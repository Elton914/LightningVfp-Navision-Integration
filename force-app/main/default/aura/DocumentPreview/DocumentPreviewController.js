({
    
    doInit : function(component, event, helper){
        component.set("v.isSpinner",true);
        helper.fetchProposals(component);
        helper.fetchSOPS(component);
        helper.fetchContracts(component);
        helper.fetchEmailcontact(component);
    },
    
    previewProposaldownload : function (component, event, helper) {
        var recordId =   event.getSource().get("v.name");
        component.set("v.documentURL","/apex/proposalPDF?id="+recordId);
        component.set("v.documentHeader",'Preview Proposal');
        component.set("v.showDocument",true);
        
    },
    
    sendproposal : function (component, event, helper) {
         var ctarget = event.currentTarget;
        
        var VfPage = ctarget.dataset.vfpage;
         var attId = ctarget.dataset.attid;
          var attName = ctarget.dataset.attname;
           var recordId =   ctarget.dataset.name;
        console.log('VfPage --'+VfPage);
        console.log('recordId --'+recordId);
        console.log('attId --'+attId);
        console.log('attName --'+attName);
        	  component.set("v.VfPage",VfPage);
          component.set("v.attId",attId);
          component.set("v.attName",attName);
          component.set("v.recordId",recordId);
          component.set("v.documentHeader",'Email Document to Customer');
        component.set("v.showSendEmail",true); 
    },
    
    
    
    sendContract: function (component, event, helper) {
          var ctarget = event.currentTarget;
        var VfPage = ctarget.dataset.vfpage;
         var attId = ctarget.dataset.attid;
          var attName = ctarget.dataset.attname;
           var recordId =   ctarget.dataset.name;
        	  component.set("v.VfPage",VfPage);
          component.set("v.attId",attId);
          component.set("v.attName",attName);
          component.set("v.recordId",recordId);
          component.set("v.documentHeader",'Email Document to Customer');
        component.set("v.showSendEmail",true); 
    },
    
    
    previewContractdownload : function (component, event, helper) {
        console.log(1);
        var recordId =   event.getSource().get("v.name");
        component.set("v.documentURL","/apex/contractPDF?id="+recordId);
        component.set("v.documentHeader",'Send Contract');
        component.set("v.showDocument",true);
            console.log(2);
    },
    
    
    previewSOPdownload : function (component, event, helper) {
        var recordId =   event.getSource().get("v.name");
        component.set("v.documentURL","/apex/sopPDF?id="+recordId);
        component.set("v.documentHeader",'Preview SOP');
        component.set("v.showDocument",true);
    },
    
    sendSOP : function (component, event, helper) {
       var ctarget = event.currentTarget;
        
        var VfPage = ctarget.dataset.vfpage;
         var attId = ctarget.dataset.attid;
          var attName = ctarget.dataset.attname;
           var recordId =   ctarget.dataset.name;
        	  component.set("v.VfPage",VfPage);
          component.set("v.attId",attId);
          component.set("v.attName",attName);
          component.set("v.recordId",recordId);
          component.set("v.documentHeader",'Email Document to Customer');
        component.set("v.showSendEmail",true); 
    },
    
    
    
    closeModal: function(component, event, helper) {
        component.set("v.showDocument",false);
           component.set("v.showSendEmail",false); 
        component.set("v.isSpinner",false);
         
    },
    
    
     sendEmail : function(component, event, helper)
    {
        component.set("v.isSpinner",true); 
      helper.sendEmail(component);
    },
    
})