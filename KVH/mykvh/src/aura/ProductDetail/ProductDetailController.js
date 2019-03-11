({
    loadProduct : function (component,event,handler) {
        var document = component.get("v.document") ;
        console.log('product: '+ document);
        var tempImgObject=[], tempNonImgObject=[];

        for (var j = 0; j < document.length; j++){
            if(document[j].doctype === 'Product Image 1' ||
                document[j].doctype === 'Product Image 2' ||
                document[j].doctype === 'Product Image 3'){
                tempImgObject.push(document[j].documents[0].prodoclib.AWS_URL__c);
            }else{
                tempNonImgObject.push(document[j]);
            }
        }
        component.set("v.productImages", tempImgObject);
        component.set("v.nonProductImages", tempNonImgObject);
    }
})