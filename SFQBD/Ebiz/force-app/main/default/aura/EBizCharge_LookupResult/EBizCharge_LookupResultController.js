({
    selectRecord: function(component, event, helper) {
        try {
            var getSelectRecord = component.get("v.oRecord");
            var getSelectedRecordId = component.get("v.oRecord.Id");
            var compEvent = component.getEvent("oSelectedRecordEvent");
            compEvent.setParams({
                "recordByEvent": getSelectRecord
            });
            compEvent.fire();
            var objName = component.get('v.objectAPIName');
            var e = component.getEvent("callParentCmpMethod");
            e.setParam("actionName", 'showGrid');
            e.setParam("objectName", objName);
            e.fire();
        } catch (e) {
            helper.showToastMsg('Please refresh the page and try again!', 'Error');
        }
    },
})