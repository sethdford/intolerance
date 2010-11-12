/*

	external background image

*/
package bitfade.intros.backgrounds {
	
	import flash.display.*
	import bitfade.utils.*
	
	public class Image extends Background {
	
		protected var onReadyCallBack:Function
		
		public function Image(...args) {
			configure.apply(null,args)
		}
		
		override protected function init():void {
			super.init()
			
			ResLoader.load(conf.resource,assetLoaded)			
		}
		
		override public function onReady(cb:Function) {
			onReadyCallBack = cb
		}
		
		protected function assetLoaded(content):void {
			if (content) addChild(content)
			if (onReadyCallBack != null) onReadyCallBack()
		}	
	}

}
/* commentsOK */