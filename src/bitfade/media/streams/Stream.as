/*

	This base class hold stream properties
	it has to be extended to implements defined (empty) methods

*/
package bitfade.media.streams {
	
	import flash.display.*
	import flash.events.*
	import flash.utils.getTimer
	
	import bitfade.core.IDestroyable
	import bitfade.utils.*
	
	public class Stream extends EventDispatcher implements bitfade.core.IDestroyable {
	
		// size
		public var width:uint
		public var height:uint
		
		// resource url
		public var resource:String
		
		// stream properties
		public var duration:Number = 0
		public var fps:Number = 0
		
		// buffer properties
		public var buffering:Boolean = false;
		public var bufferTimeMax:uint = 5;
		
		// current requested seek position
		protected var seekPos:Number = 0
		
		// playback properties
		public var paused:Boolean = false;
		public var started:Boolean = false;
		public var stopped:Boolean = false;
		public var playStarted:Boolean = false;
		public var playedStreams:uint = 0;
		
		protected var netInited:Boolean = false
		
		// last stream played time
		protected var lastPlayedTime:Number = 0;
		
		// last fired event value
		protected var lastEventValue:Object = {}
		
		// last fired event
		protected var lastEvent:String
		
		protected var errorText:String
		
		// constructor
		public function Stream() {
			super()
		}
		
		public function get error():String {
			return errorText
		}
		
		public function get type():String {
			return "stream"
		}
		
		/*
		
			empty methods that needs to be overridden by extenders
			refer to video.as for explanation
		
		*/
		
		public function get ready():Boolean {
			return false
		}
		
		public function load(url:String,startPaused:Boolean = false,startBuffering:Boolean = true):void {}
		
		public function close():void {}
		
		public function pause():Boolean { return false }
		
		public function resume():Boolean { return false }
		
		public function play():Boolean { return resume() }
		
		// restart playback
		public function restart():void {
			playStarted = false
			stopped = false
			seek(0)
		}
		
		 // stop playback
		public function stop():void {
			stopped = true;
			lastPlayedTime = 0
			pause()
			if (!lastEventValue[StreamEvent.STOP]) fireEvent(StreamEvent.STOP,getTimer(),true)
		}
		
		public function seek(pos:Number,end:Boolean = true):Number { return 0 }
		
		public function volume(vol:Number):void {}
		
		protected function reset():void {
			buffering = false
			seekPos = lastPlayedTime = 0
			playStarted = started = stopped = false
			lastEventValue = new Array()
			lastEvent = ""
			if (playedStreams > 0) fireEvent(StreamEvent.CLOSE,0)
		}
		
		public function get bytesLoaded():uint {
			return 0
		}
		
		public function get bytesTotal():uint {
			return 1
		}
		
		public function get loaded():Number {
			return bytesLoaded/bytesTotal
		}
		
		public function get time():Number {
			return 0
		}
		
		public function get position():Number{
			return uint(1000*time/duration+0.5)/1000
		}
		
		// this is used to fire events
        protected function fireEvent(type:String,value:Number = 0,filterDuplicates:Boolean = false):void {
        	// CHECK THIS
        	//if (!netInited) return
        	if (filterDuplicates) {
        		// if we have fired same event type with same value, do nothing
        		if (lastEventValue[type] == value) return
        		lastEventValue[type] = value
        	}
        	// fire event
        	lastEvent = type
       		dispatchEvent(new StreamEvent(type,value));
        }
        
        // tell player to use spinner on buffer events
        public function get useSpinner():Boolean {
        	return true
        }
        
        // tell player to inform when seeking is ended
        public function get seekNeedsEnd():Boolean {
        	return false
        }
        
        // tell player this stream will include buffer size in buffer events
        public function get hasNumbericBuffer():Boolean {
        	return true
        }
        
        public static function type(value:String):Boolean {
        	return (value.match(/^(video|audio|youtube)/) != null)
        }
        
        public static function quality(value:String):Boolean {
        	return (value.match(/^(default|small|medium|large|hd720)/) != null)
        }
        
        // split a resource in its components
        public static function splitResource(defType:String,defQuality:String,resource:String):Object {
        
        	var info:Object = {}
        	
        	var tokens:Array = resource.split(/:/)
        	
        	if (type(tokens[0])) {
        		info.type = tokens[0]
        		tokens.shift()
        	} else {
        		info.type = defType
        	}
        	
        	if (quality(tokens[0])) {
        		info.quality = tokens[0]
        		tokens.shift()
        	} else {
        		info.quality = defQuality
        	}
        	
        	info.resource = tokens.join(":")
        	
        	return info
        	
        	
        	
        }
        
        public static function getClassFrom(defValue:String,resource:String):String { 	
        	return "bitfade.media.streams."+(splitResource(defValue,"default",resource)).type
        }
        
        public static function getQualityFrom(defQuality:String,resource:String):String { 	
        	return (splitResource("video",defQuality,resource)).quality
        }
        
        public static function getResourceFrom(resource:String):String { 
        	return (splitResource("video","default",resource)).resource
        }
        
        // destructor
        public function destroy():void {
        	reset()
        	Gc.destroy(this)
        }
		
	}


}
/* commentsOK */