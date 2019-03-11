@isTest
public class QuicklinkToolkitCreation_test {
    @isTest
	static void unittest() {
        Quick_link__c ql = new Quick_link__c();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(ql);
        QuicklinkToolkitCreation ctrl = new QuicklinkToolkitCreation(sc);
        ctrl.QL.QuickLink_Label__c = 'new QL';
        ctrl.QL.Content_Type_s__c = 'Advertising';
        
        ctrl.createQL();
        List <Quick_Link__c> qls = [SELECT Id FROM Quick_Link__c WHERE QuickLink_Label__c = 'new QL'];
        system.assertEquals(1, qls.size());
        ctrl.QLid = ctrl.QL.id;
        ctrl.removeQL();
        qls = [SELECT Id FROM Quick_Link__c WHERE QuickLink_Label__c = 'new QL'];
        system.assertEquals(0, qls.size());
        
    }
}