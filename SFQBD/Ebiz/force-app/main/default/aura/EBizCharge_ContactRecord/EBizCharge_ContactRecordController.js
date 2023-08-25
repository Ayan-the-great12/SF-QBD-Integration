({
    onRecordSubmit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            event.preventDefault();
            var eventFields = event.getParam("fields");
            component.find('ContactForm').submit(eventFields);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    onRecordSuccess: function(component, event, helper) {
        try {
            helper.showToastMsg('Contact record successfully saved!', 'Success');
            component.set('v.Spinner', false);
            window.location.reload();
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
            window.location.reload(true);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleError: function(cmp, event, helper) {
        let errors = event.getParams();
        helper.showToastMsg(errors, 'Error');
    }
})