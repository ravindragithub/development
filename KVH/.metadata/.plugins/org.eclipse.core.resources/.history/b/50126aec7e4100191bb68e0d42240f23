public class AddProducts_WorkOrderController{

    
    @AuraEnabled
    public static List<ProductRequired > getProductReqList(string workOrderId) {
        List<ProductRequired> prLst= new List<ProductRequired >();
        for(ProductRequired pr :[Select id,ParentRecordId,Product2.ProductCode,Product2Id,Product2.Name,Product2.Description,QuantityRequired From ProductRequired Where ParentRecordId =: workOrderId]){
        prLst.add(pr);
        }
        return prLst;
    }
    @AuraEnabled
    public static void saveProductRequired(string wrapperLst,string workOrderId,string typeDML){
    system.debug('===wrapperLst==='+wrapperLst);
    system.debug('===typeDML==='+typeDML);
    system.debug('===workOrderId==='+workOrderId);
        if(!string.isBlank(wrapperLst) && !string.isBlank(workOrderId)){
            List<AddProducts_WorkOrderController.DisplayProductList> wrapList = 
                (List<AddProducts_WorkOrderController.DisplayProductList >)
                System.JSON.deserialize(wrapperLst,List<AddProducts_WorkOrderController.DisplayProductList >.class);
            List<ProductRequired> prLst = new List<ProductRequired>();
            
            for(AddProducts_WorkOrderController.DisplayProductList b : wrapList ){
                if((b.prodId != null && b.prodId != '') && (b.recordId == '' || typeDML == 'delete')){
                    ProductRequired PR = new ProductRequired();
                    PR.ParentRecordId = workOrderId;
                    PR.Product2Id = b.prodId;
                    if(b.quantity != '' && b.quantity != null)
                    PR.QuantityRequired = Decimal.valueof(b.quantity);
                    if(typeDML == 'delete')
                    PR.Id = b.recordId;
                    prLst.add(PR);
                }
            }
            system.debug('===prLst==='+prLst);
            if(prLst.size() > 0){
            new AddProducts_WorkOrderController().insertProductRequired(prLst,typeDML);
            }
        }
    }
    public void insertProductRequired(List<ProductRequired > prLst,string typeDML){
        if(prLst.size() > 0){
        if(typeDML == 'insert')
        upsert prLst;
        else if(typeDML == 'delete')
        delete prLst;
        }
    }
    public class DisplayProductList {
        @AuraEnabled public string partNumber;
        @AuraEnabled public string prodDescription;
        @AuraEnabled public string quantity;
        @AuraEnabled public string recordId;
        @AuraEnabled public string prodId;
        @AuraEnabled public string ProductCode;
        public DisplayProductList (){
        }
    }
}