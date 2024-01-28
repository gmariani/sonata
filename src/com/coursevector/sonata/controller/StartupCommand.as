/**
* 
* Initializes the Model and Views and their sub components.
* 
* @author Default
* @version 0.1
*/

package com.coursevector.sonata.controller {
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	
	import com.coursevector.sonata.controller.PrepModelCommand;
	import com.coursevector.sonata.controller.PrepViewCommand;

	public class StartupCommand extends MacroCommand {
		
		override protected function initializeMacroCommand():void {
			addSubCommand(PrepViewCommand);
			addSubCommand(PrepModelCommand);
		}
	}
}