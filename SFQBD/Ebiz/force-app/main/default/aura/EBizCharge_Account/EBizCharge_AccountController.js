({
    doInit: function(component, event, helper) {
        var rowActions = helper.getRowActions.bind(this, component);
        component.set("v.accountColumns", [{
                label: 'Account',
                fieldName: 'accHyperUrl',
                type: 'url',
                sortable: true,
                iconName: 'standard:account',
                typeAttributes: {
                    label: {
                        fieldName: 'accName'
                    },
                    target: '_self',
                    tooltip: 'Click to visit account'
                }
            },
            {
                label: 'Email',
                fieldName: 'accEmail',
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
                fieldName: 'accPhone',
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
                label: 'Approved Date',
                fieldName: 'Approved_Date',
                type: 'Date',
                sortable: true,
            },
            {
                label: 'Gateway Monthly Fee',
                fieldName: 'Gateway_Monthly_Fee',
                type: 'currency',
            },
            {
                label: 'Amount',
                fieldName: 'accAmount',
                sortable: true,
                type: 'currency',
                typeAttributes: {
                    currencyCode: 'USD'
                }
            },
            {
                label: 'Sync Status',
                fieldName: 'accStatus',
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
        helper.getAccountList(component, event);
        helper.accountRecordData(component, event, helper);
    },
    verifyLookUp: function(component, event, helper) {
        var accountId = component.get('v.selectedLookUpRecord.Id');
        if (!accountId) {
            helper.getAccountList(component, event);
        }
    },
    handleIsOpenToggle: function(component, event, helper) {
        let isOpen = component.get("v.ShowSplash");
        if (isOpen) {
            component.set("v.openClass", 'is-open');
        } else {
            component.set("v.openClass", '');
        }
    },
    handleCompEvent: function(component, event, helper) {
        try {
            var actionName = event.getParam("actionName");
            if (actionName == 'showGrid') {
                var accountId = component.get('v.selectedLookUpRecord.Id');
                var originallist = component.get("v.allAccounts");
                var collection_lookup = []
                if (!$A.util.isEmpty(accountId)) {
                    for (var o in originallist) {
                        if (originallist[o].accId == accountId) {
                            collection_lookup[0] = originallist[o];
                            component.set("v.allAccounts", collection_lookup);
                            return null;
                        }
                    }
                    component.set("v.accountList", component.get("v.allAccounts"));
                } else {}
            } else {
                var originallist = component.get("v.allAccounts");
                component.set("v.accountList", originallist);
            }
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    CreateNewAccount: function(component, event, helper) {
        var recordTypeChecker = component.get("v.RecordTypeOption");
        if(recordTypeChecker.length > 0){
            component.set('v.showAccModal', true);
        }else{
            component.set('v.AccountRecordSave',true);
        }  
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
    searchTable: function (cmp, event, helper) {
        var allRecords = cmp.get("v.allData");
        var searchFilter = event.getSource().get("v.value").toUpperCase();
        var tempArray =[];
        var i;
        for(i=0; i<allRecords.length; i++){
            if((allRecords[i].Approved_Date && allRecords[i].Approved_Date.toUpperCase().indexOf(searchFilter) != -1)){
                tempArray.push(allRecords[i]);
            }
        }
        cmp.set("v.allAccounts",tempArray);
    },
    AccountRecordSave: function (component, event, helper){
        component.set('v.AccountRecordSave',true);
        component.set('v.showAccModal',false);
    },
    TransHandler : function(component, event, helper) {
        component.set("v.Checker",false);  
    },
    closeModel  : function (component, event, helper){
        component.set('v.showAccModal',false);
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
                helper.handleSelectAction(action.name + '#' + row.accId, cmp, event, helper);
                break;
            case 'takepayment':
                helper.handleSelectAction(action.name + '#' + row.accId, cmp, event, helper);
                break;
            case 'requestpayment':
                helper.handleSelectAction(action.name + '#' + row.accId, cmp, event, helper);
                break;
        }
    },
    updateSelectedText: function(cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var data = []
        selectedRows.map(function(rowData) {
            data.push(rowData);
        });
        if (selectedRows.length > 0) {
            cmp.set('v.disableSyncBtn', false);
            cmp.set('v.SelectedRecords', selectedRows);
        } else {
            cmp.set('v.disableSyncBtn', true);
        }
        cmp.set('v.selectedRowsCount', selectedRows.length);
    }
})