public class generateProposalController {
    
    @AuraEnabled
    public static map<String, list<string>> fetchPickValue(String field_name,String ObjectName)
    {
        try
        {
            
            
            list<string> options = new list<string>();
            map<String, list<string>> mapPicklistOption = new map<String, list<string>>();
            SObjectType objToken = Schema.getGlobalDescribe().get(ObjectName);
            DescribeSObjectResult objDef = objToken.getDescribe();
            Map<String, Schema.SObjectField> field_map = objDef.fields.getMap(); //get a map of fields for the passed sobject
            
            List<Schema.PicklistEntry> pick_list_values = field_map.get(field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
            for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
                
                options.add(a.getValue());
                if(mapPicklistOption.get(field_name)==null)
                {
                    mapPicklistOption.put(field_name, new list<string>());
                }
                mapPicklistOption.get(field_name).add(a.getValue());
            }
            return mapPicklistOption; //return the List
        }
        
        catch (exception ex)
        {
            throw new AuraHandledException('Darn it! Something went wrong: '
                                           + ex.getMessage());    
        }
        
    }
    
    @auraenabled
    public static string submitforDiscountApproval(String oppId)
    {
        try
        {
            
            
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('This Opportunity submitted for discounts approval');
            req.setObjectId(oppId);
            req.setProcessDefinitionNameOrId('Opportunity_Discounting_Approval');
            Approval.ProcessResult approvalResult = Approval.process(req);
            //  System.debug('opportunity submitted for approval successfully: '+approvalResult .isSuccess());
            //  
            
            return 'success';
        }
        catch (exception ex)
        {
            throw new AuraHandledException('Darn it! Something went wrong: '  + ex.getMessage());    
        }
        
    }
    
    @AuraEnabled
    public static Opportunity getOpportunityDetails(String oppId)
    {
        try
        {
            
            
            Opportunity oppRecord = new Opportunity();
            for(Opportunity opp:[SELECT Id,Name,AccountId,Proposal_Approved__c, Opportunity_Checklist_Approved__c, Cargo_Details__c,Description,Pricebook2Id,Scope_Of_Work__c,Type_of_Cargo__c,
                                 (SELECT Id,ListPrice,OpportunityId,Name,Description,Product2Id,ProductCode,Quantity,UnitPrice,Subtotal,TotalPrice,PricebookentryId 
                                  FROM OpportunityLineItems),
                                 (SELECT Id,Description__c,Salutation__c FROM Proposal__r  ORDER BY Createddate DESC LIMIT 1 ),
                                 (SELECT Id,Quote_Description__c,Salutation__c FROM Quotes ORDER BY Createddate DESC LIMIT 1),
                                 (SELECT Id,Description__c FROM SOPs__r ORDER BY Createddate DESC LIMIT 1),
                                 (SELECT Id,Contract_Details__c FROM Contracts__r ORDER BY Createddate DESC LIMIT 1),
                                 (SELECT Id,Name,Opportunity__c,Remarks__c FROM Remarks__r ORDER BY Createddate )
                                 FROM Opportunity WHERE Id=:oppId])
            {
                oppRecord = opp;
            }
            return oppRecord;
        }
        
        catch (exception ex)
        {
            throw new AuraHandledException('Darn it! Something went wrong: '
                                           + ex.getMessage());    
        }
    }
    @AuraEnabled
    public static list<String> getProductFamily(String oppId)
    {
        try
        {
            
            
            list<String> families = new list<String>();
            set<String> uniqueFamily = new set<String>();
            for(AggregateResult aggOppProd:[SELECT count(Id), Pricebookentry.Product2.Family Family FROM OpportunityLineItem WHERE OpportunityId = :oppId GROUP BY Pricebookentry.Product2.Family ])
            {
                uniqueFamily.add((String)aggOppProd.get('Family'));
            }
            families.addAll(uniqueFamily);
            return families;
        }
        
        catch (exception ex)
        {
            throw new AuraHandledException('Darn it! Something went wrong: '
                                           + ex.getMessage());    
        }
    }
    @AuraEnabled
    public static List <EmailTemplate> getTemplates(String typeDocument)
    {
        
        List<EmailTemplate> templatesList;
        system.debug('===============>'+typeDocument);
        /*   templatesList = [SELECT Id,Content__c,Salutation__c,Ref__c,	Cargo_Details__c,Type__c FROM Template__c WHERE Type__c =:typeDocument ];*/
        
        templatesList = [SELECT id, name, developername, description, body,htmlvalue from EmailTemplate  WHERE Name =:typeDocument ];
        system.debug('===============>'+typeDocument);
        system.debug(templatesList);
        return templatesList;
        
    }
    @AuraEnabled
    public static Map<String, Template__c> getRemarks()
    {
        
        List<Template__c> templatesList  = [SELECT Id,Content__c,Salutation__c,Ref__c,	Cargo_Details__c,Type__c,Family__c 
                                            FROM Template__c
                                            WHERE Family__c != null];
        
        Map<String, Template__c> productFamilyToTemplateRemarkMap = new Map<String, Template__c>();
        
        for(Template__c temp: templatesList)
        {
            if(temp.Family__c != null && temp.Content__c != null)
            {
                productFamilyToTemplateRemarkMap.put(temp.Family__c, temp);
            }
        }
        
        return productFamilyToTemplateRemarkMap;
    }
    
    @AuraEnabled
    public static list<sobject> saveDocumentDetails(List<sObject> docDetails, Id oppId, String  letterhead, String typeDocument)
    {
        try
        {
            List<sobject> soToUpdate = new List<sobject>();
            
            for (sobject so : docDetails)
            {
                
                    System.debug('so --'+ so);
                String docName = '';
                Opportunity opp;
                if(String.isNotBlank(oppId))
                {
                    opp = [SELECT Id,Account.Name   FROM Opportunity WHERE Id =:oppId];
                }
                System.debug('opp --'+ opp);
                System.debug('ID --'+ so.get('Id'));
                System.debug(letterhead);
                String refNumber;
                if (letterhead == 'Mitchell Cotts Kenya')
                {
                    refNumber = 'MCFKL/'+System.Today().year()+'/'+System.Today().month()+'-';
                }
                else if (letterhead == 'Mitchell Cotts Rwanda')
                {
                    refNumber = 'MCFRL/'+System.Today().year()+'/'+System.Today().month()+'-';
                }
                else if (letterhead == 'Upstream Uganda')
                {
                    refNumber = 'UPL/'+System.Today().year()+'/'+System.Today().month()+'-';
                }
                else if (letterhead == 'Seven Stars')
                {
                    refNumber = 'SSL/'+System.Today().year()+'/'+System.Today().month()+'-';
                }
                
                DocumentRefNumber__c refnumberMT = DocumentRefNumber__c.getInstance(letterhead);
                 System.debug('refnumberMT --'+refnumberMT);
               
                refnumberMT.Last_Number__c =  refnumberMT.Last_Number__c + 1;
                Integer lastnumber = Integer.valueOf(refnumberMT.Last_Number__c );
                
                refNumber = refNumber+ String.valueOf(lastnumber).leftPad(4, '0');
                System.debug('refNumber --'+refNumber);
                
                docName = opp.Account.Name + ' - '+typeDocument + ' - ' + refnumber;
                
                
                so.put('Reference_Number__c', refnumber);
                so.put('Name', docName);
                System.debug('final so --'+so);
                soToUpdate.add(so);
                update refnumberMT;
                
            }
            
            System.debug(soToUpdate);
            upsert soToUpdate;
            upsert docDetails;
            return docDetails;
        }
        catch (exception ex)
        {
            throw new AuraHandledException('Darn it! Something went wrong: '
                                           + ex.getMessage());    
        } 	
    }
    
    
    @AuraEnabled
    public static Opportunity updateOpportunity(Opportunity opp)
    {
        try
        {        
            update opp;
            
        }
        catch (exception ex)
        {
            throw new AuraHandledException('Darn it! Something went wrong: '
                                           + ex.getMessage());    
        }
        
        return opp;
    }
    @AuraEnabled
    public static list<QuoteLineItem> saveQuoteLineItem(List<OpportunitylineItem> opplines, String quoteId)
    {
        
        try
        {
            system.debug('=====================>'+opplines);
            system.debug('=====================>'+quoteId);
            list<QuoteLineItem> quoteLineItems = new list<QuoteLineItem>();
            list<QuoteLineItem> updateQuoteLnItms = new list<QuoteLineItem>();
            if(opplines!=null)
            {
                map<Id,Id> mapQuoteLineId = new map<Id,Id>();
                for(QuoteLineItem quoteLine:[SELECT Id,OpportunityLineItemId FROM QuoteLineItem WHERE QuoteId=:quoteId])
                {
                    mapQuoteLineId.put(quoteLine.OpportunityLineItemId,quoteLine.Id);
                }
                for(OpportunitylineItem oppProd:opplines)
                {
                    QuoteLineItem quoteLine = new QuoteLineItem();
                    quoteLine.Product2Id = oppProd.Product2Id;
                    quoteLine.OpportunityLineItemId = oppProd.Id;
                    quoteLine.PricebookEntryId = oppProd.PricebookEntryId;
                    quoteLine.Quantity = oppProd.Quantity;
                    quoteLine.UnitPrice = oppProd.UnitPrice;
                    quoteLine.QuoteId = quoteId;
                    if(mapQuoteLineId.containsKey(quoteLine.OpportunityLineItemId))
                    {
                        quoteLine.Id = mapQuoteLineId.get(quoteLine.OpportunityLineItemId);
                        updateQuoteLnItms.add(quoteLine);
                    }
                    else
                    {
                        quoteLineItems.add(quoteLine);
                    }
                }
                if(quoteLineItems.size()>0)
                {
                    insert quoteLineItems;
                }
                if(updateQuoteLnItms.size()>0)
                {
                    update updateQuoteLnItms;
                }
                upsert quoteLineItems;
            }
            
            return quoteLineItems;
            
        }
        catch (exception ex)
        {
            throw new AuraHandledException('Darn it! Something went wrong: '
                                           + ex.getMessage());    
        }
    }
    
    @AuraEnabled 
    public static Opportunity saveAttachmentDoc( Id oppId, String selectedDocument)
    { 
        try
        {
            
            String attName = '';
            Opportunity opp;
            if(String.isNotBlank(oppId))
            {
                opp = [SELECT Id,Account.Name, SOP_Sent__c, Probability, Price_Updated__c,  StageName  FROM Opportunity WHERE Id =:oppId];
            }
            
            if(selectedDocument.contains('SOP'))
            { 
                opp.SOP_Sent__c = true;
                opp.StageName = 'SOP Sent';
            }
            
            update opp;
            
            return opp;
            
        }
        catch (exception ex)
        {
            throw new AuraHandledException('Darn it! Something went wrong: '
                                           + ex.getMessage());    
        }
    }
    
    
    
    @AuraEnabled 
    public static void sendMailMethod(String mMail ,String mSubject ,String mbody, list<Attachment> AttachId, String ccMail)
    {
        try
        {
            
            
            list<Id> AttchIds=new list<Id>();
            String userEmail = UserInfo.getUserEmail();
            
            for(Attachment att:AttachId)
            {
                AttchIds.add(att.Id);
            }
            List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
            
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
            mail.setEntityAttachments(AttchIds);
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
    @AuraEnabled
    public static list<Remark__c> saveRemarks(list<Remark__c> remarks)
    {
        try
        {
            
            
            upsert remarks;
            return remarks;
        }
        catch (exception ex)
        {
            throw new AuraHandledException('Darn it! Something went wrong: '
                                           + ex.getMessage());    
        }
    }
    
    @AuraEnabled
    public static void saveProposal(List<Proposal__C> proposal){
        try
        {
            
            
            insert proposal;
        }
        catch (exception ex)
        {
            throw new AuraHandledException('Darn it! Something went wrong: '
                                           + ex.getMessage());    
        }
    }
    
    @AuraEnabled
    
    public static List<Opportunity> getAccountID(String opportunityId) {
        try
        {
            list<Opportunity> accId = [SELECT AccountID from Opportunity WHERE Id=:opportunityId  LIMIT 1];
            
            return accId;
        }
        catch (exception ex)
        {
            throw new AuraHandledException('Darn it! Something went wrong: '
                                           + ex.getMessage());    
        }
    }
    
}