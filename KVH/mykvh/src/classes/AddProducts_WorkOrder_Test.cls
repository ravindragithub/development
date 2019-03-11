@isTest
private class AddProducts_WorkOrder_Test{
    public static WorkOrder wo;
    public static List<ProductRequired> prlst;
    public static  List<AddProducts_WorkOrderController.DisplayProductList> testClass;
    static void setupdata(){
        final Id Service_RECORD_TYPE_ID = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        List<Product2> prodLst = new List<Product2>();
        for(integer i= 0; i <2; i++){
        Product2 prod = new Product2();
        prod.Name = '02-1925'+i;
        prod.ProductCode = '02-1925'+i;
        prod.RecordTypeId = Service_RECORD_TYPE_ID;
        prodLst.add(prod);
        }
        insert prodLst; 
        
        wo = new WorkOrder();
        insert wo;
        
        prlst = new List<ProductRequired>();
        for(Product2 prod : prodLst){
        ProductRequired pr = new ProductRequired();
        pr.ParentRecordId = wo.Id;
        pr.Product2Id = prod.Id;
        pr.QuantityRequired = 20;
        prlst.add(pr);
        }
        insert prlst;
        
        testClass = new List<AddProducts_WorkOrderController.DisplayProductList>();
        AddProducts_WorkOrderController.DisplayProductList test = new AddProducts_WorkOrderController.DisplayProductList();
        test.partNumber = prodLst[0].Name;
        test.prodDescription = prodLst[0].ProductCode;
        test.quantity = '20';
        test.prodId = prodLst[0].Id;
        test.recordId = prlst[0].Id;
        testClass.add(test);
    }
    static testmethod void AddProducts_WorkOrder_Method(){
        Test.startTest();
        setupdata();
        AddProducts_WorkOrderController.getProductReqList(wo.Id);
        String JSONString = JSON.serialize(testClass);
        string woId = wo.Id;
        AddProducts_WorkOrderController.saveProductRequired(JSONString , woId ,'insert');
        Test.stopTest();
    }
    static testmethod void AddProducts_WorkOrder_Method2(){
        Test.startTest();
        setupdata();
        String JSONString = JSON.serialize(testClass);
        string woId = wo.Id;
        AddProducts_WorkOrderController.saveProductRequired(JSONString , woId ,'delete');
        Test.stopTest();
    }
}