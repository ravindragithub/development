/**
* @createdby        :   Teertha prasad
* @createddate      :   28/06/2016
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   28/06/2016
* @description      :   Class Used In Act_Subscriber Trigger for Activation Contact Creation and
*                       update based on Activation Subscriber record.
**/ 
public class Act_Subscriber_Handler {
    private static String strSubscriberRole = 'Main Contact'; // Contact Subscriber Role can be taken from custom labels later
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   28/06/2016
* @description          :   onAfter Method.
* @return               :   void
* @param                :   List of Activation Subscriber Records
* @invoke               :   From Act_Subscriber Trigger 
**/  
    public static void onAfter(List<Activation_Subscriber__c> lstActSubscriber){
        isAfter(lstActSubscriber);
    }
    
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   28/06/2016
* @description          :   isAfter Method.
*                           Upsert Activation Contact Record On Upsert of 
*                           Activation Subscriber Record with contact role 'Subscriber'
* @return               :   void
* @param                :   List of Activation Subscriber Records
* @invoke               :   From onAfter Method 
**/ 
    private static void isAfter(List<Activation_Subscriber__c> lstActSubscriber){
        Map<Id, Activation_Subscriber__c> mapRoleSubscriber = New Map<Id, Activation_Subscriber__c>();
        Map<Id, Activation_Contact__c> mapRoleContact = New Map<Id, Activation_Contact__c>();
        Map<Id, Activation_Contact__c> mapBillingContact = New Map<Id, Activation_Contact__c>();
        
        
        for(Activation_Subscriber__c objActivationSubscriber : [SELECT Id,Address__c,Subscriber_Address_Line_2__c,City__c,Postal_Zip_Code__c, Activation_Order__c,Contact_Role__c,Corporate_Billing_Account__r.Billing_Contact__c, Contact__c, Subscriber_Contact_Salutation__c, Subscriber_Contact_First_Name__c, Subscriber_Contact_Name__c,Secondary_Phone__c,Secondary_Phone_Type__c,Phone_Number__c,Subscriber_Phone_Type__c,Subscriber_Email__c,Billing_Rep_Job_Title__c,Subscribing_Company__c,Billing_Rep_Job_Function__c,State_Province__c,Country_Name__c,Corporate_Billing_Account__r.Bill_to__c,Corporate_Billing_Account__r.Corp_Duplicate__c,Corporate_Billing_Account__r.Billing_Contact__r.Salutation,Corporate_Billing_Account__r.Billing_Contact__r.FirstName,Corporate_Billing_Account__r.Billing_Contact__r.LastName,Corporate_Billing_Account__r.Billing_Contact__r.Job_Function__c,Corporate_Billing_Account__r.Billing_Contact__r.Account.Name,Corporate_Billing_Account__r.Billing_Contact__r.Phone,Corporate_Billing_Account__r.Billing_Contact__r.MobilePhone,Corporate_Billing_Account__r.Billing_Contact__r.Email,Corporate_Billing_Account__r.Billing_Contact__r.MailingStreet,Corporate_Billing_Account__r.Billing_Contact__r.MailingCity,Corporate_Billing_Account__r.Billing_Contact__r.MailingPostalCode,Corporate_Billing_Account__r.Billing_Contact__r.MailingState,Corporate_Billing_Account__r.Billing_Contact__r.MailingCountry FROM Activation_Subscriber__c WHERE Id in :lstActSubscriber]){
            if(objActivationSubscriber.Activation_Order__c != null && !mapRoleSubscriber.containsKey(objActivationSubscriber.Activation_Order__c) && objActivationSubscriber.Contact_Role__c != null && objActivationSubscriber.Contact_Role__c.containsIgnoreCase(strSubscriberRole)){
                mapRoleSubscriber.put(objActivationSubscriber.Activation_Order__c,objActivationSubscriber);
            }
        }
        
        List<Activation_Order__c> lstActivationOrder = New List<Activation_Order__c>();
        for(Id IdActivationOrder : mapRoleSubscriber.keySet()){
            Activation_Order__c objActivationOrder = New Activation_Order__c();
            objActivationOrder.id = IdActivationOrder;
            if(objActivationOrder.Main_Contact__c != mapRoleSubscriber.get(IdActivationOrder).Contact__c && mapRoleSubscriber.get(IdActivationOrder).Contact__c != null){
                objActivationOrder.Main_Contact__c = mapRoleSubscriber.get(IdActivationOrder).Contact__c;
                lstActivationOrder.add(objActivationOrder);
            }
        }
        if(lstActivationOrder.size() > 0)
            update lstActivationOrder;
        for(Activation_Contact__c objActivationContact 
            : [SELECT Id,Activation_Order__c,First_Name__c,Salutation__c,Last_Name__c,State__c,City__c,Postal_Zip_Code__c,
               Email__c,Primary_Phone__c,Primary_Phone_Type__c,Job_Function__c,Job_Title__c,Account__c,Country__c,Address_1__c,
               Secondary_Phone__c, Secondary_Phone_Type__c,Contact_Role__c
               FROM Activation_Contact__c WHERE Activation_Order__c IN: mapRoleSubscriber.keySet()]){
                   if(!mapRoleContact.containsKey(objActivationContact.Activation_Order__c) && objActivationContact.Contact_Role__c != null && objActivationContact.Contact_Role__c.containsIgnoreCase(strSubscriberRole)){
                       mapRoleContact.put(objActivationContact.Activation_Order__c,objActivationContact);
                   } 
                   if(!mapBillingContact.containsKey(objActivationContact.Activation_Order__c) && objActivationContact.Contact_Role__c != null && !objActivationContact.Contact_Role__c.containsIgnoreCase(strSubscriberRole) && objActivationContact.Contact_Role__c.containsIgnoreCase('Billing Representative')){
                       mapBillingContact.put(objActivationContact.Activation_Order__c,objActivationContact);
                   } 
               }
        
        for(Id KeyId : mapRoleSubscriber.keySet()){
            if(mapRoleContact.isEmpty() || !mapRoleContact.containsKey(KeyId)){
                mapRoleContact.put(KeyId, New Activation_Contact__c(Activation_Order__c = KeyId));
                mapRoleContact.get(KeyId).Contact_Role__c = (mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__c == null || mapRoleSubscriber.get(KeyId).Contact__c == mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__c || (mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Bill_to__c != 'Corporate' && mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Corp_Duplicate__c != 'No')) ? mapRoleSubscriber.get(KeyId).Contact_Role__c + ',Billing Representative' : mapRoleSubscriber.get(KeyId).Contact_Role__c;
            }
            mapRoleContact.get(KeyId).Salutation__c = mapRoleSubscriber.get(KeyId).Subscriber_Contact_Salutation__c;
            mapRoleContact.get(KeyId).First_Name__c = mapRoleSubscriber.get(KeyId).Subscriber_Contact_First_Name__c;
            mapRoleContact.get(KeyId).Last_Name__c = mapRoleSubscriber.get(KeyId).Subscriber_Contact_Name__c;
            mapRoleContact.get(KeyId).Secondary_Phone__c = mapRoleSubscriber.get(KeyId).Secondary_Phone__c;
            mapRoleContact.get(KeyId).Secondary_Phone_Type__c = mapRoleSubscriber.get(KeyId).Secondary_Phone_Type__c;
            mapRoleContact.get(KeyId).Primary_Phone__c = mapRoleSubscriber.get(KeyId).Phone_Number__c;
            mapRoleContact.get(KeyId).Primary_Phone_Type__c = mapRoleSubscriber.get(KeyId).Subscriber_Phone_Type__c;
            mapRoleContact.get(KeyId).Email__c = mapRoleSubscriber.get(KeyId).Subscriber_Email__c;
            mapRoleContact.get(KeyId).Job_Title__c = mapRoleSubscriber.get(KeyId).Billing_Rep_Job_Title__c;
            mapRoleContact.get(KeyId).Account__c = mapRoleSubscriber.get(KeyId).Subscribing_Company__c != null ? mapRoleSubscriber.get(KeyId).Subscribing_Company__c : (mapRoleSubscriber.get(KeyId).Subscriber_Contact_First_Name__c +' '+mapRoleSubscriber.get(KeyId).Subscriber_Contact_Name__c);
                mapRoleContact.get(KeyId).Job_Function__c = mapRoleSubscriber.get(KeyId).Billing_Rep_Job_Function__c; 
            mapRoleContact.get(KeyId).State__c = mapRoleSubscriber.get(KeyId).State_Province__c;
            mapRoleContact.get(KeyId).Country__c = mapRoleSubscriber.get(KeyId).Country_Name__c;
            mapRoleContact.get(KeyId).Contact__c = mapRoleSubscriber.get(KeyId).Contact__c;
            // updated added new mapping 06/20/17
            mapRoleContact.get(KeyId).Address_1__c = mapRoleSubscriber.get(KeyId).Address__c;
            mapRoleContact.get(KeyId).Address_2__c= mapRoleSubscriber.get(KeyId).Subscriber_Address_Line_2__c;
            mapRoleContact.get(KeyId).City__c = mapRoleSubscriber.get(KeyId).City__c;
            mapRoleContact.get(KeyId).Postal_Zip_Code__c = mapRoleSubscriber.get(KeyId).Postal_Zip_Code__c;
            //updated added new mapping 06/20/17
            if(mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__c != null && mapRoleSubscriber.get(KeyId).Contact__c != mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__c && (mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Bill_to__c == 'Corporate' || mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Corp_Duplicate__c == 'No')){
                if(mapBillingContact.isEmpty() || !mapBillingContact.containsKey(KeyId)){
                    mapBillingContact.put(KeyId, New Activation_Contact__c(Activation_Order__c = KeyId));
                    mapBillingContact.get(KeyId).Contact_Role__c = 'Invoice Recipient,Billing Representative';
                }
                mapBillingContact.get(KeyId).Salutation__c=mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__r.Salutation;
                mapBillingContact.get(KeyId).First_Name__c=mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__r.FirstName;
                mapBillingContact.get(KeyId).Last_Name__c=mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__r.LastName;
                mapBillingContact.get(KeyId).Job_Function__c=mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__r.Job_Function__c;
                mapBillingContact.get(KeyId).Account__c = mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__r.Account.Name;  
                mapBillingContact.get(KeyId).Contact__c=mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__c;
                mapBillingContact.get(KeyId).Primary_Phone__c=mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__r.Phone;
                mapBillingContact.get(KeyId).Primary_Phone_Type__c = 'Business';
                mapBillingContact.get(KeyId).Secondary_Phone__c =mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__r.MobilePhone;
                mapBillingContact.get(KeyId).Email__c=mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__r.Email;
                mapBillingContact.get(KeyId).Address_1__c=mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__r.MailingStreet;
                mapBillingContact.get(KeyId).City__c=mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__r.MailingCity;
                mapBillingContact.get(KeyId).Postal_Zip_Code__c=mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__r.MailingPostalCode;
                mapBillingContact.get(KeyId).State__c=mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__r.MailingState;
                mapBillingContact.get(KeyId).Country__c=mapRoleSubscriber.get(KeyId).Corporate_Billing_Account__r.Billing_Contact__r.MailingCountry;
            }
        }
        
        if(!mapRoleContact.isEmpty())
            upsert mapRoleContact.values();
        if(!mapBillingContact.isEmpty())
            upsert mapBillingContact.values();
    }
    
    public static void AddContactRole(List<Activation_Subscriber__c> lstActSubscribers){
        Map<Id, Set<Id>> AccToActSubs = New Map<Id, Set<Id>>();
        Map<Id, Set<Id>> BillAccToActSubs = New Map<Id, Set<Id>>();
        
        list<Id> lstContactIds  = New list<Id>();
        
        for(Activation_Subscriber__c objActivationSubscriber : [SELECT id, contact__c,Account__c,Activation_Order__c,Corporate_Billing_Account__c,Corporate_Billing_Account__r.Bill_to__c,Corporate_Billing_Account__r.Corp_Duplicate__c,Corporate_Billing_Account__r.Billing_Contact__c FROM Activation_Subscriber__c WHERE Id in :lstActSubscribers]) {
            lstContactIds.add(objActivationSubscriber.contact__c);
            if(objActivationSubscriber.Corporate_Billing_Account__r.Bill_to__c == 'Corporate' || objActivationSubscriber.Corporate_Billing_Account__r.Corp_Duplicate__c == 'No')
                lstContactIds.add(objActivationSubscriber.Corporate_Billing_Account__r.Billing_Contact__c);
            if(!AccToActSubs.containsKey(objActivationSubscriber.Account__c)){
                AccToActSubs.put(objActivationSubscriber.Account__c, New Set<Id> { objActivationSubscriber.Activation_Order__c });
            }else{
                AccToActSubs.get(objActivationSubscriber.Account__c).add(objActivationSubscriber.Activation_Order__c);
            }
            
            if(!BillAccToActSubs.containsKey(objActivationSubscriber.Corporate_Billing_Account__c)){
                BillAccToActSubs.put(objActivationSubscriber.Corporate_Billing_Account__c, New Set<Id> { objActivationSubscriber.Activation_Order__c });
            }else{
                BillAccToActSubs.get(objActivationSubscriber.Corporate_Billing_Account__c).add(objActivationSubscriber.Activation_Order__c);
            }
        }
        
        list<Activation_Contact__c> ActContLst=new list<Activation_Contact__c>();
        
        Map<Id, Billing_Contact_Role__c> mapBillingContactRoles = New Map<Id, Billing_Contact_Role__c> ();
        Map<Id, Set<String>> mapBillContactRoles = New Map<Id, Set<String>> ();
        
        for(Billing_Contact_Role__c objBillingContactRole : [SELECT Billing_Account__r.Id, Billing_Account__r.Name, contact__r.name,contact__r.Salutation,contact__r.MailingStreet,contact__r.MailingState,contact__r.MailingCountry,contact__r.MailingPostalCode,contact__r.MailingCity,contact__r.MobilePhone,contact__r.Phone,contact__r.Email,contact__r.Inactive_Contact__c,contact__r.Job_Function__c,contact__r.FirstName,contact__r.LastName,Role_s__c,contact__r.Id FROM Billing_Contact_Role__c WHERE Billing_Account__r.Id IN: BillAccToActSubs.keyset() AND contact__r.Id NOT IN: lstContactIds ]){
            lstContactIds.add(objBillingContactRole.Contact__c);
            Set<String> setRolesT = New Set<String>();
            setRolesT.addAll((objBillingContactRole.Role_s__c != null ? objBillingContactRole.Role_s__c.remove('Airtime').trim().split(';') : New List<String>{null}));
            if(!mapBillingContactRoles.containsKey(objBillingContactRole.Contact__c)){
                mapBillingContactRoles.put(objBillingContactRole.Contact__c, objBillingContactRole);
                mapBillContactRoles.put(objBillingContactRole.Contact__c, setRolesT);
            }else{
                Set<String> setRolesTemp = New Set<String>();
                setRolesTemp.addAll((objBillingContactRole.Role_s__c != null ? objBillingContactRole.Role_s__c.trim().remove('Airtime').split(';') : New List<String>{null}));
                setRolesTemp.addAll(setRolesT);
                mapBillContactRoles.put(objBillingContactRole.Contact__c, setRolesTemp);
            }
        }
        
        Map<Id, AccountContactRole> mapAccountContactRoles = New Map<Id, AccountContactRole> ();
        Map<Id, Set<String>> mapContactRoles = New Map<Id, Set<String>> ();
        for(AccountContactRole objAccountContactRole : [SELECT accountId,account.name,contact.name,contact.Salutation,contact.MailingStreet,contact.MailingState,contact.MailingCountry,contact.MailingPostalCode,contact.MailingCity,contact.MobilePhone,contact.Phone,contact.Email,contact.Inactive_Contact__c,contact.Job_Function__c,contact.FirstName,contact.LastName,role,contactId FROM AccountContactRole WHERE accountId IN: AccToActSubs.keyset() AND contact.Inactive_Contact__c= false and contactId NOT IN: lstContactIds AND (role='Airtime Main Contact' OR role='Authorized Representative')]){
            if(!mapAccountContactRoles.containsKey(objAccountContactRole.contactId)){
                mapAccountContactRoles.put(objAccountContactRole.contactId, objAccountContactRole);
                mapContactRoles.put(objAccountContactRole.contactId, New Set<String> {objAccountContactRole.Role != null ? objAccountContactRole.Role.remove('Airtime') : null});
            }else{
                mapContactRoles.get(objAccountContactRole.contactId).add(objAccountContactRole.Role != null ? objAccountContactRole.Role.remove('Airtime') : null);
            }
        }
        
        
        for(Id StrKey : mapBillingContactRoles.keySet()){
            Billing_Contact_Role__c objBillingContactRoleTemp = mapBillingContactRoles.get(StrKey);
            if(BillAccToActSubs.containsKey(objBillingContactRoleTemp.Billing_Account__c)){
                for(Id strKeyOrder : BillAccToActSubs.get(objBillingContactRoleTemp.Billing_Account__c)){
                    Activation_Contact__c ActCon = New Activation_Contact__c();
                    ActCon.Salutation__c=objBillingContactRoleTemp.contact__r.Salutation;
                    ActCon.First_Name__c=objBillingContactRoleTemp.contact__r.FirstName;
                    ActCon.Last_Name__c=objBillingContactRoleTemp.contact__r.LastName;
                    ActCon.Job_Function__c=objBillingContactRoleTemp.contact__r.Job_Function__c;
                    ActCon.Account__c = objBillingContactRoleTemp.Billing_Account__r.name;  
                    ActCon.Contact__c=objBillingContactRoleTemp.Contact__c;
                    ActCon.Primary_Phone__c=objBillingContactRoleTemp.contact__r.Phone;
                    ActCon.Primary_Phone_Type__c = 'Business';
                    ActCon.Secondary_Phone__c =objBillingContactRoleTemp.contact__r.MobilePhone;
                    Set<String> setRoles = (!mapBillContactRoles.isEmpty() && mapBillContactRoles.containsKey(StrKey) && mapBillContactRoles.get(StrKey) != null) ? mapBillContactRoles.get(StrKey) : New Set<String>();
                    String strTempContactRole = '';
                    for(String strRole : setRoles){
                        strTempContactRole += strRole +',';
                    }
                    ActCon.Contact_Role__c= strTempContactRole != '' ? strTempContactRole.removeEnd(',') : '';
                    ActCon.Activation_Order__c= strKeyOrder;
                    ActCon.Email__c=objBillingContactRoleTemp.contact__r.Email;
                    ActCon.Address_1__c=objBillingContactRoleTemp.contact__r.MailingStreet;
                    ActCon.City__c=objBillingContactRoleTemp.contact__r.MailingCity;
                    ActCon.Postal_Zip_Code__c=objBillingContactRoleTemp.contact__r.MailingPostalCode;
                    ActCon.State__c=objBillingContactRoleTemp.contact__r.MailingState;
                    ActCon.Country__c=objBillingContactRoleTemp.contact__r.MailingCountry;
                    ActContLst.add(ActCon);
                }
            }
        }
        
        for(Id StrKey : mapAccountContactRoles.keySet()){
            AccountContactRole objAccountContactRole = mapAccountContactRoles.get(StrKey);
            if(AccToActSubs.containsKey(objAccountContactRole.AccountId)){
                for(Id strKeyOrder : AccToActSubs.get(objAccountContactRole.AccountId)){
                    Activation_Contact__c ActCon=new Activation_Contact__c();
                    ActCon.Salutation__c=objAccountContactRole.contact.Salutation;
                    ActCon.First_Name__c=objAccountContactRole.contact.FirstName;
                    ActCon.Last_Name__c=objAccountContactRole.contact.LastName;
                    ActCon.Job_Function__c=objAccountContactRole.contact.Job_Function__c;
                    ActCon.Account__c = objAccountContactRole.account.name;  
                    ActCon.Contact__c=objAccountContactRole.ContactId;
                    ActCon.Primary_Phone__c=objAccountContactRole.contact.Phone;
                    ActCon.Primary_Phone_Type__c = 'Business';
                    ActCon.Secondary_Phone__c =objAccountContactRole.contact.MobilePhone;
                    /* Set<String> setRoles = (!mapContactRoles.isEmpty() && mapContactRoles.containsKey(StrKey) && mapContactRoles.get(StrKey) != null) ? mapContactRoles.get(StrKey) : New Set<String>();
                    String strTempContactRole = '';
                    for(String strRole : setRoles){
                    strTempContactRole += strRole +',';
                    }
                    ActCon.Contact_Role__c= strTempContactRole != '' ? strTempContactRole.removeEnd(',') : '';*/
                    ActCon.Activation_Order__c= strKeyOrder;
                    ActCon.Email__c=objAccountContactRole.contact.Email;
                    ActCon.Address_1__c=objAccountContactRole.contact.MailingStreet;
                    ActCon.City__c=objAccountContactRole.contact.MailingCity;
                    ActCon.Postal_Zip_Code__c=objAccountContactRole.contact.MailingPostalCode;
                    ActCon.State__c=objAccountContactRole.contact.MailingState;
                    ActCon.Country__c=objAccountContactRole.contact.MailingCountry;
                    ActContLst.add(ActCon);
                }
            }
        }
        
        if(ActContLst.size() >0)
            insert ActContLst;
    }
    
}