package { 
	import bitfade.intros.Backlight
	import flash.display.Sprite
	import flash.events.*
	
	public class introBackLight extends Sprite {
		
		public var intro:bitfade.intros.Backlight
		
		
		public function introBackLight() {	
			super()
			init()
  		}
  		 			
  		public function init() {	
			var conf:String = loaderInfo.parameters.config
			
			if (conf) {
				intro = new bitfade.intros.Backlight(conf)
			} else {
				intro = new bitfade.intros.Backlight()
			}
			
			if (stage) {
				// set stage to "no scale" and "top left"
				stage.scaleMode = "noScale";
				stage.align = "TL";			
			}
			
			// add it to stage
			addChild(intro)
  		}
	}
}