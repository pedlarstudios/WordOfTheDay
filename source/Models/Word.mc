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
		definitions = new [0];
		examples = new [0];

		var serializedDefs = serialized.get("definitions");
		if (serializedDefs != null) {
			for (var i = 0; i < serializedDefs.size(); i++) {
				definitions.add(new WordDefinition(serializedDefs[i]));
			}
		}
		// Not displayed currently
		/*
		note = serialized.get("note");
		var serializedExamples = serialized.get("examples");
		for (var i = 0; i < serializedExamples.size(); i++) {
			examples.add(new WordExample(serializedExamples[i]));
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

	function build(jsonData) {
		return new Word(jsonData);
	}
}