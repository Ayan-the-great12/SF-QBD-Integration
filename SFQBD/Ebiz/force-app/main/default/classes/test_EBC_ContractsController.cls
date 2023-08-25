@isTest
public class test_EBC_ContractsController {
	@isTest(OnInstall=true)
    static void test_getAllContracts(){
        EBC_ContractsController.getAllContracts();
    }
    
}