({
    getDetail: function(component, event) {
        var obj = component.get('v.ObjectName');
        var customerId = component.get('v.recordId');
        var action = component.get('c.getDetailApxcCustomCustomer');
        action.setParams({
            "CustomerId": customerId,
            "objectName": obj,
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                component.set("v.CustomCustomerDetail", resInfo.CustomCustInfo);
                component.set("v.CustomCustName", resInfo.CustomCustName);
                component.set("v.CustomCustId", resInfo.CustomCustInfo.Ebiz_C__EBizCharge_CustomerId__c);
                component.set("v.Amount", resInfo.CustomCustInfo.Ebiz_C__EBizCharge_Amount_Source__c);
                if (resInfo.CustomCustomerEmail != null) {
                    component.set('v.TempEmail', resInfo.CustomCustomerEmail);
                }
                component.set('v.TempContactEmail', resInfo.ContactEmail);
                component.set('v.TempAccountEmail', resInfo.AccountEmail);
                var TitleName = '';
                TitleName = 'Customer: ' + resInfo.CustomCustName;
                component.set('v.TitleName', TitleName);
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
                component.set('v.PaymentTotal', TotalAmount)
                component.set('v.Spinner', false);
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToast('Please refresh the page and try again!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    loadEmailTemplates: function(component, event) {
        var settings = component.get('v.Settings');
        var action = component.get('c.getEmailTemplatesApxc');
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var res = response.getReturnValue();
                component.set("v.emailTemplist", res);
                if (res != null && res != undefined && res.length > 0) {
                    if (settings.Ebiz_C__EbizCharge_Custom_Email_Pay__c == true) {
                        for (var i = 0; i < res.length; i++) {
                            if (res[i].TemplateType == 'TransactionReceiptCustomer') {
                                component.set("v.Template", res[i].TemplateInternalId);
                                this.getTemplateInfo(component, event);
                                this.sendEmailPayReq(component, event);
                                break;
                            }
                        }
                    }
                } else {
                    this.showToast('Please add an email template!', 'Warning');
                }
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
    getTemplateInfo: function(component, event, helper) {
        var originallist = component.get("v.emailTemplist");
        var search = component.get("v.Template");
        if (!$A.util.isEmpty(search)) {
            for (var e in originallist) {
                if (originallist[e].TemplateInternalId == search) {
                    component.set("v.Subject", originallist[e].TemplateSubject);
                    component.set("v.fromEmail", originallist[e].FromEmail);
                    component.set('v.fromName', originallist[e].TemplateFromName);
                    return null;
                } else {
                    component.set("v.Subject", '');
                    component.set("v.fromEmail", '');
                    component.set('v.disableSubmitBtn', true);
                }
            }
        } else {
            component.set("v.Subject", '');
            component.set("v.fromEmail", '');
            component.set('v.disableSubmitBtn', true);
        }
    },
    sendEmailPayReq: function(component, event) {
        var settings = component.get('v.Settings');
        var notifyCheck = settings.Ebiz_C__EbizCharge_Notify_Customer__c;
        var webUrl = settings.Ebiz_C__EbizCharge_Custom_Email_Pay__c;
        var standardEmailPay = settings.Ebiz_C__EbizCharge_Standard_Email_Pay__c;
        var Amount = parseFloat(component.get('v.Amount'));
        if (Amount === 0 || Amount == '') {
            if (standardEmailPay) {
                this.showToast('Please enter a valid amount!', 'Error');
                component.set('v.Spinner', false);
                return;
            } else if (webUrl) {
                this.showToast('Please enter a valid amount!', 'Error');
                this.clearAllFields(component, event);
                component.set('v.showCmpPopUp', "");
                return;
            }
        }
        var CustomCustomerDetail = component.get('v.CustomCustomerDetail');
        var customerId = component.get('v.recordId');
        var tempEmail = component.get('v.TempEmail');
        var TaxAction = settings.Ebiz_C__Tax_Action__c;
        var obj = component.get('v.ObjectName');
        var sendReq = {};
        if (Amount > 0) {
            var Tax = parseFloat(component.get('v.Tax'));
            if (TaxAction == 'Tax Included') {
                Amount = parseFloat(Amount) - parseFloat(Tax);
            }
            sendReq.Amount = parseFloat(Amount);
            if (settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent' && (!(settings.Ebiz_C__Tax_Calculate_By__c == 'Auto'))) {
                Tax = Tax / 100;
                Tax = (Amount * Tax).toFixed(2);
            }
            sendReq.Tax = parseFloat(Tax);
        } else {
            component.set('v.Spinner', false);
        }
        sendReq.PaymentTotal = parseFloat(component.get('v.PaymentTotal'));
        sendReq.TemplateId = component.get('v.Template');
        sendReq.Subject = component.get('v.Subject');
        sendReq.fromName = component.get('v.fromName');
        sendReq.fromEmail = component.get('v.fromEmail');
        if (webUrl) {
            if (tempEmail == null || tempEmail == undefined || tempEmail == '') {
                this.showToast("Please add an email on this record or related Account/Contact!", 'Warning');
                this.clearAllFields(component, event);
                component.set('v.showCmpPopUp', "");
                return;
            } else {
                sendReq.toEmail = component.get('v.TempEmail');
            }
        } else {
            sendReq.toEmail = component.get('v.TempEmail');
        }
        sendReq.Notes = component.get('v.Notes');
        sendReq.TaxAction = TaxAction;
        sendReq.customerId = component.get("v.CustomCustId");
        sendReq.customerName = component.get("v.CustomCustName");
        var action = component.get("c.sendEmailPayRequestApxcCustom");
        action.setParams({
            "webUrl": webUrl,
            "notifyCheck": notifyCheck,
            "customerId": customerId,
            "ObjName": obj,
            "sendEmailReqJSON": JSON.stringify(sendReq),
            CustomCustomerDetail: CustomCustomerDetail
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                if (retValue == 'Success') {
                    component.set('v.Spinner', false);
                    component.set('v.disableSubmitBtn', true);
                    this.showToast('Payment request successfully sent!', 'Success');
                    this.clearAllFields(component, event);
                    component.set("v.isOpen", false);
                    window.location.reload(true);
                } else if (retValue == 'Already Pending') {
                    component.set('v.Spinner', false);
                    component.set('v.disableSubmitBtn', true);
                    this.showToast('Payment request is already pending!', 'Error');
                    this.clearAllFields(component, event);
                    component.set("v.isOpen", false);
                    window.location.reload(true);
                } else {
                    component.set('v.Spinner', false);
                    this.showToast('There was an error to send email payment request!', 'Error');
                }
            } else {
                component.set('v.Spinner', false);
                this.showToast('Please refresh the page and try again!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    clearAllFields: function(component, event) {
        component.set('v.Amount', null);
        component.set('v.Tax', null);
        component.set('v.PaymentTotal', 0.0);
        component.set('v.Subject', '');
        component.set('v.Notes', '');
        component.set('v.fromEmail', '');
        component.set('v.TempEmail', '')
        component.set('v.disableSubmitBtn', true);
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