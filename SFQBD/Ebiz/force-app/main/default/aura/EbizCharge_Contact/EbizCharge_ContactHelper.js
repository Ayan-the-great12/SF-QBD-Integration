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
    getContactList: function(component, event) {
        var action = component.get("c.getAllContactsApxc");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var records = response.getReturnValue();
                var dataList = records.map(function(rowData) {
                    if (rowData.conEmail) {
                        rowData.provenanceIconNameEmail = 'utility:email';
                    }
                    if (rowData.conPhone) {
                        rowData.provenanceIconNamePhone = 'utility:call';
                    }
                    if (!rowData.conLastName) {
                        rowData.conLastName = '-';
                    }
                    if (!rowData.conFirstName) {
                        rowData.conFirstName = '-';
                    }
                    if (!rowData.conAmount) {
                        rowData.conAmount = 0.0;
                    }
                    if (!rowData.conEmail) {
                        rowData.conEmail = '-';
                    }
                    if (!rowData.conPhone) {
                        rowData.conPhone = '-';
                    }
                    if (rowData.conStatus == 'Synced') {
                        rowData.provenanceIconNameSync = 'utility:success';
                    } else {
                        rowData.provenanceIconNameSync = 'utility:warning';
                    }
                    return rowData;
                });
                component.set('v.allContacts', records);
                component.set("v.maxPage", Math.floor((records.length + 49) / 50));
                component.set("v.Spinner", false);
            } else {
                component.set("v.Spinner", false);
                this.showToastMsg('Please refresh the page and try again!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    getAccountDetail: function(component, event) {
        var action = component.get('c.getContactDetailApxc');
        action.setParams({
            "ContactId": component.get('v.setRecordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var resInfo = response.getReturnValue();
            if (state == "SUCCESS") {
                component.set("v.conDetail", resInfo.ContactInfo);
                component.set("v.UseFullAmountForAVS", resInfo.UseFullAmountForAVS);
                var savedCard = [];
                var savedACH = [];
                var payM = resInfo.savedPaymentMethods;
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
                component.set('v.showTakePayModal', true);
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    SyncSelectedAccounts: function(component, event) {
        var ConList = component.get("v.contactList");
        var isSelectAll = component.get("v.isSelectAll");
        var selectedContact = ConList;
        if (selectedContact.length > 0) {
            if (selectedContact.length > 50) {
                this.showToastMsg('We don\'t process more than 50 records to sync, Please select less than 50 records to Sync.', 'warning');
                component.set("v.Spinner", false);
            } else {
                var action = component.get("c.syncContactApxc");
                action.setParams({
                    selectedContact: selectedContact
                });
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        component.set("v.Spinner", false);
                        this.getContactList(component);
                        this.showToastMsg('Contacts Successfully Synced!', 'Success');
                    } else {
                        component.set("v.Spinner", false);
                        this.showToastMsg('Darn it! Something went wrong!', 'Error');
                    }
                });
                $A.enqueueAction(action);
            }
        } else {
            component.set("v.Spinner", false);
            this.showToastMsg('Please select atleast one Contact to Sync!', 'Error');
        }
    },
    loadEmailTemplates: function(component, event) {
        var action = component.get('c.getEmailTemplatesApxc');
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var temps = [];
                var res = response.getReturnValue();
                component.set("v.emailTemplist", res);
                component.set('v.showReqPayModal', true);
                component.set("v.Spinner", false);
            } else {
                component.set("v.Spinner", false);
                this.showToastMsg('Something went wrong!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.allContacts");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a, b) {
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.allContacts", records);
        this.renderPage(component);
    },
    renderPage: function(component) {
        var records = component.get("v.allContacts"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = records.slice((pageNumber - 1) * 1000, pageNumber * 1000);
        component.set("v.accountList", pageRecords);
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
    getRowActions: function(cmp, row, doneCallback) {
        var actions = [{
            'label': 'Edit Contact',
            'iconName': 'utility:edit',
            'name': 'editAccount'
        }];
        var take_payment_action = {
            'label': 'Take Payment on Contact',
            'iconName': 'utility:money',
            'name': 'takepayment'
        };
        var request_payment_action = {
            'label': 'Request Payment Method',
            'iconName': 'utility:change_record_type',
            'name': 'requestpayment'
        };
        if (row.conStatus == 'Not Synced') {
            take_payment_action.disabled = 'true';
            request_payment_action.disabled = 'true';
        }
        actions.push(take_payment_action);
        actions.push(request_payment_action);
        setTimeout($A.getCallback(function() {
            doneCallback(actions);
        }), 200);
    },
    sortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.allContacts");
        var key = function(a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'conAmount') {
            data.sort(function(a, b) {
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a > b) - (b > a));
            });
        } else if (fieldName == 'conHyperUrl') {
            var key = function(a) {
                return a['conName'];
            }
            data.sort(function(a, b) {
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a > b) - (b > a));
            });
        } else {
            data.sort(function(a, b) {
                var a = key(a) ? key(a).toLowerCase() : '';
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a > b) - (b > a));
            });
        }
        component.set("v.allContacts", data);
    },
    handleSelectAction: function(action, component, helper) {
        var cs = component.get('v.Settings');
        if ($A.util.isUndefinedOrNull(cs.Ebiz_C__Security_Token__c)) {
            helper.showToastMsg('Please get a security token from the publisher', 'Warning');
            return;
        }
        var originallist = component.get("v.allContacts");
        var arr = [];
        arr = action.split('#');
        var act = arr[0];
        component.set('v.setRecordId', arr[1]);
        for (var o in originallist) {
            if (originallist[o].conId == arr[1]) {
                component.set("v.recDetail", originallist[o]);
                break;
            }
        }
        if (act == 'editAccount') {
            component.set('v.showAccModal', true);
        } else if (act == 'takepayment') {
            component.set("v.Spinner", true);
            var cs = component.get('v.Settings');
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
            this.getAccountDetail(component, event);
        } else if (act == 'requestpayment') {
            component.set("v.Spinner", true);
            this.loadEmailTemplates(component, event);
        }
    },
})