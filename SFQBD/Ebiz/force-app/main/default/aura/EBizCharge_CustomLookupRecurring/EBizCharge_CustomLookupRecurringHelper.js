({
    searchHelper: function(component, event, getInputkeyWord) {
        var action = component.get("c.fetchLookUpValuescurringRe");
        if ($A.util.isEmpty(getInputkeyWord)) {
            getInputkeyWord = 'AA';
        }
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'tabName': component.get("v.tabName")
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