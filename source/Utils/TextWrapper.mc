using Log4MonkeyC as Log;
using Toybox.Math;
using Utils;

//! Handles adjusting input text to allow it to wrap in a text label
class TextWrapper {
	hidden var maxNumberOfLines = 5;
	hidden var maxCharactersPerLine = 30;
	
	hidden var logger;
	
	function initialize(configuration) {
		logger = Log.getLogger("TextWrapper");		
		if (configuration == null || configuration.isEmpty()) {
			// Defaults
		} else {
			self.maxNumberOfLines = configuration.get(:maxNumberOfLines);
			self.maxCharactersPerLine = configuration.get(:maxCharactersPerLine);
						
		}		
	}
	
	function apply(input) {
		var output = "";
		var numberOfLines = Math.ceil(input.length().toDouble() / maxCharactersPerLine.toDouble()).toNumber();
		logger.debug("Input (" + input.length() + "): " + input);
		logger.debug("Number of lines: " + numberOfLines);
		var inputAsChars = input.toCharArray();
		for (var i = 0; i < numberOfLines; i++) {
			var start = i * maxCharactersPerLine;
			var end = Utils.min(start + maxCharactersPerLine, input.length());
			var section = input.substring(start, end); 
			logger.debug(section);
			output += section;
			if (i != numberOfLines - 1) {				
				if (shouldAddHyphen(inputAsChars[end - 1])) {
					output += "-";
				}
				output += "\n";
			}
		}
		return output;
	}
	
	hidden function shouldAddHyphen(endChar) {
		// Right now, never add hyphen. Maybe add this as a setting later
		return false;
		//return endChar != ' ';
	}
}