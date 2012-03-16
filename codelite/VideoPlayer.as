/**
 * VideoClass
 * Author: codelite
 * Description: Manages the video instance
 *
 */
package codelite
{
	// flash classes
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.media.Video;
	import flash.media.SoundTransform;
	import flash.net.NetStream;
	import flash.net.NetConnection;
	import flash.net.URLRequest;
	import flash.events.NetStatusEvent
	import flash.events.Event;

	// custom classes
	import codelite.utils.Config;

	public class VideoPlayer extends Sprite
	{
		  private var _id					:int 			= 0;        // selected item id
		  private var _netcon				:NetConnection  = null;		// net connection instance
		  private var _netstr				:NetStream 		= null;		// net stream instance
		  private var _normalVideo			:Video			= null;		// video class instance
		  private var _utubeVideo			:*				= null		// youtbe instance
		  private var _loader				:Loader   		= null;		// loader for the youtube api player
		  private var _customClient		    :Object 		= null;		// client info
		  private var _link				    :String 		= "";		// link to the video file
		  private var _volume			    :Boolean 		= false;		// volume
		  private var _type                 :String         = "";       // type of the video
		  private var _checker				:Boolean		= false;	// if video should restart when sound button is pressed
		  private var _parent				:Display  		= null 		// parent reference

		/** constructor **/
		public function VideoPlayer($parent:Display, $id:int):void
		{
			_parent = $parent //set parent reference

			_id = $id;

			// set the link to the video
			_link = Config.ITEM_VIDEO($id);

			// what type of video are we playing
			 if (_link.toLowerCase().indexOf("youtube.com") != -1)
			{
				_type = "youtube";
				SetupYoutube();
			}else{
				_type = "http";
				DrawBackground();
				SetupNetConnection();
			}
		}

		/** draw the background  **/
		private function DrawBackground()
		{
			this.graphics.beginFill(0x990000,0);
			this.graphics.drawRect(0,0,Config.ITEM_VIDEO_WIDTH(_id), Config.ITEM_VIDEO_HEIGHT(_id));
			this.graphics.endFill();
		}

		/** Setup Net Connection **/
		private function SetupNetConnection():void
		{

			// if there's a net connection destroy it
			if(_netcon != null)
			{
				_netcon.close();
				_netcon.removeEventListener(NetStatusEvent.NET_STATUS, NetStatus);
				_netcon = null;
			}
			// if there's a net stream destroy it
			if(_netstr != null)
			{
				_netstr.close();
				_netstr.removeEventListener(NetStatusEvent.NET_STATUS, NetStatus);
				_netstr = null;
			}

			// create new net connection
			_netcon = new NetConnection();
			_netcon.addEventListener(NetStatusEvent.NET_STATUS, NetStatus, false, 0, true);

			// connect
			_netcon.connect(null);

		}

		/** events for the net instance */
		private function NetStatus($e:NetStatusEvent):void
		{
			switch ($e.info.code)
			{
				case "NetConnection.Connect.Success": // if connected create the net stream

													  SetupNetStream();
													  break;

													   // when the vide has ended
				case "NetStream.Play.Stop"			: Display(parent).EndOfVideo();
													   break;

			}
		}

		/** setup the net stream instance **/
		private function SetupNetStream():void
		{

			// create the informations about the video
			_customClient = new Object();
			_customClient.onMetaData = onMetaData;

			// create a new net stream
			_netstr = new NetStream(_netcon);
			_netstr.client = _customClient;
			_netstr.bufferTime = 3;
			if(!_volume) _netstr.soundTransform = new SoundTransform(0);
			_netstr.addEventListener(NetStatusEvent.NET_STATUS, NetStatus, 	false, 0, true);


			// setup video
			_normalVideo = new Video();
			_normalVideo.attachNetStream(_netstr);
			_normalVideo.smoothing = true;

			_normalVideo.width  = Config.ITEM_VIDEO_WIDTH(_id);
			_normalVideo.height = Config.ITEM_VIDEO_HEIGHT(_id);

			//add video
			addChild(_normalVideo);

			//call when video is stared
			_parent.StartOfVideo();

			// play video
			Play();
		}

		/** video data is accessible  **/
		private function onMetaData($info:Object):void
		{

		}

		/** setup youtube player **/
		private function SetupYoutube():void
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.INIT, OnLoaderInit, false, 0, true);
			_loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
		}

		/** if the youtube player is loaded */
		private function OnLoaderInit($e:Event):void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.INIT, OnLoaderInit);
			_loader.content.addEventListener("onReady", 	  OnPlayerReady);
			_loader.content.addEventListener("onStateChange", OnPlayerStateChange);
		}

		/** if the api is ready setup the youtube player */
		function OnPlayerReady($e:Event):void
		{
			_utubeVideo = _loader.content;

			_utubeVideo.setSize(Config.ITEM_VIDEO_WIDTH(_id),  Config.ITEM_VIDEO_HEIGHT(_id));

			// remove any mouse interactivity
			_utubeVideo.mouseEnabled = false;
			_utubeVideo.mouseChildren = false;

			_utubeVideo.loadVideoByUrl(_link);

		}

		/** when youtube player changes it's state */
		function OnPlayerStateChange(event:Event):void
		{
			//_display.SetTotalTime(GetYoutubeTotalDuration());
			if (Object(event).data == 1)
			{
				var $w:Number =  _utubeVideo.width;
				var $h:Number =  _utubeVideo.height;

				_utubeVideo.setSize(Config.ITEM_VIDEO_WIDTH(_id), Config.ITEM_VIDEO_HEIGHT(_id))

				if(!_volume) _utubeVideo.setVolume(0);
				_utubeVideo.playVideo();
				addChild(_utubeVideo);

				Display(parent).StartOfVideo();

			}else if (Object(event).data == 0){
				Display(parent).EndOfVideo();
			}
		}

		/** play video **/
		public function Play():void
		{
			if (_type == "youtube")
			{
					_utubeVideo.playVideo();
			}else{
				   _netstr.play(_link);
			}
		}

		/** set the volume of the video player */
		public function ControlVolume():void
		{
			if(_volume==0) _volume = true;
			else           _volume = false;

			if(_type == "youtube")
			{
				if(_volume) _utubeVideo.setVolume(100);
				else		_utubeVideo.setVolume(0);
			}else {
				if(_volume) _netstr.soundTransform = new SoundTransform(1);
				else	    _netstr.soundTransform = new SoundTransform(0);
			}
		}

		/** jump to a certain position in the timeline of the video **/
		public function SeekToPosition():void
		{

			if(!_checker)
			{
				if(_type == "youtube")
				{
					_utubeVideo.seekTo(0);
				}else{
					_netstr.seek(0);
				}

				_checker = true;
			}
		}
	}
}