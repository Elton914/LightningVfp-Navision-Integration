@isTest(SeeAllData=True) 
private class ProductWizardController_Test{
    
  /*  @isTest
    private static void testGenerateProposalPass(){
        Opportunity opp = generateOpportunity();
        
        
        Test.startTest();
        
        System.assertEquals(false, ProductWizardController.getProducts(opp).isEmpty());
        Test.stopTest();
        
    }
*/
    
    
    @isTest
    private static void testfetchPriceBook(){
        Opportunity opp = generateOpportunity();
        
        
        Test.startTest();
        
        System.assertEquals(false, ProductWizardController.fetchPriceBook().isEmpty());
        Test.stopTest();
        
        
    }
    
    @isTest
    private static void testsearchServiceTypeProducts(){
        Opportunity opp = generateOpportunity();
        
        
        Test.startTest();
        
        System.assertEquals(1,  ProductWizardController.searchServiceTypeProducts('test',  opp,  'test','Import').size());
        Test.stopTest();
        
        
    }
    
    
    @isTest
    private static void testfilterProductsServiceLine(){
        Opportunity opp = generateOpportunity();
        
        
        Test.startTest();
        
        System.assertEquals(1,  ProductWizardController.filterProductsServiceLine( opp,  'test','Import').size());
        Test.stopTest();
        
        
    }
    
    @isTest
    private static void testsaveOpportunityLineItems(){
        Opportunity opp = generateOpportunity();
        
        
        Product2 prod = new Product2();
        prod.Name = 'test Prod';
        prod.IsActive = true;
        prod.Family = 'test';
        prod.CurrencyIsoCode = 'USD';
        prod.Service_Type__c = 'Import';
        insert prod;
        
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id =  Test.getStandardPricebookId();
        pbe.Product2Id = prod.Id;
        pbe.IsActive= true;
        pbe.CurrencyIsoCode = 'USD';
        pbe.UnitPrice =1;
        
        insert pbe;
        
        
        Test.startTest();
        
        System.assertEquals(2,  ProductWizardController.saveOpportunityLineItems(ProductWizardController.convertToOliWrapper(new List<PricebookEntry>{pbe}, opp),  opp ).size());
        Test.stopTest();
        
        
    } 
    
    
    @isTest
    private static void testgetOliLineItemss(){
        Opportunity opp = generateOpportunity();
        Test.startTest();
        System.assert(ProductWizardController.getOliLineItems(opp, String.valueOf(Test.getStandardPricebookId()), new List<OpportunityLineItem>{createOpportunityProduct(opp.Id)}).size()> 1);
        Test.stopTest();
    }
    
    
    @isTest
    private static void testgetPricebookEntry(){
        Opportunity opp = generateOpportunity();
        Test.startTest();
        System.assert(ProductWizardController.getPricebookEntry(opp, String.valueOf(Test.getStandardPricebookId())).size()> 1);
        Test.stopTest();
    }
    
    
    @isTest
    private static void testgetServiceTypePicklist(){
        Opportunity opp = generateOpportunity();
        Test.startTest();
        
        System.assert( ProductWizardController.getServiceTypePicklist().size()> 1);
        
        Test.stopTest();
    }
    
    
    @isTest
    private static void testsaveProducts(){
        Opportunity opp = generateOpportunity();
        Test.startTest();
        
        System.assertEquals(1,  ProductWizardController.saveProducts( new List<OpportunityLineItem>{createOpportunityProduct(opp.Id)}, opp).size());
        
        Test.stopTest();
    }
    
    
    static private Account generateAccount()
    {
        Account drAccount=new Account();
        drAccount.Name = 'New Account';
        drAccount.BillingCity = 'Nairobi';
        drAccount.BillingCountry = 'Kenya';
        drAccount.BillingState = 'Nairobi';
        drAccount.billingStreet = 'Kena';
        drAccount.Phone = '+254711455555';
        drAccount.Tax_Identification_Number__c = '123123123';
        drAccount.BillingPostalCode = '11111';
        drAccount.Navision_Customer_ID__c = '123123';
        
        insert drAccount;
        
        return drAccount;
    }
    
    
    static private Opportunity generateOpportunity()
    {
        
        Opportunity opportunity_Obj = new Opportunity(AccountId =generateAccount().Id, currencyIsoCode = 'USD' ,Pricebook2Id =  Test.getStandardPricebookId(), Name = 'Transport', StageName = 'Prospecting', CloseDate = Date.ValueOf('2021-08-30 00:00:00'), Budget_Confirmed__c = false, Discovery_Completed__c = false, ROI_Analysis_Completed__c = false, Transit__c = false, Packing_List__c = false, Air_Freight_Export__c = false, Air_Freight_Import__c = false, Abnormal_Cargo__c = false, Sea_Road_and_Rail_Export__c = false, Sea_Road_and_Rail_Import__c = false, Warehousing__c = true, Terminals__c = false, Import_Phytosanitary_Certificate__c = false, Import_Kephis_Permit__c = false, Import_Health_Certificate__c = false, Import_Commercial_Invoice__c = false, Import_Airway_Bill__c = false, Import_Animal_Attestation__c = false, Import_Public_Health_Attestation__c = false, Import_Veterinary_Health_Certificate__c = false, Import_Packing_List__c = false, Import_Certificate_of_Conformity__c = false, Import_Declaration_Form__c = false, Import_Certificate_of_Analysis__c = false, Import_Material_Data_Sheet__c = false, Import_Exemption_Letter__c = false, Import_Radioactive_Certificate__c = false, Export_Phytosanitary_Certificate__c = false, Export_Kephis_Permit__c = false, Export_Port_Health_Certificate__c = false, Export_Commercial_Invoice__c = false, Export_Airway_Bill__c = false, Export_Animal_Attestation__c = false, Export_Public_Health_Attestation__c = false, Export_Veterinary_Health_Certificate__c = false, Export_Packing_List__c = false, Terminals_Original_Bill_of_Lading__c = false, Terminals_Original_Suppliers_Invoice__c = false, Terminals_Packing_List__c = false, Terminals_IDF_Import_License__c = false, Terminals_Certificate_of_Conformity__c = false, Terminals_Customs_Form_C52__c = false, Terminals_Marine_Insurance_Form__c = false, Terminals_Certificate_of_Origin__c = false, Terminals_Catalogue__c = false, Terminals_Form_CB_13__c = false, Terminals_C60_C56__c = false, Terminals_Original_ID_Passport_Card__c = false, Terminals_Copy_of_PIN_Certicate__c = false, Terminals_Original_Logbook__c = false, Terminals_Certificate_of_Roadworthiness__c = false, Abnormal_Cargo_Manifest__c = false, Proposal_Approved__c = false, Opportunity_Checklist_Approved__c = false, Sea_Road_Rail_Commercial_Invoice__c = false, Sea_Road_Rail_Export_Packing_List__c = false, Sea_Road_Rail_Export_Cert_of_Origin__c = false, Sea_Road_Rail_Cert_of_Origin__c = false, Sea_Road_Rail_Export_Fumigation_Cert__c = false, Sea_Road_Rail_Export_Phytosnitary_Cert__c = false, Sea_Road_Rail_Import_Packing_List__c = false, Sea_Road_Rail_Import_Commercial_Invoice__c = false, Sea_Road_Rail_Import_IDF_and_Receipt__c = false, Sea_Road_Rail_Import_Cert_of_Conformity__c = false, Sea_Road_Rail_Import_Cert_of_Origin__c = false, Sea_Road_Rail_Import_Fumigaton_Cert__c = false, Sea_Road_Rail_Import_COMESA_cert__c = false, Sea_Road_Rail_Import_KEBS_Mark__c = false, Bill_of_Lading__c = false, Warehousing_Packing_List__c = false, ICO_Certificate_of_Origin__c = false, Coffee_Commercial_Invoice__c = false, Coffee_Weight_Note__c = false, Cofffee_Quality_Certificate__c = false, Transhipment__c = false, SOP_Sent__c = false, Consolidation__c = false, ACT__c = false, Is_Quote_All_Inclusive__c = false, Price_Updated__c = false);
        
        insert opportunity_Obj;
        
        createOpportunityProduct(opportunity_Obj.Id);
        
        createProposal(opportunity_Obj.Id);
        createSOP(opportunity_Obj.Id);
        Quote  quote = createQuote(opportunity_Obj.Id);
        createContract(opportunity_Obj.Id, opportunity_Obj.AccountId); 
        createRemark(opportunity_Obj.Id, quote.Id);
        return opportunity_Obj;
        
    }
    
    static private OpportunityLineItem createOpportunityProduct(Id oppId)
    {
        Product2 prod = new Product2();
        prod.Name = 'test Prod';
        prod.IsActive = true;
        prod.Family = 'test';
        prod.CurrencyIsoCode = 'USD';
        prod.Service_Type__c = 'Import';
        insert prod;
        
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id =  Test.getStandardPricebookId();
        pbe.Product2Id = prod.Id;
        pbe.IsActive= true;
        pbe.CurrencyIsoCode = 'USD';
        pbe.UnitPrice =1;
        
        insert pbe;
        
        
        OpportunityLineItem opportunitylineitem_Obj = new OpportunityLineItem(OpportunityId = oppId, Quantity = 1.00, VAT__c = false, 	UnitPrice = 0.00, PricebookEntryId= pbe.Id);
        Insert opportunitylineitem_Obj; 
        
        return opportunitylineitem_Obj;
    }
    
    
    static private Proposal__c createProposal(Id oppId)
    {
        Proposal__c proposal_Obj = new Proposal__c(Opportunity__c = oppId,Description__c = 'Test Proposal',Salutation__c = 'Dear Sir');
        Insert proposal_Obj; 
        return proposal_Obj;
    }
    
    static private SOP__c createSOP(Id oppId)
    {
        SOP__c sop_Obj = new SOP__c(Opportunity__c =oppId,Description__c = 'Test SOP');
        Insert sop_Obj; 
        return sop_Obj;
    }
    
    static private Quote createQuote(Id oppId)
    {
        Quote quote_Obj = new Quote(Name = 'test quote',OpportunityId = oppId,	Quote_Description__c = 'Test Quote');
        Insert quote_Obj; 
        return quote_Obj;
    }
    
    static private Contract createContract(Id oppId, Id accid)
    {
        Contract contract_Obj = new Contract(AccountId =accid ,Opportunity__c = oppId,Contract_Details__c = 'Test Contract');
        Insert contract_Obj; 
        return contract_Obj;
    }
    
    static private Remark__c createRemark(Id oppId, Id quoteid)
    {
        Remark__c remark_Obj = new Remark__c(Name = 'remark',Opportunity__c = oppId,Remarks__c = 'Test Remarks',Quote__c =quoteid );
        
        Insert  remark_Obj; 
        return remark_Obj;
    }
    
}