public with sharing class TransactionPDFController {
    public string strVar {
        get;
        set;
    }
    public Map < String, Object > recMap {
        get;
        set;
    }
    public TransactionPDFController() {
        if (ApexPages.currentPage().getParameters().get('str') != null) {
            strVar = ApexPages.currentPage().getParameters().get('str');
            recMap = (Map < String, Object > ) JSON.deserializeUntyped(strVar);
        }
    }
}