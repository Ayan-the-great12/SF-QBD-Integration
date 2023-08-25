({
    doInit: function(component, event, helper) {
        component.set('v.Spinner', true);
        helper.loadEmailTemplates(component, event);
        helper.getDetail(component, event);
    },
    getTemplateInfo: function(component, event, helper) {
        var originallist = component.get("v.emailTemplist");
        var search = component.get("v.Template");
        var records = component.get("v.recordList");
        var multiEmail = "";
        for (var i = 0; i < records.length; i++) {
            var email = records[i].accEmail;
            if (i == 0) {
                multiEmail = email;
            } else {
                multiEmail = multiEmail + "," + email;
            }
        }
        component.set("v.toEmail", multiEmail);
        if (!$A.util.isEmpty(search)) {
            for (var e in originallist) {
                if (originallist[e].TemplateInternalId == search) {
                    component.set("v.Subject", originallist[e].TemplateSubject);
                    component.set("v.fromName", originallist[e].TemplateFromName);
                    component.set("v.fromEmail", originallist[e].FromEmail);
                    component.set('v.fromName', originallist[e].FromName);
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
    sendReq: function(component, event, helper) {
        component.set('v.Spinner', true);
        var allValid = component.find('field').reduce(function(validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            helper.addPaymentMethodReq(component, event);
        } else {
            helper.showToast('Please update invalid form entries and try again! ', 'Error');
            component.set('v.Spinner', false);
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
    },
    closeModelCross: function(component, event, helper) {
        component.set("v.isOpen", false);
        $A.get('e.force:refreshView').fire();
        window.location.reload(true);
    },
})