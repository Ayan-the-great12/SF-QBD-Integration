({
    doInit : function(component, event, helper) {
        try{
            
            component.set('v.Spinner',true);
            var DefaultTransBy = [];
            DefaultTransBy.push({'label':'Display transactions run today', 'value':'Today'});
            DefaultTransBy.push({'label':'Display transactions run in the past week', 'value':'Past Week'});
            DefaultTransBy.push({'label':'Display transactions run in the past month', 'value':'Past Month'});
            DefaultTransBy.push({'label':'Display transactions run in the past year', 'value':'Past Year'});
            component.set('v.DefaultTransBy',DefaultTransBy);
            
            var DefEmailReqSendBy = [];
            DefEmailReqSendBy.push({'label':'Display requests sent today', 'value':'Today'});
            DefEmailReqSendBy.push({'label':'Display requests sent in the past week', 'value':'Past Week'});
            DefEmailReqSendBy.push({'label':'Display requests sent in the past month', 'value':'Past Month'});
            DefEmailReqSendBy.push({'label':'Display requests sent in the past year', 'value':'Past Year'});
            component.set('v.DefaultEmailReqSendBy',DefEmailReqSendBy);
            
            var DefaultOrdersBy = [];
            DefaultOrdersBy.push({'label':'Display orders created or modified today', 'value':'Today'});
            DefaultOrdersBy.push({'label':'Display orders created or modified in the past week', 'value':'Past Week'});
            DefaultOrdersBy.push({'label':'Display orders created or modified in the past month', 'value':'Past Month'});
            DefaultOrdersBy.push({'label':'Display orders created or modified in the past year', 'value':'Past Year'});
            component.set('v.DefaultOrdersBy',DefaultOrdersBy);
            
            var DefaultAccountsBy = [];
            DefaultAccountsBy.push({'label':'Display accounts created or modified today', 'value':'Today'});
            DefaultAccountsBy.push({'label':'Display accounts created or modified in the past week', 'value':'Past Week'});
            DefaultAccountsBy.push({'label':'Display accounts created or modified in the past month', 'value':'Past Month'});
            DefaultAccountsBy.push({'label':'Display accounts created or modified in the past year', 'value':'Past Year'});
            component.set('v.DefaultAccountsBy',DefaultAccountsBy);
            
            var DefaultProductsBy = [];
            DefaultProductsBy.push({'label':'Display products created or modified today', 'value':'Today'});
            DefaultProductsBy.push({'label':'Display products created or modified in the past week', 'value':'Past Week'});
            DefaultProductsBy.push({'label':'Display products created or modified in the past month', 'value':'Past Month'});
            DefaultProductsBy.push({'label':'Display products created or modified in the past year', 'value':'Past Year'});
            component.set('v.DefaultProductsBy',DefaultProductsBy);
            
            var TaxAction = [
                {'label': 'Assume tax is already included in entered payment amount', 'value': 'Tax Included'},
                {'label': 'Tax should be calculated & added to entered payment amount', 'value': 'Tax Calculate'},
            ];
                component.set('v.TaxAction',TaxAction);     
                
                
                var TaxManualType = [
                {'label':'Use % for sales tax','value':'Use Percent'},
                {'label':'Use $ for sales tax','value':'Use Dollar'},
            ];
            component.set('v.TaxManualType',TaxManualType);
            
            helper.getSettings(component, event);
            
        }catch (e) {
            helper.showToastMsg('Please refresh the page and try again!','Error');
        }
        
    },
    
    TaxActionHandler : function(component, event, helper) {
        try{
            
            var TaxAction = event.getParam("value");
            component.set('v.Settings.Tax_Action__c',TaxAction);
            if(TaxAction == 'Tax Included'){
                component.set('v.Settings.Tax_Calculate_By__c',null);
                component.set('v.Settings.Tax_Manual_Type__c',null);
            }
            
        }catch (e) {
            helper.showToastMsg('Please refresh the page and try again!','Error');
        }
        
    },
    TaxTypeHandler : function(component, event, helper) {
        try{
            
            var TaxCalculateBy = event.getSource().get('v.value')
            if(TaxCalculateBy == 'Manual'){
                component.set('v.Settings.Tax_Default_Percent__c',0);            	
            }else{
                component.set('v.Settings.Tax_Manual_Type__c','');
            }
            component.set('v.Settings.Tax_Calculate_By__c',TaxCalculateBy);
            
        }catch (e) {
            helper.showToastMsg('Please refresh the page and try again!','Error');
        }
        
    }, 
    TaxManualHandler : function(component, event, helper) {
        try{
            
            var ManualType = event.getParam("value");
            component.set('v.Settings.Tax_Manual_Type__c',ManualType);    
            
        }catch (e) {
            helper.showToastMsg('Please refresh the page and try again!','Error');
        }
        
    },
    TransHandler : function(component, event, helper) {
        
    },
    paymentTypeHandler : function(component, event, helper) {
        try{
            
            var PaymentType = event.getSource().get('v.value');
            component.set('v.Settings.Allow_Order_Payment_Type__c',PaymentType);
            
        }catch (e) {
            helper.showToastMsg('Please refresh the page and try again!','Error');
        }
        
    },
    
    saveSettings : function(component, event, helper) {
        try{
            
            component.set('v.Spinner',true);
            helper.saveSettings(component, event);  
            
        }catch (e) {
            helper.showToastMsg('Please refresh the page and try again!','Error');
        }
        
    },
    
})