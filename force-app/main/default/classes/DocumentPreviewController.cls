public class DocumentPreviewController {
    
    
    @AuraEnabled
    public static String fetchEmailcontact(String oppId)
    {
        String email = '';
		for(OpportunityContactRole ocr : [Select OpportunityId, Contact.email From OpportunityContactRole where OpportunityId =:oppId and Contact.email != null])
        {
            email = email +ocr.Contact.email+ ';' ;
        }
        
        return email;
    }
    
      @AuraEnabled
    public static list<Proposal__c> fetchProposals(String oppId)
    {
        return  [SELECT Id,Name, createdDate, Opportunity__r.Owner.Manager.Name, Opportunity__r.Price_Updated__c, Opportunity__r.Proposal_Approved__c, lastmodifieddate FROM Proposal__c where Opportunity__c =:oppId  ORDER BY createdDate Desc limit 1000];
    }
  
    @AuraEnabled
    public static list<SOP__c> fetchSOPS(String oppId)
    {
        return  [SELECT Id,Name, createdDate, Opportunity__r.Owner.Manager.Name, Opportunity__r.Price_Updated__c ,Opportunity__r.Proposal_Approved__c, lastmodifieddate FROM SOP__c where Opportunity__c =:oppId  ORDER BY createdDate Desc limit 1000];
    }
    
    @AuraEnabled
    public static list<Contract> fetchContracts(String oppId)
    {
        return  [SELECT Id,Name, createdDate, Opportunity__r.Owner.Manager.Name, Opportunity__r.Price_Updated__c, Opportunity__r.Proposal_Approved__c, lastmodifieddate FROM Contract where Opportunity__c =:oppId  ORDER BY createdDate Desc limit 1000];
    }
    
    
     @AuraEnabled 
    public static void sendMailMethod(String mMail ,String mSubject ,String mbody, list<Attachment> AttachId, String ccMail,String VfPage, Id attId, String attName)
    {
        try
        {
             
            System.debug('VfPage-'+VfPage);
            System.debug('attId-'+attId);
            System.debug('attName-'+attName);
          
            
            list<Id> AttchIds=new list<Id>();
            String userEmail = UserInfo.getUserEmail();
            
          Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
             PageReference pref;
            
            if (VfPage =='contractpdf')
            {
              pref = page.contractPDF;  
            }
              if (VfPage =='soppdf')
            {
              pref = page.sopPDF;  
            }
            
              if (VfPage =='proposalpdf')
            {
              pref = page.proposalPDF;  
            }
           
            pref.getParameters().put('id',attId);
            pref.setRedirect(true);
            Blob b;
            if(Test.isRunningTest()) { 
                b = blob.valueOf('Unit.Test');
            } 
            else 
            {
            	b = pref.getContent();
            }
            attach.setFileName(attName+'.pdf');
            attach.setBody(b);
           
            Attachment attachment = new Attachment();
            attachment.Body = b;
            attachment.Name = attName+'.pdf';
            attachment.ParentId = attId; 
            insert attachment;            
            
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            List<String> sendCC = new List<String>();
            if(mMail.contains(';'))
            {
                sendTo = mMail.split(';');
                
            }
            else if(mMail.contains(','))
            {
                sendTo = mMail.split(',');
            }
            else
            {
                sendTo.add(mMail);
            }
            if(String.isNotBlank(ccMail))
            {
                if(ccMail.contains(';'))
                {
                    sendCC = ccMail.split(';');
                    
                }
                else if(ccMail.contains(','))
                {
                    sendCC = ccMail.split(',');
                }
                else
                {
                    sendCC.add(ccMail);
                }
            }
            system.debug('Emails::::::::' + sendTo);
            mail.setToAddresses(sendTo);
            if(sendCC.size() > 0)
            {
                mail.setCcAddresses(sendCC);
            }
            // Step 3: Set who the email is sent from
            //mail.setReplyTo(userEmail); // change it with your mail address.
            //mail.setSenderDisplayName('Aceli Team'); 
            
            // Step 4. Set email contents - you can use variables!
            mail.setSubject(mSubject);
            mail.setHtmlBody(mbody);
	       //     mail.setEntityAttachments(AttchIds);
              mail.setFileAttachments(new Messaging.EmailFileAttachment[]{attach});
          
            // Step 5. Add your email to the master list
            mails.add(mail);
            
            // Step 6: Send all emails in the master list
            system.debug('Emails::::::::' + mails);
            Messaging.sendEmail(mails);
        }
        
        catch (exception ex)
        {
            throw new AuraHandledException('Darn it! Something went wrong: '
                                           + ex.getMessage());    
        }
    } 
    
    
}