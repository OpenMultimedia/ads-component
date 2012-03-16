/**
 * Display
 * Author: codelite
 * Description: display content
 *
 */
package codelite
{
	/** flash classes **/
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;

	/** custom classes **/
	import codelite.utils.Public;
	import codelite.utils.Config;
	import codelite.events.FXEvents;

	CONFIG::DEBUG {
	import net.kgdesignes.utils.Console;
	}

	public class Display extends Sprite
	{
		private var _id      :int    = 0;    // the item id
		private var _poster  :Poster = null; // poster object
		private var _video   :VideoPlayer  = null; // video object
		private var _clone	 :Bitmap = null;	// cloned poster for msk effect
		private var _mask    :MovieClip  = null; // mask object
		private var _hud:Hud = null;			// hud object instance

		public function Display()
		{
			// draws the background
			DrawBackground();

			// random if there are more than one items in the list
			_id = Math.round(Math.random()*(Config.ITEMS_NUMBER()-1));

			// create a new poster
			_poster = new Poster(_id);
			addChild(_poster);
		}

		/** initialize **/
		public function Init($clone:Bitmap):void
		{
			// add events to poster
			_poster.addEventListener(MouseEvent.CLICK, Jump, false, 0, true);
			_poster.buttonMode = true;

			CONFIG::DEBUG { Console.log("Poster created"); }

			// creates a new hud object
			 _hud = new Hud(_id);

			CONFIG::DEBUG { Console.log("HUD created"); }

			CONFIG::DEBUG { Console.log("Cargando Video con ID: ", _id); }

			// cretae new video item
			_video = new VideoPlayer(this, _id);
			_video.x = Config.ITEM_VIDEO_X(_id);
			_video.y = Config.ITEM_VIDEO_Y(_id);

			// add events to video
			_video.addEventListener(MouseEvent.CLICK, Jump, false, 0, true);
			_video.buttonMode = true;

			if(Config.MASK())
			{

				// setup the cloned poster
				_clone =$clone;

				// create mask from Library

				var Mask:*;

				var  $type:String = Config.ITEM_MASK(_id);

				switch($type)
				{
						  case "1"      :
						  case "2"      :
						  case "3"      :
						  case "4"      :
						  case "5"      :
						  case "6"      :
						  case "7"      :
						  case "8"      :
						  case "9"      :
						  case "10"   	: Mask = getDefinitionByName("mask"+$type) as Class;
										  break;

						  case "random" : Mask = getDefinitionByName("mask"+(Math.round(Math.random()*(12-1)+1))) as Class;
										  break;
				}

				// create the mask from a custom object
				_mask = new Mask ();

				// setup mask
				_mask.width = Config.ITEM_VIDEO_WIDTH(_id);
				_mask.height = Config.ITEM_VIDEO_HEIGHT(_id);

				_mask.x = Config.ITEM_VIDEO_X(_id);
				_mask.y = Config.ITEM_VIDEO_Y(_id);

				// stop mask animation
				_mask.gotoAndStop(0);

			}

			//add video to display list
			addChild(_video);

			//add hud to display list
			addChild(_hud);

		}


		/** if the transitions effect has ended */
		private function FXStop($e:FXEvents):void
		{
			//remove events we dont longer need
			_mask.removeEventListener("fx_stop", FXStop);
			_mask.removeEventListener(Event.ENTER_FRAME, PlayMask);

			// remove clone from stage
			removeChild(_clone);
			removeChild(_mask);

			// hide video
			_video.visible=false;

			// show the replay button
			_hud.ShowReplay();
		}


		/** Draw background **/
		private function DrawBackground():void
		{
			this.graphics.clear();
			this.graphics.beginFill(Config.BACKGROUND_COLOR())
			this.graphics.drawRect(0,0,Public.GetStage().stageWidth, Public.GetStage().stageHeight);
			this.graphics.endFill();
		}

		/** video has started **/
		public function StartOfVideo():void
		{
			// show sound button
			_hud.ShowSound();
		}

		/** video has ended **/
		public function EndOfVideo():void
		{
			// hide sound button
			_hud.HideSound();

			if(Config.MASK())
			{
				// reset mask pisition
				_mask.gotoAndStop(0)

				// recreate mask event
				_mask.addEventListener("fx_stop", FXStop, false, 0, true);


				// add mask and poster
				addChild(_clone);
				addChild(_mask);

				_clone.mask = _mask;

				_mask.addEventListener(Event.ENTER_FRAME, PlayMask, false, 0, true);
			}else{
				// hide video
				_video.visible=false;

				// show the replay button
				_hud.ShowReplay();
			}
		}

		/** plays the mask effect */
		private function PlayMask($e:Event):void
		{
			if (_mask.currentFrame< _mask.totalFrames)
			{
			    _mask.gotoAndStop(_mask.currentFrame+1);
			} else{
				_mask.gotoAndStop(_mask.totalFrames);
			}
		}



		/** when sound button was pressed **/
		public function SoundControl():void
		{
			_video.ControlVolume();

			// if the video should restart when the sound on is used for the first one
			if(Config.RESTART_ON_FIRST_SOUND())
			{
				_video.SeekToPosition();
			}
		}

		/** when replay button was pressed **/
		public function VideoControl():void
		{
			StartOfVideo();
			_video.visible=true;
			_video.Play();
		}

		/** when tthe component is pressed **/
		private function Jump($e:MouseEvent):void
		{
			navigateToURL(new URLRequest(Config.ITEM_LINK(_id)),Config.ITEM_LINK_METHOD(_id));
		}
	}
}