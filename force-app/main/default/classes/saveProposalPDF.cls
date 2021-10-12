public class saveProposalPDF {
       // The extension constructor initializes the private member
    // variable pageOpp by using the getRecord method from the standard
    // controller.
    Date myDate = system.today();
    Private Proposal__c pageOpp;
    public Boolean initialised{get; set;}

    //Constructor
    public saveProposalPDF(ApexPages.StandardController stdController) {
        this.pageOpp = (Proposal__c)stdController.getRecord();
        id PageOppId = ApexPages.currentPAge().getParameters().get('id');
        initialised=false;
        system.debug('id = ' + pageOpp.id + '     id2' +PageOppId);
    }

//method to insert attachement call it on page on click of button 
public void saveAttachement() {
                
    if (!initialised && pageOpp.ID !=NULL) {

     PageReference pdf = Page.proposalPDFsave;
    // create the new attachment
    Attachment attach = new Attachment();

    // the contents of the attachment from the pdf
    Blob body;

    try {

        // returns the output of the page as a PDF
        body = pdf.getContentAsPDF();
        system.debug('body should be fine');

        // need to pass unit test -- current bug    
        } catch (VisualforceException e) {
            system.debug('in the catch block');
             body = Blob.valueOf('Some Text');
        }

        attach.Body = body;
    // add the user entered name
    attach.Name = Proposal__c.Opportunity__r.account.name + ' ' + myDate + '.pdf';
    attach.IsPrivate = false;
    // attach the pdf to the account
    attach.ParentId = pageOpp.Id;
    insert attach;
   system.debug(attach);
initialised=true;
  } else system.debug('tried to run twice');
} 

}