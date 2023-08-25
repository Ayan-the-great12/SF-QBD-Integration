({
    doInit: function(component, event, helper) {
        try {
            component.set('v.Spinner', true);
            helper.getSettings(component, event);
        } catch (e) {
            helper.showToast('Please refresh the page and try again!toast', 'Error');
        }
    },
    onRadio: function(cmp, event, helper) {
        cmp.find("month").set("v.disabled");
        cmp.find("daily").set("v.disabled");
        cmp.find("biMonth").set("v.disabled");
        cmp.find("week").set("v.disabled");
        cmp.find("quarter").set("v.disabled");
        cmp.find("biweek").set("v.disabled");
        cmp.find("annual").set("v.disabled");
        cmp.find("fourW").set("v.disabled");
        cmp.find("biAnnu").set("v.disabled");
        var cs = cmp.get('v.Settings');
        cs.Ebiz_C__Enable_all_frequencies__c = false;
        cmp.set('v.Settings', cs);
    },
    onRadiounlock: function(cmp, event, helper) {
        cmp.find("month").set("v.disabled", 'false');
        cmp.find("daily").set("v.disabled", 'false');
        cmp.find("biMonth").set("v.disabled", 'false');
        cmp.find("week").set("v.disabled", 'false');
        cmp.find("quarter").set("v.disabled", 'false');
        cmp.find("biweek").set("v.disabled", 'false');
        cmp.find("annual").set("v.disabled", 'false');
        cmp.find("fourW").set("v.disabled", 'false');
        cmp.find("biAnnu").set("v.disabled", 'false');
        var cs = cmp.get('v.Settings');
        cs.Ebiz_C__Disable_all_frequencies__c = false;
        cmp.set('v.Settings.Ebiz_C__AutoPay_monthly__c', true);
        cmp.set('v.Settings.Ebiz_C__AutoPay_daily__c', true);
        cmp.set('v.Settings.Ebiz_C__AutoPay_bi_monthly__c', true);
        cmp.set('v.Settings.Ebiz_C__AutoPay_weekly__c', true);
        cmp.set('v.Settings.Ebiz_C__AutoPay_quarterly__c', true);
        cmp.set('v.Settings.Ebiz_C__AutoPay_bi_weekly__c', true);
        cmp.set('v.Settings.Ebiz_C__AutoPay_annually__c', true);
        cmp.set('v.Settings.Ebiz_C__AutoPay_four_week__c', true);
        cmp.set('v.Settings.Ebiz_C__AutoPay_bi_annually__c', true);
        cmp.set('v.Settings', cs);
    },
    saveSettingsAutopay: function(component, event, helper) {
        try {
            helper.saveSettingsNew(component, event, 'Recurring Payments ');
        } catch (e) {
            helper.showToast('Please refresh the page and try again!', 'Error');
        }
    },
})