trigger IITTriggerOnQuote on invoiceit_s__Quote__c (before update) {

   IITClassAfterOnQuote  classAfterOnQuoteObj  = new IITClassAfterOnQuote();
   classAfterOnQuoteObj.handleBeforeOnOrder(trigger.new);     
}