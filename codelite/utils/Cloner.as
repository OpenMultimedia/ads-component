/**
 * Cloner
 * Author: codelite
 * Description: Clones images
 * 
 */
package codelite.utils
{
	// import flash internal classes
	import flash.display.Loader;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	public class Cloner 
	{
		/** Clone: copies the image reference into another bitmap instance and returns the instance 
		 *  @param: $object - image reference
		 **/
		public static function Clone($object:Loader):Bitmap
		{
			var $o:Bitmap = null;
			
			var $bitmapdata:BitmapData = new BitmapData($object.width, $object.height, true, 0x00000000);
			$bitmapdata.draw($object);
			$o = new Bitmap($bitmapdata);
			$o.smoothing = true;
			
			return $o;
		}
	}
}