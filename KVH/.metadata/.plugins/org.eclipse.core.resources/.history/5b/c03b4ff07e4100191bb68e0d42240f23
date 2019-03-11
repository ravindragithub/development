public class CCDS_BaseHelper
{
    public static object GetAuthenticationByType(string WsdlType)
    {
        if(String.isEmpty(WsdlType)) return null;
               
        /* refactor BaseHelper to get Password from Securities sObject jthom 1/7/15 */
        
        Security__c keyRing = new Security__c();
        keyRing = [SELECT Name, key__c FROM Security__c WHERE Name = 'CCDS' LIMIT 1];
        string password = keyRing.Key__c;
        
        string clientInitials = Global_Variable__c.getInstance('Webtop_ClientInitials').Value__c;
        // string password = Global_Variable__c.getInstance('Webtop_Password').Value__c;		//replaced... see above
        string userName = Global_Variable__c.getInstance('Webtop_Username').Value__c;       
        string version = Global_Variable__c.getInstance('Webtop_Version').Value__c;
        string application = Global_Variable__c.getInstance('Webtop_Application').Value__c;
        
        if(WsdlType == Global_Variable__c.getInstance('Webtop_WsdlType_Entity').Value__c){
            return new CCDS_Entity.Authentication(clientInitials, password, userName, version, application);
        }
        else if(WsdlType == Global_Variable__c.getInstance('Webtop_WsdlType_Customer').Value__c){
            return new CCDS_Customer.Authentication(application, clientInitials, password, userName, version);
        }
        else if(WsdlType == Global_Variable__c.getInstance('Webtop_WsdlType_Inventory').Value__c){
            return new CCDS_Inventory.Authentication(clientInitials, password, userName, version, application);
        }
        else if(WsdlType == Global_Variable__c.getInstance('Webtop_WsdlType_Corporate').Value__c){
            return new CCDS_Corporate.Authentication(clientInitials, password, userName, version, application);
        }else{
           return null; 
        } 
    }
    
    public static object GetWebtopValue(string objectName, string label)
    {
        if(string.isEmpty(objectName) || string.isEmpty(label))
       {
            System.Debug('Settings: ObjectName = ' + objectName);
            System.Debug('Settings: Label = ' + label);            
       }
        
       Sobject o = Database.Query('SELECT Value__c FROM ' + ObjectName + ' WHERE Label__c =: label');
        
       return o.get('Value__c');
    }
    
     public static Integer GetEnvironmentType()
    {
       integer i = integer.valueOf(Global_Variable__c.getInstance('Webtop_Environment').Value__c); 
       
       return i;        
    }
}