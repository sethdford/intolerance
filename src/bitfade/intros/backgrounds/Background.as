/*

	Base class for intro's backgrounds

*/
package bitfade.intros.backgrounds {
	
	import flash.display.*
	import bitfade.utils.*
	
	public class Background extends Sprite {
		
		protected var w:uint = 0
		protected var h:uint = 0
		protected var paused:Boolean = false
		
		protected var conf:Object
		
		public function background(...args) {
		}
		
		protected function configure(...args):void {
			w = args[0]
			h = args[1]
			conf = args[2]
			init()
		}
		
		// init the background
		protected function init():void {
		}
		
		// callback when background ready
		public function onReady(cb:Function) {
			cb()
		}
		
		// set gradient
		public function gradient(scheme:String = null,immediate:Boolean = false) {
		}
		
		// draw burst
		public function burst(...args):void {
		}
		
		// start display
		public function start():void {
		}
		
		// end display
		public function end():void {
		}
		
		// pause
		public function pause():void {
			paused = true
		}
		
		// play
		public function play():void {
			paused = false
		}
		
		// clean up
		public function destroy():void {
			Gc.destroy(this)
		}
				
	}

}
/* commentsOK */