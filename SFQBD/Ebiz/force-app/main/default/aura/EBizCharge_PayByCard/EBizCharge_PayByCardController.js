({
    onRecordChange: function(component, event, helper) {
        var record = component.get("v.selectedLookUpRecord");
        if (record.Id != undefined) {
            helper.getAccountDetail(component, event);
        } else {
            component.set('v.BillingAddress', '');
        }
    },
    doinit: function(component, event, helper) {
        var month = [];
        for (var i = 1; i <= 12; i++) {
            month.push({
                key: (i < 10) ? '0' + i : i,
                value: (i < 10) ? '0' + i : i
            });
        }
        component.set('v.monthList', month);
        var year = [];
        var today = new Date();
        var todayYear = today.getFullYear();
        for (var i = 0; i <= 9; i++) {
            year.push({
                key: todayYear,
                value: todayYear
            });
            todayYear++;
        }
        component.set('v.yearList', year);
    },
    handleActiveTab: function(component, event, helper) {
        var tab = event.getSource();
        tab = tab.get('v.id');
        component.set('v.ActiveTab', tab);
        helper.clearForm(component, event);
    },
    checkLengthCVC: function(component, event, helper) {
        var activeTab = component.get('v.ActiveTab');
        if (activeTab == 'UseExistingCard') {
            var val = component.get('v.cvcXC');
            if (val.length > 4) {
                component.set('v.cvcXC', val.substring(0, 4));
            }
        } else if (activeTab == 'AddNewCard') {
            var val = component.get('v.CVCNumber');
            if (val.length > 4) {
                component.set('v.CVCNumber', val.substring(0, 4));
            }
        }
    },
    checkSendReceiptTo: function(component, event, helper) {
        var checkbox = event.getSource().get("v.value");
        var activeTab = component.get('v.ActiveTab');
        if (activeTab == 'UseExistingCard') {
            if (checkbox) {
                var OS = component.get('v.OS');
                component.set('v.SendReceiptToXC', checkbox);
                component.set('v.addEmailsXC', OS.accEmail);
            } else {
                component.set('v.SendReceiptToXC', checkbox);
                component.set('v.addEmailsXC', '');
            }
            var a = component.get('c.validateFormXC');
            $A.enqueueAction(a);
        } else if (activeTab == 'AddNewCard') {
            if (checkbox) {
                var OS = component.get('v.OS');
                component.set('v.SendReceiptTo', checkbox);
                component.set('v.addCardEmail', OS.accEmail);
            } else {
                component.set('v.SendReceiptTo', checkbox);
                component.set('v.addCardEmail', '');
            }
            var a = component.get('c.validateFormAC');
            $A.enqueueAction(a);
        }
    },
    checkSaveCard: function(component, event, helper) {
        var checkbox = event.getSource().get("v.value");
        if (checkbox == true) {
            component.set('v.saveCard', true);
        } else {
            component.set('v.saveCard', false);
        }
        var a = component.get('c.validateFormAC');
        $A.enqueueAction(a);
    },
    checkLengthCard: function(component, event, helper) {
        var val = component.get('v.CardNumber');
        var Card4Degit = '-';
        Card4Degit = val.substring(12, 16);
        component.set('v.card4Degit', Card4Degit);
        if (val.length > 16) {
            component.set('v.CardNumber', val.substring(0, 16));
        }
        var a = component.get('c.validateFormAC');
        $A.enqueueAction(a);
    },
    checkLengthZip: function(component, event, helper) {
        var val = component.get('v.ZipCode');
        if (val.length > 10) {
            component.set('v.ZipCode', val.substring(0, 10));
        }
        var a = component.get('c.validateFormAC');
        $A.enqueueAction(a);
    },
    onChangeCardDigit: function(component, event, helper) {
        var payM = component.get('v.saveCardsList');
        var selectedCard = component.get('v.selectedCardXC');
        var Card4Degit = '-';
        for (var key in payM) {
            if (payM[key].key == selectedCard) {
                var arrCard = payM[key].value.toString().split(' ');
                var str = arrCard[4];
                Card4Degit = str.toString().split(',')[0];
            }
        }
        component.set('v.card4Degit', Card4Degit);
        var activeTab = component.get('v.ActiveTab');
        if (activeTab == 'UseExistingCard') {
            var a = component.get('c.validateFormXC');
            $A.enqueueAction(a);
        } else if (activeTab == 'AddNewCard') {
            var a = component.get('c.validateFormAC');
            $A.enqueueAction(a);
        }
    },
    validateFormXC: function(component, event, helper) {
        var allValid = false;
        var selectedCardXC = component.get('v.selectedCardXC');
        if (selectedCardXC != null && selectedCardXC != '') {
            allValid = true;
        }
        if (allValid) {
            component.set('v.disableRRbtnXC', false);
            component.set('v.disableSubmitBtn', false);
        } else {
            component.set('v.disableRRbtnXC', true);
            component.set('v.disableSubmitBtn', true);
        }
    },
    validateFormAC: function(component, event, helper) {
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
    },
    validateAndSubmitForm: function(component, event, helper) {
        component.set('v.Spinner', true);
        var activeTab = component.get('v.ActiveTab');
        if (activeTab == 'UseExistingCard') {
            helper.submitExistCardForm(component, event);
        } else if (activeTab == 'AddNewCard') {
            helper.submitAddNewCardForm(component, event);
        }
    },
    clearForm: function(component, event, helper) {
        helper.clearForm(component, event);
    },
    OpenModalScheduleRR: function(component, event, helper) {
        var rrPayBy = {};
        rrPayBy.rrName = '';
        var tab = component.get('v.ActiveTab');
        if (tab == 'UseExistingCard') {
            rrPayBy.Tab = tab;
            rrPayBy.selectedCardXC = component.get('v.selectedCardXC');
            rrPayBy.cvcXC = component.get('v.cvcXC');
            rrPayBy.SendReceiptToXC = component.get('v.SendReceiptToXC');
            rrPayBy.addEmailsXC = component.get('v.addEmailsXC');
        } else if (tab == 'AddNewCard') {
            rrPayBy.Tab = tab;
            rrPayBy.CardNumber = component.get('v.CardNumber');
            rrPayBy.BillingAddress = component.get('v.BillingAddress');
            rrPayBy.expiryMonth = component.get('v.expiryMonth');
            rrPayBy.expiryYear = component.get('v.expiryYear');
            rrPayBy.CVCNumber = component.get('v.CVCNumber');
            rrPayBy.ZipCode = component.get('v.ZipCode');
            rrPayBy.MethodName = component.get('v.MethodName');
            rrPayBy.saveCard = component.get('v.saveCard');
            rrPayBy.CardHolderName = component.get('v.CardHolderName');
            rrPayBy.SendReceiptTo = component.get('v.SendReceiptTo');
            rrPayBy.addCardEmail = component.get('v.addCardEmail');
        }
        component.set('v.rrPayBy', rrPayBy);
        component.set('v.showModal', true);
    },
    RemoveSchedulePayment: function(component, event, helper) {
        component.set('v.Spinner', true);
        helper.removeScheduledPayment(component, event);
    }
})