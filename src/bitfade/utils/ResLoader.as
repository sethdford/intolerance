/*
	
	this class is used to load external content

*/
package bitfade.utils {
	
	import flash.display.*
	import flash.events.*
	import flash.net.*
	import flash.system.*
	import flash.text.Font
	import flash.utils.Dictionary
	
	import flash.system.ApplicationDomain
	
	import bitfade.data.*
	
	public class ResLoader extends EventDispatcher {
		private var resUrl:URLRequest
		
		private var queue:LinkedListPool
		
		private var group:Dictionary;
		private var groupID:uint = 0;
		
		private var currItem:ResLoaderNode
		
		private var displayLoader:Loader
		private var textLoader:URLLoader
		private var loaderContext:LoaderContext
		
		private var loading:Boolean = false
		
		private var defCallBack:Function
		
		private static var basePath: String
		private var domain: String
		
		protected var delayedDestroy:*
		
		protected static var _instance:ResLoader
		
		// constructor
		function ResLoader(cb:* = null) {
			super()
			
			loaderContext = new LoaderContext();
			loaderContext.checkPolicyFile = true;
			
			if (!basePath) setBasePath("swf")
			
			//loaderContext.applicationDomain = ApplicationDomain.currentDomain;
			
			resUrl = new URLRequest()
			
			// create 2 loaders: one for images/swf, other for text
			displayLoader = new Loader();
			textLoader = new URLLoader();
			
			Events.add(displayLoader.contentLoaderInfo,[Event.COMPLETE,IOErrorEvent.IO_ERROR,SecurityErrorEvent.SECURITY_ERROR],displayLoaderComplete,this)
			Events.add(textLoader,[Event.COMPLETE,IOErrorEvent.IO_ERROR,SecurityErrorEvent.SECURITY_ERROR],textLoaderComplete,this)
			
			group = new Dictionary()
			queue = new LinkedListPool(ResLoaderNode,"type","url","groupID","className")
			
			currItem = new ResLoaderNode()
			defCallBack = cb
		}
		
		// load an asset
		public static function load(url:*,cb:* = null):uint {
			if (_instance == null) _instance = new ResLoader()
			return _instance.add(url,cb)
		}
		
		// set base path
		public static function set base(url:String) {
			if (_instance == null) _instance = new ResLoader()
			return _instance.setBasePath(url)
		}
		
		// reset a download
		public static function reset(url:String,cb:Function = null):void {
			if (_instance == null) return
			return _instance.kill(url,cb)
		}
		
		// static method for opening an external url
		public static function openUrl(url:String,target:String = "_self"):void {
			try {
  				navigateToURL(new URLRequest(url), target);
  			} catch (e:*) {}
		}
		
		// set the base path for relative urls
		protected function setBasePath(url:String = null) {
			if (url) {
				switch (url) {
					case "swf":
						basePath = Boot.stage.loaderInfo.url.replace(/[^(\/|\\)]+\.swf$/,"")
					break;
					default:
						basePath = url
				}
				//domain = boot.stage.loaderInfo.url.split("/").slice(0,3).join("/")	
			}
			
			
		}
		
		// this is used to add an url (or more) to queue
		protected function add(url:*,cb:* = null):uint {
			
			if (cb == null) cb = defCallBack
		
			if (url is String) url = [url]
			
			group[groupID] = {
				urls: url,
				total: url.length,
				loaded: 0,
				callBack: cb,
				content: []
			}
			
			for each (var u:String in url) _add(u) 
			
			return groupID++
		}
		
		
		// add a single url to queue
		private function _add(url:String):void {
			
			var token:Array = url.split(/\|/)
			
			var qi:ResLoaderNode = queue.create()
			
			qi.groupID = groupID
			
			if (token[1]) {
				qi.type = token[0] == "font" ? "font" : "library"
				
				qi.url = absoluteUrl(token[1])
				// get the class name name
				qi.className = qi.url.match(/([^\/]+)\.swf$/i)[1]
				
			} else {
				qi.type = url.substring(url.lastIndexOf(".") + 1).toLowerCase()
				qi.url = absoluteUrl(url)
			}
			
			queue.append(qi)
			
			update()
		}
		
		// make url absolute
		public static function absoluteUrl(url:String):String {
			if (!basePath || url.charAt(0) == "/" || url.indexOf("http://") == 0 || url.indexOf("https://") == 0  ) return url
			return basePath+url
		}
		
		// this is used to remove an url from queue
		protected function kill(url:*,cb:* = null):void {
			var e:Object
			var gid:uint
			
			if (loading && currItem && currItem.url == url && group[currItem.groupID].callBack == cb) {
				try {
					if (currItem.type == "xml") {
						textLoader.close()
					} else {
						displayLoader.close()
						displayLoader.unload()
					}
					loading = false
					delete group[currItem.groupID]
					update()
				} catch (e:*) {}
			} else {
				
				queue.rewind()
				
				var cursor:ResLoaderNode
				while(cursor = queue.next) {
					if (cursor.url == url && group[cursor.groupID].callBack == cb) {
						queue.deleteCurrent()
						break
					}	
				}
				
			}	
		}
		
		// destroy the instance
		public function destroy():void {
			Gc.destroy(_instance)
			_instance = undefined
			
			
		}
		
		// get a file from queue and load it
		private function update():void {
			if (loading) return 
			
			if (queue.empty) {
				delayedDestroy=Run.after(60,destroy,delayedDestroy)
				return
			} 
			
			if (delayedDestroy) {
				Run.reset(delayedDestroy)
			}
			
			
			queue.shift(currItem)
			
			resUrl.url = currItem.url
			
			// use appropriate loader for current item type (extension)
			if (currItem.type == "xml") {
				textLoader.load(resUrl)
			} else {
				// disable policy checking for external font packages
				// dunno why but it breaks Font register randomly
				displayLoader.load(resUrl,currItem.type != "font" ? loaderContext : null)
			}
			
			loading = true
		}
		
		// this is called when a display object is loaded
		public function displayLoaderComplete(e:Event=null):void {
		
			
			loading = false
			
			//if (!group[currItem.groupID]) return
			var content:Object = group[currItem.groupID].content
			
			if ((e && (e.type == IOErrorEvent.IO_ERROR || e.type == SecurityErrorEvent.SECURITY_ERROR)) || !displayLoader.contentLoaderInfo.childAllowsParent) {
				content.push(undefined)
			} else {
				var type:String = currItem.type
				var className:String = currItem.className
				
				if (type == "font") {
					var ad:ApplicationDomain = e.target.applicationDomain
					// register font (or fonts)
					var fonts:* = ad.hasDefinition(type) ? ad.getDefinition(type) : ad.hasDefinition(className) ? ad.getDefinition(className)[type] : false
					if (fonts) {
						if (!(fonts is Array)) fonts = [fonts]
						for each (var font:Class in fonts) {
							Font.registerFont(font)
						}
					}
					content.push(className)
				} else if (type=="library") {
					content.push(e.target.applicationDomain) 
				} else {
					content.push(displayLoader.content)
				}
			}
			
			displayLoader.unload()
			callCallBack(currItem.groupID)
		}
		
		// this is called when a text object is loaded
		public function textLoaderComplete(e:Event=null):void {
			loading = false
			
			var content:Object = group[currItem.groupID].content
			
			if (e && (e.type == IOErrorEvent.IO_ERROR || e.type == SecurityErrorEvent.SECURITY_ERROR)) {
				content.push(undefined)
			} else {
				content.push((currItem.type == "xml") ? new XML(textLoader.data) : textLoader.data)
			}
			
			callCallBack(currItem.groupID)
		}
		
		// call callback, if defined, and delete info
		private function callCallBack(gid:uint):void {
		
			var gData:Object = group[gid]
			
			gData.loaded++
			if (gData.loaded == gData.total) {
				if (gData.callBack) {
					gData.callBack((gData.total == 1) ? gData.content[0] : gData.content)
				}
				delete group[gid]
			}
			update()
		}

	}
}

internal class ResLoaderNode extends bitfade.data.LLNode {
	public var type:String
	public var url:String
	public var groupID:uint
	public var className:String
}
/* commentsOK */
