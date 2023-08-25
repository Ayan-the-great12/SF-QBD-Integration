({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var ApplicationID = [];
            ApplicationID.push({
                'label': 'Epicor',
                'value': 'b31d6acb-c2d7-4c37-80c7-d663b1b008ed'
            });
            component.set('v.ApplicationID', ApplicationID);
            helper.getSettings(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    integrationHandler: function(component, event, helper) {
        var cs = component.get('v.Settings');
        var check = cs.Ebiz_C__Data_Integration__c;
        if (check == false) {
            component.find('applicationid').set("v.value", null);
            component.find('lookup').set("v.value", null);
            cs.Ebiz_C__Division_ID__c = null;
            cs.Ebiz_C__Data_Flow_Direction__c = null;
            cs.Ebiz_C__Application_ID__c = null;
            cs.Ebiz_C__Data_Integration__c = null;
            component.set('v.Settings', cs);
            helper.saveSettingsNew(component, event, 'Epicor');
        } else {
            component.set('v.ShowLookup', true);
        }
    },
    saveSettings: function(component, event, helper) {
        try {
            var allValid = component.find('req-fields').reduce(function(validSoFar, inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
            if (allValid) {
                helper.saveSettings(component, event);
            } else {
                helper.showToast('Please update the invalid form entries and try again.', 'Error');
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    TransHandler: function(component, event, helper) {},
    getCompanyData: function(component, event, helper) {
        try {
            var applicationID = component.find("applicationid").get("v.value");
            var lookupID = component.get("v.LookupID");
            if (applicationID != undefined && lookupID != undefined) {
                component.set('v.Spinner', true);
                helper.getCompanyData(component, event, applicationID, lookupID);
            } else {
                helper.showToast('Please provide correct Application ID and Lookup ID', 'Error');
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
})