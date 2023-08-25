({
    getDetail: function(component, event) {
        var obj = component.get('v.ObjectName');
        var action = component.get('c.getDetailApxcCustomCustomer');
        action.setParams({
            "CustomerId": component.get('v.recordId'),
            "objectName": component.get('v.ObjectName'),
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                component.set("v.CustomCustomerDetail", resInfo.CustomCustInfo);
                component.set("v.CustomCustName", resInfo.CustomCustName);
                component.set("v.CustomCustId", resInfo.CustomCustInfo.Ebiz_C__EBizCharge_CustomerId__c);
                component.set("v.ObjectLabel", resInfo.Object_label);
                component.set('v.Spinner', false);
            } else {
                component.set('v.Spinner', false);
                var errors = response.getError();
                this.showToastMsg('Something went wrong ' + errors[0].message + '!', 'Error');
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    loadEmailTemplates: function(component, event) {
        var action = component.get('c.getEmailTemplatesApxc');
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.emailTemplist", res);
            } else {
                toastEvent.setParams({
                    title: 'Error!',
                    message: 'Something went wrong!',
                    duration: ' 5000',
                    key: 'error_alt',
                    type: 'error',
                    mode: 'dismissible'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    addPaymentMethodReq: function(component, event) {
        var sendReq = {};
        sendReq.TemplateId = component.get('v.Template');
        sendReq.Subject = component.get('v.Subject');
        sendReq.FromName = component.get('v.fromName');
        sendReq.fromEmail = component.get('v.fromEmail');
        sendReq.toEmail = component.get('v.toEmail');
        sendReq.Notes = component.get('v.Notes');
        var action = component.get("c.addPaymentMehtodReqApxcCustomCustomer");
        action.setParams({
            sendReqJSON: JSON.stringify(sendReq),
            conDetail: component.get('v.CustomCustomerDetail'),
            orderId: 'Not an Order'
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state == 'SUCCESS') {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.Spinner', false);
                    this.showToast('Request Sent successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    this.clearAllFields(component, event);
                    component.set("v.isOpen", false);
                    window.location.reload();
                    $A.get('e.force:refreshView').fire();
                } else {
                    this.showToast('Error ' + retValue + '!', 'Error');
                }
            } else {
                component.set('v.Spinner', false);
                var errors = a.getError();
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    clearAllFields: function(component, event) {
        component.set('v.Subject', '');
        component.set('v.Notes', '');
        component.set('v.toEmail', '');
        component.set('v.Template', null);
        component.set('v.disableSubmitBtn', true);
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