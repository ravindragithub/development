/***************************************************************************************************************************
Class:        Act_Contact_Handler  
----------------------------------------------------------------------------------------------------------------------------
Author:        
Created Date:  08/02/2017
Reason:        This UtilityClass is used to Validate that First Name, Last Name and Phone Number match the contact found.if not
update Review_Contact_Detail__c checkbox to True.     
***************************************************************************************************************************/
public class Act_Contact_Handler {
    
    public static void onBefore(list<Activation_Contact__c> lstActivationContacts){
        Set<String> setActivationContactEmails = New Set<String>();
        
        for(Activation_Contact__c objActivationContact : lstActivationContacts){
            if(objActivationContact.Email__c != Null)  
                setActivationContactEmails.add(objActivationContact.Email__c); 
        } 
        
        Map<String, Contact> mapContacts = New Map<String, Contact>();    
        for(Contact objContact : [SELECT FirstName, LastName, Phone, Email FROM Contact  WHERE Email IN: setActivationContactEmails]){
            if(!mapContacts.containsKey(objContact.Email)){
                mapContacts.put(objContact.Email, objContact);   
            }   
        }
        
        for(Activation_Contact__c objActivationContact : lstActivationContacts){
            if(objActivationContact.Contact__c == Null)
                objActivationContact.Contact__c =  (!mapContacts.isEmpty() && mapContacts.containsKey(objActivationContact.Email__c) ? mapContacts.get(objActivationContact.Email__c).Id : objActivationContact.Contact__c);
            objActivationContact.Review_Contact_Detail__c = (!mapContacts.isEmpty() && mapContacts.containsKey(objActivationContact.Email__c) && ((objActivationContact.First_Name__c != mapContacts.get(objActivationContact.Email__c).FirstName)
                                                             || (objActivationContact.Last_Name__c != mapContacts.get(objActivationContact.Email__c).LastName) 
                                                             || (objActivationContact.Primary_Phone__c != mapContacts.get(objActivationContact.Email__c).Phone)) 
                                                             || (objActivationContact.First_Name__c == null) || (objActivationContact.Last_Name__c == null) 
                                                             || (objActivationContact.Primary_Phone__c == null) ? true : false);
        }
    }
}