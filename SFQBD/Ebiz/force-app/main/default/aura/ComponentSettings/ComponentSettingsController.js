({
    doInit: function(component, event, helper) {
        try {
            helper.getComponentSettings(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    saveSettings: function(component, event, helper) {
        try {
            helper.saveSettings(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    closeModel: function(component, event, helper) {
        try {
            helper.closeModel(component, event, helper);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
})