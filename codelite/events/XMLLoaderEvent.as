/**
 * XMLLoaderEvent
 * Author: codelite
 * Description: events sent by the XMLLoader
 */
package codelite.events
{
	// import flash internal classes
	import flash.events.Event;

	// this class extends an Event Class
	public class XMLLoaderEvent extends Event 
	{
		public static const XML_PROGRESS:String  = "XML_PROGRESS";	// event progress status
		public static const XML_COMPLETE:String  = "XML_COMPLETE";  // event complete status
		public var _data                :*;                         // custom parameter to send               	    			  				  
		
		public function XMLLoaderEvent($type:String, $data:* ,$bubbles:Boolean = false, $cancelable:Boolean = false )
		{
			// initialize the event
			super($type ,$bubbles, $cancelable);
			// asign custom data
			_data = $data;
		}
		
		/** override the event and send a custom event **/
		override public function clone():Event
		{
			return new XMLLoaderEvent (type, bubbles, cancelable, _data);
		}
	
	}
}