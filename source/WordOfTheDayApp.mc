using Toybox.Application as App;
using Toybox.System as Sys;
using Log4MonkeyC as Log;

class WordOfTheDayApp extends App.AppBase {

	function initialize() {
		App.AppBase.initialize();
	}
	
    //! onStart() is called on application start up
    function onStart(state) {
    	// SET APPROPRIATELY BEFORE DEPLOYMENT/RELEASE
		var config = new Log4MonkeyC.Config();
		config.setLogLevel(Log.DEBUG);
		Log4MonkeyC.setLogConfig(config);		
    }

    //! onStop() is called when your application is exiting
    function onStop(state) {
    }

    //! Return the initial view of your application here
    function getInitialView() {
    	var mainView = new WordView();
    	var mainDelegate = new WordBehaviorDelegate(mainView);
        return [ mainView, mainDelegate ];
    }

}