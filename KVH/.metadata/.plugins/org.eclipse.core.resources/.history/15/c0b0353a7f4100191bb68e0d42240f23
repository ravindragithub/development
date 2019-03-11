/* ************************************************************
 * Created By  : Gopi Kishore
 * Created Date: 27/03/2015
 * Description : Trigger Used to implement following functionlality.
                 1) If invoice order update it will validate related Product job Name contains "VOD".If Yes trigger creates new Case Record. 
 *               2) If invoice order update it will validate related case contains "New VOD Order" case symtom.If Yes trigger it wont create new Case Record. 
                 3) If invoice order create,update,delete it will create rollup count on Account - Active_Orders__c field.if order - invoiceit_s__Status__c!=:'Completed/Cancelled' 
                 4) If invoice order status="Ready for Fullfilment" while update it will validate related Product job Name contains "webFTA or webFAS".If Yes trigger creates new Task Record.
                 
                 25/03/2015 Task : https://kvhdev.atlassian.net/browse/JKTDEV-11
                 5) If invoice order creates/updates need to create commision Dealer Record. 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/

trigger OrderInvoiceITTrigger on invoiceit_s__Job__c (after update,after insert,after delete){
    if(Trigger.isUpdate){
        OrderInvoiceITTriggerClass.ExecuteUpdateEvents(Trigger.new,Trigger.newMap,Trigger.oldMap);
    }
    
     
    if((Trigger.isInsert || Trigger.isUpdate)){
        OrderInvoiceITTriggerClass.orderShippingAccountCount(Trigger.New);    
    }
    
    if(trigger.isInsert  &&  OrderInvoiceITTriggerClass.dontRunAgain){
        OrderInvoiceITTriggerClass.dontRunAgain = false;
        OrderInvoiceITTriggerClass.CloneOrderCommisions(Trigger.New);
    }
    
    if(Trigger.isDelete &&  OrderInvoiceITTriggerClass.dontRunAgain){
        OrderInvoiceITTriggerClass.dontRunAgain = false;
        OrderInvoiceITTriggerClass.orderShippingAccountCount(Trigger.Old);
    }
}