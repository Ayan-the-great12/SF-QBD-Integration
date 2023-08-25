({
    searchPending: function(component, event) {
        var FromDate = component.get('v.FromDate');
        var ToDate = component.get('v.ToDate');
        var CurrentAccountsCount = component.get("v.CurrentAccountsCount");
        var action = component.get("c.getPendingRequestPaymentsApxc");
        action.setParams({
            sDate: FromDate,
            eDate: ToDate,
            webformType: 'Payment Method'
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue != null && retValue != undefined && retValue.PendingList != null && retValue.PendingList != undefined) {
                    var pendingList = retValue.PendingList;
                    var dataLength = pendingList.length;
                    var subset = [];
                    var filteredPendingList = retValue.PendingList.filter(function(order) {
                        return order.AmountDue > 0.5;
                    });
                    var dataList = filteredPendingList.map(function(rowData) {
                        rowData.OrderHyperUrl = '/' + rowData.OrderId;
                        rowData.AccountHyperUrl = '/' + rowData.CustomerId;
                        return rowData;
                    });
                    component.set("v.pendingPayList", retValue.PendingList);
                    var i;
                    var maxGridLimit = component.get("v.maxGridLimit");
                    if (dataLength <= maxGridLimit) {
                        component.set('v.disableNextBtn', true);
                    } else {
                        component.set('v.disableNextBtn', false);
                    }
                    maxGridLimit = (maxGridLimit > dataLength) ? dataLength : maxGridLimit;
                    for (i = 0; i < maxGridLimit; i++) {
                        subset.push(pendingList[i]);
                    }
                    component.set("v.PendingPayments", subset);
                    component.set('v.allData', subset);
                    component.set("v.currentIndex", maxGridLimit);
                    component.set("v.CurrentAccountsCount", CurrentAccountsCount + dataLength);
                    component.set("v.FromDate", FromDate);
                    component.set("v.ToDate", ToDate);
                } else {
                    component.set("v.pendingPayList", []);
                }
                component.set('v.Spinner', false);
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToastMsg(errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    convertArrayOfObjectsToCSV: function(component, objectRecords) {
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        columnDivider = ',';
        lineDivider = '\n';
        keys = ['TYPE', 'ACCOUNT/CONTACT NAME', 'EMAIL', 'ORIG. DATE & TIME SENT', 'No. OF TIMES SENT'];
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        var counter = 0;
        for (var i = 0; i < objectRecords.length; i++) {
            var rec = objectRecords[i];
            csvStringResult += '"' + rec.objectName + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.accName + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.CustomerEmailAddress + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.PaymentRequestDateTime + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.ResendCount + '"';
            csvStringResult += lineDivider;
            counter++;
        }
        return csvStringResult;
    },
    sortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.PendingPayments");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'PaymentRequestDateTime' || fieldName == 'CustomerId' || fieldName == 'ResendCount') {
            data.sort(function(a, b) {
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a > b) - (b > a));
            });
        } else if (fieldName == 'CustomerName') {
            var key = function(a) {
                return a['accName'];
            }
            data.sort(function(a, b) {
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a > b) - (b > a));
            });
        } else {
            data.sort(function(a, b) {
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a > b) - (b > a));
            });
        }
        component.set("v.PendingPayments", data);
    },
    SendRequestsNow: function(component, event) {
        var pendingPayList = component.get("v.SelectedpendingPayList");
        var action = component.get("c.resendPendingPaymentApx");
        action.setParams({
            pendingPayList: pendingPayList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retValue = response.getReturnValue();
                component.set('v.Spinner', false);
                component.set('v.isOpen', false);
                var selected = component.get("v.NoOfSelectedRecords");
                this.showToastMsg(selected + ' request(s) have successfully been resent!', 'Success');
                $A.get('e.force:refreshView').fire();
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToastMsg(errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    removePendingRecords: function(component, event) {
        var pendingPayList = component.get("v.SelectedpendingPayList");
        var action = component.get("c.removePendingPaymentsApxc");
        action.setParams({
            pendingPayList: pendingPayList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retValue = response.getReturnValue();
                component.set("v.pendingPayList", retValue);
                this.showToastMsg('Pending request(s) removed from list successfully!', 'Success');
                component.set("v.PendingPayments", []);
                this.searchPending(component, event);
            } else {
                var errors = response.getError();
                this.showToastMsg(errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    showToastMsg: function(msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            duration: ' 5000',
            mode: 'dismissible',
            message: msg,
            type: type,
            title: type + "!",
        });
        toastEvent.fire();
    },
    showToast: function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: type + '!',
            message: message,
            duration: ' 5000',
            key: type + '_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
})