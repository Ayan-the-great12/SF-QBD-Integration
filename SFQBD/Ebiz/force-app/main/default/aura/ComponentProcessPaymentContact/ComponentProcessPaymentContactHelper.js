({
    getContactDetail: function(component, event) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var ShowTaxField = Settings.Ebiz_C__Show_Tax_Field__c;
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
                component.set("v.contactDetail", resInfo.ContactInfo);
                component.set("v.ContactName", resInfo.ContactInfo.Name);
                component.set("v.ContactId", resInfo.ContactInfo.Id);
                if (resInfo.ContactInfo.Account != undefined) {
                    component.set("v.accountName", resInfo.ContactInfo.Account.Name);
                } else {
                    component.set("v.accountName", null);
                }
                var savedCard = [];
                var savedACH = [];
                var payM = resInfo.savedPaymentMethods;
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
                component.set('v.UseFullAmountForAVS', resInfo.UseFullAmountForAVS);
                component.set('v.Spinner', false);
            } else {
                component.set('v.Spinner', false);
                var errors = response.getError();
                this.showToastMsg('Something went wrong ' + errors[0].message + '!', 'Error');
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    submitExistCardForm: function(component, event, helper) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var obj = component.get('v.ObjectName');
        var pby = component.get('v.payByCardInfo');
        var saveWithXC = {};
        saveWithXC.TaxAction = TaxAction;
        saveWithXC.ContactId = component.get("v.contactDetail.Id");
        saveWithXC.conExternalId = component.get('v.contactDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c ');
        saveWithXC.conAmount = parseFloat(component.get('v.contactDetail.Ebiz_C__EBizCharge_Contact_Amount__c '));
        var Amount = parseFloat(component.get('v.Amount'));
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount);
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
        saveWithXC.Terminal = 'Contact';
        saveWithXC.isRecurring = false;
        if (obj == 'Order') {
            saveWithXC.OrdersfID = component.get("v.orderDetail.Id");
            saveWithXC.OrderId = component.get("v.orderDetail.OrderNumber");
            saveWithXC.OrderNo = component.get("v.orderDetail.OrderNumber");
            saveWithXC.paymentType = component.get('v.paymentType');
        } else {
            saveWithXC.OrderId = '00000';
            saveWithXC.OrderNo = '00000';
        }
        if (obj == 'Opportunity') {
            saveWithXC.OpportunityId = component.get("v.OpportunityDetail.Id");
            saveWithXC.OpportunityName = component.get("v.OpportunityDetail.Name");
        }
        var action = component.get("c.processPaymentWithXCApxcContact");
        action.setParams({
            savedCardJson: JSON.stringify(saveWithXC),
            ConDetail: component.get("v.contactDetail"),
            ObjName: obj,
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.Spinner', false);
                    this.showToastMsg('Payment processed successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    this.clearAllFields(component, event, 'CC');
                    component.set("v.isOpen", false);
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    this.showToastMsg(retValue, 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToastMsg('Please refresh the page and try again!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    submitAddNewCardForm: function(component, event, helper) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var obj = component.get('v.ObjectName');
        var pby = component.get('v.payByCardInfo');
        var addNewCard = {};
        addNewCard.TaxAction = TaxAction;
        addNewCard.ContactId = component.get("v.contactDetail.Id");
        addNewCard.conExternalId = component.get('v.contactDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c ');
        addNewCard.conAmount = parseFloat(component.get('v.contactDetail.Ebiz_C__EBizCharge_Contact_Amount__c '));
        var Amount = parseFloat(component.get('v.Amount'));
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount);
        }
        addNewCard.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        addNewCard.Tax = parseFloat(Tax);
        addNewCard.PaymentTotal = component.get('v.PaymentTotal');
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
        addNewCard.Terminal = 'Contact';
        addNewCard.isAVSCheck = component.get('v.isAVSCheck');
        addNewCard.isRecurring = false;
        if (obj == 'Order') {
            addNewCard.OrdersfID = component.get("v.orderDetail.Id");
            addNewCard.OrderId = component.get("v.orderDetail.OrderNumber");
            addNewCard.OrderNo = component.get("v.orderDetail.OrderNumber");
            addNewCard.paymentType = component.get('v.paymentType');
        } else {
            addNewCard.OrderId = '00000';
            addNewCard.OrderNo = '00000';
            addNewCard.paymentType = 'Sale';
        }
        if (obj == 'Opportunity') {
            addNewCard.OpportunityId = component.get("v.OpportunityDetail.Id");
            addNewCard.OpportunityName = component.get("v.OpportunityDetail.Name");
        }
        addNewCard.resResultCode = component.get("v.resResultCode");
        addNewCard.paymentMethodIDVar = component.get("v.paymentMethodIDVar");
        addNewCard.resError = component.get("v.resError");
        addNewCard.avsRefNum = component.get("v.avsRefNum");
        var action = component.get("c.processPaymentWithNCApxcContact");
        action.setParams({
            addNewCardJSON: JSON.stringify(addNewCard),
            conDetail: component.get("v.contactDetail"),
            ObjName: obj
        });
        try {
            action.setCallback(this, function(a) {
                if (a.getState() === "SUCCESS") {
                    var retValue = a.getReturnValue();
                    if (retValue == 'Success') {
                        component.set('v.Spinner', false);
                        this.showToastMsg('Payment processed successfully!', 'Success');
                        component.set('v.disableSubmitBtn', true);
                        this.clearAllFields(component, event, 'CC');
                        component.set("v.isOpen", false);
                        window.location.reload();
                    } else {
                        component.set('v.Spinner', false);
                        var arr = retValue.split('@');
                        var AVSCheck = arr[0];
                        var AVSWarnings = arr[1];
                        if (AVSWarnings == 'NoAVSWarnings') {
                            component.set('v.Spinner', false);
                            this.showToastMsg('AVS is not enabled, please contact support to enable AVS settings.', 'Error');
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
                                this.showToastMsg(retValue, 'Error');
                            }
                            component.set('v.avsCheckModalHeader', 'Security Mismatch');
                            component.set('v.avsCheckAction', 'Mismatch');
                        }
                    }
                } else {
                    var errors = a.getError();
                    component.set('v.Spinner', false);
                    this.showToastMsg('Please refresh the page and try again!', 'Error');
                }
            });
            $A.enqueueAction(action);
        } catch (err) {
            component.set('v.Spinner', false);
            this.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    submitSavedACHForm: function(component, event) {
        var pby = component.get('v.payByACHInfo');
        var obj = component.get('v.ObjectName');
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var savedACH = {};
        savedACH.TaxAction = TaxAction;
        savedACH.ContactId = component.get("v.contactDetail.Id");
        savedACH.conExternalId = component.get('v.contactDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c ');
        savedACH.conAmount = parseFloat(component.get('v.contactDetail.Ebiz_C__EBizCharge_Contact_Amount__c '));
        var Amount = parseFloat(component.get('v.Amount'));
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount);
        }
        savedACH.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        savedACH.Tax = parseFloat(Tax);
        savedACH.PaymentTotal = component.get('v.PaymentTotal');
        savedACH.selectedACHId = pby.selectedACHId;
        savedACH.SendReceiptTo = pby.SendReceiptTo;
        savedACH.addEmails = pby.addEmails;
        savedACH.Terminal = 'Contact';
        savedACH.isRecurring = false;
        if (obj == 'Order') {
            savedACH.OrdersfID = component.get("v.orderDetail.Id");
            savedACH.OrderId = component.get("v.orderDetail.OrderNumber");
            savedACH.OrderNo = component.get("v.orderDetail.OrderNumber");
            savedACH.paymentType = component.get('v.paymentType');
        } else {
            savedACH.OrderId = '00000';
            savedACH.OrderNo = '00000';
        }
        if (obj == 'Opportunity') {
            savedACH.OpportunityId = component.get("v.OpportunityDetail.Id");
            savedACH.OpportunityName = component.get("v.OpportunityDetail.Name");
        }
        var action = component.get("c.procesPaymentWithSavedACHApxcContact");
        action.setParams({
            savedACHJSON: JSON.stringify(savedACH),
            conDetail: component.get("v.contactDetail"),
            ObjName: obj,
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.Spinner', false);
                    this.showToastMsg('Payment processed successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    this.clearAllFields(component, event, 'ACH');
                    component.set("v.isOpen", false);
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    this.showToastMsg(retValue, 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToastMsg('Please refresh the page and try again!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    submitAddNewACHForm: function(component, event) {
        var pby = component.get('v.payByACHInfo');
        var obj = component.get('v.ObjectName');
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var addNewACH = {};
        addNewACH.TaxAction = TaxAction;
        addNewACH.ContactId = component.get("v.contactDetail.Id");
        addNewACH.conExternalId = component.get('v.contactDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c ');
        addNewACH.conAmount = parseFloat(component.get('v.contactDetail.Ebiz_C__EBizCharge_Contact_Amount__c '));
        var Amount = parseFloat(component.get('v.Amount'));
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount);
        }
        addNewACH.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        addNewACH.Tax = parseFloat(Tax);
        addNewACH.PaymentTotal = component.get('v.PaymentTotal');
        addNewACH.accHolderName = pby.accHolderName;
        addNewACH.accNumber = pby.accNumber;
        addNewACH.accRoutNumber = pby.accRoutNumber;
        addNewACH.accType = pby.accType;
        addNewACH.saveACH = pby.saveACH;
        addNewACH.SendReceiptTo = pby.SendReceiptTo;
        addNewACH.addEmails = pby.addEmails;
        addNewACH.Terminal = 'Contact';
        addNewACH.isRecurring = false;
        addNewACH.MethodName = pby.MethodName;
        if (obj == 'Order') {
            addNewACH.OrdersfID = component.get("v.orderDetail.Id");
            addNewACH.OrderId = component.get("v.orderDetail.OrderNumber");
            addNewACH.OrderNo = component.get("v.orderDetail.OrderNumber");
            addNewACH.paymentType = component.get('v.paymentType');
        } else {
            addNewACH.OrderId = '00000';
            addNewACH.OrderNo = '00000';
        }
        if (obj == 'Opportunity') {
            addNewACH.OpportunityId = component.get("v.OpportunityDetail.Id");
            addNewACH.OpportunityName = component.get("v.OpportunityDetail.Name");
        }
        var action = component.get("c.processPaymentNewACHApxcContact");
        action.setParams({
            addNewACHJSON: JSON.stringify(addNewACH),
            conDetail: component.get("v.contactDetail"),
            ObjName: obj,
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.Spinner', false);
                    this.showToastMsg('Payment processed successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    this.clearAllFields(component, event, 'ACH');
                    component.set("v.isOpen", false);
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    this.showToastMsg(retValue, 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToastMsg('Please refresh the page and try again', 'Error');
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
                this.showToastMsg('Payment voided successfully!', 'Success');
                window.location.reload(true);
            } else {
                component.set("v.avsCheckModal", false);
                this.showToastMsg('Something went wrong to void the payment!', 'Error');
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
    updatePaymentType: function(component, event, helper, condition) {
        var obj = component.get('v.ObjectName');
        if (obj == 'Order') {
            var payType = [];
            var Settings = component.get('v.Settings');
            var st = Settings.Ebiz_C__Allow_Order_Payment_Type__c;
            if (condition == 'a') {
                if (st == 'Pre-auths and Deposit') {
                    payType = [{
                            'label': 'Take deposit',
                            'value': 'Deposit'
                        },
                        {
                            'label': 'Run pre-auth',
                            'value': 'Preauth'
                        },
                    ];
                } else if (st == 'Pre-auths') {
                    payType = [{
                        'label': 'Run pre-auth',
                        'value': 'Preauth'
                    }, ];
                } else if (st == 'Deposit') {
                    payType = [{
                        'label': 'Take deposit',
                        'value': 'Deposit'
                    }, ];
                }
            } else if (condition == 'b') {
                if (st == 'Pre-auths and Deposit') {
                    payType = [{
                        'label': 'Take deposit',
                        'value': 'Deposit'
                    }, ];
                } else if (st == 'Pre-auths') {
                    payType = [{
                        'label': 'Take deposit',
                        'value': 'Deposit'
                    }, ];
                } else if (st == 'Deposit') {
                    payType = [{
                        'label': 'Take deposit',
                        'value': 'Deposit'
                    }, ];
                }
            }
            component.set('v.paymentOptions', payType);
        }
    },
    showToastMsg: function(message, type) {
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