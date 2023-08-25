({
    firstPage: function(component, event, helper) {
        try{
            component.set("v.currentPageNumber", 1);
        }catch (e) {
            helper.showToastMsg('Please refresh the page and try again!','Error');
        }
    },
    prevPage: function(component, event, helper) {
        try{
            component.set("v.currentPageNumber", Math.max(component.get("v.currentPageNumber")-1, 1));
        }catch (e) {
            helper.showToastMsg('Please refresh the page and try again!','Error');
        }
    },
    nextPage: function(component, event, helper) {
        try{
            component.set("v.currentPageNumber", Math.min(component.get("v.currentPageNumber")+1, component.get("v.maxPageNumber")));
            
        }catch (e) {
            helper.showToastMsg('Please refresh the page and try again!','Error');
        }
    },
    lastPage: function(component, event, helper) {
        try{
            component.set("v.currentPageNumber", component.get("v.maxPageNumber"));
            
        }catch (e) {
            helper.showToastMsg('Please refresh the page and try again!','Error');
        }
    }
})