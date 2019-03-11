public class ProductWrapper {
	public Boolean isSelected;								//holds a flag indicating if a Products is selected or not
	public Activation_Hardware__c wrappedProduct;			//holds the details of the Activation Hardware
	
	public ProductWrapper(Activation_Hardware__c prod){			//constructor, requires an Activation Hardware to wrap
		this.wrappedProduct = prod;								//Activation Hardware to be wrapped
		this.isSelected = false;								//Selected Flag, default == not selected
	}
	
	public Boolean getisSelected(){
		return isSelected;
	}
	public Activation_Hardware__c getwrappedProduct(){
		return wrappedProduct;
	}
}