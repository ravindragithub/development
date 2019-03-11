/**********************************************************
    Name        :        AgilePlans_Attach_SiteSurveyCtrl
    Description :        controller for AgilePlans_Attach_SiteSurvey
                        which attaching site survey for the case
**********************************************************/
public Class AgilePlans_Attach_SiteSurveyCtrl{
    public Attachment sitesurvey{get;set;}
    
    private String caseId;
    public AgilePlans_Attach_SiteSurveyCtrl(Apexpages.standardcontroller ctrl){
        caseId = ctrl.getID();
        init();
    }
    
    private void init(){
        sitesurvey = new Attachment();        
    }
    
    public PageReference submit(){
        if(!validation()){
            Case caseObj = new Case(id = caseId);
            caseObj.AgilePlans_Site_Survey_Attached__c = true;
            update caseObj;
            
            sitesurvey.parentId = caseObj.Id;
            insert sitesurvey;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'Site survey successfully attached.'));
            
        }
        init();
        return null;
    }
    
    public Pagereference back(){
        return new Pagereference('/'+caseId);
    }
    
    private boolean validation(){
        boolean isError = false;
        if(sitesurvey.body == null){
            isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Site survey is required.'));
        }
        return isError;
    }
}