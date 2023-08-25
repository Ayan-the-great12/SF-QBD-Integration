({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var DefaultOrdersPay = [];
            DefaultOrdersPay.push({
                'label': 'Allow pre-auths and deposits to be taken on orders',
                'value': 'Pre-auths and Deposit'
            });
            DefaultOrdersPay.push({
                'label': 'Allow only pre-auths on orders',
                'value': 'Pre-auths'
            });
            DefaultOrdersPay.push({
                'label': 'Allow only deposits on orders',
                'value': 'Deposit'
            });
            component.set('v.DefaultOrdersPay', DefaultOrdersPay);
            var DefaultQuotesPay = [];
            DefaultQuotesPay.push({
                'label': 'Allow pre-auths and deposits to be taken on quotes',
                'value': 'Pre-auths and Deposit'
            });
            DefaultQuotesPay.push({
                'label': 'Allow only pre-auths on quotes',
                'value': 'Pre-auths'
            });
            DefaultQuotesPay.push({
                'label': 'Allow only deposits on quotes',
                'value': 'Deposit'
            });
            component.set('v.DefaultQuotesPay', DefaultQuotesPay);
            var DefaultOppPay = [];
            DefaultOppPay.push({
                'label': 'Allow pre-auths and deposits to be taken on opportunities',
                'value': 'Pre-auths and Deposit'
            });
            DefaultOppPay.push({
                'label': 'Allow only pre-auths on opportunities',
                'value': 'Pre-auths'
            });
            DefaultOppPay.push({
                'label': 'Allow only deposits on opportunities',
                'value': 'Deposit'
            });
            component.set('v.DefaultOppPay', DefaultOppPay);
            var paymentsTab = [];
            paymentsTab.push({
                'label': 'Sale',
                'value': 'Sale'
            });
            component.set('v.paymentsTab', paymentsTab);
            var TaxAction = [{
                    'label': 'Assume tax is already included in entered payment amount',
                    'value': 'Tax Included'
                },
                {
                    'label': 'Tax should be calculated & added to entered payment amount',
                    'value': 'Tax Calculate'
                },
            ];
            component.set('v.TaxAction', TaxAction);
            var TaxManualType = [{
                    'label': 'Use % for sales tax',
                    'value': 'Use Percent'
                },
                {
                    'label': 'Use $ for sales tax',
                    'value': 'Use Dollar'
                },
            ];
            component.set('v.TaxManualType', TaxManualType);
            helper.getSettings(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    TransHandler: function(component, event, helper) {},
    paymentTypeHandler: function(component, event, helper) {
        try {
            var PaymentType = event.getSource().get('v.value');
            component.set('v.Settings.Ebiz_C__Allow_Order_Payment_Type__c', PaymentType);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    TaxActionHandler: function(component, event, helper) {
        try {
            var TaxAction = event.getParam("value");
            component.set('v.Settings.Ebiz_C__Tax_Action__c', TaxAction);
            if (TaxAction == 'Tax Included') {
                component.set('v.Settings.Ebiz_C__Tax_Calculate_By__c', null);
                component.set('v.Settings.Ebiz_C__Tax_Manual_Type__c', null);
            } else {
                component.set('v.Settings.Ebiz_C__Tax_Calculate_By__c', 'Auto');
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    TaxTypeHandler: function(component, event, helper) {
        try {
            var TaxCalculateBy = event.getSource().get('v.value')
            if (TaxCalculateBy == 'Manual') {
                component.set('v.Settings.Ebiz_C__Tax_Default_Percent__c', 0);
            } else {
                component.set('v.Settings.Ebiz_C__Tax_Manual_Type__c', '');
            }
            component.set('v.Settings.Ebiz_C__Tax_Calculate_By__c', TaxCalculateBy);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    TaxManualHandler: function(component, event, helper) {
        try {
            var ManualType = event.getParam("value");
            component.set('v.Settings.Ebiz_C__Tax_Manual_Type__c', ManualType);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    saveSettingsTransactions: function(component, event, helper) {
        try {
            helper.saveSettingsNew(component, event, 'Transactions ');
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
})