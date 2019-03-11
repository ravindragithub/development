global class EbillHyperlinkSchedulable implements Schedulable {
    global void execute(SchedulableContext sc) {
        BatchCreateEbillHyperlink batch = new BatchCreateEbillHyperlink();
        Database.ExecuteBatch(batch, 25);
        /*Maximum tested batch size = 25*/
    }
}