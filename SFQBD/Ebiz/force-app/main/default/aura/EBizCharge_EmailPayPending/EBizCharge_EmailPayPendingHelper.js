({
    searchPending: function(component, event) {
        var FromDate = component.get('v.FromDate');
        var ToDate = component.get('v.ToDate');
        if ($A.util.isEmpty(FromDate) && $A.util.isEmpty(ToDate)) {}
        var action = component.get("c.getPendingPaymentsApxc");
        action.setParams({
            sDate: FromDate,
            eDate: ToDate
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue.PendingList != undefined) {
                    let filteredPendingList = retValue.PendingList.filter(function(order) {
                        return order.AmountDue > 0.5;
                    });
                    var dataList = filteredPendingList.map(function(rowData) {
                        rowData.OrderHyperUrl = '/' + rowData.OrderId;
                        rowData.AccountHyperUrl = '/' + rowData.CustomerId;
                        return rowData;
                    });
                    component.set("v.pendingPayList", filteredPendingList);
                    component.set("v.FromDate", retValue.fromDate);
                    component.set("v.ToDate", retValue.toDate);
                } else {
                    component.set("v.pendingPayList", []);
                    component.set("v.FromDate", retValue.fromDate);
                    component.set("v.ToDate", retValue.toDate);
                }
                component.set('v.Spinner', false);
                component.set('v.sortAsc', true);
                component.set('v.sortField', 'PaymentRequestDate');
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToastMsg(errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    removePendingRecords: function(component, event) {
        var pendingPayList = component.get("v.pendingPayList");
        var action = component.get("c.removePendingPaymentsApxc");
        action.setParams({
            pendingPayList: pendingPayList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retValue = response.getReturnValue();
                component.set("v.pendingPayList", retValue);
                component.set('v.Spinner', false);
                this.showToastMsg('Pending requests removed from list successfully!', 'Success');
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToastMsg(errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    SendEmailsNow: function(component, event) {
        var pendingPayList = component.get("v.pendingPayList");
        var action = component.get("c.resendPendingPaymentApx");
        action.setParams({
            pendingPayList: pendingPayList
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retValue = response.getReturnValue();
                for (var i = 0; i < pendingPayList.length; i++) {
                    var s = pendingPayList[i];
                    s.isSelected = false;
                }
                component.set('v.Spinner', false);
                this.showToastMsg('Email reminders sent successfully!', 'Success');
                this.searchPending(component, event);
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToastMsg(errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    getRowActions: function(cmp, row, doneCallback) {
        var actions = [];
        actions.push({
            'label': 'Resend Request',
            'iconName': 'utility:reminder',
            'name': 'SendEmailReminder'
        });
        actions.push({
            'label': 'Remove From Pending',
            'iconName': 'utility:remove_link',
            'name': 'RefundTransaction'
        });
        setTimeout($A.getCallback(function() {
            doneCallback(actions);
        }), 200);
    },
    sortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.pendingPayList");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'ResendCount' || fieldName == 'AmountDue' || fieldName == 'InvoiceAmount') {
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
        component.set("v.pendingPayList", data);
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
})