({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.getSettings(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    saveSettingsSync: function(component, event, helper) {
        try {
            helper.saveSettingsNew(component, event, 'Sync ');
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
})