({
    getOpportunities : function(component,event) {
        var action = component.get("c.getOpportunitiesApxc");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                component.set('v.opportunityList',records);
                component.set("v.Spinner", false);
            }else{
                component.set("v.Spinner",false);
                this.showToastMsg('Darn it! Something went wrong','Error');
            }
        });
        $A.enqueueAction(action); 
    }, 
    showToastMsg : function(msg,type){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            duration:' 5000',
            mode: 'dismissible',
            message: msg,
            type : type,
            title: type+"!",
        });
        toastEvent.fire();
    },
    
})