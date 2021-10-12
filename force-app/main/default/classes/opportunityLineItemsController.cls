public class opportunityLineItemsController {
    public String families{ get; set; }
    public String letterhead{ get; set; }
    public Map<String, List<OpportunityLineItem>> familyToOppLineMap { get; set; }
    public Map<String, List<Remark__c>> familyRemarksMap { get; set; }
    public Boolean showFamailyRemarks{get;set;}
    public List<OpportunityLineItem> oppLineItemList{get;set;}
    public list<String> productFamily{get;set;}
    public string documentContent {get;set;} 
    
    public opportunityLineItemsController(ApexPages.StandardController controller ) {
        Id proposalId =  ApexPages.currentPage().getParameters().get('ID');
        
        
      /*  EmailTemplate et = [SELECT Id,Subject, Body, htmlvalue  FROM EmailTemplate WHERE DeveloperName ='test_SOP_1631004034118'];
        
        documentContent = et.htmlvalue;
        Pattern p = Pattern.compile('\\(\\(.+?\\)\\)');
        String query = 'Select Id';
        Set<String> fieldsToReplace = new Set<String>();
        Map<String, String> fieldsToReplaceMap = new Map<String, String>();
        Matcher m = p.matcher(documentContent);
        while(m.find()) {
            String myfield =m.group(0);
            
            myfield = myfield.replaceAll('\\(\\(', '');
            myfield = myfield.replaceAll('\\)\\)', '');
            
            query +=', '+ myfield;
            fieldsToReplace.add(myfield);
            
        }
        query += ' FROM Proposal__c where id = \''+proposalId+'\'';
        System.debug(query);
        
        query = query.replaceAll('\\(\\(', '');
        query = query.replaceAll('\\)\\)', '');
        
        System.debug(query);
        
        Sobject myproposal = (SObject) Database.query(query) ;
        
        
        
        
        
        for (String myfield :fieldsToReplace)
        {
            System.debug('in set --'+ myfield);
            LIst<String> myfieldSplit = myfield.split('\\.');
            Integer myfieldSplitSize = myfieldSplit.size();
            Sobject mysobject;
            
            for (integer x = 0; x< myfieldSplitSize -1; x++)
            {
                if (x == 0)
                {
                    mysobject = myproposal.getSobject(myfieldSplit[x]);
                    System.debug('mysobject --0'+mysobject);
                }
                else
                {
                    mysobject = mysobject.getSobject(myfieldSplit[x]);
                    System.debug('mysobject --1'+mysobject);
                }
                
                
            }
            
            String mynewvalue =String.valueOf( mysobject.get(myfieldSplit[myfieldSplitSize-1]));
            
            
            documentContent = documentContent.replaceAll('\\(\\('+myfield+'\\)\\)', mynewvalue);
            
        }*/
        
        
        familyToOppLineMap =  new Map<String, List<OpportunityLineItem>>();
        familyRemarksMap = new Map<String, List<Remark__c>>();
        showFamailyRemarks = false;
        families =  '';
        productFamily = new list<String>();
        set<String> productFamilies = new set<String>();
        letterhead= ApexPages.currentPage().getParameters().get('letterHeadValue');
        system.debug(ApexPages.currentPage().getParameters().get('letterHeadValue'));
        list<Proposal__c> proposals = [SELECT Opportunity__c from Proposal__c WHERE Id=:proposalId LIMIT 1];
        
        string oppId =  (!proposals.isEmpty()) ? proposals[0].Opportunity__c : '';
        
        system.debug(proposals);
        
        
        for(Opportunity opp :[SELECT Id,Name,(SELECT ID, Quantity, UnitPrice, TotalPrice,PricebookEntry.Name, PricebookEntry.Product2.Family FROM OpportunityLineItems),
                              (SELECT Id,Name,Opportunity__c,Proposal__c,Remarks__c FROM Remarks__r)
                              FROM Opportunity WHERE Id =: oppId ])
        {
            //oppLineItemList = opp.OpportunityLineItems;
            
            for (OpportunityLineItem oli :opp.OpportunityLineItems)
            {
                system.debug('===================>'+oli.PricebookEntry.Product2.Family);
                if(oli.PricebookEntry.Product2.Family != null)
                {
                    productFamilies.add(oli.PricebookEntry.Product2.Family);
                    if (familyToOppLineMap.get(oli.PricebookEntry.Product2.Family) == null)
                    {
                        familyToOppLineMap.put(oli.PricebookEntry.Product2.Family, new list<OpportunityLineItem>());
                    }
                    
                    familyToOppLineMap.get(oli.PricebookEntry.Product2.Family).add(oli);
                }
            }
            
            system.debug('@@oppLineItemList@@'+oppLineItemList);
        }
        for(Remark__c remark:[SELECT Id,Name,Opportunity__c,Proposal__c,Remarks__c FROM Remark__c WHERE Proposal__c IN:proposals])
        {
            families +=remark.Name+',';
            if (familyRemarksMap.get(remark.Name) == null)
            {
                familyRemarksMap.put(remark.Name, new list<Remark__c>());
            }
            familyRemarksMap.get(remark.Name).add(remark);
        }
        
        productFamily.addAll(productFamilies);
        set<Boolean> showFamilyRmrks = new set<Boolean>();
        for(String fmly:productFamily)
        {
            if(familyRemarksMap.containsKey(fmly))
            {
                showFamilyRmrks.add(familyRemarksMap.containsKey(fmly));
            }
        }
        if(showFamilyRmrks.contains(true))
        {
            showFamailyRemarks = true;
        }
    }
    
    
    
}