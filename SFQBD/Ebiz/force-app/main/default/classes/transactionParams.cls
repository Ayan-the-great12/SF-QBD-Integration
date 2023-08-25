public with sharing class transactionParams {
    public string paymentType {
        get;
        set;
    }
    public string OrderID {
        get;
        set;
    }
    public string PoNum {
        get;
        set;
    }
    public string OrderNumber {
        get;
        set;
    }
    public string accountID {
        get;
        set;
    }
    public string customerID {
        get;
        set;
    }
    public string internalID {
        get;
        set;
    }
    public string customerToken {
        get;
        set;
    }
    public string ccNumber {
        get;
        set;
    }
    public string expMonth {
        get;
        set;
    }
    public string expYear {
        get;
        set;
    }
    public string cvvCode {
        get;
        set;
    }
    public string ccName {
        get;
        set;
    }
    public string AvsZip {
        get;
        set;
    }
    public string AvsStreet {
        get;
        set;
    }
    public string CardCode {
        get;
        set;
    }
    public boolean saveCard {
        get;
        set;
    }
    public string AccountName {
        get;
        set;
    }
    public string Account {
        get;
        set;
    }
    public string Route {
        get;
        set;
    }
    public boolean saveAccount {
        get;
        set;
    }
    public string methodID {
        get;
        set;
    }
    public boolean isRecurring {
        get;
        set;
    }
    public decimal SubTotal {
        get;
        set;
    }
    public decimal Amount {
        get;
        set;
    }
    public decimal Tax {
        get;
        set;
    }
    public date Start {
        get;
        set;
    }
    public date Expire {
        get;
        set;
    }
    public string Schedule {
        get;
        set;
    }
    public string ScheduleName {
        get;
        set;
    }
    public string Notes {
        get;
        set;
    }
    public string MethodName {
        get;
        set;
    }
    public string SoftwareId {
        get;
        set;
    }
    public string Terminal {
        get;
        set;
    }
    public string Description {
        get;
        set;
    } //added by saud for sending opportunity name in description
    public String accountType {
        get;
        set;
    }
    public ebizchargeServicemodelSoap.ArrayOfLineItem LineItems {
        get;
        set;
    }
}