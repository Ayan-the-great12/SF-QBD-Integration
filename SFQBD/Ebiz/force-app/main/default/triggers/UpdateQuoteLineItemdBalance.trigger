trigger UpdateQuoteLineItemdBalance on QuoteLineItem (after insert,before delete,after delete) {

    string QuoteId = null;
    decimal TotalAmount  = 0;
    DML dml =new DML();
    if(trigger.isAfter && trigger.isInsert ){
        for (QuoteLineItem oldQuoteLineItem : trigger.new){
            QuoteId = oldQuoteLineItem.QuoteId;
        }
        if(!string.isEmpty(QuoteId)){
            UpdateQuoteTriggerHelper.UpdateQuoteAmountOnInsert(dml,QuoteId);
        }
    }
    
    if(trigger.isBefore && trigger.isDelete){
        QuoteLineItem oldQuoteLineItem = trigger.old[0];
        QuoteId = oldQuoteLineItem.QuoteId;
        if(!string.isEmpty(QuoteId)){
            boolean AllowDelete =  UpdateQuoteTriggerHelper.UpdateQuoteAmountOnDelete(dml,QuoteId,oldQuoteLineItem.UnitPrice);
            if(!AllowDelete){
                oldQuoteLineItem.adderror('The product cannot be removed from the quote due to already processed');
            }
        }
    }

}