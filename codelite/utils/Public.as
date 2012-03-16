/**
 * Public
 * Author: codelite
 * Description: manages the public variables
 */
package codelite.utils
{
	// import flash internal classes
	import flash.display.Stage;
	
	public class Public
	{
		private static var _stage		  :Stage      = null;		// stage reference
		
		/** sets the stage **/
		public static function SetStage($value:Stage):void { _stage = $value; }
		/** return the stage **/
		public static function GetStage():Stage { return _stage; }

	}
}