({
    searchNow: function(component, event, helper) {
        var compEvent = component.getEvent("filterdAccountsEvent");
        compEvent.setParams({
            "message": "Filter Accounts"
        });
        compEvent.fire();
        component.set("v.isOpen", false);
        component.set('v.Spinner', false);
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
            $A.get('e.force:refreshView').fire();
            component.set('v.Spinner', false);
            component.set('v.Spinner', false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    }
})