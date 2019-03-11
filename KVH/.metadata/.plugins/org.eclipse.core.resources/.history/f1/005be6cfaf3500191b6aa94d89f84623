/**
* Created by Jai Chaturvedi on 8/03/2017.
*/

public without sharing class CommunityUtilityClass {
    
    @AuraEnabled
    public static void setPortalviewForLoginUser(String portalOption){
        User userRec = [SELECT
                    Id,
                    Portal_View__c
            FROM User
            WHERE Id = :UserInfo.getUserId()
            LIMIT 1];
            if((String.isNotBlank(userRec.Portal_View__c) &&
                    !userRec.Portal_View__c.equalsIgnoreCase(portalOption)) ||
                    String.isBlank(userRec.Portal_View__c)){
                userRec.Portal_View__c = portalOption;
                update userRec ;
            }
    }
    
    @AuraEnabled
    public static List<PartnerMainServiceWrapper> constructTopOptions(
            String portalOption,
            String fieldAPINames){

        String fieldapi = ''  ;
        for(String s : fieldAPINames.split(';')){
            fieldapi =   fieldapi + s.substringAfter('-')  +  ', ' ;
        }
        //fieldapi = fieldapi.removeEnd(',');
        system.debug(fieldapi) ;

        String query = 'SELECT  '  + fieldapi +
                ' MasterLabel, Color_Code__c,Color_Code_hover__c' +
                ' FROM Partner_Portal_Views__mdt' +
                ' WHERE MasterLabel = \'' + portalOption + '\'' ;
        system.debug(query) ;

        List<String> availableService = new List<String>();
        Map<String, String> colorMap = new Map<String, String>();
        Map<String, String> colorhoverMap = new Map<String, String>();

        for(Partner_Portal_Views__mdt ppv : Database.query(query)){
            String colorTemp = (String)ppv.get('Color_Code__c') ;
            if(String.isNotBlank(colorTemp)){
                for(String s : colorTemp.split(';')){
                    colorMap.put(s.substringBefore('-'), s.substringAfter('-')) ;
                }
            }
            String colorhoverTemp = (String)ppv.get('Color_Code_hover__c') ;
            if(String.isNotBlank(colorhoverTemp)){
                for(String s : colorhoverTemp.split(';')){
                    colorhoverMap.put(s.substringBefore('-'), s.substringAfter('-')) ;
                }
            }

            for(String s : fieldAPINames.split(';')){
                if((Boolean)ppv.get(s.substringAfter('-'))){
                    availableService.add(s.substringBefore('-')) ;
                }
            }
        }
        system.debug('***colorMap.keySet()***'+colorMap.keySet()) ;

        List<PartnerMainServiceWrapper> availableServiceList =
                new List<PartnerMainServiceWrapper>();

        for(Partner_Portal_Services_Config__mdt p : [
                SELECT
                        MasterLabel,
                        Button_Label__c,
                        Description__c,
                        Icon_Name__c,Custom_Icon_Name__c,
                        Link_URL__c,
                        Display_Order__c
                FROM Partner_Portal_Services_Config__mdt
                WHERE MasterLabel IN : availableService
                ORDER BY Display_Order__c ]){

            String colorCode ='';
            if(colorMap.containsKey(p.MasterLabel)){
                colorCode = colorMap.get(p.MasterLabel) ;
            }
            String colorCodehover = '';
            
            if(colorhoverMap.containsKey(p.MasterLabel)){
                colorCodehover = colorhoverMap.get(p.MasterLabel) ;
            }
            PartnerMainServiceWrapper pmsw =
                    new PartnerMainServiceWrapper(p.MasterLabel,
                            colorCode,colorCodehover,
                            p.Button_Label__c,
                            p.Description__c,
                            p.Icon_Name__c,p.Custom_Icon_Name__c,
                            p.Link_URL__c
                    );

           /* User userRec = [SELECT
                    Id,
                    Portal_View__c
            FROM User
            WHERE Id = :UserInfo.getUserId()
            LIMIT 1];
            if((String.isNotBlank(userRec.Portal_View__c) &&
                    !userRec.Portal_View__c.equalsIgnoreCase(portalOption)) ||
                    String.isBlank(userRec.Portal_View__c)){
                userRec.Portal_View__c = portalOption;
                update userRec ;
            }*/

            availableServiceList.add(pmsw) ;
        }

        return availableServiceList ;
    }

    @AuraEnabled
    public static Map<String,Object> initPortalView(){
        Map<String,Object> portalViewMap = new Map<String,Object>();

        List<PortalOptionsWrapper> PortalOptionsWrapperList = new List<PortalOptionsWrapper>();

        User userRec = [
                SELECT
                        Id,
                        AccountId,contactId,
                        Portal_View__c,Default_Account_ID__c
                FROM User
                WHERE Id =: UserInfo.getUserId()
                LIMIT 1
        ];
        String selectedPortalView = '';

        Id accountId = userRec.AccountId != null ? userRec.AccountId : userRec.Default_Account_ID__c;
        String portalView = '';
        if(String.isNotBlank(userRec.Portal_View__c)){
            portalView = userRec.Portal_View__c;
            selectedPortalView = portalView;
        }

        Map<String,String> serviceNamesColorCodeMap = new Map<String,String>();
        Map<String,String> serviceNamesbgImageMap = new Map<String,String>();

        for(Partner_Portal_Views__mdt p : [
                SELECT
                        MasterLabel,
                        Background_Color__c,Service_Component_Background_Image__c
                FROM
                        Partner_Portal_Views__mdt]){
            serviceNamesColorCodeMap.put(p.MasterLabel, p.Background_Color__c) ;
            serviceNamesbgImageMap.put(p.MasterLabel, p.Service_Component_Background_Image__c);
        }
        
        Set<String> portalNameSet = new Set<String>();
        List<Account> acclst = [Select id,Portal_View_s__c from Account where ID =: accountId];
        if(acclst.size()>0 && acclst[0].Portal_View_s__c != null){
            for(String pv : acclst[0].Portal_View_s__c.split(';')){
                portalNameSet.add(pv.trim());
            }
        }
        //portalNameSet.add('Leisure Marine Systems');
        System.debug('@@ portalNameSet==>'+portalNameSet);
        
        if(portalNameSet.size()>0){
            for(String portalLabel : portalNameSet){                 
                 PortalOptionsWrapperList.add(new PortalOptionsWrapper(portalLabel, serviceNamesColorCodeMap.get(portalLabel),serviceNamesbgImageMap.get(portalLabel)));
            }
        }
        
        if(PortalOptionsWrapperList.size()>0)
            PortalOptionsWrapperList.sort() ;

        portalViewMap.put('portalViewOption', PortalOptionsWrapperList);
        portalViewMap.put('portalview', portalView);
        
        

       /* String objectName = 'Partner_Portal_Settings__c';
        List<Schema.DescribeSObjectResult> describeSobjectsResult =
                Schema.describeSObjects(new List<String>{objectName});

        String objectLabel = describeSobjectsResult[0].getLabel();
        Map<String, String> fieldAPINameLabelMap = new Map<String, String>();

        Map<String, Schema.SObjectField> allFields = describeSobjectsResult[0].fields.getMap();
        String strfieldName = '';
        for(Schema.SObjectField field : allFields.Values()) {
            Schema.DescribeFieldResult fieldResult = field.getDescribe();
            strfieldName += fieldResult.getName() + ',' ;
            Schema.DisplayType fieldType = fieldResult.getType();

            if(fieldType.name() == 'BOOLEAN' && serviceNamesColorCodeMap.keySet().contains(fieldResult.getLabel())){
                fieldAPINameLabelMap.put(fieldResult.getName(), fieldResult.getLabel()) ;
            }
        }
        strfieldName = strfieldName.substring(0, strfieldName.length()-1);
        String query = 'SELECT ' + strfieldName +
                ' FROM Partner_Portal_Settings__c' +
                ' WHERE Partner_Account__c = \'' + accountId + '\' ' ;
        system.debug(query) ;

        for(Partner_Portal_Settings__c ps: Database.query(query) ){
            for(String fieldApi : fieldAPINameLabelMap.keySet()){
                if((Boolean)ps.get(fieldApi)){
                    PortalOptionsWrapper pow =
                            new PortalOptionsWrapper(
                                    fieldAPINameLabelMap.get(fieldApi),
                                    serviceNamesColorCodeMap.get(fieldAPINameLabelMap.get(fieldApi))
                            ) ;
                    PortalOptionsWrapperList.add(pow) ;
                }
            }
        }
        system.debug('**PortalOptionsWrapperList***'+PortalOptionsWrapperList) ;
        PortalOptionsWrapperList.sort() ;

        portalViewMap.put('portalViewOption', PortalOptionsWrapperList);
        portalViewMap.put('portalview', portalView);*/
        
        //fetch login user's cart info
        UserCartWrapper cartinfo = fetchCartInfo(userRec);
        portalViewMap.put('cartinfo',cartinfo);
        
        //fetch the services
        if(String.isBlank(portalView)){
            selectedPortalView = PortalOptionsWrapperList[0].optionLabel;
        }
        List<PartnerAvailableServiceWrapper> availableSvc = constructServices(selectedPortalView);
        portalViewMap.put('availableSvc',availableSvc);
        
        return portalViewMap ;
    }

    @AuraEnabled
    public static List<PartnerAvailableServiceWrapper> constructServices(String selectedPortalView){
        List<PartnerAvailableServiceWrapper> tempList = new List<PartnerAvailableServiceWrapper>();

        String objectName = 'Partner_Portal_Views__mdt';
        List<Schema.DescribeSObjectResult> describeSobjectsResult =
                Schema.describeSObjects(new List<String>{objectName});

        String objectLabel = describeSobjectsResult[0].getLabel();
        Map<String, String> fieldAPINameLabelMap = new Map<String, String>();

        Map<String, Schema.SObjectField> allFields = describeSobjectsResult[0].fields.getMap();
        String strfieldName = '';
        for(Schema.SObjectField field : allFields.Values()) {
            Schema.DescribeFieldResult fieldResult = field.getDescribe();
            strfieldName += fieldResult.getName() + ',' ;

            Schema.DisplayType fieldType = fieldResult.getType();
            if(fieldType.name() == 'BOOLEAN'){
                fieldAPINameLabelMap.put(fieldResult.getName(), fieldResult.getLabel()) ;
            }

        }
        strfieldName = strfieldName.substring(0, strfieldName.length()-1);
        String query = 'SELECT ' + strfieldName + ' FROM Partner_Portal_Views__mdt WHERE MasterLabel = \'' + selectedPortalView + '\'' ;
        system.debug(query);
        Map<String, Boolean> finalMap = new Map<String, Boolean>();
        List<user> userlst = [Select id,name,myKVH_Role__c from User where id =: userinfo.getuserId()];
        for(Partner_Portal_Views__mdt ppv : Database.query(query) ){
            for(String s : fieldAPINameLabelMap.keySet()){
                //finalMap.put(fieldAPINameLabelMap.get(s), (Boolean)ppv.get(s)) ;
                PartnerAvailableServiceWrapper p =
                        new PartnerAvailableServiceWrapper(fieldAPINameLabelMap.get(s),
                                (Boolean)ppv.get(s),userlst[0]);
                tempList.add(p);
            }
        }
        system.debug('**tempList***'+tempList) ;
        return tempList ;
    }
    
    //fetch login user's cart id and total items in the cart
     @AuraEnabled
     public static UserCartWrapper fetchCartInfo(){
         UserCartWrapper wrapperObj = new UserCartWrapper();
        User loginUser = [Select id,contactId from User where ID =: userinfo.getUserId()];
        if(loginUser.contactId != null){
            List<AggregateResult> resultlist = [Select count(id) recordcount,Sales_Aid_Order__c  from Sales_Aid_Order_Line__c where Sales_Aid_Order__r.Partner__c =: loginUser.contactId AND Sales_Aid_Order__r.Status__c = 'In Progress' group by Sales_Aid_Order__c];
            if(resultlist.size()>0){
                wrapperObj.cartId = (String)resultlist[0].get('Sales_Aid_Order__c');
                wrapperObj.itemCount = (Integer)resultlist[0].get('recordcount');
            }
        }
        return wrapperObj;
     }
     
     //call from inside
     public static UserCartWrapper fetchCartInfo(User loginUser){
         UserCartWrapper wrapperObj = new UserCartWrapper();        
        if(loginUser.contactId != null){
            List<AggregateResult> resultlist = [Select count(id) recordcount,Sales_Aid_Order__c  from Sales_Aid_Order_Line__c where Sales_Aid_Order__r.Partner__c =: loginUser.contactId AND Sales_Aid_Order__r.Status__c = 'In Progress' group by Sales_Aid_Order__c];
            if(resultlist.size()>0){
                wrapperObj.cartId = (String)resultlist[0].get('Sales_Aid_Order__c');
                wrapperObj.itemCount = (Integer)resultlist[0].get('recordcount');
            }
        }
        return wrapperObj;
     }
    
    
    //cart info wrapp
    public class UserCartWrapper{
        @AuraEnabled
        public String cartId;
        @AuraEnabled
        public integer itemCount;
        
       
    }
}