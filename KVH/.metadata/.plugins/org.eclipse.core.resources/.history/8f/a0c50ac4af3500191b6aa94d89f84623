/******************************************************
    Name        :       AgilePlans_attachSiteSurveyCtrl
    Description :       controller for AgilePlans_attachsitesurvey
                        to attach sales order to the case
*******************************************************/
public class AgilePlans_attachSiteSurveyCtrl{
    public boolean showform{get;set;}
    public List<Case> caselist{get;set;}
    public Case caseObj{get;set;}
    public Attachment siteSurvey{get;set;}
   
    ID oppId;
    public AgilePlans_attachSiteSurveyCtrl(Apexpages.standardcontroller ctrl){
        oppId = ctrl.getId();
        init();
    }   
    
    public void init(){
        siteSurvey = new Attachment();
        caseObj = new Case();
        
        caselist = [Select id,New_Vessel_or_Platform__c,status from Case where Related_Opportunity__c =: oppId 
                        AND (Status = 'Pending Site Survey' OR Status = 'Pending Sales Order and Site Survey') limit 1000];
        showform = caselist.size()>0 ? true : false;
    } 
    
    public pagereference back(){
        return new pagereference('/'+oppId);
    }
    
    public pagereference submit(){
        System.debug('@@ '+caseObj.Id);
        if(!validaton()){
            caseObj.AgilePlans_Site_Survey_Attached__c = true;
            update caseObj;
            
            if(siteSurvey.body != null){
                siteSurvey.parentId = caseObj.Id;
                insert siteSurvey;
            }
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.confirm,'site survey successfully updated.'));
            init();
        }
        caseObj.Id = null;
        siteSurvey = new Attachment();
        return null;
    }
    
    private boolean validaton(){
        boolean isError = false;
        if(caseObj.Id == null || String.valueOf(caseObj.Id).length() == 0){
            isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select vessel.'));
        }
        if(siteSurvey.body == null){
            isError = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Site Survey required.'));
        }
        return isError;
    }
}