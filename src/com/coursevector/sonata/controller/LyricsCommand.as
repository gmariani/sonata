/**
* 
* Initializes the StageMediator and passes the stage reference
* 
* @author Default
* @version 0.1
*/

package com.coursevector.sonata.controller {
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import com.coursevector.sonata.model.LyricsProxy;

	public class LyricsCommand extends SimpleCommand implements ICommand {
		
		override public function execute(note:INotification):void {
			var lP:LyricsProxy = facade.retrieveProxy(LyricsProxy.NAME) as LyricsProxy;
			var o:Object = note.getBody();
			lP.searchSong(o.artist, o.title);
		}
	}
}