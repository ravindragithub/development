/* ************************************************************
 * Created By  : Gopi Kishore
 * Created Date:  
 * Description : OrderCommisionTriggerHandlerClass Used to implement following functionlality from OrderCommisionTrigger trigger.
                 1) populating commision order values from partner commission rate object.
 *               2) validating if order master commision salesagenss
                 
 * Modified By   :
 * Modified Date : 
 * Description   :
 * 
 * ************************************************************/

Public Class OrderCommisionTriggerHandlerClass{
    
    Public Static void AutoPopulateCommisionValues(List<Order_Commissions__c> ocListData,Map<Id,Order_Commissions__c> ocNewMapData,Map<Id,Order_Commissions__c> ocOldMapData,String DMLOperation){
        
        Set<ID> accIds = New Set<ID>();
        Set<String> validateMasterOrdersCommisions = New Set<String>(); 
        Set<String> avoidOrderCommissionAgentDupes = New Set<String>();
        
        
        for(Order_Commissions__c orderCommision:ocListData){
            if(!orderCommision.Custom_Order_Commissions__c){
                accIds.add(orderCommision.Sales_Agent__c);
            }
            if(orderCommision.Commission_Basis__c == 'Master Order'){
                validateMasterOrdersCommisions.add(orderCommision.Master_OrderID__c);
            }
            if(DMLOperation=='Insert'){
                validateMasterOrdersCommisions.add(orderCommision.Order_for_Commission__c);
            }
        }
        
        Map<ID,Set<ID>> masterSalesAgents = New Map<ID,Set<ID>>();
        List<Order_Commissions__c> masterOrderSalesAgents = [SELECT ID,Master_OrderID__c,Sales_Agent__c,Order_for_Commission__c,Order_Product__c FROM Order_Commissions__c where (Order_for_Commission__c=:validateMasterOrdersCommisions AND Order_for_Commission__c!=null)];
        
        for(Order_Commissions__c orderAgents:masterOrderSalesAgents){
            if(validateMasterOrdersCommisions.contains(orderAgents.Master_OrderID__c)){
                if(masterSalesAgents.containsKey(orderAgents.Order_for_Commission__c)) {
                    Set<Id> masterAgentsSet = masterSalesAgents.get(orderAgents.Order_for_Commission__c);
                    masterAgentsSet.add(orderAgents.Sales_Agent__c);
                    masterSalesAgents.put(orderAgents.Order_for_Commission__c, masterAgentsSet);
                } else {
                    masterSalesAgents.put(orderAgents.Order_for_Commission__c, new Set<Id> {orderAgents.Sales_Agent__c});
                }
            }
            if(orderAgents.Order_for_Commission__c!=null && orderAgents.Sales_Agent__c!=null && orderAgents.Order_Product__c!=null && DMLOperation=='Insert'){
                avoidOrderCommissionAgentDupes.add(orderAgents.Order_for_Commission__c+'-'+orderAgents.Sales_Agent__c+'-'+orderAgents.Order_Product__c);
            }
        }
        
        
        Map<String,Partner_Commission_Rates__c> partnerCommisionRates = New Map<String,Partner_Commission_Rates__c>();
        
        List<Partner_Commission_Rates__c> pcr = [SELECT ID,Partner_Agent_Account__c,Product__c,Standard_Comm__c,Year1_Commission__c FROM Partner_Commission_Rates__c where Partner_Agent_Account__c=:accIds];
        
        for(Partner_Commission_Rates__c productAgents:pcr){
            partnerCommisionRates.put(productAgents.Product__c+'-'+productAgents.Partner_Agent_Account__c,productAgents);
        }
        
        for(Order_Commissions__c orderCommision:ocListData){
            System.Debug('=====>'+avoidOrderCommissionAgentDupes);
            System.Debug('=====>'+orderCommision.Order_for_Commission__c+'-'+orderCommision.Sales_Agent__c+'-'+orderCommision.Order_Product__c);
            if(!avoidOrderCommissionAgentDupes.Contains(orderCommision.Order_for_Commission__c+'-'+orderCommision.Sales_Agent__c+'-'+orderCommision.Order_Product__c)){
                if(!orderCommision.Custom_Order_Commissions__c){
                    if(orderCommision.Commission_Basis__c == 'Master Order' && masterSalesAgents.ContainsKey(orderCommision.Master_OrderID__c)){
                        Set<ID> masterAgentsData = masterSalesAgents.get(orderCommision.Master_OrderID__c);
                        if(!masterAgentsData.contains(orderCommision.Sales_Agent__c)){
                            orderCommision.addError('There is no Master Order - Order Commission for this Sales Agent / Partner. Please add a Master Order - Order Commission, or change the Child Order - Order Commission > Commission Basis to "Child Order"');
                        }
                    }
                    String reorder = orderCommision.Order_Product__c+'-'+orderCommision.Sales_Agent__c;
                    if(partnerCommisionRates.containsKey(reorder)){
                        orderCommision.Subsequent_Years_Commission_Rate__c = partnerCommisionRates.get(reorder).Standard_Comm__c;
                        orderCommision.Year1_Commission__c = partnerCommisionRates.get(reorder).Year1_Commission__c;
                    }
                }
            }else{
                orderCommision.addError('This partner already has an order commission for the product. Please validate the current order commission.');
            }
        }  
    }
}