({
    doInit: function(component, event, helper) {
        try {
            var month = [];
            for (var i = 1; i <= 12; i++) {
                month.push({
                    'label': (i < 10) ? '0' + i : '' + i,
                    'value': (i < 10) ? '0' + i : '' + i
                });
            }
            component.set('v.monthList', month);
            var today = new Date();
            var todayYear = today.getFullYear();
            var options = [];
            for (var i = 0; i <= 9; i++) {
                options.push({
                    'label': (i < 10) ? '202' + i : i,
                    'value': (i < 10) ? '202' + i : i
                });
                todayYear++;
            }
            component.set('v.yearList', options);
            var savedCards = component.get('v.saveCardsList');
            if (savedCards.length > 0) {
                component.set('v.placeholderSC', 'Select saved cards');
            } else {
                component.set('v.placeholderSC', 'No saved cards on file');
            }
            var savedCardsPH = component.get('v.placeholderSC');
            helper.getAccountDetail(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleActiveTab: function(component, event, helper) {
        try {
            var tab = event.getSource();
            tab = tab.get('v.id');
            component.set('v.ChieldActiveTab', tab);
            helper.clearAllFields(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    checkLengthCVC: function(component, event, helper) {
        try {
            var activeTab = component.get('v.ChieldActiveTab');
            if (activeTab == 'UseExistingCard') {
                var val = component.get('v.cvcXC');
                if (val.length > 4) {
                    component.set('v.cvcXC', val.substring(0, 4));
                }
                var a = component.get('c.validateFormXC');
                $A.enqueueAction(a);
            } else if (activeTab == 'AddNewCard') {
                var val = component.get('v.CVCNumber');
                if (val.length > 4) {
                    component.set('v.CVCNumber', val.substring(0, 4));
                }
                var a = component.get('c.validateFormAC');
                $A.enqueueAction(a);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    checkSendReceiptTo: function(component, event, helper) {
        var checkbox = event.getSource().get("v.value");
        var activeTab = component.get('v.ChieldActiveTab');
        if (activeTab == 'UseExistingCard') {
            if (checkbox) {
                if (component.get('v.conDetail').Email) {
                    let email = component.get('v.conDetail').Email;
                    component.set('v.addEmailsXC', email != '' ? email : '');
                }
                component.set('v.SendReceiptToXC', true);
                var emailString = component.get('v.addEmailsXC');
                if (emailString != null && emailString != '') {
                    var a = component.get('c.validateFormXC');
                    $A.enqueueAction(a);
                } else {
                    component.set('v.disableSubmitBtn', true);
                }
            } else {
                component.set('v.SendReceiptToXC', false);
                component.set('v.addEmailsXC', '');
                var a = component.get('c.validateFormXC');
            $A.enqueueAction(a);
            }
            
            
        } else if (activeTab == 'AddNewCard') {
            if (checkbox) {
                if (component.get('v.conDetail').Email) {
                    let email = component.get('v.conDetail').Email;
                    component.set('v.addCardEmail', email);
                }
                component.set('v.SendReceiptTo', true);
                var emailString = component.get('v.addCardEmail');
                if (emailString != null && emailString != '') {
                    var a = component.get('c.validateFormAC');
                    $A.enqueueAction(a);
                } else {
                    component.set('v.disableSubmitBtn', true);
                } 
            } else {
                component.set('v.SendReceiptTo', false);
                component.set('v.addCardEmail', '');
                var a = component.get('c.validateFormAC');
                $A.enqueueAction(a);
            }
        }
    },
    checkSaveCard: function(component, event, helper) {
        try {
            var checkbox = event.getSource().get("v.value");
            if (checkbox == true) {
                component.set('v.saveCard', true);
            } else {
                component.set('v.saveCard', false);
            }
            var a = component.get('c.validateFormAC');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    checkLengthCard: function(component, event, helper) {
        try {
            var val = component.get('v.CardNumber');
            if (val.length > 16) {
                component.set('v.CardNumber', val.substring(0, 16));
            }
            var a = component.get('c.validateFormAC');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    checkLengthZip: function(component, event, helper) {
        try {
            var val = component.get('v.ZipCode');
            if (val.length > 10) {
                component.set('v.ZipCode', val.substring(0, 10));
            }
            var a = component.get('c.validateFormAC');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateFormXC: function(component, event, helper) {
        try {
            var allValid = component.find('req-fieldsXC').reduce(function(validSoFar, inputCmp) {
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
            var emailString = component.get('v.addEmailsXC');
            if (emailString.includes(";")) {
                helper.showToastMsg('Please use comma instead of semicolon!', 'Error');
                component.set('v.addEmailsXC', emailString.replace(";", ""));
            }
            var sendReceipt = component.get('v.SendReceiptToXC');
            if (allValid) {
                if(sendReceipt && (emailString != null && emailString != '')){
                    var pps = component.get('v.pps');
                    if (pps != null) {
                        component.set('v.disableSubmitBtn', false);
                        helper.saveInputsXC(component, event);
                    } else {
                        component.set('v.disableSubmitBtn', true);
                    }
                }
                
                else if(!sendReceipt){
                        var pps = component.get('v.pps');
                        if (pps != null) {
                            component.set('v.disableSubmitBtn', false);
                            helper.saveInputsXC(component, event);
                        } else {
                            component.set('v.disableSubmitBtn', true);
                        }
                    }
            } else {
                component.set('v.disableSubmitBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateFormAC: function(component, event, helper) {
        try {
            var allValid = component.find('req-fields').reduce(function(validSoFar, inputCmp) {
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
            var emailString = component.get('v.addCardEmail');
            if (emailString.includes(";")) {
                helper.showToastMsg('Please use comma instead of semicolon!', 'Error');
                component.set('v.addCardEmail', emailString.replace(";", ""));
            }
            var sendReceipt = component.get('v.SendReceiptTo');
            if (allValid) {
                if(sendReceipt && (emailString != null && emailString != '')){
                    var pps = component.get('v.pps');
                    if (pps != null) {
                        component.set('v.disableSubmitBtn', false);
                        helper.saveInputsAC(component, event);
                    } else {
                        component.set('v.disableSubmitBtn', true);
                    }
                }
               else if(!sendReceipt){
                    var pps = component.get('v.pps');
                    if (pps != null) {
                        component.set('v.disableSubmitBtn', false);
                        helper.saveInputsAC(component, event);
                    } else {
                        component.set('v.disableSubmitBtn', true);
                    }
                }
            } else {
                component.set('v.disableSubmitBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateCardEmail: function(component, event, helper) {
        try {
            
            var emailString = component.get('v.addEmailsXC');
            if (emailString != null && emailString != '') {
                var a = component.get('c.validateFormXC');
                $A.enqueueAction(a);
            }
            else{
                component.set('v.disableSubmitBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateAddCardEmail: function(component, event, helper) {
        try {
            
            var emailString = component.get('v.addCardEmail');
            if (emailString != null && emailString != '') {
                var a = component.get('c.validateFormAC');
                $A.enqueueAction(a);
            }
            else{
                component.set('v.disableSubmitBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    clearFields: function(component, event, helper) {
        try {
            helper.clearAllFields(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    }
})