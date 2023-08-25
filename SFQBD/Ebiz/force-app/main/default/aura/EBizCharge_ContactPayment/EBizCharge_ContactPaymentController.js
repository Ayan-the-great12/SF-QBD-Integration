({
    doInit: function(component, event, helper) {},
    handleParentActiveTab: function(cmp, event, helper) {
        var tab = event.getSource();
        tab = tab.get('v.id');
        cmp.set('v.ActiveTab', tab);
    },
    onChangeAmount: function(component, evt, helper) {
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
    },
    processPayment: function(component, event, helper) {
        component.set('v.Spinner', true);
        var activeTab = component.get('v.ActiveTab');
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
    },
    UpdateRetryHandler: function(component, event, helper) {
        component.set('v.resResultCode', '');
        component.set('v.paymentMethodIDVar', '');
        component.set('v.resError', '');
        component.set('v.Spinner', true);
        helper.voidTransactionWithoutReload(component, event);
    },
    AcceptTransactionHandler: function(component, event, helper) {
        component.set('v.Spinner', true);
        component.set('v.isAVSCheck', false);
        if (component.get('v.UseFullAmountForAVS') == true) {} else {
            helper.voidAVSTransaction(component, event);
        }
        component.set('v.Spinner', true);
        helper.submitAddNewCardForm(component, event);
    },
    CancelTransactionHandler: function(component, event, helper) {
        component.set('v.avsCheckAction', 'Cancel');
        component.set('v.avsCheckModalHeader', 'Void a Transaction');
    },
    cancelHandler: function(component, event, helper) {
        component.set('v.avsCheckModalHeader', 'Security Mismatch');
        component.set('v.avsCheckAction', 'Mismatch');
    },
    voideHandler: function(component, event, helper) {
        component.set('v.resResultCode', '');
        component.set('v.paymentMethodIDVar', '');
        component.set('v.resError', '');
        component.set('v.Spinner', true);
        helper.voidTransaction(component, event);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
        $A.get('e.force:refreshView').fire();
    },
})