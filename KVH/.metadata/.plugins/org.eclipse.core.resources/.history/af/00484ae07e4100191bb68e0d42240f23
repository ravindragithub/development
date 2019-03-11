({
	buildQuotePageurl : function(component){
        
        var accountID = component.get("v.partner").accountId;
       
        var productId = component.get("v.ProductID");
      
        var searchOption = component.get("v.searchOption");
        var satecountry = component.get("v.stateCountry");
           
        var url = './requestaquote?RepId='+ accountID  + '&ProductID=' + productId + '&Request=' + searchOption + '&Location=' + satecountry;
        component.set("v.quoteURL",url);
	}
})