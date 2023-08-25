({
    getAccountDetail: function(component, event) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var ShowTaxField = Settings.Ebiz_C__Show_Tax_Field__c;
        var obj = component.get('v.ObjectName');
        var action = component.get('c.getDetailApxc');
        action.setParams({
            "recordId": component.get('v.recordId'),
            "ObjectName": obj,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                if(obj == 'Account'){
                    var amount = 0.0;
                    var Tax = 0.0;
                    if(Settings.Ebiz_C__Tax_Calculate_By__c != 'Auto'){
                        var amountTax = resInfo.AccountInfo.Ebiz_C__EBizCharge_Custom_Tax__c;
                        component.set('v.Tax',amountTax);
                    } else{
                        component.set('v.Tax', Settings.Ebiz_C__Tax_Default_Percent__c);
                    }
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
                    component.set('v.Amount', amount);
                    component.set('v.PaymentTotal', TotalAmount);   
                }
                if (obj == 'Order') {
                    var amount = 0.0;
                    var Tax = 0.0;
                    var OrderAmount = resInfo.ordDetail.TotalAmount;
                    var EbizAmount = resInfo.ordDetail.Ebiz_C__EBizCharge_Amount__c;
                    var OrderBalance = resInfo.ordDetail.Ebiz_C__EBizCharge_Order_Balance__c;
                    amount = OrderBalance;
                    if(Settings.Ebiz_C__Tax_Calculate_By__c != 'Auto'){
                        var orderTax = resInfo.ordDetail.Ebiz_C__EBizCharge_Custom_Tax__c;
                        component.set('v.Tax',orderTax);
                    } else{
                        component.set('v.Tax', Settings.Ebiz_C__Tax_Default_Percent__c);
                    }
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
                    component.set('v.Amount', amount);
                    component.set('v.PaymentTotal', TotalAmount);
                    component.set("v.orderDetail", resInfo.ordDetail);
                }
                if (obj == 'Quote') {
                    var amount = 0.0;
                    var Tax = 0.0;
                    var quoteAmount = resInfo.quoteDetail.GrandTotal;
                    var EbizAmount = resInfo.quoteDetail.Ebiz_C__EBizCharge_Amount__c;
                    var quoteBalance = resInfo.quoteDetail.Ebiz_C__EBizCharge_Quote_Balance__c;
                    amount = quoteBalance;
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
                    component.set('v.Amount', amount);
                    component.set('v.Tax', Tax);
                    component.set('v.PaymentTotal', TotalAmount);
                    component.set("v.quoteDetail", resInfo.quoteDetail);
                }
                if (obj == 'Opportunity') {
                    var amount = 0.0;
                    var Tax = 0.0;
                    if (Settings.Ebiz_C__Use_Custom_Opportunity_Amount__c == true) {
                        var OppAmount = resInfo.OpportunityDetail.Ebiz_C__Custom_Amount__c;
                    } else {
                        var OppAmount = resInfo.OpportunityDetail.Amount;
                    }
                    var EbizAmount = resInfo.OpportunityDetail.Ebiz_C__EBizCharge_Amount__c;
                    var OrderBalance = resInfo.OpportunityDetail.Ebiz_C__EBizCharge_Opportunity_Balance__c;
                    amount = OppAmount ? OppAmount : 0.0;
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
                    component.set('v.Amount', amount);
                    component.set('v.Tax', Tax);
                    component.set('v.PaymentTotal', TotalAmount);
                    component.set("v.OpportunityDetail", resInfo.OpportunityDetail);
                }
                if (obj == 'Contact') {
                    component.set("v.contactDetail", resInfo.contactDetail);
                }
                component.set("v.accDetail", resInfo.AccountInfo);
                component.set("v.accountName", resInfo.AccountName);
                component.set("v.accountId", resInfo.AccountId);
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
                component.set('v.Spinner', false);
                component.set('v.UseFullAmountForAVS', resInfo.UseFullAmountForAVS);
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
        saveWithXC.DivisionId = Settings.Ebiz_C__Division_ID__c;
        saveWithXC.TaxAction = TaxAction;
        saveWithXC.AccountId = component.get("v.accDetail.Id");
        saveWithXC.QbdId  	  = component.get("v.accDetail.QBD_Customer_ID__c");
        saveWithXC.AccExternalId = component.get('v.accDetail.Ebiz_C__EBizCharge_Internal_ID__c');
        saveWithXC.accAmount = parseFloat(component.get('v.accDetail.Ebiz_C__EBizCharge_Amount__c'));
        var emailContact = component.get('v.selectedLookUpRecord');
        if (emailContact.Id != undefined) {
            saveWithXC.Terminal = emailContact.Id;
        } else {
            saveWithXC.Terminal = '';
        }
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
        saveWithXC.expiryMonth = pby.expiryMonth;
        saveWithXC.expiryYear = pby.expiryYear;
        saveWithXC.isRecurring = false;
        if (obj == 'Order') {
            saveWithXC.OrdersfID = component.get("v.orderDetail.Id");
            saveWithXC.OrderId = component.get("v.orderDetail.OrderNumber");
            saveWithXC.OrderNo = component.get("v.orderDetail.OrderNumber");
            saveWithXC.paymentType = component.get('v.paymentType');
        } else if (obj == 'Quote') {
            saveWithXC.OrdersfID = component.get("v.quoteDetail.Id");
            saveWithXC.OrderId = component.get("v.quoteDetail.QuoteNumber");
            saveWithXC.OrderNo = component.get("v.quoteDetail.QuoteNumber");
            saveWithXC.paymentType = component.get('v.paymentType');
        } else {
            saveWithXC.OrderId = '00000';
            saveWithXC.OrderNo = '00000';
        }
        if (obj == 'Opportunity') {
            saveWithXC.OpportunityId = component.get("v.OpportunityDetail.Id");
            saveWithXC.OpportunityName = component.get("v.OpportunityDetail.Name");
        }
        var action = component.get("c.processPaymentWithXCApxc");
        action.setParams({
            savedCardJson: JSON.stringify(saveWithXC),
            accDetail: component.get("v.accDetail"),
            ObjName: obj,
            OrderDetail: component.get('v.orderDetail'),
            QuoteDetail: component.get('v.quoteDetail')
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
                    this.showToastMsg('Please refresh the page and try again!', 'Error');
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
        addNewCard.DivisionId = Settings.Ebiz_C__Division_ID__c;
        addNewCard.TaxAction = TaxAction;
        addNewCard.AccountId = component.get("v.accDetail.Id");
        addNewCard.QbdId  	  = component.get("v.accDetail.QBD_Customer_ID__c");
        addNewCard.AccExternalId = component.get("v.accDetail.Ebiz_C__EBizCharge_Internal_ID__c");
        addNewCard.accAmount = parseFloat(component.get('v.accDetail.Ebiz_C__EBizCharge_Amount__c'));
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
        var emailContact = component.get('v.selectedLookUpRecord');
        if (emailContact.Id != undefined) {
            addNewCard.Terminal = emailContact.Id;
        } else {
            addNewCard.Terminal = '';
        }
        addNewCard.MethodName = pby.MethodName;
        addNewCard.isAVSCheck = component.get('v.isAVSCheck');
        addNewCard.isRecurring = false;
        if (obj == 'Order') {
            addNewCard.OrdersfID = component.get("v.orderDetail.Id");
            addNewCard.OrderId = component.get("v.orderDetail.OrderNumber");
            addNewCard.OrderNo = component.get("v.orderDetail.OrderNumber");
            addNewCard.paymentType = component.get('v.paymentType');
        } else if (obj == 'Quote') {
            addNewCard.OrdersfID = component.get("v.quoteDetail.Id");
            addNewCard.OrderId = component.get("v.quoteDetail.QuoteNumber");
            addNewCard.OrderNo = component.get("v.quoteDetail.QuoteNumber");
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
        var action = component.get("c.processPaymentWithNCApxc");
        action.setParams({
            addNewCardJSON: JSON.stringify(addNewCard),
            accDetail: component.get("v.accDetail"),
            ObjName: obj,
            OrderDetail: component.get('v.orderDetail'),
            QuoteDetail: component.get('v.quoteDetail')
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
                            this.showToastMsg('AVS is not enabled. Please contact Support.', 'Error');
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
            this.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    submitSavedACHForm: function(component, event, helper) {
        var pby = component.get('v.payByACHInfo');
        var obj = component.get('v.ObjectName');
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var savedACH = {};
        savedACH.DivisionId = Settings.Ebiz_C__Division_ID__c;
        savedACH.TaxAction = TaxAction;
        savedACH.AccountId = component.get("v.accDetail.Id");
          savedACH.QbdId  	  = component.get("v.accDetail.QBD_Customer_ID__c");
        savedACH.AccExternalId = component.get("v.accDetail.Ebiz_C__EBizCharge_Internal_ID__c");
        savedACH.accAmount = parseFloat(component.get('v.accDetail.Ebiz_C__EBizCharge_Amount__c'));
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
        var emailContact = component.get('v.selectedLookUpRecord');
        if (emailContact.Id != undefined) {
            savedACH.Terminal = emailContact.Id;
        } else {
            savedACH.Terminal = '';
        }
        savedACH.isRecurring = false;
        if (obj == 'Order') {
            savedACH.OrdersfID = component.get("v.orderDetail.Id");
            savedACH.OrderId = component.get("v.orderDetail.OrderNumber");
            savedACH.OrderNo = component.get("v.orderDetail.OrderNumber");
            savedACH.paymentType = component.get('v.paymentType');
        } else if (obj == 'Quote') {
            savedACH.OrdersfID = component.get("v.quoteDetail.Id");
            savedACH.OrderId = component.get("v.quoteDetail.QuoteNumber");
            savedACH.OrderNo = component.get("v.quoteDetail.QuoteNumber");
            savedACH.paymentType = component.get('v.paymentType');
        } else {
            savedACH.OrderId = '00000';
            savedACH.OrderNo = '00000';
        }
        if (obj == 'Opportunity') {
            savedACH.OpportunityId = component.get("v.OpportunityDetail.Id");
            savedACH.OpportunityName = component.get("v.OpportunityDetail.Name");
        }
        var action = component.get("c.procesPaymentWithSavedACHApxc");
        var qd = component.get('v.quoteDetail');
        action.setParams({
            savedACHJSON: JSON.stringify(savedACH),
            accDetail: component.get("v.accDetail"),
            ObjName: obj,
            OrderDetail: component.get('v.orderDetail'),
            QuoteDetail: component.get('v.quoteDetail')
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
                    this.showToastMsg('Please refresh the page and try again!', 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToastMsg('Please refresh the page and try again!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    submitAddNewACHForm: function(component, event, helper) {
        var pby = component.get('v.payByACHInfo');
        var obj = component.get('v.ObjectName');
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var addNewACH = {};
        addNewACH.DivisionId = Settings.Ebiz_C__Division_ID__c;
        addNewACH.TaxAction = TaxAction;
        addNewACH.AccountId = component.get("v.accDetail.Id");
        addNewACH.QbdId  	  = component.get("v.accDetail.QBD_Customer_ID__c");
        addNewACH.AccExternalId = component.get("v.accDetail.Ebiz_C__EBizCharge_Internal_ID__c");
        var emailContact = component.get('v.selectedLookUpRecord');
        if (emailContact.Id != undefined) {
            addNewACH.Terminal = emailContact.Id;
        } else {
            addNewACH.Terminal = '';
        }
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
        addNewACH.isRecurring = false;
        addNewACH.MethodName = pby.MethodName;
        if (obj == 'Order') {
            addNewACH.OrdersfID = component.get("v.orderDetail.Id");
            addNewACH.OrderId = component.get("v.orderDetail.OrderNumber");
            addNewACH.OrderNo = component.get("v.orderDetail.OrderNumber");
            addNewACH.paymentType = component.get('v.paymentType');
        } else if (obj == 'Quote') {
            addNewACH.OrdersfID = component.get("v.quoteDetail.Id");
            addNewACH.OrderId = component.get("v.quoteDetail.QuoteNumber");
            addNewACH.OrderNo = component.get("v.quoteDetail.QuoteNumber");
            addNewACH.paymentType = component.get('v.paymentType');
        } else {
            addNewACH.OrderId = '00000';
            addNewACH.OrderNo = '00000';
        }
        if (obj == 'Opportunity') {
            addNewACH.OpportunityId = component.get("v.OpportunityDetail.Id");
            addNewACH.OpportunityName = component.get("v.OpportunityDetail.Name");
        }
        var action = component.get("c.processPaymentNewACHApxc");
        action.setParams({
            addNewACHJSON: JSON.stringify(addNewACH),
            accDetail: component.get("v.accDetail"),
            ObjName: obj,
            OrderDetail: component.get('v.orderDetail'),
            QuoteDetail: component.get('v.quoteDetail')
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
                    this.showToastMsg('Please refresh the page and try again!', 'Error');
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
        if (obj == 'Quote') {
            var payType = [];
            var Settings = component.get('v.Settings');
            var st = Settings.Ebiz_C__Allow_Quote_Payment_Type__c;
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