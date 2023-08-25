({
    doInit: function (component, event, helper) {
        helper.CheckCompSettings(component);
        var objectName = component.get('v.sObjectName');
        if (objectName == undefined) {
            helper.CustomObject(component, event, helper);
        }
        var sobjectName = component.get('v.sObjectName');
        if (sobjectName != undefined) {
            if (sobjectName.includes('__c')) {
                helper.UpdateConfigInfo(component, event, helper);
            }
        }
        helper.getCustDetail(component, event);
    },
    forceHandler: function (component, event, helper) {
        component.set('v.Spinner', true);
        var objectName = component.get('v.sObjectName');
        if (objectName == undefined) {
            helper.CustomObject(component, event, helper);
        }
        var sobjectName = component.get('v.sObjectName');
        if (sobjectName != undefined) {
            if (sobjectName.includes('__c')) {
                var custId = component.get('v.recordId');
                helper.UpdateCustomerInfo(component, event, custId);
                helper.getCustomDetail(component, event);
                var delayInMilliseconds = 2000;
                setTimeout(function () {
                    helper.UpdateCustomerInternalId(component, event, custId);
                }, delayInMilliseconds);
                setTimeout(function () {
                    helper.getPaymentMethodsCustomCustomer(component, event, custId);
                }, delayInMilliseconds);
                component.set('v.Spinner', false);
            }
        }
    },
    ObjConfigOnSave: function (component, event, helper) {
        component.set('v.Spinner', true);
        component.set("v.ShowObjConfigModel", false);
        helper.UpdateConfigxApeInfo(component, event, helper);
    },
    ObjConfigModelHandle: function (component, event, helper) {
        helper.UpdateConfigxApeInfoClose(component, event, helper);
    },
    handleChangeAmount: function (cmp, event) {
        var selectedOptionValue = event.getParam("value");
        var OBJ_config = cmp.get("v.ObjectConfig");
        OBJ_config.Ebiz_C__EBizAmountApi__c = selectedOptionValue;
        cmp.set('v.ObjectConfig', OBJ_config);
    },
    handleChangeEmail: function (cmp, event) {
        var selectedOptionValue = event.getParam("value");
        var OBJ_config = cmp.get("v.ObjectConfig");
        OBJ_config.Ebiz_C__EBizCustomerEmailApi__c = selectedOptionValue;
        cmp.set('v.ObjectConfig', OBJ_config);
    },
    handleChangeName: function (cmp, event) {
        var selectedOptionValue = event.getParam("value");
        var OBJ_config = cmp.get("v.ObjectConfig");
        OBJ_config.Ebiz_C__EBizCustomerNameApi__c = selectedOptionValue;
        cmp.set('v.ObjectConfig', OBJ_config);
    },
    handleParentActiveTab: function (component, event, helper) {
        var tab = event.getSource();
        tab = tab.get('v.id');
        component.set('v.ParentActiveTab', tab);
    },
    managePaymentForm: function (component, event, helper) {
        try {
            component.set('v.showModalPayMethodsForCustomCloud', true);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },

    processPayment: function (component, event, helper) {
        try {
            var amount = component.get('v.Amount');
            if (amount === 0 || amount == '' || parseFloat(amount) <= 0) {
                helper.showToastMsg('Valid amount required', 'Error');
                return;
            }
            component.set('v.Spinner', true);
            var activeTab = component.get('v.ParentActiveTab');
            if (activeTab == 'PayByCard') {
                var pby = component.get('v.payByCardInfo');
                if (pby.payBy == 'UseExistingCard') {
                    helper.submitExistCardForm(component, event, helper);
                } else if (pby.payBy == 'AddNewCard') {
                    helper.submitAddNewCardForm(component, event, helper);
                }
            } else if (activeTab == 'PayByACH') {
                var pby = component.get('v.payByACHInfo');
                if (pby.payBy == 'savedACH') {
                    helper.submitSavedACHForm(component, event, helper);
                } else if (pby.payBy == 'addNewACH') {
                    helper.submitAddNewACHForm(component, event, helper);
                }
            }
        } catch (e) {
            component.set('v.Spinner', false);
            helper.showToastMsg('Payment processed unsuccessfully. Please try again', 'Error');
        }
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

    openPaymenthistoryTab: function (component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/payment-history"
        });
        urlEvent.fire();
    }
})