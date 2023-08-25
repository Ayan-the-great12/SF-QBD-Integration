@isTest
public class test_eBc_OpportunityController {
    @testSetup(OnInstall=true) 
    static void methodName() {
        Account testAccountData = new Account();
        Opportunity testOpportunityData = new Opportunity();
        testOpportunityData.Name='test';
        testAccountData.Name='test';
        testOpportunityData.Amount=6777;
        testOpportunityData.CloseDate=date.parse('12/27/2021');
        testOpportunityData.StageName='next';
        testOpportunityData.Type='Opportunity';
        testOpportunityData.LeadSource='lead_test';
        // insert testAccountData;
        // testOpportunityData.AccountId=testAccountData.Id;
        insert testOpportunityData;
	}
	@isTest(OnInstall=true)
    static void test_getOpportunitiesApxc(){
        eBc_OpportunityController.OpportunityWrapper oppWrapper = new eBc_OpportunityController.OpportunityWrapper();
        oppWrapper.isSelected= false;
        oppWrapper.OppId='test';
        oppWrapper.OppName='test';
        oppWrapper.OppAccountId='test';
        oppWrapper.OppAccountName='test';
        oppWrapper.OppAmount=6777;
        oppWrapper.OppCloseDate=date.parse('12/27/2021');
        oppWrapper.OppStage='next';
        oppWrapper.OppContractId='test';
        oppWrapper.OppContractName='test';
        oppWrapper.OppStageName='next';
        oppWrapper.OppType='Opportunity';
        oppWrapper.OppLeadSource='lead_test';
        
        eBc_OpportunityController.getOpportunitiesApxc();
    }
}