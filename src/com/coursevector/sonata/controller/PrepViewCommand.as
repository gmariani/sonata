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
	
	import com.coursevector.sonata.ApplicationFacade;
	import com.coursevector.sonata.view.StageMediator;
	import com.coursevector.sonata.view.PlayListsMediator;
	import com.coursevector.sonata.view.TempoMediator;
	import com.coursevector.sonata.view.LyricsMediator;
	import com.coursevector.sonata.view.InfoMediator;
	import com.coursevector.sonata.view.LibraryMediator;
	
	import flash.display.DisplayObjectContainer;

	public class PrepViewCommand extends SimpleCommand implements ICommand {
		
		override public function execute(note:INotification):void {
			var stage:DisplayObjectContainer = note.getBody() as DisplayObjectContainer;
			facade.registerMediator(new StageMediator(stage));
			facade.registerMediator(new PlayListsMediator(stage));
			facade.registerMediator(new LyricsMediator(stage));
			facade.registerMediator(new InfoMediator(stage));
			facade.registerMediator(new LibraryMediator(stage));
			facade.registerMediator(new TempoMediator(stage));
		}
	}
}