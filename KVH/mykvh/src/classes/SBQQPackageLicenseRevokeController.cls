/**
* @createdby        :   Teertha prasad
* @createddate      :   04/10/2017
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   04/10/2017
* @description      :   Class Used In Apex Scheduler to Validate and revoke SBQQ UserPackageLicense Record from User
**/
global class SBQQPackageLicenseRevokeController Implements Schedulable {
    
    global void execute(SchedulableContext objSchedulableContext){
        validateAndRevokeSBQQLicense();
    }
    
    private void validateAndRevokeSBQQLicense(){
        Map<Id, UserPackageLicense> mapUserPackageLicenseToUser = New Map<Id, UserPackageLicense>();
        for(UserPackageLicense objUserPackageLicense : [SELECT Id,UserId FROM UserPackageLicense 
                                                        WHERE UserId IN (SELECT Id FROM User WHERE Profile.UserLicense.Name = 'Overage Customer Portal Manager Custom') 
                                                        AND PackageLicenseId IN (SELECT Id FROM PackageLicense WHERE NamespacePrefix = 'SBQQ')]){
                                                            mapUserPackageLicenseToUser.put(objUserPackageLicense.UserId,objUserPackageLicense);
                                                        }
        
        Set<Id> setUserIds = New Set<Id>();
        for(AuthSession objAuthSession : [SELECT UsersId FROM AuthSession 
                                          WHERE UsersId IN: mapUserPackageLicenseToUser.keySet()]){
                                              setUserIds.add(objAuthSession.UsersId);
                                          }
        system.debug('setUserIds' + setUserIds);
        if(!mapUserPackageLicenseToUser.isEmpty() && !setUserIds.isEmpty()){
            mapUserPackageLicenseToUser.keySet().removeAll(setUserIds);
        }
        
        if(!mapUserPackageLicenseToUser.isEmpty()){
            system.debug('mapUserPackageLicenseToUser' +mapUserPackageLicenseToUser.values());
            delete mapUserPackageLicenseToUser.values();
        }
    }
}