/*******************************************************
    Name        :        SalesAidsCartController
    Descritpion :        Salesaidscart component controller
****************************************************************/
public class SalesAidsCartController{
    
    @AuraEnabled
    public static SalesAidsCartWrapper getSaleAidsCart(){
        SalesAidsCartWrapper cart = new SalesAidsCartWrapper();
        
        String accountId,contactId,contactName;
        //get account id and portal view
        List<User> userlst = [Select id,ContactId,Contact.AccountId,Contact.Name,Default_Account_ID__c
                             from User where ID =: userinfo.getuserId()];
        if(userlst.size()>0 && userlst[0].ContactId != null){
            accountId = userlst[0].Contact.AccountId;
            contactId = userlst[0].ContactId;
            contactName = userlst[0].Contact.Name;
            cart.contactId = contactId;
        }else if(userlst.size()>0 && userlst[0].Default_Account_ID__c != null){
           accountId = userlst[0].Default_Account_ID__c;
           contactName = '';
           cart.isError = true;
           cart.messageheader = '<b>Error : </b>';
           cart.message = 'You are logged in as an internal user. For help ordering sales aids, please contact Marketing or partnerportal@kvh.com with your order.';
        }
        
        
        cart.shippinginfo = new AddressWrapper();
        if(!String.isBlank(contactId)){
            //fetch partner info
            cart.partnerInfo = getPartnerInfo(contactId);
            
            List<Sales_Aid_Order_Line__c> lineItems = fetLineItems(contactId);
            if(lineItems.size()>0){
                cart.salesOrderId = lineItems[0].Sales_Aid_Order__c;
                cart.lineItems.addAll(lineItems);
            }else{
                cart.isError = true;
                cart.messageheader = '';
                cart.message = '<b>There are no items in your order. </b>Please select the \'Back\' button to return to the Sales Aids page and add to your order.';
            }
        }
        
        return cart;        
    }
    
    
    
    @AuraEnabled
    public static SalesAidsCartWrapper deleteLineItem(String itemId,String salesCartJson){
        SalesAidsCartWrapper cart = (SalesAidsCartWrapper)JSON.deserialize(salesCartJson,SalesAidsCartWrapper.Class);
        cart.isError = false;
        cart.message = '';
        if(!String.isBlank(itemId)){
            try{
                List<Sales_Aid_Order_Line__c> deletelist = [Select id from Sales_Aid_Order_Line__c where id =: itemId];
                if(deletelist.size()>0)
                    delete deletelist;
                List<Sales_Aid_Order_Line__c> lineItems = fetLineItems(cart.contactId);
                cart.lineItems = new List<Sales_Aid_Order_Line__c>();
                if(lineItems.size()>0){
                    cart.lineItems.addAll(lineItems);
                }else{
                    cart.isError = true;
                    cart.messageheader = '';
                    cart.message = '<b>There are no items in your order. </b>Please select the \'Back\' button to return to the Sales Aids page and add to your order.';
                }
            }catch(Exception ex){
                cart.isError = true;
                cart.messageheader = '<b>Error : </b>';
                cart.message = ex.getMessage();
            }            
        }
        return cart;
    }
    
     @AuraEnabled
    public static SalesAidsCartWrapper updateLineItem(String lineItemJson,String salesCartJson){
        SalesAidsCartWrapper cart = (SalesAidsCartWrapper)JSON.deserialize(salesCartJson,SalesAidsCartWrapper.Class);
        try{
            Sales_Aid_Order_Line__c lineItem = (Sales_Aid_Order_Line__c)JSON.deserialize(lineItemJson,Sales_Aid_Order_Line__c.Class);
            //update quanity
            Sales_Aid_Order_Line__c updateLineItem = new Sales_Aid_Order_Line__c(Id = lineItem.Id,Quantity__c=lineItem.Quantity__c);
            update updateLineItem;
            List<Sales_Aid_Order_Line__c> lineItems = fetLineItems(cart.contactId);
            cart.lineItems = new List<Sales_Aid_Order_Line__c>();
            if(lineItems.size()>0)
                cart.lineItems.addAll(lineItems);
        }catch(Exception ex){
            cart.isError = true;
            cart.messageheader = '<b>Error : </b>';
            cart.message = ex.getMessage();
        }
        
        return cart;
    }
    
    @AuraEnabled
    public static SalesAidsCartWrapper submitOrder(String salesCartJson){
        SalesAidsCartWrapper cart = (SalesAidsCartWrapper)JSON.deserialize(salesCartJson,SalesAidsCartWrapper.Class);
        cart.isError = false;
        cart.message = '';
        try{
            Sales_Aid_Order__c salesOrder = new Sales_Aid_Order__c(Id = cart.salesOrderId,Status__c = 'Submitted');
            salesOrder.Shipping_Address__c = cart.shippinginfo.address;
            salesOrder.Shipping_City__c = cart.shippinginfo.city;
            salesOrder.Shipping_Company_Name__c = cart.shippinginfo.companyName;
            salesOrder.Shipping_Contact_Name__c = cart.shippinginfo.contactName;
            salesOrder.Shipping_Country__c = cart.shippinginfo.country;
            salesOrder.Shipping_Email__c = cart.shippinginfo.email;
            salesOrder.Shipping_Phone__c = cart.shippinginfo.phone;
            salesOrder.Shipping_State_Province_Territory__c = cart.shippinginfo.state;
            salesOrder.Shipping_Zip_Postal_Code__c = cart.shippinginfo.zipcode;
            update salesOrder;
            
            cart.lineItems = new List<Sales_Aid_Order_Line__c>();
            cart.orderProcessed = true;
            cart.messageheader = 'Thank you for your Sales Aids Order!';
            cart.message = 'Your order has been submitted for processing and will ship within three to four business days.';
        }catch(Exception ex){
            cart.isError = true;
            cart.messageheader = '<b>Error : </b>';
            cart.message = ex.getMessage();
        }
        return cart;
    }
    
    private static List<Sales_Aid_Order_Line__c> fetLineItems(String contactId){
        List<Sales_Aid_Order_Line__c> lineItems = [Select id,Sales_Aid_Order__c,Price__c,Product_Document__c,Quantity__c,Status__c,Tracking_Number__c,
                                                 Product_Document__r.Image_URL__c,Product_Document__r.Hosting_URL__c,Product_Document__r.Title_Display_Name__c, Product_Document__r.Sub_Title__c,
                                                 Product_Document__r.File_Description__c from Sales_Aid_Order_Line__c 
                                                where Sales_Aid_Order__r.Partner__c =: contactId AND Sales_Aid_Order__r.Status__c = 'In Progress' order by createddate limit 10000];
                                                
        return lineItems;    
    }
    
    private static AddressWrapper getPartnerInfo(String contactId){
        AddressWrapper info;
        List<Sales_Aid_Order__c> salesOrderlist = [Select id,Billing_Company_Name__c,Contact_Name__c,Email__c,Phone__c,Address__c,City__c,Zip_Postal_Code__c,
                                                    State_Province_Territory__c,Country__c from Sales_Aid_Order__c where Status__c = 'In Progress' and Partner__c =: contactId limit 1];
        if(salesOrderlist.size()>0){
            Sales_Aid_Order__c sa = salesOrderlist[0];
            info = new AddressWrapper(sa.Billing_Company_Name__c,sa.Contact_Name__c,sa.Email__c,sa.Address__c,sa.City__c,sa.Country__c,sa.State_Province_Territory__c,sa.Zip_Postal_Code__c,sa.Phone__c);
        }       
            
        return info;
    }

    public class SalesAidsCartWrapper{
        @AuraEnabled
        public String salesOrderId;
        @AuraEnabled
        public AddressWrapper partnerInfo;
        @AuraEnabled
        public AddressWrapper shippinginfo;
        @AuraEnabled
        public List<Sales_Aid_Order_Line__c> lineItems;
        @AuraEnabled
        public String contactId;
        @AuraEnabled
        public String message;
        @AuraEnabled
        public String messageheader;
        @AuraEnabled
        public boolean isError;
        @AuraEnabled
        public boolean orderProcessed;
        
        
        
        public SalesAidsCartWrapper(){
            this.isError = false;
            this.lineItems = new List<Sales_Aid_Order_Line__c>();
            this.contactId = '';
            this.orderProcessed = false;
        }
        
    }
    
    public class AddressWrapper{
        @AuraEnabled
        public String companyName;
        @AuraEnabled
        public String contactName;
        @AuraEnabled
        public String email;
        @AuraEnabled
        public String address;
        @AuraEnabled
        public String city;
        @AuraEnabled
        public String country;
        @AuraEnabled
        public String state;
        @AuraEnabled
        public String zipcode;
        @AuraEnabled
        public String phone;
        
        
        public AddressWrapper(){
            this.companyName = '';
            this.contactName = '';
            this.email = '';
            this.address = '';
            this.city = '';
            this.country = '';
            this.state = '';
            this.zipcode = '';
            this.phone = '';
        }
        
        
        public AddressWrapper(String companyName,String contactName,String email,String address,String city,String country,String state,String zipcode,String phone){
            this.companyName = companyName;
            this.contactName = contactName;
            this.email = email;
            this.address = address;
            this.city = city;
            this.country = country;
            this.state = state;
            this.zipcode = zipcode;
            this.phone = phone;
        }
    }
}