/**
 * SineWaveFX - Special FX Plugin
 * -- Part of the Flixel Power Tools set
 * 
 * v1.0 First release
 * 
 * @version 1.0 - May 19th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm.FX 
{
	import flash.display.BitmapData;
	import flash.display.ColorCorrectionSupport;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * Creates a sine-wave effect through an FlxSprite
	 */
	public class SineWaveFX extends BaseFX
	{
		public var image:BitmapData;
		private var chunk:uint;
		private var offset:uint;
		private var updateLimit:uint = 0;
		private var lastUpdate:uint = 0;
		private var complete:Boolean = false;
		private var ready:Boolean = false;
		public var f:Number = 1;
		public var up:Boolean = true;
		
		private var sineData:Array;
		
		public function SineWaveFX() 
		{
		}
		
		public function create(source:FlxSprite, x:int, y:int, width:uint, height:uint, chunks:uint = 1, backgroundColor:uint = 0x0):FlxSprite
		{
			sprite = new FlxSprite(x, y).makeGraphic(width, height, backgroundColor);
			
			canvas = new BitmapData(width, height, true, backgroundColor);
			
			if (source.pixels.width != width || source.pixels.height != height)
			{
				image = new BitmapData(width, height, true, backgroundColor);
				image.copyPixels(source.pixels, new Rectangle(0, 0, source.pixels.width, source.pixels.height), new Point(0, height - source.pixels.height));
			}
			else
			{
				image = source.pixels;
			}
			
			active = true;
				
			sineData = FlxMath.sinCosGenerator(image.width * 2, 32, 1.0, 6.0);
			
			return sprite;
		}
		
		/**
		 * Starts the Effect runnning
		 * 
		 * @param	delay	How many "game updates" should pass between each update? If your game runs at 30fps a value of 0 means it will do 30 drops per second. A value of 1 means it will do 15 drops per second, etc.
		 */
		public function start(delay:uint = 0):void
		{
			updateLimit = delay;
			lastUpdate = 0;
			ready = true;
		}
		
		public function draw():void
		{
			if (ready && complete == false)
			{
				if (lastUpdate != updateLimit)
				{
					lastUpdate++;
					
					return;
				}
				
				canvas.fillRect(new Rectangle(0, 0, image.width, image.height), 0x0);
				
				canvas.lock();
			
				//sineData = FlxMath.sinCosGenerator(image.width, f, 1.0, f / 20);
				
				var s:uint = 0;
				
				for (var x:int = 0; x < image.width; x++)
				{
					canvas.copyPixels(image, new Rectangle(x, 0, 1, image.height), new Point(x, sineData[s]));
					s++;
				}
				
				var t:Number = sineData.shift();
				sineData.push(t);
				
				if (up)
				{
					f += 1;
					
					if (f > 64)
					{
						up = false;
					}
				}
				else
				{
					f -= 1;
					
					if (f <= 0)
					{
						up = true;
					}
				}
				
				lastUpdate = 0;
				
				canvas.unlock();
				
				sprite.pixels = canvas;
				sprite.dirty = true;
			}
		}
		
	}

}