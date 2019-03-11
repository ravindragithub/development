({
	toggleClass: function(component,componentId,className) {
		var modal = component.find(componentId);
    //modal.set("{!v.body}", "c:HTS_status_demo");
		$A.util.removeClass(modal,className+'hide');
		$A.util.addClass(modal,className+'open');
	},

	toggleClassInverse: function(component,componentId,className) {
		var modal = component.find(componentId);
		$A.util.addClass(modal,className+'hide');
		$A.util.removeClass(modal,className+'open');
	}
})