@isTest
private class EbillHyperlinkSchedulable_V2_test {
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    static testmethod void test() {
        Test.startTest();
        
        Account a = new Account();
        a.Name = 'testScheduledApexFromTestMethod';
        insert a;
        
        String jobId = System.schedule('ScheduleApexClassTest', CRON_EXP, new EbillHyperlinkSchedulable_V2());
        CronTrigger ct1 = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, ct1.CronExpression);
        System.assertEquals(0, ct1.TimesTriggered);
        System.assertEquals('2022-03-15 00:00:00', String.valueOf(ct1.NextFireTime));
        System.assertNotEquals('testScheduledApexFromTestMethodUpdated', [SELECT id, name FROM account WHERE id = :a.id].name);
        Test.stopTest();
        
        System.assertEquals('testScheduledApexFromTestMethodUpdated', [SELECT id, name FROM account WHERE id = :a.id].name);       
    }
}