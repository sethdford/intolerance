package { 
	import bitfade.utils.resLoader
	
	import flash.display.*
	import flash.events.*
	import flash.text.*
	
	import flash.events.Event;
	
	public class test extends Sprite {
	
		public var rL:resLoader
		        
        public function test() {    	
        	addEventListener(Event.ADDED_TO_STAGE,init)
  		}
  		
  		public function init(e) {
  			removeEventListener(Event.ADDED_TO_STAGE,init)
  			
  			stage.scaleMode = "noScale";
			stage.align = "TL";
  			
  			var fontPack:String  = "test/Vera.swf"

			// try to get config parameters, fallback is to use default conf
			try {
				if (loaderInfo.parameters.font) fontPack = loaderInfo.parameters.font
			} catch (e) {}

  			rL = new resLoader(fontLoaded)
  			rL.add("font|"+fontPack)
  		}
  		
  		public function fontLoaded(data) {
  			var buffer:String = ""
  			var fontList:Array = Font.enumerateFonts(false);
			for (var i:uint=0; i<fontList.length; i++) {
				var fontName = fontList[i].fontName
				
				var size = fontName.match(/_(\d+)pt_st$/i)
				size = size ? size[1] : 30
				
				buffer += "<font size=\""+size+"\" face=\""+fontName+"\">" + fontName + "</font><br>"
 			}
 			
 			var textR = new TextField()
 			
 			var w:uint = stage.stageWidth
 			var h:uint = stage.stageHeight
 			
 			with (textR) {
				width = w
				height = h
				
				type = TextFieldType.INPUT
				
				embedFonts  = true
			
				border = false
				background = true
				backgroundColor = 0x404040
				condenseWhite = true
				multiline = true
				selectable = true
				
				defaultTextFormat = new TextFormat("Arial",30,0xFFFFFF);
			}
 			
 			addChild(textR)
 			textR.htmlText = buffer
  		}
  		
  						
	}
}
