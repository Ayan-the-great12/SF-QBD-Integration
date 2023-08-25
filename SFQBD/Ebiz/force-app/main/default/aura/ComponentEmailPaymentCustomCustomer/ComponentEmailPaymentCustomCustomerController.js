({
    doInit: function(component, event, helper) {
        component.set('v.Spinner', true);
        var cs = component.get('v.Settings');
        if (cs.Ebiz_C__Tax_Action__c == 'Tax Included') {
            var str = 'Tax(' + cs.Ebiz_C__Tax_Default_Percent__c + '%)';
            component.set('v.TaxTitle', str);
        } else {
            if (cs.Ebiz_C__Tax_Calculate_By__c == 'Auto') {
                var str = 'Tax(' + cs.Ebiz_C__Tax_Default_Percent__c + '%)';
                component.set('v.TaxTitle', str);
            } else {
                if (cs.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
                    var str = 'Tax(%value)';
                    component.set('v.TaxTitle', str);
                } else {
                    var str = 'Tax($amount)';
                    component.set('v.TaxTitle', str);
                }
            }
        }
        helper.getDetail(component, event);
        helper.loadEmailTemplates(component, event);
    },
    onChangeAmount: function(component, evt, helper) {
        var obj = component.get('v.ObjectName');
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
    },
    getTemplateInfo: function(component, event, helper) {
        var originallist = component.get("v.emailTemplist");
        var search = component.get("v.Template");
        if (!$A.util.isEmpty(search)) {
            for (var e in originallist) {
                if (originallist[e].TemplateInternalId == search) {
                    component.set("v.Subject", originallist[e].TemplateSubject);
                    component.set("v.fromEmail", originallist[e].FromEmail);
                    component.set('v.fromName', originallist[e].FromName);
                    var a = component.get('c.validateForm');
                    $A.enqueueAction(a);
                    return null;
                }
            }
        }
    },
    sendEmailReq: function(cmp, evt, helper) {
        cmp.set('v.Spinner', true);
        var allValid = cmp.find('field').reduce(function(validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            helper.sendEmailPayReq(cmp, evt);
        } else {
            helper.showToast('Please update the invalid form entries and try again.', 'Error');
            cmp.set('v.Spinner', false);
        }
    },
    validateForm: function(component, event, helper) {
        var allValid = component.find('field').reduce(function(validSoFar, inputCmp) {
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if (allValid) {
            component.set('v.disableSubmitBtn', false);
        } else {
            component.set('v.disableSubmitBtn', true);
        }
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
        window.location.reload(true);
    },
})