({
    getOrders: function(component, event) {
        var AccountID = component.get('v.selectedLookUpAccRecord.Id');
        var OrderId = component.get('v.selectedLookUpOrdRecord.Id');
        var action = component.get("c.getListOfOrdersApxc");
        action.setParams({
            AccountID: AccountID,
            OrderId: OrderId
        });
        action.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var retValue = a.getReturnValue();
                component.set('v.Orders', retValue.accountOrders);
                component.set('v.accountDetail', retValue.accountDetail);
                component.set('v.Spinner', false);
            } else {
                var errors = a.getError();
                component.set('v.Spinner', false);
                this.showToast(errors[0].message + '!', 'Error');
            }
        });
        $A.enqueueAction(action);
    },
    sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.Orders");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a, b) {
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.Orders", records);
        component.set("v.Spinner", false);
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