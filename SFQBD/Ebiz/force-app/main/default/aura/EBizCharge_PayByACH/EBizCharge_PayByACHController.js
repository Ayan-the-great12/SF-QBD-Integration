({
    handleActiveTab: function(component, event, helper) {
        try {
            var tab = event.getSource();
            tab = tab.get('v.id');
            component.set('v.ActiveTab', tab);
            helper.clearForm(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    checkSendReceiptTo: function(component, event, helper) {
        try {
            var activeTab = component.get('v.ActiveTab');
            if (activeTab == 'savedACH') {
                if (component.get('v.SendReceiptToSA') == false) {
                    var Email = component.get('v.OS').accEmail;
                    component.set('v.SendReceiptToSA', true);
                    component.set('v.addEmailsSA', Email);
                } else {
                    component.set('v.SendReceiptToSA', false);
                    component.set('v.addEmailsSA', '');
                }
                var a = component.get('c.validateFormSA');
                $A.enqueueAction(a);
            } else if (activeTab == 'addNewACH') {
                if (component.get('v.SendReceiptTo') == false) {
                    component.set('v.SendReceiptTo', true);
                    var Email = component.get('v.OS').accEmail;
                    component.set('v.addEmails', Email);
                } else {
                    component.set('v.SendReceiptTo', false);
                }
                var a = component.get('c.validateFormACH');
                $A.enqueueAction(a);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    checkRoutLength: function(component, event, helper) {
        try {
            var val = component.get('v.accRoutNumber');
            if (val.length > 9) {
                component.set('v.accRoutNumber', val.substring(0, 9));
            }
            var activeTab = component.get('v.ActiveTab');
            if (activeTab == 'addNewACH') {
                var a = component.get('c.validateFormACH');
                $A.enqueueAction(a);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    checkAccountLength: function(component, event, helper) {
        try {
            var val = component.get('v.accNumber');
            var Card4Degit = '-';
            Card4Degit = val.substring(5, 9);
            component.set('v.card4Degit', Card4Degit);
            if (val.length > 9) {
                component.set('v.accNumber', val.substring(0, 16));
            }
            var a = component.get('c.validateFormACH');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    checksaveACH: function(component, event, helper) {
        try {
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
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    onChangeAChDigit: function(component, event, helper) {
        try {
            var payM = component.get('v.saveACHList');
            var selectedCard = component.get('v.paymentMethodIdSA');
            var Card4Degit = '-';
            for (var key in payM) {
                if (payM[key].key == selectedCard) {
                    var arrCard = payM[key].value.toString().split('^');
                    var str = arrCard[1];
                    Card4Degit = str.substring(5, 9);
                }
            }
            component.set('v.card4Degit', Card4Degit);
            var a = component.get('c.validateFormSA');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateFormSA: function(component, event, helper) {
        var commentForm = component.find('req-fieldSA'),
            valid;
        commentForm.showHelpMessageIfInvalid();
        var allValid = commentForm.get("v.validity").valid;
        if (allValid) {
            component.set('v.disableRRbtnSA', false);
            component.set('v.disableSubmitBtn', false);
        } else {
            component.set('v.disableRRbtnSA', true);
            component.set('v.disableSubmitBtn', true);
        }
    },
    validateFormACH: function(component, event, helper) {
        try {
            var allValid = component.find('req-fields').reduce(function(validSoFar, inputCmp) {
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
            if (allValid) {
                component.set('v.disableRRbtn', false);
                component.set('v.disableSubmitBtn', false);
            } else {
                component.set('v.disableRRbtn', true);
                component.set('v.disableSubmitBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateAndSubmitForm: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var activeTab = component.get('v.ActiveTab');
            if (activeTab == 'savedACH') {
                helper.submitSavedACHForm(component, event);
            } else if (activeTab == 'addNewACH') {
                helper.submitAddNewACHForm(component, event);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    OpenModalScheduleRR: function(component, event, helper) {
        try {
            var rrPayBy = {};
            var tab = component.get('v.ActiveTab');
            if (tab == 'savedACH') {
                rrPayBy.Tab = tab;
                rrPayBy.paymentMethodIdSA = component.get('v.paymentMethodIdSA');
                rrPayBy.SendReceiptToSA = component.get('v.SendReceiptToSA');
                rrPayBy.addEmailsSA = component.get('v.addEmailsSA');
            } else if (tab == 'addNewACH') {
                rrPayBy.Tab = tab;
                rrPayBy.accHolderName = component.get('v.accHolderName');
                rrPayBy.accNumber = component.get('v.accNumber');
                rrPayBy.accRoutNumber = component.get('v.accRoutNumber');
                rrPayBy.accType = component.get('v.accType');
                rrPayBy.saveACH = component.get('v.saveACH');
                rrPayBy.SendReceiptTo = component.get('v.SendReceiptTo');
                rrPayBy.addEmails = component.get('v.addEmails');
            }
            component.set('v.rrPayBy', rrPayBy);
            component.set('v.showModal', true);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    clearForm: function(component, event, helper) {
        try {
            helper.clearForm(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
})