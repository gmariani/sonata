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
	
	import flash.display.DisplayObject;
	import gs.TweenLite;

	public class ChangeScreenCommand extends SimpleCommand implements ICommand {
		
		override public function execute(note:INotification):void {
			var medStage:StageMediator = facade.retrieveMediator(StageMediator.NAME) as StageMediator;
			var arrScreens:Array = medStage.getScreens();
			var doTarg:DisplayObject = note.getBody() as DisplayObject;
			var n:int = arrScreens.length;
			
			for (var i:int = 0; i < n; i++) {
				if (arrScreens[i] != doTarg) TweenLite.to(arrScreens[i], 0.5, { autoAlpha:0 });
			}
			
			TweenLite.to(doTarg, 0.5, { autoAlpha:1 } );
		}
	}
}