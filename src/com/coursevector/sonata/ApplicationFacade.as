////////////////////////////////////////////////////////////////////////////////
//
//  COURSE VECTOR
//  Copyright 2008 Course Vector
//  All Rights Reserved.
//
//  NOTICE: Course Vector permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
/**
* ...
* @author Gabriel Mariani
* @version 0.1
*/

package com.coursevector.sonata {
	
    import org.puremvc.as3.multicore.interfaces.IFacade;
    import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	
	import com.coursevector.sonata.controller.StartupCommand;
	import com.coursevector.sonata.controller.ChangeScreenCommand;
	import com.coursevector.sonata.controller.ChangePlaylistCommand;
	import com.coursevector.sonata.controller.LyricsCommand;
	
	import flash.display.DisplayObjectContainer;
    
    public class ApplicationFacade extends Facade implements IFacade {
		
		public static const VERSION:String = "0.1.0";
		
        // Notification name constants
        public static const STARTUP:String = "startup";
        public static const CHANGE_PLAYLIST:String = "changePlayList";
        public static const NEW_PLAYLIST:String = "newPlayList";
        public static const CHANGE_SCREEN:String = "changeScreen";
        public static const FIND_LYRICS:String = "findLyrics";
        public static const FOUND_LYRICS:String = "foundLyrics";
        public static const METADATA:String = "metadata";
		
		public function ApplicationFacade(key:String) {
			super(key);	
		}
		
		/**
         * Singleton ApplicationFacade Factory Method
         */
        public static function getInstance(key:String):ApplicationFacade {
            if (instanceMap[key] == null) instanceMap[key] = new ApplicationFacade(key);
            return instanceMap[key] as ApplicationFacade;
        }
		
		/**
         * Application startup
         * 
         * @param app a reference to the application component 
         */  
        public function startup(app:DisplayObjectContainer):void {
        	sendNotification(ApplicationFacade.STARTUP, app);
        }
		
		/**
         * Singleton ApplicationFacade Factory Method
         */
        /*public static function getInstance():ApplicationFacade {
            if (instance == null) instance = new ApplicationFacade();
            return instance as ApplicationFacade;
        }*/
		/*public function ApplicationFacade(o:DisplayObjectContainer) {
			instance = this;
			initializeFacade();	
			instance.notifyObservers(new Notification(ApplicationFacade.STARTUP, o));
		}*/
		
		/*public function startUp(o:DisplayObject):void {
			notifyObservers(new Notification(ApplicationFacade.STARTUP, o));
		}*/
		
        /**
         * Register Commands with the Controller 
         */
        override protected function initializeController():void {
			super.initializeController();
			
			registerCommand(ApplicationFacade.STARTUP, StartupCommand);
			registerCommand(ApplicationFacade.CHANGE_SCREEN, ChangeScreenCommand);
			registerCommand(ApplicationFacade.CHANGE_PLAYLIST, ChangePlaylistCommand);
			registerCommand(ApplicationFacade.FIND_LYRICS, LyricsCommand);
        }
    }
}