/**
* 
* 
* 
* @author Default
* @version 0.1
*/

package com.coursevector.sonata.view {
	
	import fl.data.DataProvider;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import com.coursevector.sonata.ApplicationFacade;
	import flash.display.DisplayObjectContainer;
	import fl.events.ListEvent;
	import fl.controls.List;
	import flash.text.TextFormat;
	import flash.events.Event;
	
	public class PlayListsMediator extends Mediator implements IMediator {
		
		public static const NAME:String = 'PlayListsMediator';
		
		private var media_list:List;
		private var tfList:TextFormat = new TextFormat("Avenir LT Std 35 Light");
		
		public function PlayListsMediator(viewComponent:Object) {
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array {
			return [ApplicationFacade.NEW_PLAYLIST];
		}
		
		override public function handleNotification(note:INotification):void {
			switch (note.getName()) {
				case ApplicationFacade.NEW_PLAYLIST :
					media_list.removeAll();
					media_list.dataProvider = note.getBody() as DataProvider;
					break;
			}
		}
		
		override public function initializeNotifier(key:String):void {
			super.initializeNotifier(key);
			
			init();
		}
		
		private function get stage():DisplayObjectContainer {
			return viewComponent as DisplayObjectContainer;
		}
		
		private function init():void {
			media_list = stage.getChildByName("media_list");
			media_list.setRendererStyle("textFormat", tfList);
			media_list.setRendererStyle("embedFonts", true);
			media_list.addEventListener(ListEvent.ITEM_CLICK, playListSelected);
			media_list.visible = false;
			media_list.alpha = 0;
		}
		
		private function playListSelected(e:ListEvent):void {
			sendNotification(ApplicationFacade.CHANGE_PLAYLIST, e.item.data);
		}
	}
}