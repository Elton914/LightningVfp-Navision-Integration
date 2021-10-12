@isTest
private class saveProposalPDF_Test{
  @testSetup
  static void setupTestData(){
    test.startTest();
    Proposal__c proposal_Obj = new Proposal__c();
    Insert proposal_Obj; 
    test.stopTest();
  }
  static testMethod void test_saveAttachement_UseCase1(){
    List<Proposal__c> proposal_Obj  =  [SELECT Id, Name from Proposal__c];
    System.assertEquals(true,proposal_Obj.size()>0);
    PageReference pageRef = Page.proposalpdfSave;
    pageRef.getParameters().put('id',proposal_Obj[0].Id);
    Test.setCurrentPage(pageRef);
    saveProposalPDF obj01 = new saveProposalPDF(new ApexPages.StandardController(proposal_Obj[0]));
    obj01.initialised = false;
    obj01.saveAttachement();
  }
    
}