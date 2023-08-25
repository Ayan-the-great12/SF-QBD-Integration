({
    helperMethod: function() {},
    submitSavedACHForm: function(component, event) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var payType = Settings.Ebiz_C__Payments_Tab__c;
        var args = event.getParam("arguments");
        var OS = args.OrderSummary;
        var savedACH = {};
        savedACH.accId = OS.accId;
        savedACH.accExtrId = OS.accExtrId;
        savedACH.ordNos = OS.OrdersNo;
        var Amount = parseFloat(OS.OrderTotal);
        var Tax = parseFloat(OS.OrderTax);
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount);
            Tax = parseFloat(0.0);
        }
        savedACH.ordTotal = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        savedACH.ordTax = parseFloat(Tax);
        savedACH.TaxAction = TaxAction;
        savedACH.selectedACHId = component.get('v.paymentMethodIdSA');
        savedACH.SendReceiptTo = component.get('v.SendReceiptToSA');
        savedACH.addEmails = component.get('v.addEmailsSA');
        var action = component.get("c.procesPaymentWithSavedACHApxc");
        action.setParams({
            savedACHJSON: JSON.stringify(savedACH),
            PaymentType: payType,
            OrdersList: OS.selectedOrders,
            accountDetail: OS.accDetail
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.disabledPayBy', true);
                    component.set('v.Spinner', false);
                    this.clearForm(component, event);
                    this.updateParentComponent(component, event);
                    this.showToast('Payment processed successfully!', 'Success');
                    window.location.reload();
                } else if (retValue == 'rrScheduled') {
                    component.set('v.Spinner', false);
                    component.set('v.disableSubmitBtn', true);
                    this.showToast('Recurring payment successfully scheduled!', 'Success');
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    this.showToast('There is an exception to process the payment!', 'Error');
                }
            } else {
                component.set('v.Spinner', false);
                if (retValue.startsWith('Gateway Response Error')) {
                    this.showToast(retValue, 'Error');
                } else {
                    this.showToast('There is an exception to process the payment!', 'Error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    submitAddNewACHForm: function(component, event) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var payType = Settings.Ebiz_C__Payments_Tab__c;
        var args = event.getParam("arguments");
        var OS = args.OrderSummary;
        var addNewACH = {};
        addNewACH.accId = OS.accId;
        addNewACH.accExtrId = OS.accExtrId;
        addNewACH.ordNos = OS.OrdersNo;
        var Amount = parseFloat(OS.OrderTotal);
        var Tax = parseFloat(OS.OrderTax);
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount);
            Tax = parseFloat(0.0);
        }
        addNewACH.ordTotal = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        addNewACH.ordTax = parseFloat(Tax);
        addNewACH.TaxAction = TaxAction;
        addNewACH.accHolderName = component.get('v.accHolderName');
        addNewACH.accNumber = component.get('v.accNumber');
        addNewACH.accRoutNumber = component.get('v.accRoutNumber');
        addNewACH.accType = component.get('v.accType');
        addNewACH.saveACH = component.get('v.saveACH');
        addNewACH.SendReceiptTo = component.get('v.SendReceiptTo');
        addNewACH.addEmails = component.get('v.addEmails');
        addNewACH.MethodName = component.get('v.MethodName');
        var action = component.get("c.procesPaymentNewACHApxc");
        action.setParams({
            addNewACHJSON: JSON.stringify(addNewACH),
            PaymentType: payType,
            OrdersList: OS.selectedOrders,
            accDetail: OS.accDetail
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.disabledPayBy', true);
                    component.set('v.Spinner', false);
                    this.clearForm(component, event);
                    this.updateParentComponent(component, event);
                    this.showToast('Payment processed successfully!', 'Success');
                    window.location.reload();
                } else {
                    component.set('v.Spinner', false);
                    if (retValue.startsWith('Gateway Response Error')) {
                        this.showToast(retValue, 'Error');
                    } else {
                        this.showToast('There is an exception to process the payment!', 'Error');
                    }
                }
            } else {
                component.set('v.Spinner', false);
                this.showToast('Please refresh the page and try again!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    clearForm: function(component, event) {
        component.set('v.disableSubmitBtn', true);
        component.set('v.card4Degit', '-');
        component.set('v.disableRRbtnSA', true);
        component.set('v.paymentMethodIdSA', '');
        component.set('v.addEmailsSA', '');
        component.set('v.disableRRbtn', true);
        component.set('v.accHolderName', '');
        component.set('v.accNumber', '');
        component.set('v.accRoutNumber', '');
        component.set('v.addEmails', '');
    },
    updateParentComponent: function(component, event, helper) {
        var p = component.get("v.parentComp");
        p.updateOrderGrid();
    },
    showToast: function(msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            duration: ' 5000',
            mode: 'dismissible',
            message: msg,
            type: type,
            title: type + "!",
        });
        toastEvent.fire();
    },
})