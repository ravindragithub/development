global class SalesOrders_AgilePlans_RootAsset_Schld implements Schedulable
{
    global void execute (SchedulableContext SC)
    {
        SalesOrders_AgilePlans_RootAsset_Batch b1 = new SalesOrders_AgilePlans_RootAsset_Batch();
        database.executeBatch(b1,200);
    }
}