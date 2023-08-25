({
    getReceivedPayments: function(component, event) {
        var accountId = component.get('v.selectedLookUpAccRecord.Id');
        var fromDate = component.get('v.fromDate');
        var toDate = component.get('v.toDate');
        if (fromDate == null && toDate == null) {
            var dt = new Date();
            fromDate = $A.localizationService.formatDate(new Date(dt.getFullYear(), dt.getMonth(), 1), "YYYY-MM-DD");
            toDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        }
        component.set('v.fromDate', fromDate);
        component.set('v.toDate', toDate);
        var action = component.get("c.getReceivedPaymentsApxc");
        action.setParams({
            AccountId: accountId,
            fromDate: fromDate,
            toDate: toDate
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var oRes = response.getReturnValue();
                component.set("v.Spinner", false);
                if (oRes.length > 0) {
                    var dataList = oRes.map(function(rowData) {
                        if ($A.util.isEmpty(rowData.rrCustomerName)) {
                            rowData.RecurringHyperUrl = '';
                        }
                        rowData.OrderHyperUrl = '/' + rowData.OrderId;
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
                    component.set("v.receivedPayList", oRes);
                    component.set('v.sortAsc', true);
                    component.set('v.sortField', 'RefNum');
                } else {
                    component.set("v.receivedPayList", null);
                }
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    markPaymentApply: function(component, event, arr) {
        var OrderId = arr.OrderId;
        var RefNum = arr.RefNum;
        var PaymentInternalId = arr.PaymentInternalId;
        var InvoiceNumber = arr.InvoiceNumber;
        var Amount = arr.PaidAmount;
        var action = component.get("c.markPaymentAsApplied");
        action.setParams({
            RefNum: RefNum,
            PaymentInternalId: PaymentInternalId,
            InvoiceNumber: InvoiceNumber,
            OrderId: OrderId,
            Amount: parseFloat(Amount)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Spinner", false);
                var res = response.getReturnValue();
                if (res == 'Success') {
                    this.showToast('Payment Successfully Marked!', 'Success');
                    this.getReceivedPayments(component, event);
                } else {
                    this.showToast(res, 'Error');
                }
            } else {
                this.showToast('Something went wrong, Please try again!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    removeReceivedRecords: function(component, event) {
        var recievedEmailList = component.get("v.SelectedRecords");
        var action = component.get("c.removeRecievedPaymentsApxc");
        action.setParams({
            recievedEmailList: recievedEmailList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retValue = response.getReturnValue();
                component.set("v.receivedPayList", retValue);
                this.showToastMsg('Received requests removed from list successfully!', 'Success');
                component.set('v.Spinner', false);
                component.set("v.receivedPayList", []);
                this.getReceivedPayments(component, event);
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToastMsg(errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    showToastMsg: function(msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            duration: ' 4000',
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
    markAllPaymentsApply: function(component, event, emailPayList) {
        var maxcount = component.get("v.MaxRecords");
        var index;
        var request_count = 0;
        var success_count = 0;
        var number_of_records = emailPayList.length;
        if (emailPayList.length > 0) {
            if (emailPayList.length > maxcount) {
                component.set('v.Spinner', false);
                component.set('v.isActive', true);
                return;
            }
            for (index = 0; index < number_of_records; index++) {
                var OrderId = emailPayList[index].OrderId;
                var RefNum = emailPayList[index].RefNum;
                var PaymentInternalId = emailPayList[index].PaymentInternalId;
                var InvoiceNumber = emailPayList[index].InvoiceNumber;
                var Amount = emailPayList[index].PaidAmount;
                var action = component.get("c.markPaymentAsApplied");
                action.setParams({
                    RefNum: RefNum,
                    PaymentInternalId: PaymentInternalId,
                    InvoiceNumber: InvoiceNumber,
                    OrderId: OrderId,
                    Amount: parseFloat(Amount)
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
                        component.find("receivedPayList").set("v.selectedRows", []);
                        component.set('v.disableApplyButton', true);
                        component.set('v.selectedRowsCount', 0);
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
    sortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.receivedPayList");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'AuthCode' || fieldName == 'PaidAmount') {
            data.sort(function(a, b) {
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a > b) - (b > a));
            });
        } else {
            data.sort(function(a, b) {
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a > b) - (b > a));
            });
        }
        component.set("v.receivedPayList", data);
    },
    renderPage: function(component) {
        var records = component.get("v.receivedPayList"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = records.slice((pageNumber - 1) * 1000, pageNumber * 1000);
        component.set("v.receivedPayList", pageRecords);
    },
    getRowActions: function(cmp, row, doneCallback) {
        var actions = [];
        actions.push({
            'label': 'Apply Payment',
            'iconName': 'action:submit_for_approval',
            'name': 'Apply'
        });
        setTimeout($A.getCallback(function() {
            doneCallback(actions);
        }), 200);
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