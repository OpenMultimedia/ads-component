/**
 * Poster
 * Author: codelite
 * Description: loads the image poster
 *
 */
package codelite
{
	/** flash classes **/
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;

	/** custom classes **/
	import codelite.utils.Config;
	import codelite.utils.Cloner;

	//import net.kgdesignes.utils.Console;

	public class Poster extends Sprite
	{
		private var _loader:Loader=null; // image loader

		/** constructor **/
		public function Poster($id:int)
		{
			// create a loader for the image
			_loader = new Loader();
			_loader.load(new URLRequest(Config.ITEM_POSTER($id)));
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, Initialization, false, 0, true);
		}

		/** Initialize **/
		private function Initialization($e:Event):void
		{
			// add poster to dipsplay list
			addChild(_loader);

			//Console.log("Initing", parent);

			// initialize component / send poster reference
			Display(parent).Init(Cloner.Clone(_loader));
		}
	}
}