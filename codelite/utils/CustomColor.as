/**
 * CustomColor
 * Author: codelite
 * Description: manages the color of a movieclip
 */
package codelite.utils
{
	/** import flash internal classes **/
	import flash.geom.ColorTransform;
	import flash.display.DisplayObject
	
	public class CustomColor 
	{						
		/** Color 
		 *  @param: $object - movieclip reference
		 *  @param: $color  - custom color
		 **/
		public static function Color($object:DisplayObject, $color:Number):void
		{
			// create a temporary ColorTransform instance
			var $newColor:ColorTransform = new ColorTransform();
			// set the color
			$newColor.color = $color;
			// apply the color
			$object.transform.colorTransform = $newColor;
		}		
	}
}