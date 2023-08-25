({
    doInit: function(component, event, helper) {
        try {
            var EbizAuthAmount = component.get('v.Transaction.Ebiz_C__Auth_Amount__c');
            var Tax = component.get('v.Transaction.Ebiz_C__Tax__c');
            component.set('v.Tax', Tax);
            component.set('v.Spinner', true);
            helper.getDetail(component, event);
            component.set('v.c_Amount', EbizAuthAmount - Tax);
            component.set('v.PaymentTotal', EbizAuthAmount);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    capturePayHandler: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.capturePayment(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    onChangeAmount: function(component, event, helper) {
        var obj = component.get('v.ObjectName');
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var EbizAuthAmount = component.get('v.Transaction.Ebiz_C__Auth_Amount__c')
        var Tax = component.get('v.Transaction.Ebiz_C__Tax__c');
        var inputAmount = component.get("v.c_Amount");
        if (inputAmount <= 0) {
            helper.showToast('Capture Amount should be greater than 0 ', 'Warning');
            component.set("v.c_Amount", EbizAuthAmount - Tax);
            component.set('v.PaymentTotal', EbizAuthAmount);
            return;
        }
        if (inputAmount > EbizAuthAmount - Tax) {
            component.set("v.btnDisable", true);
            component.set("v.c_Amount", EbizAuthAmount - Tax);
            helper.showToast('Capture Total should be equal or less than order pre-auth amount ', 'Warning');
            component.set('v.PaymentTotal', EbizAuthAmount);
        } else {
            component.set("v.btnDisable", false);
            var finalInputAmount = component.get("v.c_Amount");
            if (TaxAction == 'Tax Included') {
                var TaxDefaultPercent = Settings.Ebiz_C__Tax_Default_Percent__c / 100;
                Tax = 0.0;
            } else {
                var TaxCalculatedBy = Settings.Ebiz_C__Tax_Calculate_By__c;
                if (TaxCalculatedBy == 'Auto') {
                    var TaxDefaultPercent = Settings.Ebiz_C__Tax_Default_Percent__c / 100;
                    Tax = finalInputAmount * TaxDefaultPercent;
                } else {
                    var TaxManualType = Settings.Ebiz_C__Tax_Manual_Type__c;
                    if (TaxManualType == 'Use Percent') {
                        var subtotal = component.get('v.Transaction.Ebiz_C__EBizCharge_Subtotal__c');
                        Tax = parseFloat(Tax) / parseFloat(subtotal);
                        Tax = (finalInputAmount * Tax).toFixed(2);
                    } else {
                        var subtotal = component.get('v.Transaction.Ebiz_C__EBizCharge_Subtotal__c');
                        Tax = parseFloat(Tax) / parseFloat(subtotal);
                        Tax = (finalInputAmount * Tax).toFixed(2);
                    }
                }
            }
            var paymentTotal = parseFloat(finalInputAmount) + parseFloat(Tax);
            paymentTotal = paymentTotal.toFixed(2);
            component.set('v.PaymentTotal', paymentTotal);
            component.set('v.Tax', Tax);
        }
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
            window.location.reload(true);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
})