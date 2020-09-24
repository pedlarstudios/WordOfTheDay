using Toybox.WatchUi as Ui;
using Toybox.Communications as Comm;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Application as App;

using Utils;

// Main view and controller that loads and displays the word of the day
class WordView extends Ui.View {
	hidden const LAST_LOADED_DATE_KEY = "lastLoadedDate";
	hidden const LAST_LOADED_WORD_KEY = "lastLoadedWord";
	hidden var manager;
	hidden var dataLoader;
	hidden var currentWord;
	hidden var currentDefinitionIndex;
	hidden var loadingLabelDrawable;
	hidden var loadingImageDrawable;
	hidden var loadingImageOriginalLocation = [];

	function initialize() {
		Ui.View.initialize();
		self.currentDefinitionIndex = 0;
	}

    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        loadingLabelDrawable = findDrawableById("loadingLabel");
        loadingImageDrawable = findDrawableById("loadingImage");
        loadingImageOriginalLocation = [loadingImageDrawable.locX, loadingImageDrawable.locY];
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    	setIsLoading();
    	var lastLoadedDate = App.getApp().getProperty(LAST_LOADED_DATE_KEY);
    	var currentDate = Utils.formattedDateKey(Time.now(), "-");
    	if (!currentDate.equals(lastLoadedDate)) {
			loadWordOfTheDay();
		} else {
			setFinishedLoading();
			currentWord = new Word(App.getApp().getProperty(LAST_LOADED_WORD_KEY));
			drawWord(currentWord);
		}
    }

    //! Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    	// Nothing yet
    }

    function dataResponseCallback(data) {
    	setFinishedLoading();
		if (data.success) {
    		currentWord = new WordBuilderFromJson().build(data.data);
    		App.getApp().setProperty(LAST_LOADED_DATE_KEY, Utils.formattedDateKey(Time.now(), "-"));
    		App.getApp().setProperty(LAST_LOADED_WORD_KEY, currentWord.serialize());
    		drawWord(currentWord);
    	} else {
    		setLoadingError(data);
    		Ui.requestUpdate();
    	}
    }

    function openWordOfTheDayWebpage() {
    	loader().openWordOfTheDayWebpage();
    }

    function loadWordOfTheDay() {
		if (self.currentWord != null) {
			return;
		}
		setIsLoading();
		loader().loadWordOfTheDay(method(:dataResponseCallback));
	}

	function nextDefinition() {
		if (self.currentDefinitionIndex == -1 || self.currentWord == null || self.currentWord.definitions.size() <= 1) {
    		return self.currentDefinitionIndex;
    	}
    	if (self.currentDefinitionIndex == self.currentWord.definitions.size() - 1) {
    		self.currentDefinitionIndex = 0;
    	} else {
    		self.currentDefinitionIndex++;
    	}

    	drawWord(self.currentWord);
    	return self.currentDefinitionIndex;
	}

	function previousDefinition() {
		if (self.currentDefinitionIndex == -1 || self.currentWord == null || self.currentWord.definitions.size() <= 1) {
    		return self.currentDefinitionIndex;
    	}
    	if (self.currentDefinitionIndex == 0) {
    		self.currentDefinitionIndex = self.currentWord.definitions.size() - 1;
    	} else {
    		self.currentDefinitionIndex--;
    	}

		drawWord(self.currentWord);
    	return self.currentDefinitionIndex;
	}

	hidden function setIsLoading() {
		loadingLabelDrawable.setText(Rez.Strings.loadingText);
		loadingImageDrawable.setLocation(loadingImageOriginalLocation[0], loadingImageOriginalLocation[1]);
	}

	hidden function setFinishedLoading() {
		loadingLabelDrawable.setText("");
		loadingImageDrawable.setLocation(-999, -999);
	}

	hidden function setLoadingError(responseData) {
		loadingLabelDrawable.setText(responseData.data);
		loadingImageDrawable.setLocation(loadingImageOriginalLocation[0], loadingImageOriginalLocation[1]);
	}

	hidden function loader() {
    	return new DataLoader();
	}

    hidden function drawWord(word) {
    	var wordLabel = findDrawableById("wordLabel");
    	var noteLabel = findDrawableById("noteLabel");
    	var definitionLabel = findDrawableById("currentDefinitionLabel");
    	var definitionNumberLabel = findDrawableById("definitionNumberLabel");

		if (word != null) {
			if (word.word != null) {
	    		wordLabel.setText(word.word);
	    	}

	    	if (word.definitions != null && word.definitions.size() > 0)  {
	    		var definition = word.definitions[self.currentDefinitionIndex];
	    	    var wordText = definition.partOfSpeech + ": " + definition.text;
	    	   	definitionLabel.setText(Utils.applyWrapping(wordText));
	    		if (word.definitions.size() > 1) {
	    			definitionNumberLabel.setText((self.currentDefinitionIndex + 1) + "/" + word.definitions.size());
	    		}
	    	} else {
	    		definitionLabel.setText("");
	    		definitionNumberLabel.setText("");
	    	}
		} else {
			wordLabel.setText(Rez.Strings.wordLoadFailure);
			definitionLabel.setText("");
	    	definitionNumberLabel.setText("");
		}

    	Ui.requestUpdate();
    }
}