/**
* @createdby        :   Teertha prasad
* @createddate      :   04/06/2017
* @last modifiedby  :   Teertha prasad
* @last modifieddate:   04/07/2017
* @description      :   Class Used In Flow to Validate and Insert SBQQ UserPackageLicense Record
**/
public without sharing class SBQQPackageAutoAsignController{
    @InvocableMethod(label='Validate and Insert SBQQ UserPackageLicense' description='Validate and Insert SBQQ UserPackageLicense Record')
    public static void validateRecord(List<User> lstUsers) {
        if(lstUsers.size()>0){
            List<UserPackageLicense> lstUserPackageLicenses = New List<UserPackageLicense>();
            try{
                UserPackageLicense objUserPackageLicense = new UserPackageLicense();
                objUserPackageLicense.PackageLicenseId = [SELECT Id, NamespacePrefix, AllowedLicenses, UsedLicenses,ExpirationDate,Status FROM PackageLicense WHERE NamespacePrefix = 'SBQQ'].Id;
                objUserPackageLicense.UserId = lstUsers[0].Id;
                lstUserPackageLicenses.add(objUserPackageLicense);
                insert lstUserPackageLicenses;
            }catch(Exception E){
                system.debug('exception' +E);
            }
        }
    }
}