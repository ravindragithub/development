global class SalesOrders_AgilePlans_RootAsset_Batch implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        //Query to Fetch the newly created Asset without Parent Asset aligned to it
        Set<string> tempSet = new Set<string>();
            
        for(ProductParentAsset__c saleOrdLineProduct : ProductParentAsset__c.getAll().values()){
            tempSet.add(saleOrdLineProduct.Product_Name__c);
        }
        system.debug(tempSet+'====tempSet');
        String query = 'SELECT Id, Name,Sales_Order__c,Sales_Order__r.Name,Date_Shipped__c,Product2Id,Parent_Asset__c,CreatedDate FROM Asset WHERE Parent_Asset__c = null AND Sales_Order__c != null AND  Product2.Name NOT IN: tempSet ORDER By Date_Shipped__c DESC';
        system.debug(query+'===query');
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC, List<Asset> listAsset)
    {
        system.debug(listAsset+'===listAsset');
        //Variable Declaration
        Map<Id,List<Asset>> newSalesOrderIdListAsset = new Map<Id,List<Asset>>();
        List<Asset> newParentAssetList = new List<Asset>();
        Map<Id,Id> salesOrderIdAssetParentId = new Map<Id,Id>();
        List<Asset> asstListUpdate = new List<Asset>();
        List<Order_Line__c> listOrderLine = new List<Order_Line__c>();
        Map<Id,Id> salesorderOrderLineProduct = new Map<Id,Id>();
        Set<Id> orderIds = new Set<Id>();
        Map<Id,Id> salesOrderIdExistingParentAssetMap = new Map<Id,Id>();
        Map<Id,Id> salesOrderBillingAccount = new Map<Id,Id>();
        Map<Id,Date> salesOrderShippingDate = new Map<Id,Date>();
        //Condition if start method return any list of Asset as Result
        if(listAsset.size() > 0)
        {
            /* Map of Sales Order Id vs List of all non-parent assets related to it */
            for(Asset asst : listAsset)
            {
                if(newSalesOrderIdListAsset.containsKey(asst.Sales_Order__c)) 
                {
                    List<Asset> assetToAdd= newSalesOrderIdListAsset.get(asst.Sales_Order__c);
                    assetToAdd.add(asst);
                }
                else
                {
                    newSalesOrderIdListAsset.put(asst.Sales_Order__c,  new List<Asset> { asst });
                }
                salesOrderShippingDate.put(asst.Sales_Order__c,asst.Date_Shipped__c);
                orderIds.add(asst.Sales_Order__c);
            }
            system.debug(newSalesOrderIdListAsset+'===newSalesOrderIdListAsset');
            system.debug(salesOrderShippingDate+'===salesOrderShippingDate');
            
            /* Code to get the Products from Custom Setting */
            Set<string> tempSet = new Set<string>();
            
            for(ProductParentAsset__c saleOrdLineProduct : ProductParentAsset__c.getAll().values()){
                tempSet.add(saleOrdLineProduct.Product_Name__c);
            }
            system.debug(tempSet+'====tempSet');
            /* Map of Sales Order Id vs Item on Sales Order Line.This is to add Order Line item Product to New Parent Asset */
            if(tempSet.size() > 0)
            listOrderLine = [select id,name,Sales_Order__c,Item__c,Item__r.Name from Order_Line__c where Sales_Order__c =: orderIds AND Item__r.Name =: tempSet];
            if(listOrderLine.size() > 0)
            {
                for(Order_Line__c ordLine : listOrderLine )
                {
                    salesorderOrderLineProduct.put(ordLine.Sales_Order__c ,ordLine.Item__c );
                }
            }
            system.debug(salesorderOrderLineProduct+'===salesorderOrderLineProduct');
            if(salesorderOrderLineProduct.keyset().size() > 0 &&  salesorderOrderLineProduct != null)
            {
                /*Map of Sales Order vs Existing Parent Asset Id */
                for(Asset asst : [SELECT Id, Name,Sales_Order__c,Sales_Order__r.Name,Product2.Name,Parent_Asset__c FROM Asset WHERE Sales_Order__c =: orderIds AND Product2.Name IN: tempSet])
                {
                    salesOrderIdExistingParentAssetMap.put(asst.Sales_Order__c,asst.Id);
                }
                system.debug(salesOrderIdExistingParentAssetMap+'==salesOrderIdExistingParentAssetMap');  
                
                /* Map for getting Billing Address of each sales Order.Map of Sales Order Id vs Billing Account */
                for(Sales_Order__c salesOrder : [select id,name,Billing_Account__c,Billing_Account__r.Account__c from Sales_Order__c where Id =:orderIds])
                {
                    salesOrderBillingAccount.put(salesOrder.id,salesOrder.Billing_Account__r.Account__c);
                }
                system.debug(salesorderOrderLineProduct+'==salesorderOrderLineProduct'); 
            }
            /*Creating New Parent Asset list based on existing Sales Order data */
            for(Id salesOrderId : newSalesOrderIdListAsset.keyset())
            {
                if(salesOrderIdExistingParentAssetMap.get(salesOrderId) == null && salesorderOrderLineProduct.get(salesOrderId) != null)
                {
                    Asset newParentAsset = new Asset();//Create a new Instance of Asset
                    newParentAsset.Name = newSalesOrderIdListAsset.get(salesOrderId)[0].Sales_Order__r.Name + '_-AP';//Assign name of SaleOrder + _-AP
                    newParentAsset.SerialNumber = newSalesOrderIdListAsset.get(salesOrderId)[0].Sales_Order__r.Name + '_-AP';//Assign same as AssetName
                    newParentAsset.Sales_Order__c = salesOrderId;//Assign Sales Order from loop variable
                    newParentAsset.AccountId = salesOrderBillingAccount.get(salesOrderId);//Assign the Billing Account from Map Variable
                    newParentAsset.Product2Id = salesorderOrderLineProduct.get(salesOrderId);//Assing Product from Map Variable
                    newParentAsset.Date_Shipped__c = salesOrderShippingDate.get(salesOrderId);
                    newParentAssetList.add(newParentAsset);
                }
            }
            system.debug(newParentAssetList+'==newParentAssetList');   
        }
        /* Insert the new list of parent Asset */
        if(newParentAssetList.size() > 0)
        {
            try
            {
                insert newParentAssetList;//Insert the New Parent Asset under Sales Order if it doesnt have any parent Asset
                system.debug('==newParentAssetList'+newParentAssetList);
            }
            catch(Exception ae)
            {
                system.debug('Exception on insert of new List of Parent Asset::'+ae);
            }
            /* Updating the Map of Sales Order Id vs Parent Asset with new values of Parent Asset Inserted */
            for(Asset asst : newParentAssetList)
            {
                salesOrderIdExistingParentAssetMap.put(asst.Sales_Order__c,asst.Id);
            }
            system.debug('==salesOrderIdExistingParentAssetMap'+salesOrderIdExistingParentAssetMap);
        }
        if(newSalesOrderIdListAsset.keyset().size() > 0 &&  newSalesOrderIdListAsset != null)
        {
            /*Removing the Sales Order Lookup and adding New Parent Asset Lookup to existing child assets */
            for(Id salesOrdId : newSalesOrderIdListAsset.keyset())
            {
                if(salesOrderIdExistingParentAssetMap.containsKey(salesOrdId) && salesorderOrderLineProduct.get(salesOrdId) != null)
                {
                    for(Asset newAsset : newSalesOrderIdListAsset.get(salesOrdId))
                    {
                        newAsset.Parent_Asset__c = salesOrderIdExistingParentAssetMap.get(salesOrdId);
                        newAsset.Root_Asset__c = salesOrderIdExistingParentAssetMap.get(salesOrdId);
                        asstListUpdate.add(newAsset);
                    }
                    
                }
            }
        }
        
        system.debug(asstListUpdate+'===>asstListUpdate');
        try
        {
            if(asstListUpdate.size() > 0)
            update asstListUpdate;//Update the child assets
        }
        catch(Exception ae)
        {
            system.debug('Exception on Updating the child assets::'+ae);
        }
    }  
    global void finish(Database.BatchableContext BC)
    {
    }
}