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
	
	function apply(input, numberOfDefinitions) {
		var output = "";
		var numberOfLines = Math.ceil(input.length().toDouble() / maxCharactersPerLine.toDouble()).toNumber();
		numberOfLines = Utils.min(numberOfLines, self.maxNumberOfLines);
		if (numberOfDefinitions > 1 && numberOfLines == self.maxNumberOfLines) {
			numberOfLines--;
		}
		logger.debug("Input (" + input.length() + "): " + input);
		logger.debug("Number of lines based on input: " + numberOfLines);
		logger.debug("Number of lines possible based on device: " + self.maxNumberOfLines);
		var inputAsChars = input.toCharArray();
		for (var i = 0; i < numberOfLines; i++) {
			var start = i * maxCharactersPerLine;
			var end = Utils.min(start + maxCharactersPerLine, input.length());
			var section = input.substring(start, end); 
			
			if (i != numberOfLines - 1 || numberOfLines == 1) {
				output += section;				
				if (shouldAddHyphen(inputAsChars[end - 1])) {
					output += "-";
				}
				output += "\n";
			} else {
				// Last line, truncate if necessary
				logger.debug("Length " + section.length());
				if (section.length() >= maxCharactersPerLine) {
					section = section.substring(0, maxCharactersPerLine - 3) + "...";
				}
				output += section;
			}
			logger.debug(section);
		}
		return output;
	}
	
	hidden function shouldAddHyphen(endChar) {
		// Right now, never add hyphen. Maybe add this as a setting later
		return false;
		//return endChar != ' ';
	}
}