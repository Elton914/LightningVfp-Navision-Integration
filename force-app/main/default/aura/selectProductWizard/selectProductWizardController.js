({
    doInit : function(component, event, helper) 
    {    
        component.set("v.showSpinner", true);
     
        var artId = component.get("v.recordId"); 
        console.log(artId); 
       helper.getServiceLines(component, event, helper);
       helper.getServiceTypes(component, event, helper);
        
        console.log(10);
    },
    existingOpportunity : function(component, event, helper)
    {
        var opportunityRecord = component.get("v.opportunityRecord");
        if(opportunityRecord.hasOwnProperty('Pricebook2Id'))
        {
            if(opportunityRecord.Pricebook2Id)
            {
                 component.set("v.showSpinner", true);
            	//helper.recordUpdated(component,opportunityRecord.Pricebook2Id);
            	helper.fetchNewProducts(component,opportunityRecord.Pricebook2Id);
                helper.fetchOpportunityProducts(component);
            }
        }
        
    },
    /*recordUpdated : function(component, event, helper)
    {
        var changeType = event.getParams().changeType;
        console.log(changeType)
        var opportunityRecord = component.get("v.opportunityRecord")
        var action = component.get("c.getPricebookEntry");
       action.setParams({"opportunityRecord":opportunityRecord})
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var allValues = response.getReturnValue();
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
    },*/
    servicelinepicklineChange: function (component, evt, helper) {
        var serviceline = component.find('servicelinepicklist1').get('v.value');
        console.log(serviceline);
        component.set('v.sline', serviceline);
        component.set("v.showSpinner", true);
        helper.filterProducts(component);
    },
        
    servicetypepicklineChange: function (component, evt, helper) {
        var servicetype = component.find('servicelinepicklist').get('v.value');
        console.log(servicetype);
        component.set('v.stype', servicetype);
        component.set("v.showSpinner", true);
        helper.filterProducts(component);
        
    }, 
    
    changePricebook :   function(component, event, helper) 
    {
        var recordId = component.get("v.recordId");
        var opportunityRecord = component.get("v.opportunityRecord");
        console.log(JSON.stringify(opportunityRecord))
        var pricebookid = event.getSource().get("v.value");
        component.set("v.opportunityRecord.Pricebook2Id",pricebookid);
        component.set("v.opportunityRecord.Id",recordId);
        console.log(pricebookid);
        helper.updateOppPriceBookId(component,pricebookid);
        
    },
    
    
   searchTypeProducts : function(component, event, helper) {
     
       helper.searchProducts(component);
    
    }, 
    
  
    
     onCheckVat: function(component, event, helper) {
        var findvalue = event.getSource("checkbox2");
        var checked = findvalue.get("v.value");
        console.log(checked);
      },
    
     refresh: function(component, event, helper) {

        location.reload();
      },
    
    saveProductControllers: function(component, event, helper) {
          component.set("v.showSpinner", true);
            console.log(3);
      /*  var selectedProductsList = component.get("v.allProducts");
        console.log(JSON.stringify(selectedProductsList));
        var findvalue = component.find("checkbox");
        
        var selectedProduct = [];
        for(var x in selectedProductsList)
        {
            if(findvalue[x].get("v.checked"))
            {
                selectedProduct.push(selectedProductsList[x]);
            }
        }
        console.log(selectedProduct);
        console.log(JSON.stringify(selectedProduct)); */
            console.log(4);
        var selectedProducts = [];
        var prodList = component.get("v.oliWrapperPaginated");
        console.log(1111);
        for(var x in prodList)
        {   
            console.log(x);
            console.log(prodList[x]);
            
            if(prodList[x].isSelected)
            {
                selectedProducts.push(prodList[x]);
            }
        }
        
        console.log('selectedProducts --'+selectedProducts);
        if(selectedProducts.length > 0){
            console.log(selectedProducts.length);
            helper.saveOppProducts(component, selectedProducts);
        }
        else
        {
            component.set("v.showSpinner", false);
            
        }
        
        
        
    },
    
     first: function(component, event, helper)
    {
 		 
        component.set("v.showSpinner", true);
        var selectedProducts = [];
        var prodList = component.get("v.oliWrapperPaginated");
        console.log(1111);
        for(var x in prodList)
        {   
            console.log(x);
            console.log(prodList[x]);
            
            if(prodList[x].isSelected)
            {
                selectedProducts.push(prodList[x]);
            }
        }
        
        console.log('selectedProducts --'+selectedProducts);
        if(selectedProducts.length > 0){
            console.log(selectedProducts.length);
            helper.saveOppProducts(component, selectedProducts);
        }
        
            
        
        var oppList = component.get("v.oliWrapperFullList");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];

        for (var i = 0; i < pageSize; i++)
        {
            paginationList.push(oppList[i]);
        }

        component.set("v.oliWrapperPaginated", paginationList);  
        component.set("v.showSpinner", false);
    },

    last: function(component, event, helper)
    {
 
        component.set("v.showSpinner", true);
        var selectedProducts = [];
        var prodList = component.get("v.oliWrapperPaginated");
        console.log(1111);
        for(var x in prodList)
        {   
            console.log(x);
            console.log(prodList[x]);
            
            if(prodList[x].isSelected)
            {
                selectedProducts.push(prodList[x]);
            }
        }
        
        console.log('selectedProducts --'+selectedProducts);
        if(selectedProducts.length > 0){
            console.log(selectedProducts.length);
            helper.saveOppProducts(component, selectedProducts);
        }
        
            
        var oppList = component.get("v.oliWrapperFullList");
        var pageSize = component.get("v.pageSize");
        var totalSize = component.get("v.totalSize");

        var paginationList = [];

        for (var i = totalSize - pageSize + 1; i < totalSize; i++)
        {
            paginationList.push(oppList[i]);
        }

        component.set("v.oliWrapperPaginated", paginationList);
        component.set("v.showSpinner", false);
        //disable next
    },

    next: function(component, event, helper)
    {
        
        component.set("v.showSpinner", true);
        var selectedProducts = [];
        var prodList = component.get("v.oliWrapperPaginated");
        console.log(1111);
        for(var x in prodList)
        {   
            console.log(x);
            console.log(prodList[x]);
            
            if(prodList[x].isSelected)
            {
                selectedProducts.push(prodList[x]);
            }
        }
        
        console.log('selectedProducts --'+selectedProducts);
        if(selectedProducts.length > 0){
            console.log(selectedProducts.length);
            helper.saveOppProducts(component, selectedProducts);
        }
        
            
        var oppList = component.get("v.oliWrapperFullList");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        
        var paginationList = [];
        
        var counter = 0;
        
        for (var i = end + 1; i < end + pageSize + 1; i++)
        {
            if (oppList.length > end)
            {
                paginationList.push(oppList[i]);
                counter++;
            }
        }
        
        console.log('selected - '+paginationList.length);
        
        
        start = start + counter;
        end = end + counter;
        
        component.set("v.start", start);
        component.set("v.end", end);
        component.set("v.oliWrapperPaginated", paginationList);   
        component.set("v.showSpinner", false);
        //if at the last page disable last and next
        
    },
    
    

    previous: function(component, event, helper)
    {
         
        component.set("v.showSpinner", true);
        var selectedProducts = [];
        var prodList = component.get("v.oliWrapperPaginated");
        console.log(1111);
        for(var x in prodList)
        {   
            console.log(x);
            console.log(prodList[x]);
            
            if(prodList[x].isSelected)
            {
                selectedProducts.push(prodList[x]);
            }
        }
        
        console.log('selectedProducts --'+selectedProducts);
        if(selectedProducts.length > 0){
            console.log(selectedProducts.length);
            helper.saveOppProducts(component, selectedProducts);
        }
        
            

        var oppList = component.get("v.oliWrapperFullList");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");

        var paginationList = [];

        var counter = 0;

        for (var i = start - pageSize; i < start; i++)
        {
            if (i > -1)
            {
                paginationList.push(oppList[i]);
                counter++;
            } else {
                start++;
            }
        }

        start = start - counter;
        end = end - counter;

        component.set("v.start", start);
        component.set("v.end", end);

        component.set("v.oliWrapperPaginated", paginationList);
       component.set("v.showSpinner", false);
        //if you are on first page, disable previous and first
       
    }

})