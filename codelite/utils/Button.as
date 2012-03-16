/**
 * Button
 * Author: codelite
 * Description: simple button
 *
 */

package codelite.utils
{
	/** flash classes **/
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;

	/** custom components **/
	import codelite.utils.TextLabel;
	import codelite.utils.Config;

	public class Button extends Sprite
	{
		[Embed(source="../assets/pestania.png")]
		private var PestaniaBackground:Class;

		private var _bmBackground:Bitmap = new PestaniaBackground();
		private var _background:Shape  = null; // background
		private var _label:TextLabel  = null;  // label

		/** constructor **/
		public function Button($label:String)
		{
			this.buttonMode    = true;
			this.mouseChildren = false;

			_label = new TextLabel();
			_label.SetFormat(14, Config.NORMAL_BUTTON_COLOR(), true, "left", false, false, 10, 10);

			_background = new Shape();
			addChild(_bmBackground);
			//addChild(_background);
			addChild(_label);

			ChangeLabel($label);

			_label.filters = [ new GlowFilter(0x000000,1.0,2.0,2.0,10)] ;

			this.addEventListener(MouseEvent.ROLL_OVER, Events, false, 0, true)
		}

		/** events **/
		private function Events($e:MouseEvent):void
		{
			switch($e.type)
			{
				case "rollOver":
				{
					this.addEventListener(MouseEvent.ROLL_OUT, Events, false, 0, true);
					this.removeEventListener(MouseEvent.ROLL_OVER, Events);

					_label.ChangeColor(Config.HOOVER_BUTTON_COLOR());

					break;

				}

				case "rollOut":
				{
					this.addEventListener(MouseEvent.ROLL_OVER, Events, false, 0, true);
					this.removeEventListener(MouseEvent.ROLL_OUT, Events);

					_label.ChangeColor(Config.NORMAL_BUTTON_COLOR());

					break;
				}
			}
		}

		/** change label **/
		public function ChangeLabel($label:String):void
		{
			_label.SetText($label);

			_background.graphics.clear();
			_background.graphics.beginFill(0x000000,0.6);
			_background.graphics.drawRoundRect(0,0,_label.width+10,_label.height+5, 16);
			_background.graphics.endFill();

			_label.x = 2;
			_label.y = _bmBackground.height - _label.height - 2;
		}

		/** returns the label **/
		public function ReturnLabel():String
		{
			return _label.GetText();
		}
	}
}