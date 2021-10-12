@isTest(SeeAllData=True) 
private class GenerateProposalController_Test {
    
    
    @isTest
    private static void testGenerateProposalPass(){
        
        Test.startTest();
        
        System.assertEquals(false, generateProposalController.fetchPickValue('Type__c', 'Template__c').isEmpty());
        Test.stopTest();
        
        
    }
    
    @isTest
    private static void testGenerateProposalPFail(){
        
        
        Test.startTest();
        Exception expectedException;
        
        try
        {
            
            generateProposalController.fetchPickValue('Types__c', 'Templates__c');
            
        }
        catch (Exception d)
        {
            expectedException = d;
        }
        Test.stopTest();
        
        system.assertNotEquals(null, expectedException, 'InvoiceNo field cannot be blank');
        
        
    }
    
    
    @isTest
    private static void testsubmitforDiscountApproval(){
        
        Opportunity opp = generateOpportunity();
        
        opp.Stagename = 'Proposal Approved';
        opp.Price_Updated__c = true;
        
        update opp;
        
        Test.startTest();
        
        System.assertEquals('success', generateProposalController.submitforDiscountApproval(opp.Id));
        
        Test.stopTest();
    }
    @isTest
    private static void testUpdateOpportunityFail(){
        
        
        Test.startTest();
        Exception expectedException;
        
        try
        {
            
            generateProposalController.updateOpportunity(new opportunity());
            
        }
        catch (Exception d)
        {
            expectedException = d;
        }
        Test.stopTest();
        
        system.assertNotEquals(null, expectedException, 'InvoiceNo field cannot be blank');
        
        
    }
    
    @isTest
    private static void testSaveQuoteLineItemFail(){
        Opportunity opp = generateOpportunity();
        
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>{createOpportunityProduct(opp.Id)};
            Quote q = createQuote(opp.id);
        
        
        
        Test.startTest();
        Exception expectedException;
        
        try
        {
            
            generateProposalController.saveQuoteLineItem(oppLineItems, '');
            
        }
        catch (Exception d)
        {
            expectedException = d;
        }
        Test.stopTest();
        
        system.assertNotEquals(null, expectedException, 'InvoiceNo field cannot be blank');
        
        
    }
    
    
    
    @isTest
    private static void testSaveQuoteLineItem(){
        
        Opportunity opp = generateOpportunity();
        
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>{createOpportunityProduct(opp.Id)};
            Quote q = createQuote(opp.id);
        
        Test.startTest();
        
        System.assertEquals(1, generateProposalController.saveQuoteLineItem(oppLineItems, q.Id).size());
        
        Test.stopTest();
    }
    
    
    @isTest
    private static void testSaveAttachmentDoc(){
        
        Opportunity opp = generateOpportunity();
        
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>{createOpportunityProduct(opp.Id)};
            Quote q = createQuote(opp.id);
        
        Test.startTest();
        
        System.assertEquals(1, generateProposalController.saveAttachmentDoc(q.Id, 'pdf', opp.Id, 'Proposal', 'letterheadOp').size());
        System.assertEquals(1, generateProposalController.saveAttachmentDoc(q.Id, 'pdf', opp.Id, 'SOP', 'letterheadOp').size());
        System.assertEquals(1, generateProposalController.saveAttachmentDoc(q.Id, 'pdf', opp.Id, 'Quote', 'letterheadOp').size());
        System.assertEquals(1, generateProposalController.saveAttachmentDoc(q.Id, 'pdf', opp.Id, 'Contract', 'letterheadOp').size());
        
        Test.stopTest();
    }
    
    @isTest
    private static void testMiscelleniousFunctions(){
        
        Opportunity opp = generateOpportunity();
        
        System.assertEquals(opp.Id, generateProposalController.getOpportunityDetails(opp.Id).Id);
        System.assertEquals(1, generateProposalController.getProductFamily(opp.Id).size());
        System.assertEquals(opp.Id, generateProposalController.updateOpportunity(opp).Id);
        System.assertEquals(1, generateProposalController.getAccountID(opp.Id).size());
        
        System.assertEquals(0, generateProposalController.getTemplates('test').size());
        System.assert(generateProposalController.getRemarks().size() > 0);
        System.assertEquals(opp.Id, generateProposalController.updateOpportunity(opp).Id);
        
        
        Quote  quote = createQuote(opp.Id);
        
        Proposal__c proposal_Obj = new Proposal__c(Opportunity__c = opp.Id,Description__c = 'Test Proposal',Salutation__c = 'Dear Sir');
        
        generateProposalController.saveProposal( new List<Proposal__c>{proposal_Obj});
      
        System.assertEquals(1, generateProposalController.saveRemarks( new List<Remark__c>{createRemark(opp.Id, quote.Id)}).size());
        
        
        opp.Stagename = 'Proposal Approved';
        opp.Price_Updated__c = true;
        
        update opp;
        
        Test.startTest();
        
        System.assertEquals('success', generateProposalController.submitforDiscountApproval(opp.Id));
        
        Test.stopTest();
    }
    
    
    @isTest
    private static void testsendMailMethod(){
        
        Opportunity opp = generateOpportunity();
        
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>{createOpportunityProduct(opp.Id)};
            Quote q = createQuote(opp.id);
        
        Test.startTest();
        List<Attachment> attachments =  generateProposalController.saveAttachmentDoc(q.Id, 'SOP', opp.Id, 'Proposal', 'letterheadOp');
        
        generateProposalController.sendMailMethod('bckdemo@gmail.com', 'subject', 'body', attachments, 'bckdemocc@gmail.com');
        generateProposalController.sendMailMethod('bckdemo@gmail.com;bckdemo2@gmail.com', 'subject', 'body', attachments, 'bckdemocc@gmail.com');
        
        Test.stopTest();
    }
    
    @isTest
    private static void testsCreateProposal_Fail(){
         
        
        Opportunity opp = generateOpportunity();
        
        Exception expectedException;
        
        Test.startTest();
        try
        {
            
           generateProposalController.saveProposal( new List<Proposal__c>{createProposal(opp.Id)});
      
        }
        catch (Exception d)
        {
            expectedException = d;
        }
        Test.stopTest();
        
        system.assertEquals('Script-thrown exception', expectedException.getMessage(), 'System.AuraHandledException: Script-thrown exception');
        
    }
    
    @isTest
    private static void testssaveDocumentDetails_Fail(){
        
        
        Exception expectedException;
        
        Test.startTest();
        try
        {
            
            generateProposalController.saveDocumentDetails( new List<sObject>());
            
        }
        catch (Exception d)
        {
            expectedException = d;
        }
        Test.stopTest();
        
        system.assertEquals(null, expectedException, 'sdf');
        
    }
    
    
    
    @isTest
    private static void tessaveDocumentDetails_Pass(){
        
        List<sObject> docDetailsList = new List<sObject>();
        sObject docDetails = Schema.getGlobalDescribe().get('Proposal__c').newSObject() ;
        
        
        docDetailsList.add(docDetails);
        
        Test.startTest();
        
        system.assertEquals(1, generateProposalController.saveDocumentDetails(docDetailsList).size());
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
        
        Opportunity opportunity_Obj = new Opportunity(AccountId =generateAccount().Id, Name = 'Transport', StageName = 'Prospecting', CloseDate = Date.ValueOf('2021-08-30 00:00:00'), Budget_Confirmed__c = false, Discovery_Completed__c = false, ROI_Analysis_Completed__c = false, Transit__c = false, Packing_List__c = false, Air_Freight_Export__c = false, Air_Freight_Import__c = false, Abnormal_Cargo__c = false, Sea_Road_and_Rail_Export__c = false, Sea_Road_and_Rail_Import__c = false, Warehousing__c = true, Terminals__c = false, Import_Phytosanitary_Certificate__c = false, Import_Kephis_Permit__c = false, Import_Health_Certificate__c = false, Import_Commercial_Invoice__c = false, Import_Airway_Bill__c = false, Import_Animal_Attestation__c = false, Import_Public_Health_Attestation__c = false, Import_Veterinary_Health_Certificate__c = false, Import_Packing_List__c = false, Import_Certificate_of_Conformity__c = false, Import_Declaration_Form__c = false, Import_Certificate_of_Analysis__c = false, Import_Material_Data_Sheet__c = false, Import_Exemption_Letter__c = false, Import_Radioactive_Certificate__c = false, Export_Phytosanitary_Certificate__c = false, Export_Kephis_Permit__c = false, Export_Port_Health_Certificate__c = false, Export_Commercial_Invoice__c = false, Export_Airway_Bill__c = false, Export_Animal_Attestation__c = false, Export_Public_Health_Attestation__c = false, Export_Veterinary_Health_Certificate__c = false, Export_Packing_List__c = false, Terminals_Original_Bill_of_Lading__c = false, Terminals_Original_Suppliers_Invoice__c = false, Terminals_Packing_List__c = false, Terminals_IDF_Import_License__c = false, Terminals_Certificate_of_Conformity__c = false, Terminals_Customs_Form_C52__c = false, Terminals_Marine_Insurance_Form__c = false, Terminals_Certificate_of_Origin__c = false, Terminals_Catalogue__c = false, Terminals_Form_CB_13__c = false, Terminals_C60_C56__c = false, Terminals_Original_ID_Passport_Card__c = false, Terminals_Copy_of_PIN_Certicate__c = false, Terminals_Original_Logbook__c = false, Terminals_Certificate_of_Roadworthiness__c = false, Abnormal_Cargo_Manifest__c = false, Proposal_Approved__c = false, Opportunity_Checklist_Approved__c = false, Sea_Road_Rail_Commercial_Invoice__c = false, Sea_Road_Rail_Export_Packing_List__c = false, Sea_Road_Rail_Export_Cert_of_Origin__c = false, Sea_Road_Rail_Cert_of_Origin__c = false, Sea_Road_Rail_Export_Fumigation_Cert__c = false, Sea_Road_Rail_Export_Phytosnitary_Cert__c = false, Sea_Road_Rail_Import_Packing_List__c = false, Sea_Road_Rail_Import_Commercial_Invoice__c = false, Sea_Road_Rail_Import_IDF_and_Receipt__c = false, Sea_Road_Rail_Import_Cert_of_Conformity__c = false, Sea_Road_Rail_Import_Cert_of_Origin__c = false, Sea_Road_Rail_Import_Fumigaton_Cert__c = false, Sea_Road_Rail_Import_COMESA_cert__c = false, Sea_Road_Rail_Import_KEBS_Mark__c = false, Bill_of_Lading__c = false, Warehousing_Packing_List__c = false, ICO_Certificate_of_Origin__c = false, Coffee_Commercial_Invoice__c = false, Coffee_Weight_Note__c = false, Cofffee_Quality_Certificate__c = false, Transhipment__c = false, SOP_Sent__c = false, Consolidation__c = false, ACT__c = false, Is_Quote_All_Inclusive__c = false, Price_Updated__c = false);
        
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
        insert prod;
        
        
        PricebookEntry pbe = new PricebookEntry();
        pbe.Pricebook2Id =  Test.getStandardPricebookId();
        pbe.Product2Id = prod.Id;
        pbe.IsActive= true;
        pbe.UnitPrice =1;
        
        insert pbe;
        
        
        OpportunityLineItem opportunitylineitem_Obj = new OpportunityLineItem(OpportunityId = oppId, Quantity = 1.00, VAT__c = false,   UnitPrice = 0.00, PricebookEntryId= pbe.Id);
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
        Quote quote_Obj = new Quote(Name = 'test quote',OpportunityId = oppId,  Quote_Description__c = 'Test Quote');
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
        Template__c template = new Template__c();
        template.Salutation__c = 'test';
        template.Name = 'test';
        template.Salutation__c = 'test';
        template.Family__c = 'Airfreight';
        template.Salutation__c = 'Proposal';
        template.Type__c = 'Proposal';
        template.Content__c = 'test';
        
        insert template;
        
        Remark__c remark_Obj = new Remark__c(Name = 'remark',Opportunity__c = oppId,Remarks__c = 'Test Remarks',Quote__c =quoteid );
        
        Insert  remark_Obj; 
        return remark_Obj;
        
    
        
        
    }
    
    
}