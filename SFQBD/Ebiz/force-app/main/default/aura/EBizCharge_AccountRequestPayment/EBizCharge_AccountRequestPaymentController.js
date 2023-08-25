({
    doinit: function(component, event, helper) {
        try {
            var userEmail = $A.get("$SObjectType.CurrentUser.Email");
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    getTemplateInfo: function(component, event, helper) {
        try {
            var originallist = component.get("v.emailTemplist");
            var search = component.get("v.Template");
            if (!$A.util.isEmpty(search)) {
                for (var e in originallist) {
                    if (originallist[e].TemplateInternalId == search) {
                        component.set("v.Subject", originallist[e].TemplateSubject);
                        component.set("v.fromEmail", originallist[e].FromEmail);
                        component.set('v.toEmail', component.get('v.recDetail.accEmail'));
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
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateForm: function(component, event, helper) {
        try {
            var allValid = component.find('field').reduce(function(validSoFar, inputCmp) {
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
            if (allValid) {
                component.set('v.disableSubmitBtn', false);
            } else {
                component.set('v.disableSubmitBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    sendReq: function(cmp, evt, helper) {
        try {
            cmp.set('v.Spinner', true);
            var allValid = cmp.find('field').reduce(function(validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            if (allValid) {
                helper.addPaymentMethodReq(cmp, evt);
            } else {
                helper.showToast('Please update invalid form entries and try again.', 'Error');
                cmp.set('v.Spinner', false);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    closeModel: function(component, event, helper) {
        try {
            helper.closeModel(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
})