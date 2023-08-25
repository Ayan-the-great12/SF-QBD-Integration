({
    autoSyncContact: function(component, event, ContactId) {
        var action = component.get("c.autoSyncContactApxc");
        action.setParams({
            ContactId: ContactId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
        });
        $A.enqueueAction(action);
    },
    showToastMsg: function(msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            duration: ' 5000',
            mode: 'dismissible',
            message: msg,
            type: type,
            title: type + "!",
        });
        toastEvent.fire();
    },
})