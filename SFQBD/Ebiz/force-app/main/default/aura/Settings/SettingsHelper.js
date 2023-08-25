({
    getSettings: function(component, event) {
        var action = component.get("c.getSettingsApxc");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var cs = response.getReturnValue();

            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(cs)) {
                    component.set('v.Settings', response.getReturnValue());
                }
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },

    saveSettings: function(component, event) {
        var cs = component.get('v.Settings');
        if (cs.Ebiz_C__Show_Tax_Field__c && cs.Ebiz_C__Tax_Action__c == 'Tax Calculate' && cs.Ebiz_C__Tax_Calculate_By__c == 'Manual') {
            if (!cs.Ebiz_C__Tax_Manual_Type__c) {
                this.showToast('Seems like Manually enter the sales tax option not specified!', 'Error');
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
                this.showToast('Application Settings Saved Successfully!', 'Success');
            } else {
                this.showToast('Something went wrong to save settings!', 'Error');
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