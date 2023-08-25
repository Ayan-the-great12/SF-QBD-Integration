({
    doInit: function(component, event, helper) {
        component.set('v.columns', [{
                label: 'Class Name',
                fieldName: 'Ebiz_C__EBizCharge_Class_Name__c',
                sortable: true,
                type: 'text'
            },
            {
                label: 'Method Name',
                fieldName: 'Ebiz_C__EBizCharge_Method_Name__c',
                sortable: true,
                type: 'text'
            },
            {
                label: 'Message',
                fieldName: 'Ebiz_C__EBizCharge_Message__c',
                sortable: true,
                type: 'text'
            },
            {
                label: 'Logs Level',
                fieldName: 'Ebiz_C__EBizCharge_Log_Level__c',
                sortable: true,
                type: 'text'
            },
            {
                fieldName: 'Ebiz_C__EBizCharge_Message__c',
                type: 'button-icon',
                typeAttributes: {
                    iconName: 'action:preview',
                    label: 'Edit',
                    name: 'ViewLog',
                    title: 'View',
                    disabled: false,
                    value: 'test'
                }
            },
        ]);
        const options = [{
                'Id': 1,
                'Name': 'ERROR'
            },
            {
                'Id': 2,
                'Name': 'WARNING'
            },
            {
                'Id': 3,
                'Name': 'EXCEPTION'
            },
            {
                'Id': 4,
                'Name': 'INFO'
            },
        ];
        component.set("v.options", options);
        helper.getAccounts(component, helper);
    },
    handleRowAction: function(cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'ViewLog':
                cmp.set("v.viewPicklistModel", true);
                cmp.set("v.ViewLogsMessage", row.Ebiz_C__EBizCharge_Message__c);
                break;
        }
    },
    closeModel: function(component, event, helper) {
        try {
            component.set("v.viewPicklistModel", false);
            component.set("v.isOpen", false);
            component.set("v.OpenInputModel", false);
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
    updateSorting: function(cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    searchTable: function(cmp, event, helper) {
        var allRecords = cmp.get("v.allData");
        var searchFilter = event.getSource().get("v.value").toUpperCase();
        var tempArray = [];
        var i;
        for (i = 0; i < allRecords.length; i++) {
            if ((allRecords[i].Ebiz_C__EBizCharge_Message__c && allRecords[i].Ebiz_C__EBizCharge_Message__c.toUpperCase().indexOf(searchFilter) != -1) ||
                (allRecords[i].Ebiz_C__EBizCharge_Log_Level__c && allRecords[i].Ebiz_C__EBizCharge_Log_Level__c.toUpperCase().indexOf(searchFilter) != -1)) {
                tempArray.push(allRecords[i]);
            }
        }
        cmp.set("v.recordList", tempArray);
    },
    toggleOptionalTab: function(cmp) {
        cmp.set('v.isFourVisible', !cmp.get('v.isFourVisible'));
    },
    deleteTableRow: function(component, row) {
        var action = component.get("c.deletePoster");
        action.setParams({
            "toDelete": row
        });
        $A.enqueueAction(action);
        component.refreshDataTable();
    },
    refreshDataTable: function(component, event, helper) {
        var refreshAction = component.get("c.fetchLogs");
        refreshAction.setCallback(this, function(data) {
            component.set("v.recordList", data.getReturnValue());
        });
        $A.enqueueAction(refreshAction);
    },
    storeSelectedRows: function(component, event, helper) {
        var selectedRows = event.getParam("selectedRows");
        component.set("v.selectedRows", selectedRows);
    },
    deleteData: function(component, event, helper) {
        var action = component.get("c.RemoveLogs");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                toastEvent.setParams({
                    "title": "Delete!",
                    "message": "Logs were succesfully deleted.",
                    "type": "other",
                    "key": "delete"
                });
                toastEvent.fire();
            }
        });
        window.location.reload(true);
        $A.enqueueAction(action);
    },
    onRender: function(component, event, helper) {
        if (!component.get("v.initializationCompleted")) {
            component.getElement().addEventListener("click", function(event) {
                helper.handleClick(component, event, 'component');
            });
            component.set("v.initializationCompleted", true);
            helper.setPickListName(component, component.get("v.selectedOptions"));
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
});