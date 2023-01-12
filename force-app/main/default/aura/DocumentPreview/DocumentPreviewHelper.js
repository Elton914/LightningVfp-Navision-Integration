({
    
	 fetchEmailcontact  : function(component)
    {
        component.set("v.email",null);
         var action = component.get("c.fetchEmailcontact");
         action.setParams({
                oppId: component.get("v.recordId")
        });
        action.setCallback(this, function(resp) {
            
            if (resp.getState() === "SUCCESS") {
                
                var defaultEmail = resp.getReturnValue();
               
                component.set("v.email",defaultEmail);
                 
            }
            else if(resp.getState() === "Error") 
            {
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message) 
                    }
                }
                else { 
                    
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    fetchProposals  : function(component)
    {
        component.set("v.proposals",null);
         var action = component.get("c.fetchProposals");
         action.setParams({
                oppId: component.get("v.recordId")
        });
        action.setCallback(this, function(resp) {
            
            if (resp.getState() === "SUCCESS") {
                
                var proposals = resp.getReturnValue();
                console.log('proposals ='+proposals);
                console.dir(proposals);
                component.set("v.proposals",proposals);
                 
            }
            else if(resp.getState() === "Error") 
            {
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message) 
                    }
                }
                else { 
                    
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    fetchSOPS : function(component)
    {
        component.set("v.sops",null);
         var action = component.get("c.fetchSOPS");
         action.setParams({
                oppId: component.get("v.recordId")
        });
        action.setCallback(this, function(resp) {
            
            if (resp.getState() === "SUCCESS") {
                
                var sops = resp.getReturnValue();
                
                component.set("v.sops",sops);
                 
            }
            else if(resp.getState() === "Error") 
            {
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message) 
                    }
                }
                else { 
                    
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
    fetchContracts  : function(component)
    {
        component.set("v.proposals",null);
         var action = component.get("c.fetchContracts");
         action.setParams({
                oppId: component.get("v.recordId")
        });
        action.setCallback(this, function(resp) {
            
            if (resp.getState() === "SUCCESS") {
                
                var contracts = resp.getReturnValue();
                
                component.set("v.contracts",contracts);
                component.set("v.isSpinner",false);
                
            }
            else if(resp.getState() === "Error") 
            {
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log(errors[0].message) 
                    }
                }
                else { 
                    
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    
      sendEmail : function(component, VfPage, attId, attName)
    {
        var docDetails = component.get("v.selectedDocDetails");
        var email = component.get("v.email");
        var ccEmail = component.get("v.ccEmail");
        var VfPage = component.get("v.VfPage");
      
          var attId = component.get("v.attId");
      
          var attName = component.get("v.attName");
      
        var subject = component.get("v.subject");
        var body = component.get("v.body");
        var attachmentIds = component.get("v.Attachments");
        var action = component.get("c.sendMailMethod");
         
        
        
 
        action.setParams({"mMail":email,"mSubject":subject,"mbody":body,"AttachId":attachmentIds,"ccMail":ccEmail,"VfPage":VfPage,"attId":attId,"attName":attName});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                var records = response.getReturnValue();
                this.alertActionStatus("Successful","Email sent successfully","success");
                
                console.log(records);
                component.set("v.showSendEmail",false);
                component.set("v.isSpinner",false);
            }
            else if(state === "ERROR") {
                component.set("v.isSpinner",false);
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                        this.alertActionStatus("Error!",errors[0].message,"error");
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    alertActionStatus : function(title, message,type)
    {
        var showToast = $A.get("e.force:showToast"); 
        showToast.setParams({ 
            'title' : title, 
            'message' : message,
            'type': type
        }); 
        showToast.fire(); 
    },
})