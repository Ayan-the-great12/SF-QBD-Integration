({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.getSettings(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
    CheckAllLogs: function(cmp, event, helper) {
        cmp.set('v.Settings.Ebiz_C__EBizcharge_IsLogErrorEnable__c', true);
        cmp.set('v.Settings.Ebiz_C__EBizcharge_IsLogInfoEnable__c', true);
        cmp.set('v.Settings.Ebiz_C__EBizcharge_IsLogWarningEnable__c', true);
        cmp.set('v.Settings.Ebiz_C__EBizcharge_IsLogExceptionEnable__c', true);
    },
    openLogTab: function(component, event, helper) {
        window.open("/lightning/n/Ebiz_C__Logs");
    },
    saveSettingsLogin: function(component, event, helper) {
        helper.saveSettingsNew(component, event, 'Custom Logs');
    },
})