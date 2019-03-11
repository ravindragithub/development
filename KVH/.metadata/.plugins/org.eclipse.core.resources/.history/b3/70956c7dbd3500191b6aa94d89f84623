/*

	Name: UDebug
	Created By: Jason McCormack (GearsCRM)
	Created Date: 2012-04-11
	Description:
    
	Modified By:
	Modified Date:
	Description:	

*/

public class UDebug 
{   
    public static void printDebug(String debugText)
    {
        System.debug('\n\n########## - ' + debugText.trim().toUpperCase() + '\n');        
    }
    
    public static void printDmlMessagesToDebug(DmlException e)
    {       
        if(e == null)
        {
            return;
        }
        
        for (Integer i = 0; i < e.getNumDml(); i++) 
        {    
            printDebug(e.getDmlMessage(i));         
        }
    }
    
    public static void debugPageParameters(PageReference pr)
    {
    	if(pr == null)
    	{
    		return;
    	}
    	
    	for(String param : pr.getParameters().keySet())
		{
			printDebug(param + ' = ' + ApexPages.currentPage().getParameters().get(param));
		}
    }
    
    private static testmethod void testCode()
    {        
        printDebug('This is a sample message');
        
        Contact c1 = new Contact();
        
        c1.FirstName = 'Test';
        c1.LastName = 'Contact 1';
        
        try
        {
            update c1;
        }
        catch(DmlException e)
        {
            printDmlMessagesToDebug(e);
            printDmlMessagesToDebug(null);
        }   
                                    
        PageReference pr = new PageReference('/home/home.jsp?test=test');
        
        debugPageParameters(pr);
    }                
}