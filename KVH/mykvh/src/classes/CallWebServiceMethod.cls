global class CallWebServiceMethod
{
    @future(callout=true)
    public static void callMethod(ID acctID,String accType)
    {   
        CCDS_WebtopServices.AddContact(acctID,accType);
    }

}