//http://lyricsfly.com/api/
//http://lyricsfly.com/api/api.php?i=[USERID]&a=[ARTIST]&t=[TITLE]
//http://lyricsfly.com/api/crossdomain.xml

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
	import flash.net.URLVariables;
	import flash.system.Security;

	public class LyricsProxy extends Proxy implements IProxy {

		public static const NAME:String = 'LyricsProxy';
		private static const USERID:String = '';

		public function LyricsProxy() {
            super(NAME);

			Security.loadPolicyFile("http://lyricsfly.com/api/crossdomain.xml");
		}

		public function searchSong(strArtist:String, strTitle:String):void {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.addEventListener(Event.COMPLETE, completeHandler);


			var request:URLRequest = new URLRequest("http://lyricsfly.com/api/api.php");
			var variables:URLVariables = new URLVariables();
			variables.i = USERID;
            variables.a = strArtist;
            variables.t = strTitle;
            request.data = variables;

			try {
				loader.load(request);
			} catch (error:Error) {
				trace("Unable to load requested document.");
			}
		}

		private function completeHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			var xml:XML = XML(loader.data);
			var strLyrics:String = "No lyrics found.";

			if(xml.hasOwnProperty("sg")) strLyrics = xml.sg.tx.text();
			//if(xml.hasOwnProperty("sg")) strLyrics = xml.sg.tx.toString().split("[br]").join("");
			//if(xml.hasOwnProperty("sg")) strLyrics = xml.sg.tx.toString().split("[br]").join("<br>");

			sendNotification(ApplicationFacade.FOUND_LYRICS, strLyrics);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
		}
	}
}