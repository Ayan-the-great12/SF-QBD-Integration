({
    handleClick: function(component, event, helper) {
        var compEvent = component.getEvent("RecurringReceivedApplyPayments");
        compEvent.setParams({
            "message": "Apply Payments"
        });
        compEvent.fire();
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isActive", false);
        } catch (e) {}
    }
})