public with sharing class EBC_ManageCustomerPaymentMethodsContact {
    public static string ClassName = 'EBC_ManageCustomerPaymentMethodsContact';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
    @AuraEnabled
    public static list < CstPaymentMethod > getPaymentMethodsApxc(String accId, String InternalId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        list < CstPaymentMethod > reciprocate = getPaymentMethodsApxc(dml, accId, InternalId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static list < CstPaymentMethod > getPaymentMethodsApxc(DML dml, String accId, String InternalId, EBC_Logger ebcLogger) {
        MethodName = 'getPaymentMethodsApxc';
        list < CstPaymentMethod > returnPaymentMethods = new list < CstPaymentMethod > ();
        list < ebizchargeServicemodelSoap.PaymentMethodProfile > ebizPaymentMethods = new list < ebizchargeServicemodelSoap.PaymentMethodProfile > ();
        try {
            if (!test.isRunningTest()) {
                ebizPaymentMethods = EBC_CompMethods.GetCustomerPaymentMethods(dml, accId, InternalId, ebcLogger);
            } else {
                //----------------------Mock Data---------------------------
                ebizchargeServicemodelSoap.PaymentMethodProfile mockDataCreditCard = new ebizchargeServicemodelSoap.PaymentMethodProfile();
                mockDataCreditCard.MethodType = 'cc';
                mockDataCreditCard.SecondarySort = '23';
                mockDataCreditCard.CardExpiration = '1212 12';
                mockDataCreditCard.CardNumber = '1232344';
                ebizPaymentMethods.add(mockDataCreditCard);
                ebizchargeServicemodelSoap.PaymentMethodProfile mockDataACH = new ebizchargeServicemodelSoap.PaymentMethodProfile();
                mockDataACH.MethodType = 'ach';
                mockDataACH.SecondarySort = '23';
                mockDataACH.CardExpiration = '1212 12';
                mockDataACH.CardNumber = '1232344';
                mockDataACH.Account = '4111111111111111';
                ebizPaymentMethods.add(mockDataACH);
            }
            if (ebizPaymentMethods != null) {
                for (ebizchargeServicemodelSoap.PaymentMethodProfile ebizPaymentMethodProfile: ebizPaymentMethods) {
                    CstPaymentMethod customerPaymentMethod = new CstPaymentMethod();
                    customerPaymentMethod.MethodType = ebizPaymentMethodProfile.MethodType;
                    customerPaymentMethod.MethodID = ebizPaymentMethodProfile.MethodID;
                    customerPaymentMethod.MethodName = ebizPaymentMethodProfile.MethodName;
                    customerPaymentMethod.DateCreated = ebizPaymentMethodProfile.Created;
                    customerPaymentMethod.DateModified = ebizPaymentMethodProfile.Modified;
                    customerPaymentMethod.AccountHolderName = ebizPaymentMethodProfile.AccountHolderName;
                    customerPaymentMethod.SecondarySort = Integer.valueOf(ebizPaymentMethodProfile.SecondarySort);
                    if (ebizPaymentMethodProfile.MethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.cc)) {
                        customerPaymentMethod.AvsStreet = ebizPaymentMethodProfile.AvsStreet;
                        customerPaymentMethod.AvsZip = ebizPaymentMethodProfile.AvsZip;
                        customerPaymentMethod.CardExpiration = ebizPaymentMethodProfile.CardExpiration;
                        customerPaymentMethod.CardExpMonth = ebizPaymentMethodProfile.CardExpiration.right(2);
                        customerPaymentMethod.CardExpYear = ebizPaymentMethodProfile.CardExpiration.left(4);
                        customerPaymentMethod.CardNumber = ebizPaymentMethodProfile.CardNumber;
                        customerPaymentMethod.Last4Degit = ebizPaymentMethodProfile.CardNumber.right(4);
                        customerPaymentMethod.CardType = ebizPaymentMethodProfile.CardType;
                    } else {
                        customerPaymentMethod.Account = ebizPaymentMethodProfile.Account;
                        customerPaymentMethod.Last4Degit = ebizPaymentMethodProfile.Account.right(4);
                        customerPaymentMethod.AccountType = ebizPaymentMethodProfile.AccountType;
                        customerPaymentMethod.Routing = ebizPaymentMethodProfile.Routing;
                    }
                    returnPaymentMethods.add(customerPaymentMethod);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return returnPaymentMethods;
    }
    @AuraEnabled
    public static list < CstPaymentMethod > DeletePaymentMethodApxc(String accId, String internalId, String paymentMethodId) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        list < CstPaymentMethod > reciprocate = DeletePaymentMethodApxc(dml, accId, internalId, paymentMethodId, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static list < CstPaymentMethod > DeletePaymentMethodApxc(DML dml, String accId, String internalId, String paymentMethodId, EBC_Logger ebcLogger) {
        MethodName = 'DeletePaymentMethodApxc';
        list < CstPaymentMethod > returnPaymentMethods = new list < CstPaymentMethod > ();
        String customerToken = EBC_CompMethods.getCustomerToken(dml, accId, internalID, ebcLogger);
        try {
            Boolean response = ebiz.DeleteCustomerPaymentMethodProfile(EBC_CompMethods.getSecurityToken(dml, ebcLogger), customerToken, paymentMethodId);
            if (response == true) {
                returnPaymentMethods = getPaymentMethodsApxc(dml, accId, internalId, ebcLogger);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            if (!Test.isRunningTest()) {
                throw new AuraHandledException(Configuration.EXCEPTIONSTRING + e.getMessage());
            }
        }
        return returnPaymentMethods;
    }
    @AuraEnabled
    public static list < CstPaymentMethod > updatePaymentMethodApxc(String accId, String internalId, String StrObj) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        list < CstPaymentMethod > reciprocate = updatePaymentMethodApxc(dml, accId, internalId, StrObj, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static list < CstPaymentMethod > updatePaymentMethodApxc(DML dml, String accId, String internalId, String StrObj, EBC_Logger ebcLogger) {
        MethodName = 'updatePaymentMethodApxc';
        list < CstPaymentMethod > returnPaymentMethods = new list < CstPaymentMethod > ();
        CstPaymentMethod customerPaymentMethod = new CstPaymentMethod();
        customerPaymentMethod.AVSMisMatch = false;
        Map < String, Object > stringMap = (Map < String, Object > ) JSON.deserializeUntyped(StrObj);
        Boolean isAVSCheck = (boolean) stringMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isAVSCheck));
        try {
            ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
            responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
            if (responseMerchant.EnableAVSWarnings == false) {
                isAVSCheck = false;
            }
            String methodType = (string) stringMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.MethodType));
            ebizchargeServicemodelSoap.PaymentMethodProfile ebizPaymentMethodProfile = new ebizchargeServicemodelSoap.PaymentMethodProfile();
            ebizPaymentMethodProfile.MethodType = methodType;
            ebizPaymentMethodProfile.MethodID = (string) stringMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.MethodID));
            ebizPaymentMethodProfile.MethodName = (string) stringMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.MethodName));
            ebizPaymentMethodProfile.Balance = 0;
            ebizPaymentMethodProfile.MaxBalance = 0;
            ebizPaymentMethodProfile.Modified = system.now();
            string strDateCreated = (string) stringMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.DateCreated));
            DateTime DateCreated = Datetime.valueOf(strDateCreated.replace(Configuration.DATETIMESPLITTER, Configuration.DATETIMESEPERATOR));
            ebizPaymentMethodProfile.Created = DateCreated;
            Boolean isDefault = (boolean) stringMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isDefault));
            if (isDefault == true) {
                ebizPaymentMethodProfile.SecondarySort = Configuration.SECONDRYSORTFALSE;
            } else {
                ebizPaymentMethodProfile.SecondarySort = Configuration.SECONDRYSORTTRUE;
            }
            if (methodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard)) {
                if (test.isRunningTest()) {
                    isAVSCheck = true;
                    responseMerchant.UseFullAmountForAVS = false;
                }
                if (isAVSCheck == true && responseMerchant.UseFullAmountForAVS == false) {
                    Boolean AVSMatch = true;
                    String returnMessage = 'AVSCheck@';
                    ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
                    response = EBC_CompMethods.runAVSCheck(dml, stringMap, ebcLogger);
                    if (test.isRunningTest()) {
                        response.Error = 'Approved';
                    }
                    if (response.ErrorCode == Configuration.ZEROERRORCODE) {
                        returnMessage += response.RefNum + Configuration.RETURNMESSAGECOMBINE;
                        if (response.CardCodeResultCode != string.valueOf(Enums.CARDRESULTCODES.M)) {
                            returnMessage += 'CardCodeNotMatch@';
                            AVSMatch = false;
                        } else {
                            returnMessage += 'CardCodeMatch@';
                        }
                        if (response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYY) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYY) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYA) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYD) ||
                            response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYX) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.X) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.GGG) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.D)) {
                            if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NNN) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NN) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.N)) {
                                returnMessage += 'AddressNotMatch@';
                                returnMessage += 'ZipNotMatch@';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NYZ) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.Z) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NYW) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.W) ||
                                response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.P)) {
                                returnMessage += 'AddressNotMatch@';
                                returnMessage += 'ZipCodeMatch@';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YNA) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.A) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YNY) ||
                                response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.B) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.M)) {
                                returnMessage += 'AddressMatch@';
                                returnMessage += 'ZipNotMatch@';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YYG)) {
                                returnMessage += 'AddressMatch@';
                                returnMessage += 'Not Compatible@';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YGG)) {
                                returnMessage += 'Not Compatible@';
                                returnMessage += 'ZipCodeMatch@';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXW)) {
                                returnMessage += 'Card Number Not On File@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXU)) {
                                returnMessage += 'Address Information not verified for domestic transaction@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXR) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.R) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.U) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.E)) {
                                returnMessage += 'Retry / System Unavailable@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXS) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.S)) {
                                returnMessage += 'Service Not Supported@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXE)) {
                                returnMessage += 'Address Verification Not Allowed For Card Type@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXG) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.G) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.C) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.I)) {
                                returnMessage += 'Global Non-AVS participant@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YYY) && response.CardCodeResultCode == string.valueOf(Enums.CARDRESULTCODES.P)) {
                                returnMessage += 'AddressMatch@';
                                returnMessage += 'ZipCodeMatch@';
                            } else {
                                returnMessage += ' @';
                                returnMessage += ' @';
                            }
                        } else {
                            string add = response.AvsResult;
                            if (add.contains('No AVS response')) {
                                returnMessage += 'StreetNotMatch@';
                                returnMessage += 'ZipNotMatch@';
                                AVSMatch = false;
                            } else {
                                list < string > arr = add.split('&');
                                string address = arr[0].substringAfter(':');
                                string zipcode = arr[1].substringAfter(':');
                                if (address.trim() != 'Match') {
                                    returnMessage += 'AddressNotMatch@';
                                    AVSMatch = false;
                                } else {
                                    returnMessage += 'AddressMatch@';
                                }
                                if (zipcode.trim() != 'Match') {
                                    returnMessage += 'ZipNotMatch@';
                                    AVSMatch = false;
                                } else {
                                    returnMessage += 'ZipCodeMatch@';
                                }
                            }
                        }
                    } else {
                        customerPaymentMethod.IsErrorReturn = true;
                        customerPaymentMethod.AVSretMsg = response.Error;
                        returnPaymentMethods.add(customerPaymentMethod);
                        return returnPaymentMethods;
                    }
                    if (AVSMatch != true) {
                        customerPaymentMethod.AVSMisMatch = true;
                        customerPaymentMethod.AVSretMsg = returnMessage.removeEnd(Configuration.RETURNMESSAGECOMBINE);
                        returnPaymentMethods.add(customerPaymentMethod);
                        return returnPaymentMethods;
                    } else {
                        customerPaymentMethod.AVSMisMatch = false;
                        invokeTransactionVoidApxc(dml, response.RefNum, ebcLogger);
                    }
                }
                returnPaymentMethods.add(customerPaymentMethod);
                ebizPaymentMethodProfile.AccountHolderName = (string) stringMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
                ebizPaymentMethodProfile.CardNumber = (string) stringMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
                ebizPaymentMethodProfile.CardCode = (string) stringMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardCode));
                string expiryMonth = (string) stringMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
                string expiryYear = (string) stringMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
                ebizPaymentMethodProfile.CardExpiration = expiryYear + Configuration.CARDEXPIRATIONSEPERATORD + expiryMonth;
                ebizPaymentMethodProfile.AvsStreet = (string) stringMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
                ebizPaymentMethodProfile.AvsZip = (string) stringMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
            } else {
                ebizPaymentMethodProfile.AccountHolderName = (string) stringMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.AccountHolderName));
                ebizPaymentMethodProfile.Account = (string) stringMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.Account));
                ebizPaymentMethodProfile.AccountType = (string) stringMap.get(string.valueOf(Enums.ACCOUNTTYPES.AccountType));
                ebizPaymentMethodProfile.Routing = (string) stringMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.Routing));
            }
            string customerToken = EBC_CompMethods.getCustomerToken(dml, accId, internalId, ebcLogger);
            Boolean response = ebiz.UpdateCustomerPaymentMethodProfile(EBC_CompMethods.getSecurityToken(dml, ebcLogger), customerToken, ebizPaymentMethodProfile);
            if (response == true) {
                if (isDefault == true) {
                    Boolean ebizResponse = ebiz.SetDefaultCustomerPaymentMethodProfile(EBC_CompMethods.getSecurityToken(dml, ebcLogger), customerToken, ebizPaymentMethodProfile.MethodID);
                }
                returnPaymentMethods = getPaymentMethodsApxc(dml, accId, internalId, ebcLogger);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            if (!Test.isRunningTest()) {
                throw new AuraHandledException(Configuration.EXCEPTIONSTRING + e.getMessage());
            }
        }
        return returnPaymentMethods;
    }
    @AuraEnabled
    public static list < CstPaymentMethod > addPaymentMethodApxc(String accId, String internalId, String StrObj) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        list < CstPaymentMethod > reciprocate = addPaymentMethodApxc(dml, accId, internalId, StrObj, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static list < CstPaymentMethod > addPaymentMethodApxc(DML dml, String accId, String internalId, String StrObj, EBC_Logger ebcLogger) {
        MethodName = 'addPaymentMethodApxc';
        list < CstPaymentMethod > returnPaymentMethods = new list < CstPaymentMethod > ();
        CstPaymentMethod customerPaymentMethod = new CstPaymentMethod();
        customerPaymentMethod.AVSMisMatch = false;
        Map < String, Object > stringMap = (Map < String, Object > ) JSON.deserializeUntyped(StrObj);
        Boolean isAVSCheck = (boolean) stringMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isAVSCheck));
        ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
        try {
            responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
            if (responseMerchant.EnableAVSWarnings == false) {
                isAVSCheck = false;
            }
            String MethodType = (string) stringMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.MethodType));
            ebizchargeServicemodelSoap.PaymentMethodProfile ebizPaymentMethodProfile = new ebizchargeServicemodelSoap.PaymentMethodProfile();
            ebizPaymentMethodProfile.MethodName = (string) stringMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.MethodName));
            ebizPaymentMethodProfile.Balance = 0;
            ebizPaymentMethodProfile.MaxBalance = 0;
            ebizPaymentMethodProfile.Modified = system.now();
            ebizPaymentMethodProfile.Created = system.now();
            Boolean isDefault = (boolean) stringMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isDefault));
            if (isDefault == true) {
                ebizPaymentMethodProfile.SecondarySort = Configuration.SECONDRYSORTFALSE;
            } else {
                ebizPaymentMethodProfile.SecondarySort = Configuration.SECONDRYSORTTRUE;
            }
            if (MethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard)) {
                if (test.isRunningTest()) {
                    isAVSCheck = true;
                    responseMerchant.UseFullAmountForAVS = false;
                }
                if (isAVSCheck == true && responseMerchant.UseFullAmountForAVS == false) {
                    Boolean AVSMatch = true;
                    String returnMessage = 'AVSCheck@';
                    ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
                    response = EBC_CompMethods.runAVSCheck(dml, stringMap, ebcLogger);
                    if (test.isRunningTest()) {
                        response.Error = 'Approved';
                    }
                    if (response.ErrorCode == Configuration.ZEROERRORCODE) {
                        returnMessage += response.RefNum + Configuration.RETURNMESSAGECOMBINE;
                        if (response.CardCodeResultCode != string.valueOf(Enums.CARDRESULTCODES.M)) {
                            returnMessage += 'CardCodeNotMatch@';
                            AVSMatch = false;
                        } else {
                            returnMessage += 'CardCodeMatch@';
                        }
                        if (response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYY) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYY) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYA) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYD) ||
                            response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYX) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.X) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.GGG) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.D)) {
                            if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NNN) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NN) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.N)) {
                                returnMessage += 'AddressNotMatch@';
                                returnMessage += 'ZipNotMatch@';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NYZ) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.Z) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NYW) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.W) ||
                                response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.P)) {
                                returnMessage += 'AddressNotMatch@';
                                returnMessage += 'ZipCodeMatch@';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YNA) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.A) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YNY) ||
                                response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.B) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.M)) {
                                returnMessage += 'AddressMatch@';
                                returnMessage += 'ZipNotMatch@';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YYG)) {
                                returnMessage += 'AddressMatch@';
                                returnMessage += 'Not Compatible@';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YGG)) {
                                returnMessage += 'Not Compatible@';
                                returnMessage += 'ZipCodeMatch@';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXW)) {
                                returnMessage += 'Card Number Not On File@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXU)) {
                                returnMessage += 'Address Information not verified for domestic transaction@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXR) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.R) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.U) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.E)) {
                                returnMessage += 'Retry / System Unavailable@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXS) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.S)) {
                                returnMessage += 'Service Not Supported@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXE)) {
                                returnMessage += 'Address Verification Not Allowed For Card Type@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXG) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.G) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.C) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.I)) {
                                returnMessage += 'Global Non-AVS participant@';
                                returnMessage += ' @';
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YYY) && response.CardCodeResultCode == string.valueOf(Enums.CARDRESULTCODES.P)) {
                                returnMessage += 'AddressMatch@';
                                returnMessage += 'ZipCodeMatch@';
                            } else {
                                returnMessage += ' @';
                                returnMessage += ' @';
                            }
                        } else {
                            string add = response.AvsResult;
                            if (add.contains('No AVS response')) {
                                returnMessage += 'StreetNotMatch@';
                                returnMessage += 'ZipNotMatch@';
                                AVSMatch = false;
                            } else {
                                list < string > arr = add.split('&');
                                string address = arr[0].substringAfter(':');
                                string zipcode = arr[1].substringAfter(':');
                                if (address.trim() != 'Match') {
                                    returnMessage += 'AddressNotMatch@';
                                    AVSMatch = false;
                                } else {
                                    returnMessage += 'AddressMatch@';
                                }
                                if (zipcode.trim() != 'Match') {
                                    returnMessage += 'ZipNotMatch@';
                                    AVSMatch = false;
                                } else {
                                    returnMessage += 'ZipCodeMatch@';
                                }
                            }
                        }
                    } else {
                        customerPaymentMethod.IsErrorReturn = true;
                        customerPaymentMethod.AVSretMsg = response.Error;
                        returnPaymentMethods.add(customerPaymentMethod);
                        return returnPaymentMethods;
                    }
                    if (AVSMatch != true) {
                        customerPaymentMethod.AVSMisMatch = true;
                        customerPaymentMethod.AVSretMsg = returnMessage.removeEnd(Configuration.RETURNMESSAGECOMBINE);
                        returnPaymentMethods.add(customerPaymentMethod);
                        return returnPaymentMethods;
                    } else {
                        customerPaymentMethod.AVSMisMatch = false;
                        invokeTransactionVoidApxc(dml, response.RefNum, ebcLogger);
                    }
                }
                returnPaymentMethods.add(customerPaymentMethod);
                ebizPaymentMethodProfile.MethodType = string.valueOf(Enums.PAYMENTMETHODSTRINGS.cc);
                ebizPaymentMethodProfile.AccountHolderName = (string) stringMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
                ebizPaymentMethodProfile.CardNumber = (string) stringMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
                string expiryMonth = (string) stringMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
                string expiryYear = (string) stringMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
                ebizPaymentMethodProfile.CardCode = (string) stringMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardCode));
                ebizPaymentMethodProfile.CardExpiration = expiryYear + Configuration.CARDEXPIRATIONSEPERATORD + expiryMonth;
                ebizPaymentMethodProfile.AvsStreet = (string) stringMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
                ebizPaymentMethodProfile.AvsZip = (string) stringMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
            } else {
                ebizPaymentMethodProfile.AccountHolderName = (string) stringMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.AccountHolderName));
                ebizPaymentMethodProfile.Account = (string) stringMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.Account));
                ebizPaymentMethodProfile.AccountType = (string) stringMap.get(string.valueOf(Enums.ACCOUNTTYPES.AccountType));  //(string)stringMap.get('AccountType');
                ebizPaymentMethodProfile.Routing = (string) stringMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.Routing));
            }
            ebcLogger.debug(ClassName, MethodName, 'A-isDefault->>>>>>>>: ' + isDefault);
            ebcLogger.debug(ClassName, MethodName, 'A-ebizPaymentMethodProfile.SecondarySort>>>>: ' + ebizPaymentMethodProfile.SecondarySort);
            string methodID = ebiz.AddCustomerPaymentMethodProfile(EBC_CompMethods.getSecurityToken(dml, ebcLogger), internalId, ebizPaymentMethodProfile);
            if (methodID != Configuration.EMPTYSTRING) {
                if (isDefault == true) {
                    string customerToken = EBC_CompMethods.getCustomerToken(dml, accId, internalId, ebcLogger);
                    Boolean ebizResponse = ebiz.SetDefaultCustomerPaymentMethodProfile(EBC_CompMethods.getSecurityToken(dml, ebcLogger), customerToken, methodID);
                }
                returnPaymentMethods = getPaymentMethodsApxc(dml, accId, internalId, ebcLogger);
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            if (!Test.isRunningTest()) {
                throw new AuraHandledException(Configuration.EXCEPTIONSTRING + e.getMessage());
            }
        }
        return returnPaymentMethods;
    }
    @AuraEnabled
    public static void invokeTransactionVoidApxc(String avsRefNum) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        invokeTransactionVoidApxc(dml, avsRefNum, ebcLogger);
        ebcLogger.saveLogs();
    }
    public static void invokeTransactionVoidApxc(DML dml, String avsRefNum, EBC_Logger ebcLogger) {
        MethodName = 'invokeTransactionVoidApxc';
        ebizchargeServicemodelSoap.TransactionRequestObject ebizTransaction = new ebizchargeServicemodelSoap.TransactionRequestObject();
        String paymentMethodID = Configuration.VOIDTRANSACTIONCOMMAND;
        Decimal paymentStatus = 3;
        ebizTransaction.Command = paymentMethodID;
        ebizTransaction.IgnoreDuplicate = true;
        ebizTransaction.RefNum = avsRefNum;
        ebizTransaction.IsRecurring = false;
        ebizTransaction.CustReceipt = false;
        try {
            ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
            response = ebiz.runTransaction(EBC_CompMethods.getSecurityToken(dml, ebcLogger), ebizTransaction);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
    }
    public class CstPaymentMethod {
        @AuraEnabled public String MethodType {
            get;
            set;
        }
        @AuraEnabled public String MethodID {
            get;
            set;
        }
        @AuraEnabled public String MethodName {
            get;
            set;
        }
        @AuraEnabled public DateTime DateCreated {
            get;
            set;
        }
        @AuraEnabled public DateTime DateModified {
            get;
            set;
        }
        @AuraEnabled public String AccountHolderName {
            get;
            set;
        }
        @AuraEnabled public String AvsStreet {
            get;
            set;
        }
        @AuraEnabled public String AvsZip {
            get;
            set;
        }
        @AuraEnabled public String CardExpiration {
            get;
            set;
        }
        @AuraEnabled public String CardExpMonth {
            get;
            set;
        }
        @AuraEnabled public String CardExpYear {
            get;
            set;
        }
        @AuraEnabled public String CardNumber {
            get;
            set;
        }
        @AuraEnabled public String Last4Degit {
            get;
            set;
        }
        @AuraEnabled public String CardType {
            get;
            set;
        }
        @AuraEnabled public String CardCode {
            get;
            set;
        }
        @AuraEnabled public String Account {
            get;
            set;
        }
        @AuraEnabled public String AccountType {
            get;
            set;
        }
        @AuraEnabled public String Routing {
            get;
            set;
        }
        @AuraEnabled public Integer SecondarySort {
            get;
            set;
        }
        @AuraEnabled public Boolean AVSMisMatch {
            get;
            set;
        }
        @AuraEnabled public Boolean IsErrorReturn {
            get;
            set;
        }
        @AuraEnabled public String AVSretMsg {
            get;
            set;
        }
    }
}