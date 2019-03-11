({
	download : function (component,event,helper) {
        var TC = component.get("v.tc");
        var ht = component.get("v.ht");
        var did = component.get("v.docId");
        console.log('TC' + TC);
        console.log('ht' + ht);
        if(TC || ht){
        window.open(
            $A.get("$Label.c.OrgURL")+"/"+$A.get("$Label.c.Community_Prefix")+"/TCandHTML?id="+did,
            "", "width=500,height=500");
        } else{
            window.open( 
                $A.get("$Label.c.OrgURL")+"/"+$A.get("$Label.c.Community_Prefix")+"/downloaddocument?id="+did,
            "", "width=500,height=500");
        }

    }
})