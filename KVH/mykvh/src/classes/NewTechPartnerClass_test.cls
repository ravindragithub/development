@isTest
private class NewTechPartnerClass_test {
    
    @testSetup
	static void setupTestData(){
        skilljar__Group__c sgroup1 = new skilljar__Group__c();
        sgroup1.skilljar__Skilljar_Id__c = '1234';
        sgroup1.skilljar__Name__c = 'TracVision Land';
        sgroup1.Name = 'TracVision Land';
        insert sgroup1;
        skilljar__Group__c sgroup2 = new skilljar__Group__c();
        sgroup2.skilljar__Skilljar_Id__c = '12345';
        sgroup2.skilljar__Name__c = 'TracPhone';
        sgroup2.Name = 'TracPhone';
        insert sgroup2;
        skilljar__Group__c sgroup3 = new skilljar__Group__c();
        sgroup3.skilljar__Skilljar_Id__c = '123456';
        sgroup3.skilljar__Name__c = 'TracVision Marine Advanced';
        sgroup3.Name = 'TracVision Marine Advanced';
        insert sgroup3;
        skilljar__Group__c sgroup4 = new skilljar__Group__c();
        sgroup4.skilljar__Skilljar_Id__c = '1234567';
        sgroup4.skilljar__Name__c = 'TracPhone Advanced';
        sgroup4.Name = 'TracPhone Advanced';
        insert sgroup4;
        skilljar__Group__c sgroup5 = new skilljar__Group__c();
        sgroup5.skilljar__Skilljar_Id__c = '12345678';
        sgroup5.skilljar__Name__c = 'TracVision Marine';
        sgroup5.Name = 'TracVision Marine';
        insert sgroup5;
        Security__c secur = new Security__c(Name = 'SkillJar1', Key__c = 'sk-live-c8b91cc77f04eb8c8fbabc51981484af8005db4d');
        insert secur;
        List <Account> accts = new List<Account>();
        Account acc = new Account(Name = '1234', BillingCountry = 'Italy', Partner_Role__c = 'Dealer');
        accts.add(acc);
        Account acc2 = new Account(Name = '12345', BillingCountry = 'Italy', Partner_Role__c = 'Distributor');
        accts.add(acc2);
        Account acc3 = new Account(Name = '123456', BillingCountry = 'Italy', Partner_Role__c = 'Service Provider');
        accts.add(acc3);
        insert accts;
        Product2 prod1 = new Product2(Name = 'testprod', Product_Line1__c = 'Mobile Communications', Product_Series__c = 'mini-VSAT Broadband');
        insert prod1;
        Product2 prod2 = new Product2(Name = 'testprod', Product_Line1__c = 'Satellite Television');
        insert prod2;
        Product2 prod3 = new Product2(Name = 'testprod', Product_Line1__c = 'Satellite Television');
        insert prod3;
        Product_Market_Sector__c pms1 = new Product_Market_Sector__c(Market__c = 'Leisure', Sector__c = 'Land Systems', Portal_View__c = 'Leisure Auto & RV Systems', Product__c = prod2.Id );
        insert pms1;
        Product_Market_Sector__c pms2 = new Product_Market_Sector__c(Market__c = 'Leisure', Sector__c = 'Marine Systems', Portal_View__c = 'Leisure Marine Systems', Product__c = prod1.Id );
        insert pms2;
        Product_Market_Sector__c pms3 = new Product_Market_Sector__c(Market__c = 'Leisure', Sector__c = 'Marine Systems', Portal_View__c = 'Leisure Marine Systems', Product__c = prod2.Id );
        insert pms3;
        Product_Catalogue__c prodcat1 = new Product_Catalogue__c(Product_Market_Sector__c = pms1.Id, Partner_Account__c = acc.Id);
        Product_Catalogue__c prodcat2 = new Product_Catalogue__c(Product_Market_Sector__c = pms2.Id, Partner_Account__c = acc.Id);
        Product_Catalogue__c prodCat3 = new Product_Catalogue__c(Product_Market_Sector__c = pms3.Id, Partner_Account__c = acc.Id);
        insert prodcat1;
        insert prodCat2;
        insert prodCat3;
        Contact con = new Contact(FirstName = 'bob', LastName = 'bobby', Email = 'bob@me.com', AccountId = acc.Id);
        insert con;
        Contact con1 = new Contact(FirstName = 'bob', LastName = 'bobby', Email = 'bob2@me.com', AccountId = acc2.Id);
        insert con1;
        Contact con2 = new Contact(FirstName = 'bob', LastName = 'bobby', Email = 'bob3@me.com', AccountId = acc3.Id);
        insert con2;
        skilljar__Student__c stud1 = new skilljar__Student__c(skilljar__Obfuscated_Id__c = '2342342', Name = 'bob1', skilljar__Email__c = 'bobby1@me.com');
        skilljar__Student__c stud2 = new skilljar__Student__c(skilljar__Obfuscated_Id__c = '6151656', Name = 'bob2', skilljar__Email__c = 'bobby2@me.com');
        insert stud1;
        insert stud2;
        skilljar__Course__c cs1 = new skilljar__Course__c(Name = 'TracPhone V11-IP', skilljar__Skilljar_Id__c = '1237272', skilljar__Title__c = 'TracPhone V11-IP');
        skilljar__Course__c cs2 = new skilljar__Course__c(Name = 'TracPhone V7-IP', skilljar__Skilljar_Id__c = '1237273', skilljar__Title__c = 'TracPhone V7-IP');
        skilljar__Course__c cs3 = new skilljar__Course__c(Name = 'TracVision TV5, TV6, and TV8', skilljar__Skilljar_Id__c = '1237274', skilljar__Title__c = 'TracVision TV5, TV6, and TV8');
        skilljar__Course__c cs4 = new skilljar__Course__c(Name = 'TracVision HD7', skilljar__Skilljar_Id__c = '1237275', skilljar__Title__c = 'TracVision HD7');
        insert cs1;
        insert cs2;
        insert cs3;
        insert cs4;
        skilljar__Published_Course__c pc1 = new skilljar__Published_Course__c(Name = 'TracPhone V11-IP', skilljar__Course__c = cs1.Id, skilljar__Course_Title__c = 'TracPhone V11-IP', skilljar__Course_URL__c = 'http://kvhsandbox.skilljar.com/123', skilljar__Domain__c = 'kvhsandbox.skilljar.com', skilljar__Obfuscated_Id__c = '555555');
        skilljar__Published_Course__c pc2 = new skilljar__Published_Course__c(Name = 'TracPhone V7-IP', skilljar__Course__c = cs2.Id, skilljar__Course_Title__c = 'TracPhone V7-IP', skilljar__Course_URL__c = 'http://kvhsandbox.skilljar.com/1234', skilljar__Domain__c = 'kvhsandbox.skilljar.com', skilljar__Obfuscated_Id__c = '555556');
        skilljar__Published_Course__c pc3 = new skilljar__Published_Course__c(Name = 'TracVision TV5, TV6, and TV8', skilljar__Course__c = cs3.Id, skilljar__Course_Title__c = 'TracVision TV5, TV6, and TV8', skilljar__Course_URL__c = 'http://kvhsandbox.skilljar.com/12345', skilljar__Domain__c = 'kvhsandbox.skilljar.com', skilljar__Obfuscated_Id__c = '555557');
        skilljar__Published_Course__c pc4 = new skilljar__Published_Course__c(Name = 'TracVision HD7', skilljar__Course__c = cs4.Id, skilljar__Course_Title__c = 'TracVision HD7', skilljar__Course_URL__c = 'http://kvhsandbox.skilljar.com/123456', skilljar__Domain__c = 'kvhsandbox.skilljar.com', skilljar__Obfuscated_Id__c = '555558');
        insert pc1;
        insert pc2;
        insert pc3;
        insert pc4;
        skilljar__Course_Progress__c cp1 = new skilljar__Course_Progress__c(Name = '12', skilljar__Completed_At__c = system.today(), skilljar__Student__c = stud1.Id, skilljar__Published_Course__c = pc1.Id, skilljar__Course__c = cs1.Id, skilljar__Obfuscated_Id__c = '888777');
        skilljar__Course_Progress__c cp2 = new skilljar__Course_Progress__c(Name = '23', skilljar__Completed_At__c = system.today(), skilljar__Student__c = stud1.Id, skilljar__Published_Course__c = pc2.Id, skilljar__Course__c = cs2.Id, skilljar__Obfuscated_Id__c = '888778');
        skilljar__Course_Progress__c cp3 = new skilljar__Course_Progress__c(Name = '34', skilljar__Completed_At__c = system.today(), skilljar__Student__c = stud2.Id, skilljar__Published_Course__c = pc3.Id, skilljar__Course__c = cs3.Id, skilljar__Obfuscated_Id__c = '888779');
        skilljar__Course_Progress__c cp4 = new skilljar__Course_Progress__c(Name = '45', skilljar__Completed_At__c = system.today(), skilljar__Student__c = stud2.Id, skilljar__Published_Course__c = pc4.Id, skilljar__Course__c = cs4.Id, skilljar__Obfuscated_Id__c = '888770');
        insert cp1;
        insert cp2;
        insert cp3;
        insert cp4;
        Partner_Portal_Access_Request__c ppar = new Partner_Portal_Access_Request__c();
        ppar.Company_Address_1__c = '50 Enterprise Center';
        ppar.Company_City__c = 'Middletown';
        ppar.Company_Country__c = 'United States';
        ppar.Company_Email__c = 'test@test.com';
        ppar.Company_Name__c = 'test123';
        ppar.Company_Phone__c = '987987';
        ppar.Company_State__c = 'RI';
        ppar.Company_Website__c = 'www.test.com';
        ppar.Partner_Role__c = 'Dealer';
        ppar.Salutation__c = 'Mr.';
        ppar.First_Name__c = 'firsttest';
        ppar.Last_Name__c = 'lasttest';
        ppar.Contact_Email__c = 'test1@test.com';
        ppar.Contact_Phone__c = '987987';
        ppar.Portal_View_s__c = 'Leisure Marine Systems';
        ppar.Company_Postal_Zipcode__c = '9879';
        ppar.MC_Email__c = 'test2@test.com';
        ppar.MC_First_Name__c = 'firsttest1';
        ppar.MC_Last_Name__c = 'lasttest1';
        ppar.MC_Phone__c = '98798';
        ppar.MC_Salutation__c = 'Mr.';
        ppar.Service_Manager_Email__c = 'test3@test.com';
        ppar.Service_Manager_First_Name__c = 'firsttest2';
        ppar.Service_Manager_Last_Name__c = 'lasttest2';
        ppar.Service_Manager_Phone__c = '9879';
        ppar.Service_Manager_Salutation__c = 'Mr.';
        insert ppar;
        Partner_Portal_Access_Request__c testppar = new Partner_Portal_Access_Request__c(); 
        testppar.Company_Email__c = '123@123.com';
        insert testppar;
        Partner_Portal_Access_Request__c testppar2 = new Partner_Portal_Access_Request__c(); 
        testppar2.Contact_Email__c = 'bob4@me.com';
        testppar2.Last_Name__c = 'bobtesting';
        testppar2.First_Name__c = 'bobtesting';
        testppar2.Company_Address_1__c = '50 Enterprise Center';
        testppar2.Company_City__c = 'Middletown';
        testppar2.Company_Country__c = 'United States';
        testppar2.Company_State__c = 'RI';
        insert testppar2;
        Partner_Portal_Access_Request__c testppar3 = new Partner_Portal_Access_Request__c(); 
        testppar3.Contact_Email__c = 'bob5@me.com';
        testppar3.Last_Name__c = 'bobbytesting';
        testppar3.First_Name__c = 'bobbytesting';
        testppar3.Company_Address_1__c = '50 Enterprise Center';
        testppar3.Company_City__c = 'Middletown';
        testppar3.Company_Country__c = 'United States';
        testppar3.Company_State__c = 'RI';
        insert testppar3;
    }
    static testMethod void testNewAccount(){
        Partner_Portal_Access_Request__c testppar = [SELECT Name FROM Partner_Portal_Access_Request__c WHERE Company_Email__c = 'test@test.com'];        
        string returnMessage = NewTechPartnerClass.createAcctContact(testppar.Name);
        List<Account> acc = [SELECT Id FROM Account WHERE Name = 'test123'];
        system.assertEquals(1, acc.size());
        List <Contact> cont = [SELECT Id FROM Contact WHERE AccountId =: acc[0].Id];
        system.assertEquals(3, cont.size());        
    }
    static testMethod void testNewAccountErrors(){
        Partner_Portal_Access_Request__c testppar = [SELECT Name FROM Partner_Portal_Access_Request__c WHERE Company_Email__c = '123@123.com'];
        system.debug('Here' + testppar.Name);
        string returnMessage = NewTechPartnerClass.createAcctContact(testppar.Name);
        system.debug(returnMessage);
        system.assertEquals('Could not create', returnMessage.left(16));
    }
    static testMethod void testRequest(){
        Test.setMock(HttpCalloutMock.class, new MockCalloutClass());
        string url;
        Production_Org_Ids__c mySetting = new Production_Org_Ids__c();  //Create a new instance of the Custom Setting
        mySetting = Production_Org_Ids__c.getOrgDefaults();           //get the Org default dataset for our Production Org
        if(UserInfo.getOrganizationId() == mySetting.Org_Id_18_char__c){
            /*We are in Production! Use Production Instance of Skilljar!*/
            url = 'https://api.skilljar.com/v1/domains/kvh.skilljar.com/users';  //Production instance 
        } else {
            /*We are in Sandbox! Use DEV Instance of Skilljar!*/
            url = 'https://api.skilljar.com/v1/domains/kvhsandbox.skilljar.com/users';  //Development instance
        }
        Contact con = [SELECT Email, FirstName, LastName FROM Contact WHERE Email = 'bob@me.com' LIMIT 1];
        Test.startTest();
        HttpResponse res = NewTechPartnerClass.createResponse(con.Email, con.FirstName, con.LastName);
        Test.stopTest();
        // Verify response received contains fake values
        System.assertEquals(res.getStatusCode(), 200);
        string newId = NewTechPartnerClass.parseResponse(res);
        system.assertEquals(newId, null);
     }
    static testMethod void testNoAccount(){
        Test.setMock(HttpCalloutMock.class, new MockCalloutClass());
        Partner_Portal_Access_Request__c testppar = [SELECT Name FROM Partner_Portal_Access_Request__c WHERE Contact_Email__c = 'test1@test.com'];
        Test.startTest();
        string message = NewTechPartnerClass.createContact(testppar.Name);
        Test.stopTest();
        system.assertEquals('Please enter an account for the contact.', message);
    }
    static testMethod void testNewContact(){
        Test.setMock(HttpCalloutMock.class, new MockCalloutClass());
        Partner_Portal_Access_Request__c testppar = [SELECT Name FROM Partner_Portal_Access_Request__c WHERE Contact_Email__c = 'test1@test.com'];
        Account acc = [SELECT Name FROM Account WHERE Name = '1234'];
        testppar.Found_Account__c = acc.Id;
        update testppar;
        Test.startTest();
        string message = NewTechPartnerClass.createContact(testppar.Name);
        Test.stopTest();
        List <Contact> cons = [SELECT Id FROM Contact WHERE Email = 'test1@test.com'];
        system.debug('end: ' + message);
        system.assertEquals(1, cons.size());
        List <User> lusers = [SELECT Id FROM User WHERE Email = 'test1@test.com'];
        system.assertEquals(1, lusers.size());
    }
    static testMethod void testNewStudent(){
        Test.setMock(HttpCalloutMock.class, new MockCalloutClass());
        Contact cont = [SELECT Id, Email, LastName, FirstName FROM Contact WHERE Email = 'bob@me.com'];
        Test.startTest();
        string message = NewTechPartnerClass.createStudent(cont.Id);
        Test.stopTest();
        system.assertEquals('Created.', message.right(8));
    }
    static testMethod void testNewStudent2(){
        Test.setMock(HttpCalloutMock.class, new MockCalloutClass());
        Contact cont = [SELECT Id, Email, LastName, FirstName FROM Contact WHERE Email = 'bob2@me.com'];
        Test.startTest();
        string message = NewTechPartnerClass.createStudent(cont.Id);
        Test.stopTest();
        system.assertEquals('Created.', message.right(8));
    }
    static testMethod void testNewStudent3(){
        Test.setMock(HttpCalloutMock.class, new MockCalloutClass());
        Contact cont = [SELECT Id, Email, LastName, FirstName FROM Contact WHERE Email = 'bob3@me.com'];
        Test.startTest();
        string message = NewTechPartnerClass.createStudent(cont.Id);
        Test.stopTest();
        system.assertEquals('Created.', message.right(8));
    }
    static testMethod void testNewContact2(){
        Partner_Portal_Access_Request__c testppar = [SELECT Name FROM Partner_Portal_Access_Request__c WHERE Contact_Email__c = 'bob4@me.com'];
        Account acc = [SELECT Name FROM Account WHERE Name = '12345'];
        testppar.Found_Account__c = acc.Id;
        update testppar;
        Test.setMock(HttpCalloutMock.class, new MockCalloutClass());
        Test.startTest();
        string message = NewTechPartnerClass.createContact(testppar.Name);
        Test.stopTest();
        List <Contact> cons = [SELECT Id FROM Contact WHERE Email = 'bob4@me.com'];
        system.debug('end: ' + message);
        system.assertEquals(1, cons.size());
    }
    static testMethod void testNewContact3(){
        Test.setMock(HttpCalloutMock.class, new MockCalloutClass());
        Partner_Portal_Access_Request__c testppar = [SELECT Name FROM Partner_Portal_Access_Request__c WHERE Contact_Email__c = 'bob5@me.com'];
        Account acc = [SELECT Name FROM Account WHERE Name = '123456'];
        testppar.Found_Account__c = acc.Id;
        update testppar;
        Test.startTest();
        string message = NewTechPartnerClass.createContact(testppar.Name);
        Test.stopTest();
        List <Contact> cons = [SELECT Id FROM Contact WHERE Email = 'bob5@me.com'];
        system.debug('end: ' + message);
        system.assertEquals(1, cons.size());
    }
    static testMethod void testgroupfuture(){
        skilljar__Student__c stud1 = [SELECT skilljar__Obfuscated_Id__c FROM skilljar__Student__c WHERE Name = 'bob1' LIMIT 1];
        skilljar__Group__c sgroup1 = [SELECT skilljar__Skilljar_Id__c FROM skilljar__Group__c WHERE Name = 'TracVision Land' LIMIT 1];
        Test.setMock(HttpCalloutMock.class, new MockCalloutClass());
        Test.startTest();
        NewTechPartnerClass.addToGroupFuture(stud1.skilljar__Obfuscated_Id__c, sgroup1.skilljar__Skilljar_Id__c);
        Test.stopTest();
        stud1 = [SELECT skilljar__Obfuscated_Id__c FROM skilljar__Student__c WHERE Name = 'bob1' LIMIT 1];
        system.assertEquals('12345678', stud1.skilljar__Obfuscated_Id__c);
    }
    static testMethod void testbaduser(){
        Contact con = [SELECT Id, Email, FirstName, LastName, Account.Partner_Role__c FROM Contact WHERE Email = 'bob@me.com' LIMIT 1];
        Profile PortalProf = new Profile();
        if(con.Account.Partner_Role__c == 'Dealer'){
            PortalProf = [SELECT Id, Name FROM Profile WHERE Name =: 'Partner-Dealer' Limit 1];
        } else if (con.Account.Partner_Role__c == 'Distributor'){
            PortalProf = [SELECT Id, Name FROM Profile WHERE Name =: 'Partner-Distributor' Limit 1];
        } else if(con.Account.Partner_Role__c == 'Service Provider'){
            PortalProf = [SELECT Id, Name FROM Profile WHERE Name =: 'Partner-Service Provider' Limit 1];
        }
        string first = con.FirstName + 'lkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkjlkj';
        Test.startTest();
        NewTechPartnerClass.createUser(con.Id, first, con.LastName, con.email, PortalProf.id);
    	Test.stopTest();
    	List <Case> cases = [SELECT Id FROM Case WHERE Case_Symptom__c = 'Salesforce Error'];
        system.assertEquals(1, cases.size());
    }
}