public class quotePdfLineItemsConroller {
 public String families{ get; set; }
    public Map<String, List<OpportunityLineItem>> familyToOppLineMap { get; set; }
    public Map<String, List<Remark__c>> familyRemarksMap { get; set; }
    public List<OpportunityLineItem> oppLineItemList{get;set;}
    public list<String> productFamily{get;set;}
    public quotePdfLineItemsConroller(ApexPages.StandardController controller ) {
        
        familyToOppLineMap =  new Map<String, List<OpportunityLineItem>>();
        familyRemarksMap = new Map<String, List<Remark__c>>();
        families =  '';
        productFamily = new list<String>();
        set<String> productFamilies = new set<String>();
        system.debug(ApexPages.currentPage().getParameters().get('ID'));
        list<Quote> quotes = [SELECT OpportunityId from Quote WHERE Id=: ApexPages.currentPage().getParameters().get('ID') LIMIT 1];
        system.debug(quotes);
        string oppId =  (!quotes.isEmpty()) ? quotes[0].OpportunityId : '';
        
        system.debug(oppId);
        
        /*List<Opportunity>        opptyList = [SELECT Id,Name,(SELECT ID, Quantity, UnitPrice, TotalPrice,PricebookEntry.Name, PricebookEntry.Product2.Family FROM OpportunityLineItems)

FROM Opportunity WHERE Id =: oppId ];*/
        for(Opportunity opp :[SELECT Id,Name,(SELECT ID, Quantity, UnitPrice, TotalPrice,PricebookEntry.Name, PricebookEntry.Product2.Family FROM OpportunityLineItems),
                              (SELECT Id,Name,Opportunity__C,Quote__c,Remarks__c FROM Remarks__r)
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
            system.debug('@@oppLineItemList@@'+familyToOppLineMap);
        }
        for(Remark__c remark:[SELECT Id,Name,Opportunity__c,Quote__c,Remarks__c FROM Remark__c WHERE Quote__C IN:quotes])
        {
            families +=remark.Name+',';
            if (familyRemarksMap.get(remark.Name) == null)
            {
                familyRemarksMap.put(remark.Name, new list<Remark__c>());
            }
            familyRemarksMap.get(remark.Name).add(remark);
        }
        productFamily.addAll(productFamilies);
    }
    
}