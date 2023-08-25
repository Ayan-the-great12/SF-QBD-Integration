public class eBc_OpportunityController {
    
    
    @AuraEnabled
    public static List<OpportunityWrapper> getOpportunitiesApxc() {
        List<OpportunityWrapper> oppList = new List<OpportunityWrapper>(); 
        List<Opportunity> listOfOpp = new List<Opportunity>();
        try {
            listOfOpp = [SELECT id,Name,AccountId,Account.Name,Amount,CloseDate,
                         StageName,Type,LeadSource
                         FROM Opportunity WHERE StageName NOT IN('Closed Won','Closed Lost')  Order by CreatedDate DESC limit 25000
                        ];
            for(Opportunity o :listOfOpp){
                OpportunityWrapper obj = new OpportunityWrapper();
                obj.OppId	= o.Id;
                obj.OppName	= o.Name;
                obj.OppAccountId = o.AccountId;
                obj.OppAccountName = o.Account.Name;
                obj.OppAmount = o.Amount;
                obj.OppCloseDate = o.CloseDate;
                obj.OppStage = o.StageName;
                obj.OppStageName = o.StageName;
                obj.OppType = o.Type;
                obj.OppLeadSource = o.LeadSource;
                
                oppList.add(obj);                
            }
            
        }catch(Exception e) {
            throw new AuraHandledException('Darn it! Something went wrong: '+ e.getMessage()); 
        }
        system.debug('oppList>>>'+oppList.size());
        return oppList;
    }
    
    public class OpportunityWrapper{
        
        @AuraEnabled public boolean isSelected 		{get; set;}
        @AuraEnabled public String OppId 			{get; set;}
        @AuraEnabled public String OppName 			{get; set;}
        @AuraEnabled public String OppAccountId 	{get; set;}
        @AuraEnabled public String OppAccountName 	{get; set;}
        @AuraEnabled public Decimal OppAmount 		{get; set;}
        @AuraEnabled public Date OppCloseDate 		{get; set;}
        @AuraEnabled public String OppStage 		{get; set;}
        @AuraEnabled public String OppContractId 	{get; set;}
        @AuraEnabled public String OppContractName 	{get; set;}
        @AuraEnabled public String OppStageName 	{get; set;}
        @AuraEnabled public String OppType 			{get; set;}
        @AuraEnabled public String OppLeadSource 	{get; set;}
        
        public OpportunityWrapper(){
            isSelected   = false;
        }
    }
}