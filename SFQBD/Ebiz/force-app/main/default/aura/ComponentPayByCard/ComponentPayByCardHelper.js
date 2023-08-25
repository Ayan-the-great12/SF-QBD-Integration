({
    saveInputsXC: function(component, event) {
        var saveCardsExtendedList = component.get("v.saveCardsExtendedList");
        var tab = component.get('v.ChieldActiveTab');
        var saveWithXC = {};
        saveWithXC.payBy = tab;
        saveWithXC.selectedCardXC = component.get('v.selectedCardXC');
        saveWithXC.cvcXC = component.get('v.cvcXC');
        saveWithXC.addEmailsXC = component.get('v.addEmailsXC');
        saveWithXC.SendReceiptToXC = component.get('v.SendReceiptToXC');
        for (var i = 0; i < saveCardsExtendedList.length; i++) {
            if (saveCardsExtendedList[i].MethodID == saveWithXC.selectedCardXC) {
                saveWithXC.expiryMonth = saveCardsExtendedList[i].CardExpMonth;
                saveWithXC.expiryYear = saveCardsExtendedList[i].CardExpYear;
                break;
            }
        }
        component.set('v.payByCardInfo', saveWithXC);
    },
    getAccountDetail: function(component, event) {
        var record = component.get('v.recordId');
        var obj = component.get('v.ObjectName');
        var acc = component.get("v.selectedLookUpAccRecord");
        if (acc != null) {
            record = acc.Id;
        }
        if (record != null) {
            var action = component.get('c.getDetailApxc');
            action.setParams({
                "recordId": record,
                "ObjectName": obj,
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var resInfo = response.getReturnValue();
                if (resInfo != null) {
                    if (state == "SUCCESS") {
                        if (obj == 'Opportunity' || obj == 'Order' || obj == 'Quote' || obj == 'Account' || obj == 'account' || obj == 'contact' || obj == 'Contact') {
                            var address = resInfo.Address;
                            var zipcode = resInfo.ZipCode;
                            component.set("v.BillingAddress", address);
                            component.set("v.ZipCode", zipcode);
                        }
                    } else {
                        var errors = response.getError();
                        this.showToastMsg('Something went wrong ' + errors[0].message + '!', 'Error');
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    saveInputsAC: function(component, event) {
        var tab = component.get('v.ChieldActiveTab');
        var addNewCard = {};
        addNewCard.payBy = tab;
        addNewCard.CardNumber = component.get('v.CardNumber');
        addNewCard.BillingAddress = component.get('v.BillingAddress');
        addNewCard.expiryMonth = component.get('v.expiryMonth');
        addNewCard.expiryYear = component.get('v.expiryYear');
        addNewCard.CVCNumber = component.get('v.CVCNumber');
        addNewCard.ZipCode = component.get('v.ZipCode');
        addNewCard.CardHolderName = component.get('v.CardHolderName');
        addNewCard.saveCard = component.get('v.saveCard');
        addNewCard.SendReceiptTo = component.get('v.SendReceiptTo');
        addNewCard.addEmails = component.get('v.addCardEmail');
        addNewCard.MethodName = component.get('v.MethodName');
        component.set('v.payByCardInfo', addNewCard);
    },
    clearAllFields: function(component, event) {
        component.set('v.payByCardInfo', null);
        component.set('v.disableSubmitBtn', true);
        component.set('v.SendReceiptToXC', false);
        component.set('v.selectedCardXC', null);
        component.set('v.cvcXC', null);
        component.set('v.addEmailsXC', '');
        component.set('v.CardNumber', '');
        component.set('v.expiryMonth', '');
        component.set('v.expiryYear', '');
        component.set('v.CVCNumber', '');
        component.set('v.saveCard', false);
        component.set('v.CardHolderName', '');
        component.set('v.SendReceiptTo', false);
        component.set('v.addCardEmail', '');
        component.set('v.MethodName', '');
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