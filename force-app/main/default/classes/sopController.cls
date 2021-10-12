public class sopController {
   public String letterhead{ get; set; }
    
    public sopController(ApexPages.StandardController controller ) {
   letterhead= ApexPages.currentPage().getParameters().get('letterHeadValue');
   system.debug(ApexPages.currentPage().getParameters().get('letterHeadValue'));
    }
}