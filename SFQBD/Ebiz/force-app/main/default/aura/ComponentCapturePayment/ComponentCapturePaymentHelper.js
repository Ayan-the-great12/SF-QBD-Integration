({
    getDetail: function(component, event) {
        var Settings = component.get('v.Settings');
        var obj = component.get('v.ObjectName');
        var EbizAuthAmount = component.get('v.Transaction.Ebiz_C__Auth_Amount__c');
        var action = component.get('c.getDetailApxc');
        action.setParams({
            "recordId": component.get('v.recordId'),
            "ObjectName": obj,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                if (obj == 'Order') {
                    var amount = EbizAuthAmount;
                    var Tax = 0.0;
                    var OrderAmount = resInfo.ordDetail.TotalAmount;
                    var EbizAmount = resInfo.ordDetail.Ebiz_C__EBizCharge_Amount__c;
                    var OrderBalance = resInfo.ordDetail.Ebiz_C__EBizCharge_Order_Balance__c;
                    var TaxAction = Settings.Ebiz_C__Tax_Action__c;
                    if (TaxAction == 'Tax Included') {
                        var TaxDefaultPercent = Settings.Ebiz_C__Tax_Default_Percent__c / 100;
                        Tax = 0.0;
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
                    var TotalAmount = parseFloat(amount) + parseFloat(Tax);
                    if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
                        Tax = component.get('v.Tax');
                    }
                    component.set('v.Amount', amount);
                }
                if (obj == 'Quote') {
                    var amount = EbizAuthAmount;
                    var Tax = 0.0;
                    var QuoteAmount = resInfo.quoteDetail.GrandTotal;
                    var EbizAmount = resInfo.quoteDetail.Ebiz_C__EBizCharge_Amount__c;
                    var QuoteBalance = resInfo.quoteDetail.Ebiz_C__EBizCharge_Quote_Balance__c;
                    var TaxAction = Settings.Ebiz_C__Tax_Action__c;
                    if (TaxAction == 'Tax Included') {
                        var TaxDefaultPercent = Settings.Ebiz_C__Tax_Default_Percent__c / 100;
                        Tax = 0.0;
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
                    var TotalAmount = parseFloat(amount) + parseFloat(Tax);
                    if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
                        Tax = component.get('v.Tax');
                    }
                    component.set('v.Amount', amount);
                }
                if (obj == 'Order') {
                    component.set("v.orderDetail", resInfo.ordDetail);
                }
                if (obj == 'Quote') {
                    component.set("v.quoteDetail", resInfo.quoteDetail);
                }
                component.set("v.accDetail", resInfo.AccountInfo);
                component.set("v.accountName", resInfo.AccountName);
                component.set("v.accountId", resInfo.AccountId);
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
    capturePayment: function(component, event) {
        var captureTotal = component.find("capture-total").get("v.value");
        var action = component.get('c.capturePaymentApxc');
        action.setParams({
            orderDetail: component.get("v.orderDetail"),
            Amount: component.get('v.PaymentTotal'),
            Tax: component.get('v.Tax'),
            quoteDetail: component.get("v.quoteDetail")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.Spinner', false);
            if (state == "SUCCESS") {
                var retValue = response.getReturnValue();
                if (retValue == 'Success') {
                    this.showToast('Payment successfully captured!', 'Success');
                    $A.get('e.force:refreshView').fire();
                    component.set("v.isOpen", false);
                } else {
                    this.showToast(retValue, 'Error');
                }
            } else {
                this.showToast('Something went wrong to capture the payment!', 'Error');
            }
        });
        $A.enqueueAction(action);
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