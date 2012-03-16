/**
 * Template
 * Author: codelite
 * Description: main class
 */
package codelite
{
	// flash classes
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.system.Security;
	import flash.display.LoaderInfo;

	// custom classes
	import codelite.utils.Config;
	import codelite.utils.Public;
	import codelite.utils.XMLLoader;
	import codelite.events.XMLLoaderEvent;

	CONFIG::DEBUG {
	// DEBUG flag requires FlashPlayer 10+
	import net.kgdesignes.utils.Console;
	import flash.events.ErrorEvent;
	import flash.events.UncaughtErrorEvent;
	}

	public class Component extends Sprite
	{
		private var _xmlLoader  	:XMLLoader				= null; // xml loader instance
		private var _display	  	:Display				= null; // display instance

		/** constructor **/
		public function Component()
		{
			addEventListener(Event.ADDED_TO_STAGE, Init, false, 0, true);
			CONFIG::DEBUG {
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
			}

			Config.SET_BASE_URI(unescape(LoaderInfo(this.root.loaderInfo).url));
		}

		CONFIG::DEBUG {
		private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
		    if (event.error is Error)
		    {
			var error:Error = event.error as Error;
			CONFIG::DEBUG { Console.log(error); }
			// do something with the error
		    }
		    else if (event.error is ErrorEvent)
		    {
			var errorEvent:ErrorEvent = event.error as ErrorEvent;
			CONFIG::DEBUG { Console.log(error); }
			// do something with the error
		    }
		    else
		    {
			CONFIG::DEBUG { Console.log("Error sin especificar"); }
			// a non-Error, non-ErrorEvent type was thrown and uncaught
		    }
		}
		}


		/** initialization **/
		private function Init($e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, Init);

			Security.allowDomain("*");
			Security.allowInsecureDomain("*");

			stage.scaleMode	= StageScaleMode.NO_SCALE;
			stage.align		= StageAlign.TOP_LEFT;

			LoadConfig();
		}

		/** loading configuration file **/
		private function LoadConfig():void
		{
			// get the path for the XML from flash var
			var $path:String = String(this.stage.loaderInfo.parameters["xmlpath"]);

			if ( ( $path == "undefined" || $path == "null" ) && this.stage.loaderInfo.parameters["video"] ) {
				CONFIG::DEBUG { Console.log("Configurado por FlashVars/QueryString"); }

				//if no xml path is defined, we check if we have the configuration passed down by url/flashvar

				if ( this.stage.loaderInfo.parameters["background_color"] ) {
					Config.SET_CONFIG("background_color", this.stage.loaderInfo.parameters["background_color"]);
				}

				if ( this.stage.loaderInfo.parameters["normal_button_color"] ) {
					Config.SET_CONFIG("normal_button_color", this.stage.loaderInfo.parameters["normal_button_color"]);
				}

				if ( this.stage.loaderInfo.parameters["hoover_button_color"] ) {
					Config.SET_CONFIG("hoover_button_color", this.stage.loaderInfo.parameters["hoover_button_color"]);
				}

				if ( this.stage.loaderInfo.parameters["transition_effect"] ) {
					Config.SET_CONFIG("transition_effect", this.stage.loaderInfo.parameters["transition_effect"]);
				}

				if ( this.stage.loaderInfo.parameters["restart_video_first_time_sound_on"] ) {
					Config.SET_CONFIG("restart_video_first_time_sound_on", this.stage.loaderInfo.parameters["restart_video_first_time_sound_on"]);
				}

				var item:Object = {};

				if ( this.stage.loaderInfo.parameters["poster"] ) {
					item.poster = this.stage.loaderInfo.parameters["poster"];
				}

				if ( this.stage.loaderInfo.parameters["video"] ) {
					item.video = this.stage.loaderInfo.parameters["video"];
				}

				if ( this.stage.loaderInfo.parameters["transition"] ) {
					item.transition = this.stage.loaderInfo.parameters["transition"];
				}

				if ( this.stage.loaderInfo.parameters["clickTAG"] ) {
					item.link = {
						url: unescape(this.stage.loaderInfo.parameters["clickTAG"])
					};

					if ( this.stage.loaderInfo.parameters["clickTARGET"] ) {
						item.link.target = this.stage.loaderInfo.parameters["clickTARGET"];
					}
				}

				CONFIG::DEBUG { Console.log("Elemento a reproducir: ", item); }

				Config.SET_CONFIG("items", [item]);
				Setup();

			} else {
				if ( ( $path == "undefined" || $path == "null" ) ) {
					CONFIG::DEBUG { Console.log("Cargando XML Defaulf"); }
					$path = "template.xml";
				}

				CONFIG::DEBUG { Console.log("Configurado por XML"); }
				// xml loader new instance*/
				_xmlLoader = new XMLLoader();
				_xmlLoader.Load($path);
				_xmlLoader.addEventListener(XMLLoaderEvent.XML_COMPLETE, Complete, false, 0, true);
			}
		}

		/** settings loaded **/
		private function Complete($e:XMLLoaderEvent):void
		{
			// sets the XML
			Config.SET_XML(new XML($e._data.data));

			// removes the xml loader instance
			_xmlLoader.removeEventListener(XMLLoaderEvent.XML_COMPLETE, Complete);
			_xmlLoader.Clear();
			_xmlLoader = null;

			Setup();
		}

		/** setup **/
		private function Setup():void
		{
			Public.SetStage(stage);

			_display = new Display();
			addChild(_display);
		}
	}
}
