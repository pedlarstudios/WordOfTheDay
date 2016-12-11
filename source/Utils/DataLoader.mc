using Toybox.Communications as Comm;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Cal;
using Toybox.WatchUi as Ui;
using Log4MonkeyC as Log;
using Utils;

//! Loads data via JSON requests 
class DataLoader {
	hidden const WORD_OF_THE_DAY_API_URL = "http://api.wordnik.com/v4/words.json/wordOfTheDay";
	hidden const WORD_OF_THE_DAY_URL = "https://www.wordnik.com/word-of-the-day/";
		
	hidden var logger;
	hidden var callbackMethod;
	
	function initialize() {
		logger = Log.getLogger("DataLoader");
	}

	function loadWordOfTheDay(callbackMethod) {
		self.callbackMethod = callbackMethod;
		if (!Sys.getDeviceSettings().phoneConnected) {
			self.callbackMethod.invoke(new DataResponse(false, "Phone disconnected"));
			return;
		}
		
		//var timeInfo = Cal.info(Time.now(), Time.FORMAT_SHORT);
		//var formattedDate = timeInfo.year.format("%04d") + "-" + timeInfo.month.format("%02d") + "-" + timeInfo.day.format("%02d");
		var formattedDate = Utils.formattedDateKey(Time.now(), "-");
		var apiKey = Ui.loadResource(Rez.Strings.apiKey);
		var requestOptions = { "date" => formattedDate, "api_key" => apiKey };
		logger.debug("Word for date: " + formattedDate);
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
			logger.debug("Received data: " + data);
			response = new DataResponse(true, data);
		} 
		else {
			response = new DataResponse(false, "Server error");
			logger.error("Response code " + responseCode + " encountered attempting to load Word of the Day. Data: " + data);		
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