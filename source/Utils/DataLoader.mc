using Toybox.Communications as Comm;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Cal;
using Toybox.WatchUi as Ui;
using Utils;

//! Loads data via JSON requests 
class DataLoader {
	hidden const WORD_OF_THE_DAY_API_URL = "https://api.wordnik.com/v4/words.json/wordOfTheDay";
	hidden const WORD_OF_THE_DAY_URL = "https://www.wordnik.com/word-of-the-day/";
		
	hidden var callbackMethod;
	hidden var retryCount = 0;
	
	function loadWordOfTheDay(callbackMethod) {
		self.callbackMethod = callbackMethod;
		makeWordOfTheDayRequest(true);	// attempt with date param included first 	
	}

	function openWordOfTheDayWebpage() {
		if (!Sys.getDeviceSettings().phoneConnected) {
			return;
		}
		
		var formattedDate = Utils.formattedDateKey(Time.now(), "/");
		var url = WORD_OF_THE_DAY_URL + formattedDate;
		Comm.openWebPage(url, {}, {});
	}	
		
	hidden function makeWordOfTheDayRequest(includeDateParam) {
		if (!Sys.getDeviceSettings().phoneConnected) {
			callbackMethod.invoke(new DataResponse(false, "Phone disconnected"));
			return;
		}
		
		var apiKey = Ui.loadResource(Rez.Strings.apiKey);
		// Sometimes Wordnik's API does not return a proper response if passing in today's date, and
		// sometimes it returns an old WOTD entry if omitting the date entirely, instead of returning
		// what the service considers to be the current word of the day. We need to be able to attempt both
		// of those requests.		
		var params = { "api_key" => apiKey };
		if (includeDateParam) {			
			params.put("date", Utils.formattedDateKey(Time.today(), "-"));
		}		
		var options = {
           :method => Communications.HTTP_REQUEST_METHOD_GET,
           :headers => {
                   "Content-Type" => Communications.REQUEST_CONTENT_TYPE_JSON},                        
           :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
       	};
    	Comm.makeWebRequest(WORD_OF_THE_DAY_API_URL, params, options, method(:localResponseCallback));
	}	
	
	//! MonkeyC does not allow callback methods to be hidden, or this would be
	function localResponseCallback(responseCode, data) {		
		if (responseCode == 200) {					
			callbackMethod.invoke(new DataResponse(true, data));
		} 
		else if (retryCount == 0) {
			retryCount++;
			makeWordOfTheDayRequest(false);
		}
		else {						
			callbackMethod.invoke(new DataResponse(false, "Server error"));			
		}		
    }
}

class DataResponse {
	var data;
	var success;
	
	function initialize(success, data) {
		self.success = success;
		self.data = data;
	}
}