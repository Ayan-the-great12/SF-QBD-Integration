({
    CheckCompSettings: function(component, event) {
        var action = component.get("c.getCompSettingsApxc");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.Spinner', false);
                var cs = response.getReturnValue();
                if (!$A.util.isEmpty(cs)) {
                    component.set('v.CS', cs);
                    if (cs.Ebiz_C__Component_Label__c != null && cs.Ebiz_C__Component_Label__c != '') {
                        component.set('v.ComponentLabel', cs.Ebiz_C__Component_Label__c);
                    }
                    if (cs.Ebiz_C__Security_Token__c != null && cs.Ebiz_C__Security_Token__c != '') {
                        component.set("v.isDisable", false);
                    } else {
                        component.set("v.isDisable", true);
                    }
                } else {
                    component.set("v.isDisable", true);
                }
            } else {
                component.set("v.isDisable", true);
                component.set('v.Spinner', false);
            }
        });
        $A.enqueueAction(action);
    },
    getPendingEmailRequests: function(component, event, obj, objName) {
        var fromDate = new Date(1900, 1, 1);
        var endDate = new Date(2100, 1, 1);
        var action = component.get("c.getPendingPaymentsCustomerApxc");
        action.setParams({
            sDate: fromDate,
            eDate: endDate,
            cust: obj,
            objName: objName
        });
        action.setCallback(this, function(a) {
            if (a.getState() == "SUCCESS") {
                var retValue = a.getReturnValue();
                var pendingList = retValue.PendingList;
                if (pendingList != undefined) {
                    var retValue = a.getReturnValue();
                    component.set("v.PendingList", pendingList);
                    this.sortDataPending(component, 'PaymentRequestDateTime', 'desc');
                    component.find('pendinglabel').set("v.label", "EBizCharge Pending Requests (" + pendingList.length + ")");
                } else {
                    component.set("v.PendingList", []);
                }
                component.set('v.Spinner', false);
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToast(errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    getPaymentMethods: function(component, event, accId) {
        var action = component.get('c.getCustPaymentMethodsApx');
        action.setParams({
            'AccountId': accId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                var payM = resInfo.savedPaymentMethods;
                var sCard = [];
                var sACH = [];
                for (var key in payM) {
                    var arr = [];
                    arr = key.toString().split('@');
                    if (arr[1] == 'C') {
                        sCard.push({
                            value: arr[0],
                            label: payM[key]
                        });
                    } else {
                        sACH.push({
                            value: arr[0],
                            label: payM[key]
                        });
                    }
                }
                component.set("v.savedCard", sCard);
                component.set("v.savedACH", sACH);
                var savedCard = [];
                var savedACH = [];
                if (resInfo.SavedPaymentMethodslist != null) {
                    var payM = resInfo.SavedPaymentMethodslist;
                    for (var i = 0; i < payM.length; i++) {
                        if (payM[i].MethodType == 'cc') {
                            savedCard.push(payM[i]);
                        } else {
                            savedACH.push(payM[i]);
                        }
                    }
                }
                component.set("v.savedCardList", savedCard);
                component.set("v.savedACHList", savedACH);
                component.set("v.accountDetail", resInfo.AccountInfo);
                component.set('v.Spinner', false);
            } else {
                component.set('v.Spinner', false);
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    getPaymentMethodsContact: function(component, event, ConId) {
        var action = component.get('c.getCustPaymentMethodsContactApx');
        action.setParams({
            'contactId': ConId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                var payM = resInfo.savedPaymentMethods;
                var sCard = [];
                var sACH = [];
                for (var key in payM) {
                    var arr = [];
                    arr = key.toString().split('@');
                    if (arr[1] == 'C') {
                        sCard.push({
                            value: arr[0],
                            label: payM[key]
                        });
                    } else {
                        sACH.push({
                            value: arr[0],
                            label: payM[key]
                        });
                    }
                }
                component.set("v.savedCard", sCard);
                component.set("v.savedACH", sACH);
                var savedCard = [];
                var savedACH = [];
                if (resInfo.SavedPaymentMethodslist != null) {
                    var payM = resInfo.SavedPaymentMethodslist;
                    for (var i = 0; i < payM.length; i++) {
                        if (payM[i].MethodType == 'cc') {
                            savedCard.push(payM[i]);
                        } else {
                            savedACH.push(payM[i]);
                        }
                    }
                }
                component.set("v.savedCardList", savedCard);
                component.set("v.savedACHList", savedACH);
                component.set("v.contactDetail", resInfo.ContactInfo);
                component.set('v.Spinner', false);
            } else {
                component.set('v.Spinner', false);
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    getPaymentMethodsCustomCustomer: function(component, event, ConId) {
        var action = component.get('c.getCustPaymentMethodsCustomApx');
        action.setParams({
            'CustomCustId': ConId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                var payM = resInfo.savedPaymentMethods;
                var sCard = [];
                var sACH = [];
                for (var key in payM) {
                    var arr = [];
                    arr = key.toString().split('@');
                    if (arr[1] == 'C') {
                        sCard.push({
                            value: arr[0],
                            label: payM[key]
                        });
                    } else {
                        sACH.push({
                            value: arr[0],
                            label: payM[key]
                        });
                    }
                }
                component.set("v.savedCard", sCard);
                component.set("v.savedACH", sACH);
                var savedCard = [];
                var savedACH = [];
                if (resInfo.SavedPaymentMethodslist != null) {
                    var payM = resInfo.SavedPaymentMethodslist;
                    for (var i = 0; i < payM.length; i++) {
                        if (payM[i].MethodType == 'cc') {
                            savedCard.push(payM[i]);
                        } else {
                            savedACH.push(payM[i]);
                        }
                    }
                }
                component.set("v.savedCardList", savedCard);
                component.set("v.savedACHList", savedACH);
                component.set('v.Spinner', false);
            } else {
                component.set('v.Spinner', false);
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    UpdateConfigInfo: function(component, event, helper) {
        var action = component.get('c.GETObjConfig');
        action.setParams({
            "objectName": component.get('v.sObjectName')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                var obj_config = resInfo.config;
                var EmailFields = resInfo.EBizCharge_EBizCharge_Email_list;
                var CurrencyFields = resInfo.EBizCharge_Amount_fields_list;
                var TextFields = resInfo.EBizCharge_name_fields_list;
                component.set("v.EmailFieldsList", EmailFields);
                component.set("v.AmuontFieldsList", CurrencyFields);
                component.set("v.NameFieldsList", TextFields);
                component.set('v.ObjectConfig', obj_config);
                component.set('v.ShowObjConfigModel', obj_config.Ebiz_C__ShowMeConfigModel__c);
                component.set('v.Spinner', false);
            } else {
                component.set('v.Spinner', false);
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    UpdateConfigxApeInfo: function(component, event, helper) {
        var obj_config = component.get('v.ObjectConfig');
        var action = component.get('c.SaveObjectConfig');
        action.setParams({
            "config": obj_config
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                component.set('v.Spinner', false);
                this.showToast('The object configuration has been updated successfully.', 'Success');
                $A.get('e.force:refreshView').fire();
            } else {
                component.set('v.Spinner', false);
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    UpdateConfigxApeInfoClose: function(component, event, helper) {
        var obj_config = component.get('v.ObjectConfig');
        var action = component.get('c.SaveObjectConfigClose');
        action.setParams({
            "config": obj_config
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                component.set('v.Spinner', false);
                component.set("v.ShowObjConfigModel", false);
                $A.get('e.force:refreshView').fire();
            } else {
                component.set('v.Spinner', false);
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    UpdateCustomerInfo: function(component, event, custId) {
        var action = component.get('c.UpdateCustomerInfoFromSchema');
        action.setParams({
            'CustomerId': custId,
            "objectName": component.get('v.sObjectName')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                component.set('v.CustomObjectDetail', resInfo.CustomCustInfo);
                if(resInfo.CustomCustInfo.Ebiz_C__EBizCharge_CustomerId__c != null && resInfo.CustomCustInfo.Ebiz_C__EBizCharge_CustomerId__c != undefined)
                {
                    var id = resInfo.CustomCustInfo.Ebiz_C__EBizCharge_CustomerId__c;
                    component.set('v.Spinner', true);
                    this.getTransactionsCustomObject(component, event, id);
                    this.getPendingEmailRequests(component, event, resInfo.CustomCustInfo, component.get('v.sObjectName'));
                }
                component.set('v.Spinner', false);
            } else {
                component.set('v.Spinner', false);
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    UpdateCustomerInternalId: function(component, event, custId) {
        var action = component.get('c.UpdateInternalIdCustomCustomer');
        action.setParams({
            'CustomerId': custId,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                component.set('v.Spinner', false);
            } else {
                component.set('v.Spinner', false);
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    getPaymentMethodsCustomer: function(component, event, custId) {
        var action = component.get('c.getCustPaymentMethodsContactApx');
        action.setParams({
            'contactId': custId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                var payM = resInfo.savedPaymentMethods;
                var sCard = [];
                var sACH = [];
                for (var key in payM) {
                    var arr = [];
                    arr = key.toString().split('@');
                    if (arr[1] == 'C') {
                        sCard.push({
                            value: arr[0],
                            label: payM[key]
                        });
                    } else {
                        sACH.push({
                            value: arr[0],
                            label: payM[key]
                        });
                    }
                }
                component.set("v.savedCard", sCard);
                component.set("v.savedACH", sACH);
                var savedCard = [];
                var savedACH = [];
                if (resInfo.SavedPaymentMethodslist != null) {
                    var payM = resInfo.SavedPaymentMethodslist;
                    for (var i = 0; i < payM.length; i++) {
                        if (payM[i].MethodType == 'cc') {
                            savedCard.push(payM[i]);
                        } else {
                            savedACH.push(payM[i]);
                        }
                    }
                }
                component.set("v.savedCardList", savedCard);
                component.set("v.savedACHList", savedACH);
                component.set("v.contactDetail", resInfo.ContactInfo);
                component.set('v.Spinner', false);
            } else {
                component.set('v.Spinner', false);
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    getTransaction: function(component, event, RefNum) {
        var action = component.get('c.getTransactionApxc');
        action.setParams({
            "RefNum": RefNum
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.Spinner', false);
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                res.Ebiz_C__Account_Name__c = component.get("v.AccountName");
                component.set("v.TransInfo", res);
            }
        });
        $A.enqueueAction(action);
    },
    getTransactionsCustomObject: function(component, event, id) {
        var action = component.get('c.getTransactionsCustomObjectApxc');
        action.setParams({
            "id": id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.Spinner', false);
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                if (res.length > 0) {
                    var tcount = res[0].tcount;
                    component.set("v.previousTransactionCount", tcount);
                    component.find('previouslabel').set("v.label", "Previous Transactions (" + tcount + ")");
                }
                component.set("v.TransList", res);
                var dataList = response.getReturnValue().map(function(rowData) {
                    if (rowData.CardType == 'V') {
                        rowData.cardClass = 'visa';
                    } else if (rowData.CardType == 'M') {
                        rowData.cardClass = 'master';
                    } else if (rowData.CardType == 'A') {
                        rowData.cardClass = 'american';
                    } else if (rowData.CardType == 'DS') {
                        rowData.cardClass = 'discover';
                    } else if (rowData.CardType == 'ACH') {
                        rowData.cardClass = 'ach';
                    }
                    return rowData;
                });
            }
        });
        $A.enqueueAction(action);
    },
    getTransactionsContact: function(component, event, contact) {
        var action = component.get('c.getTransactionsContactApxc');
        action.setParams({
            "contactId": contact.Id
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.Spinner', false);
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                if (res.length > 0) {
                    var tcount = res[0].tcount;
                    component.set("v.previousTransactionCount", tcount);
                    component.find('previouslabel').set("v.label", "Previous Transactions (" + tcount + ")");
                }
                component.set("v.TransList", res);
                var dataList = response.getReturnValue().map(function(rowData) {
                    if (rowData.CardType == 'V') {
                        rowData.cardClass = 'visa';
                    } else if (rowData.CardType == 'M') {
                        rowData.cardClass = 'master';
                    } else if (rowData.CardType == 'A') {
                        rowData.cardClass = 'american';
                    } else if (rowData.CardType == 'DS') {
                        rowData.cardClass = 'discover';
                    } else if (rowData.CardType == 'ACH') {
                        rowData.cardClass = 'ach';
                    }
                    return rowData;
                });
            }
        });
        $A.enqueueAction(action);
    },
    getTransactionsOpp: function(component, event, opp) {
        var action = component.get('c.getTransactionsOppApxc');
        action.setParams({
            "opp": opp
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.Spinner', false);
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                if (res.length > 0) {
                    var tcount = res[0].tcount;
                    component.set("v.previousTransactionCount", tcount);
                    component.find('previouslabel').set("v.label", "Previous Transactions (" + tcount + ")");
                }
                component.set("v.TransList", res);
                var dataList = response.getReturnValue().map(function(rowData) {
                    if (rowData.CardType == 'V') {
                        rowData.cardClass = 'visa';
                    } else if (rowData.CardType == 'M') {
                        rowData.cardClass = 'master';
                    } else if (rowData.CardType == 'A') {
                        rowData.cardClass = 'american';
                    } else if (rowData.CardType == 'DS') {
                        rowData.cardClass = 'discover';
                    } else if (rowData.CardType == 'ACH') {
                        rowData.cardClass = 'ach';
                    }
                    return rowData;
                });
            }
        });
        $A.enqueueAction(action);
    },
    getTransactionsOrder: function(component, event, ord) {
        var action = component.get('c.getTransactionsOrderApxc');
        action.setParams({
            "ord": ord
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.Spinner', false);
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                if (res.length > 0) {
                    var tcount = res[0].tcount;
                    component.set("v.previousTransactionCount", tcount);
                    component.find('previouslabel').set("v.label", "Previous Transactions (" + tcount + ")");
                }
                component.set("v.TransList", res);
                var dataList = response.getReturnValue().map(function(rowData) {
                    if (rowData.CardType == 'V') {
                        rowData.cardClass = 'visa';
                    } else if (rowData.CardType == 'M') {
                        rowData.cardClass = 'master';
                    } else if (rowData.CardType == 'A') {
                        rowData.cardClass = 'american';
                    } else if (rowData.CardType == 'DS') {
                        rowData.cardClass = 'discover';
                    } else if (rowData.CardType == 'ACH') {
                        rowData.cardClass = 'ach';
                    }
                    return rowData;
                });
            }else{
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    getTransactionsAccount: function(component, event, acc) {
        var action = component.get('c.getTransactionsAccountApxc');
        action.setParams({
            "acc": acc
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.Spinner', false);
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                if (res.length > 0) {
                    var tcount = res[0].tcount;
                    component.set("v.previousTransactionCount", tcount);
                    component.find('previouslabel').set("v.label", "Previous Transactions (" + tcount + ")");
                }
                component.set("v.TransList", res);
                this.sortData(component, 'dateTimeTransaction', 'desc');
                var dataList = response.getReturnValue().map(function(rowData) {
                    if (rowData.CardType == 'V') {
                        rowData.cardClass = 'visa';
                    } else if (rowData.CardType == 'M') {
                        rowData.cardClass = 'master';
                    } else if (rowData.CardType == 'A') {
                        rowData.cardClass = 'american';
                    } else if (rowData.CardType == 'DS') {
                        rowData.cardClass = 'discover';
                    } else if (rowData.CardType == 'ACH') {
                        rowData.cardClass = 'ach';
                    }
                    return rowData;
                });
            }
        });
        $A.enqueueAction(action);
    },
    getTransactionsQuote: function(component, event, quo) {
        var action = component.get('c.getTransactionsQuoteApxc');
        action.setParams({
            "quo": quo
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.Spinner', false);
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                if (res.length > 0) {
                    var tcount = res[0].tcount;
                    component.set("v.previousTransactionCount", tcount);
                    component.find('previouslabel').set("v.label", "Previous Transactions (" + tcount + ")");
                }
                component.set("v.TransList", res);
                var dataList = response.getReturnValue().map(function(rowData) {
                    if (rowData.CardType == 'V') {
                        rowData.cardClass = 'visa';
                    } else if (rowData.CardType == 'M') {
                        rowData.cardClass = 'master';
                    } else if (rowData.CardType == 'A') {
                        rowData.cardClass = 'american';
                    } else if (rowData.CardType == 'DS') {
                        rowData.cardClass = 'discover';
                    } else if (rowData.CardType == 'ACH') {
                        rowData.cardClass = 'ach';
                    }
                    return rowData;
                });
            }
        });
        $A.enqueueAction(action);
    },
    getTransactionContact: function(component, event, RefNum) {
        var action = component.get('c.getTransactionApxc');
        action.setParams({
            "RefNum": RefNum
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.Spinner', false);
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                res.Ebiz_C__Account_Name__c = component.get("v.ContactName");
                component.set("v.TransInfo", res);
            } else {
                component.set('v.Spinner', false);
            }
        });
        $A.enqueueAction(action);
    },
    getTransactionCustCustomer: function(component, event, RefNum) {
        var action = component.get('c.getTransactionApxc');
        action.setParams({
            "RefNum": RefNum
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set('v.Spinner', false);
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                res.Ebiz_C__Account_Name__c = component.get("v.CustomObjectDetail.Name");
                component.set("v.TransInfo", res);
            } else {
                component.set('v.Spinner', false);
            }
        });
        $A.enqueueAction(action);
    },
    getReceivedPaymentEmail: function(component, event, obj, objName) {
        var endDate = new Date(2100, 1, 1);
        var fromDate = component.get('v.fromDate');
        var toDate = component.get('v.toDate');
        var action = component.get("c.getReceivedPaymentEmailsApxc");
        action.setParams({
            sDate: fromDate,
            eDate: toDate,
            cust: obj,
            objName: objName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var oRes = response.getReturnValue();
                component.set("v.Spinner", false);
                if (oRes.length > 0) {
                    var tcount = oRes[0].tcount;
                    component.set("v.tcount", tcount);
                    component.find('receivedlabel').set("v.label", "Received payments (" + tcount + ")");
                }
                component.set("v.recPaymentList", oRes);
                var dataList = oRes.map(function(rowData) {
                    if ($A.util.isEmpty(rowData.rrCustomerName)) {
                        rowData.RecurringHyperUrl = '';
                    }
                    rowData.OrderHyperUrl = '/' + rowData.OrderId;
                    rowData.AccountHyperUrl = '/' + rowData.CustomerId;
                    rowData.Last4 = rowData.Last4;
                    if (rowData.PaymentMethod == 'Visa') {
                        rowData.cardClass = 'visa';
                    } else if (rowData.PaymentMethod == 'MasterCard') {
                        rowData.cardClass = 'master';
                    } else if (rowData.PaymentMethod == 'American Express') {
                        rowData.cardClass = 'american';
                    } else if (rowData.PaymentMethod == 'Discover') {
                        rowData.cardClass = 'discover';
                    } else {
                        rowData.cardClass = 'ach';
                        rowData.card = rowData.checkAccount;
                    }
                    return rowData;
                });
                component.set("v.recPaymentList", oRes);
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    markAllPaymentsApply: function(component, event, emailPayList) {
        var maxcount = component.get("v.MaxRecords");
        var index;
        var request_count = 0;
        var success_count = 0;
        var number_of_records = emailPayList.length;
        if (emailPayList.length > 0) {
            if (emailPayList.length > maxcount) {
                component.set('v.Spinner', false);
                component.set('v.isActive', true);
                return;
            }
            for (index = 0; index < number_of_records; index++) {
                var OrderId = emailPayList[index].OrderId;
                var RefNum = emailPayList[index].RefNum;
                var PaymentInternalId = emailPayList[index].PaymentInternalId;
                var InvoiceNumber = emailPayList[index].InvoiceNumber;
                var Amount = emailPayList[index].PaidAmount;
                var action = component.get("c.markPaymentAsApplied");
                action.setParams({
                    RefNum: RefNum,
                    PaymentInternalId: PaymentInternalId,
                    InvoiceNumber: InvoiceNumber,
                    OrderId: OrderId,
                    Amount: parseFloat(Amount)
                });
                action.setCallback(this, function(response) {
                    request_count++;
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        var res = response.getReturnValue();
                        if (res == 'Success') {
                            success_count++;
                        }
                    } else {
                        this.showToast('Something went wrong, Please try again!', 'Error');
                    }
                    if (request_count == number_of_records) {
                        component.set("v.Spinner", false);
                        component.find("recPaymentList").set("v.selectedRows", []);
                        component.set('v.disableButtonApply', true);
                        component.set('v.countSelectedRows', 0);
                        var accFields = component.get("v.obj");
                        var objectName = component.get('v.sObjectName');
                        this.getReceivedPaymentEmail(component, event, accFields, objectName);
                        if (request_count == success_count) {
                            this.showToast('Payments Successfully Applied!', 'Success');
                            window.location.reload(true);
                        } else {
                            this.showToast(res, 'Error');
                        }
                    }
                });
                $A.enqueueAction(action);
            }
        } else {
            component.set("v.Spinner", false);
            this.showToast('Please select atleast one Email Pay to Apply!', 'Error');
        }
    },
    getAccountDetail: function(component, event) {
        var obj = component.get('v.sObjectName');
        var action = component.get('c.getDetailApxc');
        action.setParams({
            "recordId": component.get('v.recordId'),
            "ObjectName": obj
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.Spinner", false);
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                component.set('v.QbdCustomerId',res.AccountId);
                if (res.auto_reload_page == true) {
                    //window.location.reload(true);
                }
            } else {
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    getContactDetail: function(component, event) {
        var obj = component.get('v.sObjectName');
        var action = component.get('c.getDetailApxcContact');
        action.setParams({
            "recordId": component.get('v.recordId'),
            "ObjectName": obj,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                if (res.auto_reload_page == true) {
                    //window.location.reload(true);
                }
            } else {}
        });
        $A.enqueueAction(action);
    },
    getCustomDetail: function(component, event) {
        var obj = component.get('v.sObjectName');
        var action = component.get('c.getDetailApxcCustomCustomer');
        action.setParams({
            "CustomerId": component.get('v.recordId'),
            "ObjectName": obj,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                if (res.auto_reload_page == true) {
                    //window.location.reload(true);
                }
            } else {}
        });
        $A.enqueueAction(action);
    },
    receivedSortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.recPaymentList");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'PaidAmount') {
            data.sort(function(a, b) {
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a > b) - (b > a));
            });
        } else {
            data.sort(function(a, b) {
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a > b) - (b > a));
            });
        }
        component.set("v.recPaymentList", data);
    },
    showToast: function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: type + '!',
            message: message,
            duration: ' 5000',
            key: type + '_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
    sortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.TransList");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        data.sort(function(a, b) {
            var a = key(a) ? key(a).toLowerCase() : '';
            var b = key(b) ? key(b).toLowerCase() : '';
            return reverse * ((a > b) - (b > a));
        });
        component.set("v.TransList", data);
    },
    sortDataPending: function(component, fieldName, sortDirection) {
        var data = component.get("v.PendingList");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        data.sort(function(a, b) {
            var a = key(a) ? key(a) : '';
            var b = key(b) ? key(b) : '';
            return reverse * ((a > b) - (b > a));
        });
        component.set("v.PendingList", data);
    }
})