public class EBC_ContractsController {
    
    @AuraEnabled
    public static List <Contract> getAllContracts(){
        List<Contract> retContracts = new List<Contract>();  
        try{
            retContracts = [SELECT Id,ContractNumber,Account.Name,Status,StartDate,EndDate,ContractTerm,ActivatedDate FROM Contract Order by CreatedDate DESC limit 49999];
        }catch(QueryException e){
            throw new AuraHandledException('Darn it! Something went wrong: '+ e.getMessage());
        }
        return retContracts;
    }
}