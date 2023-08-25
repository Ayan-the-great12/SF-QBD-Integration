({
    getAccountSavedCards: function (component, event) {
        var rrS = component.get('v.rrS');
        var action = component.get("c.getSavedCardsApxc");
        action.setParams({
            AccountID: rrS.accountId,
            accExtId: rrS.accExtId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                var savedCard = [];
                var savedACH = [];
                var payM = records.savedPaymentMethods;
                for (var key in payM) {
                    var arr = [];
                    arr = key.toString().split('@');
                    if (arr[1] == 'C') {
                        savedCard.push({
                            value: arr[0],
                            label: payM[key]
                        });
                    } else {
                        savedACH.push({
                            value: arr[0],
                            label: payM[key]
                        });
                    }
                }
                component.set('v.saveCardsList', savedCard);
                component.set('v.saveACHList', savedACH);
                var savedCards = component.get('v.saveCardsList');
                if (savedCards.length > 0) {
                    component.set('v.placeholderCard', 'Select saved cards');
                } else {
                    component.set('v.placeholderCard', 'No saved cards on file');
                }
                var savedBankAccounts = component.get('v.saveACHList');
                if (savedBankAccounts.length > 0) {
                    component.set('v.placeholderACH', 'Select saved accounts');
                } else {
                    component.set('v.placeholderACH', 'No saved accounts on file');
                }
                component.set('v.isOpen', true);
                component.set("v.Spinner", false);
            } else {
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    submitAddNewACHForm: function (component, event, helper) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var pby = component.get('v.payByACHInfo');
        var addNewACH = {};
        addNewACH.payBy = pby.payBy;
        addNewACH.OrderNo = '00000';
        addNewACH.objectName = component.get('v.Object_Name');
        addNewACH.accId = component.get("v.accDetail.Id");
        addNewACH.accExtrId = component.get("v.accDetail.Ebiz_C__EBizCharge_Internal_ID__c");
        addNewACH.accAmount = component.get('v.accDetail.Ebiz_C__EBizCharge_Amount__c');
        if (addNewACH.objectName == 'Contact') {
            addNewACH.accId = component.get("v.ConDetail.Id");
            addNewACH.accExtrId = component.get("v.ConDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c");
            addNewACH.accAmount = component.get('v.ConDetail.Ebiz_C__EBizCharge_Contact_Amount__c ');
            if (addNewACH.accExtrId == '' || addNewACH.accExtrId == null) {
                component.set('v.Spinner', false);
                this.showToast('Please try to Sync Account/Contact before Scheduling Payment', 'Error');
                return;
            }
        }
        addNewACH.Amount = parseFloat(component.get('v.rrAmount'));
        addNewACH.PaymentTotal = parseFloat(component.get('v.rrAmountTotal'));
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            var amount = addNewACH.Amount;
            var Tax = component.get('v.rrTax') / 100;
            Tax = (amount * Tax).toFixed(2);
            addNewACH.Tax = parseFloat(Tax);
        } else {
            addNewACH.Tax = parseFloat(component.get('v.rrTax'));
        }
        var rrS = component.get('v.rrS');
        addNewACH.isRecurring = true;
        addNewACH.rrPayName = component.get('v.rrPayName');
        addNewACH.rrFrequency = component.get('v.rrFrequency');
        addNewACH.rrNotes = component.get('v.rrNotes');
        addNewACH.rrStartDate = component.get('v.rrStartDate');
        addNewACH.rrEndDate = component.get('v.rrEndDate');
        addNewACH.rrIndefinit = component.get('v.rrIndefinitely');
        addNewACH.SchedPayInternalId = rrS.SchedPayInternalId;
        addNewACH.accHolderName = pby.accHolderName;
        addNewACH.accNumber = pby.accNumber;
        addNewACH.accRoutNumber = pby.accRoutNumber;
        addNewACH.accType = pby.accType;
        addNewACH.saveACH = pby.saveACH;
        addNewACH.SendReceiptTo = pby.SendReceiptTo;
        addNewACH.addEmails = pby.addEmails;
        addNewACH.MethodName = pby.MethodName;
        var action = component.get("c.runRecurringApxc");
        action.setParams({
            rrInfoJSON: JSON.stringify(addNewACH),
            actionStatus: 'Update'
        });
        action.setCallback(this, function (a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                var arr = [];
                arr = retValue.split('@');
                var message = arr[0];
                if (message == 'RecurringScheduled') {
                    this.showToast('Recurring payment schedule updated successfully!', 'Success');
                    component.set('v.disableSubmitBtn', false);
                    this.getScheduledRecurring(component, event);
                } else {
                    component.set('v.Spinner', false);
                    this.showToast(arr[1], 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    submitExistACHForm: function (component, event, helper) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var pby = component.get('v.payByACHInfo');
        var savedACH = {};
        savedACH.payBy = pby.payBy;
        savedACH.OrderNo = '00000';
        savedACH.objectName = component.get('v.Object_Name');
        savedACH.accId = component.get("v.accDetail.Id");
        savedACH.accExtrId = component.get("v.accDetail.Ebiz_C__EBizCharge_Internal_ID__c");
        savedACH.accAmount = component.get('v.accDetail.Ebiz_C__EBizCharge_Amount__c');
        if (savedACH.objectName == 'Contact') {
            savedACH.accId = component.get("v.ConDetail.Id");
            savedACH.accExtrId = component.get("v.ConDetail.Ebiz_C__EBizCharge_Contact_Internal_ID__c");
            savedACH.accAmount = component.get('v.ConDetail.Ebiz_C__EBizCharge_Contact_Amount__c ');
            if (savedACH.accExtrId == '' || savedACH.accExtrId == null) {
                component.set('v.Spinner', false);
                this.showToast('Please try to Sync Account/Contact before Scheduling Payment', 'Error');
                return;
            }
        }
        savedACH.Amount = parseFloat(component.get('v.rrAmount'));
        savedACH.PaymentTotal = parseFloat(component.get('v.rrAmountTotal'));
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            var amount = savedACH.Amount;
            var Tax = component.get('v.rrTax') / 100;
            Tax = (amount * Tax).toFixed(2);
            savedACH.Tax = parseFloat(Tax);
        } else {
            savedACH.Tax = parseFloat(component.get('v.rrTax'));
        }
        var rrS = component.get('v.rrS');
        savedACH.isRecurring = true;
        savedACH.SchedPayInternalId = rrS.SchedPayInternalId;
        savedACH.rrPayName = component.get('v.rrPayName');
        savedACH.rrFrequency = component.get('v.rrFrequency');
        savedACH.rrNotes = component.get('v.rrNotes');
        savedACH.rrStartDate = component.get('v.rrStartDate');
        savedACH.rrEndDate = component.get('v.rrEndDate');
        savedACH.rrIndefinit = component.get('v.rrIndefinitely');
        savedACH.selectedACHId = pby.selectedACHId;
        savedACH.SendReceiptTo = pby.SendReceiptTo;
        savedACH.addEmails = pby.addEmails;
        var action = component.get("c.runRecurringApxc");
        action.setParams({
            rrInfoJSON: JSON.stringify(savedACH),
            actionStatus: 'Update'
        });
        action.setCallback(this, function (a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                var arr = [];
                arr = retValue.split('@');
                var message = arr[0];
                if (message == 'RecurringScheduled') {
                    this.showToast('Recurring payment schedule updated successfully!', 'Success');
                    component.set('v.disableSubmitBtn', false);
                    this.getScheduledRecurring(component, event);
                } else {
                    component.set('v.Spinner', false);
                    this.showToast(arr[1], 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    getScheduledRecurring: function (component, event) {
        var SearchIdObj = component.get('v.selectedLookUpAccRecord.Id');
        var status = component.get('v.rrStatus');
        var action = component.get('c.getScheduledRecurringApxc');
        component.set('v.scheduledRecurring', []);
        action.setParams({
            SearchId: SearchIdObj,
            Status: status
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.scheduledRecurring', response.getReturnValue());
                var dataList = response.getReturnValue().map(function (rowData) {
                    rowData.rrMaskedPMValue = 'ending in ' + rowData.rrMaskedPM;
                    if (rowData.rrPMType == 'Visa') {
                        rowData.cardClass = 'visa';
                    } else if (rowData.rrPMType == 'MasterCard') {
                        rowData.cardClass = 'master';
                    } else if (rowData.rrPMType == 'American Express') {
                        rowData.cardClass = 'american';
                    } else if (rowData.rrPMType == 'Discover') {
                        rowData.cardClass = 'discover';
                    } else if (rowData.rrPMType == 'ACH') {
                        rowData.cardClass = 'ach';
                    }
                    if (rowData.rrScheduleStatus == '0') {
                        rowData.rrScheduleStatusValue = 'Active';
                        rowData.provenanceIconNameStatus = 'utility:check';
                    } else if (rowData.rrScheduleStatus == '1') {
                        rowData.rrScheduleStatusValue = 'Suspended';
                        rowData.provenanceIconNameStatus = 'utility:recurring_exception';
                    } else if (rowData.rrScheduleStatus == '2') {
                        rowData.rrScheduleStatusValue = 'Expired';
                        rowData.provenanceIconNameStatus = 'utility:warning';
                    } else if (rowData.rrScheduleStatus == '3') {
                        rowData.rrScheduleStatusValue = 'Canceled';
                        rowData.provenanceIconNameStatus = 'utility:close';
                    }
                    if (rowData.rrSchedule == 'once') {
                        rowData.provenanceIconrrSchedule = 'utility:dayview';
                    } else if (rowData.rrSchedule == 'daily') {
                        rowData.provenanceIconrrSchedule = 'utility:dayview';
                    } else if (rowData.rrSchedule == 'monthly') {
                        rowData.provenanceIconrrSchedule = 'utility:monthlyview';
                    } else if (rowData.rrSchedule == 'weekly') {
                        rowData.provenanceIconrrSchedule = 'utility:weeklyview';
                    } else if (rowData.rrSchedule == 'quarterly') {
                        rowData.provenanceIconrrSchedule = 'utility:weeklyview';
                    } else if (rowData.rrSchedule == 'bi-weekly') {
                        rowData.provenanceIconrrSchedule = 'utility:weeklyview';
                    }
                    return rowData;
                });
                component.set("v.Spinner", false);
            } else {
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    updScheduledRRStatus: function (component, recIntenalId, ScheduleStatus) {
        var action = component.get('c.updScheduledRRStatusApxc');
        action.setParams({
            recIntenalId: recIntenalId,
            ScheduleStatus: ScheduleStatus
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var res = response.getReturnValue();
                if (res == 'statusUpdated') {
                    component.set("v.Spinner", false);
                    if (ScheduleStatus == 0) {
                        this.showToast('Schedule resumed successfully!', 'Success');
                    } else if (ScheduleStatus == 1) {
                        this.showToast('Schedule suspended successfully!', 'Success');
                    } else if (ScheduleStatus == 3) {
                        this.showToast('Schedule cancelled successfully!', 'Success');
                    } else {
                        this.showToast('Schedule updated successfully!', 'Success');
                    }
                } else {
                    this.showToast(res, 'Error');
                }
                this.getScheduledRecurring(component, event);
            } else {
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    submitRRForm: function (component, event, payBy) {
        var Settings = component.get('v.Settings');
        var TaxAction = Settings.Ebiz_C__Tax_Action__c;
        var rrS = component.get('v.rrS');
        var saveWithXC = {};
        saveWithXC.payBy = payBy;
        saveWithXC.OrderNo = '00000';
        saveWithXC.accId = rrS.accountId;
        saveWithXC.accExtrId = rrS.accExtId;
        saveWithXC.SchedPayInternalId = rrS.SchedPayInternalId;
        saveWithXC.isRecurring = true;
        saveWithXC.rrPayName = component.get('v.rrPayName');
        saveWithXC.rrFrequency = component.get('v.rrFrequency');
        saveWithXC.rrNotes = component.get('v.rrNotes');
        saveWithXC.rrStartDate = component.get('v.rrStartDate');
        saveWithXC.rrEndDate = component.get('v.rrEndDate');
        saveWithXC.rrIndefinit = component.get('v.rrIndefinitely');
        saveWithXC.PaymentTotal = component.get('v.rrAmountTotal');
        var Amount = parseFloat(component.get('v.rrAmount'));
        var Tax = parseFloat(component.get('v.rrTax'));
        if (TaxAction == 'Tax Included') {
            Amount = parseFloat(Amount) - parseFloat(Tax);
        }
        saveWithXC.Amount = parseFloat(Amount);
        if (Settings.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
            Tax = Tax / 100;
            Tax = (Amount * Tax).toFixed(2);
        }
        saveWithXC.Tax = parseFloat(Tax);
        if (payBy == 'UseExistingCard') {
            saveWithXC.selectedCard = component.get('v.selectedCardXC');
            saveWithXC.CVC = component.get('v.cvcXC');
            saveWithXC.SendReceiptTo = component.get('v.SendReceiptToXC');
            saveWithXC.addEmails = component.get('v.addEmailsXC');
        } else {
            saveWithXC.CardNumber = component.get('v.CardNumber');
            saveWithXC.BillingAddress = component.get('v.BillingAddress');
            saveWithXC.expiryMonth = component.get('v.expiryMonth');
            saveWithXC.expiryYear = component.get('v.expiryYear');
            saveWithXC.CVC = component.get('v.CVCNumber');
            saveWithXC.ZipCode = component.get('v.ZipCode');
            saveWithXC.CardHolderName = component.get('v.CardHolderName');
            saveWithXC.SendReceiptTo = component.get('v.SendReceiptTo');
            saveWithXC.addEmails = component.get('v.addEmails');
            saveWithXC.saveCard = true;
        }
        var action = component.get("c.runRecurringApxc");
        action.setParams({
            rrInfoJSON: JSON.stringify(saveWithXC),
            actionStatus: 'Update'
        });
        action.setCallback(this, function (a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                var arr = [];
                arr = retValue.split('@');
                var message = arr[0];
                if (message == 'RecurringScheduled') {
                    component.set('v.disableSubmitBtn', false);
                    this.getScheduledRecurring(component, event);
                    this.showToast('Recurring payment schedule updated successfully!', 'Success');
                } else {
                    component.set('v.Spinner', false);
                    this.showToast(arr[1], 'Error');
                }
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToast('Something went wrong ' + errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    getAccountDetail: function (component, event) {
        var accountId = component.get('v.rrS.accountId');
        var action = component.get("c.getAccountDetailApxc");
        action.setParams({
            objID: accountId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                var address = records.Address;
                var zipcode = records.ZipCode;
                if (records.Object_Name == 'custom') {
                    component.set("v.custDetail", records.custDetail);
                }
                if (records.Object_Name == 'Contact') {
                    component.set("v.ConDetail", records.contactDetail);
                    component.set("v.accDetail", records.accountDetail);
                } else {
                    component.set("v.accDetail", records.accountDetail);
                }
                component.set("v.accDetail", records.accountDetail);
                component.set("v.BillingAddress", address);
                component.set("v.ZipCode", zipcode);
                var savedCard = [];
                var savedACH = [];
                var payM = records.savedPaymentMethods;
                for (var key in payM) {
                    var arr = [];
                    arr = key.toString().split('@');
                    if (arr[1] == 'C') {
                        savedCard.push({
                            value: arr[0],
                            label: payM[key]
                        });
                    } else {
                        savedACH.push({
                            value: arr[0],
                            label: payM[key]
                        });
                    }
                }
                component.set('v.Object_Name', records.Object_Name);
                component.set('v.saveCardsList', savedCard);
                component.set('v.saveACHList', savedACH);
                component.set("v.Spinner", false);
            } else {
                component.set("v.Spinner", false);
            }
        });
        $A.enqueueAction(action);
    },
    sortBy: function (component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.scheduledRecurring");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function (a, b) {
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.scheduledRecurring", records);
        this.renderPage(component);
    },
    renderPage: function (component) {
        var records = component.get("v.scheduledRecurring"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = records.slice((pageNumber - 1) * 1000, pageNumber * 1000);
        component.set("v.scheduledRecurring", pageRecords);
    },
    sortData: function (component, fieldName, sortDirection) {
        var data = component.get("v.scheduledRecurring");
        var key = function (a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'rrAmount') {
            data.sort(function (a, b) {
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a > b) - (b > a));
            });
        } else if (fieldName == 'RecurringHyperUrl') {
            var key = function (a) {
                return a['accName'];
            }
            data.sort(function (a, b) {
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a > b) - (b > a));
            });
        } else {
            data.sort(function (a, b) {
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a > b) - (b > a));
            });
        }
        component.set("v.scheduledRecurring", data);
    },
    getRowActions: function (cmp, row, doneCallback) {
        var actions = [];
        if (row.rrScheduleStatus === '0') {
            actions.push({
                'label': 'Suspend Payment Schedule',
                'iconName': 'utility:recurring_exception',
                'name': 'SuspendPaymentSchedule'
            });
        }
        actions.push({
            'label': 'Edit Payment Schedule',
            'iconName': 'utility:edit_form',
            'name': 'Edit'
        });
        if (row.rrScheduleStatus === '1' || row.rrScheduleStatus === '3') {
            actions.push({
                'label': 'Resume Payment Schedule',
                'iconName': 'utility:right',
                'name': 'ResumePaymentSchedule'
            });
        }
        if (row.rrScheduleStatus != '3') {
            actions.push({
                'label': 'Cancel Payment Schedule',
                'iconName': 'utility:close',
                'name': 'Cancel'
            });
        }
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    showToast: function (message, type) {
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
    saveInputsSA: function (component, event) {
        var tab = component.get('v.ChieldActiveTab');
        var savedACH = {};
        savedACH.payBy = tab;
        savedACH.selectedACHId = component.get('v.paymentMethodIdSA');
        savedACH.SendReceiptTo = component.get('v.SendReceiptToSA');
        savedACH.addEmails = component.get('v.addEmailsSA');
        component.set('v.payByACHInfo', savedACH);
    },
    saveInputsAA: function (component, event) {
        var tab = component.get('v.ChieldActiveTab');
        var addNewACH = {};
        addNewACH.payBy = tab;
        addNewACH.selectedACHId = component.get('v.paymentMethodIdSA');
        addNewACH.accHolderName = component.get('v.accHolderName');
        addNewACH.accNumber = component.get('v.accNumber');
        addNewACH.accRoutNumber = component.get('v.accRoutNumber');
        addNewACH.accType = component.get('v.accType');
        addNewACH.saveACH = component.get('v.saveACH');
        addNewACH.SendReceiptTo = component.get('v.SendReceiptTo');
        addNewACH.addEmails = component.get('v.addEmails');
        addNewACH.MethodName = component.get('v.MethodName');
        component.set('v.payByACHInfo', addNewACH);
    },
    saveInputsSAACH: function (component, event) {
        var tab = component.get('v.ChieldActiveTab');
        var savedACH = {};
        savedACH.payBy = tab;
        savedACH.selectedACHId = component.get('v.paymentMethodIdSA');
        savedACH.SendReceiptTo = component.get('v.SendReceiptToSA');
        savedACH.addEmails = component.get('v.addEmailsSA');
        component.set('v.payByACHInfo', savedACH);
    },
    saveInputsAC: function (component, event) {
        var tab = component.get('v.ChieldActiveTab');
        var addNewCard = {};
        addNewCard.payBy = tab;
        addNewCard.CardNumber = component.get('v.CardNumber');
        addNewCard.BillingAddress = component.get('v.BillingAddress');
        addNewCard.expiryMonth = component.get('v.expiryMonth');
        addNewCard.expiryYear = component.get('v.expiryYear');
        addNewCard.CVCNumber = component.get('v.CVCNumber');
        addNewCard.ZipCode = component.get('v.ZipCode');
        addNewCard.CardHolderName = component.get('v.CardHolderName');
        addNewCard.saveCard = component.get('v.saveCard');
        addNewCard.SendReceiptTo = component.get('v.SendReceiptTo');
        addNewCard.addEmails = component.get('v.addCardEmail');
        addNewCard.MethodName = component.get('v.MethodName');
        component.set('v.payByCardInfo', addNewCard);
    },
    clearAllFields: function (component, event) {
        component.set('v.payByCardInfo', null);
        component.set('v.ZipCode', null);
        component.set('v.disableSubmitBtn', false);
        component.set('v.MethodName', null);
        component.set('v.BillingAddress', null);
        component.set('v.accNumber', null);
        component.set('v.accHolderName', null);
        component.set('v.accType', null);
        component.set('v.accRoutNumber', null);
        component.set('v.cvcXC', null);
        component.set('v.CardNumber', '');
        component.set('v.expiryMonth', '');
        component.set('v.expiryYear', '');
        component.set('v.CVCNumber', '');
        component.set('v.saveCard', false);
        component.set('v.CardHolderName', '');
        component.set('v.SendReceiptTo', false);
        component.set('v.SendReceiptToAddCard', false);
        component.set('v.addCardEmail', '');
        component.set('v.addEmails', '');
    },
    saveInputsXC: function (component, event) {
        var tab = component.get('v.ChieldActiveTab');
        var saveWithXC = {};
        saveWithXC.payBy = tab;
        saveWithXC.selectedCardXC = component.get('v.selectedCardXC');
        saveWithXC.cvcXC = component.get('v.cvcXC');
        saveWithXC.addEmailsXC = component.get('v.addEmailsXC');
        saveWithXC.SendReceiptToXC = component.get('v.SendReceiptToXC');
        component.set('v.payByCardInfo', saveWithXC);
    },
})