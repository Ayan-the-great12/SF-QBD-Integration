({
    getContactDetail: function(component, event) {
        var obj = component.get('v.ObjectName');
        var action = component.get('c.getDetailApxcContact');
        action.setParams({
            "recordId": component.get('v.recordId'),
            "ObjectName": obj,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                component.set('v.orderDetail', resInfo.ordDetail);
                component.set("v.ConDetail", resInfo.ContactInfo);
                component.set("v.ContactName", resInfo.ContactInfo.Name);
                component.set("v.ContactId", resInfo.ContactInfo.Id);
                component.set('v.Spinner', false);
            } else {
                component.set('v.Spinner', false);
                var errors = response.getError();
                this.showToast('Please refresh the page and try again!', 'Error');
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    submitExistCardForm: function(component, event, helper) {
        var obj = component.get('v.ObjectName');
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var pby = component.get('v.payByCardInfo');
        var saveWithXC = {};
        saveWithXC.payBy = pby.payBy;
        saveWithXC.AccountId = component.get("v.accDetail.Id");
        saveWithXC.AccExternalId = component.get("v.accDetail.Ebiz_C__EBizCharge_Internal_ID__c");
        saveWithXC.accAmount = component.get('v.accDetail.Ebiz_C__EBizCharge_Amount__c');
        saveWithXC.ContactId = component.get("v.ConDetail.Id");
        saveWithXC.conExternalId = component.get('v.ConDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c ');
        saveWithXC.conAmount = parseFloat(component.get('v.ConDetail.Ebiz_C__EBizCharge_Contact_Amount__c '));
        var Amount = parseFloat(component.get('v.Amount'));
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount) - parseFloat(Tax);
        }
        saveWithXC.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        saveWithXC.Tax = parseFloat(Tax);
        saveWithXC.PaymentTotal = component.get('v.PaymentTotal');
        saveWithXC.selectedCardId = pby.selectedCardXC;
        saveWithXC.cvcNo = pby.cvcXC;
        saveWithXC.SendReceiptTo = pby.SendReceiptToXC;
        saveWithXC.addEmails = pby.addEmailsXC;
        if (obj == 'Order') {
            saveWithXC.OrderId = component.get('v.orderDetail.Id');
            saveWithXC.OrderNo = component.get('v.orderDetail.OrderNumber');
        } else {
            saveWithXC.OrderId = '00000';
            saveWithXC.OrderNo = '00000';
        }
        saveWithXC.isRecurring = true;
        saveWithXC.rrPayName = component.get('v.rrPayName');
        saveWithXC.rrFrequency = component.get('v.rrFrequency');
        saveWithXC.rrNotes = component.get('v.rrNotes');
        saveWithXC.rrStartDate = component.get('v.rrStartDate');
        saveWithXC.rrEndDate = component.get('v.rrEndDate');
        saveWithXC.rrIndefinit = component.get('v.RecurIndefinitely');
        var action = component.get("c.runRecurringApxcContact");
        action.setParams({
            rrInfoJSON: JSON.stringify(saveWithXC),
            ConDetail: component.get('v.ConDetail'),
            ObjName: obj
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                var arr = [];
                arr = retValue.split('@');
                var message = arr[0];
                if (message == 'rrScheduled') {
                    component.set('v.Spinner', false);
                    this.showToast('Recurring payment scheduled successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    component.set("v.isOpen", false);
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    this.showToast(arr[1], 'Error');
                }
            } else {
                component.set('v.Spinner', false);
                this.showToast('Please refresh the page and try again!', 'Error');
                window.location.reload();
            }
        });
        $A.enqueueAction(action);
    },
    submitAddNewCardForm: function(component, event, helper) {
        var obj = component.get('v.ObjectName');
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var pby = component.get('v.payByCardInfo');
        var addNewCard = {};
        addNewCard.payBy = pby.payBy;
        addNewCard.OrderNo = '00000';
        addNewCard.ContactId = component.get("v.ConDetail.Id");
        addNewCard.conExternalId = component.get('v.ConDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c ');
        addNewCard.conAmount = parseFloat(component.get('v.ConDetail.Ebiz_C__EBizCharge_Contact_Amount__c '));
        var Amount = parseFloat(component.get('v.Amount'));
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount) - parseFloat(Tax);
        }
        addNewCard.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        addNewCard.Tax = parseFloat(Tax);
        addNewCard.PaymentTotal = component.get('v.PaymentTotal');
        if (obj == 'Order') {
            addNewCard.OrderId = component.get('v.orderDetail.Id');
            addNewCard.OrderNo = component.get('v.orderDetail.OrderNumber');
        } else {
            addNewCard.OrderId = '00000';
            addNewCard.OrderNo = '00000';
        }
        addNewCard.isRecurring = true;
        addNewCard.rrPayName = component.get('v.rrPayName');
        addNewCard.rrFrequency = component.get('v.rrFrequency');
        addNewCard.rrNotes = component.get('v.rrNotes');
        addNewCard.rrStartDate = component.get('v.rrStartDate');
        addNewCard.rrEndDate = component.get('v.rrEndDate');
        addNewCard.rrIndefinit = component.get('v.RecurIndefinitely');
        addNewCard.CardNumber = pby.CardNumber;
        addNewCard.MethodName = pby.MethodName;
        addNewCard.BillingAddress = pby.BillingAddress;
        addNewCard.expiryMonth = pby.expiryMonth;
        addNewCard.expiryYear = pby.expiryYear;
        addNewCard.CVCNumber = pby.CVCNumber;
        addNewCard.ZipCode = pby.ZipCode;
        addNewCard.CardHolderName = pby.CardHolderName;
        addNewCard.saveCard = pby.saveCard;
        addNewCard.SendReceiptTo = pby.SendReceiptTo;
        addNewCard.addEmails = pby.addEmails;
        var action = component.get("c.runRecurringApxcContact");
        action.setParams({
            rrInfoJSON: JSON.stringify(addNewCard),
            ConDetail: component.get('v.contactDetail'),
            ObjName: obj
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                var arr = [];
                arr = retValue.split('@');
                var message = arr[0];
                if (message == 'rrScheduled') {
                    component.set('v.Spinner', false);
                    this.showToast('Recurring payment scheduled successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    component.set("v.isOpen", false);
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    this.showToast(arr[1], 'Error');
                }
            } else {
                component.set('v.Spinner', false);
                this.showToast('Please refresh the page and try again!', 'Error');
                window.location.reload();
            }
        });
        $A.enqueueAction(action);
    },
    submitExistACHForm: function(component, event, helper) {
        var obj = component.get('v.ObjectName');
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var pby = component.get('v.payByACHInfo');
        var savedACH = {};
        savedACH.payBy = pby.payBy;
        savedACH.AccountId = component.get("v.accDetail.Id");
        savedACH.AccExternalId = component.get("v.accDetail.Ebiz_C__EBizCharge_Internal_ID__c");
        savedACH.accAmount = parseFloat(component.get('v.accDetail.Ebiz_C__EBizCharge_Amount__c'));
        savedACH.ContactId = component.get("v.ConDetail.Id");
        savedACH.conExternalId = component.get('v.ConDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c ');
        var Amount = parseFloat(component.get('v.Amount'));
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount) - parseFloat(Tax);
        }
        savedACH.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        savedACH.Tax = parseFloat(Tax);
        savedACH.PaymentTotal = component.get('v.PaymentTotal');
        if (obj == 'Order') {
            savedACH.OrderId = component.get('v.orderDetail.Id');
            savedACH.OrderNo = component.get('v.orderDetail.OrderNumber');
        } else {
            savedACH.OrderId = '00000';
            savedACH.OrderNo = '00000';
        }
        savedACH.isRecurring = true;
        savedACH.rrPayName = component.get('v.rrPayName');
        savedACH.rrFrequency = component.get('v.rrFrequency');
        savedACH.rrNotes = component.get('v.rrNotes');
        savedACH.rrStartDate = component.get('v.rrStartDate');
        savedACH.rrEndDate = component.get('v.rrEndDate');
        savedACH.rrIndefinit = component.get('v.RecurIndefinitely');
        savedACH.selectedACHId = pby.selectedACHId;
        savedACH.SendReceiptTo = pby.SendReceiptTo;
        savedACH.addEmails = pby.addEmails;
        var action = component.get("c.runRecurringApxcContact");
        action.setParams({
            rrInfoJSON: JSON.stringify(savedACH),
            ConDetail: component.get('v.ConDetail'),
            ObjName: obj
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                var arr = [];
                arr = retValue.split('@');
                var message = arr[0];
                if (message == 'rrScheduled') {
                    component.set('v.Spinner', false);
                    this.showToast('Recurring payment scheduled successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    component.set("v.isOpen", false);
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    this.showToast(arr[1], 'Error');
                }
            } else {
                component.set('v.Spinner', false);
                this.showToast('Please refresh the page and try again!', 'Error');
                window.location.reload();
            }
        });
        $A.enqueueAction(action);
    },
    submitAddNewACHForm: function(component, event, helper) {
        var obj = component.get('v.ObjectName');
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var pby = component.get('v.payByACHInfo');
        var addNewACH = {};
        addNewACH.payBy = pby.payBy;
        addNewACH.ContactId = component.get("v.ConDetail.Id");
        addNewACH.conExternalId = component.get('v.ConDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c ');
        addNewACH.conAmount = parseFloat(component.get('v.ConDetail.Ebiz_C__EBizCharge_Contact_Amount__c '));
        var Amount = parseFloat(component.get('v.Amount'));
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount) - parseFloat(Tax);
        }
        addNewACH.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        addNewACH.Tax = parseFloat(Tax);
        addNewACH.PaymentTotal = component.get('v.PaymentTotal');
        if (obj == 'Order') {
            addNewACH.OrderId = component.get('v.orderDetail.Id');
            addNewACH.OrderNo = component.get('v.orderDetail.OrderNumber');
        } else {
            addNewACH.OrderId = '00000';
            addNewACH.OrderNo = '00000';
        }
        addNewACH.isRecurring = true;
        addNewACH.rrPayName = component.get('v.rrPayName');
        addNewACH.rrFrequency = component.get('v.rrFrequency');
        addNewACH.rrNotes = component.get('v.rrNotes');
        addNewACH.rrStartDate = component.get('v.rrStartDate');
        addNewACH.rrEndDate = component.get('v.rrEndDate');
        addNewACH.rrIndefinit = component.get('v.RecurIndefinitely');
        addNewACH.accHolderName = pby.accHolderName;
        addNewACH.accNumber = pby.accNumber;
        addNewACH.accRoutNumber = pby.accRoutNumber;
        addNewACH.accType = pby.accType;
        addNewACH.saveACH = pby.saveACH;
        addNewACH.SendReceiptTo = pby.SendReceiptTo;
        addNewACH.addEmails = pby.addEmails;
        addNewACH.MethodName = pby.MethodName;
        var action = component.get("c.runRecurringApxcContact");
        action.setParams({
            rrInfoJSON: JSON.stringify(addNewACH),
            ConDetail: component.get('v.ConDetail'),
            ObjName: obj
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                var arr = [];
                arr = retValue.split('@');
                var message = arr[0];
                if (message == 'rrScheduled') {
                    component.set('v.Spinner', false);
                    this.showToast('Recurring payment scheduled successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    component.set("v.isOpen", false);
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    this.showToast(arr[1], 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToast('Please refresh the page and try again!', 'Error');
                window.location.reload();
            }
        });
        $A.enqueueAction(action);
    },
    clearFormFields: function(component, event, PayBy) {
        component.set('v.PaymentTotal', 0);
        component.set('v.Amount', 0);
        component.set('v.Tax', 0);
        component.set('v.rrPayName', '');
        component.set('v.rrFrequency', null);
        component.set('v.rrStartDate', '');
        component.set('v.rrEndDate', '');
        component.set('v.rrNotes', '');
        component.set('v.rrS', null);
        component.set('v.disableSubmitBtn', true);
        component.set('v.showRRSummary', false);
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