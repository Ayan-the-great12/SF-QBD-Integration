({
    doInit : function(component, event, helper) {
        try{
            component.set("v.Spinner", true);
            helper.getOpportunities(component,event);
        }catch (e) {
            helper.showToastMsg('Please refresh the page and try again!','Error');
        }
        
    },
    
    NewOppHandler : function(component, event, helper) {
        try{
            component.set('v.showOppModal',true);
        }catch (e) {
            helper.showToastMsg('Please refresh the page and try again!','Error');
        }
        
    },
    
    sortByName : function(cmp, event, helper) {
    },
})