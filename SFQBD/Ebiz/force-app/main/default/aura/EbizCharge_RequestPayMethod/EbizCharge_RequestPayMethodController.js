({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.loadEmailTemplates(component, event);
            helper.getSettings(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!!', 'Error');
        }
    },
    handleActiveTab: function(component, event, helper) {
        try {
            var tab = event.getSource();
            tab = tab.get('v.id');
            component.set('v.ActiveTab', tab);
            if (tab == 'Send') {
                component.set('v.MainTitle', 'Send Requests');
            } else if (tab == 'Pending') {
                component.set('v.MainTitle', 'Pending Requests');
            } else if (tab == 'Received') {
                component.set('v.MainTitle', 'Added Payment Methods');
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    getTemplateInfo: function(component, event, helper) {
        var originallist = component.get("v.emailTemplist");
        var search = component.get("v.Template");
        var records = component.get("v.SelectedRecords");
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
        }
    },
    sendReq: function(component, event, helper) {
        var recordWithNoEmail = component.get('v.recordWithNoEmail');
        component.set('v.Spinner', true);
        var allValid = component.find('req-field').reduce(function(validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            if(recordWithNoEmail){
                component.set('v.isActive', true);
            }else{
                helper.SyncSelectedAccounts(component, event);
            }
        } else {
            helper.showToast('Please update invalid form entries and try again! ', 'Error');
            component.set('v.Spinner', false);
        }
    },
    sendRequest: function(component, event, helper) {
        component.set('v.Spinner', true);
        var allValid = component.find('req-field').reduce(function(validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if (allValid) {
            helper.SyncSelectedAccounts(component, event);
                component.set('v.isActive', false);
        } else {
            helper.showToast('Please update invalid form entries and try again! ', 'Error');
            component.set('v.Spinner', false);
        }
    },
    validateForm: function(component, event, helper) {
        var allValid = component.find('req-field').reduce(function(validSoFar, inputCmp) {
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if (allValid) {
            component.set('v.disableSubmitBtn', false);
        } else {
            component.set('v.disableSubmitBtn', true);
        }
    },
    closeModel: function(component, event, helper) {
        try {
            component.set('v.isActive', false);
            component.set('v.Spinner', false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    }
})