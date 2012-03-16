/**
 * XMLLoader
 * Author: codelite
 * Description: xml loader class
 */
package codelite.utils
{
	// import flash internal classes
	import flash.net.URLLoader;
	import flash.net.URLRequest;	
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	// import custom class 
	import codelite.events.XMLLoaderEvent;
	
	// this class extends an event dispatcher class
	public class XMLLoader extends EventDispatcher
	{
		protected static var _loader:URLLoader = null;	// loader for the xml
		
		/** create a new loader instance and load the xml **/
		public function Load($path:String)
		{
			_loader = new URLLoader();
			_loader.load(new URLRequest($path));
			_loader.addEventListener(ProgressEvent.PROGRESS, XMLLoading, false, 0, true);
			_loader.addEventListener(Event.COMPLETE,         XMLComplete, false, 0, true);
		}
		
		/** xml is loaded**/
		private function XMLComplete($e:Event):void
		{
		    dispatchEvent(new XMLLoaderEvent(XMLLoaderEvent.XML_COMPLETE, _loader));
		}
		
		/** xml is loading **/
		private function XMLLoading($e:ProgressEvent):void
		{
			dispatchEvent(new XMLLoaderEvent(XMLLoaderEvent.XML_PROGRESS,($e.bytesLoaded/$e.bytesTotal)));
        }
		
		/** destroy instance **/
		public function Clear():void
		{
			_loader.removeEventListener(ProgressEvent.PROGRESS, XMLLoading);
			_loader.removeEventListener(Event.COMPLETE,         XMLComplete);
			_loader = null;
		}
	}
}