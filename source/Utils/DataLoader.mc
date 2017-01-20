using Toybox.Communications as Comm;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Cal;
using Toybox.WatchUi as Ui;
using Utils;

//! Loads data via JSON requests 
class DataLoader {
	hidden const WORD_OF_THE_DAY_API_URL = "http://api.wordnik.com/v4/words.json/wordOfTheDay";
	hidden const WORD_OF_THE_DAY_URL = "https://www.wordnik.com/word-of-the-day/";
		
	hidden var callbackMethod;
	
	function loadWordOfTheDay(callbackMethod) {
		self.callbackMethod = callbackMethod;
		if (!Sys.getDeviceSettings().phoneConnected) {
			self.callbackMethod.invoke(new DataResponse(false, "Phone disconnected"));
			return;
		}
		
		var formattedDate = Utils.formattedDateKey(Time.now(), "-");
		var apiKey = Ui.loadResource(Rez.Strings.apiKey);
		var requestOptions = { "date" => formattedDate, "api_key" => apiKey };
    	Comm.makeJsonRequest(WORD_OF_THE_DAY_API_URL, requestOptions, {}, method(:localResponseCallback));
	}
	
	function openWordOfTheDayWebpage() {
		if (!Sys.getDeviceSettings().phoneConnected) {
			return;
		}
		
		var formattedDate = Utils.formattedDateKey(Time.now(), "/");
		var url = WORD_OF_THE_DAY_URL + formattedDate;
		Comm.openWebPage(url, {}, {});
	}
	
	//! Would be hidden but MonkeyC does not allow callback methods to be private
	function localResponseCallback(responseCode, data) {
		var response;
		if (responseCode == 200) {
			response = new DataResponse(true, data);
		} 
		else {
			response = new DataResponse(false, "Server error");
		}
		
		self.callbackMethod.invoke(response);
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