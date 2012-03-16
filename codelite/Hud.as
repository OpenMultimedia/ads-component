/**
 * Hud
 * Author: codelite
 * Description: add buttons
 *
 */
package codelite
{
    /** flash classes **/
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/** custom classes **/
	import codelite.utils.Button;
	import codelite.utils.Config;
	import codelite.utils.Public;

	public class Hud extends Sprite
	{
		private const _LOCALIZATION:Object = {
			'es': {
				'sound_on': 'Activar audio',
				'sound_off': 'Desactivar audio',
				'replay_video': 'Reproducir nuevamente'
			}
		}

		private var _soundBtn:Button = null;		// sound button object
		private var _replayBtn:Button = null;		// play video object

		public function Hud($id:int)
		{
			var $o:Object = null; // use to store the position of buttons

			// new sound object
			_soundBtn = new Button(_LOCALIZATION['es']['sound_on']);

			$o = SetSoundPosition(Config.SOUND_POSITION($id),$id);

			//position
			_soundBtn.x =  $o.x;
			_soundBtn.y =  $o.y;

			//events for the button
			_soundBtn.addEventListener(MouseEvent.CLICK, SoundEventFunction, false, 0, true);
			_soundBtn.visible = false;

			//add to display list
			addChild(_soundBtn);

			// new sound object
			_replayBtn = new Button(_LOCALIZATION['es']['replay_video']);
			_replayBtn.visible = false;

			//events for the button
			_replayBtn.addEventListener(MouseEvent.CLICK, ReplayEventFunction, false, 0, true);


			$o = SetReplayPosition(Config.REPLAY_POSITION($id));

			//position
			_replayBtn.x = $o.x;
			_replayBtn.y = $o.y;

			//add to display list
			addChild(_replayBtn);
		}

		/** Sound button events **/
		public function SoundEventFunction($e:MouseEvent):void
		{
			if(_soundBtn.ReturnLabel() == _LOCALIZATION['es']['sound_on'])  _soundBtn.ChangeLabel(_LOCALIZATION['es']['sound_off']);
			else                                       _soundBtn.ChangeLabel(_LOCALIZATION['es']['sound_on']);

			Display(parent).SoundControl();
		}

		/** replay button events **/
		private function ReplayEventFunction($e:MouseEvent):void
		{
			Display(parent).VideoControl();

			HideReplay();
		}

		/** returns the position of the sound  button **/
		private function SetSoundPosition($p:String, $id:int):Object
		{
			// used to store position
			var $o:Object = null;

			switch( $p )
			{
				case "top_left":
				{
					$o = {
							x: Config.ITEM_VIDEO_X($id),
					       	y: Config.ITEM_VIDEO_Y($id)
						 };

					break;
				}

				case "top_middle":
				{

					$o = {
							x: Config.ITEM_VIDEO_X($id) + (Config.ITEM_VIDEO_WIDTH($id)/2)- _soundBtn.width/2,
							y: Config.ITEM_VIDEO_Y($id)
						 };

					break;
				}

				case "top_right":
				{
					$o = {
							x: Config.ITEM_VIDEO_X($id) + Config.ITEM_VIDEO_WIDTH($id) - _soundBtn.width,
							y: Config.ITEM_VIDEO_Y($id)
						 };

					break;
				}

				case "bottom_left":
				{

					$o = {
							x: Config.ITEM_VIDEO_X($id),
							y: Config.ITEM_VIDEO_Y($id) + Config.ITEM_VIDEO_HEIGHT($id)- _soundBtn.height
						 };

					break;
				}

				case "bottom_middle":
				{
					$o = {
							x: Config.ITEM_VIDEO_X($id) + Config.ITEM_VIDEO_WIDTH($id)/2- _soundBtn.width/2,
							y: Config.ITEM_VIDEO_Y($id) + Config.ITEM_VIDEO_HEIGHT($id)- _soundBtn.height
						 };

					break;
				}

				case "bottom_right":
				{

					$o = {
							x: Config.ITEM_VIDEO_X($id) + Config.ITEM_VIDEO_WIDTH($id)- _soundBtn.width,
							y: Config.ITEM_VIDEO_Y($id) + Config.ITEM_VIDEO_HEIGHT($id)- _soundBtn.height
						 };

					break;
				}
			}

			return $o;

		}

		/** returns the position of the replay  button **/
		private function SetReplayPosition($p:String):Object
		{
			// used to store position
			var $o:Object = null;

			switch( $p )
			{
				case "top_left":
				{
					$o = {
							x: 0,
					       	y: 0
						 };

					break;
				}

				case "top_middle":
				{

					$o = {
							x: Public.GetStage().stageWidth/2 - _replayBtn.width/2,
							y: 0
						 };

					break;
				}

				case "top_right":
				{
					$o = {
							x:  Public.GetStage().stageWidth - _replayBtn.width,
							y: 0
						 };

					break;
				}

				case "bottom_left":
				{

					$o = {
							x: 0,
							y:  Public.GetStage().stageHeight - _replayBtn.height
						 };

					break;
				}

				case "bottom_middle":
				{
					$o = {
							x: Public.GetStage().stageWidth/2- _replayBtn.width/2,
							y: Public.GetStage().stageHeight- _replayBtn.height
						 };

					break;
				}

				case "bottom_right":
				{

					$o = {
							x: Public.GetStage().stageWidth- _replayBtn.width,
							y: Public.GetStage().stageHeight- _replayBtn.height
						 };

					break;
				}
			}

			return $o;

		}


		/**  hide sound button **/
		public function HideSound():void
		{
			_soundBtn.visible = false;
		}

		/**  show sound button **/
		public function ShowSound():void
		{
			_soundBtn.visible = true;
		}

		/**  hide replay button **/
		public function HideReplay():void
		{
			_replayBtn.visible = false;
		}

		/**  show replay button **/
		public function ShowReplay():void
		{
			_replayBtn.visible = true;
		}
	}
}