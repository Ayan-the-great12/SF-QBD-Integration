public with sharing class CalloutModelClass {
  
  public class TransactionSearchResult {
    public String ErrorsCount;
    public String TransactionsMatched;
    public CalloutModelClass.TransactionObject[] Transactions;
    public String StartIndex;
    public String SalesCount;
    public String SalesAmount;
    public String Limit_x;
    public String VoidsCount;
    public String ErrorsAmount;
    public String DeclinesCount;
    public String DeclinesAmount;
    public String CreditsCount;
    public String CreditsAmount;
    public String AuthOnlyCount;
    public String AuthOnlyAmount;
    public String TransactionsReturned;
    public String VoidsAmount;
  } 
  public class ArrayOfTransactionObject {
    public CalloutModelClass.TransactionObject[] TransactionObject;
  }
  public class TransactionObject {
    public String DateTime_x;
    public String Source;
    public CalloutModelClass.GwAddress ShippingAddress;
    public String ServerIP;
    public CalloutModelClass.TransactionResponse Response;
    public  CalloutModelClass.LineItem[] LineItems;
    public CalloutModelClass.TransactionDetail Details;
    public String User_x;
    public CalloutModelClass.FieldValue[] CustomFields;
    public String CustomerID;
    public CalloutModelClass.CreditCardData CreditCardData;
    public String ClientIP;
    public CalloutModelClass.CheckTrace CheckTrace;
    public CalloutModelClass.CheckData CheckData;
    public CalloutModelClass.GwAddress BillingAddress;
    public String AccountHolder;
    public String Status;
    public String TransactionType;
  }
  public class ApplicationData {
        public String ApplicationId;
        public String LookupKey;
        public String Base64ParametersString;
        public CalloutModelClass.SecurityToken securityToken;
        public String ApplicationDataInternalId;
    }
    public class ApplicationDataResponse{
      public String ApplicationDataInternalId;
      public String Status;
      public String StatusCode;
      public String Error;
      public String ErrorCode;
    }
    public class ApplicationTransactionResponse {
      public String ApplicationTransactionInternalId;
      public String Status;
      public String StatusCode;
      public String Error;
      public String ErrorCode;
    }
    public class ApplicationTransactionRequest {
      public String CustomerInternalId;
      public String TransactionId;
      public String TransactionTypeId;
      public String SoftwareId;
      public String LinkedToTypeId;
      public String LinkedToInternalId;
      public String LinkedToExternalUniqueId;
      public String TransactionDate;
      public String TransactionNotes;
      public String TransactionExternalReferenceNumber;
      public CalloutModelClass.EbizCustomField[] TransactionCustomFields;
    }
    public class ArrayOfEbizCustomField {
      public CalloutModelClass.EbizCustomField[] EbizCustomField;
    }
    public class CreditCardData {
      public String CAVV;
      public String Pares;
      public String MagSupport;
      public String MagStripe;
      public String InternalCardAuth;
      public String ECI;
      public String DUKPT;
      public String XID;
      public String CardType;
      public String CardPresent;
      public String CardNumber;
      public String CardExpiration;
      public String CardCode;
      public String AvsZip;
      public String AvsStreet;
      public String Signature;
      public String TermType;
    }
    public class CheckData {
      public String Account;
      public String AccountType;
      public String CheckNumber;
      public String DriversLicense;
      public String DriversLicenseState;
      public String RecordType;
      public String Routing;
      public String MICR;
      public String AuxOnUS;
      public String EpcCode;
      public String FrontImage;
      public String BackImage;
    }
    public class CheckTrace {
      public String Status;
      public String StatusCode;
      public String BankNote;
      public String Effective;
      public String Processed;
      public String Returned;
      public String ReturnCode;
      public String Reason;
      public String Settled;
      public String TrackingNum;
    }
    public class ArrayOfLineItem {
      public CalloutModelClass.LineItem[] LineItem;
    }
    public class ArrayOfFieldValue {
      public CalloutModelClass.FieldValue[] FieldValue;
    }
    public class FieldValue {
      public String Field;
      public String Value;
    }
    public class TransactionDetail {
      public String NonTax;
      public String Tax;
      public String Table;
      public String Subtotal;
      public String Shipping;
      public String ShipFromZip;
      public String SessionID;
      public String PONum;
      public String OrderID;
      public String Invoice;
      public String Duty;
      public String Discount;
      public String Comments;
      public String Description;
      public String Currency_x;
      public String Clerk;
      public String Amount;
      public String AllowPartialAuth;
      public String Terminal;
      public String Tip;
    }
    public class LineItem {
      public String DiscountRate;
      public String ProductRefNum;
      public String SKU;
      public String CommodityCode;
      public String ProductName;
      public String Description;
      public String DiscountAmount;
      public String TaxRate;
      public String UnitOfMeasure;
      public String UnitPrice;
      public String Qty;
      public String Taxable;
      public String TaxAmount;
    }
    public class GwAddress {
      public String City;
      public String Company;
      public String Country;
      public String Email;
      public String Fax;
      public String FirstName;
      public String LastName;
      public String Phone;
      public String State;
      public String Street;
      public String Street2;
      public String Zip;
    }
    public class TransactionResponse {
      public String CustNum;
      public String ResultCode;
      public String Result;
      public String RemainingBalance;
      public String RefNum;
      public String ProfilerReason;
      public String ProfilerResponse;
      public String ProfilerScore;
      public String Payload;
      public String isDuplicate;
      public String ErrorCode;
      public String Error;
      public String VpasResultCode;
      public String ConvertedAmountCurrency;
      public String ConvertedAmount;
      public String ConversionRate;
      public String CardLevelResultCode;
      public String CardLevelResult;
      public String CardCodeResultCode;
      public String CardCodeResult;
      public String BatchRefNum;
      public String BatchNum;
      public String AvsResultCode;
      public String AvsResult;
      public String AuthCode;
      public String AuthAmount;
      public String AcsUrl;
      public String Status;
      public String StatusCode;
    }
    public class CustomerTransactionRequest {
      public String isRecurring;
      public String InventoryLocation;
      public String IgnoreDuplicate;
      public CalloutModelClass.TransactionDetail Details;
      public String MerchReceiptName;
      public String MerchReceiptEmail;
      public String Software;
      public String MerchReceipt;
      public String CustReceiptName;
      public String CustReceiptEmail;
      public String CustReceipt;
      public CalloutModelClass.FieldValue[] CustomFields;
      public String ClientIP;
      public String CardCode;
      public String Command;
      public CalloutModelClass.LineItem[] LineItems;
    }
    public class GetScheduledDatesResponse {
      public String ScheduledDates;
      public String Status;
      public String StatusCode;
      public String Error;
      public String ErrorCode;
    }
    public class RecurringBilling {
      public Decimal Amount;
      public Decimal Tax;
      public Boolean Enabled;
      public String Start;
      public String Expire;
      public String Next;
      public String NumLeft;
      public Integer RepeatCount;
      public String Schedule;
      public CalloutModelClass.CustomSchedule CustomScheduleObject;
      public String ScheduleName;
      public String ReceiptNote;
      public String ReceiptTemplateName;
      public Boolean SendCustomerReceipt;
      public String CustomerEmailList;
    }
    public class ModifyScheduledRecurringPaymentStatusResponse {
        public String Status;
        public String StatusCode;
        public String Error;
        public String ErrorCode;
    }
    public class ModifyScheduledRecurringPaymentResponse {
      public String Status;
      public String StatusCode;
      public String Error;
      public String ErrorCode;
    }
    public class ArrayOfRecurringBillingDetails {
    public CalloutModelClass.RecurringBillingDetails[] RecurringBillingDetails;
    }
    public class RecurringBillingDetails {
      public String ScheduledPaymentInternalId;
      public String CustomerInternalId;
      public String CustomerId;
      public String Amount;
      public String Tax;
      public String Enabled;
      public String Start;
      public String Expire;
      public String Next;
      public String NumLeft;
      public String RepeatCount;
      public String Schedule;
      public ebizchargeServicemodelSoap.CustomSchedule CustomScheduleObject;
      public String ScheduleName;
      public String ReceiptNote;
      public String ReceiptTemplateName;
      public String SendCustomerReceipt;
      public String CustNum;
      public String PaymentMethodId;
      public String MaskedPM;
      public String PMHolderName;
      public String PMExpirationYear;
      public String PMExpirationMonth;
      public String PmType;
      public String ScheduleStatus;
      public String DateTimeCreated;
      public String DateTimeModified;
      public String CustomerFirstName;
      public String CustomerLastName;
      public String CustomerCompanyName;
      public String CustomerEmailList;
  }
    public class CustomSchedule {
      public String Interval;
      public String Frequency;
    }
    public class Customer {
      public String MerchantId;
      public String CustomerInternalId;
      public String CustomerId;
      public String FirstName;
      public String LastName;
      public String CompanyName;
      public String Phone;
      public String CellPhone;
      public String Fax;
      public String Email;
      public String WebSite;
      public CalloutModelClass.Address BillingAddress;
      public CalloutModelClass.Address ShippingAddress;
      public CalloutModelClass.EbizCustomField[] CustomerCustomFields;
      public CalloutModelClass.PaymentMethodProfile[] PaymentMethodProfile;
      public String CustomerToken;
      public String CustomerNotes;
      public String SoftwareId;
      public String CustomerLastSyncDateTime;
      public String DivisionId;
      public String DateTimeCreated;
      public String DateTimeModified;
    }
    public class PaymentMethodProfile {
      public String MethodType = '';
      public String MethodID= '';
      public String MethodName= '';
      public String SecondarySort= '';
      //change to string
      public String Created= '';
      public String Modified= '';
      public String Account= '';
      public String AccountType= '';
      public String AccountHolderName= '';
      public String DriversLicense= '';
      public String DriversLicenseState= '';
      public String RecordType= '';
      public String Routing= '';
      public String AvsStreet= '';
      public String AvsZip= '';
      public String CardCode= '';
      public String CardExpiration= '';
      public String CardNumber= '';
      public String CardType= '';
      //change to string
      public String Balance= '';
      public String MaxBalance= '';
      public String AutoReload= '';
      public String ReloadSchedule= '';
      public String ReloadThreshold= '';
      public String ReloadAmount= '';
      public String ReloadMethodID= '';
    }
    public class SecurityToken {
      public String SecurityId;
      public String UserId;
      public String Password;
    }
    public class SalesOrder {
      public String MerchantId='';
      public String CustomerId='';
      public String SubCustomerId='';
      public String SalesOrderNumber='';
      public String SalesOrderInternalId='';
      public String Date_x='';
      public String Currency_x='';
      public String Amount='';
      public String DueDate='';
      public String AmountDue='';
      public String PoNum='';
      public String DivisionId='';
      public String TypeId='';
      public String UploadedBy='';
      public String UpdatedBy='';
      public String DateUploaded='';
      public String DateUpdated='';
      public String isDeleted='';
      public String DeletedBy='';
      public String DateDeleted='';
      public CalloutModelClass.CustomItem[] Items;
      public String Software='';
      public String NotifyCustomer='';
      public String EmailTemplateID='';
      public String URL='';
      public String TotalTaxAmount='';
      public String UniqueId='';
      public String Description='';
      public CalloutModelClass.Address BillingAddress;
      public CalloutModelClass.Address ShippingAddress;
      public String CustomerMessage='';
      public String Memo='';
      public String ShipDate='';
      public String ShipVia='';
      public String SalesRepId='';
      public String TermsId='';
      public String IsToBeEmailed='';
      public String IsToBePrinted='';
      public String SalesOrderLastSyncDateTime='';
      public CalloutModelClass.EbizCustomField[] SalesOrderCustomFields;
      public String LocationId='';
    }
    public class SalesOrderResponse {
      public String SalesOrderNumber;
      public String SalesOrderInternalId;
      public String Status;
      public String StatusCode;
      public String Error;
      public String ErrorCode;
    }
    public class Address {
      public String FirstName;
      public String LastName;
      public String CompanyName;
      public String Address1;
      public String Address2;
      public String Address3;
      public String Address4;
      public String Address5;
      public String Address6;
      public String City;
      public String State;
      public String ZipCode;
      public String Country;
      //change to string
      public String IsDefault;
      public String AddressId;
    }
    public class EbizCustomField {
      public String FieldId='';
      public String FieldCaption='';
      public String FieldName='';
      public String FieldValue='';
      public String FieldType='';
      public String FieldDataType='';
      public String FieldDescription='';
    }
    public class CustomItem {
      public String ItemInternalId='';
      public String ItemId='';
      public String Name='';
      public String Description='';
      public String UnitPrice='';
      public String Qty='';
      public String Taxable='';
      public String TaxRate='';
      public String UnitOfMeasure='';
      public String TotalLineAmount='';
      public String TotalLineTax='';
      public String ItemLineNumber='';
      public String GrossPrice='';
      public String WarrantyDiscount='';
      public String SalesDiscount='';
      public String ItemClass='';
      public CalloutModelClass.EbizCustomField[] ItemCustomFields;
    }
    public class ItemDetails {
      public String ItemInternalId;
      public String ItemId;
      public String Name;
      public String SKU;
      public String UPC;
      public String Description;
      public string UnitPrice;
      public string UnitCost;
      public String UnitOfMeasure;
      public string Active;
      public String ItemType;
      public string QtyOnHand;
      public string Taxable;
      public string TaxRate;
      public String SoftwareId;
      public String ItemCategoryId;
      public String ItemNotes;
      public String DateTimeCreated;
      public String DateTimeModified;
      public String ItemUniqueId;
      public String ImageUrl;
      public String TaxCategoryID;
      public CalloutModelClass.EbizCustomField[] ItemCustomFields;
      public String ItemLastSyncDateTime;
      public String DivisionId;
      public String LocationId;
    }
    public class ItemDetailsResponse {
      public String ItemInternalId;
      public String Status;
      public String StatusCode;
      public String Error;
      public String ErrorCode;
    }
    public class MerchantTransactionData {
      public String ItemSKU;
      public String ItemCommodityCode;
      public String ItemName;
      public String ItemDescription;
      public String ItemDiscountAmount;
      public String ItemDiscountRate;
      public String ItemUnitOfMeasure;
      public String ItemUnitPrice;
      public String ItemQty;
      public String ItemTaxable;
      public String ItemTaxAmount;
      public String ItemTaxRate;
      public String DutyAmount;
      public String ShipFromZip;
      public String ShippingAmount;
      public String DiscountAmount;
      public String AvsStreet;
      public String AvsZip;
      public String AutoTax;
      public String TaxPercentage;
      public String AutoTip;
      public String TipPercentage;
      public String PreAuthPercentage;
      public String ExpireAuthAfter;
      public String AutoDiscount;
      public String AutoItemDiscount;
      public String DiscountPercentage;
      public String UseCaptureEnhancement;
      public String IsEMVEnabled;
      public String EnableAVSWarnings;
      public String EnableCVVWarnings;
      public String UseFullAmountForAVS;
      public String DeclineTransactionIfAVSWarningsAreDisabled;
      public String VerifyCreditCardBeforeSaving;
      public String AllowACHPayments;
      public String AllowCreditCardPayments;
      public String IsSurchargeEnabled;
      public String SurchargePercentage;
      public String SurchargeCaption;
    }
    public class ArrayOfPaymentMethodProfile {
      public CalloutModelClass.PaymentMethodProfile[] PaymentMethodProfiles;
   }
   public class PaymentResponse {
      public String PaymentInternalId;
      public String Status;
      public String StatusCode;
      public String Error;
      public String ErrorCode;
   }
   public class EmailReceiptResponse {
      public String Status;
      public String StatusCode;
      public String Error;
      public String ErrorCode;
   }
   public class EmailTemplate {
      public String TemplateName;
      public String TemplateInternalId;
      public String TemplateSubject;
      public String TemplateDescription;
      public String TemplateHTML;
      public String TemplateText;
      public String FromEmail;
      public String FromName;
      public String ReplyToEmail;
      public String ReplyToDisplayName;
      public String TemplateSource;
      public String TemplateTypeId;
   }
   public class Receipt {
      public String ReceiptRefNum;
      public String Name;
      public String Subject;
      public String FromEmail;
      public String Target;
      public String ContentType;
      public String TemplateHTML;
      public String TemplateText;
   }
   public class Payment {
    public String MerchantId;//not exist
    public String CustomerId;
    public String SubCustomerId;
    public String DivisionId;
    public String InvoiceNumber;
    public String InvoiceInternalId;
    public String InvoiceDate;
    public String InvoiceDueDate;
    public String PoNum;
    public String SoNum;//not exist
    public String InvoiceAmount;
    public String AmountDue;
    public String Currency_x;//not exist
    public String AuthCode;
    public String RefNum;
    public String Last4;
    public String PaymentMethod;
    public String DatePaid;
    public String PaidAmount;
    public String PaymentInternalId;
    public String ScheduledPaymentInternalId;
    public String PaymentRequestDateTime;//not exist
    public String CustNum;
    public String PaymentMethodId;
    public String PaymentType;//not exist
    public String TypeId;//not exist
    public String PaymentSourceId;//not exist
    public String TransactionLookupKey;//not exist
    public String ExternalTxnId;//not exist
    public String Description;
    public String CustomerEmailAddress;//not exist
    public String DocumentTypeId;//not exist
    public String OrderId;//not exist
   }
  
   public class ArrayOfPayment {
    public CalloutModelClass.Payment[] Payment;
   }
   public class ArrayOfReceipt {
      public CalloutModelClass.Receipt[] Receipt;
   }
   public class ArrayOfEmailTemplate {
      public CalloutModelClass.EmailTemplate[] EmailTemplate;
   }
   public class SearchFilter {
    public String FieldName;
    public String ComparisonOperator;
    public String FieldValue;
   }
   public class ArrayOfSearchFilter {
    public CalloutModelClass.SearchFilter[] SearchFilter;
   }
   public class ArrayOfSalesOrder {
    public CalloutModelClass.SalesOrder[] SalesOrder;
   }
   public class ArrayOfItemDetails {
    public CalloutModelClass.ItemDetails[] ItemDetails;
   }
   public class ArrayOfCustomer {
    public ebizchargeServicemodelSoap.Customer[] Customer;
   }
   public class CustomerListSearchResult {
    public CalloutModelClass.Customer[] CustomerList;
    public String Start;
    public String Limit_x;
    public String Count;
   }
   public class ArrayOfRecurringFrequency {
    public CalloutModelClass.RecurringFrequency[] RecurringFrequency;
   }
   public class RecurringFrequency {
    public String FrequencyInternalId;
    public String FrequencyId;
    public String FrequencyDescription;
    public String FrequencyNotes;
   }
  }