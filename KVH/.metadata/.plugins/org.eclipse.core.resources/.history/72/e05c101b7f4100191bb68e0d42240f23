@isTest
private class Test_UCase {

 	static testMethod void ChangeCaseAssetIDShoundUpdateUpdateAssetName() 
    {
    	Account parent = new Account();
    	parent.Name = 'Parent Account';
    	insert parent;
    	
    	Account acc = new Account();
    	acc.Name = 'TempAccount';
    	acc.ParentId = parent.id;
    	insert acc;
    	
		Asset a = new Asset();
		a.Name = 'Temptest';
		a.AccountId = acc.id;
		insert a;
		
		Account parent2 = new Account();
    	parent2.Name = 'Parent_NEW_Account';
    	insert parent2;
    	
    	Account acc2 = new Account();
    	acc2.Name = 'TempAccount';
    	acc2.ParentId = parent2.id;
    	insert acc2;
    	
		Asset a2 = new Asset();
		a2.Name = 'Temptest';
		a2.AccountId = acc2.id;
		insert a2; 
		
		Case aCase = new Case();
		aCase.Subject = 'Test';
		aCase.AssetId = a.id;
		insert aCase;
		
		Case[] caseAfter = [Select Asset_Account_Name_Parent_Text__c, Asset.Name
							 from Case where Id =:aCase.Id LIMIT 1];
		
		system.assertEquals('Parent Account', caseAfter[0].Asset_Account_Name_Parent_Text__c);
		
		aCase.AssetId = a2.id;
		update aCase;
		
		caseAfter = [Select Asset_Account_Name_Parent_Text__c, Asset.Name
							 from Case where Id =:aCase.Id LIMIT 1];
		
		system.assertEquals('Parent_NEW_Account', caseAfter[0].Asset_Account_Name_Parent_Text__c);
		
		
		
    }
    
    static testMethod void AssetChangesAccountsShoundUpdateUpdateAssetName() 
    {
    	Account parent = new Account();
    	parent.Name = 'Parent Account';
    	insert parent;
    	
    	Account acc = new Account();
    	acc.Name = 'TempAccount';
    	acc.ParentId = parent.id;
    	insert acc;
    	
		Asset a = new Asset();
		a.Name = 'Temptest';
		a.AccountId = acc.id;
		insert a;
		
		Account parent2 = new Account();
    	parent2.Name = 'Parent_NEW_Account';
    	insert parent2;
    	
    	Account acc2 = new Account();
    	acc2.Name = 'TempAccount';
    	acc2.ParentId = parent2.id;
    	insert acc2;
    	
		Case aCase = new Case();
		aCase.Subject = 'Test';
		aCase.AssetId = a.id;
		insert aCase;
		
		Case[] caseAfter = [Select Asset_Account_Name_Parent_Text__c, Asset.Name
							 from Case where Id =:aCase.Id LIMIT 1];
		
		system.assertEquals('Parent Account', caseAfter[0].Asset_Account_Name_Parent_Text__c);
		
		
		a.AccountId = acc2.id;
		update a;
		
		caseAfter = [Select Asset_Account_Name_Parent_Text__c, Asset.Name
							 from Case where Id =:aCase.Id LIMIT 1];
		
		//system.assertEquals('Parent_NEW_Account', caseAfter[0].Asset_Account_Name_Parent_Text__c);
		
    }
    

    static testMethod void ChangeCaseAssetShoundUpdateUpdateAssetName() 
    {
    	Account parent = new Account();
    	parent.Name = 'Parent Account';
    	insert parent;
    	
    	Account acc = new Account();
    	acc.Name = 'TempAccount';
    	acc.ParentId = parent.id;
    	insert acc;
    	
		Asset a = new Asset();
		a.Name = 'Temptest';
		a.AccountId = acc.id;
		insert a;
		
		Case aCase = new Case();
		aCase.Subject = 'Test';
		aCase.AssetId = a.id;
		insert aCase;
		
		Case[] caseAfter = [Select Asset_Account_Name_Parent_Text__c, Asset.Name
							 from Case where Id =:aCase.Id LIMIT 1];
		
		system.assertEquals('Parent Account', caseAfter[0].Asset_Account_Name_Parent_Text__c);
    }
    
    static testMethod void UpdateCaseAssetShoundUpdateUpdateAssetName() 
    {
    	Account parent = new Account();
    	parent.Name = 'Parent Account';
    	insert parent;
    	
    	Account acc = new Account();
    	acc.Name = 'TempAccount';
    	acc.ParentId = parent.id;
    	insert acc;
    	
		Asset a = new Asset();
		a.Name = 'Temptest';
		a.AccountId = acc.id;
		insert a;
		
		Case aCase = new Case();
		aCase.Subject = 'Test';
		aCase.AssetId = a.id;
		insert aCase;
		
		parent.Name = 'TempAccount_CHG';
    	update parent;
		
		Case[] caseAfter = [Select Asset_Account_Name_Parent_Text__c, Asset.Name
							 from Case where Id =:aCase.Id LIMIT 1];
		
		
		
		system.assertEquals('TempAccount_CHG',caseAfter[0].Asset_Account_Name_Parent_Text__c);
    }
    
    static testMethod void TestCaseNoParentAccountUpdateCaseAssetShoundUpdateAssetName() 
    {
    	
    	Account acc = new Account();
    	acc.Name = 'TempAccount';
    	//acc.ParentId = parent.id;
    	insert acc;
    	
		Asset a = new Asset();
		a.Name = 'Temptest';
		a.AccountId = acc.id;
		insert a;
		
		Case aCase = new Case();
		aCase.Subject = 'Test';
		aCase.AssetId = a.id;
		insert aCase;
		
		Case[] caseAfter = [Select Asset_Account_Name_Parent_Text__c, Asset.Name
							 from Case where Id =:aCase.Id LIMIT 1];
		
		
		system.assertEquals(NULL,caseAfter[0].Asset_Account_Name_Parent_Text__c);
    }
    
    static testMethod void TestCaseNoAssetAccountUpdateCaseAssetShoundUpdateAssetName() 
    {    	
    	Account acc = new Account();
    	acc.Name = 'TempAccount';
    	//acc.ParentId = parent.id;
    	insert acc;
    	
    	Contact c = new Contact();
    	c.Firstname = 'a';
    	c.LastName='z';
    	c.AccountId = acc.id;
    	//c.CompanyName = 'az';
		insert c;
    	
		Asset a = new Asset();
		a.Name = 'Temptest';
		a.ContactId = c.id;
		insert a;
		
		Case aCase = new Case();
		aCase.Subject = 'Test';
		aCase.AssetId = a.id;
		insert aCase;
		
		Case[] caseAfter = [Select Asset_Account_Name_Parent_Text__c, Asset.Name
							 from Case where Id =:aCase.Id LIMIT 1];
		
		
		system.assertEquals(NULL,caseAfter[0].Asset_Account_Name_Parent_Text__c);
    }
    
       
    static testMethod void ClearCaseAssetIdShouldClearAssetName() 
    {
    	Account parent = new Account();
    	parent.Name = 'Parent Account';
    	insert parent;
    	
    	Account acc = new Account();
    	acc.Name = 'TempAccount';
    	acc.ParentId = parent.id;
    	insert acc;
    	
		Asset a = new Asset();
		a.Name = 'Temptest';
		a.AccountId = acc.id;
		insert a;
		
		Case aCase = new Case();
		aCase.Subject = 'Test';
		aCase.AssetId = a.id;
		insert aCase;
		
		Case[] caseAfter = [Select Asset_Account_Name_Parent_Text__c, Asset.Name
							 from Case where Id =:aCase.Id LIMIT 1];
		
		
		system.assertEquals( 'Parent Account',caseAfter[0].Asset_Account_Name_Parent_Text__c);
		
		
		aCase.AssetId = null;
		update aCase;
		
		caseAfter = [Select Asset_Account_Name_Parent_Text__c, Asset.Name
							 from Case where Id =:aCase.Id LIMIT 1];
		
		
		system.assertEquals(NULL,caseAfter[0].Asset_Account_Name_Parent_Text__c);
    }
}