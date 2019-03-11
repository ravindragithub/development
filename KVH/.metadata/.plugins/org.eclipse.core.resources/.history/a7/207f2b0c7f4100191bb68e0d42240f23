global class ProductIntegration_SchedularClass implements Schedulable{
    global void execute (SchedulableContext SC){
        ProductAmazon_BatchClass b1 = new ProductAmazon_BatchClass('Products');
        ID batchprocessid1 = Database.executeBatch(b1,2000);
        ProductAmazon_BatchClass b2 = new ProductAmazon_BatchClass('Product-Options');
        ID batchprocessid2 = Database.executeBatch(b2,2000);
        ProductAmazon_BatchClass b3 = new ProductAmazon_BatchClass('Product-Features');
        ID batchprocessid3 = Database.executeBatch(b3,2000);
        ProductAmazon_BatchClass b4 = new ProductAmazon_BatchClass('Product-Attributes');
        ID batchprocessid4 = Database.executeBatch(b4,2000);
        ProductAmazonDocument_BatchClass b5 = new ProductAmazonDocument_BatchClass();
        ID batchprocessid5 = Database.executeBatch(b5,2000);
    }
}