function showLoadingDiv(){
	j$("#loadingDiv").css("display", "table-cell");
	j$("#loadingBox").css("display", "table-cell");
	j$("#loadingBox").show();
	j$(".loadingStatus").show();
}
            
function hideLoadingDiv(){
	j$("#loadingDiv").css("display", "none");
	j$("#loadingBox").css("display", "none");
	j$("#loadingBox").hide();
	j$(".loadingStatus").hide();
    j$('[id$=State_Province__c]').find('option').each(function(){
        if(j$(this).text() == 'Choose Country First'){
            j$(this).text('--Select Country First--');
        }
        if(j$(this).text() == 'Choose One'){
            j$(this).text('--Select--');
        }
    });
    j$('[id$=State_Province__c]').each(function(){
        if(j$(this).val() == 'Choose Country First'){
            j$(this).attr('disabled','disabled');
        }
    });
}