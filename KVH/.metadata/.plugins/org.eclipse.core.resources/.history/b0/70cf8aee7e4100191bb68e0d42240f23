/* Adding Product2Id to Asset Structure Queries to support IPMC
 * jthom 2/4/14
 *                                                              */
/* Adding Below Decks Type and Antenna Type to Asset Structure Queries to support IPMC
 * jthom 11/6/14
 */  
 global without sharing class AssetStructureEngine {
     //(Activation Order) Task - AW-610 : "without sharing" keyword is added because of from "Create Acct, etc." flow we are updating asset account.

    static Map<String, AssetStructureEngine.AssetStructureMap> masm = new Map<String, AssetStructureEngine.AssetStructureMap>();
    static List<AssetStructureEngine.AssetStructureMap> asm = new List<AssetStructureEngine.AssetStructureMap>();
    static List<integer> maxLevel = new List<integer>();
    /**
    * Return ObjectStructureMap
    * @return asm
    * call this from external class
    */
    global static List<AssetStructureMap> getAssetStructure(String AssetId){
        asm.clear();
        System.assertNotEquals( AssetId, null, 'sObject ID must be provided' );
        asm = formatAssetStructure( AssetId );
        return asm;
    }
        /**
    * Query Account from top down to build the AssetStructureMap
    * @param currentId
    * @return asm
    */
    
    private static AssetStructureEngine.AssetStructureMap[] formatAssetStructure( String AssetId ){
        masm.clear();

        //Change below
        List<Asset> al              = new List<Asset>{};
        List<ID> currentParent      = new List<ID>{};
        Map<ID, String> nodeList    = new Map<ID, String>{};
        List<String> nodeSortList   = new List<String>{};
        List<Boolean> levelFlag     = new List<Boolean>{};
        List<Boolean> closeFlag     = new List<Boolean>{};
        String nodeId               = '0';
        String nodeType             = 'child';
        Integer count               = 0;
        Integer level               = 0;
        Boolean endOfStructure      = false;
        
        currentParent.add( AssetId );

        //Loop though all children
        while ( !endOfStructure ){

            if( level == 0 ){
                //Change below     (removed  a.Site,  a.OwnerId,  a.Industry,)
                al = [ SELECT a.item__c, a.Parent_Asset__c, a.Name, a.Id, a.Item_Description__c,
                        a.Product2Id,                                                       //Adding Product2Id to Asset Structure Queries to support IPMC jthom 2/4/13
                        a.Sequence_No__c, a.InstallDate, a.Date_Removed__c,
                        a.Below_Decks_Type__c, a.Antenna_type__c,                           //Adding *_Type__c to support IPMC jthom 11/6/14   
                        a.Root_Asset__c, a.AccountId, a.Parent_Asset__r.AccountId,          //Adding Root, Account and Parent Asset Account jthom 1/16/15
                        a.Installed_By__c                                                   //Adding Installed by jthom 2/10/15
                        FROM Asset a 
                        WHERE a.id IN : CurrentParent 
                        ORDER BY a.Name ];
            } 
            else {
                //Change below      
                al = [ SELECT a.item__c, a.Parent_Asset__c, a.Name, a.Id, a.Item_Description__c,
                        a.Product2Id,                                                       //Adding Product2Id to Asset Structure Queries to support IPMC jthom 2/4/13
                        a.Sequence_No__c, a.InstallDate, a.Date_Removed__c,
                        a.Below_Decks_Type__c, a.Antenna_type__c,                           //Adding *_Type__c to support IPMC jthom 11/6/14   
                        a.Root_Asset__c, a.AccountId, a.Parent_Asset__r.AccountId,          //Adding Root, Account and Parent Asset Account jthom 1/16/15
                        a.Installed_By__c                                                   //Adding Installed by jthom 2/10/15
                        FROM Asset a 
                        WHERE a.Parent_Asset__c IN : CurrentParent 
                        ORDER BY a.Name ];
            }

            if( al.size() == 0 ){
                endOfStructure = true;
            }
            else{
                currentParent.clear();
                String Seq = '';
                Boolean hasSequenceNo = null;
                for ( Integer i = 0 ; i < al.size(); i++ ){
                    //Change below
                    Asset a = al[i];
                    //The following line acts like an IIF statement, AND breaks the alphabetical order of the children!
                    //nodeId = ( level > 0 ) ? NodeList.get( a.Parent_Asset__c )+'.'+String.valueOf( i ) : String.valueOf( i );
                    /*The node sort list looks like {0, 0.1, 0.2, 1.0, ... 0.12, .0.13}
                    This can cause a problem with sorting of there are >10 children... it might not sort in 
                    alphabetical order. Adding leading 0s to the sort string will alleviate the problem as long as
                    there are not more than 10000 children.*/
                    //Rather than an alhpabetical sort, let's inject the Sequence number into NodeSortList
                    If( String.isNotBlank( a.Sequence_No__c ) ) {
                        Seq = a.Sequence_No__c;
                    } else {
                        Seq = String.valueOf( i );
                    }
                    If( level > 0) {
                      nodeId = NodeList.get( a.Parent_Asset__c )+'.'+Seq.leftPad(5);
                      nodeId = nodeId.replaceAll(' ', '0');
                    }  else  {
                      nodeId = Seq.leftPad(5); // we want at least 5 chars for sorting purposes
                      nodeId = nodeId.replaceAll(' ', '0');
                    }
                    
                    //system.debug(nodeId +', '+Seq+' ,'+ a.name);
                    
                    masm.put( NodeID, new AssetStructureMap( nodeID, levelFlag, closeFlag, nodeType, false, false, a ) );
                    currentParent.add( a.id );
                    nodeList.put( a.id,nodeId );
                    nodeSortList.add( nodeId );
                }
                
                maxLevel.add( level );                
                level++;
            }
        }
        
        //Account structure must now be formatted
        NodeSortList.sort();
        for( Integer i = 0; i < NodeSortList.size(); i++ ){
            List<String> pnl = new List<String> {};
            List<String> cnl = new List<String> {};
            List<String> nnl = new List<String> {};
            
            if ( i > 0 ){
                String pn   = NodeSortList[i-1];
                pnl         = pn.split( '\\.', -1 );
            }

            String cn   = NodeSortList[i];
            cnl         = cn.split( '\\.', -1 );

            if( i < NodeSortList.size()-1 ){
                String nn = NodeSortList[i+1];
                nnl = nn.split( '\\.', -1 );
            }
            
            AssetStructureMap tasm = masm.get( cn );
            if ( cnl.size() < nnl.size() ){
                //Parent
                tasm.nodeType = ( isLastNode( cnl ) ) ? 'parent_end' : 'parent';
            }
            else if( cnl.size() > nnl.size() ){
                tasm.nodeType   = 'child_end';
                tasm.closeFlag  = setcloseFlag( cnl, nnl, tasm.nodeType );
            }
            else{
                tasm.nodeType = 'child';
            }
            
            tasm.levelFlag = setlevelFlag( cnl, tasm.nodeType ); 
            
            //Change below 
            if ( tasm.asset.id == AssetId ) {
                tasm.currentNode = true;
            }
            asm.add( tasm );
        }
        
        asm[0].nodeType             = 'start';
        asm[asm.size()-1].nodeType  = 'end';
        
        return asm;
    }
    /**
    * Determin parent elements relationship to current element
    * @return flagList
    */
    private static List<Boolean> setlevelFlag( List<String> nodeElements, String nodeType ){
        
        List<Boolean> flagList = new List<Boolean>{};
        String searchNode   = '';
        String workNode     = '';
        Integer cn          = 0;
        
        for( Integer i = 0; i < nodeElements.size() - 1; i++ ){
            cn = Integer.valueOf( nodeElements[i] );
            cn++;
            searchNode  = workNode + String.valueOf( cn );
            workNode    = workNode + nodeElements[i] + '.';
            if ( masm.containsKey( searchNode ) ){
                flagList.add( true );
            }
            else {
                flagList.add( false );
            }
        }
        
        return flagList;
    }    
    /**
    * Determin if the element is a closing element
    * @return flagList
    */
    private static List<Boolean> setcloseFlag( List<String> cnl, List<String> nnl, String nodeType ){
        
        List<Boolean> flagList = new List<Boolean>{};
        String searchNode   = '';
        String workNode     = '';
        Integer cn          = 0;
        
        for( Integer i = nnl.size(); i < cnl.size(); i++ ){
            flagList.add( true );
        }
        
        return flagList;
    }   
        /**
    * Determin if Element is the bottom node  
    * @return Boolean
    */
    private static Boolean isLastNode( List<String> nodeElements ){
        
        String searchNode   = '';
        Integer cn          = 0;
        
        for( Integer i = 0; i < nodeElements.size(); i++ ){
            if ( i == nodeElements.size()-1 ){
                cn = Integer.valueOf( nodeElements[i] );
                cn++;
                searchNode = searchNode + String.valueOf( cn );
            }
            else {
                searchNode = searchNode + nodeElements[i] + '.';
            }
        }
        if ( masm.containsKey( searchNode ) ){
            return false;
        }
        else{
            return true;
        }
    }
    /**
    * Find the tom most element in Heirarchy  
    * @return objId
    */
    global static Asset GetRootAsset( Id objId ){
        //system.debug('Getting Root Asset for : ' + objId);
        Boolean top = false;
        Asset a = new Asset();
        while ( !top ) {
            //SOQL in a WHILE loop is to be avoided! However, to navigate a Hierarchical data structure, this is difficult to avoid.
            //An alternative construct might include Asset.Parent.Parent.Parent... for as many levels as we need to support (or SF allows!)
            List<Asset> soqla = [ SELECT Id, Name,  AccountId, item__c, Item_Description__c, Product2Id,
                                        Sequence_No__c, InstallDate, Date_Removed__c, Installed_By__c,
                                        Below_Decks_Type__c, Antenna_type__c,
                                        Root_Asset__c, Parent_Asset__c,  Parent_Asset__r.AccountId
                                FROM Asset WHERE Id =: objId];
            if (!soqla.isEmpty()) { // we got a list of records, at least one....
                a = soqla.get(0);   // but we just want the first one
            }
            //system.debug('Query returned : ' + soqla.size() + ' records. Asset[0] : ' + a);
            if ( a.Parent_Asset__c != null ) {
                objId = a.Parent_Asset__c;      
            } else {
                top = true;
                a = [SELECT Id, Name,  AccountId, item__c, Item_Description__c, Product2Id,
                            Sequence_No__c, InstallDate, Date_Removed__c, Installed_By__c,
                            Below_Decks_Type__c, Antenna_type__c,
                            Root_Asset__c, Parent_Asset__c,  Parent_Asset__r.AccountId
                    FROM Asset WHERE Id =: a.Id LIMIT 1];
            }
        }
        return a ;
    }
    /**
    * Asset Structure Map Wrapper class
    */
    global without sharing class AssetStructureMap { 
    //(Activation Order) Task - AW-610 : "without sharing" keyword is added because of from "Create Acct, etc." flow we are updating asset account.

        public String nodeId;
        public Boolean[] levelFlag = new Boolean[]{};
        public Boolean[] closeFlag = new Boolean[]{};
        public String nodeType;
        public Boolean currentNode;
        
        /**
        * @Change this to your sObject
        */
        public Asset asset;
        
        public String getnodeId() { return nodeId; }
        public Boolean[] getlevelFlag() { return levelFlag; }
        public Boolean[] getcloseFlag() { return closeFlag; }
        public String getnodeType() { return nodeType; }
        public Boolean getcurrentNode() { return currentNode; }


        /**
        * @Change this to your sObject
        */
        public Asset getasset() { return asset; }
        
        public void setnodeId( String n ) { this.nodeId = n; }
        public void setlevelFlag( Boolean l ) { this.levelFlag.add(l); }
        public void setlcloseFlag( Boolean l ) { this.closeFlag.add(l); }
        public void setnodeType( String nt ) { this.nodeType = nt; }
        public void setcurrentNode( Boolean cn ) { this.currentNode = cn; }

        /**
        * @Change this to your sObject
        */
        public void setasset( Asset a ) { this.asset = a; }

        /**
        * @Change the parameters to your sObject
        */
        public AssetStructureMap( String nodeId, Boolean[] levelFlag,Boolean[] closeFlag , String nodeType, Boolean lastNode, Boolean currentNode, Asset a ){
            
            this.nodeId         = nodeId;
            this.levelFlag      = levelFlag; 
            this.closeFlag      = closeFlag;
            this.nodeType       = nodeType;
            this.currentNode    = currentNode;

            //Change this to your sObject  
            this.asset = a;
        }
    }
}