({
    autoSyncAccount: function(component, event, AccountId) {
        var action = component.get("c.autoSyncAccountApxc");
        action.setParams({
            AccountId: AccountId
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
    personAccountHelper: function(component) {
        var action = component.get("c.isPersonAccount");
        action.setCallback(this, function(data) {
            component.set("v.personAccountCheck", data.getReturnValue());
        });
        $A.enqueueAction(action);
    },
})