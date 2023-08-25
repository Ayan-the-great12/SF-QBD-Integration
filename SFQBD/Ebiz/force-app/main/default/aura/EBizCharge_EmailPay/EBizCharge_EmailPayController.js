({
    doInit: function(component, event, helper) {
        try {
            helper.getSettings(component);
            helper.loadEmailTemplates(component, event);
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
                        return;
                    }
                }
            } else {
                component.set("v.Subject", '');
                component.set("v.fromEmail", '');
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleActiveTab: function(component, event, helper) {
        try {
            var tab = event.getSource();
            tab = tab.get('v.id');
            component.set('v.ActiveTab', tab);
            if (tab == 'Create') {
                component.set('v.MainTitle', 'Create New Email Payment Request');
            } else if (tab == 'Pending') {
                component.set('v.MainTitle', 'Pending Payment Requests');
            } else if (tab == 'Received') {
                component.set('v.MainTitle', 'Received Email Payments');
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    EmailOnChanged: function(component, event, helper) {
        if (event.getSource().get("v.value")) {
            var ES = component.get('v.ES');
            ES.toEmail = event.getSource().get("v.value")
            component.set('v.ES', ES);
        }
    },
    sendEmailReq: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var allValid = component.find('req-field').reduce(function(validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && inputCmp.get('v.validity').valid;
            }, true);
            if (allValid) {
                helper.sendEmailPayReq(component, event);
            } else {
                helper.showToast('Please update invalid form entries and try again.', 'Error');
                component.set('v.Spinner', false);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
})