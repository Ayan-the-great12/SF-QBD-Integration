@isTest
public class test_eBc_LookUpController {
    @isTest(OnInstall = true)
    static void testMethod1() {
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account ac = StaticMockData.getAccount()[0];
        Contact con = StaticMockData.getContact()[0];
        if (string.isNotEmpty(ac.id) && string.isNotEmpty(ac.id)) {
            Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
            transactionParams ts = new transactionParams();
            ts.methodID = '1';
            ts.accountID = ac.id;
            eBc_LookUpController.fetchLookUpValues('Test', 'contact', ac.Id);
            eBc_LookUpController.fetchLookUpValues('Test', 'order', 'null');
            eBc_LookUpController.fetchLookUpValues('Test', 'contact', 'null');
            eBc_LookUpController.fetchLookUpValues('Test', 'account', 'null');
            Account test_account = StaticMockData.getAccount()[0];
            eBc_LookUpController.fetchLookUpValuescurringRe('Test', '');
            try {
                eBc_LookUpController.fetchLookUpValues(null, 'order', ac.Id);
            } catch (Exception err) {}
        }
    }
    @isTest(OnInstall = true)
    static void test_constructor_lookupFields() {
        eBc_LookUpController.lookupFields luf = new eBc_LookUpController.lookupFields();
        luf.Name = '';
        luf.Id = '';
        luf.ObjectAPIName = '';
        luf.Icon = '';
    }
}