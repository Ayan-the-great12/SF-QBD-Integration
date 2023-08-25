({
    doInit: function(component, event, helper) {
        try {
            component.set("v.Spinner", true);
            helper.getSettings(component);
            var rowActions = helper.getRowActions.bind(this, component);
            component.set("v.DataColumns", [{
                    label: 'Ref Number',
                    fieldName: 'RefNumber',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:price_book_entries',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Order Number',
                    fieldName: 'OrderId',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconFName'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelFname'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Type',
                    fieldName: 'TransType',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconLName'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelLname'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Card Holder Name',
                    fieldName: 'AccountName',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:user',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Date & Time Paid',
                    fieldName: 'FormatedTransDate',
                    type: 'date',
                    typeAttributes: {
                        day: 'numeric',
                        month: 'short',
                        year: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit',
                        hour12: false
                    },
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:date_input',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Auth Code',
                    fieldName: 'AuthCode',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:yubi_key',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Payment Method',
                    fieldName: 'card',
                    initialWidth: 160,
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
                    label: 'Amount',
                    fieldName: 'AuthAmount',
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
                        iconPosition: 'left',
                        lass: {
                            fieldName: 'count'
                        }
                    }
                },
                {
                    label: 'Result',
                    fieldName: 'Result',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameResult'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelResult'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Source',
                    fieldName: 'Source',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameSource'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelSource'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Status',
                    fieldName: 'Status',
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
                    label: 'Customer Type',
                    fieldName: 'Terminal',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameTerminal'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelTerminal'
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
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    getAllTranscations: function(component, event, helper) {
        var searchBy = {};
        searchBy.InputText = '';
        var checkbox = event.getSource().get("v.value");
        if (checkbox) {
            searchBy.ViewAll = true;
        } else {
            searchBy.ViewAll = false;
        }
        searchBy.fromDate = null;
        searchBy.toDate = null;
        searchBy = JSON.stringify(searchBy);
        component.set("v.Spinner", true);
        helper.getTranscations(component, event, searchBy);
    },
    getTranscations: function(component, event, helper) {
        try {
            component.set("v.Spinner", true);
            var searchBy = {};
            searchBy.InputText = '';
            searchBy.ViewAll = false;
            var fromDate = component.get('v.FromDate');
            searchBy.fromDate = fromDate;
            var toDate = component.get('v.ToDate');
            searchBy.toDate = toDate;
            var date1 = new Date(fromDate.toString());
            var date2 = new Date(toDate.toString());
            var Difference_In_Time = date2 - date1;
            var Difference_In_Days = Difference_In_Time / (1000 * 3600 * 24);
            if (Difference_In_Days > 14) {
                helper.showToastMsg('Processing for this date difference will be slow', 'Warning');
            }
            searchBy = JSON.stringify(searchBy);
            helper.getTranscations(component, event, searchBy);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    onChangeSearchText: function(component, event, helper) {
        try {
            if (event.which == 13) {
                component.set('v.FromDate', '');
                component.set('v.ToDate', '');
                component.set('v.disableFindBtn', true);
                component.set('v.disableClearBtn', true);
                component.set("v.Spinner", true);
                var searchBy = {};
                var searchInput = component.find("searchInput").get("v.value");
                var checkBox = component.find("viewAllCheckbox").get("v.value");
                if(checkBox)
                {
                    searchBy.ViewAll = true;
                }else
                {
                    searchBy.ViewAll = false;
                }
                searchBy.InputText = searchInput;
                searchBy.fromDate = null;
                searchBy.toDate = null;
                searchBy = JSON.stringify(searchBy);
                helper.getTranscations(component, event, searchBy);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    ClearDateRange: function(component, event, helper) {
        try {
            component.set("v.Spinner", true);
            component.set('v.FromDate', null);
            component.set('v.ToDate', null);
            var searchBy = {};
            searchBy.InputText = '';
            searchBy.fromDate = null;
            searchBy.toDate = null;
            var checkBox = component.find("viewAllCheckbox").get("v.value");
            if (checkBox) {
                searchBy.ViewAll = true;
            } else {
                searchBy.ViewAll = false;
            }
            searchBy = JSON.stringify(searchBy);
            helper.getTranscations(component, event, searchBy);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    validateForm: function(component, event, helper) {
        try {
            var FromDate = component.get('v.FromDate');
            var ToDate = component.get('v.ToDate');
            if (!$A.util.isEmpty(FromDate) && !$A.util.isEmpty(ToDate)) {
                var fDate = new Date(FromDate);
                var tDate = new Date(ToDate);
                var timeDiffrence = tDate - fDate;
                if (timeDiffrence <= 0) {
                    component.set('v.disableFindBtn', true);
                    component.set('v.disableClearBtn', true);
                    helper.showToastMsg('From date should be less than To date!', 'Error');
                } else {
                    component.set('v.disableFindBtn', false);
                    component.set('v.disableClearBtn', false);
                }
            } else {
                component.set('v.disableFindBtn', true);
                component.set('v.disableClearBtn', true);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    SelectAllTransactions: function(component, event, helper) {
        try {
            var checkvalue = event.getSource().get("v.value");
            var checkTransaction = component.find("checkTransaction");
            if (checkvalue == true) {
                for (var i = 0; i < checkTransaction.length; i++) {
                    checkTransaction[i].set("v.value", true);
                }
            } else {
                for (var i = 0; i < checkTransaction.length; i++) {
                    checkTransaction[i].set("v.value", false);
                }
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleSelectAction: function(component, event, helper) {
        try {
            var as = {};
            var arr = [];
            var selectedActionRefNum = event.getParam("value");
            arr = selectedActionRefNum.split('@');
            as.refNum = arr[0];
            if (arr[1] == 'VoidTransaction') {
                as.action = 'VoidTransaction';
                as.amount = arr[2];
                as.OrderId = arr[3];
                as.AccountId = arr[4];
                as.Tax = arr[5];
                as.modalTitle = 'Void Transaction';
                as.modalMessage = 'Are you sure you want to void the selected transaction?';
                component.set('v.showModal', true);
                component.set('v.actionString', as);
            } else if (arr[1] == 'RefundTransaction') {
                as.action = 'RefundTransaction';
                as.amount = arr[2];
                as.OrderId = arr[3];
                as.AccountId = arr[4];
                as.Tax = arr[5];
                as.modalTitle = 'Refund Transaction';
                as.modalMessage = 'Are you sure you want to refund the selected transaction?';
                component.set('v.showModal', true);
                component.set('v.actionString', as);
            } else if (arr[1] == 'EmailReceipt') {
                as.action = 'EmailReceipt';
                as.amount = arr[2];
                as.OrderId = arr[3];
                as.AccountId = arr[4];
                as.Tax = arr[5];
                as.modalTitle = 'Email Transaction\'s Receipt';
                as.modalMessage = 'Working on it';
                component.set('v.showModal', true);
                component.set('v.actionString', as);
                try {
                    helper.getAjexEmail(component, event, as.refNum);
                } catch (err) {}
            } else if (arr[1] == 'DownloadReceipt') {
                var refNum = arr[0];
                var TransList = component.get("v.Transcations");
                for (var i = 0; i < TransList.length; i++) {
                    var s = TransList[i];
                    if (refNum == s.RefNumber) {
                        var JSONStr = JSON.stringify(s);
                        var vfUrl = '/apex/Ebiz_C__downloadPDF?str=' + JSONStr;
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": vfUrl
                        });
                        urlEvent.fire();
                        break;
                    }
                }
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleExportAs: function(component, event, helper) {
        try {
            var allTransactions = component.get("v.SelectT");
            var isSelectAll = component.get("v.isSelectAll");
            var selectedTransactions = [];
            var exportAs = 'csv';
            if (exportAs == 'csv') {
                selectedTransactions = allTransactions;
                if (selectedTransactions.length > 0) {
                    var csv = helper.convertArrayOfObjectsToCSV(component, selectedTransactions);
                    if (csv == null) {
                        return;
                    }
                    var hiddenElement = document.createElement('a');
                    hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                    hiddenElement.target = '_self';
                    hiddenElement.download = 'ExportData.csv';
                    document.body.appendChild(hiddenElement);
                    hiddenElement.click();
                } else {
                    helper.showToastMsg('Please select records to export', 'Error');
                }
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleSort: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortData(component, sortBy, sortDirection);
    },
    handleRowAction: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var as = {};
        as.refNum = row.RefNumber;
        as.transType = row.TransType;
        if (action.name == 'VoidTransaction') {
            if (row.Result == 'Error') {
                helper.showToastMsg("Error contained transaction can't be void.", 'Error');
                return;
            }
            as.action = 'VoidTransaction';
            as.amount = row.AuthAmount;
            as.OrderId = row.OrderId;
            as.AccountId = row.CustomerId;
            as.Tax = row.Tax;
            as.modalTitle = 'Void Transaction';
            as.modalMessage = 'Are you sure you want to void the selected transaction?';
            component.set('v.showModal', true);
            component.set('v.actionString', as);
        } else if (action.name == 'RefundTransaction') {
            as.action = 'RefundTransaction';
            as.amount = row.AuthAmount;
            as.OrderId = row.OrderId;
            as.AccountId = row.CustomerId;
            as.Tax = row.Tax;
            as.modalTitle = 'Refund Transaction';
            as.modalMessage = 'Are you sure you want to refund the selected transaction?';
            component.set('v.showModal', true);
            component.set('v.actionString', as);
        } else if (action.name == 'EmailReceipt') {
            as.action = 'EmailReceipt';
            as.amount = row.AuthAmount;
            as.OrderId = row.OrderId;
            as.AccountId = row.CustomerId;
            as.Tax = row.Tax;
            as.modalTitle = 'Email Transaction\'s Receipt';
            as.modalMessage = 'Working on it';
            component.set('v.showModal', true);
            component.set('v.actionString', as);
            try {
                helper.getAjexEmail(component, event, as.refNum);
            } catch (err) {}
        } else if (action.name == 'DownloadReceipt') {
            var refNum = row.RefNumber;
            var TransList = component.get("v.Transcations");
            for (var i = 0; i < TransList.length; i++) {
                var s = TransList[i];
                if (refNum == s.RefNumber) {
                    var JSONStr = JSON.stringify(s);
                    var vfUrl = '/apex/Ebiz_C__downloadPDF?str=' + JSONStr;
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": vfUrl
                    });
                    urlEvent.fire();
                    break;
                }
            }
        }
    },
    updateSelectedText: function(cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var dataList = selectedRows.map(function(rowData) {
            return rowData;
        });
        if (selectedRows.length > 0) {
            cmp.set('v.SelectT', selectedRows);
        }
        cmp.set('v.selectedRowsCount', selectedRows.length);
    }
})