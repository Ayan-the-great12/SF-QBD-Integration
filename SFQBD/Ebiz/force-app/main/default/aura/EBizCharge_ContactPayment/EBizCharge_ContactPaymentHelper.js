({
    submitExistCardForm: function(component, event, helper) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var pby = component.get('v.payByCardInfo');
        var saveWithXC = {};
        saveWithXC.ConId = component.get("v.conDetail.Id");
        saveWithXC.ConExternalId = component.get("v.conDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c");
        saveWithXC.ConAmount = parseFloat(component.get('v.conDetail.Ebiz_C__EBizCharge_Contact_Amount__c '));
        saveWithXC.ConTax = parseFloat(component.get('v.conDetail.Ebiz_C__EBizCharge_Contact_Tax__c '));
        var Amount = parseFloat(component.get('v.Amount'));
        if (!Amount) {
            this.showToast('Amount is required field!', 'Error');
            component.set('v.Spinner', false);
            return;
        }
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount);
            Tax = parseFloat(0.0);
        }
        saveWithXC.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        saveWithXC.Tax = parseFloat(Tax);
        saveWithXC.TaxAction = TaxAction;
        saveWithXC.PaymentTotal = component.get('v.PaymentTotal');
        saveWithXC.selectedCardId = pby.selectedCardXC;
        saveWithXC.cvcNo = pby.cvcXC;
        saveWithXC.SendReceiptTo = pby.SendReceiptToXC;
        saveWithXC.addEmails = pby.addEmailsXC;
        saveWithXC.isRecurring = false;
        saveWithXC.OrderId = '00000';
        saveWithXC.OrderNo = '00000';
        saveWithXC.Terminal = 'Contact';
        var action = component.get("c.processPaymentWithXCApxc");
        action.setParams({
            savedCardJson: JSON.stringify(saveWithXC)
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.Spinner', false);
                    this.showToast('Payment processed successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    this.clearAllFields(component, event, 'CC');
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    this.showToast(retValue, 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong, please refresh the page and try again!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    submitAddNewCardForm: function(component, event, helper) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var pby = component.get('v.payByCardInfo');
        var addNewCard = {};
        addNewCard.selectedCardId = '1';
        addNewCard.ConId = component.get("v.conDetail.Id");
        addNewCard.ConExternalId = component.get("v.conDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c");
        addNewCard.ConAmount = parseFloat(component.get('v.conDetail.Ebiz_C__EBizCharge_Contact_Amount__c '));
        addNewCard.ConTax = parseFloat(component.get('v.conDetail.Ebiz_C__EBizCharge_Contact_Tax__c '));
        var Amount = parseFloat(component.get('v.Amount'));
        if (!Amount) {
            this.showToast('Amount is required field!', 'Error');
            component.set('v.Spinner', false);
            return;
        }
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount);
            Tax = parseFloat(0.0);
        }
        addNewCard.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        addNewCard.Tax = parseFloat(Tax);
        addNewCard.TaxAction = TaxAction;
        addNewCard.PaymentTotal = component.get('v.PaymentTotal');
        addNewCard.CardNumber = pby.CardNumber;
        addNewCard.expiryMonth = pby.expiryMonth;
        addNewCard.expiryYear = pby.expiryYear;
        addNewCard.CVCNumber = pby.CVCNumber;
        addNewCard.ZipCode = pby.ZipCode;
        addNewCard.BillingAddress = pby.BillingAddress;
        addNewCard.CardHolderName = pby.CardHolderName;
        addNewCard.saveCard = pby.saveCard;
        addNewCard.SendReceiptTo = pby.SendReceiptTo;
        addNewCard.addEmails = pby.addEmails;
        addNewCard.MethodName = pby.MethodName;
        addNewCard.Terminal = 'Contact';
        addNewCard.isAVSCheck = component.get('v.isAVSCheck');
        addNewCard.isRecurring = false;
        addNewCard.OrderId = '00000';
        addNewCard.OrderNo = '00000';
        addNewCard.isAVSCheck = component.get('v.isAVSCheck');
        addNewCard.resResultCode = component.get("v.resResultCode");
        addNewCard.paymentMethodIDVar = component.get("v.paymentMethodIDVar");
        addNewCard.resError = component.get("v.resError");
        addNewCard.avsRefNum = component.get("v.avsRefNum");
        var action = component.get("c.processPaymentWithNCApxc");
        action.setParams({
            addNewCardJSON: JSON.stringify(addNewCard)
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.Spinner', false);
                    this.showToast('Payment processed successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    this.clearAllFields(component, event, 'CC');
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    var arr = retValue.split('@');
                    var AVSCheck = arr[0];
                    var AVSWarnings = arr[1];
                    if (AVSWarnings == 'NoAVSWarnings') {
                        component.set('v.Spinner', false);
                        this.showToast('AVS is not enabled, please contact support to enable AVS settings.', 'Error');
                    } else {
                        if (AVSCheck == 'AVSCheck') {
                            component.set('v.avsCheckModal', true);
                            component.set('v.avsRefNum', arr[1]);
                            component.set('v.avsCardCode', arr[2]);
                            component.set('v.avsAddress', arr[3]);
                            component.set('v.avsZipCode', arr[4]);
                            component.set('v.resResultCode', arr[5]);
                            component.set('v.paymentMethodIDVar', arr[6]);
                            component.set('v.resError', arr[7]);
                        } else {
                            component.set('v.Spinner', false);
                            this.showToast(retValue, 'Error');
                        }
                        component.set('v.avsCheckModalHeader', 'Security Mismatch');
                        component.set('v.avsCheckAction', 'Mismatch');
                    }
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    submitSavedACHForm: function(component, event) {
        var pby = component.get('v.payByACHInfo');
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var savedACH = {};
        savedACH.ConId = component.get("v.conDetail.Id");
        savedACH.ConExternalId = component.get("v.conDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c");
        savedACH.ConAmount = parseFloat(component.get('v.conDetail.Ebiz_C__EBizCharge_Contact_Amount__c '))
        savedACH.ConTax = parseFloat(component.get('v.conDetail.Ebiz_C__EBizCharge_Contact_Tax__c '))
        var Amount = parseFloat(component.get('v.Amount'));
        if (!Amount) {
            this.showToast('Amount is required field!', 'Error');
            component.set('v.Spinner', false);
            return;
        }
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount);
            Tax = parseFloat(0.0);
        }
        savedACH.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        savedACH.Tax = parseFloat(Tax);
        savedACH.TaxAction = TaxAction;
        savedACH.PaymentTotal = component.get('v.PaymentTotal');
        savedACH.selectedACHId = pby.selectedACHId;
        savedACH.SendReceiptTo = pby.SendReceiptTo;
        savedACH.addEmails = pby.addEmails;
        savedACH.isRecurring = false;
        savedACH.OrderId = '00000';
        savedACH.OrderNo = '00000';
        savedACH.Terminal = 'Contact';
        var action = component.get("c.procesPaymentWithSavedACHApxc");
        action.setParams({
            savedACHJSON: JSON.stringify(savedACH)
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.Spinner', false);
                    this.showToast('Payment processed successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    this.clearAllFields(component, event, 'ACH');
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    this.showToast(retValue, 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong, please refresh the page and try again!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    submitAddNewACHForm: function(component, event) {
        var pby = component.get('v.payByACHInfo');
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var addNewACH = {};
        addNewACH.ConId = component.get("v.conDetail.Id");
        addNewACH.ConExternalId = component.get("v.conDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c");
        addNewACH.ConAmount = parseFloat(component.get('v.conDetail.Ebiz_C__EBizCharge_Contact_Amount__c '));
        addNewACH.ConTax = parseFloat(component.get('v.conDetail.Ebiz_C__EBizCharge_Contact_Tax__c '));
        var Amount = parseFloat(component.get('v.Amount'));
        if (!Amount) {
            this.showToast('Amount is required field!', 'Error');
            component.set('v.Spinner', false);
            return;
        }
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount);
            Tax = parseFloat(0.0);
        }
        addNewACH.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        addNewACH.Tax = parseFloat(Tax);
        addNewACH.TaxAction = TaxAction;
        addNewACH.PaymentTotal = component.get('v.PaymentTotal');
        addNewACH.MethodName = pby.MethodName;
        addNewACH.accHolderName = pby.accHolderName;
        addNewACH.accNumber = pby.accNumber;
        addNewACH.accRoutNumber = pby.accRoutNumber;
        addNewACH.accType = pby.accType;
        addNewACH.saveACH = pby.saveACH;
        addNewACH.SendReceiptTo = pby.SendReceiptTo;
        addNewACH.addEmails = pby.addEmails;
        addNewACH.isRecurring = false;
        addNewACH.Terminal = 'Contact';
        addNewACH.OrderId = '00000';
        addNewACH.OrderNo = '00000';
        var action = component.get("c.processPaymentNewACHApxc");
        action.setParams({
            addNewACHJSON: JSON.stringify(addNewACH),
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.Spinner', false);
                    this.showToast('Payment processed successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    this.clearAllFields(component, event, 'ACH');
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    this.showToast(retValue, 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong, please refresh the page and try again!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    voidTransaction: function(component, event) {
        var avsRefNum = component.get('v.avsRefNum');
        var action = component.get('c.invokeTransactionVoidApxc');
        action.setParams({
            avsRefNum: avsRefNum
        });
        action.setCallback(this, function(a) {
            component.set('v.Spinner', false);
            if (a.getState() === "SUCCESS") {
                component.set("v.avsCheckModal", false);
                this.showToast('Payment voided successfully!', 'Success');
                window.location.reload(true);
            } else {
                component.set("v.avsCheckModal", false);
                this.showToast('Something went wrong to void the payment!', 'Error');
                window.location.reload(true);
            }
        });
        $A.enqueueAction(action);
    },
    voidAVSTransaction: function(component, event) {
        var avsRefNum = component.get('v.avsRefNum');
        var action = component.get('c.invokeTransactionVoidApxc');
        action.setParams({
            avsRefNum: avsRefNum
        });
        action.setCallback(this, function(a) {
            component.set('v.Spinner', false);
            if (a.getState() === "SUCCESS") {
                component.set("v.avsCheckModal", false);
                window.location.reload(true);
            } else {
                component.set("v.avsCheckModal", false);
                window.location.reload(true);
            }
        });
        $A.enqueueAction(action);
    },
    voidTransactionWithoutReload: function(component, event) {
        var avsRefNum = component.get('v.avsRefNum');
        var action = component.get('c.invokeTransactionVoidApxc');
        action.setParams({
            avsRefNum: avsRefNum
        });
        action.setCallback(this, function(a) {
            component.set('v.Spinner', false);
            component.set("v.avsCheckModal", false);
        });
        $A.enqueueAction(action);
    },
    clearAllFields: function(component, event, PayBy) {
        component.set('v.disableSubmitBtn', true);
        component.set('v.Amount', 0);
        component.set('v.Tax', 0);
        component.set('v.PaymentTotal', 0);
        if (PayBy == 'ACH') {
            var childComp = component.find('UseCmpPayByACH');
            childComp.callChildFields();
        } else {
            var childComp = component.find('UseCmpPayByCard');
            childComp.callChildFields();
        }
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