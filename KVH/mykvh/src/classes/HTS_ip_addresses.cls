public with sharing class HTS_ip_addresses {
  //Integer to hex (and binary) lookup map.
  public map<integer, DecHexBin__mdt> lookupHex = new map<integer, DecHexBin__mdt>();
  //Constructor
  public HTS_ip_addresses(){
    for(DecHexBin__mdt dhb : [SELECT Binary__c, Decimal__c, Hexadecimal__c FROM DecHexBin__mdt ORDER BY Hexadecimal__c ASC]){
      lookupHex.put((integer)dhb.Decimal__c, dhb);   
      //system.debug(string.valueOf((integer)dhb.Decimal__c) + ' : ' + dhb);
    }
  }
  
  public string getHexIp(string decIp){
    //Converts a decimal representation of the IP to A Hexadecimal representation
    integer[] intIp = parseIpAddress(decIp);
    string returnString = '';
    for(integer i = 0; i < 4; i++){ //left to right....
      if(i==0){
        returnString = lookupHex.get(intIp[i]).Hexadecimal__c;
      } else{
        returnString = returnString + '.' + lookupHex.get(intIp[i]).Hexadecimal__c;
      }
      //system.debug(returnString);
    }
    //system.debug('Final String : ' + returnString);
    return returnString;
  }

  public string generateIpAddresses(integer number_to_create){
    string returnString = 'initializing';
    integer numberCreated = 0;
    if(number_to_create > 1000){
      returnString = 'Generator limited to 1000 or less';
      return returnString;
    }
    HTS_IP_Address__c maxAddress = getMaxAddress();
    //governing while loop
    string ISP_Ip_Address = maxAddress.HTS_IP_Address__c;
    string Mgmt_Ip_Address = maxAddress.Management_IP_Address__c;
    string HEX_Ip_Address = maxAddress.HTS_IP_HEX_Address__c;
    system.debug('entering the while with: number to create = ' + number_to_create + ' and number created = ' + numberCreated);
    list<HTS_IP_Address__c> insertList = new list<HTS_IP_Address__c>();
    while(number_to_create > numberCreated){
      //outer loop
      ISP_Ip_Address = incrementIpAddress(3, ISP_Ip_Address);
      Mgmt_Ip_Address = incrementIpAddress(4, Mgmt_Ip_Address);
      HEX_Ip_Address = getHexIp(ISP_Ip_Address);        
      numberCreated++;
      
      system.debug('Created : ' + numberCreated + ' Out of : ' + number_to_create);
      system.debug('ISP IP Address : ' + ISP_Ip_Address + ' Hex IP Address : ' + HEX_Ip_Address + ' Management IP Address : ' + Mgmt_Ip_Address );
      insertList.add(new HTS_IP_Address__c(Management_IP_Address__c = Mgmt_Ip_Address, HTS_IP_Address__c = ISP_Ip_Address, HTS_IP_HEX_Address__c = HEX_Ip_Address));
    }
    insert insertList;
    returnString = 'Created : ' + numberCreated + ' Out of : ' + number_to_create;
    return returnString;
  }

  public HTS_IP_Address__c getNextAvailableAddress(){
    HTS_IP_Address__c returnIP = new HTS_IP_Address__c();
    returnIP = [SELECT Id, HTS_IP_Address__c, Management_IP_Address__c, HTS_IP_HEX_Address__c, isReserved__c, Date_Issued__c
                FROM HTS_IP_Address__c
                WHERE isReserved__c = false AND Date_Issued__c = null 
                ORDER BY SystemModStamp ASC, HTS_IP_HEX_Address__c ASC
                LIMIT 1];
    return returnIP;
  }
  //Private methods....
  @testVisible private HTS_IP_Address__c getMaxAddress(){
    HTS_IP_Address__c maxAddress = [SELECT Id, HTS_IP_Address__c, Management_IP_Address__c, HTS_IP_HEX_Address__c 
                                    FROM HTS_IP_Address__c 
                                    WHERE HTS_IP_HEX_Address__c != '' 
                                    ORDER BY HTS_IP_HEX_Address__c DESC 
                                    LIMIT 1]; //difficult query to optimize....
    //system.debug(maxAddress.HTS_IP_Address__c);
    return maxAddress;
  }
  @testVisible private map<String, String> getMgmtIPs (list<String> HTSIPs){
    map<String, String> returnMap = new map<String, String>();
    for(HTS_IP_Address__c ip : [SELECT HTS_IP_Address__c, Management_IP_Address__c 
                                FROM HTS_IP_Address__c
                                WHERE HTS_IP_Address__c IN: HTSIPs]){
      returnMap.put(ip.HTS_IP_Address__c, ip.Management_IP_Address__c);
    }
    return returnMap;
  }
  
  public string incrementIpAddress(integer octetToIncrement, string ipToIncrement){
    //system.debug('Initial String ' + ipToIncrement); 
    string returnString = '';
    if(octetToIncrement < 3 || octetToIncrement > 4){ //Only increments third or fourth octet
      return null;
    }
    integer[] numericIp = parseIpAddress(ipToIncrement);
      numericIp[octetToIncrement - 1]++;
      if(numericIp[octetToIncrement - 1] == 256){
        numericIp[octetToIncrement - 1] = 0;
        numericIp[octetToIncrement - 2]++;
        if(numericIp[octetToIncrement - 2] == 256){
          numericIp[octetToIncrement - 2] = 0;
          numericIp[octetToIncrement - 3]++;
          if((numericIp[octetToIncrement - 3] == 256)){
            //OH shit!
            //thrown an exception and return null??
            return null;
          }
        }
      }
    returnString = composeIpAddress(numericIp);
    //system.debug('Incremented String ' + returnString);      
    return returnString;
  }
  
  @testVisible private integer[] parseIpAddress(string inputIpString){
    integer[] octets = new integer[4];
    for(integer i = 0; i < 4; i++){ //left to right....
      octets[i] = integer.valueOf(inputIpString.substringBefore('.'));
      //system.debug('index : ' + i + ' Value : ' + octets[i]);
      inputIpString = inputIpString.substringAfter('.');
    }
    //system.debug(octets);
    return octets;
  }
  
  @testVisible private string composeIpAddress(integer[] numericIp){
    string returnString = '';
    for(integer i = 0; i < 4; i++){ //left to right....
      if(i==0){
        returnString = String.valueOf(numericIp[i]);
      } else{
        returnString = returnString + '.' + String.valueOf(numericIp[i]);
      }
      //system.debug(returnString);
    }
    //system.debug('Final String : ' + returnString);
    return returnString;
  }

}