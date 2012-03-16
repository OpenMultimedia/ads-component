/**
 * Effexts Events
 * Author: codelite
 * Description: This class manages the custom events sent by transition effects
 */
package codelite.events
{
	/** importing events */
	import flash.events.Event
	
	/** this custom class extends the Event class*/
	public class FXEvents extends Event
	{
		public static const FX_STOP:String = "fx_stop";		/** transition has ended */
		
		public function FXEvents($type:String, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
		}
	}
}