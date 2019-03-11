public with sharing class AWSFileURLGenrationCtrl{
    Set<ID> docProdIds = new Set<ID>();
    string loginuserMail;
    string retURL;

    public AWSFileURLGenrationCtrl(Apexpages.standardsetcontroller ctrl){
      retURL = ApexPages.currentPage().getParameters().get('retURL');
       
        System.debug('@@ '+ctrl.getSelected());
        loginuserMail = userinfo.getUserEmail();
        for(Prod_Documents__c doc : (List<Prod_Documents__c>)ctrl.getSelected()){
            docProdIds.add(doc.Id);
        }
        
    }
    
    public void startbatch(){
        try{
            System.debug('@@ docProdIds'+docProdIds);
            if(docProdIds.size()>0){
                GenerateAWSSignedURLBatch batch = new GenerateAWSSignedURLBatch(docProdIds,loginuserMail);
                Database.executebatch(batch,10);
                ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.confirm, 'Batch job successfully started, we will mail when batch job will finish.');
                ApexPages.addMessage(apexMessage);
            }else{
                ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.Error, 'Please select at least one document.');
                ApexPages.addMessage(apexMessage);
            }
        }catch(Exception ex){
            ApexPages.Message apexMessage = new ApexPages.Message(ApexPages.Severity.Error, ex.getmessage());
            ApexPages.addMessage(apexMessage);
        }
    }
    
    public Pagereference redirectToListview(){
        return new Pagereference(retURL);
    }
}