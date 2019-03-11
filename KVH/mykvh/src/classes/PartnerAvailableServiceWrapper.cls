/**
 * Created by Jai Chaturvedi on 11/03/2017.
 */

public class PartnerAvailableServiceWrapper {
    @AuraEnabled public String serviceLabel { get; set; }
    @AuraEnabled public Boolean available { get; set; }
    @AuraEnabled public user currentUser { get; set; }

    public PartnerAvailableServiceWrapper(String serviceLabel, Boolean available,User currentUser){
        this.serviceLabel = serviceLabel ;
        this.available = available ;
        this.currentUser = currentUser;
    }
}