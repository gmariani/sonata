package com.coursevector.sonata {
	
	import flash.display.MovieClip;
	import com.coursevector.display.SpectrumAnalyzer;
	import com.coursevector.tempo.TempoLite;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.display.SimpleButton;
	import flash.text.TextField;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import fl.events.SliderEvent;
	import fl.events.ListEvent;
	import gs.TweenLite;
	import flash.text.TextFormat;
	import flash.media.Video;
	
	public class Main extends MovieClip {
		
		private var specAn:SpectrumAnalyzer = new SpectrumAnalyzer();
		private var isSeeking:Boolean = false;
		
		public function Sonata() {
			init();
		}
		
		private function init() {
			//populatePlayLists();
			tempo.loadPlayList("playlists/Tempo.m3u");
			
			// Spectrum Analyzer
			specAn.x = 55;
			specAn.y = 570;
			specAn.barWidth = 5;
			specAn.barAmount = 26;
			specAn.lineSpace = 2;
			specAn.showPeaks = false;
			specAn.plotHeight = 30;
			this.addChild(specAn);
			
			setButtonLabels(mcList, "Playlist", "Show playlist");
			mcList.addEventListener(MouseEvent.CLICK, clickHandler);
			setButtonLabels(mcInfo, "Information", "Shows track & artist information");
			setButtonLabels(mcPlaylists, "Playlists", "Show, choose & edit playlists");
			mcPlaylists.addEventListener(MouseEvent.CLICK, clickHandler);
			setButtonLabels(mcMusic, "Music Library", "Show the Library filter");
			setButtonLabels(mcLyrics, "Lyrics", "Show track lyrics");
			
			tempo.addEventListener(TempoLite.PLAY_PROGRESS, tempoHandler);
			tempo.addEventListener(TempoLite.PLAY_COMPLETE, tempoHandler);
			tempo.addEventListener(TempoLite.LOAD_START, tempoHandler);
			tempo.addEventListener(TempoLite.LOAD_PROGRESS, tempoHandler);
			tempo.addEventListener(TempoLite.VIDEO_METADATA, tempoHandler);
			tempo.addEventListener(TempoLite.AUDIO_METADATA, tempoHandler);
			tempo.addEventListener(TempoLite.REFRESH_PLAYLIST, tempoHandler);
			tempo.addEventListener(TempoLite.NEW_PLAYLIST, tempoHandler);
			tempo.addEventListener(TempoLite.CHANGE, tempoHandler);
			tempo.setVideoScreen(vidScreen);
			
			btnPrev.addEventListener(MouseEvent.CLICK, clickHandler);
			btnPlay.addEventListener(MouseEvent.CLICK, clickHandler);
			btnStop.addEventListener(MouseEvent.CLICK, clickHandler);
			btnPause.addEventListener(MouseEvent.CLICK, clickHandler);
			btnNext.addEventListener(MouseEvent.CLICK, clickHandler);
			
			// Volume
			volume_slider.maximum = 1;
			volume_slider.minimum = 0;
			volume_slider.snapInterval = 0.01;
			volume_slider.liveDragging = true;
			tempo.volume = volume_slider.value = .5;
			txtVolume.text = "50%";
			volume_slider.addEventListener(SliderEvent.CHANGE, volumeHandler);
			
			// Playhead
			playhead_slider.maximum = 1;
			playhead_slider.minimum = 0;
			playhead_slider.snapInterval = 0.01;
			playhead_slider.value = 0;
			playhead_slider.addEventListener(SliderEvent.THUMB_PRESS, playheadHandler);
			playhead_slider.addEventListener(SliderEvent.THUMB_RELEASE, playheadHandler);
			playhead_slider.addEventListener(SliderEvent.THUMB_DRAG, playheadHandler);
			playhead_slider.addEventListener(SliderEvent.CHANGE, playheadHandler);
			
			// Mute
			mcMute.gotoAndStop(1);
			mcMute.addEventListener(MouseEvent.CLICK, clickHandler);
			
			media_list.visible = false;
			media_list.alpha = 0;
			
			var tf:TextFormat = new TextFormat();
			tf.font = "Avenir LT Std 35 Light";
			media_list.setRendererStyle("textFormat", tf);
			media_list.setRendererStyle("embedFonts", true);
			media_list.addEventListener(Event.CHANGE, playListSelected);
			
			song_list.setRendererStyle("textFormat", tf);
			song_list.setRendererStyle("embedFonts", true);
			song_list.addEventListener(ListEvent.ITEM_CLICK, listHandler);
		}
		
		function clickHandler(e:MouseEvent):void {
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
				case mcPlaylists:
					TweenLite.to(media_list, 0.5, { autoAlpha:1 } );
					TweenLite.to(song_list, 0.5, { autoAlpha:0 } );
					break;
				case mcList:
					TweenLite.to(media_list, 0.5, { autoAlpha:0 } );
					TweenLite.to(song_list, 0.5, { autoAlpha:1 } );
					break;
				/*case btnClear:
					tempo.clear();
					break;*/
			}
		}

		private function setButtonLabels(mc:MovieClip, strTitle:String, strDesc:String):void {
			var txtTitle:TextField = mc.getChildByName("txtTitle");
			var txtDesc:TextField = mc.getChildByName("txtDesc");
			
			txtTitle.text = strTitle;
			txtTitle.mouseEnabled = false;
			txtDesc.text = strDesc;
			txtDesc.mouseEnabled = false;
		}

		private function populatePlayLists():void {
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.addEventListener(Event.COMPLETE, playlistCompleteHandler);

			var request:URLRequest = new URLRequest("Tempo.php?action=getPlayLists");
			try {
				loader.load(request);
			} catch (error:Error) {
				trace("Unable to load requested document.");
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
					tempo.seek(playhead_slider.value);
					break;
			}
		}
		
		private function playlistCompleteHandler(event:Event):void {
			var loader:URLLoader = URLLoader(event.target);
			var xml:XML = XML(loader.data);
			media_list.removeAll();
			
			for each (var node:XML in xml..playlist) {
				var strURL:String = node.toString();
				media_list.addItem({label:getFileName(strURL),data:strURL});
			}
		}

		private function playListSelected(e:Event):void {
			tempo.loadPlayList(media_list.selectedItem.data);
		}
		
		private function listHandler(e:ListEvent):void {
			tempo.play(e.rowIndex);
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
					//txtTitle.text = tempo.getMetaData().TIT2;
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