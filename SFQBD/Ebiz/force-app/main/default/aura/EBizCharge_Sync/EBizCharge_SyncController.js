({
    doInit: function(component, event, helper) {
        try {
            helper.getSettings(component);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
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
    }
})