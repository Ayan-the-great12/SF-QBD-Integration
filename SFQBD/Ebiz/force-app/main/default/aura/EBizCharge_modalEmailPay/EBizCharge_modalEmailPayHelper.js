({
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
                component.set("v.UpdatedpendingPayList", retValue);
                component.set('v.Spinner',false);
                component.set('v.isOpen',false);
                this.showToastMsg('Pending request(s) removed from list successfully!','Success');
                $A.get('e.force:refreshView').fire();
            }else{
                var errors = response.getError();
                component.set('v.Spinner',false);
                $A.get('e.force:refreshView').fire();
                this.showToastMsg(errors[0].message+'!','Error');
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
                component.set('v.Spinner', false);
                component.set('v.isOpen', false);
                this.showToastMsg('Email reminders sent successfully!', 'Success');
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
            duration: ' 5000',
            mode: 'dismissible',
            message: msg,
            type: type,
            title: type + "!",
        });
        toastEvent.fire();
    },
})