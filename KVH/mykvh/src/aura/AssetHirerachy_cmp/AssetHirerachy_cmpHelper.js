({
    getAssetHierarchy: function(component) { 
        var action = component.get("c.getAssetHierarchy");
        var assetId;
        assetId = component.get("v.assetId");
        action.setParams({	
            assetId : assetId
        });
        action.setCallback(this, function(response) {
            var roles = {}, results;
            var mymap;
            if(component.isValid() && response.getState() === "SUCCESS") {
                results = response.getReturnValue();
                var listAsset = [];
                roles[undefined] = { Name: "Root", items: [] };
                results.forEach(function(v) {
                    if(typeof v.Product2 != 'undefined'){
                        listAsset.push({Id : v.Id,Name:v.Name});
                        if(component.get("v.mode") == 'editable'){
                            var strassetIdvalue = v.Id;
                            var assetIdvalue = strassetIdvalue.substr(0, 15);
                            if(assetIdvalue == component.get("v.assetId"))
                                roles[v.Id] = { Id: v.Id, Name: v.Name,Parent_Asset__c : v.Parent_Asset__c,Account_Name__c : v.Account_Name__c, Sequence_No__c : v.Sequence_No__c , InstallDate : v.InstallDate, Date_Removed__c : v.Date_Removed__c,
                                               System_Warranty_Start_Date__c : v.System_Warranty_Start_Date__c,Warranty_Start_Date__c  : v.Warranty_Start_Date__c ,Item__c : v.Item__c,HTS_REady__c : v.HTS_REady__c,
                                               Warranty_Type__c : v.Warranty_Type__c,System_Asset_Warranty__c : v.System_Asset_Warranty__c,Warranty_End_Date__c : v.Warranty_End_Date__c,RecordTypeName : v.Product2.RecordType.Name,
                                               Product_Registration__r : v.Product_Registration__r,Product_Registration__c : v.Product_Registration__c,Warranty_Period_Months__c : v.Warranty_Period_Months__c,Root_Asset : v.Root_Asset__r,
                                               Item_Description__c : v.Item_Description__c,items: [] ,CurrentAsset : true ,mode :'editable'};
                            else
                                roles[v.Id] = { Id: v.Id, Name: v.Name,Parent_Asset__c : v.Parent_Asset__c,Account_Name__c : v.Account_Name__c, Sequence_No__c : v.Sequence_No__c , InstallDate : v.InstallDate, Date_Removed__c : v.Date_Removed__c, 
                                               System_Warranty_Start_Date__c : v.System_Warranty_Start_Date__c,Warranty_Start_Date__c  : v.Warranty_Start_Date__c ,Item__c : v.Item__c,HTS_REady__c : v.HTS_REady__c,
                                               Warranty_Type__c : v.Warranty_Type__c,System_Asset_Warranty__c : v.System_Asset_Warranty__c,Warranty_End_Date__c : v.Warranty_End_Date__c,RecordTypeName : v.Product2.RecordType.Name,
                                               Product_Registration__r : v.Product_Registration__r,Product_Registration__c : v.Product_Registration__c,Warranty_Period_Months__c : v.Warranty_Period_Months__c,Root_Asset : v.Root_Asset__r,
                                               Item_Description__c : v.Item_Description__c,items: [] ,CurrentAsset : false ,mode :'editable'};
                        }
                        else if(component.get("v.mode") == 'readonly' || component.get("v.mode") == 'readonlyMaster')
                        {
                            var strassetIdvalue = v.Id;
                            var assetIdvalue = strassetIdvalue.substr(0, 15);
                            if(assetIdvalue == component.get("v.assetId"))
                                roles[v.Id] = { Id: v.Id, Name: v.Name, Sequence_No__c : v.Sequence_No__c , InstallDate : v.InstallDate, Date_Removed__c : v.Date_Removed__c,
                                               System_Warranty_Start_Date__c : v.System_Warranty_Start_Date__c,Warranty_Start_Date__c  : v.Warranty_Start_Date__c ,Item__c : v.Item__c,HTS_REady__c : v.HTS_REady__c,
                                               Warranty_Type__c : v.Warranty_Type__c,System_Asset_Warranty__c : v.System_Asset_Warranty__c,Warranty_End_Date__c : v.Warranty_End_Date__c,RecordTypeName : v.Product2.RecordType.Name,
                                               Product_Registration__r : v.Product_Registration__r,Product_Registration__c : v.Product_Registration__c,Warranty_Period_Months__c : v.Warranty_Period_Months__c,Root_Asset : v.Root_Asset__r,
                                               Item_Description__c : v.Item_Description__c,items: [] ,CurrentAsset : true ,mode :''};
                            else
                                roles[v.Id] = { Id: v.Id, Name: v.Name, Sequence_No__c : v.Sequence_No__c , InstallDate : v.InstallDate, Date_Removed__c : v.Date_Removed__c, 
                                               System_Warranty_Start_Date__c : v.System_Warranty_Start_Date__c,Warranty_Start_Date__c  : v.Warranty_Start_Date__c ,Item__c : v.Item__c,HTS_REady__c : v.HTS_REady__c,
                                               Warranty_Type__c : v.Warranty_Type__c,System_Asset_Warranty__c : v.System_Asset_Warranty__c,Warranty_End_Date__c : v.Warranty_End_Date__c,RecordTypeName : v.Product2.RecordType.Name,
                                               Product_Registration__r : v.Product_Registration__r,Product_Registration__c : v.Product_Registration__c,Warranty_Period_Months__c : v.Warranty_Period_Months__c,Root_Asset : v.Root_Asset__r,
                                               Item_Description__c : v.Item_Description__c,items: [] ,CurrentAsset : false ,mode :''};
                        }   
                    }
                    else{
                        var appEvent = $A.get("e.c:AssetMovementModal_evt");
                        appEvent.setParams({noProduct : true});
                        appEvent.fire();
                    }
                    
                });
                results.forEach(function(v) {
                    roles[v.Parent_Asset__c ].items.push(roles[v.Id]);
                });
                component.set("v.nodes", roles[undefined].items);
                //console.log(listAsset+'From Asset Hierarchy');
                if(component.get("v.mode") == 'readonlyMaster' || component.get("v.mode") == 'editable'){
                    var appEvent = $A.get("e.c:AssetMovementModal_evt");
                    appEvent.setParams({listAssetIdInHierarchy : listAsset});
                    appEvent.fire();
                }
            } 
            else if (response.getState() === "ERROR"){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert(errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);   
    },
})