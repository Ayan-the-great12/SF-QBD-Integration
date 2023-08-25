({
    CheckCompSettings: function (component, event) {
        var action = component.get("c.getCompSettingsApxc");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var cs = response.getReturnValue();
                if (!$A.util.isEmpty(cs)) {
                    component.set('v.Settings', cs);
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
            }
        });
        $A.enqueueAction(action);
    },
    getCustDetail: function (component, event) {
        var Settings = component.get('v.Settings');
        var obj = component.get('v.ObjectName');
        var action = component.get('c.getDetailApxcCustomCustomer');
        action.setParams({
            "CustomerId": component.get('v.recordId'),
            "objectName": obj,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                component.set("v.CustomCustomerDetail", resInfo.CustomCustInfo);
                component.set("v.CustomCustName", resInfo.CustomCustName);
                component.set("v.CustomCustId", resInfo.CustomCustInfo.Ebiz_C__EBizCharge_CustomerId__c);
                component.set("v.Amount", resInfo.CustomCustInfo.Ebiz_C__EBizCharge_Amount_Source__c);
                component.set('v.ObjectLabel', resInfo.Object_label)
                var Settings = component.get('v.Settings');
                var TaxAction = Settings.Ebiz_C__Tax_Action__c;
                var ShowTaxField = Settings.Ebiz_C__Show_Tax_Field__c;
                var amount = component.get('v.Amount');
                var Tax = 0.0;
                if (TaxAction == 'Tax Included') {
                    var TaxDefaultPercent = Settings.Ebiz_C__Tax_Default_Percent__c / 100;
                    Tax = amount * TaxDefaultPercent;
                } else {
                    var TaxCalculatedBy = Settings.Ebiz_C__Tax_Calculate_By__c;
                    if (TaxCalculatedBy == 'Auto') {
                        var TaxDefaultPercent = Settings.Ebiz_C__Tax_Default_Percent__c / 100;
                        Tax = amount * TaxDefaultPercent;
                    } else {
                        var TaxManualType = Settings.Ebiz_C__Tax_Manual_Type__c;
                        if (TaxManualType == 'Use Percent') {
                            Tax = component.get('v.Tax') / 100;
                            Tax = (amount * Tax).toFixed(2);
                        } else {
                            Tax = component.get('v.Tax');
                        }
                    }
                }
                var TotalAmount = 0.0;
                if (TaxAction == 'Tax Included' || ShowTaxField == false) {
                    TotalAmount = parseFloat(amount);
                } else {
                    TotalAmount = parseFloat(amount) + parseFloat(Tax);
                }
                if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
                    Tax = component.get('v.Tax');
                }
                component.set('v.Tax', Tax);
                component.set('v.PaymentTotal', TotalAmount);
                component.set('v.UseFullAmountForAVS', resInfo.UseFullAmountForAVS);
                component.set('v.Spinner', false);
            } else {
                component.set('v.Spinner', false);
                var errors = response.getError();
                this.showToastMsg('Something went wrong ' + errors[0].message + '!', 'Error');
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },

    UpdateConfigInfo: function (component, event, helper) {
        var action = component.get('c.GETObjConfig');
        action.setParams({
            "objectName": component.get('v.sObjectName')
        });
        action.setCallback(this, function (response) {
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
    CustomObject: function (component, event, helper) {
        var action = component.get('c.CustomObjectName');
        action.setParams({
            "recordId": component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                component.set('v.sObjectName', resInfo);
                this.UpdateConfigInfo(component, event, helper);
            }
        });
        $A.enqueueAction(action);
    },
    UpdateConfigxApeInfo: function (component, event, helper) {
        var obj_config = component.get('v.ObjectConfig');
        var action = component.get('c.SaveObjectConfig');
        action.setParams({
            "config": obj_config
        });
        action.setCallback(this, function (response) {
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
    UpdateConfigxApeInfoClose: function (component, event, helper) {
        var obj_config = component.get('v.ObjectConfig');
        var action = component.get('c.SaveObjectConfigClose');
        action.setParams({
            "config": obj_config
        });
        action.setCallback(this, function (response) {
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
    UpdateCustomerInfo: function (component, event, custId) {
        var action = component.get('c.UpdateCustomerInfoFromSchema');
        action.setParams({
            'CustomerId': custId,
            "objectName": component.get('v.sObjectName')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                component.set('v.CustomObjectDetail', resInfo.CustomCustInfo);
                var id = resInfo.CustomCustInfo.Ebiz_C__EBizCharge_CustomerId__c;
                component.set('v.Spinner', true);
                component.set('v.Spinner', false);
            } else {
                component.set('v.Spinner', false);
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },


    getCustomDetail: function (component, event) {
        var obj = component.get('v.sObjectName');
        var action = component.get('c.getDetailApxcCustomCustomer');
        action.setParams({
            "CustomerId": component.get('v.recordId'),
            "ObjectName": obj,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var res = response.getReturnValue();
                component.set('v.CustomCustomerDetail', res.CustomCustInfo);
                if (res.auto_reload_page == true) {
                    window.location.reload(true);
                }
            } else {}
        });
        $A.enqueueAction(action);
    },
    UpdateCustomerInternalId: function (component, event, custId) {
        var action = component.get('c.UpdateInternalIdCustomCustomer');
        action.setParams({
            'CustomerId': custId,
        });
        action.setCallback(this, function (response) {
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
    getPaymentMethodsCustomCustomer: function (component, event, ConId) {
        var action = component.get('c.getCustPaymentMethodsCustomApx');
        action.setParams({
            'CustomCustId': ConId
        });
        action.setCallback(this, function (response) {
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
                var savedACH = component.get('v.savedACHList');
                if (savedACH.length > 0) {
                    component.set('v.placeholderSA', 'Select a saved bank account');
                } else {
                    component.set('v.placeholderSA', 'No saved bank accounts on file');
                }
                var savedACHPH = component.get('v.placeholderSA');

                var savedCards = component.get('v.savedCardList');
                if (savedCards.length > 0) {
                    component.set('v.placeholderSC', 'Select a saved card');
                } else {
                    component.set('v.placeholderSC', 'No saved cards on file');
                }

                var savedCardsPH = component.get('v.placeholderSC');
                component.set('v.Spinner', false);
            } else {
                component.set('v.Spinner', false);
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    showToast: function (message, type) {
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

    submitExistCardForm: function (component, event, helper) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var obj = component.get('v.ObjectName');
        var pby = component.get('v.payByCardInfo');
        var saveWithXC = {};
        saveWithXC.TaxAction = TaxAction;
        saveWithXC.CustomCustId = component.get("v.CustomCustomerDetail.Ebiz_C__EBizCharge_CustomerId__c");
        saveWithXC.CustExternalId = component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Internal_ID__c  ');
        saveWithXC.CustAmount = parseFloat(component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Amount__c'));
        var Amount = parseFloat(component.get('v.Amount'));
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount);
            Tax = parseFloat(0.0);
        }
        saveWithXC.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        saveWithXC.Tax = parseFloat(Tax);
        saveWithXC.PaymentTotal = component.get('v.PaymentTotal');
        saveWithXC.selectedCardId = pby.selectedCardXC;
        saveWithXC.cvcNo = pby.cvcXC;
        saveWithXC.SendReceiptTo = pby.SendReceiptToXC;
        saveWithXC.addEmails = pby.addEmailsXC;
        saveWithXC.Terminal = 'Custom';
        saveWithXC.isRecurring = false;
        if (obj == 'Order') {
            saveWithXC.OrdersfID = component.get("v.orderDetail.Id");
            saveWithXC.OrderId = component.get("v.orderDetail.OrderNumber");
            saveWithXC.OrderNo = component.get("v.orderDetail.OrderNumber");
            saveWithXC.paymentType = component.get('v.paymentType');
        } else {
            saveWithXC.OrderId = '00000';
            saveWithXC.OrderNo = '00000';
        }
        if (obj == 'Opportunity') {
            saveWithXC.OpportunityId = component.get("v.OpportunityDetail.Id");
            saveWithXC.OpportunityName = component.get("v.OpportunityDetail.Name");
        }
        var action = component.get("c.processPaymentWithXCApxcCustomCustomer");
        action.setParams({
            savedCardJson: JSON.stringify(saveWithXC),
            conDetail: component.get("v.CustomCustomerDetail"),
            ObjName: obj,
        });
        action.setCallback(this, function (a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.Spinner', false);
                    this.showToastMsg('Payment processed successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    this.clearAllFields(component, event, 'CC');
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    this.showToastMsg(retValue, 'Error');
                    this.showToastMsg('Payment did not process. Please try again', 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToastMsg('Payment did not process. Please try again', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    submitAddNewCardForm: function (component, event, helper) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var obj = component.get('v.ObjectName');
        var pby = component.get('v.payByCardInfo');
        var addNewCard = {};
        addNewCard.TaxAction = TaxAction;
        addNewCard.CustomCustId = component.get("v.CustomCustomerDetail.Ebiz_C__EBizCharge_CustomerId__c");
        addNewCard.CustExternalId = component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Internal_ID__c  ');
        addNewCard.CustAmount = parseFloat(component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Amount__c'));
        var Amount = parseFloat(component.get('v.Amount'));
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount);
            Tax = parseFloat(0.0);
        }
        addNewCard.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        addNewCard.Tax = parseFloat(Tax);
        addNewCard.PaymentTotal = component.get('v.PaymentTotal');
        addNewCard.CardNumber = pby.CardNumber;
        addNewCard.BillingAddress = pby.BillingAddress;
        addNewCard.expiryMonth = pby.expiryMonth;
        addNewCard.expiryYear = pby.expiryYear;
        addNewCard.CVCNumber = pby.CVCNumber;
        addNewCard.ZipCode = pby.ZipCode;
        addNewCard.CardHolderName = pby.CardHolderName;
        addNewCard.saveCard = pby.saveCard;
        addNewCard.SendReceiptTo = pby.SendReceiptTo;
        addNewCard.addEmails = pby.addEmails;
        addNewCard.MethodName = pby.MethodName;
        addNewCard.Terminal = 'Custom';
        addNewCard.isRecurring = false;
        if (obj == 'Order') {
            addNewCard.OrdersfID = component.get("v.orderDetail.Id");
            addNewCard.OrderId = component.get("v.orderDetail.OrderNumber");
            addNewCard.OrderNo = component.get("v.orderDetail.OrderNumber");
            addNewCard.paymentType = component.get('v.paymentType');
        } else {
            addNewCard.OrderId = '00000';
            addNewCard.OrderNo = '00000';
            addNewCard.paymentType = 'Sale';
        }
        if (obj == 'Opportunity') {
            addNewCard.OpportunityId = component.get("v.OpportunityDetail.Id");
            addNewCard.OpportunityName = component.get("v.OpportunityDetail.Name");
        }
        addNewCard.resResultCode = component.get("v.resResultCode");
        addNewCard.paymentMethodIDVar = component.get("v.paymentMethodIDVar");
        addNewCard.resError = component.get("v.resError");
        var action = component.get("c.processPaymentWithNCApxcCustomCustomer");
        action.setParams({
            addNewCardJSON: JSON.stringify(addNewCard),
            conDetail: component.get("v.CustomCustomerDetail"),
            ObjName: obj
        });
        try {
            action.setCallback(this, function (a) {
                if (a.getState() === "SUCCESS") {
                    var retValue = a.getReturnValue();
                    if (retValue == 'Success') {
                        component.set('v.Spinner', false);
                        this.showToastMsg('Payment processed successfully!', 'Success');
                        component.set('v.disableSubmitBtn', true);
                        this.clearAllFields(component, event, 'CC');
                        window.location.reload();
                    } else {
                        component.set('v.Spinner', false);
                        this.showToastMsg('Payment did not process. Please try again', 'Error');
                    }
                } else {
                    var errors = a.getError();
                    component.set('v.Spinner', false);
                    this.showToastMsg('Payment did not process. Please try again!', 'Error');
                }
            });
            $A.enqueueAction(action);
        } catch (err) {
            component.set('v.Spinner', false);
            this.showToastMsg('Payment did not process. Please try again', 'Error');
        }
    },
    submitSavedACHForm: function (component, event) {
        var pby = component.get('v.payByACHInfo');
        var obj = component.get('v.ObjectName');
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var savedACH = {};
        savedACH.TaxAction = TaxAction;
        savedACH.CustomCustId = component.get("v.CustomCustomerDetail.Ebiz_C__EBizCharge_CustomerId__c");
        savedACH.CustExternalId = component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Internal_ID__c  ');
        savedACH.CustAmount = parseFloat(component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Amount__c'));
        var Amount = parseFloat(component.get('v.Amount'));
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount);
            Tax = parseFloat(0.0);
        }
        savedACH.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        savedACH.Tax = parseFloat(Tax);
        savedACH.PaymentTotal = component.get('v.PaymentTotal');
        savedACH.selectedACHId = pby.selectedACHId;
        savedACH.SendReceiptTo = pby.SendReceiptTo;
        savedACH.addEmails = pby.addEmails;
        savedACH.Terminal = 'Custom';
        savedACH.isRecurring = false;
        if (obj == 'Order') {
            savedACH.OrdersfID = component.get("v.orderDetail.Id");
            savedACH.OrderId = component.get("v.orderDetail.OrderNumber");
            savedACH.OrderNo = component.get("v.orderDetail.OrderNumber");
            savedACH.paymentType = component.get('v.paymentType');
        } else {
            savedACH.OrderId = '00000';
            savedACH.OrderNo = '00000';
        }
        if (obj == 'Opportunity') {
            savedACH.OpportunityId = component.get("v.OpportunityDetail.Id");
            savedACH.OpportunityName = component.get("v.OpportunityDetail.Name");
        }
        var action = component.get("c.procesPaymentWithSavedACHApxcCustomCustomer");
        action.setParams({
            savedACHJSON: JSON.stringify(savedACH),
            conDetail: component.get("v.CustomCustomerDetail"),
            ObjName: obj,
        });
        action.setCallback(this, function (a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.Spinner', false);
                    this.showToastMsg('Payment processed successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    this.clearAllFields(component, event, 'ACH');
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    this.showToastMsg(retValue, 'Error');
                    this.showToastMsg('Payment did not process. Please try again', 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToastMsg('Payment did not process. Please try again', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    submitAddNewACHForm: function (component, event) {
        var pby = component.get('v.payByACHInfo');
        var obj = component.get('v.ObjectName');
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var addNewACH = {};
        addNewACH.TaxAction = TaxAction;
        addNewACH.CustomCustId = component.get("v.CustomCustomerDetail.Ebiz_C__EBizCharge_CustomerId__c");
        addNewACH.CustExternalId = component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Internal_ID__c  ');
        addNewACH.CustAmount = parseFloat(component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Amount__c'));
        var Amount = parseFloat(component.get('v.Amount'));
        var Tax = parseFloat(component.get('v.Tax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount);
            Tax = parseFloat(0.0);
        }
        addNewACH.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        addNewACH.Tax = parseFloat(Tax);
        addNewACH.PaymentTotal = component.get('v.PaymentTotal');
        addNewACH.accHolderName = pby.accHolderName;
        addNewACH.accNumber = pby.accNumber;
        addNewACH.accRoutNumber = pby.accRoutNumber;
        addNewACH.accType = pby.accType;
        addNewACH.saveACH = pby.saveACH;
        addNewACH.SendReceiptTo = pby.SendReceiptTo;
        addNewACH.addEmails = pby.addEmails;
        addNewACH.Terminal = 'Custom';
        addNewACH.isRecurring = false;
        addNewACH.MethodName = pby.MethodName;
        if (obj == 'Order') {
            addNewACH.OrdersfID = component.get("v.orderDetail.Id");
            addNewACH.OrderId = component.get("v.orderDetail.OrderNumber");
            addNewACH.OrderNo = component.get("v.orderDetail.OrderNumber");
            addNewACH.paymentType = component.get('v.paymentType');
        } else {
            addNewACH.OrderId = '00000';
            addNewACH.OrderNo = '00000';
        }
        if (obj == 'Opportunity') {
            addNewACH.OpportunityId = component.get("v.OpportunityDetail.Id");
            addNewACH.OpportunityName = component.get("v.OpportunityDetail.Name");
        }
        var action = component.get("c.processPaymentNewACHApxcCustomCustomer");
        action.setParams({
            addNewACHJSON: JSON.stringify(addNewACH),
            conDetail: component.get("v.CustomCustomerDetail"),
            ObjName: obj,
        });
        action.setCallback(this, function (a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.Spinner', false);
                    this.showToastMsg('Payment processed successfully!', 'Success');
                    component.set('v.disableSubmitBtn', true);
                    this.clearAllFields(component, event, 'ACH');
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    this.showToastMsg(retValue, 'Error');
                    this.showToastMsg('Payment did not process. Please try again', 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToastMsg('Payment did not process. Please try again', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    showToastMsg: function (message, type) {
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
    clearAllFields: function (component, event, PayBy) {
        component.set('v.disableSubmitBtn', true);
        component.set('v.Amount', 0);
        component.set('v.Tax', 0);
        component.set('v.PaymentTotal', 0);
        if (PayBy == 'ACH') {
            var childComp = component.find('UseCmpPayByACH');
            childComp.callChildFields();
        } else {
            var childComp = component.find('UseCmpPayByCard');
            childComp.callChildFields();
        }
    },
})