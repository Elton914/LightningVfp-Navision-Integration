({
    doInit  : function(component, event, helper)
    {
       var oppId = component.get("v.recordId");
     
       helper.fetchProductFamilyRemarks(component);
       helper.fetchOpportunity(component);
    },
    changeType : function(component, event, helper)
    {
        helper.fetchTemplate(component);
    },
       changeLetterhead : function(component, event, helper)
    {
        var letterhead = component.get("v.letterHeadValue");
        console.log(letterhead);
        component.set("v.letterHeadSelected",true);
    },
    next : function(component, event, helper)
    {
        var selectedTab = event.getSource().get("v.name");
        if(selectedTab.includes('Preview'))
        {
            component.set("v.reloadPreview",true);
        }
        component.set("v.selectedTab",selectedTab)
    }, 
    previous : function(component, event, helper)
    {
        var selectedTab = event.getSource().get("v.name");
        if(selectedTab.includes('Remarks'))
        {
            component.set("v.reloadPreview",false);
        }
        component.set("v.selectedTab",selectedTab);
    },
    nextFamily : function(component, event, helper)
    {
        var family = component.get("v.remarksFamily");
        var recordIndex = event.getSource().get("v.name");
        component.set("v.selectedFamilyTab",family[recordIndex+1].Name);
        
    },
    previousFamily : function(component, event, helper)
    {
        var family = component.get("v.remarksFamily");
        var recordIndex = event.getSource().get("v.name");
         component.set("v.selectedFamilyTab",family[recordIndex-1].Name);
    },
    fetchFamily : function(component, event, helper)
    {
        helper.fetchFamily(component);
    },
    createDocument : function(component, event, helper)
    {
        var oppId = component.get("v.recordId");
        var accId = component.get("v.opportunityRecord.AccountId");
        var opportunityRecord = component.get("v.opportunityDetails");
        var details = component.get("v.templates");
        var typeDocument = component.get("v.typeDocument")
         var letterhead = component.get("v.letterHeadValue");
        var docDetails = [];
     
        for(var x in details)
        {
            var docDet = {};
            docDet['Opportunity__c'] = oppId;
 		    docDet['LetterHead__c'] = letterhead;            
            if(typeDocument.includes('Proposal'))
            {
                docDet['sobjectType'] = 'Proposal__c';
                if(details[x].Content__c)
                {
                	docDet['Description__c'] = details[x].Content__c;
                }
                if(details[x].Salutation__c)
                {
                	docDet['Salutation__c'] = details[x].Salutation__c;
                }
                if(opportunityRecord.hasOwnProperty('Proposal__r'))
                {
                    if(opportunityRecord.Proposal__r.length > 0 )
                    {
                        docDet['Id'] = opportunityRecord.Proposal__r[0].Id;
                    }
                }
            }
            else if(typeDocument.includes('Contract'))
            {
                docDet['sobjectType'] = 'Contract';
                if(details[x].Content__c)
                {
                    docDet['Contract_Details__c'] = details[x].Content__c;
                    docDet['AccountId'] =accId ;
                }
                if(opportunityRecord.hasOwnProperty('Contracts__r'))
                {
                    if(opportunityRecord.Contracts__r.length > 0 )
                    {
                        docDet['Id'] = opportunityRecord.Contracts__r[0].Id;
                    }
                }
            }  
            else if(typeDocument.includes('SOP'))
            {
                docDet['sobjectType'] = 'SOP__c';
                if(details[x].Content__c)
                {
                    docDet['Description__c'] = details[x].Content__c;
                }
                if(opportunityRecord.hasOwnProperty('SOPs__r'))
                {
                    if(opportunityRecord.SOPs__r.length > 0 )
                    {
                        docDet['Id'] = opportunityRecord.SOPs__r[0].Id;
                    }
                }
           }  
            else if(typeDocument.includes('Quote'))
            {
                docDet['sobjectType'] = 'Quote';
                if(details[x].Content__c)
                {
                    docDet['Quote_Description__c'] = details[x].Content__c;
                    docDet['OpportunityId'] =oppId ;
                    docDet['Name'] =opportunityRecord.Name;
                    if(opportunityRecord.hasOwnProperty('Quotes'))
                    {
                        if(opportunityRecord.Quotes.length > 0 )
                        {
                            docDet['Id'] = opportunityRecord.Quotes[0].Id;
                        }
                    }
                } 
            }  
            
            docDetails.push(docDet) 
        }
        component.set("v.loadingSpinner",true);
       	helper.createDocument(component,docDetails, oppId, letterhead, typeDocument);
    },
    createRemarks : function(component, event, helper)
    {
        component.set("v.loadingSpinner",true);
        component.set("v.hideNextSaveRemarks",true);
        helper.createRemarks(component);
    },
    saveAttachement : function(component, event, helper)
    {
        helper.saveAttachement(component,false);
    },
    saveEmailAttachement : function(component, event, helper)
    {
        helper.saveAttachement(component,true);
    },
    sendEmail : function(component, event, helper)
    {
        helper.sendEmail(component);
    },
    printQuoteDetails:function(component,event,helper)
    {
        
        window.open("/apex/airFreightImportSample?");
    },
    
    saveQuoteDetails:function(component,event,helper)
    {  
        var oppId = component.get("v.recordId")
        var details = component.get("v.templates");
        console.log(details);
        var propDetails = [];
        for(var x in details)
        {
            var propDet = {};
            propDet['Opportunity__c'] = oppId;
            propDet['Description__c'] = details[x].Content__c;
            propDet['Salutation__c'] = details[x].Salutation__c;
            /*     propDet['Ref__c'] = details[x].Ref__c;
            propDet['Cargo_Details__c'] = details[x].Cargo_Details__c;*/
            propDetails.push(propDet) 
        }
        console.log(propDetails);
        var action = component.get("c.saveProposal");
        action.setParams({
            "proposal": propDetails
            
        });
        $A.enqueueAction(action);
        window.location.reload();
    },
    
    onBack: function(component, event, helper) {
        var value = '';
        component.set("v.value",value );
        
    },
    onNext: function(component, event, helper) {
        var value = 'none';
        component.set("v.value",value );
        component.set("v.canNext", true);
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