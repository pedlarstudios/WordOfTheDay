using Log4MonkeyC as Log;
using Toybox.Lang as Lang;
using Toybox.System as Sys;
using Utils;

//! A word
class Word {
	var id;
	var word;
	var note;
	var definitions;
	var examples;

	function initialize(serialization) {		
		if (serialization != null) {
			deserialize(serialization);
		} else {
			definitions = new [0];
			examples = new [0];
		}
	}
	
	function serialize() {
		var serialized = {
			"id" => id,
			"word" => word,
			"note" => note,
			"definitions" => Utils.serializeArray(definitions),
			"examples" => Utils.serializeArray(examples)
		};
		return serialized;
	}
	
	function deserialize(serialized) {
		id = serialized.get("id");
		word = serialized.get("word");
		note = serialized.get("note");
		definitions = new [0];
		examples = new [0];
		var serializedDefs = serialized.get("definitions");
		for (var i = 0; i < serializedDefs.size(); i++) {
			definitions.add(new WordDefinition(serializedDefs[i]));
		}
		
		var serializedExamples = serialized.get("examples");
		for (var i = 0; i < serializedExamples.size(); i++) {
			examples.add(new WordExample(serializedExamples[i]));
		}
		
		/*if (serialized.get(definitions) != null) {
			var serializedDefs = serialized.get(:definitions)[:array];
			//var serializedDefsArray = serializedDefs[:array];
			for (var i = 0; i < serializedDefs.size(); i++) {
				definitions.add(new WordDefinition(serializedDefs[i]));
			}
		}
		
		examples = new SerializableArray(new [0]);
		if (serialized.get(:examples)) {
			var serializedExamples = serialized.get(:examples)[:array];
			//var serializedDefsArray = serializedDefs[:array];
			for (var i = 0; i < serializedExamples.size(); i++) {
				examples.add(new WordDefinition(serializedExamples[i]));
			}
		}*/
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
	
	function initialize(serialization) {
		if (serialization != null) {
			deserialize(serialization);
		}
	}
	
	function serialize() {
		return {
			"text" => text,
			"source" => source,
			"partOfSpeech" => partOfSpeech
		};
	}
	
	function deserialize(serialized) {
		text = serialized.get("text");
		source = serialized.get("source");
		partOfSpeech = serialized.get("partOfSpeech");
	}
	
	function toString() {
		var toString = "text: " + text + ", source: " + source + ", partOfSpeech: " + partOfSpeech;
		return toString;
	}
}

//! An example using a word
class WordExample {
	var text;
	var title;
	
	function initialize(serialization) {
		if (serialization != null) {
			deserialize(serialization);
		}
	}
	
	function serialize() {
		return {
			"text" => text,
			"title" => title
		};
	}
	
	function deserialize(serialized) {
		text = serialized.get("text");
		title = serialized.get("title");		
	}
}

//! Builds a [Word] from provided JSON data
class WordBuilderFromJson {
	hidden var logger;

	function initialize() {
		logger = Log.getLogger("WordBuilderFromJson");
	}

	function build(jsonData) {
		var word = new Word(jsonData);
		/*word.id = jsonData["id"];
		word.word = jsonData["word"];
		word.note = jsonData["note"];*/
		
		/*var examplesRaw = jsonData["examples"];
		if (examplesRaw != null) { 
			for (var i = 0; i < examplesRaw.size(); i++) {
				var exampleRaw = examplesRaw[i];
				var example = new WordExample(exampleRaw);
							
				word.examples.add(example);
			}
		}
		var definitionsRaw = jsonData["definitions"];
		if (definitionsRaw != null) {
			for (var i = 0; i < definitionsRaw.size(); i++) {
				var definitionRaw = definitionsRaw[i];
				var definition = new WordDefinition(definitionRaw);
			
				word.definitions.add(definition);
			}
		}*/
		
		logger.debug("Built word from JSON: " + word.toString());
		return word;	
	}
}

//! Array with serialization functionality
class SerializableArray extends Lang.Array {
	hidden var backingArr;

	function initialize(array) {	
		Lang.Array.initialize();		
		backingArr = array;
	}
	
	function indexOf(object) {
		return backingArr.indexOf(object);
	}
	
	function add(object) {
		backingArr.add(object);
		return self;		
	}
	
	function addAll(array) {
		backingArr.addAll(array);
		return self;
	}
	
	function remove(object) {
		return backingArr.remove(object);
	}
	
	function removeAll(object) {
		return backingArr.removeAll(object);
	}
	
	function reverse() {
		var backingArrayReversed = backingArr.reverse();
		return new SerializableArray(backingArrayReversed);
	}
	
	function size() {
		return backingArr.size();
	}
	
	function slice(startIndex, endIndex) {
		var backingArraySliced = backingArr.slice(startIndex, endIndex);
		return new SerializableArray(backingArraySliced);
	}
	
	function toString() {
		return self.serializationName + " " + backingArr.toString();
	}
	
	function serialize() {
		var serializedArray = new [0];
		for (var i = 0; i < backingArr.size(); i++) {
			var item = backingArr[i];
			serializedArray.add(item.serialize());
		}	
		
		return serializedArray;
		/*return {
			//:count => backingArr.size(),
			:array => serializedArray
		};*/
	}
	
	function deserialize(serialized) {
		//var count = serialized[:count];
		backingArr = serialized[:array];
	}
	
	function get(index) {
		return backingArr[index];
	}
	
	function set(index, value) {
		backingArr[index] = value;
	}
}