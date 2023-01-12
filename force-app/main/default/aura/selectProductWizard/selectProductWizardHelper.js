({
    attachProducts: function(component, crtProducts) {
        console.log(crtProducts);
        this.upsertProduct(component, crtProducts, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                
                this.alertActionStatus("Products have been saved.","success");
            }
            else if (state === "ERROR") {
                var errors = a.getError();
                this.handleActionErrors(component, state, a); 
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        reject(Error("Error message: " + errors[0].message));
                    }
                }
                else {
                    reject(Error("Unknown error"));
                }
            }
            
            
            
        });
    },
    
    upsertProduct : function(component, crtProducts, callback) {
        console.log(JSON.stringify(crtProducts))
        var recordId = component.get("v.recordId"); 
        var oppProduct = [];
        
        for(var x in crtProducts)
        {
            var oppProd = {};
            oppProd['OpportunityId'] = recordId;
            oppProd['PricebookEntryId'] = crtProducts[x].Id;
            oppProd['Product2Id'] = crtProducts[x].Product2Id;
            oppProd['Quantity'] = crtProducts[x].Quantity
            oppProd['UnitPrice'] = crtProducts[x].UnitPrice;
            oppProdobj['VAT__c'] = oppProd[x].VAT__c;
          
            oppProdobj['Cost__c'] = oppProd[x].Cost__c;
            oppProdobj['Exclusions__c'] = oppProd[x].Exclusions__c;
            oppProd['sobjectType'] = 'OpportunityLineItem';
            oppProduct.push(oppProd)
        }
        
        var action = component.get("c.saveProducts");
        action.setParams({ 
            "selectedProduct": oppProduct,
            "recordId": recordId
        });
        
        
        if (callback) {
            action.setCallback(this, callback);
            console.log(callback);
            
            //this.alertActionStatus("Thank you","Your support request has been received.We will get back to you shortly.","success");
        }
        $A.enqueueAction(action);
        
    },
    getPriceBook : function(component)
    {
        var pricebooks = component.get("v.pricebooks");
        console.log(pricebooks);
        
        if (!!pricebooks)
        {
            var recordId = component.get("v.recordId");
            var action = component.get('c.fetchPriceBook');
            //action.setParams({'oppProduct':oppProduct});
            action.setCallback(this, $A.getCallback(function (response) {
                var state = response.getState();
                if (state === "SUCCESS") 
                {
                    var results = response.getReturnValue();
                    component.set("v.pricebooks",results)
                    //this.alertActionStatus("Success","Records saves successfully","success")
                }
                else if (state === "ERROR") 
                {
                    let errors = response.getError();
                    let message = 'Unknown error'; // Default error message
                    // Retrieve the error message sent by the server
                    if (errors && Array.isArray(errors) && errors.length > 0) {
                        for (var i = 0; i < errors.length; i++) { 
                            message = message +'Error'+ i + ':' + errors[i].message;
                        }
                    }
                    // Display the message
                    console.error(message);
                    
                    this.alertActionStatus("Error",message,"error");
                }
            }));
            $A.enqueueAction(action);
        }
    },
    
    saveOppProducts : function(component,oppProd){
        var opportunityRecord = component.get("v.opportunityRecord");
        console.log('saveOppProducts:::');
        
        var action = component.get('c.saveOpportunityLineItems');
        console.log('saveOppProducts:::333333');
        console.dir(oppProd);
        action.setParams({
            "selectedOliWrapper":oppProd,
            "opportunityRecord":opportunityRecord
        });
        console.log('saveOppProducts:::222222');
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('saveOppProducts111:::'+state);
            if (state === "SUCCESS") 
            {
                var results = response.getReturnValue();
                console.log("SUCCESS");
                console.log(results.length)
                component.set("v.oliFullList", results);
                component.set("v.oliList", results);
                console.log(opportunityRecord.Pricebook2Id)
                this.fetchNewProducts(component, opportunityRecord.Pricebook2Id);
                this.alertActionStatus("Success","Records saves successfully","success");
                
                component.set("v.showSpinner", false);
               
                    
            }
            else if (state === "ERROR") 
            {
                 console.log("ERROR");
                component.set("v.loadingSpinner",false)
                let errors = response.getError();
                let message = 'Please add the quantity on the selected products'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    for (var i = 0; i < errors.length; i++) { 
                        message = errors[0].message;
                    }
                }
                // Display the message
                console.error(message);
                
                this.alertActionStatus("Error",message,"error");
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
    
    getServiceLines : function(component, event, helper){
        var action = component.get("c.getPicklist");
        var percent = component.find("PicklistId");
        var opts=[];
        action.setCallback(this, function(response) {
            var allValues = response.getReturnValue();
            console.log('allValues -- >> ' + allValues);
            component.set("v.serviceLine", allValues);
            this.getPriceBook(component);
        });
        $A.enqueueAction(action); 
    },
    
    getServiceTypes : function(component, event, helper){
        console.log(1);
        var action = component.get("c.getServiceTypePicklist");
        var percent = component.find("PicklistId");
        var opts=[];
        console.log(2);
        action.setCallback(this, function(response) {
            
            var allValues = response.getReturnValue();
            console.log('allValues -- >> ' + allValues);
            component.set("v.serviceTypes", allValues);
            this.getPriceBook(component);
            console.log(3);
        });
        $A.enqueueAction(action); 
    },
    
    updateOppPriceBookId : function(component,pricebookid)
    {
        var recordId = component.get("v.recordId");
        var oppDetails = {};
        oppDetails['sobjectType'] = 'Opportunity';
        oppDetails['Id'] = recordId;
        oppDetails['Pricebook2Id'] = pricebookid;
        var action = component.get("c.updateOpportunityPricebook");
        action.setParams({'opportunityDetails':oppDetails});
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS")
            {
                var records = response.getReturnValue();
                component.set("v.opportunityRecord.Pricebook2Id",records.Pricebook2Id);
                this.recordUpdated(component,records.Pricebook2Id);
                console.log(records)
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
    
    fetchOpportunityProducts: function(component)
    {
        var opportunityRecord = component.get("v.opportunityRecord");
        var action = component.get("c.getOpportunityLineItems");
        action.setParams({"opportunityRecord":opportunityRecord})
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var allValues = response.getReturnValue();               
                console.log(allValues);
                component.set('v.oliList', allValues);
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
    
    recordUpdated : function(component,pricebookId)
    {
        
        var opportunityRecord = component.get("v.opportunityRecord");
        //opportunityRecord['Pricebook2Id'] = pricebookId;
        console.log(JSON.stringify(opportunityRecord))
        var action = component.get("c.getPricebookEntry");
        action.setParams({"opportunityRecord":opportunityRecord,"pricebookId":pricebookId})
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var allValues = response.getReturnValue();
                console.log(allValues);
                for (var x in allValues){
                    allValues[x].Quantity = 1;
                    allValues[x].VAT__c = false;
                }
                console.log(allValues);
                component.set('v.allProducts', allValues);
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
    
    fetchNewProducts : function(component,pricebookId)
    {
        var opportunityRecord = component.get("v.opportunityRecord");
        var opportunityLineItemFullList = component.get("v.oliFullList");        
        var action = component.get("c.getOliLineItems");
        action.setParams({
            "opportunityRecord":opportunityRecord,
            "pricebookId":pricebookId,
            "existingOppLineItems": opportunityLineItemFullList        
        })
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var allValues = response.getReturnValue();
                
                this.setDefaultPageValues(component, allValues);
                
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
    
    filterProducts: function (cmp) {
        var serviceline = cmp.get("v.sline");
        var servicetype = cmp.get("v.stype");
        var opportunityRecord = cmp.get("v.opportunityRecord");
        console.log(servicetype);
        var action = cmp.get('c.filterProductsServiceLine');
        console.log(opportunityRecord);
        action.setParams({
            "serviceline": serviceline,
            "servicetype": servicetype,
            "opportunityRecord":opportunityRecord
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var allValues = response.getReturnValue();
                console.log("allValues--->>> " + allValues.length);
                console.log(JSON.stringify(allValues));
                this.setDefaultPageValues(cmp, allValues);
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
    searchProducts : function(component) {
        var searchVar = component.get("v.searchVar");
        console.log('Test');
        var inputcomponent = component.find("searchProductName");
        var serviceline = component.find("servicelinepicklist1").get("v.value");
        var servicetype = component.find('servicelinepicklist').get('v.value');
        var opportunityRecord = component.get("v.opportunityRecord");
        console.log(searchVar);
        var action = component.get('c.searchServiceTypeProducts');
        action.setParams({
            "searchVar": searchVar,
            "opportunityRecord":opportunityRecord,
            "serviceline": serviceline,
            "servicetype": servicetype,
            
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var allValues = response.getReturnValue();
                console.log("allValues--->>> " + allValues);
                this.setDefaultPageValues(component, allValues);
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
    
    setDefaultPageValues: function (component, allValues)
    {
        console.log('HHHHHHHHHHHHHHH');
        var pageSize = component.get("v.pageSize");
        component.set("v.oliWrapperFullList", allValues);
        component.set("v.totalSize", allValues.length);
        component.set("v.start", 0);
        component.set("v.end", pageSize - 1);
        
        console.log(component.get("v.oliWrapperFullList"));
        
        var paginationList = [];
        
        for (var i = 0; i < pageSize; i++)
        { 
            paginationList.push(allValues[i]);                    
        }
        
        component.set("v.oliWrapperPaginated", paginationList);
        component.set("v.showSpinner", false);
    }
    
    
    
    
    
})