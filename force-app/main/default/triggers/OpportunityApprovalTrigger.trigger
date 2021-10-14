trigger OpportunityApprovalTrigger on Opportunity (before update, after update) {
    
    if (Trigger.isBefore && Trigger.isUpdate)
    {
        for (Opportunity opp :  Trigger.new) 
            
        {
            if (opp.Amount != Trigger.OldMap.get(opp.Id).Amount && opp.StageName != 'Prospecting')
            {
                opp.Price_Updated__c = true;
            }
        }
    }
    
    //hi winnie test i am typing this thing for git testing
    
    
    if (Trigger.isupdate && Trigger.isAfter)
    {
        
        for (Opportunity opp :  Trigger.new) 
            
        {
            
            System.debug('opp.StageName  --'+opp.StageName );
            System.debug('opp.rigger.OldMap.get(opp.Id).StageName  --'+Trigger.OldMap.get(opp.Id).StageName);
            
            
            
            if (opp.StageName == 'Proposal Submitted For Approval' && opp.StageName != Trigger.OldMap.get(opp.Id).StageName) {
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('This opportunity has been submitted for pricing and proposal approval');
                req.setObjectId(opp.Id);
                req.setProcessDefinitionNameOrId('Opportunity_Quote_Verify');
                Approval.ProcessResult approvalResult = Approval.process(req);
                //  System.debug('opportunity submitted for approval successfully: '+approvalResult .isSuccess());
                
            }
            
            
            else if (opp.StageName == 'SOP Sent'  && opp.StageName != Trigger.OldMap.get(opp.Id).StageName) {
                Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                req1.setComments('This opportunity has been submitted for document checklist approval');
                req1.setObjectId(opp.Id);
                req1.setProcessDefinitionNameOrId('Opportunity_Checklist_Verify');
                
                Approval.ProcessResult approvalResult = Approval.process(req1);
                System.debug('opportunity submitted for approval successfully: '+approvalResult .isSuccess());
                
            }
            
            
            else if(opp.StageName == 'Closed Won'  && opp.StageName != Trigger.OldMap.get(opp.Id).StageName) {
                Account Acc = [Select Id,Sync_Record_Data__c, Galaxy_Customer_Type__c, AWB_Prefix__c, Galaxy_Customer_Category__c, IATA_Code__c, Carrier_Code__c  FROM Account  where Id = :opp.AccountId];
                Acc.Sync_Record_Data__c = true;
                Acc.Galaxy_Customer_Type__c = opp.Galaxy_Customer_Type__c;
                Acc.AWB_Prefix__c = opp.AWB_Prefix__c;
                Acc.Galaxy_Customer_Category__c = opp.Galaxy_Customer_Category__c ;
                Acc.IATA_Code__c  = opp.IATA_Code__c;
                Acc.Carrier_Code__c = opp.Carrier_Code__c;
                
                update Acc;
            }
            
        }
    }



}