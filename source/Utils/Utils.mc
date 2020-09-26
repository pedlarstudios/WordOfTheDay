using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Cal;
using Toybox.WatchUi as Ui;
using Toybox.Math;

//! Assorted static utility methods
module Utils {

	var line1MaxChars = Ui.loadResource(Rez.Strings.line1MaxChars).toNumber();
	var line2MaxChars = Ui.loadResource(Rez.Strings.line2MaxChars).toNumber();
	var line3MaxChars = Ui.loadResource(Rez.Strings.line3MaxChars).toNumber();
	var line4MaxChars = Ui.loadResource(Rez.Strings.line4MaxChars).toNumber();
	var line5MaxChars = Ui.loadResource(Rez.Strings.line5MaxChars).toNumber();
	var line6MaxChars = Ui.loadResource(Rez.Strings.line6MaxChars).toNumber();
	var maxNumberOfLines = Ui.loadResource(Rez.Strings.maxNumberOfLines).toNumber();

	function applyWrapping(input) {
		var output = "";
		var numberOfLines = numberOfLines(input);
		numberOfLines = Utils.min(numberOfLines, maxNumberOfLines);
		var inputAsChars = input.toCharArray();
		var currentLineIndex = 0;
		var currentCharacterIndex = 0;
		while (currentCharacterIndex < input.length()) {
			var maxCharactersPerLine = line1MaxChars;	// assuming this is the smallest number
			if (currentLineIndex == 0) {
				maxCharactersPerLine = line1MaxChars;
			} else if (currentLineIndex == 1) {
				maxCharactersPerLine = line2MaxChars;
			} else if (currentLineIndex == 2) {
				maxCharactersPerLine = line3MaxChars;
			} else if (currentLineIndex == 3) {
				maxCharactersPerLine = line4MaxChars;
			} else if (currentLineIndex == 4) {
				maxCharactersPerLine = line5MaxChars;
			} else if (currentLineIndex == 5) {
				maxCharactersPerLine = line6MaxChars;
			}

			var start = currentCharacterIndex;
			var end = Utils.min(start + maxCharactersPerLine, input.length());
			var section = input.substring(start, end);
			// TODO trim section, and don't count leading/trailing whitespace in character count
			currentCharacterIndex = end;
			if (currentLineIndex != numberOfLines - 1) {
				output += section;
				output += "\n";
			} else {
				// Last line, shows ellipses if we cannot show all text
				var remaining = (input.length() - output.length()) - section.length();
				if (remaining > 0) {
					section = section.substring(0, section.length() - 4) + "...";
				}
				output += section;
				break;
			}
			currentLineIndex++;
		}
		return output;
	}

	function numberOfLines(input) {
		var inputLength = input.length().toNumber();
		var numberOfLines = 0;
		inputLength -= line1MaxChars;
		numberOfLines++;
		if (inputLength <= 0) {
			return numberOfLines;
		}
		inputLength -= line2MaxChars;
		numberOfLines++;
		if (inputLength <= 0) {
			return numberOfLines;
		}
		inputLength -= line3MaxChars;
		numberOfLines++;
		if (inputLength <= 0) {
			return numberOfLines;
		}
		inputLength -= line4MaxChars;
		numberOfLines++;
		if (inputLength <= 0) {
			return numberOfLines;
		}
		inputLength -= line5MaxChars;
		numberOfLines++;
		if (inputLength <= 0) {
			return numberOfLines;
		}
		inputLength -= line6MaxChars;
		numberOfLines++;
		return numberOfLines;
	}

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

	function trimStart(str) {
		if (str == null) {
			return str;
		}
		var newString = "";
		var chars = str.toCharArray();
		var foundNonSpace = false;
		for (var i = 0; i < chars.length; i++) {
			if (chars[i] != ' ') {
				newString += chars[i];
				foundNonSpace = true;
			} else if (foundNonSpace) {
				newString += chars[i];
			}
		}
		return newString;
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