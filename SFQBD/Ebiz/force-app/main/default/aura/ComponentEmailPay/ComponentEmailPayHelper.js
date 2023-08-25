({
    getDetail: function(component, event) {
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
                var TitleName = '';
                if (obj == 'Order') {
                    var orderbalance = resInfo.ordDetail.Ebiz_C__EBizCharge_Order_Balance__c;
                    var orderTotal = resInfo.ordDetail.TotalAmount;
                    if (orderbalance != null && orderbalance > 0) {
                        component.set("v.Amount", orderbalance);
                    } else {
                        component.set("v.Amount", orderTotal);
                    }
                    component.set("v.orderDetail", resInfo.ordDetail);
                    TitleName = 'Order #: ' + resInfo.ordDetail.OrderNumber;
                    var Settings = component.get('v.Settings');
                    var TaxAction = Settings.Ebiz_C__Tax_Action__c;
                    var ShowTaxField = Settings.Ebiz_C__Show_Tax_Field__c;
                    var amount = component.get('v.Amount');
                    if(Settings.Ebiz_C__Tax_Calculate_By__c != 'Auto'){
                        var orderTax = resInfo.ordDetail.Ebiz_C__EBizCharge_Custom_Tax__c;
                        component.set('v.Tax',orderTax);
                    } else{
                        component.set('v.Tax', Settings.Ebiz_C__Tax_Default_Percent__c);
                    }
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
                    if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent' && (!(Settings.Ebiz_C__Tax_Calculate_By__c == 'Auto'))) {
                        Tax = component.get('v.Tax');
                    }
                    component.set('v.PaymentTotal', TotalAmount);
                } else if (obj == 'Quote') {
                    var quoteBalance = resInfo.quoteDetail.Ebiz_C__EBizCharge_Quote_Balance__c;
                    var quoteTotal = resInfo.quoteDetail.GrandTotal;
                    if (quoteBalance != null && quoteBalance > 0) {
                        component.set("v.Amount", quoteBalance);
                    } else {
                        component.set("v.Amount", quoteTotal);
                    }
                    component.set("v.quoteDetail", resInfo.quoteDetail);
                    TitleName = 'Quote #: ' + resInfo.quoteDetail.QuoteNumber;
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
                    var GrandTotal = 0.0;
                    if (TaxAction == 'Tax Included' || ShowTaxField == false) {
                        GrandTotal = parseFloat(amount);
                    } else {
                        GrandTotal = parseFloat(amount) + parseFloat(Tax);
                    }
                    if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent' && (!(Settings.Ebiz_C__Tax_Calculate_By__c == 'Auto'))) {
                        Tax = component.get('v.Tax');
                    }
                    component.set('v.Tax', Tax);
                    component.set('v.PaymentTotal', GrandTotal);
                } else if (obj == 'Opportunity') {
                    var Settings = component.get('v.Settings');
                    TitleName = 'Opportunity: ' + resInfo.OppName;
                    var Opportunitybalance = resInfo.OpportunityDetail.Ebiz_C__EBizCharge_Order_Balance__c;
                    if (Settings.Ebiz_C__Use_Custom_Opportunity_Amount__c == true) {
                        var OpportunityTotal = resInfo.OpportunityDetail.Ebiz_C__Custom_Amount__c;
                    } else {
                        var OpportunityTotal = resInfo.OpportunityDetail.Amount;
                    }
                    if (!OpportunityTotal) {
                        component.set("v.Amount", 0.0);
                    } else {
                        component.set("v.Amount", OpportunityTotal);
                    }
                    component.set("v.OpportunityDetail", resInfo.OpportunityDetail);
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
                    component.set('v.PaymentTotal', TotalAmount)
                } else {
                    TitleName = resInfo.AccountName;
                }
                component.set('v.TitleName', TitleName);
                component.set("v.accountDetail", resInfo.AccountInfo);
                component.set("v.accountName", resInfo.AccountName);
                component.set("v.accountId", resInfo.AccountId);
                component.set('v.TempEmail', resInfo.AccountInfo.Ebiz_C__EBizCharge_Email__c);
                component.set('v.Spinner', false);
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToast('Please refresh the page and try again!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    loadEmailTemplates: function(component, event) {
        var action = component.get('c.getEmailTemplatesApxc');
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.emailTemplist", res);
            } else {
                toastEvent.setParams({
                    title: 'Error!',
                    message: 'Please refresh the page and try again!',
                    duration: ' 5000',
                    key: 'error_alt',
                    type: 'error',
                    mode: 'dismissible'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    sendEmailPayReq: function(component, event) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var obj = component.get('v.ObjectName');
        var sendReq = {};
        var Amount = parseFloat(component.get('v.Amount'));
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount) - parseFloat(Tax);
        }
        sendReq.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent' && (!(Settings.Ebiz_C__Tax_Calculate_By__c == 'Auto'))) {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        sendReq.Tax = parseFloat(Tax);
        sendReq.PaymentTotal = parseFloat(component.get('v.PaymentTotal'));
        sendReq.AccountId = component.get('v.accountId');
        sendReq.AccInternalId = component.get("v.accountDetail.Ebiz_C__EBizCharge_Internal_ID__c");
        sendReq.TemplateId = component.get('v.Template');
        sendReq.Subject = component.get('v.Subject');
        sendReq.fromName = component.get('v.fromName');
        sendReq.fromEmail = component.get('v.fromEmail');
        sendReq.toEmail = component.get('v.TempEmail');
        sendReq.Notes = component.get('v.Notes');
        sendReq.TaxAction = TaxAction;
        if (obj == 'Order') {
            sendReq.OrderId = component.get("v.orderDetail.Id");
            sendReq.PONum = component.get("v.orderDetail.PoNumber");
            sendReq.OrderNo = component.get("v.orderDetail.OrderNumber");
            sendReq.OrderTotal = parseFloat(component.get("v.orderDetail.TotalAmount"));
            sendReq.OrderBalance = parseFloat(component.get("v.orderDetail.Ebiz_C__EBizCharge_Order_Balance__c"));
        } else if (obj == 'Quote') {
            sendReq.OrderId = component.get("v.quoteDetail.Id");
            sendReq.PONum = component.get("v.quoteDetail.Ebiz_C__EBizCharge_PONumber__c");
            sendReq.OrderNo = component.get("v.quoteDetail.QuoteNumber");
            sendReq.OrderTotal = parseFloat(component.get("v.quoteDetail.GrandTotal"));
            sendReq.OrderBalance = parseFloat(component.get("v.quoteDetail.Ebiz_C__EBizCharge_Quote_Balance__c"));
        } else if (obj == 'Opportunity') {
            sendReq.OppId = component.get('v.recordId');
            sendReq.PONum = component.get("v.OpportunityDetail.Ebiz_C__EBizCharge_PONumber__c");
            sendReq.OpportunityTotal = parseFloat(component.get("v.Amount")) + sendReq.Tax;
            sendReq.OpportunityBalance = parseFloat(component.get("v.OpportunityDetail.Ebiz_C__EBizCharge_Opportunity_Balance__c"));
        }
        var action = component.get("c.sendEmailPayReqApxc");
        action.setParams({
            ObjName: obj,
            sendEmailReqJSON: JSON.stringify(sendReq),
            accDetail: component.get('v.accountDetail'),
            QuoteDetail: component.get('v.quoteDetail')
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.Spinner', false);
                    component.set('v.disableSubmitBtn', true);
                    this.showToast('Payment request successfully sent!', 'Success');
                    this.clearAllFields(component, event);
                    component.set("v.isOpen", false);
                    window.location.reload(true);
                } else if (retValue == 'Already Pending') {
                    component.set('v.Spinner', false);
                    component.set('v.disableSubmitBtn', true);
                    this.showToast('Payment request is already pending!', 'Error');
                    this.clearAllFields(component, event);
                    component.set("v.isOpen", false);
                    window.location.reload(true);
                } else {
                    component.set('v.Spinner', false);
                    this.showToast('There was an error to send email payment request!', 'Error');
                }
            } else {
                component.set('v.Spinner', false);
                this.showToast('Please refresh the page and try again!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    clearAllFields: function(component, event) {
        component.set('v.Amount', null);
        component.set('v.Tax', null);
        component.set('v.PaymentTotal', 0.0);
        component.set('v.Subject', '');
        component.set('v.Notes', '');
        component.set('v.fromEmail', '');
        component.set('v.accountDetail.Ebiz_C__EBizCharge_Email__c', '');
        component.set('v.disableSubmitBtn', true);
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
    },
})