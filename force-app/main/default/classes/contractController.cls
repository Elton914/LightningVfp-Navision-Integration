public class contractController {

    public String letterhead{ get; set; }
    
    public contractController(ApexPages.StandardController controller ) {
   letterhead= ApexPages.currentPage().getParameters().get('letterHeadValue');
   system.debug(ApexPages.currentPage().getParameters().get('letterHeadValue'));
    }
}