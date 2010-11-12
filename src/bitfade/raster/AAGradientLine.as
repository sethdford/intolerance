/*

	Draw antialiased line with decreasing alpha

*/
package bitfade.raster {

	public final class AAGradientLine extends bitfade.raster.Graphics {
	
		public function draw(x1:int,y1:int,x2:int,y2:int,color:uint=0xFFFFFFFF) {
			
			// clip the line
			clip(x1,y1,x2,y2)
			
			x2 = clippedX
			y2 = clippedY
			
			x1 = clippedX1
			y1 = clippedY1
			
			
			var w:uint = width
			var h:uint = height
			
			var dx:int
			var dy:int
			var adx:int
			var ady:int
			
			var yp:uint
			var eA:uint
			var nA:uint
			var err:int
   			
			var incr:int
			var other:int
			
			var sp:int
			var last:int
			
			var maxAlpha: uint = color >>> 24
			var mA:int = maxAlpha*(1 << 16)/0xFF
			var decr:int = 0
			
			var v:Vector.<uint> = target
			
			dx = x2-x1
			dy = y2-y1
			
			adx = (dx ^ (dx >> 31)) - (dx >> 31);
			ady = (dy ^ (dy >> 31)) - (dy >> 31);
			
			color = color & 0xFFFFFF
			
			if (ady > adx) {
			
				decr = -mA/ady
			
				x1++
			
				dx = dx << 8
				dx = dx / ady
				
				yp = y1*w+x1
   				
				sp = y1 > y2 ? -w : w
				incr = x1 > x2 ? -1 : 1
				
				last = x1
				
   				x1 <<= 8
   				
   				var count:uint = 0
   				
   				for (;ady != 0; --ady,yp += sp,x1 += dx, mA += decr) {
   				
					err = x1 >>> 8
					
					if (err != last) {
						yp += incr
						last = err
					}
				
					eA = v[yp] 
					eA >>>= 24
					nA = x1 
					nA &= 0xFF
					nA *= mA 
					nA >>= 16
					eA += nA
					if (eA > 0xFF) eA = 0xFF
					
					eA <<= 24
					eA |= color
         			v[yp] = eA 
					
					other = yp-1
					
					eA = v[other] 
					eA >>>= 24
					nA = x1 
					nA &= 0xFF
					nA ^= 0xFF
					nA *= mA 
					nA >>= 16
					eA += nA
					if (eA > 0xFF) eA = 0xFF
					
					eA <<= 24
					eA |= color
         			v[other] = eA
         			
					
				
				}
			} else {
				decr = -mA/adx
				
				y1++
				
				dy = dy << 8
				dy = dy / adx	
				
				
				yp = y1*w+x1
   				
				sp = y1 > y2 ? -w : w
				incr = x1 > x2 ? -1 : 1
				
   				last = y1
   				
   				y1 <<= 8
   				
 				for (;adx != 0; --adx, y1 += dy,yp += incr,mA += decr) {
 					
					err = y1 >>> 8
					
					if (err != last) {
						yp += sp
						last = err
					}
				
					eA = v[yp] 
					eA >>>= 24
					nA = y1 
					nA &= 0xFF 
					nA *= mA 
					nA >>= 16
					eA += nA
					if (eA > 0xFF) eA = 0xFF
					
					eA <<= 24
					eA |= color
         			v[yp] = eA 
					
					other = yp-w
					
					eA = v[other]
					eA >>>= 24
					nA = y1 
					nA &= 0xFF 
					nA ^= 0xFF
					nA *= int(mA) 
					nA >>= 16
					eA += nA
					if (eA > 0xFF) eA = 0xFF
					
					eA <<= 24
					eA |= color
         			v[other] = eA 
   
				}	
			}	
		}
		
		
	}
}
/* commentsOK */	