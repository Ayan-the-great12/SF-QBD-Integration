public class EBizcharge_Setting_DML {
    public void upsertRecord(EBizcharge_Setting__c Settings,boolean hasMatchingField){
        if(hasMatchingField==true){
            upsert Settings Settings.Id;
        }
        else{
            upsert Settings;
        } 
    }
    public EBizcharge_Setting__c getSettingRecordById(String recID){
        EBizcharge_Setting__c rec = new EBizcharge_Setting__c();
        if(recID!=''){
            rec =[SELECT id, Name, Security_Token__c, User_Name__c, Password__c FROM EBizcharge_Setting__c where Id = :recID];
        }
        else{
            rec =[SELECT id, Name, Security_Token__c, User_Name__c, Password__c FROM EBizcharge_Setting__c  Order by CreatedDate DESC limit 1];
        }
        
        
        return rec;
    }
    public List<EBizcharge_Setting__c> getSettingRecords(){
        List<EBizcharge_Setting__c> rec = new List<EBizcharge_Setting__c>();
        rec =[SELECT id, Name, Security_Token__c, User_Name__c, Password__c FROM EBizcharge_Setting__c];
        return rec;
    }
    
}