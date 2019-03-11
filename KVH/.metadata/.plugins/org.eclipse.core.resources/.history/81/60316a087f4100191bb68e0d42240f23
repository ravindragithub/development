/*This handler is called by the Opportunity Line Item trigger
* Version 1.0 "rolls up" specific text fields from the Opportunity Line Items
* and uses those values to populate text fields on the parent Opportunity
*/
/*1/17/2013 Version 2.0 jthom
* changes made to handle a shorter Summary_VSAT_Products text field (was 30, now 15)
* removed "{" and "}" from rolled up text fields that were inherent when converting 
* set<String> to String
*/

public with sharing class OpportunityLineItemTriggerHandler {
	private boolean m_isExecuting = false;
	private integer BatchSize = 0;
	
	public OpportunityLineItemTriggerHandler(boolean isExecuting, Integer size){
		m_isExecuting = isExecuting;
		BatchSize = size;
	}

	/*public void OnBeforeInsert(OpportunityLineItem[] newOpportunityLineItems){
		// EXECUTE BEFORE INSERT LOGIC
	}*/

	public void OnAfterInsert(OpportunityLineItem[] newOpportunityLineItems){
		system.debug('TriggerHandler After Insert Context');
		//Limit the size of list by using Sets which do not contain duplicate elements
		//Just collecting unique Opportunity IDs from the list of OLIs here
		set<Id> OpportunityIds = new set<Id>();
		for (OpportunityLineItem OLIs : newOpportunityLineItems){
			OpportunityIds.add(OLIs.OpportunityId);
			system.debug('added an Opportunity ID to the set');
		}
		//The set now contains all the Opporuntity IDs that have had new lines added
		//Pass that set to the rollup text method
		RollUpTextFields(OpportunityIDs);
	}

	/*public void OnBeforeUpdate(OpportunityLineItem[] oldOpportunityLineItems, OpportunityLineItem[] updatedOpportunityLineItems, Map<Id, OpportunityLineItem> OpportunityLineItemMap) {
		// BEFORE UPDATE LOGIC
	}*/

	public void OnAfterUpdate(OpportunityLineItem[] oldOpportunityLineItems, OpportunityLineItem[] updatedOpportunityLineItems, Map<Id, OpportunityLineItem> OpportunityLineItemMap){
		system.debug('TriggerHandler After Update Context');
		//Limit the size of list by using Sets which do not contain duplicate elements
		//Just collecting unique Opportunity IDs from the list of OLIs here
		set<Id> OpportunityIds = new set<Id>();
		for (OpportunityLineItem OLIs : updatedOpportunityLineItems){
			OpportunityIds.add(OLIs.OpportunityId);
			system.debug('added an Opportunity ID to the set');
		}
		//The set now contains all the Opporuntity IDs that have had new lines added
		//Pass that set and the list of OLIs to the rollup text methid
		RollUpTextFields(OpportunityIDs);
	}

	/*public void OnBeforeDelete(OpportunityLineItem[] OpportunityLineItemsToDelete, Map<Id, OpportunityLineItem> MapOpportunityLineItemMap){
		// BEFORE DELETE LOGIC
	}*/

	public void OnAfterDelete(OpportunityLineItem[] deletedOpportunityLineItems, Map<Id, OpportunityLineItem> MapOpportunityLineItemMap){
		system.debug('TriggerHandler After Update Context');
		//Limit the size of list by using Sets which do not contain duplicate elements
		//Just collecting unique Opportunity IDs from the list of OLIs here
		set<Id> OpportunityIds = new set<Id>();
		for (OpportunityLineItem OLIs : deletedOpportunityLineItems){
			OpportunityIds.add(OLIs.OpportunityId);
			system.debug('added an Opportunity ID to the set');
		}
		//The set now contains all the Opporuntity IDs that have had new lines added
		//Pass that set and the list of OLIs to the rollup text methid
		RollUpTextFields(OpportunityIDs);
	}

	/*public void OnUndelete(OpportunityLineItem[] restoredOpportunityLineItems){
		// AFTER UNDELETE LOGIC
	}*/

	public boolean IsTriggerContext{
		get{ return m_isExecuting;}
	}

	//This method creates the strings, and updates the master Opportunities give a set of Opportunities and a list of OLIs
	//Produce sets of KVH Product Families, Airtime Plans, and CommBox Plans
	//Then iterate through the sets to create a sting value to add to the Opportunity record
	public void RollUpTextFields(set<Id> MasterOpps){
		//get a list of Opportunities from the set of Opportunity IDs
		//and create a map to look them up later
		List<Opportunity> Opps = new List<Opportunity>();
		Map<Id, Integer> IndexOf = new Map<Id, Integer>();
		
		//create a 2D Array of Sets to collect the summary text fields by Opportunity, and text rollup
		List<List<Set<String>>> OppsListRows = new List<List<Set<String>>>();
		Integer i = 0;
		For (Opportunity o : [SELECT id, Name, Summary_airtime_plans__c,
								Summary_VSAT_Products__c, Summary_CommBox_Plans__c 
								FROM Opportunity
								WHERE Id IN :MasterOpps]) {
									
			List<Set<String>> OppsListCols = new List<Set<String>>();
			Set<String> AirPlanRollup = new Set<String>();
			Set<String> VSATProdRollup = new Set<String>();
			Set<String> CBXPlanRollup = new Set<String>();
			OppsListCols.add(AirPlanRollup);	//These are like Column headings
			system.debug(OppsListCols.size());
			OppsListCols.add(VSATProdRollup);	//at indexes 0, 1, 2...
			system.debug(OppsListCols.size());
			OppsListCols.add(CBXPlanRollup);
			system.debug(OppsListCols.size());
				
			OppsListRows.add(OppsListCols);		//Our list of Array Rows is synced with
			Opps.add(o);						//Our list of Opportunities
			IndexOf.put(o.Id, Opps.size()-1);	//and now we can find the opportunity in our list
												//by the Opportunity ID			
			system.debug('added Opportunity ' + o.Name + ' to list at index ' + i);
			i=i+1;
		}

		/* I think we are going to skip the outer loop....
		We'll just loop through all the OLIs, and update the Opps List with the new
		text rollup values. After all the OLIs have been processed, we can loop through the Opps List
		and implment the DML update there. hat should help to keep us out of trouble with
		the SF governor limits */
		//Initial 3 <String> variable to be updated to the Master Opportunity  
		Integer j = 0; //Inner counter
		//This will loop through ALL the Opp Line Items even though it's most likely 
		//just a single line item invoking the trigger
		for (OpportunityLineItem OLIs : [SELECT Id, OpportunityId, 
											Product_Family__c, KVH_Product_Family_Name__c,
											PricebookEntry.Name
										FROM OpportunityLineItem 
										WHERE OpportunityId IN :MasterOpps]) {
			//Get the Product Family Text from the OLI
			String FamilyText = OLIs.Product_Family__c; //.Product_Family__c is "Opportunity Family"!!
			system.debug(FamilyText);
			//Inner loop is all OLIs for that Opportunity
			if (FamilyText == 'Airtime') {
				system.debug(OLIs.PricebookEntry.Name);
				Set<String> LocalSet = new set<String>();	//make a new set
				LocalSet = OppsListRows.get(IndexOf.get(OLIs.OpportunityId)).get(0).clone();	//copy the existing set
				LocalSet.Add(OLIs.PricebookEntry.Name);	//Add the airtime plan name... don't worry about dupes in a set
				OppsListRows.get(IndexOf.get(OLIs.OpportunityId)).set(0, LocalSet);	//put the LocalSet back in the Array
				system.debug(OppsListRows.get(IndexOf.get(OLIs.OpportunityId)).get(0));

			}  	else if (FamilyText == 'VSAT') {
				system.debug(OLIs.KVH_Product_Family_Name__c);
				Set<String> LocalSet = new set<String>();	//make a new set
				LocalSet = OppsListRows.get(IndexOf.get(OLIs.OpportunityId)).get(1).clone();	//copy the existing set
				LocalSet.Add(OLIs.KVH_Product_Family_Name__c);	//Add the VSAT Product name... don't worry about dupes in a set
				OppsListRows.get(IndexOf.get(OLIs.OpportunityId)).set(1, LocalSet);	//put the LocalSet back in the Array
				system.debug(OppsListRows.get(IndexOf.get(OLIs.OpportunityId)).get(1));

			}	else if (FamilyText == 'CommBox') {
				system.debug(OLIs.PricebookEntry.Name);
				Set<String> LocalSet = new set<String>();	//make a new set
				LocalSet = OppsListRows.get(IndexOf.get(OLIs.OpportunityId)).get(2).clone();	//copy the existing set
				LocalSet.Add(OLIs.PricebookEntry.Name);	//Add the CommBox plan name... don't worry about dupes in a set
				OppsListRows.get(IndexOf.get(OLIs.OpportunityId)).set(2, LocalSet);	//put the LocalSet back in the Array
				system.debug(OppsListRows.get(IndexOf.get(OLIs.OpportunityId)).get(2));				

			}	else	{
				system.debug('NOTHING Hit!');	//else do nothing!
			}
			system.debug('Loop Counter ' + j);
			j=j+1;
		}

		For (Integer k = 0; k < Opps.size(); k++) {	//loop through the Opps list using a kounter (with a k)
			String Fitted = '';	//Just a string to use during this loop...
			
			Fitted = String.valueOf(OppsListRows.get(k).get(0));	//airtime plans
			Fitted = Fitted.remove('{');							//remove "{" and "}"
			Fitted = Fitted.remove('}');
			Opps.get(k).Summary_airtime_plans__c = Fitted.abbreviate(29);	//Make sure that the string fits in the field! (30 chars)
			
			Fitted = String.valueOf(OppsListRows.get(k).get(1));	//VSAT products
			Fitted = Fitted.remove('{');							//remove "{" and "}"
			Fitted = Fitted.remove('}');
			Opps.get(k).Summary_VSAT_Products__c = Fitted.abbreviate(14);	//Make sure that the string fits in the field! (15 chars)
			
			Fitted = String.valueOf(OppsListRows.get(k).get(2));	//CommBox plans
			Fitted = Fitted.remove('{');							//remove "{" and "}"
			Fitted = Fitted.remove('}');
			Opps.get(k).Summary_CommBox_Plans__c = Fitted.abbreviate(29);	//Make sure that the string fits in the field! (30 chars)
		}
		Try	{
			update Opps;
			system.debug('Update complete!');
		}
		catch (Exception Ex){
			system.debug(Ex);
		}
	}
}