({
    inlineEditColmun: function(component, event, helper) {
        try {
            var editCol = component.get('v.editCol');
            if (editCol == 'Email') {
                component.set("v.EmailEditMode", true);
            } else if (editCol == 'Amount') {
                component.set("v.paymentEditMode", true);
            }
            setTimeout(function() {
                component.find("inputId").focus();
            }, 100);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    closeInputField: function(component, event, helper) {
        try {
            component.set("v.EmailEditMode", false);
            component.set("v.paymentEditMode", false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    emailHandler: function(component, event, helper) {},
    paymentHandler: function(component, event, helper) {
        var OrderBalance = component.get('v.singleRec.OrderBalance');
        var payAmount = component.get('v.singleRec.AmountDue');
        if (payAmount > OrderBalance) {
            component.set('v.singleRec.AmountDue', OrderBalance);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                duration: ' 5000',
                mode: 'dismissible',
                message: 'Payment amount should be equal or less than order balance!',
                type: 'Warning',
                title: "Warning!",
            });
            toastEvent.fire();
        } else {
            if (parseInt(payAmount) <= 0) {
                component.set('v.singleRec.AmountDue', OrderBalance);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    duration: ' 5000',
                    mode: 'dismissible',
                    message: "Payment amount should be greater than zero!",
                    type: 'Warning',
                    title: "Warning!",
                });
                toastEvent.fire();
            } else {
                var p = component.get('v.parentComp');
                var CompName = component.get('v.CompName');
                if (CompName == 'pp') {
                    p.updatePaymentTotal();
                } else {
                    p.updateTax();
                }
            }
        }
    },
})