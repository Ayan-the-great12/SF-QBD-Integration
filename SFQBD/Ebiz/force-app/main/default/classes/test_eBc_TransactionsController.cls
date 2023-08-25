@isTest
public class test_eBc_TransactionsController {
    @isTest(OnInstall = true)
    static void test_sendReceiptToCustomerApex() {
        String Refno = 'Refno';
        try {
            eBc_TransactionsController.sendReceiptToCustomerApex(Refno, '');
        } catch (exception err) {}
    }
    @isTest(OnInstall = true)
    static void test_constructor_Transactions() {
        eBc_TransactionsController.Transactions ts = new eBc_TransactionsController.Transactions();
        ts.Error = null;
        ts.ErrorCode = null;
        ts.CardType = null;
        ts.CardNumber = null;
        ts.checkAccount = null;
        ts.PayBy = null;
    }
    @isTest(OnInstall = true)
    static void testMethod1() {
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        Account ac = StaticMockData.getAccount()[0];
        order od = StaticMockData.getOrder()[0];
        contact con = StaticMockData.getContact()[0];
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        transactionParams ts = new transactionParams();
        ts.methodID = '1';
        ts.accountID = ac.id;
        EBizCharge_Transaction__c BT = StaticMockData.getEBizCharge_Transaction()[0];
        string filters = '{"InputText": "test","ViewAll": true }';
        string filters2 = '{"InputText": "" ,"ViewAll": false }';
        Test.startTest();
        eBc_TransactionsController.getTransactionsApxc(filters);
        eBc_TransactionsController.getTransactionsApxc(filters2);
        eBc_TransactionsController.GetEmailTrans('23423432424');
        eBc_TransactionsController.getSettingsApxc();
        eBc_TransactionsController.refundORVoidApxc('refund', 'RefNo', '3', '2', 'Order00012', '11111');
        ebizchargeServicemodelSoap.TransactionRequestObject ebizTransaction = new ebizchargeServicemodelSoap.TransactionRequestObject();
        Test.stopTest();
    }
}