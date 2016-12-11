using Log4MonkeyC as Log;

//! Responsible for loading and caching word data 
class Manager {
	hidden var dataLoader;
	hidden var word;	
	hidden var dataResponseCallback;

	function initialize(dataResponseCallback) {
		self.dataResponseCallback = dataResponseCallback;
		//dataLoader = new DataLoader(method(:dataResponseCallback));
		dataLoader = new DataLoader(method(:myDataResponseCallback));
		
	}
	
	function requiresDataLoad() {
	
	}
	
	function loadWordOfTheDay() {
		// Check cache. Dictionary of info by date?
		return dataLoader.loadWordOfTheDay();
	}
	
	function myDataResponseCallback(data) {
		Log.getLogger("Manager").debug("Data is: " + data.success);
		if (data.success) {
    		word = new WordBuilderFromJson().build(data.data);
    		self.dataResponseCallback.invoke(word);
    	}
	}
}