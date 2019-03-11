public class myKVH_SupportCenterExportController{
    
    public List<Case> lstOfCases{get;set;}
    public string caseType{get;set;}
    public string caseStatus{get;set;}
    
    public myKVH_SupportCenterExportController(){ 
        List<string> statuslst = apexPages.currentPage().getParameters().get('caseStatus').split(';');
        casestatus = json.serializePretty(statuslst);
        if(apexPages.currentPage().getParameters().get('caseType')!=''){
            List<string> strList = apexPages.currentPage().getParameters().get('caseType').split(';');
            caseType = json.serializePretty(strList);
        }
        else{
            caseType = ''; 
        }
    }
    public void loaddata(){  
        lstOfCases = myKVH_SupportCenterController.getCaseRecords(caseStatus,caseType,'CaseNumber',false);
    }
    public void loadDataParent(){         
    }
}