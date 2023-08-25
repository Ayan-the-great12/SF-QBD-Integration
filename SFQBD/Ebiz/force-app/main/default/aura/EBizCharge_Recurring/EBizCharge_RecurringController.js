({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.getSettings(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    doAction: function(component, event, helper) {
        try {
            component.find("tabs").set('v.selectedTabId', 'Create');
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    }
})