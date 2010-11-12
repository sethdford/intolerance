/*
	this are helper functions used to clean stuff
*/
package bitfade.utils { 

	import flash.display.*
	import flash.utils.getQualifiedClassName

	import bitfade.core.*
	import bitfade.utils.*
	
	public class Gc {
	
		public static function destroy(target:*):* {
		
			Events.remove(target)
			
			if (target is DisplayObject && target.parent) target.parent.removeChild(target)
			
			if (target is Bitmap && target.bitmapData) {
				target.bitmapData.dispose()
				target.bitmapData = undefined
				return undefined
			} 
			
			if (!(target is DisplayObjectContainer)) return undefined
			
			var child:*
			
			while(target.numChildren) {
				try {
					child = target.getChildAt(0);
				} catch (e:*) {
					break;
				}
				
				if (child is bitfade.core.IDestroyable) {
					child.destroy()
				} else {
					destroy(child)
				}
				
				child = undefined
			}
			
			target = undefined
			return undefined
						
		}
				
	}
}
/* commentsOK */