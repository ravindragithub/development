public with sharing class SubscriptionTriggerHandler 
{           
    
    public void OnAfterInsertUpdate(List<SBQQ__Subscription__c> newSubscription)
    {
        List<SBQQ__Subscription__c> listSubscription= new List<SBQQ__Subscription__c>();
        set<Id> subLstId = new set<Id>();
        for(SBQQ__Subscription__c sub : newSubscription){
            subLstId.add(sub.Id);
        }
        listSubscription = [Select Id,Name,Asset__r.Product2.Name,SBQQ__Contract__r.Billing_Account__r.Main_Contact__r.HTS_Notifications__c 
                            From SBQQ__Subscription__c 
                            Where Asset__r.Product2.Name = 'Virtual Terminal ID' AND 
                            SBQQ__Contract__r.Billing_Account__r.Main_Contact__r.HTS_Notifications__c != 'Receive network notifications ONLY for outages LONGER than 4 hrs' AND 
                            SBQQ__Contract__r.Billing_Account__r.Main_Contact__c != null AND
                            Id =: sublstId AND
                            (Status__c = 'Active' OR Status__c = 'Suspended')];
        system.debug(listSubscription+'===listSubscription==='+listSubscription.size());
        set<Id> contIds = new set<Id>();
        if(listSubscription.size() > 0){
            //Fetching the list of Accounts from HTS Subscription
            for(SBQQ__Subscription__c sub : listSubscription){
                if(sub.SBQQ__Contract__r.Billing_Account__r.Main_Contact__c != null)
                    contIds.add(sub.SBQQ__Contract__r.Billing_Account__r.Main_Contact__c);
            }
            List<Contact> updateListCont = new List<Contact>([Select Id,Name,HTS_Notifications__c from Contact where Id =: contIds]);
            if(updateListCont.size() > 0){
                for(Contact cont : updateListCont)
                    cont.HTS_Notifications__c = 'Receive network notifications ONLY for outages LONGER than 4 hrs';
                try{
                    update updateListCont;
                }
                catch (Exception ae){
                    system.debug('Exception ::'+ae);
                }
            }
        }
    }
    
    
}