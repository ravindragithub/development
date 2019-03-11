/* ************************************************************
 * Created By  : Gopi Kishore
 * Created Date: 16/04/2015 
 * Description : 1) Utility class for invoice line trigger and InvoiceCommissionCreationBatch class.
                 2) Creating invoice commission with invoicelines with order and product.
                 3) while updating invoice having only one invoice commission salesAgent.
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/

Public Class InvoiceLineObjectTrigger{
    Static List<Invoice_Commission__c> invoiceCommisions = New List<Invoice_Commission__c>();
    Static Map<String,Invoice_Commission__c> avoidDuplicateSalesAgents = New Map<String,Invoice_Commission__c>();
    
    //Logic validating to create invoice commissions
    Public static void CreatingInvoiceLineCommision(List<invoiceit_s__Invoice_Lines__c> invoiceLines,String DMLOperation,String batchRun){
        
        List<ID> ProductIds = New List<ID>();
        List<ID> orderIds = New List<ID>();
        List<ID> masterOrderIds = New List<ID>();
        
        for(invoiceit_s__Invoice_Lines__c INVL:invoiceLines){
            if(INVL.invoiceit_s__Product__c!=null){
                ProductIds.add(INVL.invoiceit_s__Product__c);
            }
            if(INVL.invoiceit_s__Job__c!=null){
                orderIds.add(INVL.invoiceit_s__Job__c);
            }
        }
        
        if(DMLOperation == 'update'){
            updateInvoiceLines(invoiceLines);
        }
        
        
        Map<String,List<Order_Commissions__c>> orderProductAgents = New Map<String,List<Order_Commissions__c>>();
        Map<ID,List<Order_Commissions__c>> salesOrders = New Map<ID,List<Order_Commissions__c>>();
        
        List<Order_Commissions__c> ocRecords = [SELECT ID,Sales_Agent__c,Order_Product__c,Order_Product__r.Commissionable_Product__c,Order_for_Commission__c,Order_for_Commission__r.RecordTypeID FROM Order_Commissions__c Where ((Order_Product__c=:ProductIds AND Order_for_Commission__c=:orderIds) AND (Year1_Commission__c != 0 and Subsequent_Years_Commission_Rate__c != 0))];
        for(Order_Commissions__c findingICRecords:ocRecords){
            if(findingICRecords.Order_for_Commission__r.RecordTypeID == Schema.SObjectType.invoiceit_s__Job__c.getRecordTypeInfosByName().get('Child Order').getRecordTypeId()){
                if(orderProductAgents.containsKey(findingICRecords.Order_for_Commission__c+'-'+findingICRecords.Order_Product__c)) {
                    List<Order_Commissions__c> invoiceCommision = orderProductAgents.get(findingICRecords.Order_for_Commission__c+'-'+findingICRecords.Order_Product__c);
                    invoiceCommision.add(findingICRecords);
                    orderProductAgents.put(findingICRecords.Order_for_Commission__c+'-'+findingICRecords.Order_Product__c, invoiceCommision);
                } else {
                    orderProductAgents.put(findingICRecords.Order_for_Commission__c+'-'+findingICRecords.Order_Product__c, new list<Order_Commissions__c> {findingICRecords});
                }
            }
            
            if(findingICRecords.Order_for_Commission__r.RecordTypeID == Schema.SObjectType.invoiceit_s__Job__c.getRecordTypeInfosByName().get('Sale Order').getRecordTypeId()){
                if(salesOrders.containsKey(findingICRecords.Order_for_Commission__c)) {
                    list<Order_Commissions__c> invoiceCommision = salesOrders.get(findingICRecords.Order_for_Commission__c);
                    invoiceCommision.add(findingICRecords);
                    salesOrders.put(findingICRecords.Order_for_Commission__c, invoiceCommision);
                } else {
                    salesOrders.put(findingICRecords.Order_for_Commission__c,new list<Order_Commissions__c> {findingICRecords});
                }
            }
        }
        
        for(invoiceit_s__Invoice_Lines__c INVL:invoiceLines){
            String validateCommisionProduct = INVL.invoiceit_s__Job__c+'-'+INVL.invoiceit_s__Product__c;
            if(orderProductAgents.containsKey(validateCommisionProduct)){
                List<Order_Commissions__c> OC = orderProductAgents.get(validateCommisionProduct);
                orderCommisionCreation(OC,INVL.ID);
            }
            if(salesOrders.containsKey(INVL.invoiceit_s__Job__c)){
                List<Order_Commissions__c> OC = salesOrders.get(INVL.invoiceit_s__Job__c);
                orderCommisionCreation(OC,INVL.ID);
            }
            
            if(batchRun == 'BatchRun'){
                INVL.OrderCommissionBatch__c = true;
            }
        }
        if(invoiceCommisions.size()>0){
            try{
                Database.upsert(invoiceCommisions,false);
            }Catch(Exception e){
            }
        }
        
        if(invoiceLines.size()>0 && batchRun == 'BatchRun'){
            //update invoiceLines;
        }
    }
    
    static set<ID> updateIC = New set<ID>();
    Static set<ID> avoidDupsInvoice = New Set<ID>();
    
    //Creating order commissons.
    public static void orderCommisionCreation(List<Order_Commissions__c> OC,ID invoiceLineID){
         for(Order_Commissions__c O:OC){
            if(!avoidDuplicateSalesAgents.containsKey(invoiceLineID+'-'+O.Sales_Agent__c)){
                Invoice_Commission__c IC = New Invoice_Commission__c();
                IC.Invoice_Line__c = invoiceLineID;
                IC.Partner_Commissioned__c = O.Sales_Agent__c;
                IC.Order_Commissions__c = O.Id;
                avoidDuplicateSalesAgents.put(invoiceLineID+'-'+O.Sales_Agent__c,IC);
                invoiceCommisions.add(IC);
            }else{
                Invoice_Commission__c existingsalesAgents = avoidDuplicateSalesAgents.get(invoiceLineID+'-'+O.Sales_Agent__c);
                existingsalesAgents.SalesAgentDup__c = true;
                if(existingsalesAgents.id!=null && !updateIC.contains(existingsalesAgents.id)){
                    updateIC.add(existingsalesAgents.id);
                    if(!avoidDupsInvoice.contains(avoidDuplicateSalesAgents.get(invoiceLineID+'-'+O.Sales_Agent__c).id)){
                        avoidDupsInvoice.add(avoidDuplicateSalesAgents.get(invoiceLineID+'-'+O.Sales_Agent__c).id);
                        invoiceCommisions.add(existingsalesAgents);
                    }
                }
            }
        }
    } 
    
    //Validating for invoice commission agnet while updating invoice lines
    public static void updateInvoiceLines(List<invoiceit_s__Invoice_Lines__c> invoiceLines){
        List<Invoice_Commission__c> avoidDuplicateAgents = [SELECT Id,Invoice_Line__c,Partner_Commissioned__c FROM Invoice_Commission__c WHERE Invoice_Line__c=:invoiceLines];
        for(Invoice_Commission__c IC:avoidDuplicateAgents){
            avoidDuplicateSalesAgents.put(IC.Invoice_Line__c+'-'+IC.Partner_Commissioned__c,IC);
        }
    }    
}