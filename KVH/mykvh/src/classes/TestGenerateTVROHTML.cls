@isTest
Private Class TestGenerateTVROHTML{
    static testmethod void GenerateTVROHTML(){
        
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
          
          Test.setCurrentPageReference(new PageReference('Page.GenerateTVROHTML')); 
          System.currentPageReference().getParameters().put('recordId', tvro.id);
                      
          
          GenerateTVROHTML gTVRO = New GenerateTVROHTML();
       
          system.assert(gTVRO.satInfo.size()==1);
    }
}