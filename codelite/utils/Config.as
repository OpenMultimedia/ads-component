/**
 * Config
 * Author: codelite
 * Description: Manages the xml data for the entire application. This is a static class.
 *
 */
package codelite.utils
{
	CONFIG::DEBUG {
	import net.kgdesignes.utils.Console;
	}
	import com.adobe.net.URI;

	public class Config
	{
		private static const POSITIONS:Object = {
			'top_left': true,
			'top_middle': true,
			'top_right': true,
			'bottom_left': true,
			'bottom_middle': true,
			'bottom_right': true
		};

		private static const DEFAULT_VIDEO_WIDTH:Number = 300;
		private static const DEFAULT_VIDEO_HEIGHT:Number = 250;
		private static const DEFAULT_VIDEO_POSITION_X:Number = 0;
		private static const DEFAULT_VIDEO_POSITION_Y:Number = 0;
		private static const DEFAULT_SOUND_POSITION:String = 'bottom_left';
		private static const DEFAULT_REPLAY_POSITION:String = 'bottom_left';
		private static const DEFAULT_LINK_TARGET:String = '_blank';
		private static const DEFAULT_TRANSITION:String = '0';
		private static const DEFAULT_VIDEO:String = 'video.flv';
		private static const DEFAULT_POSTER:String = 'poster.jpg';

		/** stores the object data **/
		private static var _backgroundColor:int  = 0x000000;
		private static var _normalButtonColor:int = 0xEEEEEE;
		private static var _hooverButtonColor:int = 0xFFFFFF;
		private static var _items:Array = [];
		private static var _transitionEffect:Boolean = false;
		private static var _restartVideoFirstTimeSoundOn:Boolean = false;

		private static var _baseURI:URI = null;

		public static function SET_BASE_URI(uri:String):void {
			_baseURI = new URI(uri);
		}

		private static function _GET_ITEM_FROM_XML(xmlItem:XML):Object {
			CONFIG::DEBUG { Console.log("Setting XML Config: ", xmlItem); }

			var partialItem:Object = {};

			if ( xmlItem.poster ) {
				partialItem.poster = xmlItem.poster;
			}

			if ( xmlItem.video ) {
				partialItem.video = xmlItem.video;
			}
			if ( xmlItem.video_width ) {
				partialItem.video_width = xmlItem.video_width;
			}
			if ( xmlItem.video_height ) {
				partialItem.video_height = xmlItem.video_height;
			}
			if ( xmlItem.video_position_x ) {
				partialItem.video_position_x = xmlItem.video_position_x;
			}
			if ( xmlItem.video_position_y ) {
				partialItem.video_position_y = xmlItem.video_position_y;
			}
			if ( xmlItem.sound_position ) {
				partialItem.sound_position = xmlItem.sound_position;
			}
			if ( xmlItem.replay_position ) {
				partialItem.replay_position = xmlItem.replay_position;
			}
			if ( xmlItem.link ) {
				partialItem.link = {
					url: xmlItem.link,
					target: (xmlItem.link.@window ? xmlItem.link.@window : DEFAULT_LINK_TARGET)
				};
			}
			if ( xmlItem.transition ) {
				partialItem.transition = xmlItem.transition;
			}

			return partialItem;
		}

		private static function _GET_ITEM_FROM_OBJECT(objItem):Object {
			var item:Object = {
				poster: '',
				video: '',
				video_width: DEFAULT_VIDEO_WIDTH,
				video_height: DEFAULT_VIDEO_HEIGHT,
				video_position_x: DEFAULT_VIDEO_POSITION_X,
				video_position_y: DEFAULT_VIDEO_POSITION_Y,
				sound_position: DEFAULT_SOUND_POSITION,
				replay_position: DEFAULT_REPLAY_POSITION,
				link: {
					url: '',
					target: DEFAULT_LINK_TARGET
				},
				transition: DEFAULT_TRANSITION
			};

			for ( var key:String in item ) {
				if ( key in {'poster': true, 'video': true} ) {
					if ( ! objItem[key] ) {
						objItem[key] = ( key == 'poster' ? DEFAULT_POSTER : DEFAULT_VIDEO );
					}
					var uri:URI = new URI(objItem[key]);
					if ( uri.isRelative() ) {
						uri.makeAbsoluteURI(_baseURI);
					}

					item[key] = uri.toString();

					CONFIG::DEBUG { Console.log("URI " + key, uri, item[key]); }

				} else if ( key in objItem ) {
					if ( key in {'video_width': true, 'video_height': true, 'video_position_x': true, 'video_position_y': true} ) {
						try {
							item[key] = Number(objItem[key]);
						} catch(e:Error) {
							//Value cannot be casted
						}
					} else if ( key in {'sound_position': true, 'replay_position': true} ) {
						if ( objItem[key] in POSITIONS ) {
							item[key] = objItem[key];
						}
					} else if ( key == 'link' ) {
						if ( objItem[key] is Object ) {
							if ( objItem[key].url ) {
								item[key].url = objItem[key].url;
							}
							if ( objItem[key].target ) {
								item[key].target = objItem[key].target;
							}
						}
					} else {
						item[key] = objItem[key];
					}
				}
			}

			return item;
		}

		/** sets the XML data **/
		public static function SET_XML($xml:XML):void {
			if ( $xml.background_color ) {
				SET_CONFIG('background_color', $xml.background_color);
			}

			if ( $xml.normal_button_color ) {
				SET_CONFIG('normal_button_color', $xml.normal_button_color);
			}

			if ( $xml.hoover_button_color) {
				SET_CONFIG('hoover_button_color', $xml.hoover_button_color);
			}

			if ( $xml.transition_effect ) {
				SET_CONFIG('transition_effect', $xml.transition_effect);
			}

			if ( $xml.restart_video_first_time_sound_on ) {
				SET_CONFIG('restart_video_first_time_sound_on', $xml.restart_video_first_time_sound_on);
			}

			if ( $xml.list && $xml.list.item ) {
				var size = $xml.list.item.length();
				var items:Array = [];
				for ( var i:int = 0; i < size; i += 1) {
					var item:Object = _GET_ITEM_FROM_XML($xml.list.item[i]);
					if ( item ) {
						items.push(item);
					}
				}

				_SET_ITEMS(items);
			}

		}

		public static function SET_CONFIG($key:String, $value:*):void {
			switch ( $key ) {
				case 'background_color':
					_backgroundColor = int($value);
					break;
				case 'normal_button_color':
					_normalButtonColor = int($value);
					break;
				case 'hoover_button_color':
					_hooverButtonColor = int($value);
					break;
				case 'transition_effect':
					_transitionEffect = ($value && ($value != 'false') as Boolean);
					break;
				case 'restart_video_first_time_sound_on':
					_restartVideoFirstTimeSoundOn = ($value && ($value != 'false') as Boolean);
					break;
				case 'items':
					try {
						_SET_ITEMS($value);
					} catch (e:Error) {
						//Most likely, $value is not an array
					}
					break;
			}
		}

		public static function _SET_ITEMS($items:Array) {
			var size:int = $items.length;
			for ( var i:int = 0; i < size; i += 1) {
				var item:Object = _GET_ITEM_FROM_OBJECT($items[i]);
				if ( item ) {
					_items.push(item);
				}
			}
		}

		/** returns background color **/
		public static function BACKGROUND_COLOR():int  { return _backgroundColor; }

		/** returns button normal color **/
		public static function NORMAL_BUTTON_COLOR():int  { return _normalButtonColor; }

		/** returns button hoover color **/
		public static function HOOVER_BUTTON_COLOR():int  { return _hooverButtonColor; }

		/** returns the number of items **/
		public static function ITEMS_NUMBER():int  { return _items.length; }

		/** returns poster **/
		public static function ITEM_POSTER($id:int):String  { return _items[$id].poster; }

		/** returns video **/
		public static function ITEM_VIDEO($id:int):String  { return _items[$id].video; }

		/** returns video width **/
		public static function ITEM_VIDEO_WIDTH($id:int):Number  { return _items[$id].video_width; }

		/** returns video height **/
		public static function ITEM_VIDEO_HEIGHT($id:int):Number  { return _items[$id].video_height; }

		/** returns video X position **/
		public static function ITEM_VIDEO_X($id:int):Number  { return _items[$id].video_position_x; }

		/** returns video sound position **/
		public static function SOUND_POSITION($id:int):String  { return _items[$id].sound_position; }

		/** returns video replay position **/
		public static function REPLAY_POSITION($id:int):String  { return _items[$id].replay_position; }

		/** returns video Y position **/
		public static function ITEM_VIDEO_Y($id:int):Number  { return _items[$id].video_position_y; }

		/** returns external link **/
		public static function ITEM_LINK($id:int):String  { return _items[$id].link.url; }

		/** returns external link method**/
		public static function ITEM_LINK_METHOD($id:int):String  { return _items[$id].link.target; }

		/** returns  the type of mask **/
		public static function ITEM_MASK($id:int):String  { return _items[$id].transition; }

		/** returns  if mask is used **/
		public static function MASK():Boolean  { return _transitionEffect; }

		/** returns  if the video should restart on first sound on  **/
		public static function RESTART_ON_FIRST_SOUND():Boolean  { return _restartVideoFirstTimeSoundOn; }
	}
}