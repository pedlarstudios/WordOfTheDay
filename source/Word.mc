using Log4MonkeyC as Log;

//! A word
class Word {
	var id;
	var word;
	var note;
	var definitions;
	var examples;

	function initialize() {
		definitions = new [10];
		examples = new [10];
	}
	
	function toString() {
		var toString = "id: " + id + ", word: " + word + ", note: " + note;
		
		return toString;
	}
	
}

//! A definition of a word
class WordDefinition {
	var text;
	var source;
	var partOfSpeech;
}

//! An example using a word
class WordExample {
	var text;
	var title;
}

//! Builds a [Word] from provided JSON data
class WordBuilderFromJson {
	hidden var logger;

	function initialize() {
		logger = Log.getLogger("WordBuilderFromJson");
	}

	function build(jsonData) {
		var word = new Word();
		word.id = data["id"];
		word.word = data["word"];
		word.note = data["note"];
		var examplesRaw = data["examples"];
		if (examplesRaw != null) { 
			for (var i = 0; i < examplesRaw.size(); i++) {
				var exampleRaw = examplesRaw[i];
				var example = new WordExample();
				example.text = exampleRaw["text"];
				example.title = exampleRaw["title"];
				word.examples[i] = example;
			}
		}
		var definitionsRaw = data["definitions"];
		if (definitionsRaw != null) {
			for (var i = 0; i < definitionsRaw.size(); i++) {
				var definitionRaw = definitionsRaw[i];
				var definition = new WordDefinition();
				definition.text = definitionRaw["text"];
				definition.partOfSpeech = definitionRaw["partOfSpeech"];
				definition.source = definitionRaw["source"];
				word.definitions[i] = definition;
			}
		}
		
		logger.debug("Built word from JSON: " + word.toString());
		return word;	
	}

}