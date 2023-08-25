({
    onRecordSubmit: function(component, event, helper) {
        try{
            component.set('v.Spinner',true);
            event.preventDefault(); // stop form submission
            var eventFields = event.getParam("fields");
            component.find('oppForm').submit(eventFields);
            
        }catch (e) {
            helper.showToastMsg('Please refresh the page and try again!','Error');
        }
        
    },
    
    onRecordSuccess: function(component, event, helper) {
        try{
            helper.showToastMsg('Opportunity record successfully saved!','Success');
            component.set("v.isOpen", false);
        }catch (e) {
            helper.showToastMsg('Please refresh the page and try again!','Error');
        }
        
    },
    
    closeModel: function(component, event, helper) {
        try{
            component.set("v.isOpen", false); 
        }catch (e) {
            helper.showToastMsg('Please refresh the page and try again!','Error');
        }
        
    },
    
})