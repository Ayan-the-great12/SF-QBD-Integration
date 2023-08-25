({
    getSettings: function(component, event) {
        var action = component.get("c.getSettingsApxc");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var cs = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(cs)) {
                    component.set('v.Settings', response.getReturnValue());
                    var disabledSettings = component.get('v.Settings.Ebiz_C__Disable_all_frequencies__c');
                    if (disabledSettings == false) {
                        component.find("month").set("v.disabled", 'true');
                        component.find("daily").set("v.disabled", 'true');
                        component.find("biMonth").set("v.disabled", 'true');
                        component.find("week").set("v.disabled", 'true');
                        component.find("quarter").set("v.disabled", 'true');
                        component.find("biweek").set("v.disabled", 'true');
                        component.find("annual").set("v.disabled", 'true');
                        component.find("fourW").set("v.disabled", 'true');
                        component.find("biAnnu").set("v.disabled", 'true');
                    } else {}
                    if (cs.Ebiz_C__Division_ID__c != null) {
                        component.set('v.ShowLookup', false);
                    }
                } else {
                    component.set('v.Settings', null);
                }
            } else {}
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    saveSettingsNew: function(component, event, toastLabel) {
        var cs = component.get('v.Settings');
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