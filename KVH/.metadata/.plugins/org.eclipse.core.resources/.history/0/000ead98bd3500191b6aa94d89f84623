<!-----------------------------------------------------js function for  Confirm Selected Subscriber----------------------------------------->
        function ConfirmSelectedSubscriber(){
            var r = confirm("Are you sure you want to confirm and move the platform to this subscriber account?");
            if (r == true) {
               confirmSubscriber();
            }
        }
        <!-----------------------------------------------------js function for  Confirm Selected SubscriberEnds-------------------------------->
        
        function UpdatingExistingSubscriber(){
            var r = confirm("If you need to Edit the address on this account, you will need to ensure that you have first created a Contact/Role for the Airtime Account.\n\nAre you sure you want to edit this account?");
            if (r == true) {
               updatingSubscriberFifthBlock();
            }
        }
        <!-----------------------------------------------------js function for  populating address--------------------------------------------->
        function callPopulateFunction(){
            try{
				sforce.connection.sessionId = '{!$Api.Session_ID}';
                var str = document.getElementById('page:frm:TPB:TBS:parentID:parentAccountID_lkid').value;
				alert('I AM CALLNG'+sforce.connection.sessionId);
                var query = "select id,Address_1__c,Address_2__c,City__c,Country__c,Postal_Zipcode__c,State__c,Zip_4__c from Address__c where Account__c = '" + str + "'";
                result = sforce.connection.query(query);
                records = result.getArray("records");
				alert('I AM CALLNG'+records.length);
                if(records.length>0){
                    <!--Populate Subsciber Address-->
                    document.getElementById('page:frm:TPB:TBS1:address:Add1').value = records[0].Address_1__c;
                    document.getElementById('page:frm:TPB:TBS1:address:Add2').value = records[0].Address_2__c;
                    document.getElementById('page:frm:TPB:TBS1:address:BC').value = records[0].City__c;
                    document.getElementById('page:frm:TPB:TBS1:address:BST').value = records[0].State__c;
                    document.getElementById('page:frm:TPB:TBS1:address:BillingCountry').value = records[0].Country__c;
                    document.getElementById('page:frm:TPB:TBS1:address:BPC').value = records[0].Postal_Zipcode__c;
                    <!--Populate Billing Address-->
                    document.getElementById('page:frm:TPB:TBS1:BA:BA_Add1').value = records[0].Address_1__c;
                    document.getElementById('page:frm:TPB:TBS1:BA:BA_Add2').value = records[0].Address_2__c;
                    document.getElementById('page:frm:TPB:TBS1:BA:BA_BC').value = records[0].City__c;
                    document.getElementById('page:frm:TPB:TBS1:BA:BA_BST').value = records[0].State__c;
                    document.getElementById('page:frm:TPB:TBS1:BA:BA_BillingCountry').value = records[0].Country__c;
                    document.getElementById('page:frm:TPB:TBS1:BA:ZPC:BA_BPC').value = records[0].Postal_Zipcode__c;
                }
             }catch(e){
                alert('An Error has Occured. Error:' +e);
            }
        }
        <!-----------------------------------------------------js function for  populating address-Ends---------------------------------------->
        <!-----------------------------------------------------js function for Confirm New Subscriber----------------------------------------->
        function ConfirmNewSubscriber(){
           var r = confirm("Are you sure you want to create a new child subscriber account?");
           if (r == true) {
              SelectedNewSubscriber();
           }	   
        }
        var globalSelection;
        function Radioselection(){
            globalSelection = true;
        }
        <!-----------------------------------------------------js function for Confirm New Subscriber-Ends------------------------------------->
        <!-----------------------------------------------------js function for validating Subscriber should not be null------------------------>
        function pleaseSelectAtleastOneSubscriber(){
          if(globalSelection){
              var r = confirm("Are you sure you want to create a new child subscriber account?");
              if (r == true) {
                 SelectedNewSubscriber();
              }
          }else{
              alert("please select atleast one account");
          }
        }
        <!------------------------------------------------------js function for validating Subscriber should not be null- Ends----------------->
        <!-----------------------------------------------------js function for update Subscriber Creation-------------------------------------->
        function updateSubscriber(){
          var r = confirm("Are you sure you want to insert/update subscriber account?");
          if (r == true) {
             refreshFifthBlock();
          }
        }
        <!-----------------------------------------------------js function for update Subscriber Creation Ends---------------------------------->
        <!-----------------------------------------------------js function for new Subscriber Creation------------------------------------------>
        function NewSubscriberCreation(){
           var r = confirm("Are you sure you want to create new subscriber account?");
           if (r == true) {
            NewSubscriberCreationfromJS();
           }
        }
        <!-----------------------------------------------------js function for new Subscriber Creation Ends-------------------------------------->
        <!-----------------------------------------------------js function for new Subscriber---------------------------------------------------->
        function newSubscriber(){
			if(document.getElementById('page:frm:TPB:TBS:ASection:Atype').value == 'Customer'){
				  if(document.getElementById('page:frm:TPB:BS:BSS:BT').value == 'See Corporate'){
					  if(document.getElementById('page:frm:TPB:BS:BSC:BSC_Bill_Corp').checked != false || document.getElementById('page:frm:TPB:BS:BSC:BSC_Mail_Corp').checked != false){
						  var r = confirm("Are you sure you want to create new subscriber account?");
						  if (r == true) {
							 FinalSubmissionSubscriber();
						  }
					  }else{
						alert('Bill To Corporate & Mail To Corporate Should be True');
					  }
				  }else{
					var r = confirm("Are you sure you want to create new subscriber account?");
						  if (r == true) {
							 FinalSubmissionSubscriber();
						  }
				  }
			  } else {
			   var r = confirm("Are you sure you want to create new subscriber account?");
					  if (r == true) {
						 FinalSubmissionSubscriber();
					  }
			  }
        }

	function newCustomerSubscriber(){
              var r = confirm("Are you sure you want to create new subscriber account?");
              if (r == true) {
                 SelectedNewSubscriber();
              }
        }


	
        <!-----------------------------------------------------js function for new Subscriber Ends-------------------------------------------->
        <!------------------------------------------------------js function for FinalSubmission------------------------------------------------>
        function FinalSubmissionSubscriberJS(){
          var final = confirm("Are you sure you want to confirm and move the Platform to this Subscriber Account?");
          if (final == true) {
            FinalSubmissionSubscriber();
            return false;
          }
        }
        <!-----------------------------------------------------js function for FinalSubmission Ends-------------------------------------------->
        <!------------------------------------------------------js function for GoBack---------------------------------------------------------->
        function GoBack(){
          var final = confirm("Are you sure you want to modify?");
          if (final == true) {
          goBack();
          }
        }
       <!-----------------------------------------------------js function for GoBack Ends------------------------------------------------------>
       <!-----------------------------------------------------js function for Cancel------------------------------------------------------------>
        
       <!-----------------------------------------------------js function for Cancel Ends------------------------------------------------------>
       <!-----------------------------------------------------js function for returning currentPage-------------------------------------------->
        function saveReturnPage(){
           var CurrentPageID = '{!subscriberId}';
           window.location.href = '/'+CurrentPageID;
        }
       <!----------------------------------------------------js function for returning currentPage-Ends---------------------------------------->
       <!-----------------------------------------------------js function for Search Again----------------------------------------------------->
        function SearhAgain(){
          var final = confirm("Are you sure you want to restart search?");
          if (final == true) {
            SearhAgain();
          }
        }
       <!-----------------------------------------------------js function for Search Again-Ends------------------------------------------------>
       <!-----------------------------------------------------js function for enabling address fields------------------------------------------>
        function CopySubAddToBillAdd(){       
            var BA_Add1 = document.getElementById("page:frm:TPB:TBS1:address:Add1").value ;
             alert("====copied"+BA_Add1);
            if(BA_Add1!=null)
            document.getElementById("page:frm:TPB:TBS1:BA:BA_Add1").value = BA_Add1;
                       
        }
        function EnableBillingAddress(){
            var accessLevel = document.getElementById("page:frm:TPB:TBS1:address:disableCheckBox").checked;
            var BA_Add1 = document.getElementById("page:frm:TPB:TBS1:address:Add1").value ;
            var BA_Add2 = document.getElementById("page:frm:TPB:TBS1:address:Add2").value ;
            var BA_BC = document.getElementById("page:frm:TPB:TBS1:address:BC").value ;
            var BA_BST = document.getElementById("page:frm:TPB:TBS1:address:BST").value ;
            var BA_BillingCountry = document.getElementById("page:frm:TPB:TBS1:address:BillingCountry").value ;
            var BA_BPC = document.getElementById("page:frm:TPB:TBS1:address:BPC").value ;
           
            if(accessLevel == false){
            
                document.getElementById("page:frm:TPB:TBS1:BA:BA_Add1").disabled = false;
                document.getElementById("page:frm:TPB:TBS1:BA:BA_Add2").disabled = false;
                document.getElementById("page:frm:TPB:TBS1:BA:BA_BC").disabled = false;
                document.getElementById("page:frm:TPB:TBS1:BA:BA_BST").disabled = false;
                document.getElementById("page:frm:TPB:TBS1:BA:BA_BillingCountry").disabled = false;
                document.getElementById("page:frm:TPB:TBS1:BA:ZPC:BA_BPC").disabled = false;
           
                document.getElementById("page:frm:TPB:TBS1:BA:BA_Add1").value = '';
                document.getElementById("page:frm:TPB:TBS1:BA:BA_Add2").value = '';
                document.getElementById("page:frm:TPB:TBS1:BA:BA_BC").value = '';
                document.getElementById("page:frm:TPB:TBS1:BA:BA_BST").value = '';
                document.getElementById("page:frm:TPB:TBS1:BA:BA_BillingCountry").value = '';
                document.getElementById("page:frm:TPB:TBS1:BA:ZPC:BA_BPC").value = '';
            }else{
           
                document.getElementById("page:frm:TPB:TBS1:BA:BA_Add1").value = BA_Add1;
                document.getElementById("page:frm:TPB:TBS1:BA:BA_Add2").value = BA_Add2;
                document.getElementById("page:frm:TPB:TBS1:BA:BA_BC").value = BA_BC;
                document.getElementById("page:frm:TPB:TBS1:BA:BA_BST").value = BA_BST;
                document.getElementById("page:frm:TPB:TBS1:BA:BA_BillingCountry").value = BA_BillingCountry;
                document.getElementById("page:frm:TPB:TBS1:BA:ZPC:BA_BPC").value = BA_BPC;
                
                document.getElementById("page:frm:TPB:TBS1:BA:BA_Add1").disabled = true;
                document.getElementById("page:frm:TPB:TBS1:BA:BA_Add2").disabled = true;
                document.getElementById("page:frm:TPB:TBS1:BA:BA_BC").disabled = true;
                document.getElementById("page:frm:TPB:TBS1:BA:BA_BST").disabled = true;
                document.getElementById("page:frm:TPB:TBS1:BA:BA_BillingCountry").disabled = true;
                document.getElementById("page:frm:TPB:TBS1:BA:ZPC:BA_BPC").disabled = true;
            }
        }
      <!-----------------------------------------------------js function for enabling address fields Ends----------------------------------------------------->
      <!-----------------------------------------------------js function for disabling address fields--------------------------------------------------------->
        function disableFunction() {
             
              document.getElementById("page:frm:TPB:TBS1:BA:BA_Add1").disabled = true;
              document.getElementById("page:frm:TPB:TBS1:BA:BA_Add2").disabled = true;
              document.getElementById("page:frm:TPB:TBS1:BA:BA_BC").disabled = true;
              document.getElementById("page:frm:TPB:TBS1:BA:BA_BST").disabled = true;
              document.getElementById("page:frm:TPB:TBS1:BA:BA_BillingCountry").disabled = true;
              document.getElementById("page:frm:TPB:TBS1:BA:ZPC:BA_BPC").disabled = true;
        };    
     <!-----------------------------------------------------js function for disabling address fields Ends----------------------------------------------------->
  