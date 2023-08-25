({
    getSettings: function(component, event) {
        var action = component.get("c.getSettingsApxc");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.Settings', response.getReturnValue());
                var cs = response.getReturnValue();
                if ($A.util.isEmpty(cs.Ebiz_C__Security_Token__c)) {
                    component.set('v.ShowWarn', true);
                } else {
                    component.set('v.ShowWarn', false);
                }
                if (cs.Ebiz_C__Tax_Action__c == 'Tax Included') {
                    var str = 'Tax(' + cs.Ebiz_C__Tax_Default_Percent__c + '%)';
                    component.set('v.TaxTitle', str);
                } else {
                    if (cs.Ebiz_C__Tax_Calculate_By__c == 'Auto') {
                        var str = 'Tax(' + cs.Ebiz_C__Tax_Default_Percent__c + '%)';
                        component.set('v.TaxTitle', str);
                    } else {
                        if (cs.Ebiz_C__Tax_Manual_Type__c == 'Use Percent') {
                            var str = 'Tax(%value)';
                            component.set('v.TaxTitle', str);
                        } else {
                            var str = 'Tax($amount)';
                            component.set('v.TaxTitle', str);
                        }
                    }
                }
            }
            component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },
    showToast: function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: type + '!',
            message: message,
            duration: ' 5000',
            key: type + '_alt',
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
})