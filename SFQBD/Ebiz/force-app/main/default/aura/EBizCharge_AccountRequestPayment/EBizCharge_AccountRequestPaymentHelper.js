({
    loadEmailTemplates: function(component, event) {
        var action = component.get('c.getEmailTemplatesApxc');
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var temps = [];
                var res = response.getReturnValue();
                component.set("v.emailTemplist", res);
            } else {
                this.showToast('Something went wrong!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    addPaymentMethodReq: function(component, event) {
        var sendReq = {};
        sendReq.TemplateId = component.get('v.Template');
        sendReq.Subject = component.get('v.Subject');
        sendReq.fromEmail = component.get('v.fromEmail');
        sendReq.toEmail = component.get('v.toEmail');
        sendReq.Notes = component.get('v.Notes');
        var action = component.get("c.addPaymentMehtodReqApxc");
        action.setParams({
            sendReqJSON: JSON.stringify(sendReq),
            AccountId: component.get('v.recDetail.Qbd_Customer_Id'),
            AccountName: component.get('v.recDetail.accName')
        });
        action.setCallback(this, function(a) {
            if (a.getState() == 'SUCCESS') {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.disableSubmitBtn', true);
                    component.set('v.Subject', '');
                    component.set('v.fromEmail', '');
                    component.set('v.toEmail', '');
                    component.set('v.disableSubmitBtn', true);
                    this.showToast('Add payment method request successfully sent!', 'Success');
                    this.closeModel(component, event);
                    component.set('v.Spinner', false);
                } else {
                    this.showToast('There was an error to send email add payment method request!', 'Error');
                }
            } else {
                this.showToast('Something went wrong to send email add payment method request!', 'Error');
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    closeModel: function(component, event) {
        try {
            component.set("v.isOpen", false);
            $A.get('e.force:refreshView').fire();
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    showToast: function(msg, type) {
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