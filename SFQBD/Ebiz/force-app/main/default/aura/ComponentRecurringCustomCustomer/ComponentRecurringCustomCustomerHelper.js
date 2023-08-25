({
    getCustDetail: function(component, event) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var ShowTaxField = Settings.Ebiz_C__Show_Tax_Field__c;
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
                component.set("v.Amount", resInfo.CustomCustInfo.Ebiz_C__EBizCharge_Amount_Source__c);
                component.set('v.ObjectLabelName', resInfo.Object_label)
                var Settings = component.get('v.Settings');
                var TaxAction = Settings.Ebiz_C__Tax_Action__c;
                var ShowTaxField = Settings.Ebiz_C__Show_Tax_Field__c;
                var amount = component.get('v.Amount');
                var Tax = 0.0;
                if (TaxAction == 'Tax Included') {
                    var TaxDefaultPercent = Settings.Ebiz_C__Tax_Default_Percent__c / 100;
                    Tax = amount * TaxDefaultPercent;
                } else {
                    var TaxCalculatedBy = Settings.Ebiz_C__Tax_Calculate_By__c;
                    if (TaxCalculatedBy == 'Auto') {
                        var TaxDefaultPercent = Settings.Ebiz_C__Tax_Default_Percent__c / 100;
                        Tax = amount * TaxDefaultPercent;
                    } else {
                        var TaxManualType = Settings.Ebiz_C__Tax_Manual_Type__c;
                        if (TaxManualType == 'Use Percent') {
                            Tax = component.get('v.Tax') / 100;
                            Tax = (amount * Tax).toFixed(2);
                        } else {
                            Tax = component.get('v.Tax');
                        }
                    }
                }
                var TotalAmount = 0.0;
                if (TaxAction == 'Tax Included' || ShowTaxField == false) {
                    TotalAmount = parseFloat(amount);
                } else {
                    TotalAmount = parseFloat(amount) + parseFloat(Tax);
                }
                if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
                    Tax = component.get('v.Tax');
                }
                component.set('v.Tax', Tax);
                component.set('v.PaymentTotal', TotalAmount);
                component.set('v.Spinner', false);
            } else {
                component.set('v.Spinner', false);
                var errors = response.getError();
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
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
        saveWithXC.ContactId = component.get("v.CustomCustomerDetail.Ebiz_C__EBizCharge_CustomerId__c");
        saveWithXC.conExternalId = component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Internal_ID__c ');
        saveWithXC.conAmount = parseFloat(component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Amount__c'));
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
        var action = component.get("c.runRecurringApxcCustomCustomer");
        action.setParams({
            rrInfoJSON: JSON.stringify(saveWithXC),
            ConDetail: component.get('v.CustomCustomerDetail'),
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
        addNewCard.ContactId = component.get("v.CustomCustomerDetail.Ebiz_C__EBizCharge_CustomerId__c");
        addNewCard.conExternalId = component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Internal_ID__c');
        addNewCard.conAmount = parseFloat(component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Amount__c'));
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
        var action = component.get("c.runRecurringApxcCustomCustomer");
        action.setParams({
            rrInfoJSON: JSON.stringify(addNewCard),
            ConDetail: component.get('v.CustomCustomerDetail'),
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
        savedACH.accAmount = component.get('v.accDetail.Ebiz_C__EBizCharge_Amount__c');
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
        var action = component.get("c.runRecurringApxc");
        action.setParams({
            rrInfoJSON: JSON.stringify(savedACH),
            accDetail: component.get('v.accDetail'),
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
        addNewACH.AccountId = component.get("v.accDetail.Id");
        addNewACH.AccExternalId = component.get("v.accDetail.Ebiz_C__EBizCharge_Internal_ID__c");
        addNewACH.accAmount = component.get('v.accDetail.Ebiz_C__EBizCharge_Amount__c');
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
        var action = component.get("c.runRecurringApxc");
        action.setParams({
            rrInfoJSON: JSON.stringify(addNewACH),
            accDetail: component.get('v.accDetail')
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