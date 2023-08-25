@isTest
public class test_EBC_ManageCustomerContact {
    @isTest(OnInstall = true)
    static void testMethod1() {
        Contact acc = StaticMockData.getContact()[0];
        string Object_json = '{"MethodType":"CreditCard","MethodID":"1","MethodName":"test","AccountHolderName":"test","CardNumber":"98983434","CardCode":"2","CardExpMonth":"2","CardExpYear":"2019","isDefault":true,"DateCreated":"2018-01-23T05:00:00Z"}';
        string Object_json_addPaymentMethodApxc = '{"MethodType":"CreditCard","MethodID":"1","MethodName":"test","AccountHolderName":"test","CardNumber":"98983434","CardCode":"2","CardExpMonth":"2","CardExpYear":"2019","isDefault":true,"DateCreated":"2018-01-23T05:00:00Z"}';
        EBC_ManageCustomerPaymentMethodsContact.getPaymentMethodsApxc(acc.id, acc.id);
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        Test.startTest();
        EBC_ManageCustomerPaymentMethodsContact.DeletePaymentMethodApxc(acc.id, acc.id, 'test');
        try {
            EBC_ManageCustomerPaymentMethodsContact.updatePaymentMethodApxc(acc.id, acc.id, Object_json);
        } catch (Exception ex) {
            system.debug('ex');
        }
        string Object_json2 = '{"isAVSCheck": true, "MethodType":"CreditCard","MethodID":"1","MethodName":"test","AccountHolderName":"test","CardNumber":"98983434","CardCode":"2","CardExpMonth":"2","CardExpYear":"2019","isDefault":true,"DateCreated":"2018-01-23T05:00:00Z"}';
        EBC_ManageCustomerPaymentMethodsContact.updatePaymentMethodApxc(acc.id, acc.id, Object_json2);
        try {
            EBC_ManageCustomerPaymentMethodsContact.addPaymentMethodApxc(acc.id, acc.id, Object_json_addPaymentMethodApxc);
        } catch (Exception ex) {
            system.debug('ex');
        }
        string Object_json_addPaymentMethodApxc2 = '{"isAVSCheck": true, "MethodType":"CreditCard","MethodID":"1","MethodName":"test","AccountHolderName":"test","CardNumber":"98983434","CardCode":"2","CardExpMonth":"2","CardExpYear":"2019","isDefault":true,"DateCreated":"2018-01-23T05:00:00Z"}';
        EBC_ManageCustomerPaymentMethodsContact.addPaymentMethodApxc(acc.id, acc.id, Object_json_addPaymentMethodApxc2);
        EBC_ManageCustomerPaymentMethodsContact.invokeTransactionVoidApxc('ref');
        Test.stopTest();
        EBC_ManageCustomerPaymentMethodsContact.CstPaymentMethod cpm = new EBC_ManageCustomerPaymentMethodsContact.CstPaymentMethod();
        cpm.CardCode = 'Code';
        cpm.Account = 'Account';
        cpm.IsErrorReturn = true;
        cpm.AccountType = ' Type';
        cpm.Routing = 'Routing';
    }
}