public class ProductWizardController {
    
  /*   @AuraEnabled
    public static List<Product2> getProducts(Opportunity opportunityRecord){
        
        List<Product2> clist = new list<Product2>();
        set<Id> prodids = new set<Id>();
        system.debug('=========================>'+prodids);
        for(PricebookEntry pbe:[SELECT Id,Product2Id,CurrencyIsoCode,Pricebook2Id FROM PricebookEntry WHERE CurrencyIsoCode =:opportunityRecord.CurrencyIsoCode AND Pricebook2Id =:opportunityRecord.Pricebook2Id AND IsActive = true ])
        {
            prodids.add(pbe.Product2Id);
        }
        system.debug('=========================>'+opportunityRecord);
        for(Product2 cs:[Select Id,Name, Price__c,Family,QuantityUnitOfMeasure,Service_Type__c From Product2 WHERE Id IN:prodids limit 10])
        {
            clist.add(cs);
        }
        return cList;
    }
*/
    
    @AuraEnabled
    public static List<Pricebook2> fetchPriceBook()
    {
        
        List<Pricebook2> pricebooks = new list<Pricebook2>();
        
        for(Pricebook2 pk:[Select Id,Name From Pricebook2 WHERE IsActive = true])
        {
            pricebooks.add(pk);
        }
        return pricebooks;
    }
    
    @AuraEnabled  
    public static List <OpportunityLineItemWrapper> searchServiceTypeProducts(string searchVar,Opportunity opportunityRecord,  string serviceline,string servicetype)
    {
        
        list<OpportunityLineItemWrapper> oliWrapper = new  list<OpportunityLineItemWrapper>();
        
           system.debug('opportunityRecord.'+opportunityRecord.Pricebook2Id);
            String myPdId = opportunityRecord.Pricebook2Id;
            String oppCurrency = opportunityRecord.CurrencyIsoCode;
     
            String queryString = 'SELECT Id,Name,Product2.Id,Product2.QuantityUnitOfMeasure, Product2.Name,Product2.Family,Product2.Service_Type__c,UnitPrice,CurrencyIsoCode, Product2.Description '; 
            queryString+= ' FROM Pricebookentry ';
            queryString+= ' WHERE PriceBook2.IsStandard=true ';
            queryString+= ' AND Pricebook2Id =: myPdId ';
            queryString+= ' AND CurrencyIsoCode =: oppCurrency ';
            queryString+= 'AND IsActive = true';
            if(serviceline != null && serviceline != '')
            {
                 queryString+= ' AND ( Product2.Family =: serviceline ) ';
            }
            
            if(servicetype != null && servicetype != '')
            {
                 queryString+= ' AND ( Product2.Service_Type__c =: servicetype ) ';
            }
            if(searchVar != null && searchVar != '')
            {
              string var = '%'+searchVar+'%';
               queryString+= ' AND ( Product2.Name like: var  OR Product2.QuantityUnitOfMeasure like: var OR Product2.Description like: var OR Product2.Family like: var  OR Product2.Service_Type__c like: var ) ';
            }
        
        queryString+= ' ORDER BY Product2.Name ASC ';   
        queryString+= ' LIMIT 50 ';
        
            System.debug('queryString ---> + '+queryString);
            
           List<PricebookEntry> priceBookEntryList = Database.query(queryString);
        
        if(priceBookEntryList.size() > 0)
        {
            List<OpportunityLineItemWrapper> convertedList = convertToOliWrapper(priceBookEntryList, opportunityRecord);
            
             system.debug('convertedList: '+convertedList[0].pbe.Product2.Name);
            
            oliWrapper.addall(convertedList);
        }
        
        return oliWrapper;  
  
    }
    
    @AuraEnabled
    public static List <OpportunityLineItemWrapper> filterProductsServiceLine(Opportunity opportunityRecord, string serviceline, string servicetype ){
        
        system.debug('opportunityRecord.'+opportunityRecord.Pricebook2Id);
        List<OpportunityLineItemWrapper> oliWrapper = new List<OpportunityLineItemWrapper>();
        
        String myPdId = opportunityRecord.Pricebook2Id;
        String oppCurrency = opportunityRecord.CurrencyIsoCode;
        
        String queryString = 'SELECT Id,Name,Product2.Id,Product2.QuantityUnitOfMeasure, Product2.Name,Product2.Family,Product2.Service_Type__c,UnitPrice,CurrencyIsoCode, Product2.Description '; 
        queryString+= ' FROM Pricebookentry ';
        queryString+= ' WHERE PriceBook2.IsStandard=true ';
        queryString+= ' AND Pricebook2Id =: myPdId ';
        queryString+= ' AND CurrencyIsoCode =: oppCurrency ';
        queryString+= 'AND IsActive = true';
        if(serviceline != null && serviceline != '')
        {
            queryString+= ' AND ( Product2.Family =: serviceline ) ';
        }
        
        if(servicetype != null && servicetype != '')
        {
            queryString+= ' AND ( Product2.Service_Type__c =: servicetype ) ';
        }
        
        System.debug('queryString ---> + '+queryString);
        
        List<PricebookEntry> priceBookEntryList = Database.query(queryString);        
        system.debug('priceBookEntryList'+priceBookEntryList);
        
        if(priceBookEntryList.size() > 0)
        {
            List<OpportunityLineItemWrapper> convertedList = convertToOliWrapper(priceBookEntryList, opportunityRecord);                
            system.debug('convertedList: '+convertedList[0].pbe.Product2.Name);                
            oliWrapper.addall(convertedList);
        }
        
        return oliWrapper;  
    }
    
     @AuraEnabled
    public static list<OpportunityLineItem> saveOpportunityLineItems(list<OpportunityLineItemWrapper> selectedOliWrapper, Opportunity opportunityRecord ){
                   
        list<OpportunityLineItem>  oliList = new list<OpportunityLineItem>();
        
        try{
            System.debug('QQQQQQQQQQQ:::'+selectedOliWrapper);
            for(OpportunityLineItemWrapper oliWrapper :  selectedOliWrapper)
            {
                if(oliWrapper.oli != null){  
                    System.debug('oliWrapper.oli:::'+oliWrapper.oli);
                    oliList.add(oliWrapper.oli);
                }
            }
            
            if(!oliList.isEmpty()){
                upsert oliList;
            }
            
            System.debug('QQQQQQQQQQQ1111:::'+selectedOliWrapper);
            oliList = getOpportunityLineItems(opportunityRecord);
            System.debug('oliList:::'+oliList);
        }
        catch(exception e){
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());    
        }  
        System.debug('oliList111:::'+oliList);
        return oliList;
    }
    
     @AuraEnabled
     public static List <OpportunityLineItemWrapper> getOliLineItems(Opportunity opportunityRecord,String pricebookId, list<OpportunityLineItem> existingOppLineItems)
    {
         List<OpportunityLineItemWrapper> oliWrapper = new List<OpportunityLineItemWrapper>();
        
        Set<Id> oliIds = new Set<Id>();
        
        List<OpportunityLineItem> oliList = [SELECT PricebookEntryId FROM OpportunityLineItem WHERE OpportunityId =: opportunityRecord.Id];
        
        for(OpportunityLineItem oli: oliList)
        {
            oliIds.add(oli.PricebookEntryId);
        }
        
        List<PricebookEntry> priceBookEntryList = [SELECT Id,Name,Product2.Id,Product2.Name,Product2.Family,UnitPrice,CurrencyIsoCode,Product2.QuantityUnitOfMeasure, Product2.Description 
                                                   FROM Pricebookentry 
                              						WHERE PriceBook2.IsStandard=true 
                                                   		AND Pricebook2Id =:pricebookId 
                                                   		 AND CurrencyIsoCode =:opportunityRecord.CurrencyIsoCode
                                                   			AND Id NOT IN : oliIds
                                                  ORDER BY Product2.Name ASC];
            
        system.debug('priceBookEntryList'+priceBookEntryList[0].Product2.Name);
        
        if(priceBookEntryList.size() > 0)
        {
            List<OpportunityLineItemWrapper> convertedList = convertToOliWrapper(priceBookEntryList, opportunityRecord);
            
             system.debug('convertedList: '+convertedList[0].pbe.Product2.Name);
            
            oliWrapper.addall(convertedList);
        }
        
        system.debug('oliWrapper: '+oliWrapper.size());
        return oliWrapper;
    }
    
     @AuraEnabled
    public static list<OpportunityLineItem> saveProducts(list<OpportunityLineItem> oppProduct, Opportunity opportunityRecord ) {
        system.debug('===================>'+oppProduct);
        system.debug('===================>'+opportunityRecord);
        Id priceBookId =  [SELECT Id FROM Pricebook2 WHERE IsStandard=true].Id;
        opportunityRecord.Pricebook2Id = priceBookId;
        update opportunityRecord;
        String currencyCode = [SELECT Id,CurrencyIsoCode FROM Opportunity WHERE Id =: opportunityRecord.Id].CurrencyIsoCode;
        system.debug('===================>'+currencyCode);
        map<Id,list<PricebookEntry>> mappricebookentry =  new map<Id,list<PricebookEntry>>();
        set<Id> prodIds = new set<Id>();
        for(OpportunityLineItem oppline:oppProduct)
        {
            prodIds.add(oppline.Product2Id);
        }
        for(PricebookEntry priceBkenty:[SELECT Id,CurrencyIsoCode,Pricebook2Id,Product2Id FROM PricebookEntry WHERE Product2Id IN:prodIds AND Pricebook2Id =:opportunityRecord.Pricebook2Id AND CurrencyIsoCode =:currencyCode])
        {
            /*mappricebookentry.put(priceBkenty.Pricebook2Id, new map<Id,map<String, Id>>());
            mappricebookentry.get(priceBkenty.Pricebook2Id).put(priceBkenty.Product2Id, new map<String, Id>());
            mappricebookentry.get(priceBkenty.Pricebook2Id).get(priceBkenty.Product2Id).put(priceBkenty.CurrencyIsoCode, priceBkenty.Id);*/
            if(mappricebookentry.get(priceBkenty.Pricebook2Id)==null)
            {
                mappricebookentry.put(priceBkenty.Pricebook2Id, new list<PricebookEntry>());
            }
            mappricebookentry.get(priceBkenty.Pricebook2Id).add(priceBkenty);
        }
        system.debug('===================>'+mappricebookentry);
        system.debug('=====================>'+oppProduct);
        list<OpportunityLineItem> oppLineItems = new list<OpportunityLineItem>();
        for(OpportunityLineItem oppline:oppProduct)
        {
            if(mappricebookentry.containsKey(opportunityRecord.Pricebook2Id))
            {
               for(PricebookEntry pbe:mappricebookentry.get(opportunityRecord.Pricebook2Id))
               {
                   if(pbe.CurrencyIsoCode == currencyCode && pbe.Product2Id == oppline.Product2Id && pbe.Pricebook2Id == opportunityRecord.Pricebook2Id)
                   {
                       oppline.PricebookEntryId = pbe.Id;
                       oppLineItems.add(oppline);
                   }
               }
                        
            }
            
        }
        system.debug('===================>'+oppLineItems);
        insert oppLineItems;
        system.debug('===================>'+oppLineItems);
        return oppProduct;
    }
    
        @AuraEnabled
    public static List<String> getPicklist(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Product2.Family.getDescribe();
        System.debug('fieldResult---->>> ' + fieldResult);
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        System.debug('pList---->>> ' + pList);
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        System.debug('options---->>> ' + options);
        return options;
    }
    
        @AuraEnabled
    public static List<String> getServiceTypePicklist(){
        List<String> options = new List<String>();
        Schema.DescribeFieldResult fieldResult = Product2.Service_Type__c.getDescribe();
        System.debug('fieldResult---->>> ' + fieldResult);
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        System.debug('pList---->>> ' + pList);
        for (Schema.PicklistEntry p: pList) {
            options.add(p.getLabel());
        }
        System.debug('options---->>> ' + options);
        return options;
    }
    
    
    @AuraEnabled
    
      public static List <PricebookEntry> getPricebookEntry(Opportunity opportunityRecord,String pricebookId)
    {
        system.debug('opportunityRecord.'+opportunityRecord.Pricebook2Id);
        List<PricebookEntry> priceBookEntryList;
     
        priceBookEntryList = [SELECT Id,Name,Product2.Id,Product2.Name,Product2.Family,UnitPrice,CurrencyIsoCode,Product2.QuantityUnitOfMeasure FROM Pricebookentry 
                              WHERE PriceBook2.IsStandard=true AND Pricebook2Id =:pricebookId AND CurrencyIsoCode =:opportunityRecord.CurrencyIsoCode limit 10 ];
            
        system.debug('priceBookEntryList'+priceBookEntryList);
        
        return priceBookEntryList;
    }
    
    @AuraEnabled
    public static List<OpportunityLineItem> getOpportunityLineItems(Opportunity opportunityRecord)
    {
        list<OpportunityLineItem> oliList = [SELECT Id, Name,Quantity, Description, UnitPrice, TotalPrice, VAT__c, Cost__c, Exclusions__c,
                                             Product2.Name, PricebookEntry.Name, PricebookEntry.Product2.Family, Product2.QuantityUnitOfMeasure, Product2.Description  
                                            FROM OpportunityLineItem
                                            WHERE OpportunityId =: opportunityRecord.Id
                                            ORDER BY Product2.Name ASC];
        
        return oliList;       
        
    }
    
   
    
    public static List<OpportunityLineItemWrapper> convertToOliWrapper(List<PricebookEntry> priceBookEntryList, Opportunity opp)
    {
        List<OpportunityLineItemWrapper> oliWrapper = new List<OpportunityLineItemWrapper>();
        
        for(PricebookEntry pbe : priceBookEntryList)
        {
            OpportunityLineItem oli = new OpportunityLineItem();
            oli.PricebookEntryId = pbe.Id;
            oli.Quantity = 1;
            oli.VAT__c = false;
            oli.UnitPrice = 0.00;
            oli.Product2Id = pbe.Product2Id;
            oli.OpportunityId = opp.Id;
            
            OpportunityLineItemWrapper oliw = new OpportunityLineItemWrapper();
            oliw.opp = opp;
            oliw.oli = oli;
            oliw.isSelected = false;
            oliw.pbe = pbe;
            
            oliWrapper.add(oliw);            
        }
        
        return oliWrapper;
        
    }
    
    
   
     @AuraEnabled
  public static Opportunity updateOpportunityPricebook(Opportunity opportunityDetails){
      
      
      system.debug('test');
    
    update opportunityDetails ;
      return opportunityDetails;
}
    
    public class OpportunityLineItemWrapper{
         @AuraEnabled
        public Opportunity opp {get;set;}
         @AuraEnabled
        public Boolean isSelected {get;set;}
         @AuraEnabled
        public PricebookEntry pbe {get;set;}
         @AuraEnabled
        public OpportunityLineItem oli {get;set;}
        
        
        public OpportunityLineItemWrapper()
        {
            
        }
        
    }
    
    
    
}