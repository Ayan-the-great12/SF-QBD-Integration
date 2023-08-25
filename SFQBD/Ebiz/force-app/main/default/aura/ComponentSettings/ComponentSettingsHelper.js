({
    getComponentSettings: function(component, event) {
        var action = component.get("c.getCompSettingsApxc");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var cs = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(cs)) {
                    component.set("v.CS", response.getReturnValue());
                }
            }
        });
        $A.enqueueAction(action);
    },
    saveSettings: function(component, event) {
        component.set('v.Spinner', true);
        var cs = component.get('v.CS');
        var action = component.get("c.saveSettingsApxc");
        action.setParams({
            "cmpSettings": cs
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                this.showToast('Component Settings Saved Successfully!', 'Success');
                this.closeModel(component, event);
            } else {
                this.showToast('Please refresh the page and try again!', 'Error');
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
            $A.get('e.force:refreshView').fire();
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
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