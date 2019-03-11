@RestResource(urlMapping='/V1/beams/*')
/* Version 1.1, added Status__c to response 
 * jthom 10/1/13                            
 * Version 1.2 added Utilization_Name__c to response
 * jthom 1/27/14                                      */
global with sharing class REST_beams {
	@HttpGet
	//Responds to an HttpGet naturally... 
	//Given an Beam ID, this Class returns the details of the Beam record
	//Provding for an "all" parameter as well
	global static Beam__c[] doGet(){
		RestRequest req = RestContext.request;
		RestResponse res = RestContext.response;
		//declare return list
		List<Beam__c> Beams = new List<Beam__c>();
		//variables for Asset query
		String identifier = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
		if (identifier.left(3) == 'a1L') {//a1Y in ServCloud Sandbox
			 							  //a1L in Production!!
			Try {
				/*Beams = [SELECT Id, Name, ACU_Name__c, Orbital_Location__c, Frequency_KU_Downlink_MHz__c ,
							Frequency_Band__c, Modulation__c , Feed_Designator__c, Google_Designator__c,
							Management_Mod_Code__c, V11_Mod_Code__c, V3_Mod_Code__c, V7_Mod_Code__c, 
							Status__c, Utilization_Name__c, KVH_Health_Monitor__c, KVH_Health_Monitor__r.Name,
							ViaSat_Monitor__c, ViaSat_Monitor__r.Name
							FROM Beam__c WHERE Id=:identifier];*/
				Beams = [SELECT Id, Name, ACU_Name__c, ViaSat_Name__c, Utilization_Name__c, Feed_Designator__c, Google_Designator__c, 
								Status__c, IPMC_Enabled__c, Modulation__c, Is_FAP_SMP__c, 
								Map_Name__c, Region__c, MegaPoP__c, isForeign_Teleport__c,
								Frequency_Band__c, Frequency_KU_Downlink_MHz__c, Forward_Link_Frequency__c, 
								Management_Mod_Code__c, V7_Mod_Code__c, V3_Mod_Code__c, V11_Mod_Code__c, 
								Allot_Return_Link_Limit__c, Allot_Forward_Link_Limit__c, Return_Link_simacs__c, 
								Mod_Code_Rate_54__c, Mod_Code_Rate_52__c, Mod_Code_Rate_35__c, 
								Mod_Code_Rate_33__c, Mod_Code_Rate_31__c, Mod_Code_Rate_29__c, 
								Mod_Code_Rate_28__c, Mod_Code_Rate_26__c, Mod_Code_Rate_25__c, 
								Mod_Code_Rate_24__c, Mod_Code_Rate_22__c, Mod_Code_Rate_20__c, 
								Mod_Code_Rate_18__c, Mod_Code_Rate_16__c,
								Number_of_SPARE_cards__c, Number_of_GOV_cards__c, Number_of_768mbps_cards__c, 
								Number_of_64mbps_cards__c, Number_of_512mbps_cards__c, Number_of_384mbps_cards__c, 
								Number_of_256mbps_cards__c, Number_of_128mbps_cards__c, Number_of_1024mbps_cards__c, 
								SAT_Name__c, SAT_Longitude__c, SAT_Long__c, Orbital_Location__c, 
								ViaSat_Monitor__c, ViaSat_Monitor__r.Name, KVH_Health_Monitor__c, KVH_Health_Monitor__r.Name,
								Teleport__c, Location__c, 
								File_Name_per_CDRs__c, Hub_per_Custom_Call__c, Hub_Id__c, Footprint__c, 
								Share_Payable_to_ViaSat__c, Payable_to_JSAT__c, Management_Fee_payable_to_ViaSat__c, Pipe_per_CDRs__c, Airtime_Notes__c,
								CreatedDate, CreatedById, LastModifiedDate, LastModifiedById 
							FROM Beam__c WHERE Id=:identifier];
				if (Beams.size()==0){
					res.statusCode = 404;
				}
			} Catch (Exception e) { res.statusCode = 500; }	//Something bad happened... Should never get here!
															//recommended remedial action is try again!
		} else if (identifier.left(3) == 'all'){
			//Someone wants ALL the Beams! Maybe they are re-building database!
			Try {
				system.debug('Trying to get all Beams...');
				Beams = [SELECT Id, Name, ACU_Name__c, ViaSat_Name__c, Utilization_Name__c, Feed_Designator__c, Google_Designator__c, 
								Status__c, IPMC_Enabled__c, Modulation__c, Is_FAP_SMP__c, 
								Map_Name__c, Region__c, MegaPoP__c, isForeign_Teleport__c,
								Frequency_Band__c, Frequency_KU_Downlink_MHz__c, Forward_Link_Frequency__c, 
								Management_Mod_Code__c, V7_Mod_Code__c, V3_Mod_Code__c, V11_Mod_Code__c, 
								Allot_Return_Link_Limit__c, Allot_Forward_Link_Limit__c, Return_Link_simacs__c, 
								Mod_Code_Rate_54__c, Mod_Code_Rate_52__c, Mod_Code_Rate_35__c, 
								Mod_Code_Rate_33__c, Mod_Code_Rate_31__c, Mod_Code_Rate_29__c, 
								Mod_Code_Rate_28__c, Mod_Code_Rate_26__c, Mod_Code_Rate_25__c, 
								Mod_Code_Rate_24__c, Mod_Code_Rate_22__c, Mod_Code_Rate_20__c, 
								Mod_Code_Rate_18__c, Mod_Code_Rate_16__c,
								Number_of_SPARE_cards__c, Number_of_GOV_cards__c, Number_of_768mbps_cards__c, 
								Number_of_64mbps_cards__c, Number_of_512mbps_cards__c, Number_of_384mbps_cards__c, 
								Number_of_256mbps_cards__c, Number_of_128mbps_cards__c, Number_of_1024mbps_cards__c, 
								SAT_Name__c, SAT_Longitude__c, SAT_Long__c, Orbital_Location__c, 
								ViaSat_Monitor__c, ViaSat_Monitor__r.Name, KVH_Health_Monitor__c, KVH_Health_Monitor__r.Name,
								Teleport__c, Location__c, 
								File_Name_per_CDRs__c, Hub_per_Custom_Call__c, Hub_Id__c, Footprint__c, 
								Share_Payable_to_ViaSat__c, Payable_to_JSAT__c, Management_Fee_payable_to_ViaSat__c, Pipe_per_CDRs__c, Airtime_Notes__c,
								CreatedDate, CreatedById, LastModifiedDate, LastModifiedById
							FROM Beam__c];
				if (Beams.size()==0){
					res.statusCode = 404;
				}
			} Catch (Exception e) { res.statusCode = 500; }	//Something bad happened... Should never get here!
															//recommended remedial action is try again!
		} else {
			//We did not get a Beam identifier
			res.statusCode = 400;		//Something bad happened... Should never get here!
										//recommended remedial action is try again!
		
		}
		return Beams;
	}
}