({
    onRecordSubmit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            event.preventDefault();
            var eventFields = event.getParam("fields");
            component.find('accForm').submit(eventFields);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    onRecordSuccess: function(component, event, helper) {
        try {
            helper.showToastMsg('Account record successfully saved!', 'Success');
            component.set('v.Spinner', false);
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "lightning/n/Account"
            });
            urlEvent.fire();
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleError: function(component, event, helper) {
        helper.showToastMsg('Please refresh the page and try again!', 'Error');
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
            window.location.reload(true);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    personAccAction: function(component, event, helper) {
        helper.personAccountHelper(component);
        var action = component.get("c.getPARecTypeId");
        action.setCallback(this, function(data) {
            component.set("v.recordTypeId", data.getReturnValue());
        });
        $A.enqueueAction(action);
    },
})