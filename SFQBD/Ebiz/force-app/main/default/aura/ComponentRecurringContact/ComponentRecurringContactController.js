({
    doInit: function(component, event, helper) {
        component.set('v.Spinner', true);
        var cs = component.get('v.Settings');
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
        var rrOptions = [];
        if (cs.Ebiz_C__AutoPay_daily__c) {
            var refnumobject = {
                value: "daily",
                label: "daily"
            }
            rrOptions.push(refnumobject);
        }
        if (cs.Ebiz_C__AutoPay_weekly__c) {
            var refnumobject = {
                value: "weekly",
                label: "weekly"
            }
            rrOptions.push(refnumobject);
        }
        if (cs.Ebiz_C__AutoPay_bi_weekly__c) {
            var refnumobject = {
                value: "bi-weekly",
                label: "bi-weekly"
            }
            rrOptions.push(refnumobject);
        }
        if (cs.Ebiz_C__AutoPay_four_week__c) {
            var refnumobject = {
                value: "four-week",
                label: "four-week"
            }
            rrOptions.push(refnumobject);
        }
        if (cs.Ebiz_C__AutoPay_monthly__c) {
            var refnumobject = {
                value: "monthly",
                label: "monthly"
            }
            rrOptions.push(refnumobject);
        }
        if (cs.Ebiz_C__AutoPay_bi_monthly__c) {
            var refnumobject = {
                value: "bi-monthly",
                label: "bi-monthly"
            }
            rrOptions.push(refnumobject);
        }
        if (cs.Ebiz_C__AutoPay_quarterly__c) {
            var refnumobject = {
                value: "quarterly",
                label: "quarterly"
            }
            rrOptions.push(refnumobject);
        }
        if (cs.Ebiz_C__AutoPay_annually__c) {
            var refnumobject = {
                value: "annually",
                label: "annually"
            }
            rrOptions.push(refnumobject);
        }
        if (cs.Ebiz_C__AutoPay_bi_annually__c) {
            var refnumobject = {
                value: "bi-annually",
                label: "bi-annually"
            }
            rrOptions.push(refnumobject);
        }
        component.set('v.rrOptions', rrOptions);
        component.set('v.payByCardInfo', null);
        component.set('v.payByACHInfo', null);
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
    },
    handleParentActiveTab: function(component, event, helper) {
        var tab = event.getSource();
        tab = tab.get('v.id');
        component.set('v.ParentActiveTab', tab);
    },
    checkRecurIndefinitely: function(component, event, helper) {
        component.set('v.rrEndDate', '');
        var checkbox = event.getSource().get("v.value");
        component.set('v.RecurIndefinitely', checkbox);
        component.set('v.ButtonVisibility', false);
        component.set('v.disableSubmitBtn', false);
        var a = component.get('c.validateRecurringForm');
        $A.enqueueAction(a);
    },
    onChangeAmount: function(component, evt, helper) {
        var amount = component.get('v.Amount');
        if (amount === 0 || amount == '' || parseFloat(amount) <= 1) {
            helper.showToast('Valid amount required', 'Error');
        }
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
        component.set('v.PaymentTotal', TotalAmount);
        var a = component.get('c.validateRecurringForm');
        $A.enqueueAction(a);
    },
    ScheduleRecurring: function(component, event, helper) {
        var amount = component.get('v.Amount');
        if (amount === 0 || amount == '' || parseFloat(amount) <= 1) {
            helper.showToast('Valid amount required', 'Error');
            return;
        }
        var allValid = component.find('req-fieldsrr').reduce(function(validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if (allValid) {
            var inputStartDate = component.get('v.rrStartDate');
            var rrStartDate = new Date(inputStartDate.replace(/-/g, "/"));
            var inputEndDate = component.get('v.rrEndDate');
            var rrEndDate = new Date(inputEndDate.replace(/-/g, "/"));
            var timeDiffrence = rrEndDate - rrStartDate;
            if (timeDiffrence <= 0) {} else {
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
                        helper.submitExistACHForm(component, event, helper);
                    } else if (pby.payBy == 'addNewACH') {
                        helper.submitAddNewACHForm(component, event, helper);
                    }
                }
            }
        } else {
            helper.showToast('Please fill the required fields and try again!', 'Error');
        }
    },
    validateRecurringForm: function(component, event, helper) {
        try {
            var allValid = component.find('req-fieldsrr').reduce(function(validSoFar, inputCmp) {
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
            if (allValid) {
                component.set('v.ButtonVisibility', true);
                if (component.get('v.PaymentTotal') > 0) {
                    var timeDiffrence = 1;
                    var RecurIndefinitely = component.get('v.RecurIndefinitely');
                    if (!RecurIndefinitely && component.get('v.rrFrequency') != 'once') {
                        var today = new Date();
                        today.setHours(0,0,0,0);
                        var inputStartDate = component.get('v.rrStartDate');
                        var rrStartDate = new Date(inputStartDate.replace(/-/g, "/"));
                        var inputEndDate = component.get('v.rrEndDate');
                        var rrEndDate = new Date(inputEndDate.replace(/-/g, "/"));
                        var timeDiffrence = rrEndDate - rrStartDate;
                        if (timeDiffrence <= 0) {
                            component.set('v.disableSubmitBtn', true);
                            component.set('v.showpaymentform', false);
                        } else if (rrStartDate <= today) {
                            component.set('v.disableSubmitBtn', true);
                            component.set('v.showpaymentform', false);
                            component.set('v.ButtonVisibility', false);
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
                            var PayTotal = component.get('v.PaymentTotal');
                            var action = component.get('c.getRecurringSchedulePreview');
                            action.setParams({
                                "startDate": component.get('v.rrStartDate'),
                                "endDate": component.get('v.rrEndDate'),
                                "paymentFrequency": component.get('v.rrFrequency')
                            });
                            action.setCallback(this, function(response) {
                                var state = response.getState();
                                if (state == "SUCCESS") {
                                    if (response.getReturnValue() != 'Error') {
                                        var scheduledDatesReturnList = JSON.parse(response.getReturnValue());
                                        var totalScheduledDatesReturned = scheduledDatesReturnList.length;
                                        NoOfPay = totalScheduledDatesReturned;
                                        TPA = totalScheduledDatesReturned * PayTotal;
                                        scheduledDatesStr = response.getReturnValue();
                                        setRR.rrNoOfPays = NoOfPay;
                                        setRR.rrPaysTotal = TPA.toFixed(2);
                                        setRR.Amount = component.get('v.Amount');
                                        setRR.Tax = component.get('v.Tax');
                                        setRR.rrPayName = component.get('v.rrPayName');
                                        setRR.rrFrequency = component.get('v.rrFrequency');
                                        setRR.rrStartDate = component.get('v.rrStartDate');
                                        setRR.rrEndDate = component.get('v.rrEndDate');
                                        setRR.rrIndefinit = component.get('v.RecurIndefinitely');
                                        setRR.paymentTotal = component.get('v.PaymentTotal');
                                        setRR.rrScheduledDates = scheduledDatesReturnList;
                                        component.set('v.rrS', setRR);
                                        component.set('v.showRRSummary', true);
                                        component.set('v.showpaymentform', true);
                                    } else {
                                        helper.showToast('Gateway GettRecurringSchedulePreview error!', 'Error');
                                        component.set('v.disableSubmitBtn', true);
                                        component.set('v.showpaymentform', false);
                                        component.set('v.showRRSummary', false);
                                    }
                                } else {
                                    helper.showToast('Gateway GettRecurringSchedulePreview error!', 'Error');
                                    component.set('v.disableSubmitBtn', true);
                                    component.set('v.showpaymentform', false);
                                    component.set('v.showRRSummary', false);
                                }
                            });
                            $A.enqueueAction(action);
                            var payByCardInfo = component.get('v.payByCardInfo');
                            var payByACHInfo = component.get('v.payByACHInfo');
                            var ParentActiveTab = component.get('v.ParentActiveTab');
                            if (ParentActiveTab == 'PayByCard') {
                                if (payByCardInfo == null) {
                                    component.set('v.disableSubmitBtn', true);
                                } else {
                                    component.set('v.disableSubmitBtn', false);
                                }
                            } else {
                                if (payByACHInfo == null) {
                                    component.set('v.disableSubmitBtn', true);
                                } else {
                                    component.set('v.disableSubmitBtn', false);
                                }
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
                        if (Freq == 'once') {
                            if (!RecurIndefinitely) {
                                var inputStartDate = component.get('v.rrStartDate');
                                var rrStartDate = new Date(inputStartDate.replace(/-/g, "/"));
                                var inputEndDate = component.get('v.rrEndDate');
                                var rrEndDate = new Date(inputEndDate.replace(/-/g, "/"));
                                var timeDiffrence = rrEndDate - rrStartDate;
                                if (timeDiffrence <= 0) {
                                    isValid = false;
                                } else {
                                    setRR.rrNoOfPays = 1;
                                    isValid = true;
                                }
                            } else {
                                setRR.rrNoOfPays = 1;
                                isValid = true;
                            }
                        } else {
                            isValid = true;
                            setRR.rrNoOfPays = 'Indefinite';
                        }
                        setRR.rrPaysTotal = component.get('v.PaymentTotal')
                        setRR.Amount = component.get('v.Amount');
                        setRR.Tax = component.get('v.Tax');
                        setRR.rrPayName = component.get('v.rrPayName');
                        setRR.rrFrequency = component.get('v.rrFrequency');
                        setRR.rrStartDate = component.get('v.rrStartDate');
                        setRR.rrEndDate = component.get('v.rrEndDate');
                        setRR.rrIndefinit = component.get('v.RecurIndefinitely');
                        setRR.paymentTotal = component.get('v.PaymentTotal');
                        var today = new Date();
                        today.setHours(0,0,0,0);
                        var inputStartDate = component.get('v.rrStartDate');
                        var rrStartDate = new Date(inputStartDate.replace(/-/g, "/"));
                        var endDate = new Date(inputStartDate.replace(/-/g, "/"));
                        if (RecurIndefinitely) {
                            if (rrStartDate <= today) {
                                component.set('v.disableSubmitBtn', false);
                                component.set('v.showpaymentform', false);
                                component.set('v.ButtonVisibility', false);
                                component.set('v.showRRSummary', false);
                            } else {
                                component.set('v.showpaymentform', true);
                                component.set('v.showRRSummary', true);
                                component.set('v.disableSubmitBtn', false);
                            }
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
                        action.setCallback(this, function(response) {
                            var state = response.getState();
                            if (state == "SUCCESS") {
                                if (response.getReturnValue() != 'Error') {
                                    var scheduledDatesReturnList = JSON.parse(response.getReturnValue());
                                    setRR.rrScheduledDates = scheduledDatesReturnList;
                                }
                            }
                        });
                        $A.enqueueAction(action);
                        component.set('v.rrS', setRR);
                        if (isValid) {} else {}
                        var payByCardInfo = component.get('v.payByCardInfo');
                        var payByACHInfo = component.get('v.payByACHInfo');
                        var ParentActiveTab = component.get('v.ParentActiveTab');
                        if (ParentActiveTab == 'PayByCard') {
                            if (payByCardInfo == null) {
                                component.set('v.disableSubmitBtn', true);
                            } else {
                                component.set('v.disableSubmitBtn', false);
                            }
                        } else {
                            if (payByACHInfo == null) {
                                component.set('v.disableSubmitBtn', true);
                            } else {
                                component.set('v.disableSubmitBtn', false);
                            }
                        }
                    }
                } else {
                    component.set('v.disableSubmitBtn', true);
                    component.set('v.showpaymentform', false);
                    component.set('v.showRRSummary', false);
                    helper.showToast('Please enter valid amount', 'Error');
                }
            } else {
                component.set('v.disableSubmitBtn', true);
                component.set('v.showpaymentform', false);
                component.set('v.showRRSummary', false);
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    PreviewScheduleDates: function(component, event, helper) {
        try {
            component.set("v.isOpenScheduleDatesModal", true);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    closeScheduleDatesModel: function(component, event, helper) {
        try {
            component.set("v.isOpenScheduleDatesModal", false);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
        window.location.reload();
    },
})