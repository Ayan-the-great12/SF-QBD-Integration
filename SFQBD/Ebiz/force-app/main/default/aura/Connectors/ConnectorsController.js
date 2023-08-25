({
    doInit : function(component, event, helper)
    {
        try
        {   
            var options =  [
                {'label': 'Orders/Opp/Quotes', 'value': 'Orders/Opp/Quotes'},
                {'label': 'Customers', 'value': 'Customers'},
                {'label': 'Items', 'value': 'Items'}
                ];
            component.set("v.EntityOptions",options);
            helper.fetchData(component);
            component.set("v.DataColumnsDynamic", [
            {
                label: 'Saleforce Field',
                fieldName: 'Ebiz_C__SaLId__c',
                type: 'text',
                sortable: true,  
            },
            {
                label: 'Direction',
                fieldName: 'Ebiz_C__Flow__c',
                type:'text',
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
            {   label:'Microsoft Dynamic AX 2012 Field',
                fieldName: 'Ebiz_C__ExtId__c',
                type: 'text',
                sortable: true,
            }, 
        ]);
        component.set("v.DataColumnsDesktop", [
            {
                label: 'Saleforce Field',
                fieldName: 'Ebiz_C__SaLId__c',
                type: 'text',
                sortable: true,  
            },
            {
                label: 'Direction',
                fieldName: 'Ebiz_C__Flow__c',
                type:'text',
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
            {   label:'QuickBooks Desktop Field',
                fieldName: 'Ebiz_C__ExtId__c',
                type: 'text',
                sortable: true,
            }, 
        ]);
        component.set("v.DataColumnsEpicor", [
            {
                label: 'Saleforce Field',
                fieldName: 'Ebiz_C__SaLId__c',
                type: 'text',
                sortable: true,  
            },
            {
                label: 'Direction',
                fieldName: 'Ebiz_C__Flow__c',
                type:'text',
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
            {   label:'Epicor Field',
                fieldName: 'Ebiz_C__ExtId__c',
                type: 'text',
                sortable: true,
            }, 
        ]);
        component.set("v.DataColumnsOnline", [
            {
                label: 'Saleforce Field',
                fieldName: 'Ebiz_C__SaLId__c',
                type: 'text',
                sortable: true,  
            },
            {
                label: 'Direction',
                fieldName: 'Ebiz_C__Flow__c',
                type:'text',
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
            {   label:'QuickBooks Online Field',
                fieldName: 'Ebiz_C__ExtId__c',
                type: 'text',
                sortable: true,
            }, 
        ]);   
        }
        catch (e) 
        {
            helper.showToast('Please refresh the page and try again!','Error');
        }
    },
    addRow : function (cmp, event, helper) 
    {
        var myData = cmp.get("v.tableData"); 
       myData.push(
        {
            SalesforceId: "",
            FlowDirection: "",
            EpicorId: ""
         }
    );
    cmp.set("v.tableData", myData);  
    },
    addNewModel : function (cmp, event, helper) {
        cmp.set("v.OpenInputModel",true)
    },
    handleSaveEdition: function (cmp, event, helper) {
   var draftValues = event.getParam('draftValues');
   var action = cmp.get("c.updateData");
   action.setParams({
       "upd":draftValues
   });
   action.setCallback(this, function(response) 
   {
       var state = response.getState();
       if (state === "SUCCESS") 
       {  cmp.set('v.draftValues',[]);
       helper.fetchData(component, event);
        $A.get('e.force:refreshView').fire();
       }
   });
   $A.enqueueAction(action);
    },
    PreviewModel : function(component, event, helper)
    {
        try
        {
            component.set("v.isOpen", true);
        }
        catch (e) 
        {
            helper.showToast('Please refresh the page and try again!','Error');
        }
    },
    closeModel: function(component, event, helper) {
        try{
            component.set("v.viewPicklistModel", false);
            component.set("v.isOpen", false);
            component.set("v.OpenInputModel", false);
        }catch (e) {
            helper.showToastMsg('Please refresh the page and try again!','Error');
        }
    },
    TransHandler : function(component, event, helper) {
        component.set("v.Checker",false);  
    },
    handleRowAction: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'editRecord':
                cmp.set("v.viewPicklistModel",true);
                break;
            case 'action2':
                helper.handleAction2(cmp, row, action);
                break;
        }
    },
    SuccessHandler: function(component, event, helper) {
       
        var CustomDecisionObject = component.get("v.newConnection");
        helper.NewTableQueryData(component,CustomDecisionObject);
        component.set("v.isOpen", false);
        var data= component.find("applicationid").get("v.value");
        component.set("v.viewTable", true);
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: 'The Saleforce & '+data+' Connection has been successfully created.',
            duration:' 3000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        var data = []
       if(selectedRows.length > 0){
        selectedRows.map(function(rowData) {
            data.push(rowData);
        });
        cmp.set('v.SelectedRecords',selectedRows);
    }
      cmp.set('v.selectedRowsCount', selectedRows.length);
    },
    onCheck: function(cmp, evt) {
        var data=cmp.get("v.test");
        cmp.set("v.test",data);
        cmp.set("v.test1",data);
    },
    MultipleDropdown: function(cmp, evt) {
      cmp.set("v.DropDownBool",true);
    },
    ComboChange :function(cmp, evt)
    {
        var data = cmp.find("ComboId").get("v.value");
        cmp.set("v.ComboChangeValue",data);
    },
    saveData :function(component, evt){
        component.set("v.viewPicklistModel", false);
        component.set("v.isOpen", false);
    },
    validateNewInputForm : function(component, event, helper) {
        
        var allValid = component.find('req-fieldsrr').reduce(function (validSoFar, inputCmp) {    
            return validSoFar && !inputCmp.get('v.validity').valueMissing;
        }, true);
        if(allValid)
        {
            component.set("v.requiredChecker",false);
        }
    },
    SavingInputsData :function(component, evt,helper)
    {  
        var updateList ={};
        var SalId= component.get("v.SalId");
        var ExtId = component.get("v.ExtId");
        var Flow = component.get("v.IconVal");
        var UpdData= component.get("v.newConnection");
        var entityVal= component.get("v.entityValue");
        updateList.SalId=SalId;
        updateList.ExtId=ExtId;
        updateList.Flow=Flow;
        updateList.UpdData=UpdData;
        updateList.entityVal=entityVal;
      
        helper.Updation(component, evt,updateList);
        component.set("v.OpenInputModel", false);

    },
    handleSelect: function (cmp, event,helper) {
        var selectedMenuItemValue = event.getParam("value");
        var menuItems = cmp.find("menuItems");
        menuItems.forEach(function (menuItem) {
            if (menuItem.get("v.checked")) {
                menuItem.set("v.checked", false);
            }
            if (menuItem.get("v.value") === selectedMenuItemValue) {
                cmp.set("v.IconVal",menuItem.get("v.value"));
                menuItem.set("v.checked", true);
            }
        });
    },
    saveSettingsDisplay : function (cmp, event,helper){
        var tableData= cmp.get("v.DesktopTableData");
        var CustomDecisionObject = cmp.get("v.newConnection");
        helper.AddApplicationData(cmp, event,tableData,CustomDecisionObject);
    },
})