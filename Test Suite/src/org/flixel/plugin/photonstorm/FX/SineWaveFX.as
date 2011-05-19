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
		private var image:BitmapData;
		private var sourceRef:FlxSprite;
		private var updateFromSource:Boolean;
		private var clsRect:Rectangle;
		private var clsColor:uint;
		
		private var waveType:uint;
		private var waveLength:uint;
		private var waveHeight:uint;
		private var waveFrequency:Number;
		private var wavePixelChunk:uint;
		private var waveData:Array;
		
		private var waveDataCounter:uint = 0;
		
		//	For staggered drawing updates
		private var updateLimit:uint = 0;
		private var lastUpdate:uint = 0;
		//private var complete:Boolean = false;
		private var ready:Boolean = false;
		
		//public var f:Number = 1;
		//public var up:Boolean = true;
		
		public static const WAVETYPE_SINE:uint = 0;
		public static const WAVETYPE_COSINE:uint = 1;
		
		public function SineWaveFX() 
		{
		}
		
		public function createFromFlxSprite(source:FlxSprite, type:uint, sinHeight:int, sinLength:uint = 1, frequency:Number = 2, pixelsPerChunk:uint = 1, updateOnLoop:Boolean = false, backgroundColor:uint = 0x0):FlxSprite
		{
			waveType = type;
			//	works for freq 1 and 2 then breaks!
			waveHeight = sinHeight / frequency;
			//waveHeight = sinHeight;
			waveFrequency = frequency;
			wavePixelChunk = pixelsPerChunk;
			
			//	The FlxSprite into which the sine-wave effect is drawn
			
			sprite = new FlxSprite(source.x, source.y).makeGraphic(source.width, source.height + ((waveHeight * 2)), backgroundColor);
			
			//sprite = new FlxSprite(source.x, source.y).makeGraphic(source.width, source.height + ((waveHeight * 2) * waveFrequency), backgroundColor);
			
			//	The scratch bitmapData where we prepare the final sine-waved image
			canvas = new BitmapData(sprite.width, sprite.height, true, backgroundColor);
			
			//	Our local copy of the sprite image data
			image = source.pixels;
			
			waveLength = (image.width * sinLength) / pixelsPerChunk;
			
			updateFromSource = updateOnLoop;
			
			if (updateOnLoop)
			{
				sourceRef = source;
			}
			
			clsColor = backgroundColor;
			clsRect = new Rectangle(0, 0, canvas.width, canvas.height);
			
			//	ODD frequency values cause the image to split half-way through the sine, probably the result of the * 2 value below?
			//	ODD numbers get half the sine, need * 2 below? or should we split that out to a SineLength value? (could be a multiple of the image width?)
			
			if (waveType == WAVETYPE_SINE)
			{
				waveData = FlxMath.sinCosGenerator(waveLength, waveHeight, 1.0, waveFrequency);
				//waveData = FlxMath.sinCosGenerator(image.width * waveLength, waveHeight, 1.0, waveFrequency);
			}
			else if (waveType == WAVETYPE_COSINE)
			{
				//waveData = FlxMath.sinCosGenerator(canvas.width * 2, 1.0, waveHeight, waveFrequency);
			}
			else
			{
				throw new Error("SineWaveFX: Invalid WAVETYPE");
				
				return null;
			}
			
			active = true;
			
			return sprite;
		}
		
		/*
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
		
		*/
		
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
			if (ready)
			{
				if (lastUpdate != updateLimit)
				{
					lastUpdate++;
					
					return;
				}
				
				if (updateFromSource)
				{
					image = sourceRef.framePixels;
				}
				
				canvas.lock();
				
				canvas.fillRect(clsRect, clsColor);
				
				var s:uint = 0;
				
				//	Could move these to constructor actually, save creating any objects at run-time
				var copyRect:Rectangle = new Rectangle(0, 0, wavePixelChunk, image.height);
				var copyPoint:Point = new Point(0, 0);
				
				for (var x:int = 0; x < image.width; x += wavePixelChunk)
				{
					copyPoint.x = x;
					copyPoint.y = waveHeight + waveData[s];
					
					canvas.copyPixels(image, copyRect, copyPoint);
					
					copyRect.x += wavePixelChunk;
					
					s++;
				}
				
				//	Cycle through the wave data - this is what causes the image to "undulate"
				var t:Number = waveData.shift();
				waveData.push(t);
				
				waveDataCounter++;
				
				if (waveDataCounter == waveData.length)
				{
					waveDataCounter = 0;
					trace("wave data loop");
				}
				
				//if (up)
				//{
					//f += 1;
					//
					//if (f > 64)
					//{
						//up = false;
					//}
				//}
				//else
				//{
					//f -= 1;
					//
					//if (f <= 0)
					//{
						//up = true;
					//}
				//}
				
				canvas.unlock();
				
				lastUpdate = 0;
				
				sprite.pixels = canvas;
				sprite.dirty = true;
			}
		}
		
	}

}