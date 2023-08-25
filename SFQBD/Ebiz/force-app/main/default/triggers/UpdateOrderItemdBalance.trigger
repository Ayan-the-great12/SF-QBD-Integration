trigger UpdateOrderItemdBalance on OrderItem  (after insert,before delete,after delete) {
    
    
    string OrderId = null;
    decimal TotalAmount  = 0;
    DML dml =new DML();
    if(trigger.isAfter && trigger.isInsert ){
        for (OrderItem oldOrderItem : trigger.new){
            OrderId = oldOrderItem.OrderId;
        }
        if(!string.isEmpty(OrderId)){
            
            UpdateOrderTriggerHelper.UpdateOrderAmountOnInsert(dml,OrderId);
        }
    }
    
    if(trigger.isBefore && trigger.isDelete){
        OrderItem oldOrderItem = trigger.old[0];
        OrderId = oldOrderItem.OrderId;
        if(!string.isEmpty(OrderId)){
            boolean AllowDelete =  UpdateOrderTriggerHelper.UpdateOrderAmountOnDelete(dml,OrderId,oldOrderItem.UnitPrice);
            if(!AllowDelete){
                oldOrderItem.adderror('The product cannot be removed from the order due to already processed');
            }
        }
    }
    
    
    
}