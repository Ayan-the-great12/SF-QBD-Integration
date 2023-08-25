({
    getSettings: function(component) {
        var action = component.get("c.getSettingsApxc");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var cs = response.getReturnValue();
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(cs)) {
                    var settings = response.getReturnValue();
                    component.set("v.CS", response.getReturnValue());
                    if (settings.Ebiz_C__Data_Integration__c == true) {
                        component.set("v.DivisionID", settings.Ebiz_C__Division_ID__c);
                    }
                }
            } else {}
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