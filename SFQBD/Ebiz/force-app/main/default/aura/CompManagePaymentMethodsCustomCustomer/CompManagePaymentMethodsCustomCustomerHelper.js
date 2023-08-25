({
    deletePaymentMethod: function(component, event) {
        var SelectedTab = component.get('v.SelectedTab');
        var methodId = component.get('v.DelThisMethod');
        var action = component.get('c.DeletePaymentMethodApxc');
        action.setParams({
            "accId": component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_CustomerId__c'),
            "internalId": component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Internal_ID__c  '),
            "paymentMethodId": methodId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var payM = response.getReturnValue();
                var savedCard = [];
                var savedACH = [];
                for (var i = 0; i < payM.length; i++) {
                    if (payM[i].MethodType == 'cc') {
                        savedCard.push(payM[i]);
                    } else {
                        savedACH.push(payM[i]);
                    }
                }
                if (SelectedTab == 'CreditCard') {
                    component.set('v.selectedCard', 'addnewcard');
                    component.set('v.CardInfo', null);
                    component.find("setCCdefault").set("v.value", false);
                    component.set('v.isDefault', false);
                    var Elements = component.find('tab');
                } else {
                    component.set('v.selectedACH', 'addnewach');
                    component.set('v.AChInfo', null);
                    component.find("setACHdefault").set("v.value", false);
                    component.set('v.isDefault', false);
                    var Elements = component.find('tabACH');
                }
                for (var i = 0; i < Elements.length; i++) {
                    var val = Elements[i].getElement().getAttribute('data-id');
                    if (val != 0) {
                        $A.util.removeClass(Elements[i], "slds-is-active");
                    } else {
                        $A.util.addClass(Elements[i], "slds-is-active");
                    }
                }
                component.set("v.savedCardList", savedCard);
                component.set("v.savedACHList", savedACH);
                component.set('v.Spinner', false);
                this.resetObject(component, event);
                this.showToast('Payment method has been deleted!', 'Success');
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    updatePaymentMethod: function(component, event) {
        var strUpd = {};
        var SelectedTab = component.get('v.SelectedTab');
        if (SelectedTab == 'CreditCard') {
            strUpd.MethodType = 'CreditCard';
            strUpd.AccountId = component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_CustomerId__c');
            strUpd.AccInternalId = component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c');
            strUpd.MethodID = component.get('v.CardInfo.MethodID');
            strUpd.MethodName = component.get('v.CardInfo.MethodName');
            strUpd.CardHolderName = component.get('v.CardInfo.AccountHolderName');
            strUpd.isDefault = component.get('v.isDefault');
            strUpd.CardNumber = component.get('v.CardInfo.CardNumber');
            strUpd.expiryMonth = component.get('v.CardInfo.CardExpMonth');
            strUpd.expiryYear = component.get('v.CardInfo.CardExpYear');
            strUpd.CVCNumber = component.get('v.CardInfo.CardCode');
            strUpd.BillingAddress = component.get('v.CardInfo.AvsStreet');
            strUpd.ZipCode = component.get('v.CardInfo.AvsZip');
            strUpd.DateCreated = component.get('v.CardInfo.DateCreated');
            strUpd.SecondarySort = component.get('v.CardInfo.SecondarySort');
        } else {
            strUpd.MethodType = 'ACH';
            strUpd.MethodID = component.get('v.AChInfo.MethodID');
            strUpd.MethodName = component.get('v.AChInfo.MethodName');
            strUpd.AccountHolderName = component.get('v.AChInfo.AccountHolderName');
            strUpd.isDefault = component.get('v.isDefault');
            strUpd.Account = component.get('v.AChInfo.Account');
            strUpd.AccountType = component.get('v.AChInfo.AccountType');
            strUpd.Routing = component.get('v.AChInfo.Routing');
            strUpd.DateCreated = component.get('v.AChInfo.DateCreated');
            strUpd.SecondarySort = component.get('v.AChInfo.SecondarySort');
        }
        var action = component.get('c.updatePaymentMethodApxc');
        action.setParams({
            "accId": component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_CustomerId__c'),
            "internalId": component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Internal_ID__c'),
            "StrObj": JSON.stringify(strUpd)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var payM = response.getReturnValue();
                if (payM[0].IsErrorReturn) {
                    this.showToast(payM[0].AVSretMsg, 'Error');
                    component.set('v.Spinner', false);
                    return;
                }
                if (payM[0].AVSMisMatch == true) {
                    var retMsg = payM[0].AVSretMsg;
                    var arr = retMsg.split('@');
                    var AVSCheck = arr[0];
                    if (AVSCheck == 'AVSCheck') {
                        component.set('v.avsCheckModal', true);
                        component.set('v.avsRefNum', arr[1]);
                        component.set('v.avsCardCode', arr[2]);
                        component.set('v.avsAddress', arr[3]);
                        component.set('v.avsZipCode', arr[4]);
                    } else {
                        this.showToast('Please refresh the page and try again!', 'Error');
                    }
                    component.set('v.avsCheckModalHeader', 'Security Mismatch');
                    component.set('v.avsCheckAction', 'Mismatch');
                    component.set('v.avsAction', 'Update');
                    component.set('v.Spinner', false);
                } else {
                    var savedCard = [];
                    var savedACH = [];
                    for (var i = 0; i < payM.length; i++) {
                        if (payM[i].MethodType == 'cc') {
                            savedCard.push(payM[i]);
                        } else {
                            savedACH.push(payM[i]);
                        }
                    }
                    component.set("v.savedCardList", savedCard);
                    component.set("v.savedACHList", savedACH);
                    component.set('v.Spinner', false);
                    if (SelectedTab == 'CreditCard') {
                        component.set('v.selectedCard', 'addnewcard');
                        this.resetObject(component, event);
                    } else {
                        component.set('v.selectedACH', 'addnewach');
                        this.resetObject(component, event);
                    }
                    this.showToast('Payment method has been updated!', 'Success');
                }
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    addPaymentMethod: function(component, event) {
        var strUpd = {};
        var SelectedTab = component.get('v.SelectedTab');
        if (SelectedTab == 'CreditCard') {
            strUpd.AccountId = component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_CustomerId__c');
            strUpd.AccInternalId = component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Internal_ID__c');
            strUpd.MethodType = 'CreditCard';
            strUpd.MethodName = component.get('v.CardInfo.MethodName');
            strUpd.CardHolderName = component.get('v.CardInfo.AccountHolderName');
            strUpd.isDefault = component.get('v.isDefault');
            strUpd.CardNumber = component.get('v.CardInfo.CardNumber');
            strUpd.CVCNumber = component.get('v.CardInfo.CardCode');
            strUpd.expiryMonth = component.get('v.CardInfo.CardExpMonth');
            strUpd.expiryYear = component.get('v.CardInfo.CardExpYear');
            strUpd.BillingAddress = component.get('v.CardInfo.AvsStreet');
            strUpd.ZipCode = component.get('v.CardInfo.AvsZip');
            strUpd.isAVSCheck = component.get('v.isAVSCheck');
        } else {
            strUpd.MethodType = 'ACH';
            strUpd.MethodName = component.get('v.AChInfo.MethodName');
            strUpd.AccountHolderName = component.get('v.AChInfo.AccountHolderName');
            strUpd.isDefault = component.get('v.isDefault');
            strUpd.Account = component.get('v.AChInfo.Account');
            strUpd.AccountType = component.get('v.AChInfo.AccountType');
            strUpd.Routing = component.get('v.AChInfo.Routing');
        }
        var action = component.get('c.addPaymentMethodApxc');
        action.setParams({
            "accId": component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_CustomerId__c'),
            "internalId": component.get('v.CustomCustomerDetail.Ebiz_C__EBizCharge_Internal_ID__c '),
            "StrObj": JSON.stringify(strUpd)
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state == "SUCCESS") {
                var payM = response.getReturnValue();
                if (payM[0].IsErrorReturn) {
                    this.showToast(payM[0].AVSretMsg, 'Error');
                    component.set('v.Spinner', false);
                    return;
                }
                if (payM[0].AVSMisMatch == true) {
                    var retMsg = payM[0].AVSretMsg;
                    var arr = retMsg.split('@');
                    var AVSCheck = arr[0];
                    if (AVSCheck == 'AVSCheck') {
                        component.set('v.avsCheckModal', true);
                        component.set('v.avsRefNum', arr[1]);
                        component.set('v.avsCardCode', arr[2]);
                        component.set('v.avsAddress', arr[3]);
                        component.set('v.avsZipCode', arr[4]);
                    } else {
                        this.showToast('Please refresh the page and try again!', 'Error');
                    }
                    component.set('v.avsCheckModalHeader', 'Security Mismatch');
                    component.set('v.avsCheckAction', 'Mismatch');
                    component.set('v.avsAction', 'Add');
                    component.set('v.Spinner', false);
                } else {
                    var savedCard = [];
                    var savedACH = [];
                    for (var i = 0; i < payM.length; i++) {
                        if (payM[i].MethodType == 'cc') {
                            savedCard.push(payM[i]);
                        } else {
                            savedACH.push(payM[i]);
                        }
                    }
                    this.showToast('Payment method has been successfully saved!', 'Success');
                    component.set("v.savedCardList", savedCard);
                    component.set("v.savedACHList", savedACH);
                    this.resetObject(component, event);
                    component.set('v.Spinner', false);
                }
            } else {
                var errors = response.getError();
                component.set('v.Spinner', false);
                this.showToast('Please refresh the page and try again!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    voidTransaction: function(component, event) {
        var avsRefNum = component.get('v.avsRefNum');
        var action = component.get('c.invokeTransactionVoidApxc');
        action.setParams({
            avsRefNum: avsRefNum
        });
        action.setCallback(this, function(a) {
            component.set('v.Spinner', false);
            if (a.getState() === "SUCCESS") {
                component.set("v.avsCheckModal", false);
                this.showToast('Payment voided successfully!', 'Success');
                window.location.reload(true);
            } else {
                component.set("v.avsCheckModal", false);
                this.showToast('Something went wrong to void the payment!', 'Error');
                window.location.reload(true);
            }
        });
        $A.enqueueAction(action);
    },
    voidAVSTransaction: function(component, event) {
        var avsRefNum = component.get('v.avsRefNum');
        var action = component.get('c.invokeTransactionVoidApxc');
        action.setParams({
            avsRefNum: avsRefNum
        });
        action.setCallback(this, function(a) {
            component.set('v.Spinner', false);
            if (a.getState() === "SUCCESS") {
                component.set("v.avsCheckModal", false);
                window.location.reload(true);
            } else {
                component.set("v.avsCheckModal", false);
                window.location.reload(true);
            }
        });
        $A.enqueueAction(action);
    },
    voidTransactionWithoutReload: function(component, event) {
        var avsRefNum = component.get('v.avsRefNum');
        var action = component.get('c.invokeTransactionVoidApxc');
        action.setParams({
            avsRefNum: avsRefNum
        });
        action.setCallback(this, function(a) {
            component.set('v.Spinner', false);
            component.set("v.avsCheckModal", false);
        });
        $A.enqueueAction(action);
    },
    resetObject: function(component, event) {
        component.set('v.isDefault', false);
        component.set('v.disableSubmitBtn', true);
        var obj = {};
        obj.MethodType = '';
        obj.MethodID = '';
        obj.MethodName = '';
        obj.DateCreated = null;
        obj.DateModified = null;
        obj.AccountHolderName = '';
        obj.AvsStreet = '';
        obj.AvsZip = '';
        obj.CardExpiration = '';
        obj.CardExpMonth = '';
        obj.CardExpYear = '';
        obj.CardNumber = '';
        obj.CardCode = '';
        obj.Last4Degit = '';
        obj.CardType = '';
        obj.Account = '';
        obj.AccountType = '';
        obj.Routing = '';
        obj.SecondarySort = 0;
        component.set('v.CardInfo', obj);
        component.set('v.AChInfo', obj);
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