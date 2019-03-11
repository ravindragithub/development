/************************************************
    Name        :    AccountHierarchyUtility
    Description :    This class give the account hirarchy in without sharing mode
**************************************************/
public without sharing class AccountHierarchyUtility{

    //Declare variables
    public String currentId;
    public List<ObjectStructureMap> asm ;
    public Map<String, ObjectStructureMap> masm;
    public List<Integer> maxLevel;
    
    /**
    * Contructor
    */
    public AccountHierarchyUtility() {
        this.asm = new List<ObjectStructureMap>{};
        this.masm = new Map<String, ObjectStructureMap>{};
        this.maxLevel = new List<Integer>{};
    }
    
    /**
    * Allow page to set the current ID
    */
    public void setcurrentId( String cid ){
        currentId = cid;
    }

    /**
    * Return ObjectStructureMap to page
    * @return asm
    */
    public List<ObjectStructureMap> getObjectStructure(){          //gets hierarchy from Top down
        asm.clear();
        if ( currentId == null ) {
            currentId = System.currentPageReference().getParameters().get( 'id' );
        }
        System.assertNotEquals( currentId, null, 'sObject ID must be provided' );
        asm = formatObjectStructure( CurrentId, true);
        return asm;
    }
  public List<ObjectStructureMap> getObjectStructure(string AcctId){    //overloaded method, gets hierarchy from AcctId down
    asm.clear();
    System.assertNotEquals( AcctId, null, 'sObject ID must be provided' );
    System.assertEquals('001', AcctId.left(3), 'sObject Id must be an Account Id');
    asm = formatObjectStructure( AcctId, false);
        return asm;
  }

    /**
    * Query Account from top down to build the ObjectStructureMap
    * @param currentId
    * @return asm
    */
    public ObjectStructureMap[] formatObjectStructure( String currentId, Boolean TopDown ){  //refactor to accept boolean, topDown or not topDown
    
        List<ObjectStructureMap> asm = new List<ObjectStructureMap>{};
        masm.clear();

        //Change below
        List<Account> al            = new List<Account>{};
        List<ID> currentParent      = new List<ID>{};
        Map<ID, String> nodeList    = new Map<ID, String>{};
        List<String> nodeSortList   = new List<String>{};   //String List sorts like 1.1, 1.11, 1.12, 1.2...
                                                            //This messes up the sequence of the children
        List<Boolean> levelFlag     = new List<Boolean>{};
        List<Boolean> closeFlag     = new List<Boolean>{};
        String nodeId               = '0';
        String nodeType             = 'child';
        Integer count               = 0;
        Integer level               = 0;
        Boolean endOfStructure      = false;
        
        //Find highest level obejct in the structure if TopDown is selected!
        If(TopDown){
          currentParent.add( GetTopElement( currentId ) );      //Get Hierarchy from the Top
        } else {
          currentParent.add(currentId);                //Get Hierarchy from the current level
        }
        

        //Loop though all children
        while ( !endOfStructure ){

            if( level == 0 ){
                //Change below     
                al = [ SELECT a.Type, a.Site, a.ParentId, a.OwnerId, a.Custom_Call_Acct_ID__c,
                a.Name, a.Industry, a.Id, a.BillingCity, a.BillingState, a.Send_to_myKVH_Physical__c,
                a.RecordType.Name, a.RecordType.DeveloperName FROM Account a WHERE a.id IN : CurrentParent ORDER BY a.Name ];
            } 
            else {
                //Change below      
                al = [ SELECT a.Type, a.Site, a.ParentId, a.OwnerId, a.Custom_Call_Acct_ID__c,
                a.Name, a.Industry, a.Id, a.BillingCity, a.BillingState, a.Send_to_myKVH_Physical__c,
                a.RecordType.Name, a.RecordType.DeveloperName FROM Account a WHERE a.ParentID IN : CurrentParent ORDER BY a.Name ];
            }
            al.sort();
            
            for ( Integer i = 0 ; i < al.size(); i++ ){
                    system.debug(al[i].name);
                }
            if( al.size() == 0 ){
                endOfStructure = true;
                
            }
            else{
                currentParent.clear();
                for ( Integer i = 0 ; i < al.size(); i++ ){
                    //Change below
                    Account a = al[i];
                    //The following line acts like an IIF statement, AND breaks the alphabetical order of the children!
                    //nodeId = ( level > 0 ) ? NodeList.get( a.ParentId )+'.'+String.valueOf( i ) : String.valueOf( i );
                    /*The node sort list looks like {0, 0.1, 0.2, 1.0, ... 0.12, .0.13}
                      This can cause a problem with sorting of there are >10 children... it might not sort in 
                      alphabetical order. Adding leading 0s to the sort string will alleviate the problem as long as
                      there are not more than 10000 children.*/
                    If( level > 0) {
                        nodeId = NodeList.get( a.ParentId )+'.'+String.valueOf( i ).leftPad(5);
                        nodeId = nodeId.replaceAll(' ', '0');
                    }   else    {
                        nodeId = String.valueOf( i ).leftPad(5); // we want at least 5 chars for sorting purposes
                        nodeId = nodeId.replaceAll(' ', '0');
                    }
                    
                    system.debug(nodeId +', '+ a.name);
                    masm.put( NodeID, new ObjectStructureMap( nodeID, levelFlag, closeFlag, nodeType, false, false, a ) );
                    currentParent.add( a.id );
                    nodeList.put( a.id,nodeId );
                    nodeSortList.add( nodeId );
                }
                
                maxLevel.add( level );                
                level++;
                system.debug(level);
            }
        }
        
        //Account structure must now be formatted
        system.debug(NodeSortList);
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
            
            ObjectStructureMap tasm = masm.get( cn );
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
            if ( tasm.account.id == currentId ) {
                tasm.currentNode = true;
            }
            asm.add( tasm );
        }
        
        if(asm.size()>0){
            asm[0].nodeType             = 'start';
            asm[asm.size()-1].nodeType  = 'end';
        }
        
        return asm;
    }
    
    /**
    * Determin parent elements relationship to current element
    * @return flagList
    */
    public List<Boolean> setlevelFlag( List<String> nodeElements, String nodeType ){
        
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
    public List<Boolean> setcloseFlag( List<String> cnl, List<String> nnl, String nodeType ){
        
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
    public Boolean isLastNode( List<String> nodeElements ){
        
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
    public String GetTopElement( String objId ){
        
        Boolean top = false;
        while ( !top ) {
            //Change below
            Account a = [ Select a.Id, a.Name, a.ParentId From Account a where a.Id =: objId limit 1 ];
            system.debug('Name: ' + a.Name + ' Id: ' + a.ID + ' Parent: ' + a.ParentId);
            if ( a.ParentID != null ) {
                objId = a.ParentID;
            }
            else {
                top = true;
            }
        }
        return objId ;
    }
    
    /**
    * Wrapper class
    */
    public without sharing class ObjectStructureMap{

        public String nodeId;
        public Boolean[] levelFlag = new Boolean[]{};
        public Boolean[] closeFlag = new Boolean[]{};
        public String nodeType;
        public Boolean currentNode;
        
        /**
        * @Change this to your sObject
        */
        public Account account;
        
        public String getnodeId() { return nodeId; }
        public Boolean[] getlevelFlag() { return levelFlag; }
        public Boolean[] getcloseFlag() { return closeFlag; }
        public String getnodeType() { return nodeType; }
        public Boolean getcurrentNode() { return currentNode; }


        /**
        * @Change this to your sObject
        */
        public Account getaccount() { return account; }
        
        public void setnodeId( String n ) { this.nodeId = n; }
        public void setlevelFlag( Boolean l ) { this.levelFlag.add(l); }
        public void setlcloseFlag( Boolean l ) { this.closeFlag.add(l); }
        public void setnodeType( String nt ) { this.nodeType = nt; }
        public void setcurrentNode( Boolean cn ) { this.currentNode = cn; }

        /**
        * @Change this to your sObject
        */
        public void setaccount( Account a ) { this.account = a; }

        /**
        * @Change the parameters to your sObject
        */
        public ObjectStructureMap( String nodeId, Boolean[] levelFlag,Boolean[] closeFlag , String nodeType, Boolean lastNode, Boolean currentNode, Account a ){
            
            this.nodeId         = nodeId;
            this.levelFlag      = levelFlag; 
            this.closeFlag      = closeFlag;
            this.nodeType       = nodeType;
            this.currentNode    = currentNode;

            //Change this to your sObject  
            this.account = a;
        }
    }
}