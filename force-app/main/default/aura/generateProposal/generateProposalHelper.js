({
    helperMethod : function() {
        
    },
    fetchOpportunity : function(component)
    {
        var recordId = component.get("v.recordId"); 
        var action = component.get("c.getOpportunityDetails");
        action.setParams({"oppId":recordId})
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var records = response.getReturnValue();
                component.set("v.opportunityDetails",records);
                console.log(JSON.stringify(records));
                // this.fetchTypeofDocument(component)
                // 
                var options = [];
                var optionObj = {};
                optionObj['value'] = 'Proposal';
                optionObj['label'] = 'Proposal';
                options.push(optionObj);
                
                if (records.Proposal_Approved__c )  {
                    
                    
                 //   var optionObj = {};
                 //   optionObj['value'] = 'Quote';
                  //  optionObj['label'] = 'Quote';
                  //  options.push(optionObj);
                   
                    
                    var optionObj = {};
                    optionObj['value'] = 'Contract';
                    optionObj['label'] = 'Contract';
                    options.push(optionObj);
                    
                    
                    var optionObj = {};
                    optionObj['value'] = 'SOP';
                    optionObj['label'] = 'SOP';
                    options.push(optionObj);
                }
                component.set("v.options",options);
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    fetchTypeofDocument : function(component)
    {
        var recordId = component.get("v.recordId"); 
        var action = component.get("c.fetchPickValue");
        action.setParams({"field_name":"Type__c","ObjectName":"Template__c"})
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var records = response.getReturnValue();
                var options = [];
                if(records.hasOwnProperty("Type__c"))
                {
                    for(var x in records['Type__c'])
                    {
                        var optionObj = {};
                        optionObj['label'] = records['Type__c'][x];
                        optionObj['value'] = records['Type__c'][x];
                        options.push(optionObj);
                    }
                    component.set("v.options",options);
                }
                
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    fetchFamily : function(component)
    {
        var recordId = component.get("v.recordId"); 
        var action = component.get("c.getProductFamily");
        action.setParams({"oppId":recordId})
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var records = response.getReturnValue();
                console.log(records)
                var savedDocument = component.get("v.selectedDocDetails");
                var opportunityRecord = component.get("v.opportunityDetails");
                console.log(JSON.stringify(opportunityRecord))
                var typeDocument = component.get("v.typeDocument")
                if(records.length>0)
                {
                    var existingRemarks;
                    if(opportunityRecord.hasOwnProperty('Remarks__r'))
                    {
                        existingRemarks = opportunityRecord.Remarks__r;
                    }
                    component.set("v.selectedFamilyTab",records[0])
                    var remarksDetails = [];
                    for(var x in records)
                    {
                        var remarkIndex;
                        if(existingRemarks)
                        {
                            remarkIndex = existingRemarks.map(function (r) { return r.Name; }).indexOf(records[x]);
                        }
                        if(savedDocument.hasOwnProperty("Id"))
                        {
                            var familyOpt = {};
                            familyOpt['Name'] = records[x];
                            familyOpt['Opportunity__c'] = recordId;
                            familyOpt['sobjectType'] = 'Remark__c';
                            if(typeDocument.includes('Proposal'))
                            {
                                familyOpt['Proposal__c'] = savedDocument.Id;
                            }
                            if(typeDocument.includes('Quote'))
                            {
                                familyOpt['Quote__c'] = savedDocument.Id;
                            }
                            if(remarkIndex>=0)
                            {
                                if(records[x].includes(existingRemarks[remarkIndex].Name))
                                {
                                    //get remarks
                                //    var stdRemark = component.get("v.productFamilyToRemarksMap");
                                 //   var specificRemark = stdRemark['family'].Content__c;
                                    
                                 
                                    
                                    familyOpt['Remarks__c'] = existingRemarks[remarkIndex].Remarks__c;// +'/n'+specificRemark;
                                    familyOpt['Id'] = existingRemarks[remarkIndex].Id;
                                }
                            }
                            else
                            {
                                familyOpt['Remarks__c'] = "";
                            }
                            remarksDetails.push(familyOpt); 
                        }
                    }
                    component.set("v.remarksFamily",remarksDetails);
                }
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    fetchProductFamilyRemarks : function(component)
    {
        var action = component.get("c.getRemarks");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var records = response.getReturnValue();
                console.log(records)
                component.set("v.productFamilyToRemarksMap", records);
                
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    fetchTemplate : function(component)
    {
        var typeDocument = component.get("v.typeDocument")
        var artId = component.get("v.recordId"); 
        var action = component.get("c.getTemplates");
        action.setParams({'typeDocument':typeDocument});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var allValues = response.getReturnValue();
                console.log(allValues);
                component.set("v.hideNextSaveDocument",false);
                component.set("v.hideNextSaveRemarks",false);
                
                
                var opportunityRecord = component.get("v.opportunityDetails");
                for(var x in allValues)
                {
                    if(allValues[x].hasOwnProperty("Name"))
                    {
                        if(allValues[x].Name.includes(typeDocument))
                        {  
                           allValues[x].Content__c =allValues[x].HtmlValue ;
                            console.log(allValues[x].HtmlValue);
                           if(typeDocument.includes("Proposal"))
                            {
                                if(opportunityRecord.hasOwnProperty('Proposal__r'))
                                {
                                    if(opportunityRecord.Proposal__r.length > 0 )
                                    {
                                        allValues[x].Content__c = opportunityRecord.Proposal__r[0].Description__c;
                                        allValues[x].Salutation__c = opportunityRecord.Proposal__r[0].Salutation__c;
                                    }
                                }
                            }
                            else if(typeDocument.includes("Contract"))
                            {
                                if(opportunityRecord.hasOwnProperty('Contracts__r'))
                                {
                                    if(opportunityRecord.Contracts__r.length > 0 )
                                    {
                                        allValues[x].Content__c = opportunityRecord.Contracts__r[0].Contract_Details__c;
                                    }
                                }
                            }
                                else if(typeDocument.includes("SOP"))
                                {
                                    if(opportunityRecord.hasOwnProperty('SOPs__r'))
                                    {
                                        if(opportunityRecord.SOPs__r.length > 0 )
                                        {
                                            allValues[x].Content__c = opportunityRecord.SOPs__r[0].Description__c;
                                        }
                                    }
                                }
                                    else if(typeDocument.includes("Quote"))
                                    {
                                        if(opportunityRecord.hasOwnProperty('Quotes'))
                                        {
                                            if(opportunityRecord.Quotes.length > 0 )
                                            {
                                                allValues[x].Content__c = opportunityRecord.Quotes[0].Quote_Description__c;
                                            }
                                        }
                                    } 
                        }
                    }
                }
                component.set('v.templates', allValues);
            }
            else if(state === "ERROR") {
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    createDocument : function(component,docDetails,oppId, letterhead, typeDocument)
    {
        var typeDocument = component.get("v.typeDocument")
        var recordId = component.get("v.recordId"); 
        var action = component.get("c.saveDocumentDetails");
        action.setParams({'docDetails':docDetails, 'oppId':oppId, 'letterhead':letterhead, 'typeDocument':typeDocument});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                
                   component.set("v.hideNextSaveDocument",true);
                
                var records = response.getReturnValue();
                if(records.length > 0)
                {
                    component.set("v.selectedDocDetails",records[0])
                }
                if(typeDocument.includes('Quote'))
                {
                    this.createQuoteLine(component);
                }
                this.alertActionStatus("Successful","Records created successfully","success");
                component.set("v.loadingSpinner",false);
                console.log(records);
                
            }
            else if(state === "ERROR") {
                component.set("v.loadingSpinner",false);
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
    createQuoteLine : function(component)
    {
        var opportunityRecord = component.get("v.opportunityDetails");
        if(opportunityRecord.hasOwnProperty('OpportunityLineItems'))
        {
            var quoteId = component.get("v.selectedDocDetails.Id");
            var action = component.get("c.saveQuoteLineItem");
            action.setParams({'opplines':opportunityRecord.OpportunityLineItems,"quoteId":quoteId});
            action.setCallback(this, function(response){
                var state = response.getState();
                if(state === "SUCCESS")
                {
                    var records = response.getReturnValue();
                    console.log(records);
                    this.alertActionStatus("Successful","Records created successfully","success");
                    component.set("v.loadingSpinner",false);
                    this.updateOpp(component);
                }
                else if(state === "ERROR") {
                    component.set("v.loadingSpinner",false);
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
        }
    },
    updateOpp : function(component)
    {
        var quote = component.get("v.selectedDocDetails");
        var typeDocument = component.get("v.typeDocument");
        var recordId = component.get("v.recordId");
        var oppDetails = {};
        oppDetails['sobjectType'] = 'Opportunity';
        oppDetails['Id'] = recordId;
        oppDetails['SyncedQuoteId'] = quote.Id;
        var action = component.get("c.updateOpportunity");
        action.setParams({'opp':oppDetails});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var records = response.getReturnValue();
                console.log(records);
            }
            else if(state === "ERROR") {
                component.set("v.loadingSpinner",false);
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
    createRemarks : function(component)
    {
        var familyRemarks = component.get("v.remarksFamily");
        var remarks = [];
        for(var x in familyRemarks)
        {
            if(familyRemarks[x].Remarks__c)
            {
                remarks.push(familyRemarks[x]);
            }
        }
        console.log(JSON.stringify(remarks));
        var action = component.get("c.saveRemarks");
        action.setParams({'remarks':remarks});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                var records = response.getReturnValue();
                this.alertActionStatus("Successful","Records created successfully","success");
                
                console.log(records);
                component.set("v.loadingSpinner",false);
            }
            else if(state === "ERROR") {
                component.set("v.loadingSpinner",false);
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
    saveAttachement : function(component,attach)
    {
        var recordId = component.get("v.recordId");
         var typeDocument = component.get("v.typeDocument") ;
         var action = component.get("c.saveAttachmentDoc");
         action.setParams({ "oppId":recordId,"selectedDocument":typeDocument });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                var opp = response.getReturnValue();
                this.alertActionStatus("Successful","Records created successfully","success");
                 
                component.set("v.loadingSpinner",false);
                console.log(111);
                if(opp.StageName == 'Prospecting'){
                  this.submitApproval(component);
                 console.log(2222)
                }
                else if(opp.Probability >= 0.4 && opp.Price_Updated__c == true){
                   this.submitDiscountApproval(component);
                }
                
     }
            else if(state === "ERROR") {
                component.set("v.loadingSpinner",false);
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
    sendEmail : function(component)
    {
        var docDetails = component.get("v.selectedDocDetails");
        var email = component.get("v.email");
        var ccEmail = component.get("v.ccEmail");
        var subject = component.get("v.subject");
        var body = component.get("v.body");
        var attachmentIds = component.get("v.Attachments");
        var action = component.get("c.sendMailMethod");
        action.setParams({"mMail":email,"mSubject":subject,"mbody":body,"AttachId":attachmentIds,"ccMail":ccEmail});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                var records = response.getReturnValue();
                this.alertActionStatus("Successful","Email sent successfully","success");
                
                console.log(records);
                component.set("v.loadingSpinner",false);
            }
            else if(state === "ERROR") {
                component.set("v.loadingSpinner",false);
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
      submitApproval : function(component)
    {
        console.log(333);
       var recordId = component.get("v.recordId");
        var oppDetails = {};
        oppDetails['sobjectType'] = 'Opportunity';
        oppDetails['Id'] = recordId;
        oppDetails['StageName'] ='Proposal Submitted For Approval';
        var action = component.get("c.updateOpportunity");
        action.setParams({'opp':oppDetails});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var records = response.getReturnValue();
                console.log(records);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "The Proposal has been submited for approval."
                    
                });
                toastEvent.fire();
                 window.location.reload;
            }
            else if(state === "ERROR") {
                component.set("v.loadingSpinner",false);
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                      //  this.alertActionStatus("Error!",errors[0].message,"error");
                       var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type":"error",
                            "message":errors[0].message,
                            "Mode":"sticky"
                        });
                        toastEvent.fire();
                    
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
        window.location.reload;
       
     //   window.location.reload;
    },
       submitDiscountApproval : function(component)
    {
        console.log(333);
       var recordId = component.get("v.recordId");
        var action = component.get("c.submitforDiscountApproval");
        action.setParams({'oppId':recordId});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var records = response.getReturnValue();
                console.log(records);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"success",
                    "message": "The Proposal has been submitted for discounts approval!"
                    
                });
                toastEvent.fire();
                 window.location.reload;
            }
            else if(state === "ERROR") {
                component.set("v.loadingSpinner",false);
                var errors = response.getError();
                if(errors){
                    if(errors[0] && errors[0].message){
                        console.log("Error Message: " + errors[0].message);
                      //  this.alertActionStatus("Error!",errors[0].message,"error");
                       var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Error!",
                            "type":"error",
                            "message":errors[0].message,
                            "Mode":"sticky"
                        });
                        toastEvent.fire();
                    
                    }
                }
                else{
                    console.log("Unknown Error");
                }
            }
        });
        $A.enqueueAction(action);
        window.location.reload;
       
     //   window.location.reload;
    },
  
})