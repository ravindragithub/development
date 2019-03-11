public class DistanceWrapper implements Comparable{
    @AuraEnabled public Integer srnumber {get;set;}
    @AuraEnabled public Set<String> productId {get;set;}
    @AuraEnabled public Account account {get;set;}
    @AuraEnabled public Id accountId {get;set;}
    @AuraEnabled public Integer durationInSeconds {get;set;}
    @AuraEnabled public String distance {get;set;}
    @AuraEnabled public String duration {get;set;}
    @AuraEnabled public String desination {get;set;}
    @AuraEnabled public String CSN {get;set;}
    @AuraEnabled public Boolean Sales {get;set;}
    @AuraEnabled public Boolean ServicesOnly {get;set;}
    @AuraEnabled public String accountRecordType {get;set;}
    
    public DistanceWrapper(){}
    
    public DistanceWrapper(Set<String> productId, Account account, Id accountId, String CSN, Boolean Sales, Boolean ServicesOnly, String distance, Integer durationInSeconds, String duration, String desination){
        this.productId = productId;
        this.account = account;
        this.accountId = accountId;
        this.CSN = CSN;
        this.Sales = Sales;
        this.ServicesOnly = ServicesOnly;
        this.durationInSeconds = durationInSeconds;
        this.distance = distance;
        this.duration = duration;
        this.desination = desination;
        this.accountRecordType = account.recordType.name;
    }
    
    public DistanceWrapper(Set<String> productId, Account account, Id accountId, String CSN, Boolean Sales, Boolean ServicesOnly){
        this.productId = productId;
        this.account = account;
        this.accountId = accountId;
        this.CSN = CSN;
        this.Sales = Sales;
        this.ServicesOnly = ServicesOnly;
        this.durationInSeconds = 0;
        this.accountRecordType = account.recordType.name;
    }
    
   /* public Integer compareTo(Object obj) {
        System.debug('DistanceWrapper-CompareTo');
        DistanceWrapper dw = (DistanceWrapper)(obj);
        if (this.account.Partner_Role__c > dw.account.Partner_Role__c){
            return 1;
        }else if (this.account.Partner_Role__c == dw.account.Partner_Role__c){
            Map<String, Integer> csnLevel = new Map<String, Integer>();
            csnLevel.put('Master', 1);
            csnLevel.put('Advanced', 2);
            csnLevel.put('Basic', 3);
            if (csnLevel.get(this.CSN) > csnLevel.get(dw.CSN)){
                return 1;
            }else if (csnLevel.get(this.CSN) == csnLevel.get(dw.CSN)){
                if (this.durationInSeconds > dw.durationInSeconds){
                    return 1;
                }else if (this.durationInSeconds == dw.durationInSeconds){
                    if (this.account.Name > dw.account.Name){
                        return 1;
                    }else if (this.account.Name == dw.account.Name){
                        return 0;
                    }else{
                        return -1;
                    }
                }else{
                    return -1;
                }
            }else{
                return -1;
            }
        }else{
            return -1;
        }
    }*/
    
    public Integer compareTo(Object obj) {
        DistanceWrapper dw = (DistanceWrapper)(obj);
     
        
        if(WhereToBuyController.searchType == 'WhereToBuy'){
             
             if (this.accountRecordType == 'Indirect Partner'){
                 return 1;
             }else if(this.accountRecordType == dw.accountRecordType){
                Map<String, Integer> csnLevel = new Map<String, Integer>();
                csnLevel.put('Master', 1);
                csnLevel.put('Advanced', 2);
                csnLevel.put('Basic', 3);
                if (csnLevel.get(this.CSN) > csnLevel.get(dw.CSN)){
                    return 1;
                }else if (csnLevel.get(this.CSN) == csnLevel.get(dw.CSN)){
                    if (this.durationInSeconds > dw.durationInSeconds){
                        return 1;
                    }else if (this.durationInSeconds == dw.durationInSeconds){
                        if (this.account.Name > dw.account.Name){
                            return 1;
                        }else if (this.account.Name == dw.account.Name){
                            return 0;
                        }else{
                            return -1;
                        }
                    }else{
                        return -1;
                    }
                }else{
                   return -1;
                }
             }else{
                 return -1;
             }
        }else{
            Map<String, Integer> csnLevel = new Map<String, Integer>();
            csnLevel.put('Master', 1);
            csnLevel.put('Advanced', 2);
            csnLevel.put('Basic', 3);
            if (csnLevel.get(this.CSN) > csnLevel.get(dw.CSN)){
                return 1;
            }else if (csnLevel.get(this.CSN) == csnLevel.get(dw.CSN)){
                if (this.accountRecordType == 'Indirect Partner'){
                    return 1;
                }else if(this.accountRecordType == dw.accountRecordType){
                    if (this.durationInSeconds > dw.durationInSeconds){
                        return 1;
                    }else if (this.durationInSeconds == dw.durationInSeconds){
                        if (this.account.Name > dw.account.Name){
                            return 1;
                        }else if (this.account.Name == dw.account.Name){
                            return 0;
                        }else{
                            return -1;
                        }
                    }else{
                        return -1;
                    }
                }else{
                    return -1;
                }
            }else{
                return -1;
            }
        }        
    }
}