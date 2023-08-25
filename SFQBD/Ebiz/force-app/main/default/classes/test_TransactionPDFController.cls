@isTest
public class test_TransactionPDFController {
    @isTest(OnInstall = true)
    static void testMethod1() {
        Integer len = 10; //fake id
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        String reg = key.substring(0, len);
        Account acc = StaticMockData.getAccount()[0];
        ebizchargeServicemodelSoap.SecurityToken Token = new ebizchargeServicemodelSoap.SecurityToken();
        Token.SecurityId = '234234';
        Token.UserId = 'test-1';
        Token.Password = '123';
        TransactionPDFController cc = new TransactionPDFController();
        if (string.isNotBlank(acc.id)) {
            cc.strVar = 'test';
            System.currentPageReference().getParameters().put('str', 'test');
        }
    }
}