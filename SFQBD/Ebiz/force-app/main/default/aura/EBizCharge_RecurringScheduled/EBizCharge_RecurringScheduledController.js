({
    doInit: function (component, event, helper) {
        try {
            var Options = [{
                    value: "all",
                    label: "All Payments"
                },
                {
                    value: "0",
                    label: "Active Payments"
                },
                {
                    value: "1",
                    label: "Suspended Payments"
                },
                {
                    value: "2",
                    label: "Expired Payments"
                },
                {
                    value: "3",
                    label: "Canceled Payments"
                }
            ];
            component.set('v.filterStatus', Options);
            var month = [];
            for (var i = 1; i <= 12; i++) {
                month.push({
                    'label': (i < 10) ? '0' + i : '' + i,
                    'value': (i < 10) ? '0' + i : '' + i
                });
            }
            component.set('v.monthList', month);
            var today = new Date();
            var todayYear = today.getFullYear();
            var options = [];
            for (var i = 0; i <= 9; i++) {
                options.push({
                    'label': (i < 10) ? '202' + i : i,
                    'value': (i < 10) ? '202' + i : i
                });
                todayYear++;
            }
            component.set('v.yearList', options);
            component.set('v.Spinner', true);
            helper.getScheduledRecurring(component, event);
            var rowActions = helper.getRowActions.bind(this, component);
            component.set("v.DataColumns", [{
                    label: 'Account / Contact Name',
                    fieldName: 'RecurringHyperUrl',
                    type: 'url',
                    sortable: true,
                    iconName: 'standard:client',
                    typeAttributes: {
                        label: {
                            fieldName: 'accName'
                        },
                        target: '_self',
                        tooltip: 'Click to visit account'
                    }
                },
                {
                    label: 'Schedule Name',
                    fieldName: 'rrScheduleName',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:event',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Starting Date',
                    fieldName: 'rrScheduleStart',
                    type: 'date',
                    typeAttributes: {
                        day: 'numeric',
                        month: 'short',
                        year: 'numeric',
                        timeZone: "UTC"
                    },
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:date_time',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Ending Date',
                    fieldName: 'rrScheduleEnd',
                    type: 'date',
                    typeAttributes: {
                        day: 'numeric',
                        month: 'short',
                        year: 'numeric',
                        timeZone: "UTC"
                    },
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:date_time',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Frequency',
                    fieldName: 'rrSchedule',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconrrSchedule'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconPayByrrSchedule'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Amount',
                    fieldName: 'rrAmount',
                    sortable: true,
                    type: 'currency',
                    typeAttributes: {
                        currencyCode: 'USD'
                    },
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconAuthAmount'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconAuthAmountLabel'
                        },
                        class: 'numbers',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Payment Method',
                    fieldName: 'rrMaskedPMValue',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        alignment: 'center',
                        class: {
                            fieldName: 'cardClass'
                        }
                    }
                },
                {
                    label: 'Status',
                    fieldName: 'rrScheduleStatusValue',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameStatus'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelStatus'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    type: 'action',
                    typeAttributes: {
                        rowActions: rowActions
                    }
                }
            ]);
            var today = $A.localizationService.formatDate(new Date(), "MM-DD-YYYY");
            component.set('v.today', today);
            var result = new Date();
            result.setDate(result.getDate() + 1);
            var Startdate = $A.localizationService.formatDate(result, "MMMM dd yyyy");
            component.set("v.mindate", Startdate);
            var result2 = new Date();
            result2.setDate(result2.getDate() + 2);
            var endDate = $A.localizationService.formatDate(result2, "MMMM dd yyyy");
            component.set("v.maxdate", endDate);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleCompEvent: function (component, event, helper) {
        try {
            var actionName = event.getParam("actionName");
            var accountId = component.get('v.selectedLookUpAccRecord.Id');
            var status = component.get('v.rrStatus');
            component.set('v.Spinner', true);
            helper.getScheduledRecurring(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    searchScheduledRR: function (component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var rrStatus = component.get('v.rrStatus');
            helper.getScheduledRecurring(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleActiveTab: function (component, event, helper) {
        try {
            var tab = event.getSource();
            tab = tab.get('v.id');
            component.set('v.ChieldActiveTab', tab);
            helper.clearAllFields(component, event);
            var activeTab = component.get('v.ChieldActiveTab');
            if (activeTab == 'UseExistingCard') {
                var a = component.get('c.validateFormXC');
                $A.enqueueAction(a);
            } else if (activeTab == 'AddNewCard') {
                var a = component.get('c.validateFormAC');
                $A.enqueueAction(a);
            }
            else if (activeTab == 'savedACH') {
                var a = component.get('c.validateFormSA');
                $A.enqueueAction(a);
            } else if (activeTab == 'addNewACH') {
                var a = component.get('c.validateFormACH');
                $A.enqueueAction(a);
            }
            else if(activeTab == 'PayByACH'){
                var a = component.get('c.validateFormSA');
                $A.enqueueAction(a);
                var b = component.get('c.validateFormACH');
                $A.enqueueAction(b);
            }
            else if(activeTab == 'PayByCard'){
                var a = component.get('c.validateFormXC');
                $A.enqueueAction(a);
                var b = component.get('c.validateFormAC');
                $A.enqueueAction(b);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleSelectAction: function (component, event, helper) {
        try {
            component.set('v.Spinner', true);
            var action = event.getParam('action');
            var row = event.getParam('row');
            component.set('v.Spinner', false);
            if (action.name == 'Edit') {
                component.set('v.isOpen', true);
                component.set('v.Spinner', false);
                var rrOptions = [{
                        value: "daily",
                        label: "daily"
                    },
                    {
                        value: "weekly",
                        label: "weekly"
                    },
                    {
                        value: "bi-weekly",
                        label: "bi-weekly"
                    },
                    {
                        value: "four-week",
                        label: "four-week"
                    },
                    {
                        value: "monthly",
                        label: "monthly"
                    },
                    {
                        value: "bi-monthly",
                        label: "bi-monthly"
                    },
                    {
                        value: "quarterly",
                        label: "quarterly"
                    },
                    {
                        value: "annually",
                        label: "annually"
                    },
                    {
                        value: "bi-annually",
                        label: "bi-annually"
                    }
                ];
                component.set('v.rrOptions', rrOptions);
                var rrPaymentIntId = row.rrPaymentIntId;
                var rrList = component.get('v.scheduledRecurring');
                var rr = {};
                var accountId = component.get('v.selectedLookUpAccRecord.Id');
                for (var i = 0; i < rrList.length; i++) {
                    var r = rrList[i];
                    if (rrPaymentIntId == r.rrPaymentIntId) {
                        rr.accountId = r.accId;
                        rr.accExtId = r.accExtId;
                        rr.rrPMType = r.rrPaymentMethodId;
                        rr.SchedPayInternalId = r.rrPaymentIntId;
                        rr.PaymentMethodId = r.rrPaymentMethodId;
                        if (r.rrPMType == 'ACH') {
                            rr.tabToActive = 'PayByACH';
                            component.set('v.addEmailsSA', r.emails);
                            component.set('v.SendReceiptToSA', r.sendReceipt);
                            component.set('v.paymentMethodIdSA', r.rrPaymentMethodId);
                            component.set('v.addEmailsXC', '');
                            component.set('v.SendReceiptToXC', false);
                            component.set('v.selectedCardXC', '');
                            helper.saveInputsSAACH(component, event);
                        } else {
                            rr.tabToActive = 'PayByCard';
                            component.set('v.addEmailsXC', r.emails);
                            component.set('v.SendReceiptToXC', r.sendReceipt);
                            component.set('v.selectedCardXC', r.rrPaymentMethodId);
                            component.set('v.addEmailsSA', '');
                            component.set('v.SendReceiptToSA', false);
                            component.set('v.paymentMethodIdSA', '');
                        }
                        component.set('v.rrPayName', r.rrScheduleName);
                        component.set('v.rrStartDate', r.rrScheduleStart);
                        component.set('v.rrEndDate', r.rrScheduleEnd);
                        component.set('v.rrAmount', r.rrAmount);
                        component.set('v.rrTax', r.rrTax);
                        component.set('v.rrFrequency', r.rrSchedule);
                        component.set('v.rrNotes', r.rrNote);
                        break;
                    }
                }
                component.set('v.rrS', rr);
                helper.getAccountDetail(component, event);
                helper.getAccountSavedCards(component, event);
                var result = new Date(component.get('v.rrStartDate'));
                result.setDate(result.getDate() + 0);
                var Startdate = $A.localizationService.formatDate(result, "MM-DD-YYYY");
                var currentdate = component.get('v.today');
                if (Startdate <= currentdate) {
                    component.set('v.disableStartDate', true);
                } else {
                    component.set('v.disableSubmitBtn', false);
                    component.set('v.disableStartDate', false);
                }
            } else {
                var ScheduleStatus = '';
                if (action.name == 'SuspendPaymentSchedule') {
                    ScheduleStatus = 1;
                }
                if (action.name == 'ResumePaymentSchedule') {
                    ScheduleStatus = 0;
                }
                if (action.name == 'Cancel') {
                    ScheduleStatus = 3;
                }
                var recIntenalId = row.rrPaymentIntId;
                helper.updScheduledRRStatus(component, recIntenalId, ScheduleStatus);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },

    checkRecurIndefinitely: function (component, event, helper) {
        component.set('v.rrEndDate', '');
        var checkbox = event.getSource().get("v.value");
        component.set('v.rrIndefinitely', checkbox);
        if (checkbox) {
            component.set('v.RecurIndefinitely', true);
            component.set("v.EndDateIsRequired", false);
            var a = component.get('c.validateRecurringForm');
            $A.enqueueAction(a);
        } else {
            component.set('v.RecurIndefinitely', false);
            component.set("v.EndDateIsRequired", true);
            component.set('v.disableSubmitBtn', true);
        }
    },
    ExcludeTaxFromTotal: function (component, event, helper) {
        try {
            var checkbox = event.getSource().get("v.value");
            if (checkbox) {
                component.set('v.ExcludeTax', checkbox);
            } else {
                component.set('v.ExcludeTax', checkbox);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    ChangeAmount: function (component, event, helper) {
        try {
            var Settings = component.get('v.Settings');
            var TaxAction = Settings.Ebiz_C__Tax_Action__c;
            var ShowTaxField = Settings.Ebiz_C__Show_Tax_Field__c;
            var amount = component.get('v.rrAmount');
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
                        Tax = component.get('v.rrTax') / 100;
                        Tax = (amount * Tax).toFixed(2);
                    } else {
                        Tax = component.get('v.rrTax');
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
                Tax = component.get('v.rrTax');
            }
            component.set('v.rrTax', Tax);
            component.set('v.rrAmountTotal', TotalAmount);
            var a = component.get('c.validateRecurringForm');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    PreviewSchedule: function (component, event, helper) {
        try {
            var a = component.get('c.validateRecurringForm');
            $A.enqueueAction(a);
            component.set("v.previewDetails", true);
        } catch (e) {
            helper.showToast('Please refresh the page and try again100!', 'Error');
        }
    },
    checkLengthCVC: function (component, event, helper) {
        try {
            var activeTab = component.get('v.ChieldActiveTab');
            if (activeTab == 'UseExistingCard') {
                var val = component.get('v.cvcXC');
                if (val.length > 4) {
                    component.set('v.cvcXC', val.substring(0, 4));
                }
            } else if (activeTab == 'AddNewCard') {
                var val = component.get('v.CVCNumber');
                if (val.length > 4) {
                    component.set('v.CVCNumber', val.substring(0, 4));
                }
            }
            var a = component.get('c.validateFormAC');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    checkSendReceiptTo: function (component, event, helper) {
        var checkbox = event.getSource().get("v.value");
        var activeTab = component.get('v.ChieldActiveTab');
        if (activeTab == 'UseExistingCard') {
            if (checkbox) {
                var emailString = component.get('v.addEmailsXC');
                if (emailString == '') {
                    try {
                        let email;
                        if(component.get('v.ConDetail.Email') == '' || component.get('v.ConDetail.Email') == null){
                        if ((component.get('v.contactEmail') == '') || (component.get('v.contactEmail') == undefined)) {
                            if (component.get('v.accDetail').Ebiz_C__EBizCharge_Email__c == '' || component.get('v.accDetail').Ebiz_C__EBizCharge_Email__c == undefined) {
                                email = '';
                            } else {
                                email = component.get('v.accDetail').Ebiz_C__EBizCharge_Email__c;
                            }
                        } else {
                            email = component.get('v.contactEmail');
                        }
                    }
                    else{
                        email = component.get('v.ConDetail.Email');
                    }
                        component.set('v.addEmailsXC', email);
                    } catch (err) {}
                }
                component.set('v.SendReceiptToXC', true);
                var emailString = component.get('v.addEmailsXC');
                if (emailString != null && emailString != '') {
                    var a = component.get('c.validateFormXC');
                    $A.enqueueAction(a);
                } else {
                    component.set('v.disableSubmitBtn', true);
                }

            } else {
                component.set('v.SendReceiptToXC', false);
                var a = component.get('c.validateFormXC');
                $A.enqueueAction(a);
            }
        } else if (activeTab == 'AddNewCard') {
            if (checkbox) {
                try {
                    let email;
                    if(component.get('v.ConDetail.Email') == '' || component.get('v.ConDetail.Email') == null){
                    if ((component.get('v.contactEmail') == '') || (component.get('v.contactEmail') == undefined)) {
                        if (component.get('v.accDetail').Ebiz_C__EBizCharge_Email__c == '' || component.get('v.accDetail').Ebiz_C__EBizCharge_Email__c == undefined) {
                            email = '';
                        } else {
                            email = component.get('v.accDetail').Ebiz_C__EBizCharge_Email__c;
                        }
                    } else {
                        email = component.get('v.contactEmail');
                    }
                }
                else{
                    email = component.get('v.ConDetail.Email');
                }
                    component.set('v.addCardEmail', email);
                } catch (err) {}
                component.set('v.SendReceiptToAddCard', true);
                var emailString = component.get('v.addCardEmail');
                if (emailString != null && emailString != '') {
                    var a = component.get('c.validateFormAC');
                    $A.enqueueAction(a);
                } else {
                    component.set('v.disableSubmitBtn', true);
                }
            } else {
                component.set('v.SendReceiptToAddCard', false);
                component.set('v.addEmails', '');
                var a = component.get('c.validateFormAC');
                $A.enqueueAction(a);
            }
        }
    },
    checkSaveCard: function (component, event, helper) {
        try {
            var checkbox = event.getSource().get("v.value");
            if (checkbox == true) {
                component.set('v.saveCard', true);
            } else {
                component.set('v.saveCard', false);
            }
            var a = component.get('c.validateFormAC');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    checkLengthCard: function (component, event, helper) {
        try {
            var val = component.get('v.CardNumber');
            if (val.length > 16) {
                component.set('v.CardNumber', val.substring(0, 16));
            }
            var a = component.get('c.validateFormAC');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    checkLengthZip: function (component, event, helper) {
        try {
            var val = component.get('v.ZipCode');
            if (val.length > 10) {
                component.set('v.ZipCode', val.substring(0, 10));
            }
            var a = component.get('c.validateFormAC');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateRecurringForm: function (component, event, helper) {
        try {
            var allValid = component.find('req-fieldsrr').reduce(function (validSoFar, inputCmp) {
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
            if (allValid) {
                var timeDiffrence = 1;
                var RecurIndefinitely = component.get('v.rrIndefinitely');
                if (!RecurIndefinitely) {
                    var today = new Date();
                    var rrStartDate = new Date(component.get('v.rrStartDate'));
                    var rrEndDate = new Date(component.get('v.rrEndDate'));
                    var Ddate = component.get('v.disableStartDate');
                    var timeDiffrence = rrEndDate - rrStartDate;
                    if (timeDiffrence <= 0) {
                        component.set("v.disableSubmitBtn", true);
                    }
                    if (Ddate == false && rrStartDate <= today) {
                        component.set('v.disableSubmitBtn', true);
                    } else {
                        var setRR = {};
                        var second = 1000,
                            minute = second * 60,
                            hour = minute * 60,
                            day = hour * 24,
                            week = day * 7,
                            month = day * 31,
                            year = month * 12;
                        var NoOfPay = 1;
                        var TPA = 0.0;
                        var Freq = component.get('v.rrFrequency');
                        var scheduledDatesStr = '';
                        var PayTotal = component.get('v.rrAmount');
                        var action = component.get('c.getRecurringSchedulePreview');
                        action.setParams({
                            "startDate": component.get('v.rrStartDate'),
                            "endDate": component.get('v.rrEndDate'),
                            "paymentFrequency": component.get('v.rrFrequency')
                        });
                        action.setCallback(this, function (response) {
                            var state = response.getState();
                            if (state == "SUCCESS") {
                                if (response.getReturnValue() != 'Error') {
                                    var scheduledDatesReturnList = JSON.parse(response.getReturnValue());
                                    var totalScheduledDatesReturned = scheduledDatesReturnList.length;
                                    var rrS = component.get('v.rrS');
                                    NoOfPay = totalScheduledDatesReturned;
                                    TPA = totalScheduledDatesReturned * PayTotal;
                                    scheduledDatesStr = response.getReturnValue();
                                    setRR.rrNoOfPays = NoOfPay;
                                    setRR.rrPaysTotal = TPA.toFixed(2);
                                    setRR.accountId = rrS.accountId;
                                    setRR.accExtrId = rrS.accExtId;
                                    setRR.Amount = component.get('v.rrAmount');
                                    setRR.Tax = component.get('v.rrTax');
                                    setRR.rrPayName = component.get('v.rrPayName');
                                    setRR.rrFrequency = component.get('v.rrFrequency');
                                    setRR.rrStartDate = component.get('v.rrStartDate');
                                    setRR.rrEndDate = component.get('v.rrEndDate');
                                    setRR.rrIndefinit = component.get('v.rrIndefinitely');
                                    setRR.rrAmountTotal = component.get('v.rrAmountTotal');
                                    setRR.rrNotes = component.get('v.rrNotes');
                                    setRR.rrScheduledDates = scheduledDatesReturnList;
                                    component.set('v.NewrrS', setRR);
                                } else {
                                    helper.showToast('Gateway GettRecurringSchedulePreview error!', 'Error');
                                    component.set('v.disableSubmitBtn', true);
                                    component.set('v.previewDetails', false);
                                }
                            } else {
                                helper.showToast('Gateway GettRecurringSchedulePreview error!', 'Error');
                                component.set('v.disableSubmitBtn', true);
                                component.set('v.previewDetails', false);
                            }
                        });
                        $A.enqueueAction(action);
                        var payByCardInfo = component.get('v.payByCardInfo');
                        var payByACHInfo = component.get('v.payByACHInfo');
                        if (payByCardInfo == null && payByACHInfo == null) {
                            component.set('v.disableSubmitBtn', true);
                        } else {
                            component.set('v.disableSubmitBtn', false);
                        }
                    }
                } else {
                    var setRR = {};
                    var NoOfPay = 1;
                    var TPA = 0.0;
                    var second = 1000,
                        minute = second * 60,
                        hour = minute * 60,
                        day = hour * 24,
                        week = day * 7;
                    var NoOfPay = 1;
                    var TPA = 0.0;
                    var Freq = component.get('v.rrFrequency');
                    var isValid = false
                    var rrStartDate = new Date(component.get('v.rrStartDate'));
                    var rrS = component.get('v.rrS');
                    setRR.accountId = rrS.accountId;
                    setRR.rrPaysTotal = component.get('v.rrAmountTotal');
                    setRR.Amount = component.get('v.rrAmount');
                    setRR.Tax = component.get('v.rrTax');
                    setRR.rrPayName = component.get('v.rrPayName');
                    setRR.rrFrequency = component.get('v.rrFrequency');
                    setRR.rrStartDate = component.get('v.rrStartDate');
                    setRR.rrEndDate = component.get('v.rrEndDate');
                    setRR.rrIndefinit = component.get('v.rrIndefinitely');
                    setRR.rrAmountTotal = component.get('v.rrAmountTotal');
                    setRR.rrNotes = component.get('v.rrNotes');
                    setRR.rrNotes = component.get('v.rrNotes');
                    var sDate = new Date(component.get('v.rrStartDate'));
                    var endDate = new Date(component.get('v.rrStartDate'));
                    var today = new Date(component.get('v.mindate'));
                    var rrStartDate = new Date(component.get('v.rrStartDate'));
                    var Ddate = component.get('v.disableStartDate');
                    var Sstart = new Date(component.get('v.rrStartDate'));
                    var Cdate = new Date(component.get('v.mindate'));
                    if (Ddate == false && Sstart <= Cdate) {
                        component.set('v.disableSubmitBtn', true);
                    } else {
                        component.set('v.disableSubmitBtn', false);
                    }
                    if (Freq == 'daily') {
                        var days = 5;
                        endDate.setDate(endDate.getDate() + days);
                    }
                    if (Freq == 'weekly') {
                        var week = 35;
                        endDate.setDate(endDate.getDate() + week);
                    }
                    if (Freq == 'bi-weekly') {
                        var biWeek = 60;
                        endDate.setDate(endDate.getDate() + biWeek);
                    }
                    if (Freq == 'four-week') {
                        var fWeek = 140;
                        endDate.setDate(endDate.getDate() + fWeek);
                    }
                    if (Freq == 'monthly') {
                        var eMonth = 150;
                        endDate.setDate(endDate.getDate() + eMonth);
                    }
                    if (Freq == 'bi-monthly') {
                        var BMonth = 80;
                        endDate.setDate(endDate.getDate() + BMonth);
                    }
                    if (Freq == 'quarterly') {
                        var Qua = 450;
                        endDate.setDate(endDate.getDate() + Qua);
                    }
                    if (Freq == 'annually') {
                        var anual = 1800;
                        endDate.setDate(endDate.getDate() + anual);
                    }
                    if (Freq == 'bi-annually') {
                        var Banual = 900;
                        endDate.setDate(endDate.getDate() + Banual);
                    }
                    var scheduledDatesStr = '';
                    var action = component.get('c.getRecurringSchedulePreview');
                    action.setParams({
                        "startDate": component.get('v.rrStartDate'),
                        "endDate": endDate,
                        "paymentFrequency": component.get('v.rrFrequency')
                    });
                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        if (state == "SUCCESS") {
                            if (response.getReturnValue() != 'Error') {
                                var scheduledDatesReturnList = JSON.parse(response.getReturnValue());
                                setRR.rrScheduledDates = scheduledDatesReturnList;
                            }
                        }
                    });
                    $A.enqueueAction(action);
                    component.set('v.NewrrS', setRR);
                }
            } else {
                component.set('v.disableSubmitBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    EditScheduledRR: function (component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set('v.isOpen', false);
            var activeTab = component.get('v.ChieldActiveTab');
            if (activeTab == 'UseExistingCard') {
                helper.submitRRForm(component, event, 'UseExistingCard');
            } else if (activeTab == 'AddNewCard') {
                helper.submitRRForm(component, event, 'AddNewCard');
            }
            if (activeTab == 'savedACH') {
                helper.submitExistACHForm(component, event, helper);
            } else if (activeTab == 'addNewACH') {
                helper.submitAddNewACHForm(component, event, helper);
            }
            this.validateRecurringForm(component, event, helper);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleSort: function (component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortData(component, sortBy, sortDirection);
    },
    PreviewScheduleDates: function (component, event, helper) {
        try {
            component.set("v.previewDetails", false);
            component.set("v.isOpenScheduleDatesModal", true);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    closeModelPreview: function (component, event, helper) {
        try {
            component.set("v.previewDetails", false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    closeModel: function (component, event, helper) {
        try {
            component.set("v.isOpen", false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    closeScheduleDatesModel: function (component, event, helper) {
        try {
            component.set("v.isOpenScheduleDatesModal", false);
            component.set("v.previewDetails", true);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    returnToPreviewPaymentSchedule: function (component, event, helper) {
        try {
            component.set("v.isOpenScheduleDatesModal", false);
            component.set("v.previewDetails", true);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    validateFormSA: function (component, event, helper) {
        var commentForm = component.find('req-fieldSA'),
            valid;
        var allValid = commentForm.get("v.validity").valid;
        var emailString = component.get('v.addEmailsSA');
        var sendReceipt = component.get('v.SendReceiptToSA');
        if (allValid) {
            if (sendReceipt && (emailString != null && emailString != '')) {
                var pps = component.get('v.rrS');
                if (pps != null) {
                    component.set('v.disableSubmitBtn', false);
                    helper.saveInputsSA(component, event);
                } else {
                    component.set('v.disableSubmitBtn', true);
                }
            }
            if (!sendReceipt) {
                var pps = component.get('v.rrS');
                if (pps != null) {
                    component.set('v.disableSubmitBtn', false);
                    helper.saveInputsSA(component, event);
                } else {
                    component.set('v.disableSubmitBtn', true);
                }
            }
        } else {
            component.set('v.disableSubmitBtn', true);
        }
    },
    checkSendReceiptToACH: function (component, event, helper) {
        var checkbox = event.getSource().get("v.value");
        var activeTab = component.get('v.ChieldActiveTab');
        if (activeTab == 'savedACH') {
            if (checkbox) {
                var emailString = component.get('v.addEmailsSA');
                if (emailString == '') {
                    try {
                        let email;
                        if(component.get('v.ConDetail.Email') == '' || component.get('v.ConDetail.Email') == null){
                            if ((component.get('v.contactEmail') == '') || (component.get('v.contactEmail') == undefined)) {
                                if (component.get('v.accDetail').Ebiz_C__EBizCharge_Email__c == '' || component.get('v.accDetail').Ebiz_C__EBizCharge_Email__c == undefined) {
                                    email = '';
                                } else {
                                    email = component.get('v.accDetail').Ebiz_C__EBizCharge_Email__c;
                                }
                            } else {
                                email = component.get('v.contactEmail');
                            }
                        }
                        else{
                            email = component.get('v.ConDetail.Email');
                        }
                        component.set('v.addEmailsSA', email);
                    } catch (err) {}
                }
                component.set('v.SendReceiptToSA', true);
                var emailString = component.get('v.addEmailsSA');
                if (emailString != null && emailString != '') {
                    var a = component.get('c.validateFormSA');
                    $A.enqueueAction(a);
                } else {
                    component.set('v.disableSubmitBtn', true);
                }
            } else {
                component.set('v.SendReceiptToSA', false);
                var a = component.get('c.validateFormSA');
                $A.enqueueAction(a);
            }
        } else if (activeTab == 'addNewACH') {
            if (checkbox) {
                try {
                    let email;
                    if(component.get('v.ConDetail.Email') == '' || component.get('v.ConDetail.Email') == null){
                    if ((component.get('v.contactEmail') == '') || (component.get('v.contactEmail') == undefined)) {
                        if (component.get('v.accDetail').Ebiz_C__EBizCharge_Email__c == '' || component.get('v.accDetail').Ebiz_C__EBizCharge_Email__c == undefined) {
                            email = '';
                        } else {
                            email = component.get('v.accDetail').Ebiz_C__EBizCharge_Email__c;
                        }
                    } else {
                        email = component.get('v.contactEmail');
                    }
                }else{
                    email = component.get('v.ConDetail.Email');
                }
                    component.set('v.addEmails', email);
                } catch (err) {}
                component.set('v.SendReceiptTo', true);
                var emailString = component.get('v.addEmails');
                if (emailString != null && emailString != '') {
                    var a = component.get('c.validateFormACH');
                    $A.enqueueAction(a);
                } else {
                    component.set('v.disableSubmitBtn', true);
                }
            } else {
                component.set('v.SendReceiptTo', false);
                component.set('v.addEmails', '');
                var a = component.get('c.validateFormACH');
                $A.enqueueAction(a);
            }
        }
    },
    validateFormACH: function (component, event, helper) {
        var allValid = component.find('req-fields').reduce(function (validSoFar, inputCmp) {
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        var emailString = component.get('v.addEmails');
        var sendReceipt = component.get('v.SendReceiptTo');
        if (allValid) {
            if (sendReceipt && (emailString != null && emailString != '')) {
                component.set('v.disableSubmitBtn', false);
                helper.saveInputsAA(component, event);
            } else if (!sendReceipt) {
                component.set('v.disableSubmitBtn', false);
                helper.saveInputsAA(component, event);
            }
        } else {
            component.set('v.disableSubmitBtn', true);
        }
    },
    validateFormAC: function (component, event, helper) {
        try {
            var allValid = component.find('req-fieldsAC').reduce(function (validSoFar, inputCmp) {
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
            var emailString = component.get('v.addCardEmail');
            if(emailString != null && emailString != ''){
                if (emailString.includes(";")) {
                    helper.showToastMsg('Please use comma instead of semicolon!', 'Error');
                    component.set('v.addCardEmail', emailString.replace(";", ""));
                }
            }  
            var sendReceipt = component.get('v.SendReceiptToAddCard');
            if (allValid) {
                if (sendReceipt && (emailString != null && emailString != '')) {
                    var pps = component.get('v.rrS');
                    if (pps != null) {
                        component.set('v.disableSubmitBtn', false);
                        helper.saveInputsAC(component, event);
                    } else {
                        component.set('v.disableSubmitBtn', true);
                    }
                }
                if (!sendReceipt) {
                    var pps = component.get('v.rrS');
                    if (pps != null) {
                        component.set('v.disableSubmitBtn', false);
                        helper.saveInputsAC(component, event);
                    } else {
                        component.set('v.disableSubmitBtn', true);
                    }
                }
            } else {
                component.set('v.disableSubmitBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    checkRoutLength: function (component, event, helper) {
        var val = component.get('v.accRoutNumber');
        if (val.length > 9) {
            component.set('v.accRoutNumber', val.substring(0, 9));
        }
        var activeTab = component.get('v.ChieldActiveTab');
        if (activeTab == 'savedACH') {
            var a = component.get('c.validateFormACH');
            $A.enqueueAction(a);
        } else if (activeTab == 'addNewACH') {
            var a = component.get('c.validateFormACH');
            $A.enqueueAction(a);
        }
    },
    contactEmailChange: function (cmp, evt) {
        var activeTab = cmp.get('v.ChieldActiveTab');
        if (activeTab == 'addNewACH') {
            var checkCmp = cmp.find("sendToCheck");
            if (cmp.get('v.contactEmail') == undefined) {
                checkCmp.set('v.value', false);
                cmp.set('v.SendReceiptTo', false);
                cmp.set('v.addEmails', '');
                var a = cmp.get('c.validateFormACH');
                $A.enqueueAction(a);
            } else {
                if (checkCmp.get("v.value") == true) {
                    cmp.set('v.addEmails', cmp.get('v.contactEmail'));
                }
            }
        } else if (activeTab == 'savedACH') {
            var checkCmp = cmp.find("sendCheckSA");
            if (cmp.get('v.contactEmail') == undefined) {
                checkCmp.set('v.value', false);
                cmp.set('v.SendReceiptToSA', false);
                cmp.set('v.addEmailsSA', '');
                var a = cmp.get('c.validateFormSA');
                $A.enqueueAction(a);
            } else {
                if (checkCmp.get("v.value") == true) {
                    cmp.set('v.addEmailsSA', cmp.get('v.contactEmail'));
                }
            }
        }
    },
    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        if (selectedRows.length > 0) {
            cmp.set('v.selectedOrders', selectedRows);
        }
        cmp.set('v.selectedRowsCount', selectedRows.length);
    },
    clearFields: function (component, event, helper) {
        try {
            helper.clearAllFields(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateFormXC: function (component, event, helper) {
        try {
            var allValid = component.find('req-fieldsXC').reduce(function (validSoFar, inputCmp) {
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
            var emailString = component.get('v.addEmailsXC');
            if(emailString != null && emailString != ''){
                if (emailString.includes(";")) {
                    helper.showToastMsg('Please use comma instead of semicolon!', 'Error');
                    component.set('v.addEmailsXC', emailString.replace(";", ""));
                }
            }
            var sendReceipt = component.get('v.SendReceiptToXC');
            if (allValid) {
                if (sendReceipt && (emailString != null && emailString != '')) {
                    var pps = component.get('v.rrS');
                    if (pps != null) {
                        component.set('v.disableSubmitBtn', false);
                        helper.saveInputsXC(component, event);
                    } else {
                        component.set('v.disableSubmitBtn', true);
                    }
                } else if (!sendReceipt) {
                    var pps = component.get('v.rrS');
                    if (pps != null) {
                        component.set('v.disableSubmitBtn', false);
                        helper.saveInputsXC(component, event);
                    } else {
                        component.set('v.disableSubmitBtn', true);
                    }
                }
            } else {
                component.set('v.disableSubmitBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateCardEmail: function (component, event, helper) {
        try {

            var emailString = component.get('v.addEmailsXC');
            if (emailString != null && emailString != '') {
                var a = component.get('c.validateFormXC');
                $A.enqueueAction(a);
            } else {
                component.set('v.disableSubmitBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateAddCardEmail: function (component, event, helper) {
        try {

            var emailString = component.get('v.addCardEmail');
            if (emailString != null && emailString != '') {
                var a = component.get('c.validateFormAC');
                $A.enqueueAction(a);
            } else {
                component.set('v.disableSubmitBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateBankEmail: function (component, event, helper) {
        try {
            var emailString = component.get('v.addEmailsSA');
            if (emailString != null && emailString != '') {
                var a = component.get('c.validateFormSA');
                $A.enqueueAction(a);
            } else {
                component.set('v.disableSubmitBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateAddBankEmail: function (component, event, helper) {
        try {
            var emailString = component.get('v.addEmails');
            if (emailString != null && emailString != '') {
                var a = component.get('c.validateFormACH');
                $A.enqueueAction(a);
            } else {
                component.set('v.disableSubmitBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
})