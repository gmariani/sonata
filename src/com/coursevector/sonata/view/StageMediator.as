/**
* 
* 
* 
* @author Default
* @version 0.1
*/

package com.coursevector.sonata.view {
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import com.coursevector.sonata.ApplicationFacade;
	import com.coursevector.display.SpectrumAnalyzer;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import gs.TweenLite;
	import fl.controls.List;
	
	public class StageMediator extends Mediator implements IMediator {
		
		public static const NAME:String = 'StageMediator';
		
		private var specAn:SpectrumAnalyzer = new SpectrumAnalyzer();
		private var mcList:MovieClip;
		private var mcInfo:MovieClip;
		private var mcPlaylists:MovieClip;
		private var mcMusic:MovieClip;
		private var mcLyrics:MovieClip;
		private var song_list:List;
		private var media_list:List;
		private var mcLibraryScreen:MovieClip;
		private var mcLyricsScreen:MovieClip;
		private var mcInfoScreen:MovieClip;
		
		public function StageMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			init();
		}
		
		override public function listNotificationInterests():Array {
			return [];
		}
		
		override public function handleNotification(note:INotification):void {
			/*switch (note.getName()) {
				case ApplicationFacade.NEW_SKIN :
					loadSkin(note.getBody() as String);
					break;
			}*/
		}
		
		public function getScreens():Array {
			return [media_list, song_list, mcLibraryScreen, mcLyricsScreen, mcInfoScreen];
		}
		
		private function get stage():DisplayObjectContainer {
			return viewComponent as DisplayObjectContainer;
		}
		
		private function init():void {
			mcList = stage.getChildByName("mcList");
			mcInfo = stage.getChildByName("mcInfo");
			mcPlaylists = stage.getChildByName("mcPlaylists");
			mcMusic = stage.getChildByName("mcMusic");
			mcLyrics = stage.getChildByName("mcLyrics");
			song_list = stage.getChildByName("song_list");
			media_list = stage.getChildByName("media_list");
			mcLibraryScreen = stage.getChildByName("mcLibraryScreen");
			mcLyricsScreen = stage.getChildByName("mcLyricsScreen");
			mcInfoScreen = stage.getChildByName("mcInfoScreen");
			
			// Spectrum Analyzer
			specAn.x = 55;
			specAn.y = 570;
			specAn.barWidth = 5;
			specAn.barAmount = 26;
			specAn.lineSpace = 2;
			specAn.showPeaks = false;
			specAn.plotHeight = 30;
			stage.addChild(specAn);
			
			// Section Buttons
			setButtonLabels(mcList, "Playlist", "Show playlist");
			setButtonLabels(mcInfo, "Information", "Shows track & artist information");
			setButtonLabels(mcPlaylists, "Playlists", "Show, choose & edit playlists");
			setButtonLabels(mcMusic, "Music Library", "Show the Library filter");
			setButtonLabels(mcLyrics, "Lyrics", "Show track lyrics");
			mcList.addEventListener(MouseEvent.CLICK, clickHandler);
			mcPlaylists.addEventListener(MouseEvent.CLICK, clickHandler);
			mcMusic.addEventListener(MouseEvent.CLICK, clickHandler);
			mcLyrics.addEventListener(MouseEvent.CLICK, clickHandler);
			mcInfo.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		private function setButtonLabels(mc:MovieClip, strTitle:String, strDesc:String):void {
			var txtTitle:TextField = mc.getChildByName("txtTitle");
			var txtDesc:TextField = mc.getChildByName("txtDesc");
			
			txtTitle.text = strTitle;
			txtTitle.mouseEnabled = false;
			txtDesc.text = strDesc;
			txtDesc.mouseEnabled = false;
		}
		
		private function clickHandler(e:MouseEvent):void {
			switch(e.currentTarget) {
				case mcPlaylists:
					sendNotification(ApplicationFacade.CHANGE_SCREEN, media_list);
					break;
				case mcList:
					sendNotification(ApplicationFacade.CHANGE_SCREEN, song_list);
					break;
				case mcMusic:
					sendNotification(ApplicationFacade.CHANGE_SCREEN, mcLibraryScreen);
					break;
				case mcLyrics:
					sendNotification(ApplicationFacade.CHANGE_SCREEN, mcLyricsScreen);
					break;
				case mcInfo:
					sendNotification(ApplicationFacade.CHANGE_SCREEN, mcInfoScreen);
					break;
			}
		}
	}
}