({
    searchHelper: function(component, event, getInputkeyWord, getParentId) {
        var action = component.get("c.fetchLookUpValues");
        var objectName = component.get("v.objectAPIName");
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'ObjectName': objectName,
            'parentId': getParentId
        });
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Result Found...');
                } else {
                    component.set("v.Message", '');
                }
                component.set("v.listOfSearchRecords", storeResponse);
            }
        });
        $A.enqueueAction(action);
    },
    showToastMsg: function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: type + '!',
            message: message,
            duration: ' 5000',
            key: type + '_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
})