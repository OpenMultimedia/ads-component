/**
 * TextLabel
 * Author: codelite
 * Description: text label
 */
package codelite.utils
{
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	public class TextLabel extends Sprite
	{							
		protected var _textfield:TextField = new TextField(); // text field
		protected var _format:TextFormat = new TextFormat(); // text format
		
		/** constructor **/
		public function TextLabel()
		{
			_textfield.selectable   = false;
			_textfield.mouseEnabled = false;
			addChild(_textfield);
		}
		/** sets the text **/
		public function SetText($text:String):void
		{
			_textfield.htmlText = $text;
		}
		/** formats the textfield **/
		public function SetFormat($size:Number, $color:Number, $bold:Boolean, $align:String="left", $wordwrap:Boolean=false,$multiline:Boolean=false, $w:Number =5, $h:Number =5 ):void
		{
			_textfield.multiline = $multiline;
			_textfield.wordWrap  = $wordwrap;
			_textfield.width 	 = $w;
			_textfield.height	 = $h;
			_textfield.autoSize  = TextFieldAutoSize.LEFT;
			_textfield.condenseWhite = true;
			_textfield.type = TextFieldType.DYNAMIC;
			
			_format.font  = "Arial";
			_format.size  = $size;
			_format.color = $color;
			_format.bold  = $bold;
			_format.align = $align;
			
			_textfield.setTextFormat(_format);
			_textfield.defaultTextFormat = _format ;

		}		
		/** return text **/
		public function GetText():String
		{
			return _textfield.text;
		}
		
		/** change the color**/
		public function ChangeColor($color:Number):void
		{
			_format.color = $color;
			_textfield.setTextFormat(_format);
			_textfield.defaultTextFormat = _format ;
		}
	}
}