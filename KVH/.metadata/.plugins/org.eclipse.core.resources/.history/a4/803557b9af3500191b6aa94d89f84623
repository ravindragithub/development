public class Act_Operation_Data_Controller{
    
    public List<String> setIndividualBundles {
        get { 
            List<String> lstTemp = New List<String>();
            String strProductbundleId = Activation_Product_Bundle__c.getValues('Operation Data').Product_Bundle_Id__c;
            for(SBQQ__ProductFeature__c objProductFeature : [SELECT Id,Name FROM SBQQ__ProductFeature__c WHERE SBQQ__ConfiguredSKU__c =: strProductbundleId ORDER BY SBQQ__Number__c]){
                lstTemp.add(objProductFeature.Id);
            }
            return lstTemp;
        } 
            set;
    }

    public Activation_Service__c objActivationService ;
    public void setobjActivationService(Activation_Service__c ActivationService){
        if(objActivationService == null){ 
            objActivationService = ActivationService;
        }
    }
    
    public Activation_Service__c getobjActivationService(){
        return objActivationService; 
    }
    
    
    /** Constructor - Start **/
    public Act_Operation_Data_Controller(){
    }
    /** Constructor - End **/
    
    /**
    * @last modified by     :   Teertha prasad
    * @last modified date   :   09/20/2016
    * @description          :   updateActivationServiceValueOperation Method.
    *                           Upsert Activation Service
    * @return               :   void
    * @invoke               :   From action method of Vf page
    **/
    public pagereference updateActivationServiceValueOperation(){
        update objActivationService; 
        return null;
    }

}