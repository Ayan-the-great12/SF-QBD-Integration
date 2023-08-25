({
    getSettings: function(component, event) {
        var action = component.get("c.getSettingsApxc");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var settings = response.getReturnValue();
                component.set('v.Settings', settings);
                var rrOptions = [];
                if (settings.Ebiz_C__AutoPay_daily__c) {
                    var refnumobject = {
                        value: "daily",
                        label: "daily"
                    }
                    rrOptions.push(refnumobject);
                }
                if (settings.Ebiz_C__AutoPay_weekly__c) {
                    var refnumobject = {
                        value: "weekly",
                        label: "weekly"
                    }
                    rrOptions.push(refnumobject);
                }
                if (settings.Ebiz_C__AutoPay_bi_weekly__c) {
                    var refnumobject = {
                        value: "bi-weekly",
                        label: "bi-weekly"
                    }
                    rrOptions.push(refnumobject);
                }
                if (settings.Ebiz_C__AutoPay_four_week__c) {
                    var refnumobject = {
                        value: "four-week",
                        label: "four-week"
                    }
                    rrOptions.push(refnumobject);
                }
                if (settings.Ebiz_C__AutoPay_monthly__c) {
                    var refnumobject = {
                        value: "monthly",
                        label: "monthly"
                    }
                    rrOptions.push(refnumobject);
                }
                if (settings.Ebiz_C__AutoPay_bi_monthly__c) {
                    var refnumobject = {
                        value: "bi-monthly",
                        label: "bi-monthly"
                    }
                    rrOptions.push(refnumobject);
                }
                if (settings.Ebiz_C__AutoPay_quarterly__c) {
                    var refnumobject = {
                        value: "quarterly",
                        label: "quarterly"
                    }
                    rrOptions.push(refnumobject);
                }
                if (settings.Ebiz_C__AutoPay_annually__c) {
                    var refnumobject = {
                        value: "annually",
                        label: "annually"
                    }
                    rrOptions.push(refnumobject);
                }
                if (settings.Ebiz_C__AutoPay_bi_annually__c) {
                    var refnumobject = {
                        value: "bi-annually",
                        label: "bi-annually"
                    }
                    rrOptions.push(refnumobject);
                }
                var rrDayOptions = [];
                for (var i = 1; i <= 28; i++) {
                    rrDayOptions.push({
                        'label': 'Day ' + i,
                        'value': i
                    });
                }
                component.set('v.rrDayOptions', rrDayOptions);
                component.set('v.rrOptions', rrOptions);
                component.set('v.payByCardInfo', null);
                component.set('v.payByACHInfo', null);
                component.set('v.rrS', null);
            }
        });
        $A.enqueueAction(action);
    },
    getAccountDetail: function(component, event) {
        var accountId = component.get('v.selectedLookUpAccRecord.Id');
        var action = component.get("c.getAccountDetailApxc");
        action.setParams({
            objID: accountId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                if (records.Object_Name == 'custom') {
                    component.set("v.custDetail", records.custDetail);
                }
                if (records.Object_Name == 'Contact') {
                    component.set("v.ConDetail", records.contactDetail);
                    component.set("v.accDetail", records.accountDetail);
                } else {
                    component.set("v.accDetail", records.accountDetail);
                }
                component.set("v.accDetail", records.accountDetail);
                var savedCard = [];
                var savedACH = [];
                var payM = records.savedPaymentMethods;
                for (var key in payM) {
                    var arr = [];
                    arr = key.toString().split('@');
                    if (arr[1] == 'C') {
                        savedCard.push({
                            value: arr[0],
                            label: payM[key]
                        });
                    } else {
                        savedACH.push({
                            value: arr[0],
                            label: payM[key]
                        });
                    }
                }
                component.set('v.Object_Name', records.Object_Name);
                component.set('v.saveCardsList', savedCard);
                component.set('v.saveACHList', savedACH);
                component.set("v.Spinner", false);
            } else {
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    submitExistCardForm: function(component, event, helper) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var pby = component.get('v.payByCardInfo');
        var saveWithXC = {};
        saveWithXC.payBy = pby.payBy;
        saveWithXC.OrderId = '00000';
        saveWithXC.OrderNo = '00000';
        saveWithXC.accId = component.get("v.accDetail.Id");
        saveWithXC.accExtrId = component.get("v.accDetail.Ebiz_C__EBizCharge_Internal_ID__c");
        saveWithXC.objectName = component.get('v.Object_Name');
        if (saveWithXC.objectName == 'Account') {
            if (saveWithXC.accExtrId == '' || saveWithXC.accExtrId == null) {
                component.set('v.Spinner', false);
                this.showToast('Please try to Sync Account/Contact before Scheduling Payment', 'Error');
                return;
            }
        }
        saveWithXC.accAmount = component.get('v.accDetail.Ebiz_C__EBizCharge_Amount__c');
        if (saveWithXC.objectName == 'Contact') {
            saveWithXC.accId = component.get("v.ConDetail.Id");
            saveWithXC.accExtrId = component.get("v.ConDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c");
            saveWithXC.accAmount = component.get('v.ConDetail.Ebiz_C__EBizCharge_Contact_Amount__c ');
            if (saveWithXC.accExtrId == '' || saveWithXC.accExtrId == null) {
                component.set('v.Spinner', false);
                this.showToast('Please try to Sync Account/Contact before Scheduling Payment', 'Error');
                return;
            }
        }
        if (saveWithXC.objectName == 'custom') {
            saveWithXC.accId = component.get("v.custDetail.Ebiz_C__EBizCharge_CustomerId__c");
            saveWithXC.accExtrId = component.get("v.custDetail.Ebiz_C__EBizCharge_Internal_ID__c");
            saveWithXC.accAmount = component.get('v.custDetail.Ebiz_C__EBizCharge_Amount__c');
            if (saveWithXC.accExtrId == '' || saveWithXC.accExtrId == null) {
                component.set('v.Spinner', false);
                this.showToast('Please try to Sync Customer before Scheduling Payment', 'Error');
                return;
            }
        }
        var Amount = parseFloat(component.get('v.rrAmount'));
        var Tax = parseFloat(component.get('v.rrTax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount) - parseFloat(Tax);
        }
        saveWithXC.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        saveWithXC.Tax = parseFloat(Tax);
        saveWithXC.PaymentTotal = component.get('v.rrAmountTotal');
        saveWithXC.selectedCard = pby.selectedCardXC;
        saveWithXC.CVCNumber = pby.cvcXC;
        saveWithXC.SendReceiptTo = pby.SendReceiptToXC;
        saveWithXC.addEmails = pby.addEmailsXC;
        saveWithXC.isRecurring = true;
        saveWithXC.rrPayName = component.get('v.rrPayName');
        saveWithXC.rrFrequency = component.get('v.rrFrequency');
        saveWithXC.rrNotes = component.get('v.rrNotes');
        saveWithXC.rrStartDate = component.get('v.rrStartDate');
        saveWithXC.rrEndDate = component.get('v.rrEndDate');
        saveWithXC.rrIndefinit = component.get('v.rrIndefinitely');
        var action = component.get("c.runRecurringApxc");
        action.setParams({
            rrInfoJSON: JSON.stringify(saveWithXC),
            actionStatus: 'Create'
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                var arr = [];
                arr = retValue.split('@');
                var message = arr[0];
                if (message == 'RecurringScheduled') {
                    component.set('v.Spinner', false);
                    this.showToast('Recurring payment scheduled successfully!', 'Success');
                    location.reload();
                    component.set('v.disableSubmitBtn', true);
                    this.clearFormFields(component, event, 'CC');
                } else {
                    component.set('v.Spinner', false);
                    this.showToast(arr[1], 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    submitAddNewCardForm: function(component, event, helper) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var pby = component.get('v.payByCardInfo');
        var addNewCard = {};
        addNewCard.payBy = pby.payBy;
        addNewCard.OrderNo = '00000';
        addNewCard.accId = component.get("v.accDetail.Id");
        addNewCard.accExtrId = component.get("v.accDetail.Ebiz_C__EBizCharge_Internal_ID__c");
        addNewCard.objectName = component.get('v.Object_Name');
        if (addNewCard.objectName == 'Account') {
            if (addNewCard.accExtrId == '' || addNewCard.accExtrId == null) {
                component.set('v.Spinner', false);
                this.showToast('Please try to Sync Account/Contact before Scheduling Payment', 'Error');
                return;
            }
        }
        addNewCard.accAmount = component.get('v.accDetail.Ebiz_C__EBizCharge_Amount__c');
        if (addNewCard.objectName == 'Contact') {
            addNewCard.accId = component.get("v.ConDetail.Id");
            addNewCard.accExtrId = component.get("v.ConDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c");
            addNewCard.accAmount = component.get('v.ConDetail.Ebiz_C__EBizCharge_Contact_Amount__c ');
            if (addNewCard.accExtrId == '' || addNewCard.accExtrId == null) {
                component.set('v.Spinner', false);
                this.showToast('Please try to Sync Account/Contact before Scheduling Payment', 'Error');
                return;
            }
        }
        if (addNewCard.objectName == 'custom') {
            addNewCard.accId = component.get("v.custDetail.Ebiz_C__EBizCharge_CustomerId__c");
            addNewCard.accExtrId = component.get("v.custDetail.Ebiz_C__EBizCharge_Internal_ID__c");
            addNewCard.accAmount = component.get('v.custDetail.Ebiz_C__EBizCharge_Amount__c');
            if (addNewCard.accExtrId == '' || addNewCard.accExtrId == null) {
                component.set('v.Spinner', false);
                this.showToast('Please try to Sync Customer before Scheduling Payment', 'Error');
                return;
            }
        }
        var Amount = parseFloat(component.get('v.rrAmount'));
        var Tax = parseFloat(component.get('v.rrTax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount) - parseFloat(Tax);
        }
        addNewCard.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        addNewCard.Tax = parseFloat(Tax);
        addNewCard.PaymentTotal = component.get('v.rrAmountTotal');
        addNewCard.isRecurring = true;
        addNewCard.rrPayName = component.get('v.rrPayName');
        addNewCard.rrFrequency = component.get('v.rrFrequency');
        addNewCard.rrNotes = component.get('v.rrNotes');
        addNewCard.rrStartDate = component.get('v.rrStartDate');
        addNewCard.rrEndDate = component.get('v.rrEndDate');
        addNewCard.rrIndefinit = component.get('v.rrIndefinitely');
        addNewCard.CardNumber = pby.CardNumber;
        addNewCard.BillingAddress = pby.BillingAddress;
        addNewCard.expiryMonth = pby.expiryMonth;
        addNewCard.expiryYear = pby.expiryYear;
        addNewCard.CVCNumber = pby.CVCNumber;
        addNewCard.ZipCode = pby.ZipCode;
        addNewCard.CardHolderName = pby.CardHolderName;
        addNewCard.saveCard = pby.saveCard;
        addNewCard.SendReceiptTo = pby.SendReceiptTo;
        addNewCard.addEmails = pby.addEmails;
        addNewCard.MethodName = pby.MethodName;
        addNewCard.isAVSCheck = component.get('v.isAVSCheck');
        var action = component.get("c.runRecurringApxc");
        action.setParams({
            rrInfoJSON: JSON.stringify(addNewCard),
            actionStatus: 'Create'
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                var arr = [];
                arr = retValue.split('@');
                var message = arr[0];
                if (message == 'RecurringScheduled') {
                    component.set('v.Spinner', false);
                    this.showToast('Recurring payment scheduled successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    location.reload();
                    this.clearFormFields(component, event, 'CC');
                } else {
                    component.set('v.Spinner', false);
                    var AVSCheck = arr[0];
                    if (AVSCheck == 'AVSCheck') {
                        component.set('v.avsCheckModal', true);
                        component.set('v.avsRefNum', arr[1]);
                        component.set('v.avsCardCode', arr[2]);
                        component.set('v.avsAddress', arr[3]);
                        component.set('v.avsZipCode', arr[4]);
                    } else {
                        component.set('v.Spinner', false);
                        this.showToast(retValue, 'Error');
                    }
                    component.set('v.avsCheckModalHeader', 'Security Mismatch');
                    component.set('v.avsCheckAction', 'Mismatch');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    submitExistACHForm: function(component, event, helper) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var pby = component.get('v.payByACHInfo');
        var savedACH = {};
        savedACH.payBy = pby.payBy;
        savedACH.OrderNo = '00000';
        savedACH.accId = component.get("v.accDetail.Id");
        savedACH.accExtrId = component.get("v.accDetail.Ebiz_C__EBizCharge_Internal_ID__c");
        savedACH.accAmount = component.get('v.accDetail.Ebiz_C__EBizCharge_Amount__c');
        savedACH.Amount = parseFloat(component.get('v.rrAmount'));
        savedACH.PaymentTotal = parseFloat(component.get('v.rrAmountTotal'));
        savedACH.objectName = component.get('v.Object_Name');
        if (savedACH.objectName == 'Contact') {
            savedACH.accId = component.get("v.ConDetail.Id");
            savedACH.accExtrId = component.get("v.ConDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c");
            savedACH.accAmount = component.get('v.ConDetail.Ebiz_C__EBizCharge_Contact_Amount__c ');
            if (savedACH.accExtrId == '' || savedACH.accExtrId == null) {
                component.set('v.Spinner', false);
                this.showToast('Please try to Sync Account/Contact before Scheduling Payment', 'Error');
                return;
            }
        }
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            var amount = savedACH.Amount;
            var Tax = component.get('v.rrTax') / 100;
            Tax = (amount * Tax).toFixed(2);
            savedACH.Tax = parseFloat(Tax);
        } else {
            savedACH.Tax = parseFloat(component.get('v.rrTax'));
        }
        savedACH.isRecurring = true;
        savedACH.rrPayName = component.get('v.rrPayName');
        savedACH.rrFrequency = component.get('v.rrFrequency');
        savedACH.rrNotes = component.get('v.rrNotes');
        savedACH.rrStartDate = component.get('v.rrStartDate');
        savedACH.rrEndDate = component.get('v.rrEndDate');
        savedACH.rrIndefinit = component.get('v.rrIndefinitely');
        savedACH.selectedACHId = pby.selectedACHId;
        savedACH.SendReceiptTo = pby.SendReceiptTo;
        savedACH.addEmails = pby.addEmails;
        var action = component.get("c.runRecurringApxc");
        action.setParams({
            rrInfoJSON: JSON.stringify(savedACH),
            actionStatus: 'Create'
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                var arr = [];
                arr = retValue.split('@');
                var message = arr[0];
                if (message == 'RecurringScheduled') {
                    component.set('v.Spinner', false);
                    this.showToast('Recurring payment scheduled successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    location.reload();
                    this.clearFormFields(component, event, 'ACH');
                } else {
                    component.set('v.Spinner', false);
                    this.showToast(arr[1], 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    submitAddNewACHForm: function(component, event, helper) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var pby = component.get('v.payByACHInfo');
        var addNewACH = {};
        addNewACH.objectName = component.get('v.Object_Name');
        addNewACH.payBy = pby.payBy;
        addNewACH.OrderNo = '00000';
        addNewACH.accId = component.get("v.accDetail.Id");
        addNewACH.accExtrId = component.get("v.accDetail.Ebiz_C__EBizCharge_Internal_ID__c");
        addNewACH.accAmount = component.get('v.accDetail.Ebiz_C__EBizCharge_Amount__c');
        addNewACH.Amount = parseFloat(component.get('v.rrAmount'));
        addNewACH.PaymentTotal = parseFloat(component.get('v.rrAmountTotal'));
        if (addNewACH.objectName == 'Contact') {
            addNewACH.accId = component.get("v.ConDetail.Id");
            addNewACH.accExtrId = component.get("v.ConDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c");
            addNewACH.accAmount = component.get('v.ConDetail.Ebiz_C__EBizCharge_Contact_Amount__c ');
            if (addNewACH.accExtrId == '' || addNewACH.accExtrId == null) {
                component.set('v.Spinner', false);
                this.showToast('Please try to Sync Account/Contact before Scheduling Payment', 'Error');
                return;
            }
        }
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            var amount = addNewACH.Amount;
            var Tax = component.get('v.rrTax') / 100;
            Tax = (amount * Tax).toFixed(2);
            addNewACH.Tax = parseFloat(Tax);
        } else {
            addNewACH.Tax = parseFloat(component.get('v.rrTax'));
        }
        addNewACH.isRecurring = true;
        addNewACH.rrPayName = component.get('v.rrPayName');
        addNewACH.rrFrequency = component.get('v.rrFrequency');
        addNewACH.rrNotes = component.get('v.rrNotes');
        addNewACH.rrStartDate = component.get('v.rrStartDate');
        addNewACH.rrEndDate = component.get('v.rrEndDate');
        addNewACH.rrIndefinit = component.get('v.rrIndefinitely');
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
            actionStatus: 'Create'
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                var arr = [];
                arr = retValue.split('@');
                var message = arr[0];
                if (message == 'RecurringScheduled') {
                    component.set('v.Spinner', false);
                    this.showToast('Recurring payment scheduled successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    location.reload();
                    this.clearFormFields(component, event, 'ACH');
                } else {
                    component.set('v.Spinner', false);
                    this.showToast(arr[1], 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
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
    clearFormFields: function(component, event, PayBy) {
        component.set('v.rrAmountTotal', 0);
        component.set('v.rrAmount', 0);
        component.set('v.rrTax', 0);
        component.set('v.rrPayName', '');
        component.set('v.rrFrequency', null);
        component.set('v.rrStartDate', '');
        component.set('v.rrEndDate', '');
        component.set('v.rrNotes', '');
        component.set('v.rrS', null);
        component.set('v.disableSubmitBtn', true);
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