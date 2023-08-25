({
    getReceivedPayments: function(component, event) {
        var CurrentAccountsCount = component.get("v.CurrentAccountsCount");
        var FromDate = component.get('v.FromDate');
        var ToDate = component.get('v.ToDate');
        var action = component.get("c.getReceivedPaymentsApxc");
        action.setParams({
            sDate: FromDate,
            eDate: ToDate,
            webformType: 'Payment Method'
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var receivedPayment = a.getReturnValue();
                if (receivedPayment != null && receivedPayment != undefined) {
                    var dataLength = receivedPayment.length;
                    var subset = [];
                    var dataList = receivedPayment.map(function(rowData) {
                        rowData.AccountHyperUrl = '/' + rowData.CustomerId;
                        rowData.Last4 = 'ending in ' + rowData.Last4;
                        if (rowData.PaymentMethod == 'Visa') {
                            rowData.cardClass = 'visa';
                        } else if (rowData.PaymentMethod == 'MasterCard') {
                            rowData.cardClass = 'master';
                        } else if (rowData.PaymentMethod == 'American Express') {
                            rowData.cardClass = 'american';
                        } else if (rowData.PaymentMethod == 'Discover') {
                            rowData.cardClass = 'discover';
                        } else if (rowData.PaymentMethod == 'eCheck') {
                            rowData.cardClass = 'eCheck';
                        }
                        return rowData;
                    });
                    component.set("v.receivedPayList", receivedPayment);
                    component.set("v.FromDate", FromDate);
                    component.set("v.ToDate", ToDate);
                    var i;
                    var maxGridLimit = component.get("v.maxGridLimit");
                    if (dataLength <= maxGridLimit) {
                        component.set('v.disableNextBtn', true);
                    } else {
                        component.set('v.disableNextBtn', false);
                    }
                    maxGridLimit = (maxGridLimit > dataLength) ? dataLength : maxGridLimit;
                    for (i = 0; i < maxGridLimit; i++) {
                        subset.push(receivedPayment[i]);
                    }
                    component.set("v.ReceivedPayments", subset);
                    component.set('v.allData', subset);
                    component.set("v.currentIndex", maxGridLimit);
                    component.set("v.CurrentAccountsCount", CurrentAccountsCount + dataLength);
                    component.set("v.FromDate", FromDate);
                    component.set("v.ToDate", ToDate);
                    component.set('v.Spinner', false);
                } else {
                    component.set("v.receivedPayList", []);
                    component.set('v.Spinner', false);
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToastMsg(errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    sortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.ReceivedPayments");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'PaymentRequestDateTime' || fieldName == 'CustomerId') {
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
        component.set("v.ReceivedPayments", data);
    },
    convertArrayOfObjectsToCSV: function(component, objectRecords) {
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        columnDivider = ',';
        lineDivider = '\n';
        keys = ['TYPE', 'ACCOUNT/CONTACT NAME', 'EMAIL', 'DATE & TIME ADDED', 'ADDED PAYMENT METHOD'];
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
            csvStringResult += '"' + rec.cardClass + '      ' + rec.Last4 + '"';
            csvStringResult += lineDivider;
            counter++;
        }
        return csvStringResult;
    },
    markAllPaymentsApply: function(component, event, requestPayList) {
        var maxcount = component.get("v.MaxRecords");
        var index;
        var request_count = 0;
        var success_count = 0;
        var number_of_records = requestPayList.length;
        if (requestPayList.length > 0) {
            if (requestPayList.length > maxcount) {
                component.set('v.Spinner', false);
                component.set('v.isActive', true);
                return;
            }
            for (index = 0; index < number_of_records; index++) {
                var PaymentInternalId = requestPayList[index].PaymentInternalId;
                var action = component.get("c.markPaymentAsApplied");
                action.setParams({
                    PaymentInternalId: PaymentInternalId,
                });
                action.setCallback(this, function(response) {
                    request_count++;
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var res = response.getReturnValue();
                        if (res == 'Success') {
                            success_count++;
                        }
                    } else {
                        this.showToast('Something went wrong, Please try again!', 'Error');
                    }
                    if (request_count == number_of_records) {
                        component.set("v.Spinner", false);
                        component.set('v.disableBtns', true);
                        component.set('v.NoOfSelectedRecords', 0);
                        component.set("v.ReceivedPayments", []);
                        this.getReceivedPayments(component, event);
                        if (request_count == success_count) {
                            this.showToast('Payments Successfully Applied!', 'Success');
                        } else {
                            this.showToast(res, 'Error');
                        }
                    }
                });
                $A.enqueueAction(action);
            }
        } else {
            component.set("v.Spinner", false);
            this.showToast('Please select atleast one Email Pay to Apply!', 'Error');
        }
    },
    removeReceivedRecords: function(component, event) {
        var recievedPayList = component.get("v.SelectedreceivedPayList");
        var action = component.get("c.removeRecievedPaymentsApxc");
        action.setParams({
            recievedPayList: recievedPayList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retValue = response.getReturnValue();
                component.set("v.receivedPayList", retValue);
                this.showToastMsg('Added payment method(s) successfully removed from list!', 'Success');
                component.set("v.ReceivedPayments", []);
                this.getReceivedPayments(component, event);
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