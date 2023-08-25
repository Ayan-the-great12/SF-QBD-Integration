({
    getSettings: function(component, event) {
        var action = component.get("c.getSettingsApxc");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var cs = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(cs)) {
                    component.set('v.Settings', response.getReturnValue());
                    if (cs.Ebiz_C__Division_ID__c != null) {
                        component.set('v.ShowLookup', false);
                    }
                }
            } else {}
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
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
    saveSettingsNew: function(component, event, toastLabel) {
        var cs = component.get('v.Settings');
        if (cs.Ebiz_C__Show_Tax_Field__c && cs.Ebiz_C__Tax_Action__c == 'Tax Calculate' && cs.Ebiz_C__Tax_Calculate_By__c == 'Manual') {
            if (!cs.Ebiz_C__Tax_Manual_Type__c) {
                this.showToast('Please specify the manual sales tax entry option in setting', 'Error');
                component.set('v.Spinner', false);
                return;
            }
        }
        var action = component.get("c.saveSettingsApxc");
        action.setParams({
            "Settings": cs
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                this.showToast(toastLabel + ' settings saved successfully!', 'Success');
                this.getSettings(component, event);
            } else {
                this.showToast('Please refresh the page and try again!', 'Error');
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    showToast: function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: type + '!',
            message: message,
            duration: ' 5000',
            key: type + '_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
})