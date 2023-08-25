({
    doInit: function(component, event, helper) {
        component.set('v.Spinner', true);
        helper.loadEmailTemplates(component, event);
        helper.getDetail(component, event);
    },
    getTemplateInfo: function(component, event, helper) {
        var originallist = component.get("v.emailTemplist");
        var search = component.get("v.Template");
        if (!$A.util.isEmpty(search)) {
            for (var e in originallist) {
                if (originallist[e].TemplateInternalId == search) {
                    component.set("v.Subject", originallist[e].TemplateSubject);
                    component.set("v.fromName", originallist[e].TemplateFromName);
                    component.set("v.fromEmail", originallist[e].FromEmail);
                    component.set('v.fromName', originallist[e].FromName);
                    component.set("v.toEmail", component.get('v.CustomCustomerDetail').Ebiz_C__EBizCharge_Email__c);
                    var a = component.get('c.validateForm');
                    $A.enqueueAction(a);
                    return;
                } else {
                    component.set("v.Subject", '');
                    component.set("v.fromEmail", '');
                }
            }
        } else {
            component.set("v.Subject", '');
            component.set("v.fromEmail", '');
            var a = component.get('c.validateForm');
            $A.enqueueAction(a);
        }
    },
    sendReq: function(cmp, evt, helper) {
        cmp.set('v.Spinner', true);
        var allValid = cmp.find('field').reduce(function(validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            helper.addPaymentMethodReq(cmp, evt);
        } else {
            helper.showToast('Please update invalid form entries and try again! ', 'Error');
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
        $A.get('e.force:refreshView').fire();
    },
})