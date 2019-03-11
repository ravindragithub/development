trigger BIG_PopulateWorkOrderFields on Work_Order__c (before insert, before update) {
    
    List<id> case_ids = new List<id>();
    
    for(Work_Order__c w:Trigger.new)
        if(w.Case__c!=null)
            case_ids.add(w.Case__c);
          
    if(!case_ids.isEmpty())
    {
        Map<id,Case> m_case = new Map<id,Case>([SELECT ID,Thread_ID__c from Case WHERE ID IN :case_ids]);
        Case temp_case;
        for(Work_Order__c w:Trigger.new)
        {
            if(w.Case__c!=null && m_case.containskey(w.Case__c))
            {
                temp_case=m_case.get(w.Case__c);
                w.hTreadId__c=temp_Case.Thread_ID__c;
                
                
            }
            
            
            
        }
        
        
        
    }

}