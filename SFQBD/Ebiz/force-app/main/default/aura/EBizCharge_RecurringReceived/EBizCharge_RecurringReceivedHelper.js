({
    getReceivedrrPayments: function(component, event) {
        var accountId = component.get('v.selectedLookUpAccRecord.Id');
        var rrFromDate = component.get('v.rrFromDate');
        var rrToDate = component.get('v.rrToDate');
        if (rrFromDate == null && rrToDate == null) {
            var dt = new Date();
            rrFromDate = $A.localizationService.formatDate(new Date(dt.getFullYear(), dt.getMonth(), 1), "YYYY-MM-DD");
            rrToDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        }
        component.set('v.rrFromDate', rrFromDate);
        component.set('v.rrToDate', rrToDate);
        var action = component.get("c.ReceivedRRPaymentsApxc");
        action.setParams({
            AccountId: accountId,
            fromDate: rrFromDate,
            toDate: rrToDate
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                component.set('v.rrReceivedPayment', records);
                var dataList = records.map(function(rowData) {
                    if ($A.util.isEmpty(rowData.rrCustomerName)) {
                        rowData.RecurringHyperUrl = '';
                    }
                    rowData.rrMaskedPMValue = 'ending in ' + rowData.rrLast4;
                    if (rowData.rrPaymentMethod == 'Visa') {
                        rowData.cardClass = 'visa';
                    } else if (rowData.rrPaymentMethod == 'MasterCard') {
                        rowData.cardClass = 'master';
                    } else if (rowData.rrPaymentMethod == 'American Express') {
                        rowData.cardClass = 'american';
                    } else if (rowData.rrPaymentMethod == 'Discover') {
                        rowData.cardClass = 'discover';
                    } else if (rowData.rrPaymentMethod == 'ACH') {
                        rowData.cardClass = 'ach';
                    }
                    return rowData;
                });
                component.set("v.Spinner", false);
                component.set('v.sortAsc', true);
                component.set('v.sortField', '');
                this.sortBy(component, "rrCustomerName");
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    markPaymentApply: function(component, event, row) {
        var AccountId = row.rrCustomerId;
        var PaymentInternalId = row.rrPaymentInternalId;
        var Amount = row.rrPaidAmount;
        var RefNumber = row.rrRefNum;
        var action = component.get("c.markRRPaymentAsApplied");
        action.setParams({
            PaymentInternalId: PaymentInternalId,
            AccountId: AccountId,
            RefNumber: RefNumber,
            Amount: parseFloat(Amount)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Spinner", false);
                var res = response.getReturnValue();
                if (res == 'Success') {
                    this.showToast('Payment Successfully Marked!', 'Success');
                    this.getReceivedrrPayments(component, event);
                } else {
                    this.showToast(res, 'Error');
                }
            } else {
                this.showToast('Something went wrong, Please try again!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    markAllPaymentsApply: function(component, event, recurringPayList) {
        var maxcount = component.get("v.MaxRecords");
        var index;
        var request_count = 0;
        var success_count = 0;
        var number_of_records = recurringPayList.length;
        if (recurringPayList.length > 0) {
            if (recurringPayList.length > maxcount) {
                component.set('v.Spinner', false);
                component.set('v.isActive', true);
                return;
            }
            for (index = 0; index < number_of_records; index++) {
                var AccountId = recurringPayList[index].rrCustomerId;
                var PaymentInternalId = recurringPayList[index].rrPaymentInternalId;
                var Amount = recurringPayList[index].rrPaidAmount;
                var RefNumber = recurringPayList[index].rrRefNum;
                var action = component.get("c.markRRPaymentAsApplied");
                action.setParams({
                    PaymentInternalId: PaymentInternalId,
                    AccountId: AccountId,
                    RefNumber: RefNumber,
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
                        component.find("rrReceivedPayment").set("v.selectedRows", []);
                        component.set('v.disableApplyButton', true);
                        component.set('v.selectedRowsCount', 0);
                        this.getReceivedrrPayments(component, event);
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
            this.showToast('Please select atleast one Recurring Payment to Apply!', 'Error');
        }
    },
    sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.rrReceivedPayment");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a, b) {
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.rrReceivedPayment", records);
        this.renderPage(component);
    },
    renderPage: function(component) {
        var records = component.get("v.rrReceivedPayment"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = records.slice((pageNumber - 1) * 1000, pageNumber * 1000);
        component.set("v.rrReceivedPayment", pageRecords);
    },
    sortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.rrReceivedPayment");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'rrPaidAmount') {
            data.sort(function(a, b) {
                var a = key(a) ? parseFloat(key(a)) : '';
                var b = key(b) ? parseFloat(key(b)) : '';
                return reverse * ((a > b) - (b > a));
            });
        } else {
            data.sort(function(a, b) {
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a > b) - (b > a));
            });
        }
        component.set("v.rrReceivedPayment", data);
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