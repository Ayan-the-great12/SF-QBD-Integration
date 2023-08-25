({
    doInit: function(component, event, helper) {
        var rowActions = helper.getRowActions.bind(this, component);
        component.set("v.ContactColumns", [{
                label: 'Contact',
                fieldName: 'conHyperUrl',
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
                label: 'First Name',
                fieldName: 'conFirstName',
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
                label: 'Last Name',
                fieldName: 'conLastName',
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
                label: 'Email',
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
                label: 'Phone#',
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
                label: 'Amount',
                fieldName: 'conAmount',
                sortable: true,
                type: 'currency',
                typeAttributes: {
                    currencyCode: 'USD'
                },
                cellAttributes: {
                    iconName: {
                        fieldName: 'provenanceIconAmount'
                    },
                    iconLabel: {
                        fieldName: 'provenanceIconAmountLabel'
                    },
                    iconPosition: 'left'
                }
            },
            {
                label: 'Sync Status',
                fieldName: 'conStatus',
                type: 'text',
                sortable: true,
                cellAttributes: {
                    iconName: {
                        fieldName: 'provenanceIconNameSync'
                    },
                    iconLabel: {
                        fieldName: 'provenanceIconLabelSync'
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
        component.set("v.Spinner", true);
        helper.getSettings(component);
        helper.getContactList(component, event);
    },
    verifyLookUp: function(component, event, helper) {
        var accountId = component.get('v.selectedLookUpRecord.Id');
        if (!accountId) {
            component.set("v.Spinner", true);
            helper.getContactList(component, event);
        }
    },
    handleCompEvent: function(component, event, helper) {
        try {
            var actionName = event.getParam("actionName");
            if (actionName == 'showGrid') {
                var accountId = component.get('v.selectedLookUpRecord.Id');
                var originallist = component.get("v.allContacts");
                var collection_lookup = []
                if (!$A.util.isEmpty(accountId)) {
                    for (var o in originallist) {
                        if (originallist[o].conId == accountId) {
                            collection_lookup[0] = originallist[o];
                            component.set("v.allContacts", collection_lookup);
                            return null;
                        }
                    }
                    component.set("v.contactList", component.get("v.allContacts"));
                } else {}
            } else {
                var originallist = component.get("v.allContacts");
                component.set("v.allContacts", originallist);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    CreateNewContact: function(component, event, helper) {
        component.set('v.showAccModal', true);
    },
    SyncAccounts: function(component, event, helper) {
        try {
            var cs = component.get('v.Settings');
            if ($A.util.isUndefinedOrNull(cs.Ebiz_C__Security_Token__c)) {
                helper.showToastMsg('Please get a security token from the publisher', 'Warning');
                return;
            }
            component.set("v.Spinner", true);
            helper.SyncSelectedAccounts(component, event);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
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
    sortByAccountName: function(cmp, event, helper) {
        try {
            helper.sortBy(cmp, "accName");
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    sortByFirstName: function(cmp, event, helper) {
        try {
            helper.sortBy(cmp, "accFirstName");
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    sortByAmount: function(cmp, event, helper) {
        try {
            helper.sortBy(cmp, "accAmount");
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    sortByLastName: function(cmp, event, helper) {
        try {
            helper.sortBy(cmp, "accLastName");
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    sortByEmail: function(cmp, event, helper) {
        try {
            helper.sortBy(cmp, "accEmail");
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    sortByPhone: function(cmp, event, helper) {
        try {
            helper.sortBy(cmp, "accPhone");
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    sortByStatus: function(cmp, event, helper) {
        try {
            helper.sortBy(cmp, "accStatus");
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    handleRowAction: function(cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'editAccount':
                helper.handleSelectAction(action.name + '#' + row.conId, cmp, event, helper);
                break;
            case 'takepayment':
                helper.handleSelectAction(action.name + '#' + row.conId, cmp, event, helper);
                break;
            case 'requestpayment':
                helper.handleSelectAction(action.name + '#' + row.conId, cmp, event, helper);
                break;
        }
    },
    updateSelectedText: function(cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var dataList = selectedRows.map(function(rowData) {
            return rowData;
        });
        if (selectedRows.length > 0) {
            cmp.set('v.disableSyncBtn', false);
            cmp.set('v.contactList', selectedRows);
        } else {
            cmp.set('v.disableSyncBtn', true);
        }
        cmp.set('v.selectedRowsCount', selectedRows.length);
    }
})