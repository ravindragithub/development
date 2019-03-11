global class DB_CustomTestDataGenerator implements CRMfusionDBR101.DB_TestDataGenerator{
	public class UnsupportedTypeException extends Exception{}
	//Base code obtained from CRM Fusion at
	//http://www.helpconsole.com/DupeBlocker%203/default.aspx#pageid=sample_db_customtestgenerator_cls
	//need to add assets to supported sObject Types

    // Update this list to contain the lower case name of all types you wish to support.
    // For each entry in the list, create a corresponding createTest<Object Type> method
    // similar the the createTestAccount() method below.  This method should be called by
    // the createTestData() method after you've modified it to support the desired data types.
    private Set<String> supportedTypes = new Set<String>{ 'account', 'contact', 'lead', 'asset' };
    
    // Generate an sObject with test data of the type requested in the
    // sObjectType parameter.
    // Modify this to add support for all types in the supportedTypes set above.
    global sObject createTestData( Schema.SObjectType sobjectType )
    {
        if ( sobjectType == Account.getSObjectType() )
            return createTestAccount();
        else if ( sobjectType == Contact.getSObjectType() )
            return createTestContact();
        else if ( sobjectType == Lead.getSObjectType() )
            return createTestLead();
        else if ( sobjectType == Asset.getSObjectType() )
        	return createTestAsset();
        else
            throw new UnsupportedTypeException( 'CustomTestDataGenerator.createTestData():  Unsupported ' +
                'type requested: ' + String.valueOf( sobjectType ) );
    }
    
    // Verify that a particular sObjectType is supported by this generator.
    // If the generator doesn't support it, DupeBlocker will fall back to
    // default data generation for that object type.
    // This does not need to be customized, it uses the types set above.
    global Boolean isSupportedType( Schema.SObjectType sobjectType )
    {
        return supportedTypes.contains( String.valueOf( sobjectType ).toLowerCase() );
    }
    
    // Sample account data creation method.
    private Account createTestAccount()
    {
        String randomizer = String.valueOf( Math.round( Math.random() * 10000 ) );
        return new Account ( Name = 'DupeBlocker Unit Test Account ' + randomizer,
            AnnualRevenue = Math.round( Math.random() * 100000 ),
            BillingStreet = randomizer + ' Main St.',
            BillingCity = 'DupeBlocker Unit Test City',
            BillingState = 'CA',
            BillingCountry = 'US',
            BillingPostalCode = '90210',
            Description = 'DupeBlocker Unit Test Description ' + randomizer,
            NumberOfEmployees = math.round( Math.random() * 100000 ),
            Fax = '(123) 456-7890',
            Phone = '(123) 456-7890',
            Industry = 'Technology',
            ShippingStreet = randomizer + ' Main St.',
            ShippingCity = 'DupeBlocker Unit Test City',
            ShippingState = 'CA',
            ShippingCountry = 'US',
            ShippingPostalCode = '90210',
            Type = 'Prospect' );
    }
    
    // Sample contact data creation method.
    private Contact createTestContact()
    {
        String randomizer = String.valueOf( Math.round( Math.random() * 10000 ) );
        return new Contact ( FirstName = 'DupeBlocker Unit Test First Name ' + randomizer,
            LastName = 'DupeBlocker Unit Test Last Name ' + randomizer,
            Department = 'DupeBlocker Unit Test Department ' + randomizer,
            Description = 'DupeBlocker Unit Test Description ' + randomizer,
            Email = 'test' + randomizer + '@test.com',
            Fax = '(123) 456-7890',
            Phone = '(123) 456-7890',
            HomePhone = '(123) 456-7890',
            MobilePhone = '(123) 456-7890',
            OtherPhone = '(123) 456-7890',
            LeadSource = 'Trade Show',
            MailingStreet = randomizer + ' Main St.',
            MailingCity = 'DupeBlocker Unit Test City',
            MailingState = 'CA',
            MailingCountry = 'US',
            MailingPostalCode = '90210',
            OtherStreet = randomizer + ' Main St.',
            OtherCity = 'DupeBlocker Unit Test City',
            OtherState = 'CA',
            OtherCountry = 'US',
            OtherPostalCode = '90210' );
    }
    
    // Sample lead data creation method.
    private Lead createTestLead()
    {
        String randomizer = String.valueOf( Math.round( Math.random() * 10000 ) );
        return new Lead ( FirstName = 'DupeBlocker Unit Test First Name ' + randomizer,
            LastName = 'DupeBlocker Unit Test Last Name ' + randomizer,
            Company = 'DupeBlocker Unit Test Company ' + randomizer,
            AnnualRevenue = Math.round( Math.random() * 100000 ),
            Industry = 'Technology',
            Description = 'DupeBlocker Unit Test Description ' + randomizer,
            Email = 'test' + randomizer + '@test.com',
            Fax = '(123) 456-7890',
            Phone = '(123) 456-7890',
            MobilePhone = '(123) 456-7890',
            LeadSource = 'Trade Show',
            Street = randomizer + ' Main St.',
            City = 'DupeBlocker Unit Test City',
            State = 'CA',
            Country = 'US',
            PostalCode = '90210',
            NumberOfEmployees = math.round( Math.random() * 100000 ),
            Rating = 'Warm' );
    }
    
    private Asset createTestAsset(){	//Added jthom 9/4/14
		//test data
		//Need Account for Asset
		Account testAcct1 = new Account(Name = 'testAcct1', BillingState = 'CA', BillingCountry = 'US');
		Insert testAcct1;
		testAcct1 = [SELECT Id, Name FROM Account WHERE name =: 'testAcct1' LIMIT 1];
		
		//Need KVH_Product_Family for Asset
		KVH_Product_Family__c testProdFamily = new KVH_Product_Family__c(Name = 'IP Address', FCP_Element_Type__c = 'Terminal');
		insert testProdFamily;
		testProdFamily = [SELECT id, Name, FCP_Element_Type__c FROM KVH_Product_Family__c WHERE Name = 'IP Address' LIMIT 1];
		
		//Need Product2 for Asset positive tests
		Product2 testProduct = new Product2(Name = 'IP Address', KVH_Product_Family__c = testProdFamily.Id);
		insert testProduct;
		testProduct = [SELECT id, Name FROM Product2 WHERE Name = 'IP Address' LIMIT 1];
		
		//Need Asset for positive test
		Asset testAsset = new Asset(Name = 'Test Asset', Product2ID = testProduct.Id, AccountID = testAcct1.Id);
		
		return testAsset;
    	
    }
}