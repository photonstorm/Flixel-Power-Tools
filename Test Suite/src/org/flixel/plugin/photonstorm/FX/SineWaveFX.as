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
	 * 
	 * TODO:
	 * 
	 * Allow the sine-wave to run horizontally rather than just vertically
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
		private var waveLoopCallback:Function;
		
		//	For staggered drawing updates
		private var updateLimit:uint = 0;
		private var lastUpdate:uint = 0;
		private var ready:Boolean = false;
		
		private var copyRect:Rectangle;
		private var copyPoint:Point;
		
		public static const WAVETYPE_SINE:uint = 0;
		public static const WAVETYPE_COSINE:uint = 1;
		
		public function SineWaveFX() 
		{
		}
		
		/**
		 * Creates a new SineWaveFX Effect from the given FlxSprite. The original sprite remains unmodified.<br>
		 * The resulting FlxSprite will take on the same width / height and x/y coordinates of the source FlxSprite.<br>
		 * For really cool effects you can SineWave an FlxSprite that is constantly updating (either through animation or an FX chain).
		 * 
		 * @param	source				The FlxSprite providing the image data for this effect. The resulting FlxSprite takes on the source width, height, x/y positions and scrollfactor.
		 * @param	type				WAVETYPE_SINE (0) or WAVETYPE_COSINE (1)
		 * @param	height				The height in pixels of the sine wave
		 * @param	length				The length of the wave. This is based on the source width. A value of 1 means source.width. A value of 2 means source.width * 2, etc.
		 * @param	frequency			The frequency of the peaks in the wave. MUST BE AN EVEN NUMBER! 2, 4, 6, 8, etc.
		 * @param	pixelsPerChunk		How many pixels to use per step. Higher numbers make a more chunky but much faster effect. Make sure source.width divides by this value evenly.
		 * @param	updateFrame			When this FX is created it takes a copy of the FlxSprite image data and uses it. If this is set to true it grabs a new copy of the image data every frame.
		 * @param	backgroundColor		The background color in 0xAARRGGBB format to draw behind the effect (default 0x0 = transparent)
		 * @return	An FlxSprite with the effect running through it, which should be started with a call to SineWaveFX.start()
		 */
		public function createFromFlxSprite(source:FlxSprite, type:uint, height:int, length:uint = 1, frequency:Number = 2, pixelsPerChunk:uint = 1, updateFrame:Boolean = false, backgroundColor:uint = 0x0):FlxSprite
		{
			var result:FlxSprite = create(source.pixels, source.x, source.y, type, height, length, frequency, pixelsPerChunk, backgroundColor);
			
			updateFromSource = updateFrame;
			
			if (updateFrame)
			{
				sourceRef = source;
			}
			
			return result;
		}
		
		/**
		 * Creates a new SineWaveFX Effect from the given Class (which must contain a Bitmap).<br>
		 * If you need to update the source data at run-time then use createFromFlxSprite
		 * 
		 * @param	source				The Class providing the bitmapData for this effect, usually from an Embedded bitmap.
		 * @param	type				WAVETYPE_SINE (0) or WAVETYPE_COSINE (1)
		 * @param	x					The x coordinate (in game world pixels) that the resulting FlxSprite will be created at.
		 * @param	y					The x coordinate (in game world pixels) that the resulting FlxSprite will be created at.
		 * @param	height				The height in pixels of the sine wave
		 * @param	length				The length of the wave. This is based on the source width. A value of 1 means source.width. A value of 2 means source.width * 2, etc.
		 * @param	frequency			The frequency of the peaks in the wave. MUST BE AN EVEN NUMBER! 2, 4, 6, 8, etc.
		 * @param	pixelsPerChunk		How many pixels to use per step. Higher numbers make a more chunky but much faster effect. Make sure source.width divides by this value evenly.
		 * @param	backgroundColor		The background color in 0xAARRGGBB format to draw behind the effect (default 0x0 = transparent)
		 * @return	An FlxSprite with the effect running through it, which should be started with a call to SineWaveFX.start()
		 */
		public function createFromClass(source:Class, type:uint, x:int, y:int, height:int, length:uint = 1, frequency:Number = 2, pixelsPerChunk:uint = 1, backgroundColor:uint = 0x0):FlxSprite
		{
			var result:FlxSprite = create((new source).bitmapData, x, y, type, height, length, frequency, pixelsPerChunk, backgroundColor);
			
			updateFromSource = false;
			
			return result;
		}
		
		/**
		 * Creates a new SineWaveFX Effect from the given bitmapData.<br>
		 * If you need to update the source data at run-time then use createFromFlxSprite
		 * 
		 * @param	source				The bitmapData image to use for this effect.
		 * @param	type				WAVETYPE_SINE (0) or WAVETYPE_COSINE (1)
		 * @param	x					The x coordinate (in game world pixels) that the resulting FlxSprite will be created at.
		 * @param	y					The x coordinate (in game world pixels) that the resulting FlxSprite will be created at.
		 * @param	height				The height in pixels of the sine wave
		 * @param	length				The length of the wave. This is based on the source width. A value of 1 means source.width. A value of 2 means source.width * 2, etc.
		 * @param	frequency			The frequency of the peaks in the wave. MUST BE AN EVEN NUMBER! 2, 4, 6, 8, etc.
		 * @param	pixelsPerChunk		How many pixels to use per step. Higher numbers make a more chunky but much faster effect. Make sure source.width divides by this value evenly.
		 * @param	backgroundColor		The background color in 0xAARRGGBB format to draw behind the effect (default 0x0 = transparent)
		 * @return	An FlxSprite with the effect running through it, which should be started with a call to SineWaveFX.start()
		 */
		public function createFromBitmapData(source:BitmapData, type:uint, x:int, y:int, height:int, length:uint = 1, frequency:Number = 2, pixelsPerChunk:uint = 1, backgroundColor:uint = 0x0):FlxSprite
		{
			var result:FlxSprite = create(source, x, y, type, height, length, frequency, pixelsPerChunk, backgroundColor);
			
			updateFromSource = false;
			
			return result;
		}
		
		//	Internal function fed from createFromFlxSprite / createFromClass / createFromBitmapData
		private function create(source:BitmapData, x:int, y:int, type:uint, height:int, length:uint = 1, frequency:Number = 2, pixelsPerChunk:uint = 1, backgroundColor:uint = 0x0):FlxSprite
		{
			if (type != WAVETYPE_SINE && type != WAVETYPE_COSINE)
			{
				throw new Error("SineWaveFX: Invalid WAVETYPE");
				return null;
			}
			
			if (height >= source.height)
			{
				throw new Error("SineWaveFX: height cannot be >= source.height");
				return null;
			}
			
			if (pixelsPerChunk >= source.width)
			{
				throw new Error("SineWaveFX: pixelsPerChunk cannot be >= source.width");
				return null;
			}
			
			if (FlxMath.isOdd(frequency))
			{
				throw new Error("SineWaveFX: frequency must be an even number");
				return null;
			}
			
			waveType = type;
			waveHeight = height / 2;
			waveLength = (source.width * length) / pixelsPerChunk;
			waveFrequency = frequency;
			wavePixelChunk = pixelsPerChunk;
			waveData = FlxMath.sinCosGenerator(waveLength, waveHeight, waveHeight, waveFrequency);
			
			//	The FlxSprite into which the sine-wave effect is drawn
			sprite = new FlxSprite(x, y).makeGraphic(source.width, source.height + ((waveHeight * 3)), backgroundColor);
			
			//	The scratch bitmapData where we prepare the final sine-waved image
			canvas = new BitmapData(sprite.width, sprite.height, true, backgroundColor);
			
			//	Our local copy of the sprite image data
			image = source.clone();
			
			clsColor = backgroundColor;
			clsRect = new Rectangle(0, 0, canvas.width, canvas.height);
			copyRect = new Rectangle(0, 0, wavePixelChunk, image.height);
			copyPoint = new Point(0, 0);
			
			active = true;
			
			return sprite;
		}
		
		/**
		 * Update the SineWave data without modifying the source image being used.<br>
		 * This call is fast enough that you can modify it in real-time.
		 * 
		 * @param	type				WAVETYPE_SINE (0) or WAVETYPE_COSINE (1)
		 * @param	height				The height in pixels of the sine wave
		 * @param	length				The length of the wave. This is based on the source width. A value of 1 means source.width. A value of 2 means source.width * 2, etc.
		 * @param	frequency			The frequency of the peaks in the wave. MUST BE AN EVEN NUMBER! 2, 4, 6, 8, etc.
		 * @param	pixelsPerChunk		How many pixels to use per step. 1 = the smoothest but most intensive. Make sure source.width divides by this value evenly.
		 */
		public function updateWaveData(type:uint, height:int, length:uint = 1, frequency:Number = 2, pixelsPerChunk:uint = 1):void
		{
			if (type != WAVETYPE_SINE && type != WAVETYPE_COSINE)
			{
				throw new Error("SineWaveFX: Invalid WAVETYPE");
				return null;
			}
			
			if (height >= canvas.height)
			{
				throw new Error("SineWaveFX: height cannot be >= source.height");
				return null;
			}
			
			if (pixelsPerChunk >= canvas.width)
			{
				throw new Error("SineWaveFX: pixelsPerChunk cannot be >= source.width");
				return null;
			}
			
			if (FlxMath.isOdd(frequency))
			{
				throw new Error("SineWaveFX: frequency must be an even number");
				return null;
			}
			
			waveType = type;
			waveHeight = height / 2;
			waveLength = (canvas.width * length) / pixelsPerChunk;
			waveFrequency = frequency;
			wavePixelChunk = pixelsPerChunk;
			waveData = FlxMath.sinCosGenerator(waveLength, waveHeight, waveHeight, waveFrequency);
		}
		
		/**
		 * Use this to set a function to be called every time the wave has completed one full cycle.<br>
		 * Set to null to remove any previous callback.
		 * 
		 * @param	callback		The function to call every time the wave completes a full cycle (duration will vary based on waveLength)
		 */
		public function setLoopCompleteCallback(callback:Function):void
		{
			waveLoopCallback = callback;
		}
		
		/**
		 * Starts the Effect runnning
		 * 
		 * @param	delay	How many "game updates" should pass between each update? If your game runs at 30fps a value of 0 means it will do 30 updates per second. A value of 1 means it will do 15 updates per second, etc.
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
				
				copyRect.x = 0;
				
				for (var x:int = 0; x < image.width; x += wavePixelChunk)
				{
					copyPoint.x = x;
					copyPoint.y = waveHeight + (waveHeight/2) + waveData[s];
					
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
					
					if (waveLoopCallback is Function)
					{
						waveLoopCallback.call();
					}
				}
				
				canvas.unlock();
				
				lastUpdate = 0;
				
				sprite.pixels = canvas;
				sprite.dirty = true;
			}
		}
		
	}

}