({
    getSettings: function(component, event) {
        var action = component.get("c.getSettingsApxc");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var cs = response.getReturnValue();
                if ($A.util.isEmpty(cs.Ebiz_C__Security_Token__c)) {
                    component.set('v.ShowWarn', true);
                    component.set('v.Spinner', false);
                } else {
                    component.set('v.ShowWarn', false);
                    component.set('v.Spinner', false);
                }
                component.set('v.Settings', cs);
            }
        });
        $A.enqueueAction(action);
    },
    SyncSelectedAccounts: function(component, event) {
        var selectedRecords = component.get("v.SelectedRecords");
                var action = component.get("c.syncAccountsApxc");
                action.setParams({
                    selectedRecords: selectedRecords
                });
                action.setCallback(this, function(response) {
                    this.addPaymentMethodReq(component, event);
                });
                $A.enqueueAction(action);
    },
    getDetail: function(component, event) {
        var obj = component.get('v.ObjectName');
        var action = component.get('c.getDetailApxc');
        action.setParams({
            "recordId": component.get('v.recordId'),
            "ObjectName": obj,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                component.set("v.accountDetail", resInfo.AccountInfo);
                component.set("v.accountName", resInfo.AccountName);
                component.set("v.accountId", resInfo.AccountId);
                component.set("v.toEmail", resInfo.AccountInfo.EBizCharge_Email__c);
                if (obj == 'Order') {
                    var orderId = resInfo.ordDetail.Id;
                    component.set("v.orderId", orderId);
                } else if (obj == 'Opportunity') {
                    var orderId = resInfo.OpportunityDetail.Id;
                    component.set("v.orderId", orderId);
                } else if (obj == 'Quote') {
                    var orderId = resInfo.quoteDetail.Id;
                    component.set("v.orderId", orderId);
                } else if (obj == 'Account' || obj == 'Contact') {
                    var orderId = 'Not an Order';
                    component.set("v.orderId", orderId);
                }
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    loadEmailTemplates: function(component, event) {
        var action = component.get('c.getEmailTemplatesApxc');
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.emailTemplist", res);
            } else {
                toastEvent.setParams({
                    title: 'Error!',
                    message: 'Something went wrong!',
                    duration: ' 5000',
                    key: 'error_alt',
                    type: 'error',
                    mode: 'dismissible'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    addPaymentMethodReq: function(component, event) {
        var sendReq = {};
        sendReq.TemplateId = component.get('v.Template');
        sendReq.Subject = component.get('v.Subject');
        sendReq.FromName = component.get('v.fromName');
        sendReq.fromEmail = component.get('v.fromEmail');
        sendReq.toEmail = component.get('v.toEmail');
        sendReq.Notes = component.get('v.Notes');
        var recordList = component.get("v.SelectedRecords")
        var action = component.get("c.addPayMehtodReqApxc");
        action.setParams({
            sendReqJSON: JSON.stringify(sendReq),
            recordList: recordList
        });
        action.setCallback(this, function(a) {
            var NoOfRequestSend = component.get('v.NoOfRequestSend');
            var state = a.getState();
            if (state == 'SUCCESS') {
                var retValue = a.getReturnValue();
                if (retValue.startsWith('@')) {
                    component.set('v.Spinner', false);
                    var res = retValue.split("@");
                    var len = res.length;
                    var text = '';
                    var i;
                    for (i = 0; i < len - 1; i++) {
                        if (i != 0) {
                            text += ' ' + res[i];
                        }
                    }
                    var count = res[len - 1];
                    if (count == '0') {
                        this.showToast('Pending payment request already exists for ' + text, 'Warning');
                    } else if (text == '') {
                        this.showToast(NoOfRequestSend + ' payment method request(s) successfully sent!', 'Success');
                    } else {
                        this.showToast(count + ' payment method request(s) successfully sent!', 'Success');
                        this.showToast('Pending payment request already exists for ' + text, 'Warning');
                    }
                    component.set('v.disableSubmitBtn', true);
                    component.set('v.isActive', false);
                    this.clearAllFields(component, event);
                    $A.get('e.force:refreshView').fire();
                } else {
                    component.set('v.Spinner', false);
                    component.set('v.isActive', false);
                    this.showToast('Error ' + retValue + '!', 'Error');
                }
            } else {
                var retValue = a.getError();
                component.set('v.Spinner', false);
                component.set('v.isActive', false);
                this.showToast('Something went wrong ' + retValue[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    clearAllFields: function(component, event) {
        component.set('v.Subject', '');
        component.set('v.Notes', '');
        component.set('v.toEmail', '');
        component.set('v.Template', null);
        component.set('v.disableSubmitBtn', true);
    },
    showToast: function(message, type) {
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
    showToastMsg: function(msg, type) {
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