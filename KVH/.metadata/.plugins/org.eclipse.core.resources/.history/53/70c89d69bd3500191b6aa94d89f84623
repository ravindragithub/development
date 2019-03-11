/* ************************************************************
 * Created By  : Gopi Kishore
 * Created Date: 27/03/2015 
 * Description : OrderInvoiceITTriggerClass Used to implement following functionlality from OrderInvoiceITTrigger trigger.
                 1) If invoice order update it will validate related Product job Name contains "VOD".If Yes trigger creates new Case Record. 
 *               2) If invoice order update it will validate related case contains "New VOD Order" case symtom.If Yes trigger it wont create new Case Record. 
                 3) If invoice order create,update,delete it will create rollup count on Account - Active_Orders__c field.if order - invoiceit_s__Status__c!=:'Completed/Cancelled' 
                 4) If invoice order status="Ready for Fullfilment" while update it will validate related Product job Name contains "webFTA or webFAS".If Yes trigger creates new Task Record. 
                 
                 25/03/2015 Task : https://kvhdev.atlassian.net/browse/JKTDEV-11
                 5) If invoice order updates need to create commision Dealer Record.
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/


Public Class OrderInvoiceITTriggerClass{
    /*
    1) If invoice order update it will validate related Product job Name contains "VOD".If Yes trigger creates new Case Record               
    2) If invoice order update it will validate related case contains "New VOD Order" case symtom.If Yes trigger it wont create new Case Record. 
    */
    Public Static Boolean dontRunAgain = true;
   
    Public static void ExecuteUpdateEvents(List<invoiceit_s__Job__c> invoiceOrderJob,Map<ID,invoiceit_s__Job__c> newInvoiceJobs,Map<ID,invoiceit_s__Job__c> oldInvoiceJobs){
        
        Set<ID> vodOrderProducts         = New Set<ID>();
        Set<ID> caseVODOrder             = new Set<ID>();
        Set<ID> webOrderProducts         = New Set<ID>();
      
        //following variable used for creating Commision Dealer
        Map<ID,List<ID>> invoicejobsITProducts = New Map<ID,List<ID>>();
        
        List<invoiceit_s__Job_Product__c> invoiceITOrderProduct = [SELECT ID,NAME,invoiceit_s__Job__c,invoiceit_s__Product__c FROM invoiceit_s__Job_Product__c WHERE invoiceit_s__Job__c=:newInvoiceJobs.keySet()];
        for(invoiceit_s__Job_Product__c validateVODName:invoiceITOrderProduct){
            String Orderstatus = validateVODName.Name;
            if(Orderstatus.contains('VOD')){
                vodOrderProducts.add(validateVODName.invoiceit_s__Job__c);
            }
            if(Orderstatus.contains('webFTA') || Orderstatus.contains('webFSA')){
                webOrderProducts.add(validateVODName.invoiceit_s__Job__c);
            }
            //Commision Delear Requirement
            if(invoicejobsITProducts.containsKey(validateVODName.invoiceit_s__Job__c)) {
                list<Id> ItProductsIds = invoicejobsITProducts.get(validateVODName.invoiceit_s__Job__c);
                ItProductsIds.add(validateVODName.invoiceit_s__Product__c);
                invoicejobsITProducts.put(validateVODName.invoiceit_s__Job__c, ItProductsIds);
            } else {
                invoicejobsITProducts.put(validateVODName.invoiceit_s__Job__c, new list<Id> { validateVODName.invoiceit_s__Product__c});
            }
        }
        
        LIST<Case> findVODservice = [SELECT id,InvoiceIT_Order__c FROM CASE WHERE (InvoiceIT_Order__c=:vodOrderProducts AND Case_Symptom__c =:'New VOD Order')];
        for(Case validateVod:findVODservice){
            caseVODOrder.add(validateVod.InvoiceIT_Order__c);
        }
        
        List<Case> vodCases = New List<Case>();
        List<Task> taskCreation = New List<Task>();

        //CustomSetting values to pull QueueID
        Map<string,DefaultQueues__c> defaultQueues = DefaultQueues__c.getAll(); 
        List<Messaging.SingleEmailMessage> caseEmails = New List<Messaging.SingleEmailMessage>();
        for(invoiceit_s__Job__c iotJob:invoiceOrderJob){
            if(iotJob.invoiceit_s__Status__c == 'Ready for Fulfillment' && vodOrderProducts.contains(iotJob.id) && !caseVODOrder.contains(iotJob.id)){
                Case newVODCase = New Case();
                newVODCase.Subject = 'New VOD Order';
                newVODCase.Product_or_Service__c = 'VOD';
                newVODCase.Product_or_Service_Detail__c = 'VOD Order';
                newVODCase.Type = 'Add or change a Video / Training Service';
                newVODCase.InvoiceIT_Order__c = iotJob.id;
                newVODCase.Case_Symptom__c = 'New VOD Order';
                newVODCase.Status = 'New';
                newVODCase.Origin = 'Web';
                newVODCase.RecordTypeID = Schema.SObjectType.Case.getRecordTypeInfosByName().get('KV Production Support').getRecordTypeId();
                newVODCase.AccountID = iotJob.invoiceit_s__Account__c;
                newVODCase.OwnerID = defaultQueues.get('VOD Production Team').Queue_Id__c;
                newVODCase.Platform_Asset_Account__c = iotJob.Shipping_Account__c;
                vodCases.add(newVODCase);
            }
            
            if(iotJob.invoiceit_s__Status__c == 'Ready for Fulfillment' && (newInvoiceJobs.get(iotJob.id).invoiceit_s__Status__c!=oldInvoiceJobs.get(iotJob.id).invoiceit_s__Status__c) && webOrderProducts.contains(iotJob.id)){
                Task t = new Task();
                t.OwnerId = system.label.Jon_Buttler_UserID;
                t.Subject = 'Provision webFSA / webFTA - Reference Order';
                t.Status = 'Open';
                t.Priority = 'High';
                t.ActivityDate = system.today()+2;
                t.WhatId = iotJob.id;
                taskCreation.add(t);
            } 
        }
   
        if(vodCases.size()>0){
            insert vodCases;
        }
        
        if(taskCreation.size()>0){
            insert taskCreation; 
        }
        //Commision Dealer Creation
        if(dontRunAgain){
            dontRunAgain = false;
            CommisionDealerCreationMethod(invoiceOrderJob,newInvoiceJobs,oldInvoiceJobs,invoicejobsITProducts);
        }
    }
    
    /*Method to update activeOrder count from trigger:"OrderInvoiceITTrigger".
    If invoice order create,update,delete it will create rollup count on Account - Active_Orders__c field.if order - invoiceit_s__Status__c!=:'Completed/Cancelled'*/ 
    Public Static void orderShippingAccountCount(List<invoiceit_s__Job__c> invoiceItJobs){
        Set<ID> accIds = New Set<ID>();
        Map<ID,Integer> accountInvoiceJobs = New Map<ID,Integer>();
        for(invoiceit_s__Job__c IJ:invoiceItJobs){
            accIds.add(IJ.Shipping_Account__c);
        }
        
        List<Account> acctJobs = [SELECT ID,(SELECT ID,invoiceit_s__Status__c FROM Shipping_Account__r WHERE (invoiceit_s__Status__c!=:'Completed' AND invoiceit_s__Status__c!=:'Cancelled')) FROM Account Where ID=:accIds];
        for(Account countUpdate:acctJobs){
            countUpdate.Active_Orders__c = countUpdate.Shipping_Account__r.size();
        }   
        Update acctJobs;
    }   
    
    Public static void CommisionDealerCreationMethod(List<invoiceit_s__Job__c> invoiceOrderJob,Map<ID,invoiceit_s__Job__c> newInvoiceJobs,Map<ID,invoiceit_s__Job__c> oldInvoiceJobs,Map<ID,list<ID>> invoicejobsITProducts){
        
        List<Id> partnerIds = New List<Id>();
        Set<ID> cloneMasterIds = New Set<ID>();
        
        Map<ID,Map<ID,Partner_Commission_Rates__c>> ProductPcrs = New Map<ID,Map<ID,Partner_Commission_Rates__c>>();
        for(invoiceit_s__Job__c invoiceJobsCommisionCreation:invoiceOrderJob){
            if(invoiceJobsCommisionCreation.invoiceit_s__Partner__c!=null){
                partnerIds.add(invoiceJobsCommisionCreation.invoiceit_s__Partner__c);
            }
            if(invoiceJobsCommisionCreation.invoiceit_s__Master_Order__c!=null && invoiceJobsCommisionCreation.recordTypeID==Schema.SObjectType.invoiceit_s__Job__c.getRecordTypeInfosByName().get('Child Order').getRecordTypeId()){
                cloneMasterIds.add(invoiceJobsCommisionCreation.invoiceit_s__Master_Order__c);
            }
        }
        Map<Id,Partner_Commission_Rates__c> salesOrderType = New Map<Id,Partner_Commission_Rates__c>();
        
        List<Partner_Commission_Rates__c> PCR = [Select Id,Commission_Type__c,Partner_Agent_Account__c,Product__c,Standard_Comm__c,Year1_Commission__c FROM Partner_Commission_Rates__c WHERE (Partner_Agent_Account__c=:partnerIds)];
        for(Partner_Commission_Rates__c pcrProducts:PCR){
            if(ProductPcrs.containsKey(pcrProducts.Partner_Agent_Account__c)) {
                Map<Id,Partner_Commission_Rates__c> exitsPcr = ProductPcrs.get(pcrProducts.Partner_Agent_Account__c);
                exitsPcr.put(pcrProducts.Product__c,pcrProducts);
                ProductPcrs.put(pcrProducts.Partner_Agent_Account__c,exitsPcr);
            }else{
                ProductPcrs.put(pcrProducts.Partner_Agent_Account__c,new Map<Id,Partner_Commission_Rates__c>{pcrProducts.Product__c => pcrProducts});
            }
            if(pcrProducts.Commission_Type__c == 'Sale'){
                salesOrderType.put(pcrProducts.Partner_Agent_Account__c,pcrProducts);
            }
        }
        Map<ID,ID> validateProductExits = new Map<ID,ID>();
        set<ID> salesAgentsIds = New set<ID>();
        List<Order_Commissions__c> exitsOC = [Select Id,Order_for_Commission__c,Order_Product__c,Sales_Agent__c From Order_Commissions__c WHERE (Order_for_Commission__c=:newInvoiceJobs.keyset() OR Order_for_Commission__c=:cloneMasterIds)];
        for(Order_Commissions__c oc:exitsOC){
            validateProductExits.put(oc.Order_for_Commission__c,oc.Order_Product__c);
            salesAgentsIds.add(oc.Sales_Agent__c);
        }
        
        List<Order_Commissions__c> orderCommisions = New List<Order_Commissions__c>();
        for(invoiceit_s__Job__c invoiceJobsCommisionCreation:invoiceOrderJob){
           if(invoiceJobsCommisionCreation.recordTypeID==Schema.SObjectType.invoiceit_s__Job__c.getRecordTypeInfosByName().get('Master Order').getRecordTypeId() || invoiceJobsCommisionCreation.recordTypeID==Schema.SObjectType.invoiceit_s__Job__c.getRecordTypeInfosByName().get('Child Order').getRecordTypeId()){
               if(invoiceJobsCommisionCreation.invoiceit_s__Partner__c!=null){ 
                   if(ProductPcrs.containsKey(invoiceJobsCommisionCreation.invoiceit_s__Partner__c)){
                       Map<ID,Partner_Commission_Rates__c> showPCRData = ProductPcrs.get(invoiceJobsCommisionCreation.invoiceit_s__Partner__c);
                       if(invoicejobsITProducts.containsKey(invoiceJobsCommisionCreation.id)){
                           List<Id> productIds = invoicejobsITProducts.get(invoiceJobsCommisionCreation.id);
                           Set<String> salesAgentPartner = New Set<String>();
                           
                           for(integer i=0;i<productIds.size();i++){
                               if(showPCRData.containsKey(productIds[i])){
                                    if(!validateProductExits.containsKey(invoiceJobsCommisionCreation.id)){
                                        if(validateProductExits.get(invoiceJobsCommisionCreation.id)!=productIds[i]){
                                            salesAgentPartner.add(showPCRData.get(productIds[i]).Partner_Agent_Account__c+'-'+productIds[i]+'-'+invoiceJobsCommisionCreation.Id);
                                            Order_Commissions__c oc = New Order_Commissions__c();
                                            oc.Order_for_Commission__c = invoiceJobsCommisionCreation.Id;
                                            oc.Sales_Agent__c    = showPCRData.get(productIds[i]).Partner_Agent_Account__c;
                                            oc.Order_Product__c = productIds[i];
                                            oc.Subsequent_Years_Commission_Rate__c  = showPCRData.get(productIds[i]).Standard_Comm__c;
                                            oc.Year1_Commission__c  = showPCRData.get(productIds[i]).Year1_Commission__c;
                                            orderCommisions.add(oc);
                                        }
                                    }
                                    if((newInvoiceJobs.get(invoiceJobsCommisionCreation.id).invoiceit_s__Partner__c!=oldInvoiceJobs.get(invoiceJobsCommisionCreation.id).invoiceit_s__Partner__c)&& !salesAgentPartner.contains(showPCRData.get(productIds[i]).Partner_Agent_Account__c+'-'+productIds[i]+'-'+invoiceJobsCommisionCreation.Id)){
                                        
                                        Order_Commissions__c oc = New Order_Commissions__c();
                                        oc.Order_for_Commission__c = invoiceJobsCommisionCreation.Id;
                                        oc.Sales_Agent__c    = showPCRData.get(productIds[i]).Partner_Agent_Account__c;
                                        oc.Order_Product__c = productIds[i];
                                        oc.Subsequent_Years_Commission_Rate__c  = showPCRData.get(productIds[i]).Standard_Comm__c;
                                        oc.Year1_Commission__c  = showPCRData.get(productIds[i]).Year1_Commission__c;
                                        orderCommisions.add(oc);
                                    }
                               }
                           }
                       }
                   }
               }
           }else
           {
               if(invoiceJobsCommisionCreation.recordTypeID==Schema.SObjectType.invoiceit_s__Job__c.getRecordTypeInfosByName().get('Sale Order').getRecordTypeId()){
                   if(!salesAgentsIds.contains(invoiceJobsCommisionCreation.invoiceit_s__Partner__c)){
                         if(salesOrderType.containsKey(invoiceJobsCommisionCreation.invoiceit_s__Partner__c)){
                            Order_Commissions__c oc = New Order_Commissions__c();
                            oc.Order_for_Commission__c = invoiceJobsCommisionCreation.Id;
                            oc.Sales_Agent__c    = salesOrderType.get(invoiceJobsCommisionCreation.invoiceit_s__Partner__c).Partner_Agent_Account__c;
                            oc.Order_Product__c = salesOrderType.get(invoiceJobsCommisionCreation.invoiceit_s__Partner__c).Product__c;
                            oc.Subsequent_Years_Commission_Rate__c  = salesOrderType.get(invoiceJobsCommisionCreation.invoiceit_s__Partner__c).Standard_Comm__c;
                            oc.Year1_Commission__c  = salesOrderType.get(invoiceJobsCommisionCreation.invoiceit_s__Partner__c).Year1_Commission__c;
                            orderCommisions.add(oc); 
                        }
                   }
               }
           }
        }
        if(orderCommisions.size()>0){
            try{
            insert orderCommisions;
            }Catch(Exception e){
                //throw e;
            }
        }
    }
    
    Public static void CloneOrderCommisions(List<invoiceit_s__Job__c> invoiceOrderJob){
        
        Set<ID> cloneMasterIds = New Set<ID>();
        Map<ID,List<ID>> childOrderIds = New Map<ID,List<ID>>();
        
        for(invoiceit_s__Job__c orderCommisionCreation:invoiceOrderJob){
            if(orderCommisionCreation.invoiceit_s__Master_Order__c!=null && orderCommisionCreation.recordTypeID==Schema.SObjectType.invoiceit_s__Job__c.getRecordTypeInfosByName().get('Child Order').getRecordTypeId()){
                cloneMasterIds.add(orderCommisionCreation.invoiceit_s__Master_Order__c);
                
                if(childOrderIds.containsKey(orderCommisionCreation.invoiceit_s__Master_Order__c)) {
                    list<Id> masterOrderIds = childOrderIds.get(orderCommisionCreation.invoiceit_s__Master_Order__c);
                    masterOrderIds.add(orderCommisionCreation.Id);
                    childOrderIds.put(orderCommisionCreation.invoiceit_s__Master_Order__c, masterOrderIds);
                } else {
                    childOrderIds.put(orderCommisionCreation.invoiceit_s__Master_Order__c, new list<Id> {orderCommisionCreation.Id});
                }
            }
        }
        
        
        List<Order_Commissions__c> exitsOC = [Select Id,Custom_Order_Commissions__c,Year1_Commission__c,Subsequent_Years_Commission_Rate__c,Order_for_Commission__c,Order_Product__c,Sales_Agent__c From Order_Commissions__c WHERE Order_for_Commission__c=:cloneMasterIds];
        
        List<Order_Commissions__c> ClonedRecords = new List<Order_Commissions__c>();
        set<String> uniqueCode = New set<String>();
        
        for(Order_Commissions__c updateChildIds:exitsOC){
            if(childOrderIds.containsKey(updateChildIds.Order_for_Commission__c)){
                for(ID childOrder:childOrderIds.get(updateChildIds.Order_for_Commission__c)){
                    if(!uniqueCode.contains(updateChildIds.Order_for_Commission__c+'-'+updateChildIds.Order_Product__c+'-'+updateChildIds.Sales_Agent__c)){
                        Order_Commissions__c cloneNew = updateChildIds.clone();
                        cloneNew.Order_for_Commission__c = childOrder;
                        ClonedRecords.add(cloneNew); 
                        uniqueCode.add(updateChildIds.Order_for_Commission__c+'-'+updateChildIds.Order_Product__c+'-'+updateChildIds.Sales_Agent__c);
                    }
                }
            }
        }
        if(ClonedRecords.size()>0)
            insert ClonedRecords;
    }      
}