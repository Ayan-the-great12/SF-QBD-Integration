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
    getCompanyData: function(component, event, applicationID, lookupID) {
        var action = component.get("c.getApplicationDataApxc");
        action.setParams({
            "applicationID": applicationID,
            "lookupID": lookupID
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var divisionID = response.getReturnValue();
                component.set('v.DivisionID', divisionID);
                component.set('v.ShowLookup', false);
                var cs = component.get('v.Settings');
                cs.Ebiz_C__Division_ID__c = divisionID;
                component.set('v.Settings', cs);
                this.saveSettingsNew(component, event, 'Epicor');
            } else {
                this.showToast('Please refresh the page and try again!', 'Error');
                component.set('v.Spinner', false);
            }
        });
        $A.enqueueAction(action);
    },
    saveSettings: function(component, event) {
        var cs = component.get('v.Settings');
        var action = component.get("c.saveSettingsApxc");
        action.setParams({
            "Settings": cs
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                this.showToast('Application settings saved successfully!', 'Success');
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