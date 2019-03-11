Public Class SatInfoTunersXMLpage{
     public String xmlForm           {get;set;}
     public list<TVRO_Header__c>     tvroHeader;
     public boolean updateMinorVer;
     
    
     public SatInfoTunersXMLpage(){
          
          Map<String,Tuner1_2__c> TunerData = New Map<String,Tuner1_2__c>();
          
          
          // Schema Tuners Data //
          
          List<Schema.FieldSetMember> FSM = SObjectType.Tuner1_2__c.FieldSets.TunerFieldSet.getFields();
          
          String query = 'SELECT ';
          for(Schema.FieldSetMember f : FSM) {
              query += f.getFieldPath() + ',';
          }
          query += 'id,RecordType.Name FROM Tuner1_2__c';
          
          List<Tuner1_2__c> tunersData =  Database.query(query);
          
          for(integer i=0;i<tunersData.size();i++){
              TunerData.put(tunersData[i].SatInfoMaster__c+'-'+tunersData[i].RecordType.Name,tunersData[i]);
          }
          
          // Tuners Data // 
          
          
          Map<String,String> PolarizationValues = new Map<String,String>();
          Map<String,String> decodeTypeTuners   = new Map<String,String>();
          updateMinorVer = false;
          
          
          XmlStreamWriter w = new XmlStreamWriter();
          // w.writeStartDocument(null, '1.0'); //Start the XML document
          w.writeStartElement(null, 'root', null); //this will start with <accounts> in XML
          
          
          //Selected Polarization Values populated with (Vertical(V),Horzontal(H),Circular Right(R),Circular left(L))
            PolarizationValues.put('Horizontal','H');
            PolarizationValues.put('Vertical','V');
            PolarizationValues.put('Circular Right','R');
            PolarizationValues.put('Circular Left','L');
            
            List<DecodeTypeTuners__c> DTT = [Select id,name,ModeTypeinXML__c from DecodeTypeTuners__c];
            
            //Mode Type Values From Polarization tuners
            
            for(DecodeTypeTuners__c placevaluesHere:DTT){
                decodeTypeTuners.put(placevaluesHere.name,placevaluesHere.ModeTypeinXML__c);
            }
        
          ID tvroid = apexpages.currentpage().getparameters().get('id');
          
          tvroHeader = [select id,DocLastEdited__c,DocPN__c,DocRev__c,DocSVNRev__c,
           
           //Getting SatINFO from current TVRO
           
           (select id,listID__c,Orbital_Position__c,antsatID__c,Name__c,Region__c,Sat_Longitude_text__c,Pre_Skew__c,CreatedDate,Enabled__c,Favorite__c,selectable__c,Is_Tri_Sat__c,Local_Oscillator_1__c,Local_Oscillator_2__c,KU_Mode__c,Preferred_Polarity__c,LNB_Type__c  from SatInfo__r Order By listID__c),
           
           //Getting Group from current TVRO
           
           (Select id,Name,Available_LNB_Type__c,Predefined__c,A__r.antsatID__c,B__r.antsatID__c,C__r.antsatID__c,D__r.antsatID__c,Service__c,AutoSwitch__c,Group_Sort_Order__c from Groups__r ORDER BY Group_Sort_Order__c)
            
           from TVRO_Header__c where id =: tvroid ];
           
        
       for(TVRO_Header__c th : tvroHeader) {
          
          w.writeStartElement(null, 'header', null);
               // DocPN
               w.writeStartElement(null, 'part', null); 
                 if(th.DocPN__c != null)
                    w.writeCharacters(th.DocPN__c); 
               w.writeEndElement(); 
               // DocRev
               w.writeStartElement(null, 'rev', null);
                 if(th.DocRev__c != null) 
                    w.writeCharacters(th.DocRev__c); 
               w.writeEndElement(); 
               // Version
               w.writeStartElement(null, 'ver', null);
                 if(th.DocSVNRev__c != null) 
                 {
                    if(updateMinorVer)
                    {
                        Decimal Chk = decimal.valueOF(th.DocSVNRev__c);
                        List<String> secondValueIncrement = string.valueOf(chk).split('\\.');
                        Decimal minorChange;
                        if(secondValueIncrement.size()>0){
                           minorChange = decimal.valueof(secondValueIncrement[0]+'.'+(integer.valueOF(secondValueIncrement[1])+1));
                        }
                        w.writeCharacters(String.valueof(minorChange)); 
                    }else
                    {
                        w.writeCharacters(th.DocSVNRev__c); 
                    }
                 }
               w.writeEndElement(); 
               
              // DocLastEdited
               w.writeStartElement(null, 'rev_dt', null); 
                if(th.DocLastEdited__c != null) 
                {
                  List<String> splitDate = string.valueof(th.DocLastEdited__c).split(' ');
                  String dateValue = splitDate[0]+'T'+splitDate[1]+'Z';
                  w.writeCharacters(dateValue); 
                }  
               w.writeEndElement(); 
               
              // DocLastEdited
               w.writeStartElement(null, 'edit_dt', null); 
                if(th.DocLastEdited__c != null) 
                {
                  List<String> splitDate = string.valueof(th.DocLastEdited__c).split(' ');
                  String dateValueEdit = splitDate[0]+'T'+splitDate[1]+'Z';
                  w.writeCharacters(dateValueEdit); 
                }
               w.writeEndElement(); 
               
             // DocPN
               w.writeStartElement(null, 'master_part', null); 
                 w.writeCharacters(th.DocPN__c); 
               w.writeEndElement(); 
               
               // DocRev
               w.writeStartElement(null, 'master_rev', null);
                 if(th.DocRev__c != null) 
                    w.writeCharacters(th.DocRev__c); 
               w.writeEndElement();
               
             w.writeEndElement();
             w.writeStartElement(null, 'sat_list', null); //this will start with <accounts> in XML
        for (SatInfoMaster__c s: th.SatInfo__r) {
               w.writeStartElement(null, 'satellite', null);
                   // Name
                   w.writeStartElement(null, 'listID', null); 
                     w.writeCharacters(String.valueof(s.listID__c)); 
                   w.writeEndElement(); 
                   //antSatID
                    w.writeStartElement(null, 'antSatID', null); 
                     if(s.Orbital_Position__c != null)
                       w.writeCharacters(s.antsatID__c); 
                   w.writeEndElement(); 
                   // name
                   w.writeStartElement(null, 'name', null); 
                    if(s.name__c != null) 
                      w.writeCharacters(s.name__c); 
                   w.writeEndElement();
                   // region
                   w.writeStartElement(null, 'region', null); 
                    if(s.Region__c != null) 
                     w.writeCharacters(s.Region__c); 
                   w.writeEndElement();
                   // satLongitude
                   w.writeStartElement(null, 'lon', null); 
                    if(s.Sat_Longitude_text__c != null)  
                     w.writeCharacters(s.Sat_Longitude_text__c  ); 
                   w.writeEndElement();
                   
                   // preSkew
                   w.writeStartElement(null, 'skew', null); 
                    if(s.Pre_Skew__c != null)  
                     w.writeCharacters(String.valueOF(s.Pre_Skew__c)); 
                   w.writeEndElement();
                   
                   // timestamp
                   w.writeStartElement(null, 'dt', null); 
                     if(s.createddate != null)
                     {
                       List<String> splitDate = string.valueof(s.createddate).split(' ');
                       String dateValuedt = splitDate[0]+'T'+splitDate[1]+'Z';
                       w.writeCharacters(dateValuedt);  
                     }
                   w.writeEndElement();
                   
                   // enable
                   w.writeStartElement(null, 'enable', null); 
                     if(s.createddate != null)
                       w.writeCharacters(String.valueOF(s.Enabled__c).toUpperCase()); 
                   w.writeEndElement();
                   // Favorie
                   w.writeStartElement(null, 'favorite', null); 
                     if(s.createddate != null)
                       w.writeCharacters(String.valueOF(s.Favorite__c).toUpperCase()); 
                   w.writeEndElement();
                   // Select
                   w.writeStartElement(null, 'select', null); 
                     if(s.createddate != null)
                       w.writeCharacters(String.valueOF(s.selectable__c).toUpperCase()); 
                   w.writeEndElement();
                   // TriSatID
                   w.writeStartElement(null, 'triSatID', null); 
                     if(s.createddate != null)
                       w.writeCharacters(String.valueOF(s.Is_Tri_Sat__c).toUpperCase()); 
                   w.writeEndElement();
                   
                   
                   // localOscillator1
                   w.writeStartElement(null, 'lo1', null); 
                     if(s.Local_Oscillator_1__c!= null)
                       w.writeCharacters(s.Local_Oscillator_1__c); 
                   w.writeEndElement();
                   // localOscillator2
                   w.writeStartElement(null, 'lo2', null); 
                     if(s.Local_Oscillator_2__c!= null)
                       w.writeCharacters(s.Local_Oscillator_2__c); 
                   w.writeEndElement();
                   
                   w.writeStartElement(null, 'kumode', null);
                       if(s.KU_Mode__c!= null)
                       w.writeCharacters(s.KU_Mode__c);  
                   w.writeEndElement();
                   
                   w.writeStartElement(null, 'preferredPolarity', null); 
                       if(s.Preferred_Polarity__c!= null)
                       w.writeCharacters(s.Preferred_Polarity__c);
                   w.writeEndElement();
                   
                   if(s.LNB_Type__c!= null)
                   {
                       List<String> LNBSplit = s.LNB_Type__c.split(';');
                       if(LNBSplit.size()>0)
                       {
                           for(String splitLNBs:LNBSplit)
                           {
                               w.writeStartElement(null, 'lnb', null);
                               if(splitLNBs.contains('-'))
                               {
                                   List<string> afterSplit = splitLNBs.split('-');
                                   w.writeStartElement(null, 'partnum', null); 
                                       w.writeCharacters(afterSplit[0]+'-'+afterSplit[1]);
                                   w.writeEndElement();    
                               }
                               w.writeEndElement();
                           }
                       } 
                   }
                   
                   //Xponder 1
        
                  w.writeStartElement(null, 'xponder', null);
                           // ID
                           w.writeStartElement(null, 'id', null);
                               w.writeCharacters('1'); 
                           w.writeEndElement();
                           
                           // polarizationVH
                           w.writeStartElement(null, 'pol', null); 
                             if(TunerData.get(s.id+'-Tuner 1').PolarizationVH__c!= null)
                               if(PolarizationValues.containskey(TunerData.get(s.id+'-Tuner 1').PolarizationVH__c))
                               w.writeCharacters(PolarizationValues.get(TunerData.get(s.id+'-Tuner 1').PolarizationVH__c)); 
                           w.writeEndElement();
                           // bandVH
                           w.writeStartElement(null, 'band', null); 
                             if(TunerData.get(s.id+'-Tuner 1').bandVH__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 1').bandVH__c); 
                           w.writeEndElement();
                           
                           // frequencyVH
                           w.writeStartElement(null, 'freq', null); 
                             if(TunerData.get(s.id+'-Tuner 1').FrequencyVH__c!= null)
                               w.writeCharacters(string.valueof(TunerData.get(s.id+'-Tuner 1').FrequencyVH__c)); 
                           w.writeEndElement();
                           
                           // symbolRateVH
                           w.writeStartElement(null, 'symRate', null); 
                             if(TunerData.get(s.id+'-Tuner 1').symbolRateVH__c != null)
                               w.writeCharacters(string.valueof(TunerData.get(s.id+'-Tuner 1').symbolRateVH__c)); 
                           w.writeEndElement();
                           
                           // codeRateVH
                           w.writeStartElement(null, 'fec', null); 
                             if(TunerData.get(s.id+'-Tuner 1').FEC_Code_VH__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 1').FEC_Code_VH__c); 
                           w.writeEndElement();
                           
                            // networkIdVH
                           w.writeStartElement(null, 'netID', null); 
                             if(TunerData.get(s.id+'-Tuner 1').NetworkidVH__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 1').NetworkidVH__c); 
                           w.writeEndElement();
                            
                            
                           // decodeTypeVH
                           w.writeStartElement(null, 'modType', null); 
                             if(TunerData.get(s.id+'-Tuner 1').decodetypeVH__c!= null)
                               if(decodeTypeTuners.containsKey(TunerData.get(s.id+'-Tuner 1').decodetypeVH__c))
                               w.writeCharacters(decodeTypeTuners.get(TunerData.get(s.id+'-Tuner 1').decodetypeVH__c)); 
                           w.writeEndElement();
                           
                        w.writeEndElement();
                        
                        
                        //Xponder 5
                        
                        w.writeStartElement(null, 'xponder', null);
                           // ID
                           w.writeStartElement(null, 'id', null);
                               w.writeCharacters('2'); 
                           w.writeEndElement();
                           
                           // polarizationVHalt
                           w.writeStartElement(null, 'pol', null); 
                             if(TunerData.get(s.id+'-Tuner 2').PolarizationVHalt__c!= null)
                               if(PolarizationValues.containskey(TunerData.get(s.id+'-Tuner 2').PolarizationVHalt__c))
                               w.writeCharacters(PolarizationValues.get(TunerData.get(s.id+'-Tuner 2').PolarizationVHalt__c)); 
                           w.writeEndElement();
                           
                           // bandVHalt
                           w.writeStartElement(null, 'band', null); 
                             if(TunerData.get(s.id+'-Tuner 2').bandVHalt__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 2').bandVHalt__c); 
                           w.writeEndElement();
                           
                           // frequencyVHalt
                           w.writeStartElement(null, 'freq', null); 
                             if(TunerData.get(s.id+'-Tuner 2').FrequencyVHalt__c!= null)
                               w.writeCharacters(string.valueof(TunerData.get(s.id+'-Tuner 2').FrequencyVHalt__c)); 
                           w.writeEndElement();
                           
                           // symbolRateVHalt
                           w.writeStartElement(null, 'symRate', null); 
                             if(TunerData.get(s.id+'-Tuner 2').symbolRateVHalt__c != null)
                               w.writeCharacters(string.valueof(TunerData.get(s.id+'-Tuner 2').symbolRateVHalt__c)); 
                           w.writeEndElement();
                           
                           // codeRateVHalt
                           w.writeStartElement(null, 'fec', null); 
                             if(TunerData.get(s.id+'-Tuner 2').FEC_Code_VHalt__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 2').FEC_Code_VHalt__c); 
                           w.writeEndElement();
                           
                            // networkIdVHalt
                           w.writeStartElement(null, 'netID', null); 
                             if(TunerData.get(s.id+'-Tuner 2').NetworkidVHalt__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 2').NetworkidVHalt__c); 
                           w.writeEndElement();
                            
                            
                           // decodeTypeVHalt
                           w.writeStartElement(null, 'modType', null); 
                             if(TunerData.get(s.id+'-Tuner 2').decodetypeVHalt__c!= null)
                               if(decodeTypeTuners.containsKey(TunerData.get(s.id+'-Tuner 2').decodetypeVHalt__c))
                               w.writeCharacters(decodeTypeTuners.get(TunerData.get(s.id+'-Tuner 2').decodetypeVHalt__c));
                           w.writeEndElement();
                           
                        w.writeEndElement();
                        
                        
                        //Xponder 4
                        
                        w.writeStartElement(null, 'xponder', null);
                           // ID
                           w.writeStartElement(null, 'id', null);
                               w.writeCharacters('3'); 
                           w.writeEndElement();
                           
                           // polarizationHH
                           w.writeStartElement(null, 'pol', null); 
                             if(TunerData.get(s.id+'-Tuner 1').PolarizationHH__c!= null)
                               if(PolarizationValues.containskey(TunerData.get(s.id+'-Tuner 1').PolarizationHH__c))
                               w.writeCharacters(PolarizationValues.get(TunerData.get(s.id+'-Tuner 1').PolarizationHH__c)); 
                           w.writeEndElement();
                           
                           // bandHH
                           w.writeStartElement(null, 'band', null); 
                             if(TunerData.get(s.id+'-Tuner 1').bandHH__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 1').bandHH__c); 
                           w.writeEndElement();
                           
                           // frequencyHH
                           w.writeStartElement(null, 'freq', null); 
                             if(TunerData.get(s.id+'-Tuner 1').FrequencyHH__c!= null)
                               w.writeCharacters(string.valueof(TunerData.get(s.id+'-Tuner 1').FrequencyHH__c)); 
                           w.writeEndElement();
                           
                           // symbolRateHH
                           w.writeStartElement(null, 'symRate', null); 
                             if(TunerData.get(s.id+'-Tuner 1').symbolRateHH__c != null)
                               w.writeCharacters(string.valueof(TunerData.get(s.id+'-Tuner 1').symbolRateHH__c)); 
                           w.writeEndElement();
                           
                           // codeRateHH
                           w.writeStartElement(null, 'fec', null); 
                             if(TunerData.get(s.id+'-Tuner 1').FEC_Code_HH__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 1').FEC_Code_HH__c); 
                           w.writeEndElement();
                           
                            // networkIdHH
                           w.writeStartElement(null, 'netID', null); 
                             if(TunerData.get(s.id+'-Tuner 1').NetworkidHH__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 1').NetworkidHH__c); 
                           w.writeEndElement();
                            
                            
                           // decodeTypeHH
                           w.writeStartElement(null, 'modType', null); 
                             if(TunerData.get(s.id+'-Tuner 1').decodetypeHH__c!= null)
                               if(decodeTypeTuners.containsKey(TunerData.get(s.id+'-Tuner 1').decodetypeHH__c))
                               w.writeCharacters(decodeTypeTuners.get(TunerData.get(s.id+'-Tuner 1').decodetypeHH__c));
                           w.writeEndElement();
                           
                        w.writeEndElement();
                        
                        
                        
                        //Xponder 8
                        
                        w.writeStartElement(null, 'xponder', null);
                           // ID
                           w.writeStartElement(null, 'id', null);
                               w.writeCharacters('4'); 
                           w.writeEndElement();
                           
                           // polarizationHHalt
                           w.writeStartElement(null, 'pol', null); 
                             if(TunerData.get(s.id+'-Tuner 2').PolarizationHHalt__c!= null)
                               if(PolarizationValues.containskey(TunerData.get(s.id+'-Tuner 2').PolarizationHHalt__c))
                               w.writeCharacters(PolarizationValues.get(TunerData.get(s.id+'-Tuner 2').PolarizationHHalt__c)); 
                           w.writeEndElement();
                           
                           // bandHHalt
                           w.writeStartElement(null, 'band', null); 
                             if(TunerData.get(s.id+'-Tuner 2').bandHHalt__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 2').bandHHalt__c); 
                           w.writeEndElement();
                           
                           // frequencyHHalt
                           w.writeStartElement(null, 'freq', null); 
                             if(TunerData.get(s.id+'-Tuner 2').FrequencyHHalt__c!= null)
                               w.writeCharacters(string.valueof(TunerData.get(s.id+'-Tuner 2').FrequencyHHalt__c)); 
                           w.writeEndElement();
                           
                           // symbolRateHHalt
                           w.writeStartElement(null, 'symRate', null); 
                             if(TunerData.get(s.id+'-Tuner 2').symbolRateHHalt__c != null)
                               w.writeCharacters(string.valueof(TunerData.get(s.id+'-Tuner 2').symbolRateHHalt__c)); 
                           w.writeEndElement();
                           
                           // codeRateHHalt
                           w.writeStartElement(null, 'fec', null); 
                             if(TunerData.get(s.id+'-Tuner 2').FEC_Code_HHalt__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 2').FEC_Code_HHalt__c); 
                           w.writeEndElement();
                           
                            // networkIdHHalt
                           w.writeStartElement(null, 'netID', null); 
                             if(TunerData.get(s.id+'-Tuner 2').NetworkidHHalt__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 2').NetworkidHHalt__c); 
                           w.writeEndElement();
                            
                            
                           // decodeTypeHHalt
                           w.writeStartElement(null, 'modType', null); 
                             if(TunerData.get(s.id+'-Tuner 2').decodetypeHHalt__c!= null)
                               if(decodeTypeTuners.containsKey(TunerData.get(s.id+'-Tuner 2').decodetypeHHalt__c))
                               w.writeCharacters(decodeTypeTuners.get(TunerData.get(s.id+'-Tuner 2').decodetypeHHalt__c));
                           w.writeEndElement();
                           
                        w.writeEndElement();
                        
                        //Xponder 2
                        
                        w.writeStartElement(null, 'xponder', null);
                           // ID
                           w.writeStartElement(null, 'id', null);
                               w.writeCharacters('5'); 
                           w.writeEndElement();
                           
                           // polarizationVL
                           w.writeStartElement(null, 'pol', null); 
                             if(TunerData.get(s.id+'-Tuner 1').PolarizationVL__c!= null)
                               if(PolarizationValues.containskey(TunerData.get(s.id+'-Tuner 1').PolarizationVL__c))
                               w.writeCharacters(PolarizationValues.get(TunerData.get(s.id+'-Tuner 1').PolarizationVL__c)); 
                           w.writeEndElement();
                           // bandVH
                           w.writeStartElement(null, 'band', null); 
                             if(TunerData.get(s.id+'-Tuner 1').bandVL__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 1').bandVL__c); 
                           w.writeEndElement();
                           
                           // frequencyVL
                           w.writeStartElement(null, 'freq', null); 
                             if(TunerData.get(s.id+'-Tuner 1').FrequencyVL__c!= null)
                               w.writeCharacters(string.valueof(TunerData.get(s.id+'-Tuner 1').FrequencyVL__c)); 
                           w.writeEndElement();
                           
                           // symbolRateVL
                           w.writeStartElement(null, 'symRate', null); 
                             if(TunerData.get(s.id+'-Tuner 1').symbolRateVL__c != null)
                               w.writeCharacters(string.valueof(TunerData.get(s.id+'-Tuner 1').symbolRateVL__c)); 
                           w.writeEndElement();
                           
                           // codeRateVL
                           w.writeStartElement(null, 'fec', null); 
                             if(TunerData.get(s.id+'-Tuner 1').FEC_Code_VL__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 1').FEC_Code_VL__c); 
                           w.writeEndElement();
                           
                            // networkIdVL
                           w.writeStartElement(null, 'netID', null); 
                             if(TunerData.get(s.id+'-Tuner 1').NetworkidVL__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 1').NetworkidVL__c); 
                           w.writeEndElement();
                            
                            
                           // decodeTypeVL
                           w.writeStartElement(null, 'modType', null); 
                             if(TunerData.get(s.id+'-Tuner 1').decodetypeVL__c!= null)
                               if(decodeTypeTuners.containsKey(TunerData.get(s.id+'-Tuner 1').decodetypeVL__c))
                               w.writeCharacters(decodeTypeTuners.get(TunerData.get(s.id+'-Tuner 1').decodetypeVL__c)); 
                           w.writeEndElement();
                           
                        w.writeEndElement();
                        
                        //Xponder 6
                        
                        w.writeStartElement(null, 'xponder', null);
                           // ID
                           w.writeStartElement(null, 'id', null);
                               w.writeCharacters('6'); 
                           w.writeEndElement();
                           
                           // polarizationVLalt
                           w.writeStartElement(null, 'pol', null); 
                             if(TunerData.get(s.id+'-Tuner 2').PolarizationVLalt__c!= null)
                               if(PolarizationValues.containskey(TunerData.get(s.id+'-Tuner 2').PolarizationVLalt__c))
                               w.writeCharacters(PolarizationValues.get(TunerData.get(s.id+'-Tuner 2').PolarizationVLalt__c)); 
                           w.writeEndElement();
                           
                           // bandVLalt
                           w.writeStartElement(null, 'band', null); 
                             if(TunerData.get(s.id+'-Tuner 2').bandVLalt__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 2').bandVLalt__c); 
                           w.writeEndElement();
                           
                           // frequencyVLalt
                           w.writeStartElement(null, 'freq', null); 
                             if(TunerData.get(s.id+'-Tuner 2').FrequencyVLalt__c!= null)
                               w.writeCharacters(string.valueof(TunerData.get(s.id+'-Tuner 2').FrequencyVLalt__c)); 
                           w.writeEndElement();
                           
                           // symbolRateVLalt
                           w.writeStartElement(null, 'symRate', null); 
                             if(TunerData.get(s.id+'-Tuner 2').symbolRateVLalt__c != null)
                               w.writeCharacters(string.valueof(TunerData.get(s.id+'-Tuner 2').symbolRateVLalt__c)); 
                           w.writeEndElement();
                           
                           // codeRateVLalt
                           w.writeStartElement(null, 'fec', null); 
                             if(TunerData.get(s.id+'-Tuner 2').FEC_Code_VLalt__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 2').FEC_Code_VLalt__c); 
                           w.writeEndElement();
                           
                            // networkIdVLalt
                           w.writeStartElement(null, 'netID', null); 
                             if(TunerData.get(s.id+'-Tuner 2').NetworkidVLalt__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 2').NetworkidVLalt__c); 
                           w.writeEndElement();
                            
                            
                           // decodeTypeVLalt
                           w.writeStartElement(null, 'modType', null); 
                             if(TunerData.get(s.id+'-Tuner 2').decodetypeVLalt__c!= null)
                               if(decodeTypeTuners.containsKey(TunerData.get(s.id+'-Tuner 2').decodetypeVLalt__c))
                               w.writeCharacters(decodeTypeTuners.get(TunerData.get(s.id+'-Tuner 2').decodetypeVLalt__c));
                           w.writeEndElement();
                           
                        w.writeEndElement();
                        
                        //Xponder 3
                        
                        w.writeStartElement(null, 'xponder', null);
                           // ID
                           w.writeStartElement(null, 'id', null);
                               w.writeCharacters('7'); 
                           w.writeEndElement();
                           
                           // polarizationHL
                           w.writeStartElement(null, 'pol', null); 
                             if(TunerData.get(s.id+'-Tuner 1').PolarizationHL__c!= null)
                                 if(PolarizationValues.containskey(TunerData.get(s.id+'-Tuner 1').PolarizationHL__c))
                               w.writeCharacters(PolarizationValues.get(TunerData.get(s.id+'-Tuner 1').PolarizationHL__c)); 
                           w.writeEndElement();
                           
                           // bandHL
                           w.writeStartElement(null, 'band', null); 
                             if(TunerData.get(s.id+'-Tuner 1').bandHL__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 1').bandHL__c); 
                           w.writeEndElement();
                           
                           // frequencyHL
                           w.writeStartElement(null, 'freq', null); 
                             if(TunerData.get(s.id+'-Tuner 1').FrequencyHL__c!= null)
                               w.writeCharacters(string.valueof(TunerData.get(s.id+'-Tuner 1').FrequencyHL__c)); 
                           w.writeEndElement();
                           
                           // symbolRateHL
                           w.writeStartElement(null, 'symRate', null); 
                             if(TunerData.get(s.id+'-Tuner 1').symbolRateHL__c != null)
                               w.writeCharacters(string.valueof(TunerData.get(s.id+'-Tuner 1').symbolRateHL__c)); 
                           w.writeEndElement();
                           
                           // codeRateHL
                           w.writeStartElement(null, 'fec', null); 
                             if(TunerData.get(s.id+'-Tuner 1').FEC_Code_HL__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 1').FEC_Code_HL__c); 
                           w.writeEndElement();
                           
                            // networkIdHL
                           w.writeStartElement(null, 'netID', null); 
                             if(TunerData.get(s.id+'-Tuner 1').NetworkidHL__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 1').NetworkidHL__c); 
                           w.writeEndElement();
                            
                            
                           // decodeTypeHL
                           w.writeStartElement(null, 'modType', null); 
                             if(TunerData.get(s.id+'-Tuner 1').decodetypeHL__c!= null)
                               if(decodeTypeTuners.containsKey(TunerData.get(s.id+'-Tuner 1').decodetypeHL__c))
                               w.writeCharacters(decodeTypeTuners.get(TunerData.get(s.id+'-Tuner 1').decodetypeHL__c));
                           w.writeEndElement();
                           
                        w.writeEndElement();
        
                       
                        
                        //Xponder 7
                        
                        w.writeStartElement(null, 'xponder', null);
                           // ID
                           w.writeStartElement(null, 'id', null);
                               w.writeCharacters('8'); 
                           w.writeEndElement();
                           
                           // polarizationHLalt
                           w.writeStartElement(null, 'pol', null); 
                             if(TunerData.get(s.id+'-Tuner 2').PolarizationHLalt__c!= null)
                               if(PolarizationValues.containskey(TunerData.get(s.id+'-Tuner 2').PolarizationHLalt__c))
                               w.writeCharacters(PolarizationValues.get(TunerData.get(s.id+'-Tuner 2').PolarizationHLalt__c)); 
                           w.writeEndElement();
                           
                           // bandHLalt
                           w.writeStartElement(null, 'band', null); 
                             if(TunerData.get(s.id+'-Tuner 2').bandHLalt__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 2').bandHLalt__c); 
                           w.writeEndElement();
                           
                           // frequencyHLalt
                           w.writeStartElement(null, 'freq', null); 
                             if(TunerData.get(s.id+'-Tuner 2').FrequencyHLalt__c!= null)
                               w.writeCharacters(string.valueof(TunerData.get(s.id+'-Tuner 2').FrequencyHLalt__c)); 
                           w.writeEndElement();
                           
                           // symbolRateHLalt
                           w.writeStartElement(null, 'symRate', null); 
                             if(TunerData.get(s.id+'-Tuner 2').symbolRateHLalt__c != null)
                               w.writeCharacters(string.valueof(TunerData.get(s.id+'-Tuner 2').symbolRateHLalt__c)); 
                           w.writeEndElement();
                           
                           // codeRateHLalt
                           w.writeStartElement(null, 'fec', null); 
                             if(TunerData.get(s.id+'-Tuner 2').FEC_Code_HLalt__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 2').FEC_Code_HLalt__c); 
                           w.writeEndElement();
                           
                            // networkIdHLalt
                           w.writeStartElement(null, 'netID', null); 
                             if(TunerData.get(s.id+'-Tuner 2').NetworkidHLalt__c!= null)
                               w.writeCharacters(TunerData.get(s.id+'-Tuner 2').NetworkidHLalt__c); 
                           w.writeEndElement();
                            
                            
                           // decodeTypeHLalt
                           w.writeStartElement(null, 'modType', null); 
                             if(TunerData.get(s.id+'-Tuner 2').decodetypeHLalt__c!= null)
                               if(decodeTypeTuners.containsKey(TunerData.get(s.id+'-Tuner 2').decodetypeHLalt__c))
                               w.writeCharacters(decodeTypeTuners.get(TunerData.get(s.id+'-Tuner 2').decodetypeHLalt__c));
                           w.writeEndElement();
                           
                        w.writeEndElement();
                        
                 w.writeEndElement();  
            }
        w.writeEndElement(); 
        //Generating Group XML from here
        w.writeStartElement(null, 'group_list', null);
        for(Group__c GroupData: th.Groups__r)
        {
            //For Group Name
             w.writeStartElement(null, 'group', null); 
                   w.writeStartElement(null, 'group_name', null); 
                       if(GroupData.Name != null)
                       w.writeCharacters(GroupData.Name);
                   w.writeEndElement();
                   w.writeStartElement(null, 'predefined', null); 
                       if(GroupData.Predefined__c != null)
                       w.writeCharacters(GroupData.Predefined__c);
                   w.writeEndElement();
                   w.writeStartElement(null, 'service', null); 
                       if(GroupData.Service__c != null)
                       w.writeCharacters(GroupData.Service__c);
                   w.writeEndElement();  
                   w.writeStartElement (null, 'autoswitch', null);
                       if(GroupData.AutoSwitch__c != null)
                       w.writeCharacters(GroupData.AutoSwitch__c);
                   w.writeEndElement();      
                   w.writeStartElement(null, 'A', null); 
                       if(GroupData.A__r.antsatID__c != null)
                       w.writeCharacters(GroupData.A__r.antsatID__c);
                   w.writeEndElement();  
                   w.writeStartElement(null, 'B', null); 
                       if(GroupData.B__r.antsatID__c != null)
                       w.writeCharacters(GroupData.B__r.antsatID__c);
                   w.writeEndElement();
                   w.writeStartElement(null, 'C', null); 
                       if(GroupData.C__r.antsatID__c != null)
                       w.writeCharacters(GroupData.C__r.antsatID__c);
                   w.writeEndElement();
                   w.writeStartElement(null, 'D', null); 
                       if(GroupData.D__r.antsatID__c != null)
                       w.writeCharacters(GroupData.D__r.antsatID__c);
                   w.writeEndElement();
                   
                   if(GroupData.Available_LNB_Type__c!= null)
                   {
                       List<String> LNBSplit = GroupData.Available_LNB_Type__c.split(';');
                       if(LNBSplit.size()>0)
                       {
                           for(String splitLNBs:LNBSplit)
                           {
                               w.writeStartElement(null, 'lnb', null);
                               if(splitLNBs.contains('-'))
                               {
                                   List<string> afterSplit = splitLNBs.split('-');
                                   w.writeStartElement(null, 'partnum', null); 
                                       w.writeCharacters(afterSplit[0]+'-'+afterSplit[1]);
                                   w.writeEndElement();    
                               }
                               w.writeEndElement();
                           }
                       } 
                   }
             w.writeEndElement();
        } 
      }
      
      w.writeEndElement();
        //Generating Service satillites
      List<TVRO_Provider__c> TVROSatellies = [select id,Name,(Select id,Satellite_Name__c from TV_Satellites_with_Services__r) from TVRO_Provider__c];   
          
       w.writeStartElement(null, 'service_list', null);
          for(TVRO_Provider__c serviceProvider:TVROSatellies){
           w.writeStartElement(null, 'service', null);
               w.writeStartElement(null, 'name', null);
                       w.writeCharacters(serviceProvider.Name);
               w.writeEndElement();
               w.writeStartElement(null, 'sat_list', null);
               for(TVRO_Satellites_with_Services__c satServices:serviceProvider.TV_Satellites_with_Services__r)
               {
                   w.writeStartElement(null, 'sat', null);
                       w.writeCharacters(satServices.Satellite_Name__c);
                   w.writeEndElement();
               }
               w.writeEndElement();
           w.writeEndElement();
           }
       w.writeEndElement();
      
      
      //Ending Sercives Satellites
         
        w.writeEndDocument();
        
        xmlForm = w.getXmlString();   
     }
     
}