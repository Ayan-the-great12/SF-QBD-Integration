public with sharing class Enums {
    public enum PREFIX {
        OPP,
        ORD,
        QUO
    }
    public enum FIELDNAMES {
        InvoiceNumber,
        OrderId,
        OpportunityId,
        CustomerID,
        Invoice,
        SoftwareID,
        TransID,
        Amount,
        Created,
        SalesOrderLastSyncDateTime,
        DateCreated,
        Software,
        DateTimeModified,
        DateTimeCreated,
        RefNum,
        SalesOrderInternalId,
        DivisionId,
        ExpirationYear,
        ExpirationMonth,
        PaymentMethodId,
        Id,
        DateUploaded,
        DateUpdated,
        DateModified,
        createddate
    }
    public enum MESSAGETYPES {
        INFO,
        WARN,
        ERROR
    }
    public enum FIELDVALUES {
        Token,
        SalesforceApp
    }
    public enum FILTERBY {
        Today
    }
    public enum SALESFORCEOBJECTNAMES {
        Account,
        Contact,
        Order,
        Opportunity,
        Quote,
        custom,
        Product,
        Payment
    }
    public enum LINEITEMPARAMETERS {
        EA
    }
    public enum EMAILJAVASCRIPTMAPSTRINGS {
        fromEmail,
        toEmail,
        Subject,
        Notes,
        TemplateId,
        FromName,
        OrderId,
        OrderNo,
        AccInternalId,
        PaymentTotal,
        OppId,
        OpportunityTotal,
        OpportunityBalance,
        OrderBalance,
        PO,
        PONum
        
    }
    public enum CARDJAVASCRIPTMAPSTRINGS {
        CardNumber,
        expiryMonth,
        expiryYear,
        CVCNumber,
        CardHolderName,
        ZipCode,
        BillingAddress,
        MethodName,
        saveCard,
        selectedCardId,
        cvcNo,
        selectedCard,
        CardCode,
        accType
    }
    public enum ACCOUNTJAVASCRIPTMAPSTRINGS {
        accHolderName,
        accNumber,
        accRoutNumber,
        saveACH,
        selectedACHId,
        MethodName,
        AccountHolderName,
        Account,
        Routing
    }
    public enum RECURRINGJAVASCRIPTMAPSTRINGS {
        rrStartDate,
        rrEndDate,
        rrIndefinit,
        rrPayName,
        rrFrequency,
        rrNotes,
        SchedPayInternalId
    }
    public enum PAYMENTJAVASCRIPTMAPSTRINGS {
        SendReceiptTo,
        addEmails,
        Amount,
        Tax,
        TaxAction,
        OrderNo,
        Terminal,
        AccountId,
        AccExternalId,
        accAmount,
        accTax,
        ConExternalId,
        ConId,
        ConAmount,
        ConTax,
        paymentType,
        resResultCode,
        paymentMethodIDVar,
        resError,
        avsRefNum,
        OrderId,
        OpportunityId,
        payBy,
        isRecurring,
        CustomCustId,
        CustExternalId,
        CustAmount,
        ContactId,
        accExtrId,
        accId,
        objectName,
        OpportunityName,
        OrdersfID,
        AccInternalId
    }
    public enum IDENTICALJAVASCRIPTMAPSTRINGS {
        conExternalId,
        conAmount,
        fromName,
        OrderID
    }
    public enum EBIZWEBFORMPARAMETERS {
        Token,
        AppUser,
        PmRequestForm
    }
    public enum ASSIGNMENTSTRINGS {
        Synced,
        SalesforceApp,
        EBizCharge
    }
    public enum COMPARISONOPERATORS {
        eq,
        ne,
        gt,
        lt
    }
    public enum IDENTICALFIELDNAMES {
        SoftwareId,
        OrderID
    }
    public enum PAYMENTMETHODSTRINGS {
        CreditCard,
        ACH,
        Check,
        ExistingCard,
        NewCard,
        saveCard,
        ExistingACH,
        NewACH,
        saveACH,
        UseExistingCard,
        AddNewCard,
        savedACH,
        addNewACH,
        cc,
        MethodType,
        MethodName,
        isDefault,
        MethodID,
        DateCreated,
        isAVSCheck
    }
    public enum IDENTICALPAYMENTMETHODSTRINGS {
        ach
    }
    public enum PAYMENTTYPES {
        Sale,
        AuthOnly,
        Deposit,
        Credit,
        Check
    }
    public enum ENTITYPAYMENTSTATUS {
        Refund,
        Preauth,
        Deposit
    }
    public enum RETURNMESSAGE {
        Success,
        Error,
        statusUpdated
    }
    public enum RECEIPTPARAMETERSTRINGS {
        Email
    }
    public enum TRANSACTIONCOMMANDS {
        capture,
        Credit
    }
    public enum ENTITYSTATUS {
        Paid,
        Unpaid
    }
    public enum ORDERSTATUS {
        Draft
    }
    public enum OBJECTPAYMENTSTATUS {
        Capture
    }
    public enum CARDTYPES {
        VISA,
        MC,
        AMEX,
        DISC
    }
    public enum IDENTICALCARDTYPES {
        visa,
        master,
        american,
        discover,
        eCheck
    }
    public enum RECURRINGACTION {
        all,
        RECURRINGACTION
    }
    public enum CARDCOMPARISONSTRINGS {
        V,
        M,
        A,
        DS,
        X
    }
    public enum ACCOUNTTYPES {
        Checking,
        AccountType
    }
    public enum TRANSACTIONACTIONS {
        refund
    }
    public enum ENTITYACTIONS {
        addOrder,
        addCustomer,
        updProduct,
        updCustomer,
        addProduct,
        updOrder,
        updateCustomer
    }
    public enum AVSRESULTCODES {
        YYY,
        Y,
        YYA,
        YYD,
        YYX,
        X,
        GGG,
        D,
        NNN,
        NN,
        N,
        NYZ,
        Z,
        NYW,
        W,
        YNA,
        A,
        YNY,
        B,
        M,
        YYG,
        YGG,
        XXW,
        XXU,
        XXR,
        R,
        U,
        E,
        XXS,
        S,
        XXE,
        XXG,
        G,
        C,
        I,
        P
    }
    public enum CARDRESULTCODES {
        M,
        P
    }
    public enum LOGTYPESANDSTATUS {
        Uploaded,
        Upload,
        Error,
        Download,
        Imported
    }
    public enum CUSTOMFIELDNAMES {
        name,
        email
    }
    public enum ENTITYFIELDSMAPSTRINGS {
        Name,
        Id,
        OrderNumber,
        QuoteNumber,
        AccountId,
        ebizAmount,
        TotalAmount,
        PoNumber
    }
    public enum FILTERJAVASCRIPTMAPSTRINGS {
        InputText,
        fromDate,
        toDate,
        ViewAll
    }
    public enum PRODUCTFIELDS {
        Description,
        ProductCode,
        IsActive
    }
}