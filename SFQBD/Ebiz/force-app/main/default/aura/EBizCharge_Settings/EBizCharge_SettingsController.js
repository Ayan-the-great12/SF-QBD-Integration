({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.getSettings(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    handleActiveTab: function(component, event, helper) {
        try {
            var tab = event.getSource();
            tab = tab.get('v.id');
            component.set('v.ActiveTab', tab);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
})