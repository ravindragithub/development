({
    updateSearch : function(component, event, helper) {
        
       var searchValue = component.find("searchInput").getElement().value;
        console.log("searchValue==>"+event.getParams().keyCode );
        if(event.getParams().keyCode == 13){
            helper.searchHelper(component, event, helper, searchValue) ;
        }
        
        var appEvent = $A.get("e.c:SearchBoxComponentEvent");
        appEvent.setParams({
            "searchinput" : searchValue });
        appEvent.fire();
    },
    
    searchIcon : function(component, event, helper){

        var searchValue = component.find("searchInput").getElement().value;
        helper.searchHelper(component, event, helper, searchValue) ;
    },
    handleClearEvent : function(component, event, helper){
    	component.find("searchInput").getElement().value = "";
	}
})