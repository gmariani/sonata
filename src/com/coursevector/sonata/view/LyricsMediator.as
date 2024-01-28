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
	
	public class LyricsMediator extends Mediator implements IMediator {
		
		public static const NAME:String = 'LyricsMediator';
		
		private var mcLyricsScreen:MovieClip;
		private var txtTitle:TextField;
		private var txtArtistAlbum:TextField;
		private var txtLyrics:TextField;
		
		public function LyricsMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			init();
		}
		
		override public function listNotificationInterests():Array {
			return [ApplicationFacade.METADATA, ApplicationFacade.FOUND_LYRICS];
		}
		
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case ApplicationFacade.METADATA :
					var o:Object = note.getBody();
					txtTitle.text = o.TIT2;
					txtArtistAlbum.text = o.TPE1 + " - " + o.TABL;
					txtLyrics.htmlText = "Searching for lyrics...";
					
					sendNotification(ApplicationFacade.FIND_LYRICS, {artist:o.TPE1, title:o.TIT2});
					break;
				case ApplicationFacade.FOUND_LYRICS :
					//txtLyrics.htmlText = note.getBody() as String;
					txtLyrics.text = note.getBody() as String;
					
					break;
			}
		}
		
		private function get stage():DisplayObjectContainer {
			return viewComponent as DisplayObjectContainer;
		}
		
		private function init():void {
			mcLyricsScreen = stage.getChildByName("mcLyricsScreen");
			txtTitle = mcLyricsScreen.getChildByName("txtTitle");
			txtArtistAlbum = mcLyricsScreen.getChildByName("txtArtistAlbum");
			txtLyrics = mcLyricsScreen.getChildByName("txtLyrics");
			
			txtTitle.embedFonts = true;
			txtArtistAlbum.embedFonts = true;
			txtLyrics.embedFonts = true;
			
			mcLyricsScreen.visible = false;
			mcLyricsScreen.alpha = 0;
		}
	}
}