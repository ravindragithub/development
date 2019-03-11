public class mykvh_ChangePasswordSuccessClass {
        
    public String destination {get; set;}      
    public String serialnumber {get; set;}      
    public mykvh_ChangePasswordSuccessClass(){
        user theUser = [SELECT Id, Name,Destination__c,Serial_Number__c from user where Id =: UserInfo.getUserId() LIMIT 1];
        destination = string.valueof(theUser.Destination__c);
        serialnumber = string.valueof(theUser.Serial_Number__c);
    }
}