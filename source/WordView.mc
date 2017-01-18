using Toybox.WatchUi as Ui;
using Toybox.Communications as Comm;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Application as App;

using Log4MonkeyC as Log;
using Utils;

// Main view and controller that loads and displays the word of the day
class WordView extends Ui.View {
	hidden const LAST_LOADED_DATE_KEY = "lastLoadedDate"; 
	hidden const LAST_LOADED_WORD_KEY = "lastLoadedWord";
	hidden var logger;
	hidden var manager;
	hidden var dataLoader;
	hidden var currentWord;
	hidden var currentDefinitionIndex;
	hidden var loadingLabelDrawable;
	hidden var loadingImageDrawable;
	hidden var loadingImageOriginalLocation = [];

	function initialize() {
		Ui.View.initialize();
		logger = Log.getLogger("WordOfTheDayView");
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
    	logger.debug("Last loaded: " + lastLoadedDate + " Current: " + currentDate);    		
    	if (!currentDate.equals(lastLoadedDate)) {
			loadWordOfTheDay();
		} else {
			setFinishedLoading();
			logger.debug("Displaying previously loaded word");
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
    		setLoadingError();
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
    	var maxCharactersPerLine = Ui.loadResource(Rez.Strings.maxCharactersPerLine).toNumber();
    	var maxNumberOfLines = Ui.loadResource(Rez.Strings.maxNumberOfLines).toNumber();
    	var wrapper = new TextWrapper({
    		:maxCharactersPerLine => maxCharactersPerLine,
    		:maxNumberOfLines => maxNumberOfLines
    	});
    	
    	wordLabel.setText(word.word);
    	//noteLabel.setText(word.note);
    	    	
    	var definition = word.definitions[self.currentDefinitionIndex];
    	if (word.definitions.size() == 1) {
    		var wordText = definition.partOfSpeech + ": " + definition.text;
	    	definitionLabel.setText(wrapper.apply(wordText, word.definitions.size()));
    		definitionNumberLabel.setText("");
    	} else if (word.definitions.size() > 0) {
    		var wordText = (self.currentDefinitionIndex + 1) + ") " + definition.partOfSpeech + ": " + definition.text;
	    	definitionLabel.setText(wrapper.apply(wordText, word.definitions.size()));
    		definitionNumberLabel.setText((self.currentDefinitionIndex + 1) + "/" + word.definitions.size());
    	} else {
    		definitionLabel.setText("");
    		definitionNumberLabel.setText("");
    	}
    	
    	Ui.requestUpdate();
    }    
}