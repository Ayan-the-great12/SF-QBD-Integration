({
    getSettings: function(component, event) {
        var action = component.get("c.getSettingsApxc");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var cs = response.getReturnValue();
                if ($A.util.isEmpty(cs.Ebiz_C__Security_Token__c)) {
                    component.set('v.ShowWarn', true);
                } else {
                    component.set('v.ShowWarn', false);
                }
                component.set('v.Settings', cs);
            }
        });
        $A.enqueueAction(action);
    },
    loadEmailTemplates: function(component, event) {
        var action = component.get('c.getEmailTemplatesApxc');
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var templist = response.getReturnValue();
                component.set("v.emailTemplist", templist);
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
    sendEmailPayReq: function(component, event) {
        var ES = component.get('v.ES');
        var sendReq = {};
        sendReq.accountId = ES.accountId;
        sendReq.AccountName = ES.accountName;
        sendReq.OrderNos = ES.OrderNos;
        sendReq.Amount = ES.Amount;
        sendReq.TemplateId = component.get('v.Template');
        sendReq.Subject = component.get('v.Subject');
        sendReq.fromEmail = component.get('v.fromEmail');
        var accountDetail = component.get('v.accountDetail');
        sendReq.toEmail = ES.toEmail;
        sendReq.Notes = component.get('v.Notes');
        var action = component.get("c.sendEmailPayReqApxc");
        action.setParams({
            sendEmailReqJSON: JSON.stringify(sendReq),
            OrdersList: ES.Orders,
            accountDetail: accountDetail
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue.startsWith('@')) {
                    component.set('v.Spinner', false);
                    var res = retValue.split("@");
                    var len = res.length;
                    var text = '';
                    var i;
                    for (i = 0; i < len - 1; i++) {
                        if (i != 0) {
                            text += ' #' + res[i];
                        }
                    }
                    var count = res[len - 1];
                    if (count == '0') {
                        this.showToast('Email Payment request is not sent for' + text, 'Error');
                    } else if (text == '') {
                        this.showToast('Email Payment requests sent successfully!', 'Success');
                    } else {
                        this.showToast('Total Email Payment requests sent ' + count, 'Success');
                        this.showToast('Email Payment request is not sent for ' + text, 'Error');
                    }
                    component.set('v.disableEmailForm', true);
                    this.clearAllFields(component, event);
                } else {
                    component.set('v.Spinner', false);
                    this.showToast('Error ' + retValue + '!', 'Error');
                }
            } else {
                var retValue = a.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + retValue[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    clearAllFields: function(component, event) {
        component.set('v.disableEmailForm', true);
        component.set('v.Template', null);
        component.set('v.Subject', '');
        component.set('v.fromEmail', '');
        component.set('v.Notes', '');
        component.set('v.ES', null);
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