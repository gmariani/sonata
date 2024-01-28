/**
* 
* 
* 
* @author Default
* @version 0.1
*/

package com.coursevector.sonata.view {
	
	
	
	import com.coursevector.media.VideoFacade;
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import com.coursevector.sonata.ApplicationFacade;
	import com.coursevector.tempo.TempoLite;
	import com.coursevector.controls.Slider;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import fl.events.SliderEvent;
	import fl.events.ListEvent;
	import fl.controls.List;
	import flash.text.TextField;
	import gs.TweenLite;
	import flash.text.TextFormat;
	import flash.events.Event;
	
	public class TempoMediator extends Mediator implements IMediator {
		
		public static const NAME:String = 'TempoMediator';
		
		private var isSeeking:Boolean = false;
		private var tempo:TempoLite;
		private var volume_slider:Slider;
		private var playhead_slider:Slider;
		private var mcMute:MovieClip;
		private var btnPrev:SimpleButton;
		private var btnPlay:SimpleButton;
		private var btnStop:SimpleButton;
		private var btnPause:SimpleButton;
		private var btnNext:SimpleButton;
		private var txtTime:TextField;
		private var txtVolume:TextField;
		private var song_list:List;
		private var tfList:TextFormat = new TextFormat();
		
		public function TempoMediator(viewComponent:Object) {
			super(NAME, viewComponent);
			init();
		}
		
		public function loadPlayList(strURL:String):void {
			tempo.loadPlayList(strURL);
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
		
		private function get stage():DisplayObjectContainer {
			return viewComponent as DisplayObjectContainer;
		}
		
		private function init():void {
			tempo = stage.getChildByName("tempo");
			txtTime = stage.getChildByName("txtTime");
			txtVolume = stage.getChildByName("txtVolume");
			song_list = stage.getChildByName("song_list");
			tfList.font = "Avenir LT Std 35 Light";
			
			tempo.addEventListener(TempoLite.PLAY_PROGRESS, tempoHandler);
			tempo.addEventListener(TempoLite.PLAY_COMPLETE, tempoHandler);
			tempo.addEventListener(TempoLite.LOAD_START, tempoHandler);
			tempo.addEventListener(TempoLite.LOAD_PROGRESS, tempoHandler);
			tempo.addEventListener(TempoLite.VIDEO_METADATA, tempoHandler);
			tempo.addEventListener(TempoLite.AUDIO_METADATA, tempoHandler);
			tempo.addEventListener(TempoLite.REFRESH_PLAYLIST, tempoHandler);
			tempo.addEventListener(TempoLite.NEW_PLAYLIST, tempoHandler);
			tempo.addEventListener(TempoLite.CHANGE, tempoHandler);
			tempo.setVideoScreen(stage.getChildByName("vidScreen"));
			
			btnPrev = stage.getChildByName("btnPrev");
			btnPlay = stage.getChildByName("btnPlay");
			btnStop = stage.getChildByName("btnStop");
			btnPause = stage.getChildByName("btnPause");
			btnNext = stage.getChildByName("btnNext");
			btnPrev.addEventListener(MouseEvent.CLICK, clickHandler);
			btnPlay.addEventListener(MouseEvent.CLICK, clickHandler);
			btnStop.addEventListener(MouseEvent.CLICK, clickHandler);
			btnPause.addEventListener(MouseEvent.CLICK, clickHandler);
			btnNext.addEventListener(MouseEvent.CLICK, clickHandler);
			
			// Volume
			volume_slider = stage.getChildByName("volume_slider");
			volume_slider.maximum = 1;
			volume_slider.minimum = 0;
			volume_slider.snapInterval = 0.01;
			volume_slider.liveDragging = true;
			tempo.volume = volume_slider.value = .5;
			txtVolume.text = "50%";
			volume_slider.addEventListener(SliderEvent.CHANGE, volumeHandler);
			
			// Playhead
			playhead_slider = stage.getChildByName("playhead_slider");
			playhead_slider.maximum = 1;
			playhead_slider.minimum = 0;
			playhead_slider.snapInterval = 0.01;
			playhead_slider.value = 0;
			playhead_slider.addEventListener(SliderEvent.THUMB_PRESS, playheadHandler);
			playhead_slider.addEventListener(SliderEvent.THUMB_RELEASE, playheadHandler);
			playhead_slider.addEventListener(SliderEvent.THUMB_DRAG, playheadHandler);
			playhead_slider.addEventListener(SliderEvent.CHANGE, playheadHandler);
			
			// Mute
			mcMute = stage.getChildByName("mcMute");
			mcMute.gotoAndStop(1);
			mcMute.addEventListener(MouseEvent.CLICK, clickHandler);
			
			song_list.setRendererStyle("textFormat", tfList);
			song_list.setRendererStyle("embedFonts", true);
			song_list.addEventListener(ListEvent.ITEM_CLICK, listHandler);
		}
		
		private function clickHandler(e:MouseEvent):void {
			switch(e.currentTarget) {
				case btnPrev:
					tempo.previous();
					break;
				case btnPlay:
					tempo.play();
					break;
				case btnStop:
					tempo.stop();
					break;
				case btnPause:
					tempo.pause();
					break;
				case btnNext:
					tempo.next();
					break;
				case mcMute:
					if (mcMute.currentFrame == 1) {
						mcMute.gotoAndStop(2);
						tempo.setMute(true);
					} else {
						mcMute.gotoAndStop(1);
						tempo.setMute(false);
					}
					break;
			}
		}
		
		private function volumeHandler(e:SliderEvent):void {
			tempo.volume = volume_slider.value;
			txtVolume.text = int(tempo.volume * 100) + "%";
		}
		
		private function playheadHandler(e:SliderEvent):void {
			switch(e.type) {
				case SliderEvent.THUMB_PRESS :
					isSeeking = true;
					break;
				case SliderEvent.THUMB_RELEASE :
					isSeeking = false;
					break;
				case SliderEvent.THUMB_DRAG : 
					break;
				case SliderEvent.CHANGE :
					// seek
					tempo.seekPercent(playhead_slider.value);
					break;
			}
		}
		
		private function listHandler(e:ListEvent):void {
			tempo.play(e.rowIndex);
		}
		
		private function tempoHandler(e:Event):void {
			switch(e.type) {
				case TempoLite.PLAY_PROGRESS :
					playhead_slider.value = tempo.getCurrentPercent() / 100;
					txtTime.text = tempo.getTimeCurrent();
					break;
				case TempoLite.PLAY_COMPLETE :
					//trace("PLAY_COMPLETE");
					break;
				case TempoLite.LOAD_START :
					//load_bar.setProgress(0, 100);
					//txtTitle.text = "";
					break;
				case TempoLite.LOAD_PROGRESS :
					//load_bar.setProgress(tempo.getLoadCurrent(), tempo.getLoadTotal());
					break;
				case TempoLite.VIDEO_METADATA :
					//trace("VIDEO_METADATA");
					break;
				case TempoLite.AUDIO_METADATA :
					sendNotification(ApplicationFacade.METADATA, tempo.getMetaData());
					break;
				case TempoLite.REFRESH_PLAYLIST :
				case TempoLite.NEW_PLAYLIST :
					song_list.dataProvider = tempo.getList().toDataProvider();
					song_list.selectedIndex = tempo.getList().index;
					break;
				case TempoLite.CHANGE :
					song_list.selectedIndex = tempo.getList().index;
					song_list.scrollToIndex(song_list.selectedIndex);
					break;
			}
		}
	}
}