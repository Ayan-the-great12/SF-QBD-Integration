({
    doInit: function (component, event, helper) {
        try {

        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleActiveTab: function (component, event, helper) {
        var tab = event.getSource();
        tab = tab.get('v.id');
        component.set('v.ChieldActiveTab', tab);
        helper.clearAllFields(component, event);
    },
    checkRoutLength: function (component, event, helper) {
        var val = component.get('v.accRoutNumber');
        if (val.length > 9) {
            component.set('v.accRoutNumber', val.substring(0, 9));
        }
        var activeTab = component.get('v.ChieldActiveTab');
        if (activeTab == 'savedACH') {
            var a = component.get('c.validateFormXC');
            $A.enqueueAction(a);
        } else if (activeTab == 'addNewACH') {
            var a = component.get('c.validateFormACH');
            $A.enqueueAction(a);
        }
    },
    checkSendReceiptTo: function (component, event, helper) {
        var checkbox = event.getSource().get("v.value");
        var activeTab = component.get('v.ChieldActiveTab');
        if (activeTab == 'savedACH') {
            if (checkbox) {
                let email = component.get('v.CustomCustDetail').Ebiz_C__EBizCharge_Email__c;
                component.set('v.SendReceiptToSA', true);
                component.set('v.addEmailsSA', email);
                var emailString = component.get('v.addEmailsSA');
                if (emailString != null && emailString != '') {
                    var a = component.get('c.validateFormSA');
                    $A.enqueueAction(a);
                } else {
                    component.set('v.disableSubmitBtn', true);
                }
            } else {
                component.set('v.SendReceiptToSA', false);
                component.set('v.addEmailsSA', '');
                var a = component.get('c.validateFormSA');
                $A.enqueueAction(a);
            }

        } else if (activeTab == 'addNewACH') {
            if (checkbox) {
                let email = component.get('v.CustomCustDetail').Ebiz_C__EBizCharge_Email__c;
                component.set('v.SendReceiptTo', true);
                component.set('v.addEmails', email);
                var emailString = component.get('v.addEmails');
                if (emailString != null && emailString != '') {
                    var a = component.get('c.validateFormACH');
                    $A.enqueueAction(a);
                } else {
                    component.set('v.disableSubmitBtn', true);
                }
            } else {
                component.set('v.SendReceiptTo', false);
                component.set('v.addEmails', '');
                var a = component.get('c.validateFormACH');
                $A.enqueueAction(a);
            }

        }
    },
    checksaveACH: function (component, event, helper) {
        var checkbox = event.getSource().get("v.value");
        if (checkbox == true) {
            component.set('v.saveACH', true);
        } else {
            component.set('v.saveACH', false);
        }
        var activeTab = component.get('v.ChieldActiveTab');
        if (activeTab == 'savedACH') {
            var a = component.get('c.validateFormSA');
            $A.enqueueAction(a);
        } else if (activeTab == 'addNewACH') {
            var a = component.get('c.validateFormACH');
            $A.enqueueAction(a);
        }
    },
    validateFormSA: function (component, event, helper) {
        var commentForm = component.find('req-fieldSA'),
            valid;
        var allValid = commentForm.get("v.validity").valid;
        var emailString = component.get('v.addEmailsSA');
        var sendReceipt = component.get('v.SendReceiptToSA');
        if (allValid) {
            if (sendReceipt && (emailString != null && emailString != '')) {
                var pps = component.get('v.pps');
                if (pps != null) {
                    component.set('v.disableSubmitBtn', false);
                    helper.saveInputsSA(component, event);
                } else {
                    component.set('v.disableSubmitBtn', true);
                }
            } else if (!sendReceipt) {
                var pps = component.get('v.pps');
                if (pps != null) {
                    component.set('v.disableSubmitBtn', false);
                    helper.saveInputsSA(component, event);
                } else {
                    component.set('v.disableSubmitBtn', true);
                }
            }
        } else {
            component.set('v.disableSubmitBtn', true);
        }
    },
    validateFormACH: function (component, event, helper) {
        var allValid = component.find('req-fields').reduce(function (validSoFar, inputCmp) {
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        var emailString = component.get('v.addEmails');
        var sendReceipt = component.get('v.SendReceiptTo');
        if (allValid) {
            if (sendReceipt && (emailString != null && emailString != '')) {
                var pps = component.get('v.pps');
                if (pps != null) {
                    component.set('v.disableSubmitBtn', false);
                    helper.saveInputsAA(component, event);
                } else {
                    component.set('v.disableSubmitBtn', true);
                }
            } else if (!sendReceipt) {
                var pps = component.get('v.pps');
                if (pps != null) {
                    component.set('v.disableSubmitBtn', false);
                    helper.saveInputsAA(component, event);
                } else {
                    component.set('v.disableSubmitBtn', true);
                }
            }
        } else {
            component.set('v.disableSubmitBtn', true);
        }
    },
    validateBankEmail: function (component, event, helper) {
        try {
            var emailString = component.get('v.addEmailsSA');
            if (emailString != null && emailString != '') {
                var a = component.get('c.validateFormSA');
                $A.enqueueAction(a);
            } else {
                component.set('v.disableSubmitBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateAddBankEmail: function (component, event, helper) {
        try {
            var emailString = component.get('v.addEmails');
            if (emailString != null && emailString != '') {
                var a = component.get('c.validateFormACH');
                $A.enqueueAction(a);
            } else {
                component.set('v.disableSubmitBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    clearFields: function (component, event, helper) {
        helper.clearAllFields(component, event);
    }
})