({
    doInit: function(component, event, helper) {},
    voidTransaction: function(component, event, helper) {
        try {
            component.set("v.Spinner", true);
            helper.refundORvoid(component, event, 'void');
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    refundTransaction: function(component, event, helper) {
        try {
            component.set("v.Spinner", true);
            if (component.get("v.PartialPayment")) {
                var amount = component.get('v.RefundAmount');
                if (amount === 0 || amount == '' || parseFloat(amount) <= 0) {
                    helper.showToastMsg('Valid amount required', 'Error');
                    component.set("v.Spinner", false);
                    return;
                }
                helper.refundORvoid(component, event, 'partially refund');
            } else {
                helper.refundORvoid(component, event, 'refund');
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    sendTransactionEmail: function(component, event, helper) {
        try {
            var commentForm = component.find('receiptEmail'),
                valid;
            commentForm.showHelpMessageIfInvalid();
            var allValid = commentForm.get("v.validity").valid;
            if (allValid) {
                component.set("v.Spinner", true);
                helper.sendTransactionEmail(component, event);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    downloadpdf: function(component, event, helper) {
        try {
            var vfUrl = '/apex/downloadPDF?str=Working';
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": vfUrl
            });
            urlEvent.fire();
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.ReceiptEmail", '');
            component.set("v.isOpen", false);
            component.set("v.PartialPayment", false);
            component.set("v.RefundAmount", '');
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    valueChecker: function(component, event, helper) {
       var refundValue= component.get('v.RefundAmount');
       if(refundValue.length>0){
        component.set('v.disabled',false);
       }else{
        component.set('v.disabled',true);
       }
    }
})