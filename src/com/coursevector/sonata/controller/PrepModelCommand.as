/**
* 
* Initializes the proxies
* 
* @author Default
* @version 0.1
*/

package com.coursevector.sonata.controller {
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	import com.coursevector.sonata.ApplicationFacade;
	import com.coursevector.sonata.model.InfoProxy;
	import com.coursevector.sonata.model.LyricsProxy;
	import com.coursevector.sonata.model.PlayListProxy;

	public class PrepModelCommand extends SimpleCommand implements ICommand {
		
		override public function execute(note:INotification):void {
			//facade.registerProxy(new InfoProxy());
			facade.registerProxy(new LyricsProxy());
			facade.registerProxy(new PlayListProxy());
			
			sendNotification(ApplicationFacade.INITIALIZED);
		}
	}
}