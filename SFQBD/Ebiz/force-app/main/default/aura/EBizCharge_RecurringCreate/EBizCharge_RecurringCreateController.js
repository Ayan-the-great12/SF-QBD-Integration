({
    doInit: function(component, event, helper) {
        try {
            helper.getSettings(component);
            var rrDayOptions = [];
            for (var i = 1; i <= 28; i++) {
                rrDayOptions.push({
                    'label': 'Day ' + i,
                    'value': i
                });
            }
            component.set('v.rrDayOptions', rrDayOptions);
            component.set('v.payByCardInfo', null);
            component.set('v.payByACHInfo', null);
            component.set('v.rrS', null);
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
            helper.showToast('Please refresh the page and try again123!', 'Error');
        }
    },
    handleCompEvent: function(component, event, helper) {
        try {
            var actionName = event.getParam("actionName");
            if (actionName == 'showGrid') {
                component.set('v.Spinner', true);
                helper.getAccountDetail(component, event);
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    handleRadioClick: function(component, event, helper) {
        try {
            component.set('v.rrPayType', event.getSource().get('v.value'));
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    handleParentActiveTab: function(component, event, helper) {
        try {
            var tab = event.getSource();
            tab = tab.get('v.id');
            component.set('v.ParentActiveTab', tab);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    checkRecurIndefinitely: function(component, event, helper) {
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
            component.set('v.showpaymentform', false);
        }
    },
    ChangeAmount: function(component, event, helper) {
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
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    validateRRForm: function(component, event, helper) {
        try {
            var rrDay = component.get('v.rrDay');
            var rrTerms = document.getElementById("terms").checked;
            var setRR = {};
            var monthDigit = today.getMonth() + 1;
            var dayDigit = today.getDate();
            var rrStartDate = '';
            var dt = new Date();
            if (dayDigit <= rrDay) {
                rrStartDate = $A.localizationService.formatDate(new Date(dt.getFullYear(), dt.getMonth(), rrDay), "MM/DD/YYYY");
            } else {
                rrStartDate = $A.localizationService.formatDate(new Date(dt.getFullYear(), dt.getMonth() + 1, rrDay), "MM/DD/YYYY");
            }
            if (monthDigit <= 9) {
                monthDigit = '0' + monthDigit;
            }
            if (rrDay != '' && rrDay != null && rrTerms == true) {
                setRR.rrFrequency = 'monthly';
                setRR.rrStartDate = '';
                setRR.rrEndDate = '';
                setRR.rrIndefinit = true;
                setRR.rrAmountTotal = 0;
                component.set('v.rrS', setRR);
                var payByCardInfo = component.get('v.payByCardInfo');
                var payByACHInfo = component.get('v.payByACHInfo');
                if (payByCardInfo == null && payByACHInfo == null) {
                    component.set('v.disableSubmitBtn', true);
                } else {
                    component.set('v.disableSubmitBtn', true);
                }
            } else {
                component.set('v.disableSubmitBtn', true);
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    termsChanged: function(cmp, event, helper) {
        try {
            cmp.set("v.chkTerms", document.getElementById("terms").checked);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    validateRecurringForm: function(component, event, helper) {
        try {
            if ($A.util.isEmpty(component.get('v.selectedLookUpAccRecord'))) {
                helper.showToast('Please select the account!', 'Error');
                component.set('v.disableSubmitBtn', true);
            }
            var allValid = component.find('req-fieldsrr').reduce(function(validSoFar, inputCmp) {
                return validSoFar && !inputCmp.get('v.validity').valueMissing;
            }, true);
            if (allValid) {
                if (component.get('v.rrAmountTotal') > 0) {
                    component.set('v.showpaymentform', true);
                    var timeDiffrence = 1;
                    var RecurIndefinitely = component.get('v.rrIndefinitely');
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
                        } 
                        else if (rrStartDate <= today) {
                            component.set('v.disableSubmitBtn', true);
                            component.set('v.showpaymentform', false);
                        } 
                        else {
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
                            var PayTotal = component.get('v.rrAmountTotal');
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
                                        component.set('v.rrS', setRR);
                                    } else {
                                        helper.showToast('Gateway GettRecurringSchedulePreview error!', 'Error');
                                        component.set('v.disableSubmitBtn', true);
                                        component.set('v.showpaymentform', false);
                                    }
                                } else {
                                    helper.showToast('Gateway GettRecurringSchedulePreview error!', 'Error');
                                    component.set('v.disableSubmitBtn', true);
                                    component.set('v.showpaymentform', false);
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
                        if (Freq == 'once') {
                            if (!RecurIndefinitely) {
                                var inputStartDate = component.get('v.rrStartDate');
                                var rrStartDate = new Date(inputStartDate.replace(/-/g, "/"));
                                var inputEndDate = component.get('v.rrEndDate');
                                var rrEndDate = new Date(inputEndDate.replace(/-/g, "/"));
                                var timeDiffrence = rrEndDate - rrStartDate;
                                if (timeDiffrence <= 0) {
                                    isValid = false;
                                    helper.showToast('End date must be greater than start date!', 'Error');
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
                        var inputStartDate = component.get('v.rrStartDate');
                        var rrStartDate = new Date(inputStartDate.replace(/-/g, "/"));
                        var endDate = new Date(inputStartDate.replace(/-/g, "/"));
                        var today = new Date();
                        today.setHours(0,0,0,0);
                        if (RecurIndefinitely) {
                            if (rrStartDate <= today) {
                                component.set('v.disableSubmitBtn', true);
                                component.set('v.showpaymentform', false);
                            } else {
                                component.set('v.disableSubmitBtn', false);
                                component.set('v.showpaymentform', true);
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
                        var payByCardInfo = component.get('v.payByCardInfo');
                        var payByACHInfo = component.get('v.payByACHInfo');
                        if (payByCardInfo == null && payByACHInfo == null) {
                            component.set('v.disableSubmitBtn', true);
                        } else {
                            component.set('v.disableSubmitBtn', false);
                        }
                    }
                } else {
                    component.set('v.disableSubmitBtn', true);
                    component.set('v.showpaymentform', false);
                    helper.showToast('Please enter valid amount', 'Error');
                }
            } else {
                component.set('v.disableSubmitBtn', true);
                component.set('v.showpaymentform', false);
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    PreviewSchedule: function(component, event, helper) {
        try {
            component.set("v.isOpen", true);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    PreviewScheduleDates: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
            component.set("v.isOpenScheduleDatesModal", true);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    SchedulePayment: function(component, event, helper) {
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
    },
    UpdateRetryHandler: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.voidTransactionWithoutReload(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    AcceptTransactionHandler: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set('v.isAVSCheck', false);
            component.set('v.avsCheckModal', false);
            helper.voidAVSTransaction(component, event);
            component.set('v.Spinner', true);
            helper.submitAddNewCardForm(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    CancelTransactionHandler: function(component, event, helper) {
        try {
            component.set('v.avsCheckAction', 'Cancel');
            component.set('v.avsCheckModalHeader', 'Void a Transaction');
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    cancelHandler: function(component, event, helper) {
        try {
            component.set('v.avsCheckModalHeader', 'Security Mismatch');
            component.set('v.avsCheckAction', 'Mismatch');
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    voideHandler: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.voidTransaction(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
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
    returnToPreviewPaymentSchedule: function(component, event, helper) {
        try {
            component.set("v.isOpenScheduleDatesModal", false);
            component.set("v.isOpen", true);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    AccountChange: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            if (!$A.util.isEmpty(component.get('v.selectedLookUpAccRecord.Id'))) {
                component.set("v.isAccountOpen", true);
            } else {
                component.set('v.Spinner', false);
                component.set("v.isAccountOpen", false);
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
})