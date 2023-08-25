({
    handleSuccess: function(component, event, helper) {
        try {
            var cs = component.get('v.Settings');
            var params = event.getParams();
            var OrderId = params.response.id;
            if (cs.Auto_Upload_Order__c == true) {
                helper.autoSyncOrder(component, event, OrderId);
            }
            component.set("v.isOpen", false);
            $A.get('e.force:refreshView').fire();
            component.set('v.Spinner', false);
            component.find('notifLib').showToast({
                "variant": "success",
                "title": "Order Created!",
                "message": "Order has been successfully created"
            });
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateDate: function(component, event, helper) {
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        var orderStartDate = component.get('v.ordStartDate');
        if (orderStartDate < today) {
            component.set('v.disableSaveBtn', true);
            helper.showToastMsg('Order start date must be greater than or equal to today\'s date!', 'Error');
        } else {
            component.set('v.disableSaveBtn', false);
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