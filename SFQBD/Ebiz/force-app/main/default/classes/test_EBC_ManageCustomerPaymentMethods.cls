@isTest
public class test_EBC_ManageCustomerPaymentMethods {
    @isTest(OnInstall = true)
    static void testMethod1() {
        Account acc = StaticMockData.getAccount()[0];
        string Object_json = '{"MethodType":"CreditCard","MethodID":"1","MethodName":"test","AccountHolderName":"test","CardNumber":"98983434","CardCode":"2","CardExpMonth":"2","CardExpYear":"2019","isDefault":true,"DateCreated":"2018-01-23T05:00:00Z"}';
        string Object_json_addPaymentMethodApxc = '{"MethodType":"CreditCard","MethodID":"1","MethodName":"test","AccountHolderName":"test","CardNumber":"98983434","CardCode":"2","CardExpMonth":"2","CardExpYear":"2019","isDefault":true,"DateCreated":"2018-01-23T05:00:00Z"}';
        EBC_ManageCustomerPaymentMethods.getPaymentMethodsApxc(acc.id, acc.id);
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        EBC_ManageCustomerPaymentMethods.DeletePaymentMethodApxc(acc.id, acc.id, 'test');
        EBC_ManageCustomerPaymentMethods.updatePaymentMethodApxc(acc.id, acc.id, Object_json);
        string Object_json2 = '{"isAVSCheck": true, "MethodType":"CreditCard","MethodID":"1","MethodName":"test","AccountHolderName":"test","CardNumber":"98983434","CardCode":"2","CardExpMonth":"2","CardExpYear":"2019","isDefault":true,"DateCreated":"2018-01-23T05:00:00Z"}';
        EBC_ManageCustomerPaymentMethods.updatePaymentMethodApxc(acc.id, acc.id, Object_json2);
        EBC_ManageCustomerPaymentMethods.addPaymentMethodApxc(acc.id, acc.id, Object_json_addPaymentMethodApxc);
        string Object_json_addPaymentMethodApxc2 = '{"isAVSCheck": true, "MethodType":"CreditCard","MethodID":"1","MethodName":"test","AccountHolderName":"test","CardNumber":"98983434","CardCode":"2","CardExpMonth":"2","CardExpYear":"2019","isDefault":true,"DateCreated":"2018-01-23T05:00:00Z"}';
        EBC_ManageCustomerPaymentMethods.addPaymentMethodApxc(acc.id, acc.id, Object_json_addPaymentMethodApxc2);
        EBC_ManageCustomerPaymentMethods.invokeTransactionVoidApxc('ref');
        Test.stopTest();
        EBC_ManageCustomerPaymentMethods.CstPaymentMethod cpm = new EBC_ManageCustomerPaymentMethods.CstPaymentMethod();
        cpm.CardCode = 'Code';
        cpm.Account = 'Account';
        cpm.AccountType = ' Type';
        cpm.IsErrorReturn = true;
        cpm.AVSretMsg = ' Type';
        cpm.Routing = 'Routing';
    }
    @isTest(OnInstall = true)
    static void test_avsMatchConditionCheck() {
        EBC_Logger ebcLogger = new EBC_Logger();
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        response.CardCodeResultCode = 'T';
        response.AvsResultCode = 'YYY';
        response.AvsResult = 'No AVS response';
        EBC_ManageCustomerPaymentMethods.avsMatchConditionCheck(response, ebcLogger);
        response.AvsResultCode = 'T';
        response.AvsResult = 'address:Match&zipcode:Match';
        EBC_ManageCustomerPaymentMethods.avsMatchConditionCheck(response, ebcLogger);
        response.AvsResultCode = 'T';
        response.AvsResult = 'address:NoMatch&zipcode:NoMatch';
        EBC_ManageCustomerPaymentMethods.avsMatchConditionCheck(response, ebcLogger);
        response.AvsResultCode = 'NNN';
        EBC_ManageCustomerPaymentMethods.avsMatchConditionCheck(response, ebcLogger);
        response.AvsResultCode = 'NYZ';
        EBC_ManageCustomerPaymentMethods.avsMatchConditionCheck(response, ebcLogger);
        response.AvsResultCode = 'YNA';
        EBC_ManageCustomerPaymentMethods.avsMatchConditionCheck(response, ebcLogger);
        response.AvsResultCode = 'XXW';
        EBC_ManageCustomerPaymentMethods.avsMatchConditionCheck(response, ebcLogger);
        response.AvsResultCode = 'XXU';
        EBC_ManageCustomerPaymentMethods.avsMatchConditionCheck(response, ebcLogger);
        response.AvsResultCode = 'XXR';
        EBC_ManageCustomerPaymentMethods.avsMatchConditionCheck(response, ebcLogger);
        response.AvsResultCode = 'XXS';
        EBC_ManageCustomerPaymentMethods.avsMatchConditionCheck(response, ebcLogger);
        response.AvsResultCode = 'XXE';
        EBC_ManageCustomerPaymentMethods.avsMatchConditionCheck(response, ebcLogger);
        response.AvsResultCode = 'XXG';
        EBC_ManageCustomerPaymentMethods.avsMatchConditionCheck(response, ebcLogger);
        response.AvsResultCode = 'YYY';
        response.CardCodeResultCode = 'P';
        EBC_ManageCustomerPaymentMethods.avsMatchConditionCheck(response, ebcLogger);
    }
}