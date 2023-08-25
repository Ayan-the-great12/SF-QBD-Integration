({
    saveInputsSA: function(component, event) {
        var tab = component.get('v.ChieldActiveTab');
        var savedACH = {};
        savedACH.payBy = tab;
        savedACH.selectedACHId = component.get('v.paymentMethodIdSA');
        savedACH.SendReceiptTo = component.get('v.SendReceiptToSA');
        savedACH.addEmails = component.get('v.addEmailsSA');
        component.set('v.payByACHInfo', savedACH);
    },
    saveInputsAA: function(component, event) {
        var tab = component.get('v.ChieldActiveTab');
        var addNewACH = {};
        addNewACH.payBy = tab;
        addNewACH.accHolderName = component.get('v.accHolderName');
        addNewACH.accNumber = component.get('v.accNumber');
        addNewACH.accRoutNumber = component.get('v.accRoutNumber');
        addNewACH.accType = component.get('v.accType');
        addNewACH.saveACH = component.get('v.saveACH');
        addNewACH.SendReceiptTo = component.get('v.SendReceiptTo');
        addNewACH.addEmails = component.get('v.addEmails');
        addNewACH.MethodName = component.get('v.MethodName');
        component.set('v.payByACHInfo', addNewACH);
    },
    clearAllFields: function(component, event) {
        component.set('v.disableSubmitBtn', true);
        component.set('v.paymentMethodIdSA', null);
        component.set('v.addEmailsSA', '');
        component.set('v.accHolderName', '');
        component.set('v.accNumber', '');
        component.set('v.accRoutNumber', '');
        component.set('v.accType', '');
        component.set('v.addEmails', '');
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