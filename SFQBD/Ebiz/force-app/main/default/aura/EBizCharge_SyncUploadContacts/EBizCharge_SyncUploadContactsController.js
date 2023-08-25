({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.getContacts(component, event);
            component.set("v.DataColumns", [{
                    label: 'Contact Name',
                    fieldName: 'HyperUrlContact',
                    type: 'url',
                    sortable: true,
                    iconName: 'standard:contact',
                    typeAttributes: {
                        label: {
                            fieldName: 'conName'
                        },
                        target: '_self',
                        tooltip: 'Click to visit account'
                    }
                },
                {
                    label: 'Payment on Contact',
                    fieldName: 'conAmount',
                    sortable: false,
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
                        class: {
                            fieldName: 'count'
                        }
                    }
                },
                {
                    label: 'First Name',
                    fieldName: 'conFirstName',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Last Name',
                    fieldName: 'conLastName',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Contact Email',
                    fieldName: 'conEmail',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameEmail'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelEmail'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Phone',
                    fieldName: 'conPhone',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNamePhone'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelPhone'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Last Modified Date',
                    fieldName: 'conLastSync',
                    type: 'date',
                    typeAttributes: {
                        day: 'numeric',
                        month: 'short',
                        year: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit',
                        hour12: false,
                    },
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:date_input',
                        iconPosition: 'left'
                    }
                },
            ]);
            component.set("v.DataColumnsLogs", [{
                    label: 'Contact Name',
                    fieldName: 'HyperUrlContact',
                    type: 'url',
                    sortable: true,
                    iconName: 'standard:contact',
                    typeAttributes: {
                        label: {
                            fieldName: 'accName'
                        },
                        target: '_self',
                        tooltip: 'Click to visit account'
                    }
                },
                {
                    label: 'Balance',
                    fieldName: 'amount',
                    sortable: false,
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
                        class: {
                            fieldName: 'count'
                        }
                    }
                },
                {
                    label: 'First Name',
                    fieldName: 'firstName',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Last Name',
                    fieldName: 'lastName',
                    type: 'text',
                    sortable: true,
                },
                {
                    label: 'Email',
                    fieldName: 'email',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameEmail'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelEmail'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Phone #',
                    fieldName: 'Phone',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNamePhone'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconLabelPhone'
                        },
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Upload Date',
                    fieldName: 'uploadDate',
                    type: 'date',
                    typeAttributes: {
                        day: 'numeric',
                        month: 'short',
                        year: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit',
                        hour12: false,
                    },
                    sortable: true,
                    cellAttributes: {
                        iconName: 'utility:date_input',
                        iconPosition: 'left'
                    }
                },
                {
                    label: 'Upload Status',
                    fieldName: 'status',
                    type: 'text',
                    sortable: true,
                    cellAttributes: {
                        iconName: {
                            fieldName: 'provenanceIconNameUpload'
                        },
                        iconLabel: {
                            fieldName: 'provenanceIconNameUploads'
                        },
                        iconPosition: 'left'
                    }
                },
            ]);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    handleActiveTab: function(component, event, helper) {
        try {
            var tab = event.getSource();
            tab = tab.get('v.id');
            component.set('v.activeTab', tab);
            if (tab == 'log') {
                component.set('v.Spinner', true);
                helper.getUploadLog(component, event);
            } else {
                component.set('v.Spinner', true);
                helper.getContacts(component, event);
            }
            component.set('v.fromDate', null);
            component.set('v.toDate', null);
            component.set('v.disableFindBtn', false);
            component.set('v.disableUploadBtn', true);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    handleSort: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortData(component, sortBy, sortDirection);
    },
    handleSortlogs: function(component, event, helper) {
        var sortBy = event.getParam("fieldName");
        var sortDirection = event.getParam("sortDirection");
        component.set("v.sortBy", sortBy);
        component.set("v.sortDirection", sortDirection);
        helper.sortDataLogs(component, sortBy, sortDirection);
    },
    updateSelectedText: function(cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var dataList = selectedRows.map(function(rowData) {
            return rowData.Id;
        });
        if (dataList.length > 0) {
            cmp.set('v.disableUploadBtn', false);
            cmp.set('v.selectedConIds', dataList);
        } else {
            cmp.set('v.disableUploadBtn', true);
        }
        cmp.set('v.NoOfSelectedRecords', dataList.length);
    },
    validateDate: function(component, event, helper) {
        try {
            var today = new Date();
            var fromDate = component.get('v.fromDate');
            var toDate = component.get('v.toDate');
            if (fromDate != '' && fromDate != null && toDate != null && toDate != '') {
                var fromDate = new Date(fromDate);
                var toDate = new Date(toDate);
                var timeDiffrence = toDate - fromDate;
                if (timeDiffrence <= 0) {
                    component.set('v.disableFindBtn', true);
                    helper.showToast('End date should be greater than Start date!', 'Error');
                } else {
                    component.set('v.disableFindBtn', false);
                }
            } else {
                component.set('v.disableFindBtn', true);
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    FindContact: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.getContacts(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    clearDateRange: function(component, event, helper) {
        try {
            component.set('v.disableFindBtn', false);
            component.set('v.fromDate', null);
            component.set('v.toDate', null);
            component.set('v.Spinner', true);
            helper.getContacts(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    SelectAllAccounts: function(component, event, helper) {
        try {
            var checkvalue = event.getSource().get("v.value");
            component.set('v.isSelectAll', checkvalue);
            var checkAccount = component.find("checkAccount");
            if (checkvalue == true) {
                for (var i = 0; i < checkAccount.length; i++) {
                    checkAccount[i].set("v.value", true);
                }
            } else {
                for (var i = 0; i < checkAccount.length; i++) {
                    checkAccount[i].set("v.value", false);
                }
            }
            var a = component.get('c.SelectSingleAccount');
            $A.enqueueAction(a);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    SelectSingleAccount: function(component, event, helper) {
        try {
            var accountList = component.get('v.ContactList');
            var selectedConIds = [];
            var k = 0;
            for (var i = 0; i < accountList.length; i++) {
                var s = accountList[i];
                if (s.isSelected) {
                    selectedConIds[k] = s.Id;
                    k++;
                }
            }
            component.set('v.NoOfSelectedRecords', k);
            if (selectedConIds.length > 0) {
                component.set('v.disableUploadBtn', false);
                component.set('v.selectedConIds', selectedConIds);
            } else {
                component.set('v.disableUploadBtn', true);
            }
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    uploadContact: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set("v.isOpen", false);
            helper.syncContacts(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    clearLog: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            component.set("v.isOpen", false);
            helper.clearLog(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    openModel: function(component, event, helper) {
        try {
            var whichOne = event.getSource().getLocalId();
            if (whichOne == 'Upload') {
                component.set('v.modalTitle', 'Upload Contacts');
                component.set('v.modalContent', whichOne);
            } else {
                component.set('v.modalTitle', 'Clear Upload Log');
                component.set('v.modalContent', whichOne);
            }
            component.set("v.isOpen", true);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.isOpen", false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
})