({
    removePendingRecords: function(component, event, helper) {
        try {
            component.set("v.Spinner", true);
            helper.removePendingRecords(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    SendEmailsNow: function(component, event, helper) {
        try {
            component.set("v.Spinner", true);
            helper.SendEmailsNow(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
})