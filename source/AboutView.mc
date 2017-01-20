using Toybox.WatchUi as Ui;
using Toybox.Communications as Comm;
using Toybox.System as Sys;

// View that displays app information
class AboutView extends Ui.View {
	
	function initialize() {
		Ui.View.initialize();
	}
	
    //! Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.AboutLayout(dc));
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {    	
		// Nothing
    }

    //! Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        new Rez.Drawables.menuSeparator().draw(dc);        
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    	// Nothing yet
    }
}