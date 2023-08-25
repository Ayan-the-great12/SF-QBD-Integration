({
    refundORvoid: function(component, event, Type) {
        var RefNo = component.get("v.strObj.refNum");
        var amount;
        if (Type == 'partially refund') {
            amount = component.get("v.RefundAmount");
        } else {
            amount = component.get("v.strObj.amount");
        }
        var aTax = component.get("v.strObj.Tax");
        var OrderId = component.get("v.strObj.OrderId");
        var AccountId = component.get("v.strObj.AccountId");
        var action = component.get("c.refundORVoidApxc");
        action.setParams({
            aType: Type,
            RefNo: RefNo,
            Amount: amount,
            Tax: aTax,
            OrderId: OrderId,
            AccountId: AccountId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var res = response.getReturnValue();
            if (state === "SUCCESS") {
                if (res == 'Success') {
                    this.showToastMsg('Transaction ' + Type + 'ed successfully!', 'Success');
                } else if (res == 'Gateway Success') {
                    this.showToastMsg('No local reference for transaction is found and transaction ' + Type + 'ed successfully on the gateway!', 'Success');
                } else if (res == '') {
                    this.showToastMsg('Record not found in salesforce and transaction ' + Type + 'ed successfully on the gateway!', 'Success');
                } else {
                    this.showToastMsg(res, 'Error');
                }
                $A.get('e.force:refreshView').fire();
                component.set("v.Spinner", false);
                component.set("v.isOpen", false);
            } else {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {}
                }
                component.set("v.Spinner", false);
                component.set("v.isOpen", false);
                this.showToastMsg('Darn it! Something went wrong', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    sendTransactionEmail: function(component, event) {
        var emailTo = component.find("receiptEmail").get("v.value");
        var RefNo = component.get("v.strObj.refNum");
        var action = component.get("c.sendReceiptToCustomerApex");
        action.setParams({
            Refno: RefNo,
            sendTo: emailTo
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.Spinner", false);
                component.set("v.isOpen", false);
                this.showToastMsg('Transaction receipt sent successfully!', 'Success');
            } else {
                component.set("v.Spinner", false);
                component.set("v.isOpen", false);
                this.showToastMsg('Darn it! Something went wrong', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    showToastMsg: function(msg, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            duration: '5000',
            mode: 'dismissible',
            message: msg,
            type: type,
            title: type + "!",
        });
        toastEvent.fire();
    },
})