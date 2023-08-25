({
    getEntitydata : function (cmp)
    {
        var action = cmp.get("c.getData");
        action.setCallback(this, function(response) 
        {
            var state = response.getState();
            if (state == "SUCCESS") 
            {}
        });
        $A.enqueueAction(action);
    },
    fetchData : function (cmp) 
    {   
        var dynamicList=[];
        var epicorList=[];
        var desktopList=[];
        var onlineList=[];
        var entityList=[];
        let dummyList=[];
      this.getEntitydata(cmp);
        var action = cmp.get("c.getTableDataApx");
        action.setCallback(this, function(response) 
        {
            var state = response.getState();
            if (state == "SUCCESS") 
             { 
                var data = response.getReturnValue();
                cmp.set('v.DesktopTableData',data);
                for(var i=0;i<data.length;i++)
                {   
                    if(data[i].Ebiz_C__Entity__c=='Orders/Opp/Quotes' || data[i].Ebiz_C__Entity__c=='Customers' || data[i].Ebiz_C__Entity__c=='Items')
                    { 
                      entityList.push(data[i].Ebiz_C__Entity__c);
                    }
                } 
               
                 var options = cmp.get("v.EntityOptions");
                 if(entityList!=null){
                    for(var k=0;k<options.length;k++)
                    {
                        if(!entityList.includes(options[k].value)){
                            dummyList.push(
                                           {'label': options[k].value, 'value': options[k].value }
                            );
                        }
                    }
                 }
                 cmp.set("v.EntityOptions",dummyList);
                var dataList = data.map(function (rowData) 
                {     
                    if (rowData.Ebiz_C__Flow__c == 'Bi Directional SF/Md' || rowData.Ebiz_C__Flow__c == 'Bi Directional SF/Ep' || rowData.Ebiz_C__Flow__c == 'Bi Directional SF/Qd' || rowData.Ebiz_C__Flow__c == 'Bi Directional SF/QO' ) {
                        rowData.provenanceIconNameResult = 'utility:rotate';
                       
                    }
                    else if(rowData.Ebiz_C__Flow__c == 'Salesforce to Microsoft Dynamic AX 2012' || rowData.Ebiz_C__Flow__c == 'Salesforce to Epicor' || rowData.Ebiz_C__Flow__c == 'Salesforce to QuickBooks Desktop'|| rowData.Ebiz_C__Flow__c == 'Salesforce to QuickBooks Online') 
                    {
                        rowData.provenanceIconNameResult = 'utility:forward'; 
                    }
                    else if(rowData.Ebiz_C__Flow__c == 'Microsoft Dynamic AX 2012 to Salesforce' || rowData.Ebiz_C__Flow__c == 'Epicor to Salesforce' || rowData.Ebiz_C__Flow__c == 'QuickBooks Desktop to Salesforce'|| rowData.Ebiz_C__Flow__c == 'QuickBooks Online to Salesforce')
                    {
                        rowData.provenanceIconNameResult = 'utility:back';
                    }
                    return rowData;    
                });
            }
        });
        $A.enqueueAction(action);
    },
   
    Updation : function (cmp,event,updateList) 
    {   
        var action = cmp.get("c.UpdateDataApxc");
        action.setParams({
            newData:JSON.stringify(updateList)
        });
        action.setCallback(this, function(response) 
        {
            var state = response.getState();
            if (state == "SUCCESS") 
            {   
                this.fetchData(cmp);
            }
        });
        $A.enqueueAction(action);
    },
    NewTableQueryData : function(cmp, CustomDecisionObject) {
        if(CustomDecisionObject=='Microsoft Dynamic AX 2012')
        {   
            var action = cmp.get("c.CustomObjectDynamicsApxc");
            action.setCallback(this, function(response) 
            {
                var state = response.getState();
                if (state === "SUCCESS") 
                {   
                    var iconName="";
                    var data = response.getReturnValue();
                    cmp.set('v.DynamicsTableData',data);
                    cmp.set('v.classNameEpicor',"slds-hide");
                    cmp.set('v.classNameDynamic',"");
                    cmp.set('v.classNameDesktop',"slds-hide");
                    cmp.set('v.classNameOnline',"slds-hide");

                    var dataList = data.map(function (rowData) 
                    {     
                        
                        if (rowData.Ebiz_C__Flow__c == 'Bi Directional SF/Md' || rowData.Ebiz_C__Flow__c == 'Bi Directional SF/Ep' || rowData.Ebiz_C__Flow__c == 'Bi Directional SF/Qd' || rowData.Ebiz_C__Flow__c == 'Bi Directional SF/QO' ) {
                            rowData.provenanceIconNameResult = 'utility:rotate';
                           
                        }
                        else if(rowData.Ebiz_C__Flow__c == 'Salesforce to Microsoft Dynamic AX 2012' || rowData.Ebiz_C__Flow__c == 'Salesforce to Epicor' || rowData.Ebiz_C__Flow__c == 'Salesforce to QuickBooks Desktop'|| rowData.Ebiz_C__Flow__c == 'Salesforce to QuickBooks Online') 
                        {
                            rowData.provenanceIconNameResult = 'utility:forward'; 
                        }
                        else if(rowData.Ebiz_C__Flow__c == 'Microsoft Dynamic AX 2012 to Salesforce' || rowData.Ebiz_C__Flow__c == 'Epicor to Salesforce' || rowData.Ebiz_C__Flow__c == 'QuickBooks Desktop to Salesforce'|| rowData.Ebiz_C__Flow__c == 'QuickBooks Online to Salesforce')
                        {   
                            rowData.provenanceIconNameResult = 'utility:back';
                        }
                        return rowData;
                            
                    });
                }
            });
        }
        else if(CustomDecisionObject=='Epicor')
         {
            var action = cmp.get("c.CustomObjectEpicorApxc");
            action.setCallback(this, function(response) 
            {
                var state = response.getState();
                if (state === "SUCCESS") 
                {   
                     var data = response.getReturnValue();
                     cmp.set('v.EpicorTableData',data);
                     cmp.set('v.classNameEpicor',"");
                     cmp.set('v.classNameDynamic',"slds-hide");
                     cmp.set('v.classNameDesktop',"slds-hide");
                     cmp.set('v.classNameOnline',"slds-hide");
                }
            });
         }
         else if(CustomDecisionObject=='QuickBooks Desktop')
         {  
            var action = cmp.get("c.CustomObjectDesktopApxc");
            action.setCallback(this, function(response) 
            {
                var state = response.getState();
                if (state === "SUCCESS") 
                {   
                    var data = response.getReturnValue();
                    cmp.set('v.DesktopTableData',data);
                    cmp.set('v.classNameEpicor',"slds-hide");
                    cmp.set('v.classNameDynamic',"slds-hide");
                    cmp.set('v.classNameDesktop',"");
                    cmp.set('v.classNameOnline',"slds-hide");
                } 
            });
         }
         else if(CustomDecisionObject=='QuickBooks Online')
         {
            var action = cmp.get("c.CustomObjectOnlineApxc");
           
            action.setCallback(this, function(response) 
            {
                var state = response.getState();
                if (state === "SUCCESS") 
                {   
                    var data = response.getReturnValue();
                    cmp.set('v.OnlineTableData',data);
                    cmp.set('v.classNameEpicor',"slds-hide");
                    cmp.set('v.classNameDynamic',"slds-hide");
                    cmp.set('v.classNameDesktop',"slds-hide");
                    cmp.set('v.classNameOnline',"");
                }
            });
         }
        $A.enqueueAction(action);
    },
    AddApplicationData : function (cmp,event,tableData,CustomDecisionObject)
    {   
        var action = cmp.get("c.SaveDataToPortalApxc");
        action.setParams({
        "data":JSON.stringify(tableData),
        "ObjectName":CustomDecisionObject
        });
        action.setCallback(this, function(response) 
        {
            var state = response.getState();
            if (state === "SUCCESS") 
            {   
                var data = response.getReturnValue();
            }
        });
        $A.enqueueAction(action);
    }

})