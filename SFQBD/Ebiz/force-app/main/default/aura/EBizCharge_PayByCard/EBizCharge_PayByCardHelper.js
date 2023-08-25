({
    helperMethod: function() {},
    getAccountDetail: function(component, event) {
        var action = component.get('c.getDetailApxc');
        var record = component.get('v.selectedLookUpRecord');
        action.setParams({
            "recordId": record.Id,
            "ObjectName": 'Account',
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                var address = resInfo.Address;
                var zipcode = resInfo.ZipCode;
                component.set("v.BillingAddress", address);
                component.set("v.ZipCode", zipcode);
            } else {
                var errors = response.getError();
                this.showToastMsg('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    submitExistCardForm: function(component, event) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var payType = Settings.Ebiz_C__Payments_Tab__c;
        var args = event.getParam("arguments");
        var OS = args.OrderSummary;
        var saveWithXC = {};
        saveWithXC.accId = OS.accId;
        saveWithXC.accExtrId = OS.accExtrId;
        saveWithXC.ordNos = OS.OrdersNo;
        var Amount = parseFloat(OS.OrderTotal);
        var Tax = parseFloat(OS.OrderTax);
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount);
            Tax = parseFloat(0.0);
        }
        saveWithXC.ordTotal = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        saveWithXC.ordTax = parseFloat(Tax);
        saveWithXC.TaxAction = TaxAction;
        saveWithXC.selectedCardId = component.get('v.selectedCardXC');
        var saveCardsExtendedList = component.get("v.saveCardsExtendedList");
        for (var i = 0; i < saveCardsExtendedList.length; i++) {
            if (saveCardsExtendedList[i].MethodID == saveWithXC.selectedCardId) {
                saveWithXC.expiryMonth = saveCardsExtendedList[i].CardExpMonth;
                saveWithXC.expiryYear = saveCardsExtendedList[i].CardExpYear;
                break;
            }
        }
        saveWithXC.cvcNo = component.get('v.cvcXC');
        saveWithXC.SendReceiptTo = component.get('v.SendReceiptToXC');
        saveWithXC.addEmails = component.get('v.addEmailsXC');
        var action = component.get("c.processPaymentWithXCApxc");
        action.setParams({
            savedCardJson: JSON.stringify(saveWithXC),
            PaymentType: payType,
            OrdersList: OS.selectedOrders,
            accountDetail: OS.accDetail
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.Spinner', false);
                    component.set('v.disabledPayBy', true);
                    this.clearForm(component, event);
                    this.updateParentComponent(component, event);
                    this.showToast('Payment processed successfully!', 'Success');
                    window.location.reload();
                } else if (retValue == 'rrScheduled') {
                    component.set('v.Spinner', false);
                    this.showToast('Recurring payment successfully scheduled!', 'Success');
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    if (retValue.startsWith('Gateway Response Error')) {
                        this.showToast(retValue, 'Error');
                    } else {
                        this.showToast('There is an exception to process the payment!', 'Error');
                    }
                }
            } else {
                component.set('v.Spinner', false);
                this.showToast('Something went wrong to process the payment!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    submitAddNewCardForm: function(component, event) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var payType = Settings.Ebiz_C__Payments_Tab__c;
        var args = event.getParam("arguments");
        var OS = args.OrderSummary;
        var addNewCard = {};
        addNewCard.accId = OS.accId;
        addNewCard.accExtrId = OS.accExtrId;
        addNewCard.ordNos = OS.OrdersNo;
        var Amount = parseFloat(OS.OrderTotal);
        var Tax = parseFloat(OS.OrderTax);
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount);
            Tax = parseFloat(0.0);
        }
        addNewCard.ordTotal = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        addNewCard.ordTax = parseFloat(Tax);
        addNewCard.TaxAction = TaxAction;
        addNewCard.CardNumber = component.get('v.CardNumber');
        addNewCard.BillingAddress = component.get('v.BillingAddress');
        addNewCard.expiryMonth = component.get('v.expiryMonth');
        addNewCard.expiryYear = component.get('v.expiryYear');
        addNewCard.CVCNumber = component.get('v.CVCNumber');
        addNewCard.ZipCode = component.get('v.ZipCode');
        addNewCard.MethodName = component.get('v.MethodName');
        addNewCard.CardHolderName = component.get('v.CardHolderName');
        addNewCard.saveCard = component.get('v.saveCard');
        addNewCard.SendReceiptTo = component.get('v.SendReceiptTo');
        addNewCard.addEmails = component.get('v.addCardEmail');
        var action = component.get("c.procesPaymentWithNCApxc");
        action.setParams({
            addNewCardJSON: JSON.stringify(addNewCard),
            PaymentType: payType,
            OrdersList: OS.selectedOrders,
            accountDetail: OS.accDetail
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.Spinner', false);
                    component.set('v.disabledPayBy', true);
                    this.clearForm(component, event);
                    this.updateParentComponent(component, event);
                    this.showToast('Payment processed successfully!', 'Success');
                    window.location.reload();
                } else if (retValue == 'rrScheduled') {
                    component.set('v.Spinner', false);
                    component.set('v.disableSubmitBtn', true);
                    this.showToast('Recurring payment successfully scheduled!', 'Success');
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    if (retValue.startsWith('Gateway Response Error')) {
                        this.showToast(retValue, 'Error');
                    } else {
                        this.showToast('There is an exception to process the payment!', 'Error');
                    }
                }
            } else {
                component.set('v.Spinner', false);
                this.showToast('Something went wrong to process the payment!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    removeScheduledPayment: function(component, event) {
        var ScheduledPaymentId = component.get('v.ScheduledPaymentId');
        var action = component.get("c.updrrPaymentScheduleStatusApxc");
        action.setParams({
            recIntenalId: ScheduledPaymentId,
            ScheduleStatus: '3'
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                component.set('v.Spinner', false);
                component.set('v.ScheduledPaymentId', '');
            } else {
                component.set('v.Spinner', false);
                this.showToast('Something went wrong to process the payment!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    clearForm: function(component, event) {
        component.set('v.card4Degit', '-');
        component.set('v.disableSubmitBtn', true);
        component.set('v.disableRRbtnXC', true);
        component.set('v.selectedCardXC', '');
        component.set('v.cvcXC', '');
        component.set('v.addEmailsXC', '');
        component.set('v.CardNumber', '');
        component.set('v.expiryMonth', '');
        component.set('v.expiryYear', '');
        component.set('v.CVCNumber', '');
        component.set('v.saveCard', false);
        component.set('v.CardHolderName', '');
        component.set('v.SendReceiptTo', false);
        component.set('v.addCardEmail', '');
    },
    updateParentComponent: function(component, event, helper) {
        var p = component.get("v.parentComp");
        p.updateOrderGrid();
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
    }
})