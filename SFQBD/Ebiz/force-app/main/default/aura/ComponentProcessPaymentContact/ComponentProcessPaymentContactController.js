({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.updatePaymentType(component, event, helper, 'a');
            var cs = component.get('v.Settings');
            if (cs.Ebiz_C__Tax_Action__c == 'Tax Included') {
                var str = 'Tax(' + cs.Ebiz_C__Tax_Default_Percent__c + '%)';
                component.set('v.TaxTitle', str);
            } else {
                if (cs.Ebiz_C__Tax_Calculate_By__c == 'Auto') {
                    var str = 'Tax(' + cs.Ebiz_C__Tax_Default_Percent__c + '%)';
                    component.set('v.TaxTitle', str);
                } else {
                    if (cs.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
                        var str = 'Tax(%value)';
                        component.set('v.TaxTitle', str);
                    } else {
                        var str = 'Tax($amount)';
                        component.set('v.TaxTitle', str);
                    }
                }
            }
            helper.getContactDetail(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleParentActiveTab: function(component, event, helper) {
        try {
            var tab = event.getSource();
            tab = tab.get('v.id');
            if (tab == 'PayByACH') {
                helper.updatePaymentType(component, event, helper, 'b');
            } else {
                helper.updatePaymentType(component, event, helper, 'a');
            }
            component.set('v.ParentActiveTab', tab);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    onChangeAmount: function(component, evt, helper) {
        try {
            var obj = component.get('v.ObjectName');
            var Settings = component.get('v.Settings');
            var TaxAction = Settings.Ebiz_C__Tax_Action__c;
            var ShowTaxField = Settings.Ebiz_C__Show_Tax_Field__c;
            var amount = component.get('v.Amount');
            var Tax = 0.0;
            if (obj == 'Order') {
                var OrderAmount = component.get('v.orderDetail.TotalAmount');
                var EbizAmount = component.get('v.orderDetail.Ebiz_C__EBizCharge_Amount__c');
                var OrderBalance = component.get('v.orderDetail.Ebiz_C__EBizCharge_Order_Balance__c');
                var payType = component.get('v.paymentType');
                if (payType == 'Deposit' || payType == 'Sale') {
                    if (EbizAmount == null || EbizAmount == 0) {
                        if (amount > OrderAmount) {
                            amount = OrderAmount;
                            component.set('v.Amount', OrderAmount);
                            helper.showToastMsg('Amount should be equal or less than order amount', 'Warning');
                        }
                    } else {
                        if (amount > OrderBalance) {
                            amount = OrderBalance;
                            component.set('v.Amount', OrderBalance);
                            helper.showToastMsg('Amount should be equal or less than order remaining amount', 'Warning');
                        }
                    }
                } else if (payType == 'Preauth') {
                    if (EbizAmount == null || EbizAmount == 0) {
                        if (amount < OrderAmount) {
                            amount = OrderAmount;
                            component.set('v.Amount', OrderAmount);
                            helper.showToastMsg('Amount should be equal or greater than order amount', 'Warning');
                        }
                    } else {
                        if (amount < OrderBalance) {
                            amount = OrderBalance;
                            component.set('v.Amount', OrderBalance);
                            helper.showToastMsg('Amount should be equal or greater than order remaining amount', 'Warning');
                        }
                    }
                }
            }
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
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    PaymentHandler: function(component, evt, helper) {
        try {
            var selectedOptionValue = evt.getParam("value");
            component.set('v.paymentType', selectedOptionValue);
            var a = component.get('c.onChangeAmount');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    /*processPayment : function(component, event, helper) {
        component.set('v.Spinner',true);
        var tab = component.get('v.ParentActiveTab');
        var childComp = '';
        if(tab == 'PayByCard'){
            childComp = component.find('UseAccCmpPayByCard');
        }else if(tab == 'PayByACH'){
            childComp = component.find('UseAccCmpPayByACH');
        }
        
        childComp.validateAndSubmitForm();
        component.set('v.Spinner',false);
    },
    */
    processPayment: function(component, event, helper) {
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
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    UpdateRetryHandler: function(component, event, helper) {
        try {
            component.set('v.resResultCode', '');
            component.set('v.paymentMethodIDVar', '');
            component.set('v.resError', '');
            component.set('v.Spinner', true);
            helper.voidTransactionWithoutReload(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    AcceptTransactionHandler: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set('v.isAVSCheck', false);
            if (component.get('v.UseFullAmountForAVS') == true) {} else {
                helper.voidAVSTransaction(component, event);
            }
            component.set('v.Spinner', true);
            helper.submitAddNewCardForm(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    CancelTransactionHandler: function(component, event, helper) {
        try {
            component.set('v.avsCheckAction', 'Cancel');
            component.set('v.avsCheckModalHeader', 'Void a Transaction');
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    cancelHandler: function(component, event, helper) {
        try {
            component.set('v.avsCheckModalHeader', 'Security Mismatch');
            component.set('v.avsCheckAction', 'Mismatch');
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    voideHandler: function(component, event, helper) {
        try {
            component.set('v.resResultCode', '');
            component.set('v.paymentMethodIDVar', '');
            component.set('v.resError', '');
            component.set('v.Spinner', true);
            helper.voidTransaction(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
            $A.get('e.force:refreshView').fire();
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
})