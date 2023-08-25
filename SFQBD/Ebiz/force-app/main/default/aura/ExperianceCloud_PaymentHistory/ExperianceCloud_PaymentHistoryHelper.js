({
    getSettings: function (component, event) {
        var action = component.get("c.getSettingsApxc");
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var cs = response.getReturnValue();
                if ($A.util.isEmpty(cs.Ebiz_C__Security_Token__c)) {
                    component.set('v.ShowWarn', true);
                } else {
                    component.set('v.ShowWarn', false);
                }
                if ($A.util.isUndefinedOrNull(cs.Ebiz_C__Security_Token__c)) {
                    component.set("v.Spinner", false);
                    this.showToastMsg('Please get a security token from the publisher', 'Warning');
                    return;
                } else {
                    component.set('v.Settings', cs);
                    var RefNum = component.get('v.RefNum');
                    component.find("searchInput").set("v.value", RefNum);
                    var searchBy = {};
                    searchBy.InputText = RefNum;
                    searchBy.fromDate = null;
                    searchBy.toDate = null;
                    searchBy.ViewAll = false;
                    searchBy = JSON.stringify(searchBy);
                    this.getTranscations(component, event, searchBy);
                }
            }
        });
        $A.enqueueAction(action);
    },
    getTranscations: function (component, event, searchBy) {
        if (searchBy.length > 0) {
            var action = component.get("c.getTransactionsApxc");
            action.setParams({
                filters: searchBy
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var res = response.getReturnValue();
                    var Tracscation_obj = res.Transactions;
                    component.set("v.Transcations", res.Transactions);
                    var dataList = res.Transactions.map(function (rowData) {
                        if (!rowData.Terminal) {
                            rowData.Terminal = '-';
                        }
                        if (rowData.Terminal == 'Contact') {
                            rowData.provenanceIconNameTerminal = 'standard:contact';
                        } else if (rowData.Terminal == 'Account') {
                            rowData.provenanceIconNameTerminal = 'standard:account';
                        } else {
                            if (rowData.Terminal == '-') {} else {
                                rowData.provenanceIconNameTerminal = 'standard:client';
                            }
                        }
                        if (rowData.PayBy == 'CreditCard') {
                            rowData.card = 'ending in ' + rowData.CardNumber;
                            if (rowData.CardType == 'V') {
                                rowData.cardClass = 'visa';
                            } else if (rowData.CardType == 'M') {
                                rowData.cardClass = 'master';
                            } else if (rowData.CardType == 'A') {
                                rowData.cardClass = 'american';
                            } else if (rowData.CardType == 'DS') {
                                rowData.cardClass = 'discover';
                            }
                        } else {
                            rowData.cardClass = 'ach';
                            rowData.card = 'ending in ' + rowData.checkAccount;
                        }
                        if (rowData.Result == 'Approved') {
                            rowData.provenanceIconNameResult = 'utility:success';
                        } else {
                            rowData.provenanceIconNameResult = 'utility:warning';
                        }
                        return rowData;
                    });
                    component.set("v.TotalTransactions", res.Transactions.length);
                    component.set('v.FromDate', res.fromDate);
                    component.set('v.ToDate', res.toDate);
                    component.set('v.sortAsc', true);
                    component.set('v.sortField', 'DateTime_x');
                    this.sortBy(component, "DateTime_x");
                    component.set("v.Spinner", false);
                    component.set('v.disableFindBtn', false);
                } else {
                    component.set('v.disableFindBtn', false);
                    component.set("v.Spinner", false);
                    this.showToastMsg('Please refresh the page and try again!', 'Error');
                }
            });
            $A.enqueueAction(action);
        } else {
            component.set("v.Spinner", false);
            component.set('v.Transcations', null);
            this.showToastMsg('Input a valid text to search', 'Error');
        }
    },
    getAjexEmail: function (component, event, refNumber) {
        if (refNumber > 0) {
            var action = component.get("c.GetEmailTrans");
            action.setParams({
                ref: refNumber
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var res = response.getReturnValue();
                    component.set("v.emailAddress", res);
                    component.set("v.Spinner", false);
                } else {
                    component.set("v.Spinner", false);
                }
            });
            $A.enqueueAction(action);
        } else {
            component.set("v.Spinner", false);
        }
    },
    sortBy: function (component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.Transcations");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function (a, b) {
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.Transcations", records);
        component.set("v.Spinner", false);
    },
    convertArrayOfObjectsToCSV: function (component, objectRecords) {
        var csvStringResult, counter, keys, columnDivider, lineDivider;
        if (objectRecords == null || !objectRecords.length) {
            return null;
        }
        columnDivider = ',';
        lineDivider = '\n';
        keys = ['Ref Number', 'Order Number', 'Type', 'Account Name', 'Date & Time Paid', 'Auth Code', 'Amount', 'Result', 'Source', 'Status'];
        csvStringResult = '';
        csvStringResult += keys.join(columnDivider);
        csvStringResult += lineDivider;
        var counter = 0;
        for (var i = 0; i < objectRecords.length; i++) {
            var rec = objectRecords[i];
            csvStringResult += '"' + rec.RefNumber + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.OrderNumber + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.TransType + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.AccountName + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.TransDate + ' ' + rec.TransTime + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.AuthCode + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"$' + rec.AuthAmount + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.Result + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.Source + '"';
            csvStringResult += columnDivider;
            csvStringResult += '"' + rec.Status + '"';
            csvStringResult += lineDivider;
            counter++;
        }
        return csvStringResult;
    },
    getRowActions: function (cmp, row, doneCallback) {
        var actions = [];
        actions.push({
            'label': 'Email Receipt',
            'iconName': 'utility:text_template',
            'name': 'EmailReceipt'
        });
        actions.push({
            'label': 'Download Receipt',
            'iconName': 'utility:save',
            'name': 'DownloadReceipt'
        });
        setTimeout($A.getCallback(function () {
            doneCallback(actions);
        }), 200);
    },
    sortData: function (component, fieldName, sortDirection) {
        var data = component.get("v.Transcations");
        var key = function (a) {
            return a[fieldName];
        }
        var reverse = sortDirection == 'asc' ? 1 : -1;
        if (fieldName == 'AuthAmount') {
            data.sort(function (a, b) {
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a > b) - (b > a));
            });
        } else if (fieldName == 'AuthCode') {
            data.sort(function (a, b) {
                var a = key(a) ? key(a) : '';
                var b = key(b) ? key(b) : '';
                return reverse * ((a > b) - (b > a));
            });
        } else {
            data.sort(function (a, b) {
                var a = key(a) ? key(a).toLowerCase() : '';
                ing
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a > b) - (b > a));
            });
        }
        component.set("v.Transcations", data);
    },
    showToastMsg: function (msg, type) {
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