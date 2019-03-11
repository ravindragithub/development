/***********************************************************************************************************************
 Name: SatInfoXMLControllerTest 
 Copyright © 2014 KVH Industries | Salesforce Instance : 
========================================================================================================================
 Purpose: This is used to test "SatInfoXMLController" class 
------------------------------------------------------------------------------------------------------------------------
 Utilized in(Called in):
-----------------------
                                           
========================================================================================================================
 REQUIREMENT INFORMATION & DEVELOPMENT INFORMATION:                                                        
------------------------------------------------------------------------------------------------------------------------
 VERSION    AUTHOR              DATE             DETAIL                                Mercury Request #
------------------------------------------------------------------------------------------------------------------------
   1.0     Gopi Kishore. K      17/03/2014       Initial Development                                   
***********************************************************************************************************************/

@isTest
private class SatInfoXMLControllerTest {

    static testMethod void testxml() {
      
      test.StartTest();
      
      //CustomSetting Insertion
     
      List<DecodeTypeTuners__c> allDTTS = new List<DecodeTypeTuners__c>();
      
      
      DecodeTypeTuners__c DTT = new DecodeTypeTuners__c();
      DTT.Name = 'DCII QPSK DigiCipher 2';
      DTT.ModeTypeinXML__c = 'QDC2';
      allDTTS.add(DTT);
      
      DecodeTypeTuners__c DTT1 = new DecodeTypeTuners__c();
      DTT1.Name = 'DVB QPSK';
      DTT1.ModeTypeinXML__c = 'QDVB';
      allDTTS.add(DTT1);
      
      DecodeTypeTuners__c DTT2 = new DecodeTypeTuners__c();
      DTT2.Name = 'DSS DTV';
      DTT2.ModeTypeinXML__c = 'QDSS';
      allDTTS.add(DTT2);
      
      insert allDTTS;
    
      //TVRO Header Object Insertion
      
      TVRO_Header__c tvro = new TVRO_Header__c();
      tvro.DocLastEdited__c = system.now();
      tvro.docPN__c = 'TVRO External';
      tvro.DocRev__c = 'R';
      tvro.DocSVNRev__c = '1.0';
      insert tvro;
      
      //SatinfoMaster Object Insertion
      
      SatInfoMaster__c  satinfo = new SatInfoMaster__c();
      satinfo.antsatID__c = 'test external id';
      satinfo.bandHH__c = 'H';
    //  satinfo.bandHHalt__c ='L';
      satinfo.bandHL__c = 'H';
   //   satinfo.bandHLalt__c = 'L';
      satinfo.bandVH__c = 'H';
    //  satinfo.bandVHalt__c = 'L';
      satinfo.bandVL__c = 'L';
   //   satinfo.bandVLalt__c = 'H';
      satinfo.decodetypeHH__c = 'DVB QPSK';
      satinfo.decodetypeHHalt__c = 'DVB QPSK';
      satinfo.decodetypeHL__c = 'DVB QPSK';
      satinfo.decodetypeVH__c = 'DSS DTV';
      satinfo.decodetypeVHalt__c = 'DSS DTV';
      satinfo.decodetypeVL__c = 'DCII QPSK DigiCipher 2';
      satinfo.decodetypeVLalt__c = 'DSS DTV';
      satinfo.Doc_Rev__c = 'AR';
      satinfo.Doc_SVN_Rev__c = '0';
      satinfo.Document_PN__c = '56-0258';
      satinfo.Enabled__c = true;
      satinfo.Favorite__c = true;
      satinfo.FEC_Code_HH__c = '23';
      satinfo.FEC_Code_HHalt__c = '45';
      satinfo.FEC_Code_HL__c = '12';
      satinfo.FEC_Code_HLalt__c = '910';
      satinfo.FEC_Code_VH__c = '12';
      satinfo.FEC_Code_VHalt__c = '45';
      satinfo.FEC_Code_VL__c = '34';
      satinfo.FEC_Code_VLalt__c = '56';
      satinfo.FrequencyHH__c = '11606';
      satinfo.FrequencyHHalt__c = '11605';
      satinfo.FrequencyHL__c = '11405';
      satinfo.FrequencyHLalt__c = '12450';
      satinfo.FrequencyVH__c = '10100';
      satinfo.FrequencyVHalt__c = '12345';
      satinfo.FrequencyVL__c = '12378';
      satinfo.FrequencyVLalt__c = '12389';
      satinfo.Hemisphere__c = 'East';
      satinfo.Local_Oscillator_1__c = 'test band';
      satinfo.Install_Name_HD11__c = 'AM80E';
      satinfo.Install_Name_M3__c = 'N/A';
      satinfo.Install_Name_M7__c = 'N/A';
      satinfo.Install_Name_M9__c = 'AME53E';
      satinfo.Is_Tri_Sat__c = true;
      satinfo.KU_Mode__c = 'Wide';
      satinfo.listID__c = 4;
      satinfo.Local_Oscillator_2__c = '10600';
      satinfo.Name__c = 'Express AM2';
      satinfo.NetworkidHH__c = '0XFFFE';
      satinfo.NetworkidHHalt__c = '0XFFFE';
      satinfo.NetworkidHL__c = '0XFFFE';
      satinfo.NetworkidHLalt__c = '0XFFFE';
      satinfo.NetworkidVH__c = '0XFFFE';
      satinfo.NetworkidVHalt__c = '0XFFFE';
      satinfo.NetworkidVL__c = '0XFFFE';
      satinfo.NetworkidVLalt__c = '0XFFFE';
      satinfo.Orbital_Position__c = '140E';
      satinfo.PolarizationHH__c = 'Vertical';
      satinfo.PolarizationHH__c = 'Horizontal';
      satinfo.PolarizationHL__c = 'Vertical';
      satinfo.PolarizationVH__c = 'Horizontal';
      satinfo.PolarizationVL__c = 'Horizontal';
      satinfo.Pre_Skew__c = 30;
      satinfo.Region__c = 'Asia';
      satinfo.Sat_Longitude_text__c = '80.03';
      satinfo.selectable__c = true;
      satinfo.Service__c = 'Viva TV';
      satinfo.Suffix__c = 'N';
      satinfo.symbolRateHH__c = '30000';
      satinfo.symbolRateHHalt__c ='30000';
      satinfo.symbolRateHL__c ='30000';
      satinfo.symbolRateHLalt__c ='30000';
      satinfo.symbolRateVH__c ='30000';
      satinfo.symbolRateVHalt__c ='30000';
      satinfo.symbolRateVL__c ='30000';
      satinfo.symbolRateVLalt__c ='30000';
      satinfo.TVRO_Header__c = tvro.id;
      satinfo.Variable_Name_HH__c = 'var';
      satinfo.Variable_Name_HHalt__c = 'var';
      satinfo.Variable_Name_HLalt__c = 'var';
      satinfo.Variable_Name_VH__c = 'var';
      satinfo.Variable_Name_VHalt__c = 'var';
      satinfo.Variable_Name_VL__c = 'var';
      satinfo.Variable_Name_VLalt__c = 'var';
      satinfo.variable_name_HL__c = 'var';
      insert satinfo;
      
      Tuner1_2__c tuner1Data = New Tuner1_2__c();
      
      tuner1Data.SatInfoMaster__c = satinfo.id;
      
      tuner1Data.bandHH__c = 'H';
      tuner1Data.bandHL__c = 'H';
      tuner1Data.bandVH__c = 'H';
      tuner1Data.bandVL__c = 'L';
      
      tuner1Data.PolarizationHH__c = 'Horizontal';
      tuner1Data.PolarizationHL__c = 'Vertical';
      tuner1Data.PolarizationVH__c = 'Horizontal';
      tuner1Data.PolarizationVL__c = 'Horizontal';
      
      tuner1Data.FrequencyHH__c = '11606';
      tuner1Data.FrequencyHL__c = '11405';
      tuner1Data.FrequencyVH__c = '10100';
      tuner1Data.FrequencyVL__c = '12378';
      
      tuner1Data.symbolRateHH__c = '30000';
      tuner1Data.symbolRateHL__c ='30000';
      tuner1Data.symbolRateVH__c ='30000';
      tuner1Data.symbolRateVL__c ='30000';
      
      tuner1Data.FEC_Code_HH__c = '23';
      tuner1Data.FEC_Code_HL__c = '12';
      tuner1Data.FEC_Code_VH__c = '12';
      tuner1Data.FEC_Code_VL__c = '34';
      
      
      tuner1Data.NetworkidHH__c = '0XFFFE';
      tuner1Data.NetworkidHL__c = '0XFFFE';
      tuner1Data.NetworkidVH__c = '0XFFFE';
      tuner1Data.NetworkidVL__c = '0XFFFE';
      
      tuner1Data.decodetypeHH__c = 'DVB QPSK';
      tuner1Data.decodetypeHL__c = 'DVB QPSK';
      tuner1Data.decodetypeVH__c = 'DSS DTV';
      tuner1Data.decodetypeVL__c = 'DCII QPSK DigiCipher 2';
      
      tuner1Data.Variable_Name_HH__c = 'var';
      tuner1Data.Variable_Name_VH__c = 'var';
      tuner1Data.Variable_Name_VL__c = 'var';
      tuner1Data.variable_name_HL__c = 'var';
      
      
      tuner1Data.RecordTypeID = Schema.SObjectType.Tuner1_2__c.getRecordTypeInfosByName().get('Tuner 1').getRecordTypeId();
      
      insert tuner1Data;
      
      
      Tuner1_2__c tuner2Data = New Tuner1_2__c();
      
      tuner2Data.SatInfoMaster__c = satinfo.id;
      
      tuner2Data.FrequencyHHalt__c = '11606';
      tuner2Data.FrequencyHLalt__c = '11405';
      tuner2Data.FrequencyVHalt__c = '10100';
      tuner2Data.FrequencyVLalt__c = '12378';
      
      tuner2Data.symbolRateHHalt__c = '30000';
      tuner2Data.symbolRateHLalt__c ='30000';
      tuner2Data.symbolRateVHalt__c ='30000';
      tuner2Data.symbolRateVLalt__c ='30000';
      
      tuner2Data.FEC_Code_HHalt__c = '23';
      tuner2Data.FEC_Code_HLalt__c = '12';
      tuner2Data.FEC_Code_VHalt__c = '12';
      tuner2Data.FEC_Code_VLalt__c = '34';
      
      
      tuner2Data.NetworkidHHalt__c = '0XFFFE';
      tuner2Data.NetworkidHLalt__c = '0XFFFE';
      tuner2Data.NetworkidVHalt__c = '0XFFFE';
      tuner2Data.NetworkidVLalt__c = '0XFFFE';
      
      tuner2Data.decodetypeHHalt__c = 'DVB QPSK';
      tuner2Data.decodetypeHLalt__c = 'DVB QPSK';
      tuner2Data.decodetypeVHalt__c = 'DSS DTV';
      tuner2Data.decodetypeVLalt__c = 'DCII QPSK DigiCipher 2';
      
      tuner2Data.Variable_Name_HHalt__c = 'var';
      tuner2Data.Variable_Name_VHalt__c = 'var';
      tuner2Data.Variable_Name_VLalt__c = 'var';
      tuner2Data.variable_name_HLalt__c = 'var';
      
      
      tuner2Data.RecordTypeID = Schema.SObjectType.Tuner1_2__c.getRecordTypeInfosByName().get('Tuner 2').getRecordTypeId();
      
      insert tuner2Data;
      
      tuner2Data.decodetypeVLalt__c = 'DCII QPSK DigiCipher 3';
      update tuner2Data;
      
      //Group Object Insertion
        
      Group__c groupobj = new Group__c();
      groupobj.Name = 'test group';
      groupobj.A__c = satinfo.id;
      groupobj.B__c = satinfo.id;
      groupobj.C__C = satinfo.id;
      groupobj.D__C = satinfo.id;
      groupobj.Predefined__c = 'test';
      groupobj.TVRO_Header__c = tvro.id;
      insert groupobj;
      
      groupobj.Predefined__c = 'Y';
      update groupobj;
      
      TVRO_Provider__c newTVROProvider = new TVRO_Provider__c();
      newTVROProvider.Name = 'TVRO Record';
      insert newTVROProvider;
      
      TVRO_Provider__c newTVROProviderRec = new TVRO_Provider__c();
      newTVROProviderRec.Name = 'TVRO Record';
      insert newTVROProviderRec;
      
      
      TVRO_Satellites_with_Services__c TVROServies = new TVRO_Satellites_with_Services__c();
      TVROServies.Satellite_Record__c = satinfo.id;
      TVROServies.TRVO_Provider__c = newTVROProvider.id;
      insert TVROServies;
      
      newTVROProvider.Name = 'TVRO RecordUpdate';
      update newTVROProvider;
      
      
      TVROServies.TRVO_Provider__c = newTVROProviderRec.id;
      update TVROServies;
      
      
      
      
      //Passing Parameters to Current page
      
      apexpages.currentpage().getparameters().put('id',tvro.id);
      apexpages.currentpage().getparameters().put('environment','production');
      
      //Calling main(SatInfoXMLController) class to test
      SatInfoXMLController.stopExternalsite = true;
      SatInfoXMLController satinfoxml = new SatInfoXMLController(); 
      
      
      //Test to test for sandbox
      apexpages.currentpage().getparameters().put('environment','sandbox');
      SatInfoXMLController satinfoSandboxXml = new SatInfoXMLController(); 
      
      //Custom Setting " ModeTypeinXML__c " should Appear in XML.
      
      
      system.assertEquals(true,satinfoxml.xmlForm.contains(DTT.ModeTypeinXML__c));
      system.assertnotEquals(false,satinfoxml.xmlForm.contains(DTT.ModeTypeinXML__c));
      
     
      //Custom Setting names should not Appear in XML.
      
      system.assertEquals(false,satinfoxml.xmlForm.contains(DTT.Name));
      system.assertnotEquals(true,satinfoxml.xmlForm.contains(DTT.Name));
      
      Test.stopTest();
    }
    
}