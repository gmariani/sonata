/**
* 
* 
* 
* @author Default
* @version 0.1
*/

package com.coursevector.sonata.view {
	
	import fl.data.DataProvider;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	
	import com.coursevector.sonata.ApplicationFacade;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	public class LibraryMediator extends Mediator implements IMediator {
		
		public static const NAME:String = 'LibraryMediator';
		
		private var mcLibraryScreen:MovieClip;
		
		public function LibraryMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			init();
		}
		
		override public function listNotificationInterests():Array {
			return [];
		}
		
		override public function handleNotification(note:INotification):void {
			/*switch (note.getName()) {
				case ApplicationFacade.FOUND_LYRICS :
					txtLyrics.htmlText = note.getBody() as String;
					break;
			}*/
		}
		
		private function get stage():DisplayObjectContainer {
			return viewComponent as DisplayObjectContainer;
		}
		
		private function init():void {
			mcLibraryScreen = stage.getChildByName("mcLibraryScreen");
			mcLibraryScreen.visible = false;
			mcLibraryScreen.alpha = 0;
		}
	}
}