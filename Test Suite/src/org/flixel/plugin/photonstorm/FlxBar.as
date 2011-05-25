/**
 * FlxBar
 * -- Part of the Flixel Power Tools set
 * 
 * v1.3 Renamed from FlxHealthBar and made less specific / far more flexible
 * v1.2 Fixed colour values for fill and gradient to include alpha
 * v1.1 Updated for the Flixel 2.5 Plugin system
 * 
 * @version 1.3 - May 25th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;
	
	/**
	 * FlxBar is a quick and easy way to create a graphical bar which can
	 * be used as part of your UI/HUD, or positioned next to a sprite. It could represent
	 * a loader, progress or health bar.
	 * 
	 * TODO
	 * 
	 * Support vertical bars
	 * Hook to any variable, not just health (HealthBar can then extend FlxBar)
	 * Callbacks for full / empty (just trigger once)
	 */
	public class FlxBar
	{
		//	Used by the FlxBarManager plugin
		public var enabled:Boolean = false;
		
		public var sprite:FlxSprite;
		private var canvas:BitmapData;
		
		private var barWidth:uint;
		private var barHeight:uint;
		
		private var parent:*;
		private var parentVariable:String;
		
		public var fixedPosition:Boolean = true;
		public var positionOverSprite:Boolean = false;
		public var positionOffset:FlxPoint;
		
		private var min:Number;
		private var max:Number;
		private var pct:Number;
		private var value:Number;
		private var pxPerPercent:Number;
		
		private var emptyCallback:Function;
		private var emptyCallbackReset:Boolean;
		private var emptyBar:BitmapData;
		private var emptyBarRect:Rectangle;
		private var emptyBarPoint:Point;
		private var zeroOffset:Point = new Point;
		
		private var filledCallback:Function;
		private var filledCallbackReset:Boolean;
		private var filledBar:BitmapData;
		private var filledBarRect:Rectangle;
		private var filledBarPoint:Point;
		
		private var fillDirection:uint;
		private var fillHorizontal:Boolean;
		
		public static const FILL_LEFT_TO_RIGHT:uint = 1;
		public static const FILL_RIGHT_TO_LEFT:uint = 2;
		public static const FILL_TOP_TO_BOTTOM:uint = 3;
		public static const FILL_BOTTOM_TO_TOP:uint = 4;
		public static const FILL_HORIZONTAL_INSIDE_OUT:uint = 5;
		public static const FILL_HORIZONTAL_OUTSIDE_IN:uint = 6;
		public static const FILL_VERTICAL_INSIDE_OUT:uint = 7;
		public static const FILL_VERTICAL_OUTSIDE_IN:uint = 8;
		
		private var barType:uint;
		
		private static const BAR_FILLED:uint = 1;
		private static const BAR_GRADIENT:uint = 2;
		private static const BAR_IMAGE:uint = 3;
		
		public function FlxBar()
		{
		}
		
		/**
		 * Create a new FlxBar Object
		 * 
		 * @param	width		The width of the bar in pixels
		 * @param	height		The height of the bar in pixels
		 * @param	direction 	One of the FlxBar.FILL_ constants (such as FILL_LEFT_TO_RIGHT, FILL_TOP_TO_BOTTOM etc)
		 * @param	min			The minimum value. I.e. for a progress bar this would be zero (nothing loaded yet)
		 * @param	max			The maximum value the bar can reach. I.e. for a progress bar this would typically be 100.
		 * @param	parentRef	A reference to an object in your game that you wish the bar to track
		 * @param	variable	The variable of the object that is used to determine the bar position. For example if the parent was an FlxSprite this could be "health" to track the health value
		 * @param	border		Include a 1px border around the bar? (if true it adds +2 to width and height to accommodate it)
		 * 
		 * @return	FlxSprite	An FlxSprite containing the FlxBar to display in your State
		 */
		public function create(width:int, height:int, direction:uint = FILL_LEFT_TO_RIGHT, min:Number = 0, max:Number = 100, parentRef:* = null, variable:String = "", border:Boolean = false):FlxSprite
		{
			barWidth = width;
			barHeight = height;
			
			if (border)
			{
				sprite = new FlxSprite().makeGraphic(barWidth + 2, barHeight + 2, 0xffffffff, true);
				filledBarPoint = new Point(1, 1);
			}
			else
			{
				sprite = new FlxSprite().makeGraphic(barWidth, barHeight, 0xffffffff, true);
				filledBarPoint = new Point(0, 0);
			}
			
			canvas = new BitmapData(sprite.width, sprite.height, true, 0x0);
			
			if (parentRef)
			{
				parent = parentRef;
				parentVariable = variable;
				
				trace(parent[parentVariable]);
			}
			
			setFillDirection(direction);
			
			setRange(min, max);
			
			createFilledBar(0xff005100, 0xff00F400, border);
			
			enabled = true;
			
			return sprite;
		}
		
		/**
		 * Track the parent FlxSprites x/y coordinates. For example if you wanted your sprite to have a floating health-bar above their head.<br />
		 * If your health bar is 10px tall and you wanted it to appear above your sprite, then set offsetY to be -10<br />
		 * If you wanted it to appear below your sprite, and your sprite was 32px tall, then set offsetY to be 32. Same applies to offsetX.
		 * 
		 * @param	offsetX		The offset on X in relation to the origin x/y of the parent
		 * @param	offsetY		The offset on Y in relation to the origin x/y of the parent
		 * @see		stopTrackingParent
		 */
		public function trackParent(offsetX:int, offsetY:int):void
		{
			fixedPosition = false;
			
			positionOffset = new FlxPoint(offsetX, offsetY);
			
			if (parent.scrollFactor)
			{
				sprite.scrollFactor.x = parent.scrollFactor.x;
				sprite.scrollFactor.y = parent.scrollFactor.y;
			}
		}
		
		/**
		 * Tells the health bar to stop following the parent sprite. The given posX and posY values are where it will remain on-screen.
		 * 
		 * @param	posX	X coordinate of the health bar now it's no longer tracking the parent sprite
		 * @param	posY	Y coordinate of the health bar now it's no longer tracking the parent sprite
		 */
		public function stopTrackingParent(posX:int, posY:int):void
		{
			fixedPosition = true;
			
			sprite.x = posX;
			sprite.y = posY;
		}
		
		/**
		 * Set the minimum and maximum allowed values for the FlxBar
		 * 
		 * @param	Min			The minimum value. I.e. for a progress bar this would be zero (nothing loaded yet)
		 * @param	Max			The maximum value the bar can reach. I.e. for a progress bar this would typically be 100.
		 */
		public function setRange(Min:Number, Max:Number):void
		{
			if (Max <= Min)
			{
				throw Error("FlxBar: max cannot be less than or equal to min");
				return;
			}
			
			min = Min;
			max = Max;
			pct = 100 / (max - min);
			
			if (fillHorizontal)
			{
				pxPerPercent = barWidth / 100;
			}
			else
			{
				pxPerPercent = barHeight / 100;
			}
		}
		
		/**
		 * Creates a solid-colour filled health bar in the given colours, with optional 1px thick border.<br />
		 * All colour values are in 0xAARRGGBB format, so if you want a slightly transparent health bar give it lower AA values.
		 * 
		 * @param	empty		The color of the bar when empty in 0xAARRGGBB format (the background colour)
		 * @param	fill		The color of the bar when full in 0xAARRGGBB format (the foreground colour)
		 * @param	showBorder	Should the bar be outlined with a 1px solid border?
		 * @param	border		The border colour in 0xAARRGGBB format
		 */
		public function createFilledBar(empty:uint, fill:uint, showBorder:Boolean = false, border:uint = 0xffffffff):void
		{
			barType = BAR_FILLED;
			
			if (showBorder)
			{
				emptyBar = new BitmapData(barWidth, barHeight, true, border);
				emptyBar.fillRect(new Rectangle(1, 1, barWidth - 2, barHeight - 2), empty);
				
				filledBar = new BitmapData(barWidth, barHeight, true, border);
				filledBar.fillRect(new Rectangle(1, 1, barWidth - 2, barHeight - 2), fill);
			}
			else
			{
				emptyBar = new BitmapData(barWidth, barHeight, true, empty);
				filledBar = new BitmapData(barWidth, barHeight, true, fill);
			}
			
			filledBarRect = new Rectangle(0, 0, filledBar.width, filledBar.height);
			emptyBarRect = new Rectangle(0, 0, emptyBar.width, emptyBar.height);
		}
		
		/**
		 * Creates a gradient filled health bar using the given colour ranges, with optional 1px thick border.<br />
		 * All colour values are in 0xAARRGGBB format, so if you want a slightly transparent health bar give it lower AA values.
		 * 
		 * @param	empty		Array of colour values used to create the gradient of the health bar when empty, each colour must be in 0xAARRGGBB format (the background colour)
		 * @param	fill		Array of colour values used to create the gradient of the health bar when full, each colour must be in 0xAARRGGBB format (the foreground colour)
		 * @param	chunkSize	If you want a more old-skool looking chunky gradient, increase this value!
		 * @param	rotation	Angle of the gradient in degrees. 90 = top to bottom, 180 = left to right. Any angle is valid
		 * @param	showBorder	Should the bar be outlined with a 1px solid border?
		 * @param	border		The border colour in 0xAARRGGBB format
		 */
		public function createGradientBar(empty:Array, fill:Array, chunkSize:int = 1, rotation:int = 180, showBorder:Boolean = false, border:uint = 0xffffffff):void
		{
			barType = BAR_GRADIENT;
			
			if (showBorder)
			{
				emptyBar = new BitmapData(barWidth, barHeight, true, border);
				FlxGradient.overlayGradientOnBitmapData(emptyBar, barWidth - 2, barHeight - 2, empty, 1, 1, chunkSize, rotation);
				
				filledBar = new BitmapData(barWidth, barHeight, true, border);
				FlxGradient.overlayGradientOnBitmapData(filledBar, barWidth - 2, barHeight - 2, fill, 1, 1, chunkSize, rotation);
			}
			else
			{
				emptyBar = FlxGradient.createGradientBitmapData(barWidth, barHeight, empty, chunkSize, rotation);
				filledBar = FlxGradient.createGradientBitmapData(barWidth, barHeight, fill, chunkSize, rotation);
			}
			
			emptyBarRect = new Rectangle(0, 0, emptyBar.width, emptyBar.height);
			filledBarRect = new Rectangle(0, 0, filledBar.width, filledBar.height);
		}
		
		/**
		 * Creates a health bar filled using the given bitmap images.<br />
		 * You can provide "empty" (background) and "fill" (foreground) images. either one or both images (empty / fill), and use the optional empty/fill colour values 
		 * All colour values are in 0xAARRGGBB format, so if you want a slightly transparent health bar give it lower AA values.
		 * 
		 * @param	empty				Bitmap image used as the background (empty part) of the health bar, if null the emptyBackground colour is used
		 * @param	fill				Bitmap image used as the foreground (filled part) of the health bar, if null the fillBackground colour is used
		 * @param	emptyBackground		If no background (empty) image is given, use this colour value instead. 0xAARRGGBB format
		 * @param	fillBackground		If no foreground (fill) image is given, use this colour value instead. 0xAARRGGBB format
		 */
		public function createImageBar(empty:Class = null, fill:Class = null, emptyBackground:uint = 0xff000000, fillBackground:uint = 0xff00ff00):void
		{
			barType = BAR_IMAGE;
			
			if (empty == null && fill == null)
			{
				return;
			}
			
			if (empty)
			{
				emptyBar = Bitmap(new empty).bitmapData.clone();
			}
			else
			{
				emptyBar = new BitmapData(barWidth, barHeight, true, emptyBackground);
			}
			
			if (fill)
			{
				filledBar = Bitmap(new fill).bitmapData.clone();
			}
			else
			{
				filledBar = new BitmapData(barWidth, barHeight, true, fillBackground);
			}
			
			emptyBarRect = new Rectangle(0, 0, emptyBar.width, emptyBar.height);
			filledBarRect = new Rectangle(0, 0, filledBar.width, filledBar.height);
			
			if (emptyBarRect.width != barWidth || emptyBarRect.height != barHeight)
			{
				barWidth = emptyBarRect.width;
				barHeight = emptyBarRect.height;
			}
		}
		
		/**
		 * Set the direction from which the health bar will fill-up. Default is from left to right. Change takes effect immediately.
		 * 
		 * @param	direction 			One of the FlxBar.FILL_ constants (such as FILL_LEFT_TO_RIGHT, FILL_TOP_TO_BOTTOM etc)
		 */
		public function setFillDirection(direction:uint):void
		{
			switch (direction)
			{
				case FILL_LEFT_TO_RIGHT:
				case FILL_RIGHT_TO_LEFT:
				case FILL_HORIZONTAL_INSIDE_OUT:
				case FILL_HORIZONTAL_OUTSIDE_IN:
					fillDirection = direction;
					fillHorizontal = true;
					break;
					
				case FILL_TOP_TO_BOTTOM:
				case FILL_BOTTOM_TO_TOP:
				case FILL_VERTICAL_INSIDE_OUT:
				case FILL_VERTICAL_OUTSIDE_IN:
					fillDirection = direction;
					fillHorizontal = false;
					break;
			}
		}
		
		private function updateValue():void
		{
			var newValue:Number = parent[parentVariable];
			
			if (newValue > max)
			{
				newValue = max;
			}
			
			if (newValue < min)
			{
				newValue = min;
			}
			
			value = newValue;
		}
		
		/**
		 * Internal
		 * Called when the health bar detects a change in the health of the parent.
		 */
		private function updateBar():void
		{
			if (fillHorizontal)
			{
				filledBarRect.width = int(percent * pxPerPercent);
			}
			else
			{
				filledBarRect.height = int(percent * pxPerPercent);
			}
			
			canvas.copyPixels(emptyBar, emptyBarRect, zeroOffset);
			
			if (percent > 0)
			{
				switch (fillDirection)
				{
					case FILL_LEFT_TO_RIGHT:
					case FILL_TOP_TO_BOTTOM:
						//	Already handled above
						break;
						
					case FILL_BOTTOM_TO_TOP:
						filledBarRect.y = barHeight - filledBarRect.height;
						filledBarPoint.y = barHeight - filledBarRect.height;
						break;
						
					case FILL_RIGHT_TO_LEFT:
						filledBarRect.x = barWidth - filledBarRect.width;
						filledBarPoint.x = barWidth - filledBarRect.width;
						break;
						
					case FILL_HORIZONTAL_INSIDE_OUT:
						filledBarRect.x = int((barWidth / 2) - (filledBarRect.width / 2));
						filledBarPoint.x = int((barWidth / 2) - (filledBarRect.width / 2));
						break;
						
					case FILL_HORIZONTAL_OUTSIDE_IN:
						filledBarRect.width = int(100 - percent * pxPerPercent);
						filledBarPoint.x = int((barWidth - filledBarRect.width) / 2);
						break;
						
					case FILL_VERTICAL_INSIDE_OUT:
						filledBarRect.y = int((barHeight / 2) - (filledBarRect.height / 2));
						filledBarPoint.y = int((barHeight / 2) - (filledBarRect.height / 2));
						break;
						
					case FILL_VERTICAL_OUTSIDE_IN:
						filledBarRect.height = int(100 - percent * pxPerPercent);
						filledBarPoint.y = int((barHeight- filledBarRect.height) / 2);
						break;
				}
				
				canvas.copyPixels(filledBar, filledBarRect, filledBarPoint);
				
			}
			
			sprite.pixels = canvas;
		}
		
		public function get percent():uint
		{
			return Math.floor(value / pct);
		}
		
		public function set percent(newPct:uint):void
		{
			if (newPct >= 0 && newPct <= 100)
			{
				value = newPct * pct;
				
				updateBar();
			}
		}
		
		public function update():void
		{
			if (parent)
			{
				if (parent[parentVariable] != value)
				{
					updateValue();
					updateBar();
				}
				
				if (fixedPosition == false)
				{
					sprite.x = parent.x + positionOffset.x;
					sprite.y = parent.y + positionOffset.y;
				}
			}
		}
		
	}

}