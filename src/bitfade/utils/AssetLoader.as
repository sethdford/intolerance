/*
	used to load assets in progressive way
*/
package bitfade.utils { 

	import flash.display.*
	
	import bitfade.core.*
	import bitfade.data.*
	import bitfade.utils.*
	
	public class AssetLoader {
	
		protected var loadQueue:LinkedList
		protected var assets:Array
		protected var current: ContentNode
		protected var loaded:uint = 0
		
		public var loading:Boolean = false
		
		public var readyCallBack:Function
		public var transformCallBack:Function
		
		public var cacheSize:uint = 2
	
		public function AssetLoader(items:Array,callBack:Function,trasform:Function = null) {
			assets = items
			readyCallBack = callBack
			transformCallBack = trasform
		}
		
		public function start() {
			if (!assets) return
			
			// get the list of external assets
			for each (var asset:Object in assets) {
				if (asset.resource) {
					// create the queue
					if (!loadQueue) loadQueue = new LinkedList()
			
					current = new ContentNode()
					current.content = {
						resource: 	asset.resource
						
					}
					
					// add the node
					loadQueue.append(current)
					asset.resource = current
				}
				
			}
			
			if (loadQueue) {
				// resize the cache
				cacheSize = Math.min(cacheSize,loadQueue.length)
				loadAsset()
			} else {
				readyCallBack()
			}
		}
		
		protected function loadAsset() {
		
			if (loaded >= cacheSize) {
				// cache is full
				readyCallBack()
				return
			} 
			loading = true
			// load the asset
			current = ContentNode(loadQueue.shift())
			loadQueue.append(current)
			ResLoader.load(current.content.resource,assetLoaded)
			
		}
		
		// current asset is loaded
		protected function assetLoaded(data:*) {
			loading = false;
			loaded++
			current.content.data = (transformCallBack != null) ? transformCallBack(data) : data
			loadAsset()
		}
		
		// get data (external asset) for a given item
		public function getData(item:Object):* {
			if (!item || !item.resource || !item.resource.content || !item.resource.content.data) return null
			var data:* = item.resource.content.data
			if (loadQueue.length > cacheSize ) {
				delete item.resource.content.data
				next()
			}
			return data
		}
		
		// ready if asset is loaded (or asset is not external)
		public function ready(item:Object):Boolean {
			return item && item.resource is Object && item.resource.content.data  
		}
		
		// load next asset
		public function next() {
			loaded--
			if (!loading) loadAsset()
		}
		
				
	}
}
/* commentsOK */