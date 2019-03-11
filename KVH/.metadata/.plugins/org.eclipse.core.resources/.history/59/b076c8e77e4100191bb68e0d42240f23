public class Act_OpenPort_Component_Ctrl{
    
    public Activation_Service__c objActivationService ;
    private static String 	strPlanName 	=	'Iridium OpenPort Backup';
    public String strFeatureIds 	{get; set;} 
    
    public void setobjActivationService(Activation_Service__c ActivationService){
        if(objActivationService == null){ 
            objActivationService = ActivationService;
            String strProductbundleId = Activation_Product_Bundle__c.getValues(strPlanName).Product_Bundle_Id__c;
            for(SBQQ__ProductFeature__c objProductFeature : [SELECT Id,Name FROM SBQQ__ProductFeature__c WHERE SBQQ__ConfiguredSKU__c =: strProductbundleId ORDER BY SBQQ__Number__c]){
                strFeatureIds = (strFeatureIds == null ? String.valueOf(objProductFeature.Id) : (strFeatureIds + '@@' + String.valueOf(objProductFeature.Id)));
            }
            strFeatureIds = strFeatureIds.removeEnd('@@');
        }
    }
    
    public Activation_Service__c getobjActivationService(){
        return objActivationService; 
    }
    
    
    /** Constructor - Start **/
    public Act_OpenPort_Component_Ctrl(){
    }
    /** Constructor - End **/
    
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   11/08/2016
* @description          :   updateActivationServiceopenport Method.
*                           Upsert Activation Service
* @return               :   void
* @invoke               :   From action method of Vf page
**/
    public pagereference updateActivationServiceopenport(){
        update objActivationService; 
        return null;
    }
  
    /**
* @last modified by     :   Teertha prasad
* @last modified date   :   09/20/2016
* @description          :   clearActivationService Method.
*                           Upsert Activation Service
* @return               :   void
* @invoke               :   From action method of Vf page
**/
    public pagereference clearActivationService(){
        objActivationService.Iridium_OpenPort_Selected__c = false;
        objActivationService.Iridium_OpenPort_Product__c = null;
        objActivationService.Pilot_Firmware_Version__c = '';
        objActivationService.Pilot_IMEI_Number__c = '';
        objActivationService.Pilot_SIM_Card_Number__c = '';
        update objActivationService; 
        return null;
    }

}