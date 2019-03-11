@isTest
private class Test_UAccount {

    static testMethod void InsertedAccountShouldUpdateItParentAccountName() 
    {
        Account parentAcct = new Account();
        parentAcct.Name = 'Temp Account';
        insert parentAcct;
        
        Account relatedAcct = new Account();
        relatedAcct.ParentId = parentAcct.Id;
        relatedAcct.Name = 'ChildAcct';
        insert relatedAcct; 
        
        List<Account> acct = [Select ParentId, Parent.Name, 
        						Parent_Account_Text__c
        						from Account
        						where Id =:relatedAcct.Id LIMIT 1];

		system.assertEquals(acct[0].Parent.Name,acct[0].Parent_Account_Text__c);
    }
    
    static testMethod void UpdateAccountShouldUpdateItParentAccountName() 
    {
        Account parentAcct = new Account();
        parentAcct.Name = 'Temp Account';
        insert parentAcct;
        
        Account relatedAcct = new Account();
        relatedAcct.ParentId = null;
        relatedAcct.Name = 'ChildAcct';
        insert relatedAcct;
        
        relatedAcct.ParentId = parentAcct.Id;
        update relatedAcct;
        
        List<Account> acct = [Select ParentId, Parent.Name, 
        						Parent_Account_Text__c
        						from Account
        						where Id =:relatedAcct.Id LIMIT 1];

		system.assertEquals(acct[0].Parent.Name,acct[0].Parent_Account_Text__c);
    }
    
	static testMethod void RemovingAcctParentClearsTheParentAccountText() 
    {
        Account parentAcct = new Account();
        parentAcct.Name = 'Temp Account';
        insert parentAcct;
        
        Account relatedAcct = new Account();
        relatedAcct.ParentId = parentAcct.Id;
        relatedAcct.Name = 'ChildAcct';
        insert relatedAcct;
        
		relatedAcct.ParentId = null;
        update relatedAcct;
		
        List<Account> acct = [Select ParentId, Parent.Name, 
						Parent_Account_Text__c
						from Account
						where Id =:relatedAcct.Id LIMIT 1];

		system.assertEquals(null,acct[0].Parent_Account_Text__c);
		
    }
    
    static testMethod void UpdatingAParentAccountNameUpdatesAllItsChildrensParentAccountTxt()
    {
		Account parentAcct = new Account();
        parentAcct.Name = 'Temp Account';
        insert parentAcct;
        
        Account relatedAcct = new Account();
        relatedAcct.ParentId = parentAcct.Id;
        relatedAcct.Name = 'ChildAcct';
        insert relatedAcct;

        Account relatedAcct2 = new Account();
        relatedAcct2.ParentId = parentAcct.Id;
        relatedAcct2.Name = 'ChildAcct2';
        insert relatedAcct2;
 
        Account relatedAcct3 = new Account();
        relatedAcct3.ParentId = parentAcct.Id;
        relatedAcct3.Name = 'ChildAcct3';
        insert relatedAcct3;
 
 		parentacct.Name = 'This_Was_Updated';
        update parentacct;
		
        List<Account> acct = [Select ParentId, Parent.Name, 
						Parent_Account_Text__c
						from Account
						where parentId =:parentAcct.Id];

		for(Account aut: acct)
		{
			system.assertEquals('This_Was_Updated',aut.Parent_Account_Text__c);
		}    	
    } 
    
    static testMethod void UpdatingAParentAccountNameDeepNesting()
    {
		Account parentAcct = new Account();
        parentAcct.Name = 'Temp Account';
        insert parentAcct;
        
        Account relatedAcct = new Account();
        relatedAcct.ParentId = parentAcct.Id;
        relatedAcct.Name = 'ChildAcct';
        insert relatedAcct;

        Account relatedAcct2 = new Account();
        relatedAcct2.ParentId = relatedAcct.Id;
        relatedAcct2.Name = 'ChildAcct2';
        insert relatedAcct2;
 
        Account relatedAcct3 = new Account();
        relatedAcct3.ParentId = relatedAcct2.Id;
        relatedAcct3.Name = 'ChildAcct3';
        insert relatedAcct3;
 
 		parentacct.Name = 'This_Was_Updated';
        update parentacct;
		
        List<Account> acct = [Select ParentId, Parent.Name, 
						Parent_Account_Text__c
						from Account
						where parentId =:parentAcct.Id];

		for(Account aut: acct)
		{
			system.assertEquals('This_Was_Updated',aut.Parent_Account_Text__c);
			system.assertEquals(1,acct.Size());
		}    	
    } 
    
    static testMethod void ChangeParentAccountNameShoundUpdateUpdateCaseAssetName() 
    {
    	Account parent = new Account(Name='Parent');
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
		
		Case aCase2 = new Case();
		aCase2.Subject = 'Test';
		aCase2.AssetId = a.id;
		
		insert new case[]{aCase,aCase2};
		
		parent.Name = 'This_was_Changed';
		update parent;
		
		Case[] caseAfter = [Select Asset_Account_Name_Parent_Text__c, 
								Asset.Account.Name, 
								Asset.Account.Parent.Name
							 from Case where AssetId =:a.Id];
		
		system.assertEquals(2,caseAfter.size());
		
		for(Case caseIndx:caseAfter){
			system.assertEquals(caseIndx.Asset.Account.Parent.Name, caseIndx.Asset_Account_Name_Parent_Text__c);
			system.assertEquals('This_was_Changed',caseIndx.Asset_Account_Name_Parent_Text__c);
		}
    }
    
     static testMethod void ReparentingAccountShoundUpdateUpdateCaseAssetName() 
    {
    	Account parent = new Account(Name='Parent');
    	insert parent;
    	
    	Account reparent = new Account(Name='ReParent');
    	insert reparent;
    	
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
		
		Case aCase2 = new Case();
		aCase2.Subject = 'Test';
		aCase2.AssetId = a.id;
		
		insert new case[]{aCase,aCase2};
		
		acc.ParentId =reparent.Id;
		update acc;
		
		Case[] caseAfter = [Select Asset_Account_Name_Parent_Text__c, 
								Asset.Account.Name, 
								Asset.Account.Parent.Name
							 from Case where AssetId =:a.Id];
		
		system.assertEquals(2,caseAfter.size());
		
		for(Case caseIndx:caseAfter){
			system.assertEquals(caseIndx.Asset.Account.Parent.Name, caseIndx.Asset_Account_Name_Parent_Text__c);
			system.assertEquals('ReParent',caseIndx.Asset_Account_Name_Parent_Text__c);
		}
    }
	
	static testmethod void testoneTimeBackfillRequest()
	{
		Account parent = new Account(Name='Parent');
    	insert parent;
    	    	
    	Account acc = new Account();
    	acc.Name = 'TempAccount';
    	acc.ParentId = parent.id;
    	insert acc;
		
		AccountParentCaseAssetBackfillBatchable batch =	new AccountParentCaseAssetBackfillBatchable(true);
		Test.startTest();
		ID jobId = Database.executeBatch(batch);
		Test.stopTest();
	}	    
	
	static testMethod void Parenting() 
    {
    	Account a1 = new Account();
    	a1.Name = 'Test';
    	insert a1;    
    	    
    	Account a2 = new Account();
    	a2.Name = 'Test2';
    	a2.ParentId = a1.id;
    	insert a2;
    	
    	a1.Apply_Custom_Sharing__c = true;
    	update a1;
    	
    	Account a3 = new Account();
    	a3.Name = 'Test3';
    	a3.ParentId = a2.id;
    	insert a3;
    	
    	Account a4 = new Account();
    	a4.Name = 'Test4';
    	insert a4;

		a3.parentId = a4.id;
		update a3;    
		
		set <id> accounts = new set <id>();
		accounts.add(a1.id);
		accounts.add(a2.id);
		accounts.add(a3.id);
		accounts.add(a4.id);
			
		
		UAccountShare.createAccountShare(accounts);
    }
}