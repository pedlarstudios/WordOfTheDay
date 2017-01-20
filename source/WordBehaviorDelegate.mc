using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Communications as Comm;

//! Handles user interactions for the widget
class WordBehaviorDelegate extends Ui.BehaviorDelegate {
	hidden var wordView;
	
	function initialize(wordView) {
		Ui.BehaviorDelegate.initialize();
		self.wordView = wordView;
	}
	
	function onKey(evt) {
		if (Ui.KEY_ENTER == evt.getKey()) {	
			self.wordView.nextDefinition();			
		} else if (Ui.KEY_ESC == evt.getKey()) {
			// Returning false exits the widget
			return false;
		} else if (Ui.KEY_UP == evt.getKey() || Ui.KEY_MENU == evt.getKey()) {
			return menuPress();
		} else if (Ui.KEY_LAP == evt.getKey() || Ui.KEY_MODE == evt.getKey()) {
			openWordWebpage();
		}

		return true;
	}
	
	//! Specifically handles the menu key press
    function onMenu() {
    	return menuPress();
	}
	
	function onBack() {
		// Returning false exits the widget
		return false;
	} 
	
	hidden function menuPress() {
		Ui.pushView(new Rez.Menus.WordMenu(), new WordMenuDelegate(self.wordView), Ui.SLIDE_UP);
        return true;
	}
	
	function onTap(evt) {
		self.wordView.nextDefinition();
		return true;
	}
	
	//! Handle touch screen swipe
	function onSwipe(evt) {
		var direction = evt.getDirection();
		if (direction == 3) {
			// Left
			onNextPage();
		} else if (direction == 1) {
			// Right
			onPreviousPage();
		}
				
		return true;
	}
	
	function onHold(evt) {
		openWordWebpage();
	}
	
	function onKeyReleased(evt) {
		return true;
	}
	
	function onNextPage() {
		return true;
	}
	
	function onPreviousPage() {
		return true;		
	}
	
	hidden function openWordWebpage() {
		if (Sys.getDeviceSettings().phoneConnected) {
			self.wordView.openWordOfTheDayWebpage();
		}
	}
}

//! Handles the menu
class WordMenuDelegate extends Ui.MenuInputDelegate {
	hidden var wordView;
	
	function initialize(wordView) {
		Ui.MenuInputDelegate.initialize();
		self.wordView = wordView;
	}
	
	function onMenuItem(item) {
		if (item == :about) {
			var aboutView = new AboutView();
			var aboutBehaviorDelegate = new AboutMenuBehaviorDelegate(aboutView);
			Ui.pushView(aboutView, aboutBehaviorDelegate, Ui.SLIDE_IMMEDIATE);
		} else if (item == :help) {
			Ui.pushView(new HelpView(), new BaseBehaviorDelegate(), Ui.SLIDE_IMMEDIATE);
		} else if (item == :openWord) {
			if (Sys.getDeviceSettings().phoneConnected) {
				self.wordView.openWordOfTheDayWebpage();
			}
		}
		return true;
	}
}

class BaseBehaviorDelegate extends Ui.BehaviorDelegate {
	function initialize() {
		Ui.BehaviorDelegate.initialize();	
	}
	
	function onBack() {
		Ui.popView(Ui.SLIDE_IMMEDIATE);
		return true;
	} 
}

//! Handles interactions with the about menu
class AboutMenuBehaviorDelegate extends BaseBehaviorDelegate {
	hidden var aboutView;
	hidden const TAP_BUFFER = 10;
	
	function initialize(aboutView) {
		BaseBehaviorDelegate.initialize();
		self.aboutView = aboutView;
	}
	
	function onTap(evt) {
    	var coords = evt.getCoordinates();
		var x = coords[0];
		var y = coords[1];
		
		if (!Sys.getDeviceSettings().phoneConnected) {
			return true;
		}
		
		var providerLabel = aboutView.findDrawableById("providerLogo");						
		var developerLabel = aboutView.findDrawableById("developerLabel");
		
		// Provider tapped
		if ((x >= applyMinusBuffer(providerLabel.locX) && x <= applyPlusBuffer(providerLabel.locX) + providerLabel.width)
			&& (y >= applyMinusBuffer(providerLabel.locY) && y <= applyPlusBuffer(providerLabel.locY) + providerLabel.height)) {
			Comm.openWebPage(Ui.loadResource(Rez.Strings.providerUrl), {}, {});
		} else if ((x >= applyMinusBuffer(developerLabel.locX) && x <= applyPlusBuffer(developerLabel.locX) + developerLabel.width)
			&& (y >= applyMinusBuffer(developerLabel.locY) && y <= applyPlusBuffer(developerLabel.locY) + developerLabel.height)) {
			Comm.openWebPage(Ui.loadResource(Rez.Strings.developerUrl), {}, {});
		}
		
		return true;			
	}
	
	function onNextPage() {
		Comm.openWebPage(Ui.loadResource(Rez.Strings.providerUrl), {}, {});
		return true;
	}
	
	function onPreviousPage() {
		Comm.openWebPage(Ui.loadResource(Rez.Strings.developerUrl), {}, {});
		return true;	
	}
	
	hidden function applyPlusBuffer(value) {
		return value + TAP_BUFFER;
	}
	
	hidden function applyMinusBuffer(value) {
		return value - TAP_BUFFER;
	}

}