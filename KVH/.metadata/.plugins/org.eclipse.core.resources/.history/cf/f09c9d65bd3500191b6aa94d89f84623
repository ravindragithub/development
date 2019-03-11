public with sharing class JKT_myKVHPermissionsMatrix {
	public List<myKVHFeature> lstKVHFeatures	{get; set;}	
	public List<myKVH_Role__c> lstRoles			{get; set;}
	
	public JKT_myKVHPermissionsMatrix() {
		lstKVHFeatures = new List<myKVHFeature>();
		lstRoles = new List<myKVH_Role__c>();
		
		this.loadPermissionMatrix();
	}
	
	public class myKVHFeature {
		public myKVH_Feature__c objFeature					{get; set;}
		public List<myKVH_Permission_Set__c> lstPermissions	{get; set;}
	}
	
	private void loadPermissionMatrix() {
		Map<String, myKVH_Permission_Set__c> mapPermissions = new Map<String, myKVH_Permission_Set__c>();
		
		for(myKVH_Role__c oRole : [SELECT Id, Name FROM myKVH_Role__c ORDER BY Name LIMIT 10000]) {
			lstRoles.add(oRole);
		}
		
		for(myKVH_Permission_Set__c oPermission : [SELECT Id, Name, adminFlag__c, canCreate__c, canDelete__c, canRead__c, canUpdate__c, myKVH_Role__c, myKVH_Feature__c 
													FROM myKVH_Permission_Set__c WHERE myKVH_Role__c != NULL AND myKVH_Feature__c != NULL LIMIT 10000]) {
			if(oPermission.myKVH_Role__c != null && oPermission.myKVH_Feature__c != null) {
				String strKey = oPermission.myKVH_Role__c + ':' + oPermission.myKVH_Feature__c;
				mapPermissions.put(strKey, oPermission);
			}
		}
		
		for(myKVH_Feature__c oFeature : [SELECT Id, Name, Status__c FROM myKVH_Feature__c ORDER BY Name LIMIT 10000]) {
			List<myKVH_Permission_Set__c> lstPermissionsTemp = new List<myKVH_Permission_Set__c>();
			for(myKVH_Role__c oRole : lstRoles) {
				String strKey = oRole.Id + ':' + oFeature.Id;
				if(mapPermissions.containsKey(strKey)) {
					lstPermissionsTemp.add(mapPermissions.get(strKey));
				}
				else {
					myKVH_Permission_Set__c objPermission = new myKVH_Permission_Set__c();
					lstPermissionsTemp.add(objPermission);
				}
			}
			
			myKVHFeature objKVHFeature = new myKVHFeature();
			objKVHFeature.objFeature = oFeature;
			objKVHFeature.lstPermissions = lstPermissionsTemp;
			lstKVHFeatures.add(objKVHFeature);
		}
	}
}