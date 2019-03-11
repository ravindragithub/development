trigger CaseTrigger on Case (before insert, before update, after insert, after update) 
{
    List<Case> records = trigger.isDelete ? trigger.old : trigger.new;
    
    if(Trigger.isBefore){
        if(Trigger.isInsert || Trigger.isUpdate){
            
            UCase.setAccount(records, trigger.oldMap); 
            
            //Method from ValidateCaseCountryFields trigger consolidate in this trigger by Gopi
            
            pw_ccpro.CountryValidator2.Validate(Trigger.new, Trigger.oldMap);
            
            //Assiging Values if Asset not available :(line 11 to 21 code written by Gopi)
            
           set<ID> passIds            = new set<ID>(); 
           set<ID> platformAccountIds = new Set<ID>();
           
            for(Case allcases:Trigger.new){
                if(allcases.AssetID==null){
                    passIds.add(allcases.Modem_IP_2__c);
                }
                
                if(allcases.AccountID == null && allcases.Platform_Asset_Account__c != null && allcases.RecordTypeID == system.label.KV_Support_RT){
                    platformAccountIds.add(allcases.Platform_Asset_Account__c);
                }
            } 
            Map<ID,ID> checkTest = AssetStructure.GetTopMultipleElements(passIds);
            
            Map<ID,ID> findPlatformParentAccIds = UtilityCaseTrigger.findPlatformParentAccIds(platformAccountIds);
            
            for(Case allcases:Trigger.new){
                if(checkTest.containsKey(allcases.Modem_IP_2__c)){
                    allcases.AssetID = checkTest.get(allcases.Modem_IP_2__c);
                }
                if(findPlatformParentAccIds.containsKey(allcases.Platform_Asset_Account__c)){
                    allcases.AccountID = findPlatformParentAccIds.get(allcases.Platform_Asset_Account__c);
                }
            } 
            
           /* for(Case allcases:Trigger.new){
                if(allcases.AssetID == null && allcases.Modem_IP_2__c != null){
                    AssetStructure assetCreate = new AssetStructure();
                    allcases.AssetID = assetCreate.GetTopElement(allcases.Modem_IP_2__c);
                }
             }*/
        }
    }
    else if(Trigger.isAfter){
        if(Trigger.isInsert || trigger.isUpdate){
            UCase.UpdateAssetAccountNameText(records, trigger.oldMap);       
        }
    }
}