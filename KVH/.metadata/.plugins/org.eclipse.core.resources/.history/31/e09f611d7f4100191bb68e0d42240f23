public Class UAccountShareJKT_Utility{
    public static AccountShare DMLAccountShare(AccountShareProfiles__c asp,String accID,ID userGroupID){
        AccountShare newShare = new AccountShare();
        newShare.UserOrGroupId = userGroupID;
        newShare.AccountId = accID;
        newShare.CaseAccessLevel = asp.caseAccess__c;
        newShare.AccountAccessLevel = asp.accountAccess__c;
        newShare.OpportunityAccessLevel = asp.opportunityAccess__c;
        return newShare;
    }
    public static void sendEnhanceReport(List<wrapAccountError> failedAccountShareRecords,Id jobId,Integer failurecount,Integer successCount){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        AsyncApexJob a = [SELECT Id,Status,NumberOfErrors,JobItemsProcessed,TotalJobItems,CompletedDate,ExtendedStatus,ApexClass.name,CreatedBy.Email,
                          CreatedBy.Name FROM AsyncApexJob WHERE Id =: jobId];
        String[] toAddresses = new String[] {System.label.UAccount_Share_Report_Email};
            mail.setToAddresses(toAddresses);
        //mail.setTargetObjectId(emailABC);
        mail.setSubject('Batch Code Complete : '+a.ApexClass.name);
        mail.setUseSignature(false);
        mail.saveAsActivity = false;
        
        Messaging.EmailFileAttachment pdfAttc = new Messaging.EmailFileAttachment();
        String pdfString = '<html><body>';
        pdfString += '<table  style="font-size:8pt;" bgcolor="white" border="1" align="center" width="100%" cellspacing="0" >';
        pdfString += '<tr width="100%"><th colspan="1" bgcolor="#D3D3D3" align="center"><b> User Or Group Name </b></th>';
        pdfString += '<th colspan="1" bgcolor="#D3D3D3" align="center"><b> Profile Name </b></th>';
        pdfString += '<th colspan="1" bgcolor="#D3D3D3" align="center"><b> Account Id </b></th>';
        pdfString += '<th colspan="1" bgcolor="#D3D3D3" align="center"><b> AccountAccessLevel  </b></th>';
        pdfString += '<th colspan="1" bgcolor="#D3D3D3" align="center"><b> CaseAccessLevel  </b></th>';
        pdfString += '<th colspan="1" bgcolor="#D3D3D3" align="center"><b> Error Message</b> </th></tr>';
        for(wrapAccountError temp : failedAccountShareRecords)
        {
            pdfString += '<tr><td align="center">' + temp.UName+ '</td>';
            pdfString += '<td align="center">' + temp.PName+ '</td>';
            pdfString += '<td align="center">' + temp.AccountId + '</td>';
            pdfString += '<td align="center">' + temp.AccountAccessLevel + '</td>';
            pdfString += '<td align="center">' + temp.CaseAccessLevel + '</td>';
            pdfString += '<td align="center">' + temp.errorMessage+ '</td></tr>';
            
        }
        pdfString += '</table ></body></html>';
        Datetime myDT = Datetime.now(); // Returns the current Datetime based on a GMT calendar.
        String presentDate = myDT.format('dd/MM/yyyy'); // formats the date
        string pdfName= 'UAccount Share_Failed Records_'+presentDate+'.pdf';
        pdfAttc.setFileName(pdfName);
        pdfAttc.setContentType('application/pdf');
        pdfAttc.Body = Blob.toPDF(pdfString);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[]{pdfAttc});
        
        string td1='"border:1px solid #1797c0; width=200px;"';
        string td2='"width=200px; border:1px solid #1797c0; background-color:red; color:white; font-weight:bold;"';
        string tdHead='"border:1px solid #1797c0; width=200px; color: black; background-color: #1797c0;"';
        string ExtendedStatus='';
        if(a.ExtendedStatus!=null)
            ExtendedStatus=a.ExtendedStatus;
        string tdErrors=td1;
        if(a.NumberOfErrors>0)
            tdErrors=td2;
        string htmlBody = '<div ><p>Hi '+a.CreatedBy.Name +',</p><p>Salesforce completed running <b>Apex Batch Code</b>.</p>'
            +'<p>Results:</p>'
            +'<center><table style="border:2px solid #1797c0; border-collapse:collapse;">'
            +'<tr><td style='+tdHead+'>Job Id</td><td style='+tdHead+'>'+a.Id+'</td></tr>'
            +'<tr><td style='+tdHead+'>Class Name</td><td style='+tdHead+'>'+a.ApexClass.name+'</td></tr>'
            +'<tr><td style='+td1+'>Completed Date</td><td style='+td1+'>'+a.CompletedDate+'</td></tr>'
            +'<tr><td style='+td1+'>Status</td><td style='+td1+'>'+a.Status+'</td></tr>'
            +'<tr><td style='+td1+'>Job Items Processed</td><td style='+td1+'>'+a.JobItemsProcessed+' / '+a.TotalJobItems+'</td></tr>'
            +'<tr><td style='+td1+'>Success Records</td><td style='+tdErrors+'>'+successCount+'</td></tr>'
            +'<tr><td style='+td2+'>Failure Records</td><td style='+tdErrors+'>'+failurecount +'</td></tr>'
            +'<tr><td style='+td2+'>Extended Status</td><td style='+td1+'>'+ExtendedStatus+'</td></tr>'
            +'<tr><td style='+tdHead+'>Created By</td><td style='+tdHead+'>'+a.CreatedBy.Name+' ('+a.CreatedBy.Email+')</td></tr>'
            +'</table></center>'
            +'</div>';
        
        mail.setHtmlBody(htmlBody);
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        mails.add(mail);
        Messaging.sendEmail(mails);
    }
    public class wrapAccountError {
        public string UName;
        public string PName;
        public Id AccountId;
        public string AccountAccessLevel;
        public string OpportunityAccessLevel;
        public string CaseAccessLevel;
        public string errorMessage;
        public wrapAccountError(string uId,string pId,Id aId,string aa,string oa,string ca,string eMsg) {
            UName = uId;
            PName = pId;
            AccountId = aId;
            AccountAccessLevel = aa;
            OpportunityAccessLevel = oa;
            CaseAccessLevel = ca;
            errorMessage = eMsg;
        }
    }
}