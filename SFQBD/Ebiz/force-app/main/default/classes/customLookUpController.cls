public class customLookUpController {
    
    //this class is deprected*
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName) {
       /*
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = '';
        String condition = '';
        String Fields = '';
        if(ObjectName == 'account'){
            Fields = 'Name';
            if(searchKeyWord != null && searchKeyWord !=''){
                searchKey = searchKeyWord + '%';
                condition =  'WHERE Name LIKE: searchKey';
            }
        }else if (ObjectName == 'Order'){
            Fields = 'OrderNumber';
            if(searchKeyWord != null && searchKeyWord !=''){
                searchKey = searchKeyWord + '%';
                condition =  'WHERE OrderNumber LIKE: searchKey AND EBizCharge_Order_Status__c <> \'Paid\' AND TotalAmount > 0 '; //AND (EBizCharge_Order_Balance__c = null OR EBizCharge_Order_Balance__c > 0)
            }else{
                condition =  'WHERE EBizCharge_Order_Status__c <> \'Paid\' AND TotalAmount > 0 '; //AND (EBizCharge_Order_Balance__c = null OR EBizCharge_Order_Balance__c > 0)
            }
        }
        
        List < sObject > returnList = new List < sObject > ();
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'SELECT Id,'+Fields+' FROM ' +ObjectName+' '+condition+' order by createdDate DESC limit 10';
        system.debug('sQuery>>>'+sQuery);
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
*/
        return null;
    }
}