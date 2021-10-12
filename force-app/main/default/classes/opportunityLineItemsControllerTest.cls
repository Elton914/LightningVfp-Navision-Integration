@isTest
public class opportunityLineItemsControllerTest {
       static testMethod void test_opportunityLineItemsController(){
         test.startTest();
    Account account_obj = new Account( Name = 'Test', Galaxy_Customer_Type__c ='Airline' ,AWB_Prefix__c = '157',Galaxy_Customer_Category__c = 'Cash',IATA_Code__c = '1234567',Carrier_Code__c = 'KQ',BillingCity='Nairobi',BillingCountry='Kenya',BillingPostalCode='00100',BillingState='Kenya',BillingStreet='Moi',Phone='+254711999555');
      Insert account_obj;
      Opportunity opportunity_Obj = new Opportunity( AccountId = account_obj.Id, Name = 'Name734', Galaxy_Customer_Type__c ='Airline' ,AWB_Prefix__c = '157',Galaxy_Customer_Category__c = 'Cash',IATA_Code__c = '1234567',Carrier_Code__c = 'KQ', Description = '6', StageName = 'Negotiation and Agreement', Amount = 8, Probability = 40, CloseDate = Date.today(), Type = 'Existing Business', NextStep = 'NextStep686', LeadSource = 'Clearing agent', ForecastCategoryName = 'Omitted', CurrencyIsoCode = 'USD',  Pricebook2Id = Test.getStandardPricebookId(), Budget_Confirmed__c = false, Discovery_Completed__c = false, ROI_Analysis_Completed__c = false, Transit__c = false, Packing_List__c = false, Air_Freight_Export__c = false, Air_Freight_Import__c = false, Abnormal_Cargo__c = false, Sea_Road_and_Rail_Export__c = false, Sea_Road_and_Rail_Import__c = false, Warehousing__c = false, Terminals__c = false, Import_Phytosanitary_Certificate__c = false, Import_Kephis_Permit__c = false, Import_Health_Certificate__c = false, Import_Commercial_Invoice__c = false, Import_Airway_Bill__c = false, Import_Animal_Attestation__c = false, Import_Public_Health_Attestation__c = false, Import_Veterinary_Health_Certificate__c = false, Import_Packing_List__c = false, Import_Certificate_of_Conformity__c = false, Import_Declaration_Form__c = false, Import_Certificate_of_Analysis__c = false, Import_Material_Data_Sheet__c = false, Import_Exemption_Letter__c = false, Import_Radioactive_Certificate__c = false, Export_Phytosanitary_Certificate__c = false, Export_Kephis_Permit__c = false, Export_Port_Health_Certificate__c = false, Export_Commercial_Invoice__c = false, Export_Airway_Bill__c = false, Export_Animal_Attestation__c = false, Export_Public_Health_Attestation__c = false, Export_Veterinary_Health_Certificate__c = false, Export_Packing_List__c = false, Terminals_Original_Bill_of_Lading__c = false, Terminals_Original_Suppliers_Invoice__c = false, Terminals_Packing_List__c = false, Terminals_IDF_Import_License__c = false, Terminals_Certificate_of_Conformity__c = false, Terminals_Customs_Form_C52__c = false, Terminals_Marine_Insurance_Form__c = false, Terminals_Certificate_of_Origin__c = false, Terminals_Catalogue__c = false, Terminals_Form_CB_13__c = false, Terminals_C60_C56__c = false, Terminals_Original_ID_Passport_Card__c = false, Terminals_Copy_of_PIN_Certicate__c = false, Terminals_Original_Logbook__c = false, Terminals_Certificate_of_Roadworthiness__c = false, Abnormal_Cargo_Manifest__c = false, Proposal_Approved__c = false, Opportunity_Checklist_Approved__c = false, Sea_Road_Rail_Commercial_Invoice__c = false, Sea_Road_Rail_Export_Packing_List__c = false, Sea_Road_Rail_Export_Cert_of_Origin__c = false, Sea_Road_Rail_Cert_of_Origin__c = false, Sea_Road_Rail_Export_Fumigation_Cert__c = false, Sea_Road_Rail_Export_Phytosnitary_Cert__c = false, Sea_Road_Rail_Import_Packing_List__c = false, Sea_Road_Rail_Import_Commercial_Invoice__c = false, Sea_Road_Rail_Import_IDF_and_Receipt__c = false, Sea_Road_Rail_Import_Cert_of_Conformity__c = false, Sea_Road_Rail_Import_Cert_of_Origin__c = false, Sea_Road_Rail_Import_Fumigaton_Cert__c = false, Sea_Road_Rail_Import_COMESA_cert__c = false, Sea_Road_Rail_Import_KEBS_Mark__c = false, Bill_of_Lading__c = false, Warehousing_Packing_List__c = false, ICO_Certificate_of_Origin__c = false, Coffee_Commercial_Invoice__c = false, Coffee_Weight_Note__c = false, Cofffee_Quality_Certificate__c = false, Transhipment__c = false, SOP_Sent__c = false, Consolidation__c = false, ACT__c = false, Is_Quote_All_Inclusive__c = false, Price_Updated__c = false);
      Insert opportunity_Obj; 
     opportunity_Obj.Price_Updated__c = true;
        update opportunity_Obj;
        Product2 prod = new Product2( Name = 'test Prod',IsActive = true, Family = 'test' );
        insert prod;
       PricebookEntry pbe = new PricebookEntry(Pricebook2Id =  Test.getStandardPricebookId(),Product2Id = prod.Id,IsActive= true,UnitPrice =1);
        insert pbe;  
        OpportunityLineItem opportunitylineitem_Obj = new OpportunityLineItem(OpportunityId = opportunity_Obj.id, Quantity = 1.00, VAT__c = false,  UnitPrice = 0.00, PricebookEntryId =pbe.Id);
        Insert opportunitylineitem_Obj; 
      string oppId =  opportunity_Obj.Id;
        Proposal__c proposal_Obj = new Proposal__c( Opportunity__c = opportunity_Obj.id,Description__c = 'Test Proposal',Salutation__c = 'Dear Sir');
        Insert proposal_Obj; 
        SOP__c sop_Obj = new SOP__c(Opportunity__c = opportunity_Obj.id,Description__c = 'Test SOP');
        Insert sop_Obj; 
        Quote quote_Obj = new Quote(Name = 'test quote',    OpportunityId = opportunity_Obj.id, Quote_Description__c = 'Test Quote');
        Insert quote_Obj; 
        Contract contract_Obj = new Contract(AccountId = account_obj.Id ,Opportunity__c = opportunity_Obj.id,Contract_Details__c = 'Test Contract');
        Insert contract_Obj; 
        Remark__c remark_Obj = new Remark__c(Name = 'remark',Opportunity__c = opportunity_Obj.id,Remarks__c = 'Test Remarks',Quote__c = quote_Obj.Id );
         
        Insert  remark_Obj; 
         PageReference pageRef = Page.proposalPDF;
         Test.setCurrentPage(pageRef);
         pageRef.getParameters().put('Id', String.valueOf(proposal_Obj.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(proposal_Obj);
 
     opportunityLineItemsController proposal = new opportunityLineItemsController(sc);
       


    test.stopTest();
}

}