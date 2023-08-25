public with sharing class EBC_ManageCustomerPaymentMethods {
    public static string ClassName = 'EBC_ManageCustomerPaymentMethods';
    public static string MethodName = Configuration.EMPTYSTRING;
    public static ebizchargeServicemodelSoap.eBizService ebiz = new ebizchargeServicemodelSoap.eBizService();
    @AuraEnabled
    public static EBC_ComponentController.Detail getDetailApxc(String recordId, String ObjectName) {
        DML dml = new DML();
        if (test.isRunningTest()) {
            dml = (DML) MockUtil.createMock(DML.class);
        }
        EBC_Logger ebcLogger = new EBC_Logger();
        EBC_ComponentController.Detail reciprocate = getDetailApxcV2(dml, recordId, ObjectName, ebcLogger);
        ebcLogger.saveLogs();
        return reciprocate;
    }
    public static EBC_ComponentController.Detail getDetailApxcV2(DML dml, String recordId, String ObjectName, EBC_Logger ebcLogger) {
        MethodName = 'getDetailApxcV2';
        return EBC_ComponentController.getDetailApxc(dml, recordId, ObjectName, ebcLogger);
    }
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
        list < CstPaymentMethod > retList = new list < CstPaymentMethod > ();
        list < ebizchargeServicemodelSoap.PaymentMethodProfile > pmList = new list < ebizchargeServicemodelSoap.PaymentMethodProfile > ();
        try {
            if (!test.isRunningTest()) {
                String querySelect = 'select id,QBD_Customer_ID__c';
                String queryFrom = 'from Account';
                String queryWhere =  'where id=\''+accId+'\'';
                Account account = (Account)dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
                pmList = EBC_CompMethods.GetCustomerPaymentMethods(dml,(string)account.get('QBD_Customer_ID__c'), InternalId, ebcLogger);
            } else {
                ebizchargeServicemodelSoap.PaymentMethodProfile TestDATA = new ebizchargeServicemodelSoap.PaymentMethodProfile();
                TestDATA.MethodType = 'cc';
                TestDATA.SecondarySort = '23';
                TestDATA.CardExpiration = '1212 12';
                TestDATA.CardNumber = '1232344';
                pmList.add(TestDATA);
                ebizchargeServicemodelSoap.PaymentMethodProfile TestDATA2 = new ebizchargeServicemodelSoap.PaymentMethodProfile();
                TestDATA2.MethodType = 'ach';
                TestDATA2.SecondarySort = '23';
                TestDATA2.CardExpiration = '1212 12';
                TestDATA2.CardNumber = '1232344';
                TestDATA2.Account = '4111111111111111';
                pmList.add(TestDATA2);
            }
            if (pmList != null) {
                for (ebizchargeServicemodelSoap.PaymentMethodProfile pp: pmList) {
                    CstPaymentMethod obj = new CstPaymentMethod();
                    obj.MethodType = pp.MethodType;
                    obj.MethodID = pp.MethodID;
                    obj.MethodName = pp.MethodName;
                    obj.DateCreated = pp.Created;
                    obj.DateModified = pp.Modified;
                    obj.AccountHolderName = pp.AccountHolderName;
                    obj.SecondarySort = Integer.valueOf(pp.SecondarySort);
                    if (pp.MethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.cc)) {
                        obj.AvsStreet = pp.AvsStreet;
                        obj.AvsZip = pp.AvsZip;
                        obj.CardExpiration = pp.CardExpiration;
                        obj.CardExpMonth = pp.CardExpiration.right(2);
                        obj.CardExpYear = pp.CardExpiration.left(4);
                        obj.CardNumber = pp.CardNumber;
                        obj.Last4Degit = pp.CardNumber.right(4);
                        obj.CardType = pp.CardType;
                    } else {
                        obj.Account = pp.Account;
                        obj.Last4Degit = pp.Account.right(4);
                        obj.AccountType = pp.AccountType;
                        obj.Routing = pp.Routing;
                    }
                    retList.add(obj);
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        return retList;
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
        list < CstPaymentMethod > retList = new list < CstPaymentMethod > ();
        Boolean checkCustomer = true;
        string customerToken;
        ebizchargeServicemodelSoap.Customer response = new ebizchargeServicemodelSoap.Customer();
        ebizchargeServicemodelSoap.CustomerResponse customerResponse = new ebizchargeServicemodelSoap.CustomerResponse();
        Account accountDetail = EBC_CompMethods.getAccountDetail(dml, accId, ebcLogger);
        if(accountDetail.EBizCharge_Internal_ID__c != null){
            //GetCustomer on the basis of Internal Id
        try{
            //internal id is changed -----> exception
            response = ebiz.GetCustomer(eBc_UtilityController.getSecurityToken(dml, ebcLogger),Configuration.EMPTYSTRING,accountDetail.EBizCharge_Internal_ID__c);
            //else update on the basis of Internal Id
            if(response.CustomerInternalId != null){
                //Update Api Call
                customerResponse = eBc_UtilityController.invoke_addORUpdCustomerQBD(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger),'',string.valueOf(Enums.ENTITYACTIONS.updateCustomer), ebcLogger);
                customerToken = EBC_CompMethods.getCustomerToken(dml,Configuration.EMPTYSTRING, response.CustomerInternalId, ebcLogger);
                checkCustomer = true;
            }    
        }catch(Exception e){
            //get customer on the basis of QBD ------> if its changed or not?
            try{ 
                //if QBD id is not changed------> get a 200 status code
            response = ebiz.GetCustomer(eBc_UtilityController.getSecurityToken(dml, ebcLogger),(String)accountDetail.get('QBD_Customer_ID__c'),Configuration.EMPTYSTRING);
            if(response.CustomerInternalId != null){
                //Update Api Call
                accountDetail.EBizCharge_Internal_ID__c = response.CustomerInternalId;
                customerResponse = eBc_UtilityController.invoke_addORUpdCustomerQBD(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger),'',string.valueOf(Enums.ENTITYACTIONS.updateCustomer), ebcLogger);
                customerToken = EBC_CompMethods.getCustomerToken(dml,(string)accountDetail.get('QBD_Customer_ID__c'),Configuration.EMPTYSTRING, ebcLogger);
                checkCustomer = true;
            }
            }catch(exception error){
                //else changed ------> not found 500 status code
                customerResponse = eBc_UtilityController.invoke_addORUpdCustomerQBD(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger),'',string.valueOf(Enums.ENTITYACTIONS.addCustomer), ebcLogger);
                accountDetail.EBizCharge_Internal_ID__c = response.CustomerInternalId;
                checkCustomer = false;
            }
        }    
        }
        try {
            if(checkCustomer){
                Boolean apiResponse = ebiz.DeleteCustomerPaymentMethodProfile(EBC_CompMethods.getSecurityToken(dml, ebcLogger), customerToken, paymentMethodId);
                if (apiResponse == true) {
                    retList = getPaymentMethodsApxc(dml, (string)accountDetail.get('QBD_Customer_ID__c'), internalId, ebcLogger);
                } 
            }
            dml.upsertRecord(accountDetail);
        } catch (Exception e) {
            if (!Test.isRunningTest()) {
                ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            }
        }
        return retList;
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
        Boolean checkCustomer = true;
        list < CstPaymentMethod > retList = new list < CstPaymentMethod > ();
        CstPaymentMethod obj = new CstPaymentMethod();
        obj.AVSMisMatch = false;
        Map < String, Object > objMap = (Map < String, Object > ) JSON.deserializeUntyped(StrObj);
        Boolean isAVSCheck = (boolean) objMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isAVSCheck));
        try {
            ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
            responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
            if (responseMerchant.EnableAVSWarnings == false) {
                isAVSCheck = false;
            }
            String MethodType = (string) objMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.MethodType));
            ebizchargeServicemodelSoap.PaymentMethodProfile paymentMethod = new ebizchargeServicemodelSoap.PaymentMethodProfile();
            paymentMethod.MethodType = MethodType;
            paymentMethod.MethodID = (string) objMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.MethodID));
            paymentMethod.MethodName = (string) objMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.MethodName));
            paymentMethod.Balance = 0;
            paymentMethod.MaxBalance = 0;
            paymentMethod.Modified = system.now();
            string strDateCreated = (string) objMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.DateCreated));
            DateTime DateCreated = Datetime.valueOf(strDateCreated.replace(Configuration.DATETIMESPLITTER, Configuration.DOUBLEBLANKS));
            paymentMethod.Created = DateCreated;
            Boolean isDefault = (boolean) objMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isDefault));
            if (isDefault == true) {
                paymentMethod.SecondarySort = Configuration.STARTINDEX;
            } else {
                paymentMethod.SecondarySort = Configuration.CARDMETHODID;
            }
            if (MethodType == string.valueOf(Enums.PAYMENTMETHODSTRINGS.CreditCard)) {
                if (test.isRunningTest()) {
                    isAVSCheck = true;
                    responseMerchant.UseFullAmountForAVS = false;
                }
                if (isAVSCheck == true && responseMerchant.UseFullAmountForAVS == false) {
                    Boolean AVSMatch = true;
                    String retMsg = Configuration.AVSCHECKSTRING;
                    ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
                    response = EBC_CompMethods.runAVSCheck(dml, objMap, ebcLogger);
                    if (test.isRunningTest()) {
                        response.Error = Configuration.APPROVED;
                    }
                    if (response.ErrorCode == Configuration.STARTINDEX) {
                        retMsg += response.RefNum + Configuration.KEYSPLITTER;
                        if (response.CardCodeResultCode != Configuration.CARDCODERESULTCODE) {
                            retMsg += Configuration.CARDCODENOTMATCH;
                            AVSMatch = false;
                        } else {
                            retMsg += Configuration.CARDCODEMATCH;
                        }
                        if (response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYY) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.Y) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYA) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYD) ||
                            response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYX) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.X) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.GGG) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.D)) {
                            if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NNN) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NN) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.N)) {
                                retMsg += Configuration.ADDRESSNOTMATCH;
                                retMsg += Configuration.ZIPNOTMATCH;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NYZ) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.Z) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NYW) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.W) ||
                                response.AvsResultCode == Configuration.AVSRESULTCODE) {
                                retMsg += Configuration.ADDRESSNOTMATCH;
                                retMsg += Configuration.ZIPNOTMATCH;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YNA) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.A) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YNY) ||
                                response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.B) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.M)) {
                                retMsg += Configuration.ADDRESSMATCH;
                                retMsg += Configuration.ZIPNOTMATCH;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YYG)) {
                                retMsg += Configuration.ADDRESSMATCH;
                                retMsg += Configuration.NOTCOMPATIBLE;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YGG)) {
                                retMsg += Configuration.NOTCOMPATIBLE;
                                retMsg += Configuration.ZIPMATCH;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXW)) {
                                retMsg += Configuration.CARDNUMBERNOTFOUND;
                                retMsg += Configuration.KEYSPLITTERWITHSPACE;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXU)) {
                                retMsg += Configuration.ADDRESSINFOVERIFICATION;
                                retMsg += Configuration.KEYSPLITTERWITHSPACE;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXR) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.R) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.U) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.E)) {
                                retMsg += Configuration.RETRY;
                                retMsg += Configuration.KEYSPLITTERWITHSPACE;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXS) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.S)) {
                                retMsg += Configuration.SERVICENOTSUPPORTED;
                                retMsg += Configuration.KEYSPLITTERWITHSPACE;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXE)) {
                                retMsg += Configuration.ADDRESSVERIFICATION;
                                retMsg += Configuration.KEYSPLITTERWITHSPACE;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXG) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.G) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.C) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.I)) {
                                retMsg += Configuration.GLOBALAVS;
                                retMsg += Configuration.KEYSPLITTERWITHSPACE;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YYY) && response.CardCodeResultCode == string.valueOf(Enums.AVSRESULTCODES.P)) {
                                retMsg += Configuration.ADDRESSMATCH;
                                retMsg += Configuration.ZIPCODEMATCH;
                            } else {
                                retMsg += Configuration.KEYSPLITTERWITHSPACE;
                                retMsg += Configuration.KEYSPLITTERWITHSPACE;
                            }
                        } else {
                            string add = response.AvsResult;
                            if (add.contains(Configuration.NOAVSRESPONSE)) {
                                retMsg += Configuration.STREETNOTMATCH;
                                retMsg += Configuration.ZIPNOTMATCH;
                                AVSMatch = false;
                            } else {
                                list < string > arr = add.split(Configuration.KEYSPLITTERWITHAMPERCENT);
                                string address = arr[0].substringAfter(Configuration.SUBSTRINGSPLIITTER);
                                string zipcode = arr[1].substringAfter(Configuration.SUBSTRINGSPLIITTER);
                                if (address.trim() != Configuration.MATCHCHECK) {
                                    retMsg += Configuration.ADDRESSNOTMATCH;
                                    AVSMatch = false;
                                } else {
                                    retMsg += Configuration.ADDRESSMATCH;
                                }
                                if (zipcode.trim() != Configuration.MATCHCHECK) {
                                    retMsg += Configuration.ZIPNOTMATCH;
                                    AVSMatch = false;
                                } else {
                                    retMsg += Configuration.ZIPCODEMATCH;
                                }
                            }
                        }
                    } else {
                        obj.IsErrorReturn = true;
                        obj.AVSretMsg = response.Error;
                        retList.add(obj);
                        return retList;
                    }
                    if (AVSMatch != true) {
                        obj.AVSMisMatch = true;
                        obj.AVSretMsg = retMsg.removeEnd(Configuration.KEYSPLITTER);
                        retList.add(obj);
                        return retList;
                    } else {
                        obj.AVSMisMatch = false;
                        invokeTransactionVoidApxc(dml, response.RefNum, ebcLogger);
                    }
                }
                retList.add(obj);
                paymentMethod.AccountHolderName = (string) objMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
                paymentMethod.CardNumber = (string) objMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
                paymentMethod.CardCode = (string) objMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardCode));
                string month_x = (string) objMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
                string year_x = (string) objMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
                paymentMethod.CardExpiration = year_x + Configuration.KEYSPLITTERWITHDASH + month_x;
                paymentMethod.AvsStreet = (string) objMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
                paymentMethod.AvsZip = (string) objMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
            } else {
                paymentMethod.AccountHolderName = (string) objMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.AccountHolderName));
                paymentMethod.Account = (string) objMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.Account));
                paymentMethod.AccountType = (string) objMap.get(string.valueOf(Enums.ACCOUNTTYPES.AccountType));
                paymentMethod.Routing = (string) objMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.Routing));
            }
            string customerToken;
            ebizchargeServicemodelSoap.Customer response = new ebizchargeServicemodelSoap.Customer();
            ebizchargeServicemodelSoap.CustomerResponse customerResponse = new ebizchargeServicemodelSoap.CustomerResponse();
            Account accountDetail = EBC_CompMethods.getAccountDetail(dml, accId, ebcLogger);
            if(accountDetail.EBizCharge_Internal_ID__c != null){
                //GetCustomer on the basis of Internal Id
            try{
                //internal id is changed -----> exception
                response = ebiz.GetCustomer(eBc_UtilityController.getSecurityToken(dml, ebcLogger),Configuration.EMPTYSTRING,accountDetail.EBizCharge_Internal_ID__c);
                //else update on the basis of Internal Id
                if(response.CustomerInternalId != null){
                    //Update Api Call
                    customerResponse = eBc_UtilityController.invoke_addORUpdCustomerQBD(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger),'',string.valueOf(Enums.ENTITYACTIONS.updateCustomer), ebcLogger);
                    customerToken = EBC_CompMethods.getCustomerToken(dml,Configuration.EMPTYSTRING, response.CustomerInternalId, ebcLogger);
                    checkCustomer = true;
                }    
            }catch(Exception e){
                //get customer on the basis of QBD ------> if its changed or not?
                try{ 
                    //if QBD id is not changed------> get a 200 status code
                response = ebiz.GetCustomer(eBc_UtilityController.getSecurityToken(dml, ebcLogger),(String)accountDetail.get('QBD_Customer_ID__c'),Configuration.EMPTYSTRING);
                if(response.CustomerInternalId != null){
                    //Update Api Call
                    accountDetail.EBizCharge_Internal_ID__c = response.CustomerInternalId;
                    customerResponse = eBc_UtilityController.invoke_addORUpdCustomerQBD(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger),'',string.valueOf(Enums.ENTITYACTIONS.updateCustomer), ebcLogger);
                    customerToken = EBC_CompMethods.getCustomerToken(dml,(string)accountDetail.get('QBD_Customer_ID__c'),Configuration.EMPTYSTRING, ebcLogger);
                    checkCustomer = true;
                }
                }catch(exception error){
                    //else changed ------> not found 500 status code
                    customerResponse = eBc_UtilityController.invoke_addORUpdCustomerQBD(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger),'',string.valueOf(Enums.ENTITYACTIONS.addCustomer), ebcLogger);
                    accountDetail.EBizCharge_Internal_ID__c = response.CustomerInternalId;
                    checkCustomer = false;
                }
            }    
            }
            if(checkCustomer){
                Boolean apiResponse = ebiz.UpdateCustomerPaymentMethodProfile(EBC_CompMethods.getSecurityToken(dml, ebcLogger), customerToken, paymentMethod);
                if (apiResponse == true) {
                    if (isDefault == true) {
                        Boolean UpProfileRes = ebiz.SetDefaultCustomerPaymentMethodProfile(EBC_CompMethods.getSecurityToken(dml, ebcLogger), customerToken, paymentMethod.MethodID);
                    }
                    retList = getPaymentMethodsApxc(dml, accId, internalId, ebcLogger);
                }
            }
            dml.upsertRecord(accountDetail);
        } catch (Exception e) {
            if (!Test.isRunningTest()) {
                throw new AuraHandledException(Configuration.EXCEPTIONSTRING + e.getMessage());
            }
        }
        return retList;
    }
    public static Map < String, String > avsMatchConditionCheck(ebizchargeServicemodelSoap.TransactionResponse response, EBC_Logger ebcLogger) {
        MethodName = 'avsMatchConditionCheck';
        ebcLogger.debug(ClassName, MethodName, 'response.AvsResultCode 1--> ' + response.AvsResultCode);
        String AVSMatch = Configuration.AVSMATCHTRUE;
        String retMsg = Configuration.AVSCHECKSTRING;
        try {
            retMsg += response.RefNum + Configuration.KEYSPLITTER;
            if (response.CardCodeResultCode != string.valueOf(Enums.CARDCOMPARISONSTRINGS.M)) {
                retMsg += Configuration.CARDCODENOTMATCH;
                AVSMatch = Configuration.AVSMATCHFALSE;
            } else {
                retMsg += Configuration.CARDCODEMATCH;
            }
            ebcLogger.debug(ClassName, MethodName, 'response.AvsResultCode != YYY--> ' + (response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYY)));
            ebcLogger.debug(ClassName, MethodName, 'response.AvsResultCode != Y--> ' + (response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.Y)));
            ebcLogger.debug(ClassName, MethodName, 'response.AvsResultCode != YYA--> ' + (response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYA)));
            ebcLogger.debug(ClassName, MethodName, 'response.AvsResultCode != YYD--> ' + (response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYD)));
            ebcLogger.debug(ClassName, MethodName, 'response.AvsResultCode != YYX--> ' + (response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYX)));
            ebcLogger.debug(ClassName, MethodName, 'response.AvsResultCode != X--> ' + (response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.X)));
            ebcLogger.debug(ClassName, MethodName, 'response.AvsResultCode != GGG--> ' + (response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.GGG)));
            ebcLogger.debug(ClassName, MethodName, 'response.AvsResultCode != D--> ' + (response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.D)));
            ebcLogger.debug(ClassName, MethodName, 'response.AvsResultCode  ALL--> ' + (response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYY) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.Y) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYA) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYD) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYX) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.X) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.GGG) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.D)));
            if (response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYY) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.Y) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYA) ||
                response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYD) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYX) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.X) ||
                response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.GGG) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.D)) {
                if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NNN) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NN) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.N)) {
                    retMsg += Configuration.ADDRESSNOTMATCH;
                    retMsg += Configuration.ZIPNOTMATCH;
                    AVSMatch = Configuration.AVSMATCHFALSE;
                } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NYZ) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.Z) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NYW) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.W) ||
                    response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.P)) {
                    retMsg += Configuration.ADDRESSNOTMATCH;
                    retMsg += Configuration.ZIPCODEMATCH;
                    AVSMatch = Configuration.AVSMATCHFALSE;
                } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YNA) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.A) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YNY) ||
                    response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.B) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.M)) {
                    retMsg += Configuration.ADDRESSMATCH;
                    retMsg += Configuration.ZIPNOTMATCH;
                    AVSMatch = Configuration.AVSMATCHFALSE;
                } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YYG)) {
                    retMsg += Configuration.ADDRESSMATCH;
                    retMsg += Configuration.NOTCOMPATIBLE;
                    AVSMatch = Configuration.AVSMATCHFALSE;
                } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YGG)) {
                    retMsg += Configuration.NOTCOMPATIBLE;
                    retMsg += Configuration.ZIPCODEMATCH;
                    AVSMatch = Configuration.AVSMATCHFALSE;
                } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXW)) {
                    retMsg += Configuration.CARDNUMBERNOTFOUND;
                    retMsg += Configuration.EMPTYSTRING;
                    AVSMatch = Configuration.AVSMATCHFALSE;
                } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXU)) {
                    retMsg += Configuration.ADDRESSINFOVERIFICATION;
                    retMsg += Configuration.EMPTYSTRING;
                    AVSMatch = Configuration.AVSMATCHFALSE;
                } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXR) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.R) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.U) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.E)) {
                    retMsg += Configuration.RETRY;
                    retMsg += Configuration.EMPTYSTRING;
                    AVSMatch = Configuration.AVSMATCHFALSE;
                } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXS) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.S)) {
                    retMsg += Configuration.SERVICENOTSUPPORTED;
                    retMsg += Configuration.EMPTYSTRING;
                    AVSMatch = Configuration.AVSMATCHFALSE;
                } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXE)) {
                    retMsg += Configuration.ADDRESSVERIFICATION;
                    retMsg += Configuration.EMPTYSTRING;
                    AVSMatch = Configuration.AVSMATCHFALSE;
                } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXG) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.G) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.C) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.I)) {
                    retMsg += Configuration.GLOBALAVS;
                    retMsg += Configuration.EMPTYSTRING;
                    AVSMatch = Configuration.AVSMATCHFALSE;
                } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YYY) && response.CardCodeResultCode == string.valueOf(Enums.AVSRESULTCODES.P)) {
                    retMsg += Configuration.ADDRESSMATCH;
                    retMsg += Configuration.ZIPCODEMATCH;
                }
            } else {
                string add = response.AvsResult;
                if (add.contains(Configuration.NOAVSRESPONSE)) {
                    retMsg += Configuration.STREETNOTMATCH;
                    retMsg += Configuration.ZIPNOTMATCH;
                    AVSMatch = Configuration.AVSMATCHFALSE;
                } else {
                    list < string > arr = add.split(Configuration.KEYSPLITTERWITHAMPERCENT);
                    string address = arr[0].substringAfter(Configuration.SUBSTRINGSPLIITTER);
                    string zipcode = arr[1].substringAfter(Configuration.SUBSTRINGSPLIITTER);
                    if (address.trim() != Configuration.MATCHCHECK) {
                        retMsg += Configuration.ADDRESSNOTMATCH;
                        AVSMatch = Configuration.AVSMATCHFALSE;
                    } else {
                        retMsg += Configuration.ADDRESSMATCH;
                    }
                    if (zipcode.trim() != Configuration.MATCHCHECK) {
                        retMsg += Configuration.ZIPNOTMATCH;
                        AVSMatch = Configuration.AVSMATCHFALSE;
                    } else {
                        retMsg += Configuration.ZIPCODEMATCH;
                    }
                }
            }
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
        }
        map < String, String > avsMatchAndRetMsg = new map < String, String > ();
        avsMatchAndRetMsg.put(Configuration.RETURNMESSAGE, retMsg);
        avsMatchAndRetMsg.put(Configuration.MATCHCHECK, AVSMatch);
        return avsMatchAndRetMsg;
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
        list < CstPaymentMethod > retList = new list < CstPaymentMethod > ();
        CstPaymentMethod obj = new CstPaymentMethod();
        obj.AVSMisMatch = false;
        obj.IsErrorReturn = false;
        try {
            Account accountDetail = EBC_CompMethods.getAccountDetail(dml, accId, ebcLogger);
            Map < String, Object > objMap = (Map < String, Object > ) JSON.deserializeUntyped(StrObj);
            Boolean isAVSCheck = (boolean) objMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isAVSCheck));
            ebizchargeServicemodelSoap.MerchantTransactionData responseMerchant;
            responseMerchant = ebiz.GetMerchantTransactionData(EBC_CompMethods.getSecurityToken(dml, ebcLogger));
            if (test.isRunningTest()) {
                responseMerchant.EnableAVSWarnings = false;
            }
            if (responseMerchant.EnableAVSWarnings == false) {
                isAVSCheck = false;
            }
            String MethodType = (string) objMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.MethodType));
            ebizchargeServicemodelSoap.PaymentMethodProfile paymentMethod = new ebizchargeServicemodelSoap.PaymentMethodProfile();
            paymentMethod.MethodName = (string) objMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.MethodName));
            paymentMethod.Balance = 0;
            paymentMethod.MaxBalance = 0;
            paymentMethod.Modified = system.now();
            paymentMethod.Created = system.now();
            Boolean isDefault = (boolean) objMap.get(string.valueOf(Enums.PAYMENTMETHODSTRINGS.isDefault));
            if (isDefault == true) {
                paymentMethod.SecondarySort = Configuration.STARTINDEX;
            } else {
                paymentMethod.SecondarySort = Configuration.CARDMETHODID;
            }
            if (MethodType == Configuration.CREDITCARD) {
                if (test.isRunningTest()) {
                    isAVSCheck = true;
                    responseMerchant.UseFullAmountForAVS = false;
                }
                if (isAVSCheck == true && responseMerchant.UseFullAmountForAVS == false) {
                    Boolean AVSMatch = true;
                    String retMsg = Configuration.AVSCHECKSTRING;
                    ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
                    response = EBC_CompMethods.runAVSCheck(dml, objMap, ebcLogger);
                    if (test.isRunningTest()) {
                        response.Error = Configuration.APPROVED;
                    }
                    if (response.ErrorCode == Configuration.STARTINDEX) {
                        retMsg += response.RefNum + Configuration.KEYSPLITTER;
                        ebcLogger.debug(ClassName, MethodName, 'avs cardcode result code is:' + response.CardCodeResultCode);
                        if (response.CardCodeResultCode != string.valueOf(Enums.CARDCOMPARISONSTRINGS.M)) {
                            retMsg += Configuration.CARDCODENOTMATCH;
                            AVSMatch = false;
                        } else {
                            retMsg += Configuration.CARDCODEMATCH;
                        }
                        ebcLogger.debug(ClassName, MethodName, 'avs result code is:' + response.AvsResultCode);
                        if (response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYY) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.Y) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYA) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYD) ||
                            response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.YYX) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.X) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.GGG) || response.AvsResultCode != string.valueOf(Enums.AVSRESULTCODES.D)) {
                            if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NNN) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NN) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.N)) {
                                retMsg += Configuration.ADDRESSNOTMATCH;
                                retMsg += Configuration.ZIPNOTMATCH;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NYZ) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.Z) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.NYW) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.W) ||
                                response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.P)) {
                                retMsg += Configuration.ADDRESSNOTMATCH;
                                retMsg += Configuration.ZIPCODEMATCH;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YNA) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.A) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YNY) ||
                                response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.B) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.M)) {
                                retMsg += Configuration.ADDRESSMATCH;
                                retMsg += Configuration.ZIPNOTMATCH;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YYG)) {
                                retMsg += Configuration.ADDRESSMATCH;
                                retMsg += Configuration.NOTCOMPATIBLE;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YGG)) {
                                retMsg += Configuration.NOTCOMPATIBLE;
                                retMsg += Configuration.ZIPCODEMATCH;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXW)) {
                                retMsg += Configuration.CARDNUMBERNOTFOUND;
                                retMsg += Configuration.KEYSPLITTERWITHSPACE;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXU)) {
                                retMsg += Configuration.ADDRESSINFOVERIFICATION;
                                retMsg += Configuration.KEYSPLITTERWITHSPACE;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXR) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.R) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.U) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.E)) {
                                retMsg += Configuration.RETRY;
                                retMsg += Configuration.KEYSPLITTERWITHSPACE;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXS) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.S)) {
                                retMsg += Configuration.SERVICENOTSUPPORTED;
                                retMsg += Configuration.KEYSPLITTERWITHSPACE;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXE)) {
                                retMsg += Configuration.ADDRESSVERIFICATION;
                                retMsg += Configuration.KEYSPLITTERWITHSPACE;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.XXG) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.G) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.C) || response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.I)) {
                                retMsg += Configuration.GLOBALAVS;
                                retMsg += Configuration.KEYSPLITTERWITHSPACE;
                                AVSMatch = false;
                            } else if (response.AvsResultCode == string.valueOf(Enums.AVSRESULTCODES.YYY) && response.CardCodeResultCode == string.valueOf(Enums.AVSRESULTCODES.P)) {
                                retMsg += Configuration.ADDRESSMATCH;
                                retMsg += Configuration.ZIPCODEMATCH;
                            } else {
                                retMsg += Configuration.KEYSPLITTERWITHSPACE;
                                retMsg += Configuration.KEYSPLITTERWITHSPACE;
                            }
                        } else {
                            string add = response.AvsResult;
                            if (add.contains(Configuration.NOAVSRESPONSE)) {
                                retMsg += Configuration.STREETNOTMATCH;
                                retMsg += Configuration.ZIPNOTMATCH;
                                AVSMatch = false;
                            } else {
                                list < string > arr = add.split(Configuration.KEYSPLITTERWITHAMPERCENT);
                                string address = arr[0].substringAfter(Configuration.SUBSTRINGSPLIITTER);
                                string zipcode = arr[1].substringAfter(Configuration.SUBSTRINGSPLIITTER);
                                if (address.trim() != Configuration.MATCHCHECK) {
                                    retMsg += Configuration.ADDRESSNOTMATCH;
                                    AVSMatch = false;
                                } else {
                                    retMsg += Configuration.ADDRESSMATCH;
                                }
                                if (zipcode.trim() != Configuration.MATCHCHECK) {
                                    retMsg += Configuration.ZIPNOTMATCH;
                                    AVSMatch = false;
                                } else {
                                    retMsg += Configuration.ZIPCODEMATCH;
                                }
                            }
                        }
                        if (AVSMatch != true) {
                            obj.AVSMisMatch = true;
                            obj.AVSretMsg = retMsg.removeEnd(Configuration.KEYSPLITTER);
                            retList.add(obj);
                            return retList;
                        } else {
                            obj.AVSMisMatch = false;
                            invokeTransactionVoidApxc(dml, response.RefNum, ebcLogger);
                        }
                    } else {
                        obj.IsErrorReturn = true;
                        obj.AVSretMsg = response.Error;
                        retList.add(obj);
                        return retList;
                    }
                }
                retList.add(obj);
                paymentMethod.MethodType = string.valueOf(Enums.PAYMENTMETHODSTRINGS.cc);
                paymentMethod.AccountHolderName = (string) objMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardHolderName));
                paymentMethod.CardNumber = (string) objMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CardNumber));
                string month_x = (string) objMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryMonth));
                string year_x = (string) objMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.expiryYear));
                paymentMethod.CardCode = (string) objMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.CVCNumber));
                paymentMethod.CardExpiration = year_x + Configuration.KEYSPLITTERWITHDASH + month_x;
                paymentMethod.AvsStreet = (string) objMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.BillingAddress));
                paymentMethod.AvsZip = (string) objMap.get(string.valueOf(Enums.CARDJAVASCRIPTMAPSTRINGS.ZipCode));
            } else {
                paymentMethod.AccountHolderName = (string) objMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.AccountHolderName));
                paymentMethod.Account = (string) objMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.Account));
                paymentMethod.AccountType = (string) objMap.get(string.valueOf(Enums.ACCOUNTTYPES.AccountType));
                paymentMethod.Routing = (string) objMap.get(string.valueOf(Enums.ACCOUNTJAVASCRIPTMAPSTRINGS.Routing));
            }
            ebcLogger.debug(ClassName, MethodName, 'A-isDefault->>>>>>>>' + isDefault);
            ebcLogger.debug(ClassName, MethodName, 'A-paymentMethod.SecondarySort>>>>' + paymentMethod.SecondarySort);
            ebizchargeServicemodelSoap.Customer response = new ebizchargeServicemodelSoap.Customer();
            ebizchargeServicemodelSoap.CustomerResponse customerResponse = new ebizchargeServicemodelSoap.CustomerResponse();
            if(accountDetail.EBizCharge_Internal_ID__c != null){
                //GetCustomer on the basis of Internal Id
            try{
                //internal id is changed -----> exception
                response = ebiz.GetCustomer(eBc_UtilityController.getSecurityToken(dml, ebcLogger),Configuration.EMPTYSTRING,accountDetail.EBizCharge_Internal_ID__c);
                //else update on the basis of Internal Id
                if(response.CustomerInternalId != null){
                    //Update Api Call
                    customerResponse = eBc_UtilityController.invoke_addORUpdCustomerQBD(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger),'',string.valueOf(Enums.ENTITYACTIONS.updateCustomer), ebcLogger);
                }    
            }catch(Exception e){
                //get customer on the basis of QBD ------> if its changed or not?
                try{ 
                    //if QBD id is not changed------> get a 200 status code
                response = ebiz.GetCustomer(eBc_UtilityController.getSecurityToken(dml, ebcLogger),(String)accountDetail.get('QBD_Customer_ID__c'),Configuration.EMPTYSTRING);
                if(response.CustomerInternalId != null){
                    //Update Api Call
                    accountDetail.EBizCharge_Internal_ID__c = response.CustomerInternalId;
                    customerResponse = eBc_UtilityController.invoke_addORUpdCustomerQBD(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger),'',string.valueOf(Enums.ENTITYACTIONS.updateCustomer), ebcLogger);
                }
                }catch(exception error){
                    //else changed ------> not found 500 status code
                    customerResponse = eBc_UtilityController.invoke_addORUpdCustomerQBD(dml, accountDetail, eBc_UtilityController.getSecurityToken(dml, ebcLogger),'',string.valueOf(Enums.ENTITYACTIONS.addCustomer), ebcLogger);
                    accountDetail.EBizCharge_Internal_ID__c = response.CustomerInternalId;
                }
            }    
            }
            //string methodID = ebiz.AddCustomerPaymentMethodProfile(EBC_CompMethods.getSecurityToken(dml, ebcLogger), internalId, paymentMethod);
            string methodID = ebiz.AddCustomerPaymentMethodProfile(EBC_CompMethods.getSecurityToken(dml, ebcLogger), customerResponse.CustomerInternalId, paymentMethod);
            if (methodID != Configuration.EMPTYSTRING) {
                if (isDefault == true) {
                    String querySelect = 'select id,QBD_Customer_ID__c';
                    String queryFrom = 'from Account';
                    String queryWhere =  'where id=\''+accId+'\'';
                    Account account = (Account)dml.selectSingleRecord(querySelect, queryFrom, queryWhere, Configuration.EMPTYSTRING,Configuration.EMPTYSTRING);
                    string customerToken = EBC_CompMethods.getCustomerToken(dml, (string)account.get('QBD_Customer_ID__c'), internalId, ebcLogger);
                    Boolean UpProfileRes = ebiz.SetDefaultCustomerPaymentMethodProfile(EBC_CompMethods.getSecurityToken(dml, ebcLogger), customerToken, methodID);
                }
                retList = getPaymentMethodsApxc(dml, accId, internalId, ebcLogger);
            }
            dml.upsertRecord(accountDetail);
        } catch (Exception e) {
            ebcLogger.debug(ClassName, MethodName, e.getMessage(), Configuration.EXCEPTIONLOGTYPE);
            if (!Test.isRunningTest()) {
                throw new AuraHandledException(Configuration.EXCEPTIONSTRING + e.getMessage());
            }
        }
        return retList;
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
        ebizchargeServicemodelSoap.TransactionRequestObject tran = new ebizchargeServicemodelSoap.TransactionRequestObject();
        String paymentMethodID = Configuration.VOIDTRANSACTIONCOMMAND;
        Decimal paymentStatus = 3;
        tran.Command = paymentMethodID;
        tran.IgnoreDuplicate = true;
        tran.RefNum = avsRefNum;
        tran.IsRecurring = false;
        tran.CustReceipt = false;
        ebizchargeServicemodelSoap.TransactionResponse response = new ebizchargeServicemodelSoap.TransactionResponse();
        try {
            response = ebiz.runTransaction(EBC_CompMethods.getSecurityToken(dml, ebcLogger), tran);
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