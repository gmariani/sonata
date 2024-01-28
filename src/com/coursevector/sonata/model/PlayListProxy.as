package com.coursevector.sonata.model {
	
	import fl.data.DataProvider;
    import org.puremvc.as3.multicore.interfaces.IProxy;
    import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	import com.coursevector.sonata.ApplicationFacade;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class PlayListProxy extends Proxy implements IProxy {
		
		public static const NAME:String = 'PlayListProxy';
		
		private var _dp:DataProvider;
		
		public function PlayListProxy() {
            super(NAME);
		}
		
		override public function initializeNotifier(key:String):void {
			super.initializeNotifier(key);
			
			getPlayLists();
		}
		
		private function getPlayLists():void {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.addEventListener(Event.COMPLETE, completeHandler);
			
			var request:URLRequest = new URLRequest("Tempo.php?action=getPlayLists");
			try {
				loader.load(request);
			} catch (error:Error) {
				trace("Unable to load requested document.");
			}
		}
		
		private function completeHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			var xml:XML = XML(loader.data);
			_dp = new DataProvider();
			
			for each (var node:XML in xml..playlist) {
				var strURL:String = node.toString();
				_dp.addItem({label:getFileName(strURL),data:strURL});
			}
			
			sendNotification(ApplicationFacade.NEW_PLAYLIST, _dp);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}
		
		private function getFileName(s:String):String {
			var arrURL:Array = (s.indexOf("\\") != -1) ? s.split("\\") : s.split("/");
			var strFileName:String = arrURL[arrURL.length - 1];
			return strFileName.substr(0, -4);
		}
	}
}