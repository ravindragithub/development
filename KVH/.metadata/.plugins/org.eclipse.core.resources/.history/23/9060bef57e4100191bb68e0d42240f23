public with sharing class ControllerCloneOrder {
    
    public invoiceit_s__Job__c orderObj{get;set;}
    invoiceit_s__Job__c orderToInsert;
    public boolean isRender{get;set;}
    
    public boolean isMasterOrder{get;set;}
    public boolean isChildOrder{get;set;}
    public integer iCountOfChild{get;set;}
    public boolean isMasterOrderSelected{get;set;}
     
    public string orderName;
    
    public ControllerCloneOrder(ApexPages.StandardController controller) {
        isChildOrder = false;
        isMasterOrder = false;
        isMasterOrderSelected = true;
        isRender = false;
        orderObj = (invoiceit_s__Job__c)controller.getRecord();
        String sQuery = getObjectSelectQuery('invoiceit_s__Job__c') + ' WHERE  id = \'' + orderObj.id + '\'';
        sQuery = String.escapeSingleQuotes(sQuery);
        sQuery = sQuery.replace('\\','');
        orderObj = database.query(sQuery);
        
        orderName = orderObj.name;
    }
    
    public pagereference createCloneOrder(){
        SavePoint sp;
        try{
            sp = DataBase.setSavepoint();
            string sResponce;
            
            if(isChildOrder && isMasterOrder) {
                Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.Error, 'Please select either Master Order or Child Order');
                Apexpages.addMessage(errorMessage);
                return null;
            }
            
            if(isChildOrder){
                isRender = true;
                BatchProcessCreationOfOrder b = new BatchProcessCreationOfOrder(iCountOfChild,OrderObj);
                database.executebatch(b,1);
                
               Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.Confirm, iCountOfChild + ' orders are processing on background.');
               Apexpages.addMessage(errorMessage);
               
               orderObj.name = orderName;
               return null;
            }else if(isMasterOrder){
                sResponce = OrderCreation(orderObj, isMasterOrder);
            }else{
               Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.Info, 'please select either Master Order or Child Order');
               Apexpages.addMessage(errorMessage);
               return null;
            }
            
            if(sResponce != 'null'){
                pagereference ref = new pagereference('/'+sResponce);
                return ref;
            } else{
                Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.INFO,'No records found to clone');
                Apexpages.addMessage(errorMessage);
                return null;
            }
        }catch(exception ex){
            Database.rollback(sp); 
            Apexpages.Message errorMessage = new Apexpages.Message(ApexPages.Severity.ERROR,'Please follow the exception messege ==>>' + ex.getTypeName()+':'+ex.getMessage() + ':LINE ' + ex.getLineNumber());
            Apexpages.addMessage(errorMessage);
            return null;
        }
        return null;
    }
    
    public void masterOrder() {
        isMasterOrderSelected = false;
    }
    
    
    public static string OrderCreation(invoiceit_s__Job__c orderObj, boolean isMasterOrder){
        list<invoiceit_s__Job_Product__c> listOfOrderProduct;
        list<invoiceit_s__Job_Rate_Plan__c> listOfOrderRatePlan;
        list<invoiceit_s__Job_Rate_Plan_Charge__c> listOfOrderCharge;
        
        OrderProdClass orderProdClass;
        OrderRatePlanClass orderRatePlanClass;
        OrderChargeClass orderChargeClass;
        OrderChargeTitleClass orderChargeTitleClass;
        OrderTierClass orderTierClass;
    
        list<OrderProdClass> lstOrderProdClass = new list<OrderProdClass>();
    
        Integer jobProductCounter = 0;
        Integer jobRatePlanCounter = 0;
        Integer jobRateplanChargeCounter = 0;
        Integer jobRatePlanChargeTitleCounter = 0;
        integer chargeTierCounter = 0;
        
        invoiceit_s__Job__c orderToInsert = new invoiceit_s__Job__c();
        
        String sQuery1 = getObjectSelectQuery('invoiceit_s__Job_Product__c') + ' WHERE  invoiceit_s__Job__c = \'' + orderObj.id + '\'';
            sQuery1 = String.escapeSingleQuotes(sQuery1);
            sQuery1 = sQuery1.replace('\\','');
            listOfOrderProduct = database.query(sQuery1);

            String sQuery2 = getObjectSelectQuery('invoiceit_s__Job_Rate_Plan__c') + ' WHERE  invoiceit_s__Job_Product__r.invoiceit_s__Job__c = \'' + orderObj.id + '\'';
            sQuery2 = String.escapeSingleQuotes(sQuery2);
            sQuery2 = sQuery2.replace('\\','');
            listOfOrderRatePlan = database.query(sQuery2);


            String sQuery3 = getObjectSelectQueryChargeNew('invoiceit_s__Job_Rate_Plan_Charge__c') + ' WHERE  invoiceit_s__Order__c = \'' + orderObj.id + '\'';
            sQuery3 = String.escapeSingleQuotes(sQuery3);
            sQuery3 = sQuery3.replace('\\','');
            listOfOrderCharge = database.query(sQuery3);
            if(listOfOrderCharge.size() > 0){
                 //clone order creation
                orderToInsert = orderObj.clone(false);
                //orderToInsert.Reference_Order__c = orderObj.id;
                
                orderToInsert.invoiceit_s__Master_Order__c = orderObj.id;
                Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.invoiceit_s__Job__c; 
                Map<String,Schema.RecordTypeInfo> OrderRecordTypeInfo = cfrSchema.getRecordTypeInfosByName();  

                
                if(isMasterOrder) {
                    orderToInsert.recordtypeid = OrderRecordTypeInfo.get('Master Order').getRecordTypeId();
                    //orderToInsert.Reference_Order__c = null;
                    orderToInsert.invoiceit_s__Master_Order__c = null;

                    // added by Laxman on Aug, 18th
                    orderToInsert.invoiceit_s__Billing_Master_Account__c = null;
                } else {
                    orderToInsert.recordtypeid = OrderRecordTypeInfo.get('Child Order').getRecordTypeId();
                    if(orderObj.RecordType.Name == 'Child Order') {
                    	orderToInsert.invoiceit_s__Master_Order__c = orderObj.invoiceit_s__Master_Order__c;

                        // added by Laxman on Aug, 18th
                        // in order to upgrade KVH to latest version, we need to populate the billing master account field
                        orderToInsert.invoiceit_s__Billing_Master_Account__c = orderObj.invoiceit_s__Account__c;

                        /*list<invoiceit_s__Job__c> orders = [SELECT invoiceit_s__Master_Order__r.invoiceit_s__Account__c, Id 
                                                            FROM invoiceit_s__Job__c
                                                            WHERE invoiceit_s__Master_Order__c != null];
                          
                          for(invoiceit_s__Job__c order : orders) {
                            order.invoiceit_s__Billing_Master_Account__c = order.invoiceit_s__Master_Order__r.invoiceit_s__Account__c; 
                          }
                        */
                    }
                }           
                
                orderToInsert.OwnerId = Userinfo.getuserId(); 
                insert orderToInsert;

                invoiceit_s__Job_Product__c orderProdLocal;
                invoiceit_s__Job_Rate_Plan__c ratePlanLocal;
                invoiceit_s__Job_Rate_Plan_Charge__c chargeLocal;
                
                set<id> setOfProductIds = new set<id>();
                set<id> setOfRatePlanIds = new set<id>();

                for(invoiceit_s__Job_Product__c orderProd : listOfOrderProduct){
                    orderProdClass = new orderProdClass();
                    orderProdClass.iProdCount = ++jobProductCounter;
                    orderProdClass.orderProd = orderProd.clone(false);
                    orderProdClass.orderProd.invoiceit_s__Job__c = null;

                    for(invoiceit_s__Job_Rate_Plan__c ratePlan : listOfOrderRatePlan){
                        if(ratePlan.invoiceit_s__Job_Product__c == orderProd.id){
                            orderRatePlanClass = new orderRatePlanClass();
                            orderRatePlanClass.ratePlan = ratePlan.clone(false);
                            orderRatePlanClass.ratePlan.invoiceit_s__Job_Product__c = null;
                            orderRatePlanClass.iPlanCount = ++jobRatePlanCounter;

                            for(invoiceit_s__Job_Rate_Plan_Charge__c orderCharge : listOfOrderCharge){
                                if(orderCharge.invoiceit_s__Job_Rate_Plan__c == ratePlan.id){
                                    orderChargeClass = new orderChargeClass();
                                    orderChargeClass.iChargeCount = ++jobRateplanChargeCounter;
                                    
                                    orderChargeClass.orderCharge = orderCharge.clone(false);
                                    orderChargeClass.orderCharge.invoiceit_s__Master_Order_Rate_Plan_Charge__c = orderCharge.Id;
                                    orderChargeClass.orderCharge.invoiceit_s__Job_Rate_Plan__c = null;
                                    orderChargeClass.orderCharge.invoiceit_s__Mid_Term_Adjustment__c = null;
                                    orderChargeClass.orderCharge.invoiceit_s__Previous_Mid_Term_Adjustment__c = null;
                                    orderChargeClass.orderCharge.invoiceit_s__Previous_Charge_Date__c = null;
                                    orderChargeClass.orderCharge.invoiceit_s__Charge_Date__c = null;
                                    orderChargeClass.orderCharge.invoiceit_s__Next_Charge_Date__c = null;
                                    orderChargeClass.orderCharge.invoiceit_s__Order__c = null;
                                    if(!isMasterOrder)
                                        orderChargeClass.orderCharge.invoiceit_s__Price_Format__c = 'Default';
                                    if(orderObj.RecordType.Name == 'Child Order')
                    					orderChargeClass.orderCharge.invoiceit_s__Master_Order_Rate_Plan_Charge__c = orderCharge.invoiceit_s__Master_Order_Rate_Plan_Charge__c;
                                    //orderChargeClass.orderCharge.invoiceit_s__Service_Activation_Date__c = startDate; 
                                    //orderChargeClass.orderCharge.invoiceit_s__Service_End_Date__c = startDate.addMonths(12).addDays(-1);
                                    
                                    // add order product and order plan ids to check
                                    setOfRatePlanIds.add(orderCharge.invoiceit_s__Job_Rate_Plan__c);
                                    setOfProductIds.add(ratePlan.invoiceit_s__Job_Product__c);

                                    for(Order_Charge_Titles__c chargeTitles : orderCharge.Order_Charge__r){
                                            orderChargeTitleClass = new OrderChargeTitleClass();
                                            orderChargeTitleClass.iTitleCount = ++jobRatePlanChargeTitleCounter;
                                            orderChargeTitleClass.orderChargeTitle = chargeTitles.clone(false);
                                            orderChargeTitleClass.orderChargeTitle.Order_Rate_Plan_Charge__c = null;
                                            orderChargeTitleClass.orderChargeTitle.OwnerId = Userinfo.getuserId(); 
                                            
                                            orderChargeClass.lstOrderChargeTitleClass.add(orderChargeTitleClass);
                                    }
                                    
                                     if(isMasterOrder) {
                                        for(invoiceit_s__Job_Rate_Plan_Charge_Tier__c tier : orderCharge.invoiceit_s__Order_Rate_Plan_Charge_Tiers__r){
                                                orderTierClass = new OrderTierClass();
                                                orderTierClass.iTierCount = ++chargeTierCounter;
                                                orderTierClass.orderTier = tier.clone(false); 
                                                orderTierClass.orderTier.invoiceit_s__Job_Rate_Plan_Charge__c = null;
                                                orderTierClass.orderTier.OwnerId = Userinfo.getuserId(); 
                                                
                                                orderChargeClass.listOrderTierClass.add(orderTierClass);
                                        }
                                    }
                                    orderRatePlanClass.lstOrderChargeClass.add(orderChargeClass);
                                }
                            }
                        }
                        if(setOfRatePlanIds.contains(ratePlan.id))
                            orderProdClass.lstorderRatePlanClass.add(orderRatePlanClass);
                    }
                    if(setOfProductIds.contains(orderProd.id))
                        lstOrderProdClass.add(orderProdClass);
                }

                Map<Integer,invoiceit_s__Job_Product__c> mapOrderProducts = new Map<Integer, invoiceit_s__Job_Product__c>();

                for(orderProdClass oPclass : lstOrderProdClass){
                    oPclass.orderProd.invoiceit_s__Job__c = orderToInsert.id;
                    mapOrderProducts.put(oPclass.iProdCount,oPclass.orderProd);
                }

                insert mapOrderProducts.values();
                system.debug('mapOrderProducts===>>'+mapOrderProducts);

                Map<Integer,invoiceit_s__Job_Rate_Plan__c> mapJobRatePlan = new Map<Integer,invoiceit_s__Job_Rate_Plan__c>();

                for(orderProdClass oPclass : lstOrderProdClass){
                    oPclass.orderProd =  mapOrderProducts.get(oPclass.iProdCount);   
                    for(OrderRatePlanClass ratePlanClass : oPclass.lstorderRatePlanClass){
                        if(ratePlanClass.ratePlan != null && ratePlanClass.ratePlan.invoiceit_s__Job_Product__c == null){
                            ratePlanClass.ratePlan.invoiceit_s__Job_Product__c = oPclass.orderProd.id;
                            mapJobRatePlan.put(ratePlanClass.iPlanCount,ratePlanClass.ratePlan);
                        }
                    }
                }

                insert mapJobRatePlan.values();
                system.debug('mapJobRatePlan===>>'+mapJobRatePlan);

                Map<Integer,invoiceit_s__Job_Rate_Plan_Charge__c> mapJobRatePlanCharge = new Map<Integer,invoiceit_s__Job_Rate_Plan_Charge__c>();
                for(orderProdClass oPclass : lstOrderProdClass){
                    for(OrderRatePlanClass ratePlanClass : oPclass.lstorderRatePlanClass){
                        for(OrderChargeClass chargeClass : ratePlanClass.lstOrderChargeClass){
                            chargeClass.orderCharge.invoiceit_s__Job_Rate_Plan__c = ratePlanClass.ratePlan.id;
                            mapJobRatePlanCharge.put(chargeClass.iChargeCount,chargeClass.orderCharge);
                        }
                    }
                }

                insert mapJobRatePlanCharge.values();

                Map<Integer,Order_Charge_Titles__c> mapJobRatePlanChargeTitles = new Map<Integer,Order_Charge_Titles__c>();
                
                Map<Integer,invoiceit_s__Job_Rate_Plan_Charge_Tier__c> mapChargeTiers = new Map<Integer,invoiceit_s__Job_Rate_Plan_Charge_Tier__c>();
                for(orderProdClass oPclass : lstOrderProdClass){
                    for(OrderRatePlanClass ratePlanClass : oPclass.lstorderRatePlanClass){
                        for(OrderChargeClass chargeClass : ratePlanClass.lstOrderChargeClass){
                            chargeClass.orderCharge = mapJobRatePlanCharge.get(chargeClass.iChargeCount);
                            for(OrderChargeTitleClass titleClass : chargeClass.lstOrderChargeTitleClass){
                                titleClass.orderChargeTitle.Order_Rate_Plan_Charge__c = chargeClass.orderCharge.id;
                                mapJobRatePlanChargeTitles.put(titleClass.iTitleCount,titleClass.orderChargeTitle);
                            }
                            
                            for(OrderTierClass tierClass : chargeClass.listOrderTierClass){
                                tierClass.orderTier.invoiceit_s__Job_Rate_Plan_Charge__c = chargeClass.orderCharge.id;
                                mapChargeTiers.put(tierClass.iTierCount,tierClass.orderTier);
                            }
                        }
                    }
                }
                // insert order charge titles
                insert mapJobRatePlanChargeTitles.values();
                // insert order charge tiers
                insert mapChargeTiers.values();
                if(!Test.isRunningTest()){
                    orderToInsert.invoiceit_s__Recalculate__c = true;
                    update orderToInsert;
                }
                
                 if(!isMasterOrder) {
                    Integer counter = [ SELECT count() FROM invoiceit_s__Job__c WHERE invoiceit_s__Master_Order__c =: orderToInsert.invoiceit_s__Master_Order__c AND invoiceit_s__Status__c != 'Archived'];
                    invoiceit_s__Job__c order = new invoiceit_s__Job__c(Id = orderToInsert.invoiceit_s__Master_Order__c, No_Of_Child_Orders__c = counter );
                    update order;
                }
                
                return orderToInsert.id;
            }else{
                return 'null';
            }
    } 
    
    
    public class OrderProdClass{
        invoiceit_s__Job_Product__c orderProd = new invoiceit_s__Job_Product__c();
        integer iProdCount;
        public list<OrderRatePlanClass> lstorderRatePlanClass;
        public orderProdClass(){
            lstorderRatePlanClass = new list<OrderRatePlanClass>();
        }
    }

    public class OrderRatePlanClass{
        invoiceit_s__Job_Rate_Plan__c ratePlan = new invoiceit_s__Job_Rate_Plan__c();
        integer iPlanCount;
        public list<OrderChargeClass> lstOrderChargeClass;
        public OrderRatePlanClass(){
            lstOrderChargeClass = new list<OrderChargeClass>();
        }
    }

    public class OrderChargeClass{
        invoiceit_s__Job_Rate_Plan_Charge__c orderCharge = new invoiceit_s__Job_Rate_Plan_Charge__c();
        integer iChargeCount;
        public list<OrderChargeTitleClass> lstOrderChargeTitleClass;
        public list<OrderTierClass> listOrderTierClass;
        public OrderChargeClass(){
            lstOrderChargeTitleClass = new list<OrderChargeTitleClass>();
            listOrderTierClass = new list<OrderTierClass>();
        }
    }

    public class OrderChargeTitleClass{
        integer iTitleCount;
        Order_Charge_Titles__c orderChargeTitle = new Order_Charge_Titles__c();
    }
    
    public class OrderTierClass{
        integer iTierCount;
        invoiceit_s__Job_Rate_Plan_Charge_Tier__c orderTier = new invoiceit_s__Job_Rate_Plan_Charge_Tier__c();
    }
    
    public static String getObjectSelectQueryChargeNew(String chargeObjectName) {
        String sQuery = 'SELECT ';
        sQuery += getObjectFields(chargeObjectName);
        sQuery += ',(' + getObjectSelectQueryNew('Order_Charge_Titles__c','Order_Charge__r') + ')';
        sQuery += ',(' + getObjectSelectQueryNew('invoiceit_s__Job_Rate_Plan_Charge_Tier__c','invoiceit_s__Order_Rate_Plan_Charge_Tiers__r') + ')';
        sQuery += ' FROM '+ chargeObjectName + ' ';
        return sQuery;
    }
    
    public static String getObjectSelectQueryNew(String objectName,string objectRelatedListName) {
        String sQuery = 'SELECT ';
        sQuery += getObjectFields(objectName);
        sQuery += ' FROM '+ objectRelatedListName + ' ';
        return sQuery;
    }

    //This method returns a select query string that contains all the standard fields of the object
    public static String getObjectSelectQuery(String objectName) {
        String sQuery = 'SELECT ';
        sQuery += getObjectFields(objectName);
        if(objectName == 'invoiceit_s__Job__c') 
        	sQuery += ',RecordType.Name FROM '+ objectName + ' ';
        else
           sQuery += ' FROM '+ objectName + ' ';
        return sQuery;
    }

    //This method returns a comma seperated string of all the standard fields of the object
    public static String getObjectFields(String objectName) {
        String sQuery = '';
        String sCompareAddress = '';
        Map<String, Schema.SObjectField> objectFieldMap = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        for(Schema.SObjectField column: objectFieldMap.values()) {
            //system.debug('column Name is ' + column + 'column permission' + column.getDescribe().isUpdateable());
            sCompareAddress = ''+column;
            if(sCompareAddress != 'ShippingAddress' && sCompareAddress != 'BillingAddress'){
                sQuery += column+', ';
            } 
        }
        sQuery = sQuery.substring(0, sQuery.length()-2);
        sQuery += ' ';
        return sQuery;
    }

}