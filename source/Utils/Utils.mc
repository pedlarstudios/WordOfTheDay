using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Cal;

//! Assorted static utility methods
module Utils {

	function min(a, b) {
		if (a < b) {
			return a;
		}
		return b;
	}
	
	function max(a, b) {
		if (a > b) {
			return a;
		}
		return b;
	}
	
	function formattedDateKey(date, separator) {
		var timeInfo = Cal.info(date, Time.FORMAT_SHORT);
		return timeInfo.year.format("%04d") + separator + timeInfo.month.format("%02d") + separator + timeInfo.day.format("%02d");
	}
	
	function serializeArray(arrayOfSerializables) {
		var serializedArray = new [0];
		for (var i = 0; i < arrayOfSerializables.size(); i++) {
			var item = arrayOfSerializables[i];
			serializedArray.add(item.serialize());
		}	
		
		return serializedArray;
	}
	
}