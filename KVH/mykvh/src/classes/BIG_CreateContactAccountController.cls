public with sharing class BIG_CreateContactAccountController {
    /*Version 1 created and deployed by Black Iron Group
    * 
    * Version 2 modified by John Thompson 10/18/2010
    * Added tryagain() button click handler to controller
    * and corresponding button to VF page
    */    
    private string status;
    private Account a;
    private Contact c;
    
    
    
    public BIG_CreateContactAccountController()
    {
        
        a=null;
        c = new Contact();
        
    }
    
    public Contact getContact()
    {
        return c;
        
        
    }
    
    public void setContact(Contact t_c)
    {
        c=t_c;
        
    }
    
    public string getAccountCreated()
    {
        if(a!=null)
            return 'true';
        else return 'false';
    
    }
    
    public string getAccountLink()
    {
        if(a!=null)
        {
            return '/'+a.id;
            
        }
        else return null;
    }

    
    public PageReference Reset()
    {
        
        a=null;
        c= new Contact();
        ApexPages.getMessages().clear();
        return null;
    
    }
    
    public PageReference tryagain()
    // Version 2, new handler
    // new button to provide agents with a second chance
    // if the insert actions throw an exception
    // derived from Reset()
    {
    
        a=null;
        //c= new Contact(); Please do not clear the existing data
        ApexPages.getMessages().clear();
        return null;
  
    }
    
    public PageReference Submit()
    {
        try
        {
            List<RecordType> r_type= [SELECT ID,Name FROM RecordType WHERE DeveloperName='Indirect_Customer' and sobjectType='Account'];
            
            a=new Account();
            a.Name= c.FirstName+' '+c.LastName;
            a.Phone=c.Phone;
            a.BillingStreet=c.MailingStreet;
            a.BillingCity=c.MailingCity;
            a.BillingState=c.MailingState;
            a.BillingCountry=c.MailingCountry;
            a.BillingPostalCode=c.MailingPostalCode;
            a.Account_Status__c='Active';
            if(!r_type.isEmpty()) a.RecordTypeId=r_type[0].id;
            
            insert a;
        
            c.AccountId=a.id;
        
            insert c;
            status='The Account has been created';
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'The account has been created');
            ApexPages.addMessage(myMsg);
            PageReference contpage = new ApexPages.Standardcontroller(c).view();
            contpage.setRedirect(true);
            return contpage;
            //return null;
        }
        catch(Exception e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
            
        }
        
    }
    
    
    static testMethod void BIG_CretaeContactAccountController_Test()
    {
        
        String s;
        BIG_CreateContactAccountController cont = new BIG_CreateContactAccountController();
        
        s=cont.getAccountLink();
        s=cont.getAccountCreated();
        
        Contact c = new Contact();
        c.FirstName='firstname';
        c.LastName='lastname';
        c.Job_Function__c='test';
        c.Phone='555-555-5555';
        c.MobilePhone='666-666-6666';
        c.Email='blah@blah.com';
        c.MailingStreet='mailingstreet';
        c.MailingCity='NYC';
        c.MailingState='NY';
        c.MailingCountry='USA';
        C.MailingPostalCode='11201';
        
        cont.setContact(c);
        
        cont.Submit();
        
        c=cont.getContact();
        s=cont.getAccountLink();
        s=cont.getAccountCreated();
        cont.Reset();
        
        c=[SELECT ID,AccountID from Contact where id=:c.id];
        System.assert(c.AccountID!=null);
        
        c = new Contact();
        c.FirstName='firstname';
        c.LastName='lastname';
        c.Job_Function__c='test';
        c.Phone='555-555-5555';
        c.MobilePhone='666-666-6666';
        c.Email='blah@blah.com...aaa';
        c.MailingStreet='mailingstreet';
        c.MailingCity='NYC';
        c.MailingState='NY';
        c.MailingCountry='USA';
        C.MailingPostalCode='11201';
        
        cont.setContact(c);
        
        cont.Submit();
    
        
        
    }
    

}