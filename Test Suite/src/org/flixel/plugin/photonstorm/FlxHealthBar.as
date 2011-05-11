/**
 * FlxHealthBar
 * -- Part of the Flixel Power Tools set
 * 
 * v1.2 Fixed colour values for fill and gradient to include alpha
 * v1.1 Updated for the Flixel 2.5 Plugin system
 * 
 * @version 1.2 - May 5th 2011
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
	 * FlxHealthBar is a quick and easy way to create a graphical health bar which can
	 * be used as part of your UI/HUD, or positioned next to a sprite.
	 */
	public class FlxHealthBar extends FlxSprite
	{
		private var parent:FlxSprite;
		
		public var fixedPosition:Boolean = true;
		
		public var positionOffset:FlxPoint;
		
		public var positionOverSprite:Boolean = false;
		
		private var prevHealth:int;
		private var pxPerHealth:Number;
		private var min:uint;
		private var max:uint;
		
		private var zeroOffset:Point = new Point;
		
		private var emptyBar:BitmapData;
		private var emptyBarRect:Rectangle;
		
		private var filledBar:BitmapData;
		private var filledBarRect:Rectangle;
		
		private var fillDirection:int;
		
		public static const FILL_LEFT_TO_RIGHT:int = 1;
		public static const FILL_RIGHT_TO_LEFT:int = 2;
		public static const FILL_INSIDE_OUT:int = 3;
		
		private var barType:int;
		
		private static const BAR_FILLED:int = 1;
		private static const BAR_GRADIENT:int = 2;
		private static const BAR_IMAGE:int = 3;
		
		/**
		 * Create a new Health Bar object.
		 * 
		 * @param	Parent	The parent FlxSprite who's health value this bar will monitor
		 * @param	Width	The display width of the health bar
		 * @param	Height	The display height of the health bar
		 * @param	Min		The minimum value that Parent.health is allowed to drop to (that the bar will render)
		 * @param	Max		The maximum value that Parent.health can be
		 * @param	Border	Include a 1px border around the bar? (if true it adds +2 to width and height to accommodate it)
		 */
		public function FlxHealthBar(Parent:FlxSprite, Width:int, Height:int, Min:uint = 0, Max:uint = 100, Border:Boolean = false):void
		{
			super();
			
			parent = Parent;
			
			if (Border)
			{
				makeGraphic(Width + 2, Height + 2, 0xffffffff, true);
				width = Width + 2;
				height = Height + 2;
			}
			else
			{
				makeGraphic(Width, Height, 0xffffffff, true);
				width = Width;
				height = Height;
			}
			
			fillDirection = FILL_LEFT_TO_RIGHT;
			
			setRange(Min, Max);
			
			createFilledBar(0xff005100, 0xff00F400, Border);
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
			
			scrollFactor.x = parent.scrollFactor.x;
			scrollFactor.y = parent.scrollFactor.y;
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
			
			x = posX;
			y = posY;
		}
		
		/**
		 * Set the minimum and maximum allowed values for the parents health value
		 * 
		 * @param	Min		Minimum allowed health value
		 * @param	Max		Maximum allowed health value
		 */
		public function setRange(Min:uint, Max:uint):void
		{
			if (Max == 0)
			{
				return;
			}
			
			if (Min == Max)
			{
				return;
			}
			
			if (Max < Min)
			{
				throw Error("FlxHealthBar: max cannot be less than min");
				return;
			}
			
			min = Min;
			max = Max;
			
			pxPerHealth = (width / max);
		}
		
		/**
		 * Creates a solid-colour filled health bar in the given colours, with optional 1px thick border.<br />
		 * All colour values are in 0xAARRGGBB format, so if you want a slightly transparent health bar give it lower AA values.
		 * 
		 * @param	empty		The color of the health bar when empty in 0xAARRGGBB format (the background colour)
		 * @param	fill		The color of the health bar when full in 0xAARRGGBB format (the foreground colour)
		 * @param	showBorder	Should the bar be outlined with a 1px solid border?
		 * @param	border		The border colour in 0xAARRGGBB format
		 */
		public function createFilledBar(empty:uint, fill:uint, showBorder:Boolean = false, border:uint = 0xffffffff):void
		{
			barType = BAR_FILLED;
			
			if (showBorder)
			{
				emptyBar = new BitmapData(width, height, true, border);
				emptyBar.fillRect(new Rectangle(1, 1, width - 2, height - 2), empty);
				
				filledBar = new BitmapData(width, height, true, border);
				filledBar.fillRect(new Rectangle(1, 1, width - 2, height - 2), fill);
			}
			else
			{
				emptyBar = new BitmapData(width, height, true, empty);
				filledBar = new BitmapData(width, height, true, fill);
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
				emptyBar = new BitmapData(width, height, true, border);
				FlxGradient.overlayGradientOnBitmapData(emptyBar, width - 2, height - 2, empty, 1, 1, chunkSize, rotation);
				
				filledBar = new BitmapData(width, height, true, border);
				FlxGradient.overlayGradientOnBitmapData(filledBar, width - 2, height - 2, fill, 1, 1, chunkSize, rotation);
			}
			else
			{
				emptyBar = FlxGradient.createGradientBitmapData(width, height, empty, chunkSize, rotation);
				filledBar = FlxGradient.createGradientBitmapData(width, height, fill, chunkSize, rotation);
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
				emptyBar = new BitmapData(width, height, true, emptyBackground);
			}
			
			if (fill)
			{
				filledBar = Bitmap(new fill).bitmapData.clone();
			}
			else
			{
				filledBar = new BitmapData(width, height, true, fillBackground);
			}
			
			emptyBarRect = new Rectangle(0, 0, emptyBar.width, emptyBar.height);
			filledBarRect = new Rectangle(0, 0, filledBar.width, filledBar.height);
			
			if (emptyBarRect.width != width || emptyBarRect.height != height)
			{
				width = emptyBarRect.width;
				height = emptyBarRect.height;
			}
		}
		
		/**
		 * Set the direction from which the health bar will fill-up. Default is from left to right. Change takes effect immediately.
		 * 
		 * @param	direction Either FILL_LEFT_TO_RIGHT, FILL_RIGHT_TO_LEFT or FILL_INSIDE_OUT
		 */
		public function setFillDirection(direction:int):void
		{
			if (direction == FILL_LEFT_TO_RIGHT || direction == FILL_RIGHT_TO_LEFT || direction == FILL_INSIDE_OUT)
			{
				fillDirection = direction;
			}
		}
		
		/**
		 * Internal
		 * Called when the health bar detects a change in the health of the parent.
		 */
		private function updateBar():void
		{
			var temp:BitmapData = pixels;
			
			temp.copyPixels(emptyBar, emptyBarRect, zeroOffset);
			
			if (parent.health < min)
			{
				filledBarRect.width = int(min * pxPerHealth);
			}
			else if (parent.health > max)
			{
				filledBarRect.width = int(max * pxPerHealth);
			}
			else
			{
				filledBarRect.width = int(parent.health * pxPerHealth);
			}
			
			if (parent.health != 0)
			{
				switch (fillDirection)
				{
					case FILL_LEFT_TO_RIGHT:
						temp.copyPixels(filledBar, filledBarRect, zeroOffset);
						break;
						
					case FILL_RIGHT_TO_LEFT:
						filledBarRect.x = width - filledBarRect.width;
						temp.copyPixels(filledBar, filledBarRect, new Point(width - filledBarRect.width, 0));
						break;
						
					case FILL_INSIDE_OUT:
						filledBarRect.x = int((width / 2) - (filledBarRect.width / 2));
						temp.copyPixels(filledBar, filledBarRect, new Point((width / 2) - (filledBarRect.width / 2), 0));
						break;
				}
			}
			
			pixels = temp;
					
			prevHealth = parent.health;
		}
		
		override public function update():void
		{
			super.update();
			
			if (parent.exists)
			{
				//	Is this health bar floating over / under the sprite?
				if (fixedPosition == false)
				{
					x = parent.x + positionOffset.x;
					y = parent.y + positionOffset.y;
				}
				
				//	Update?
				if (parent.health != prevHealth)
				{
					updateBar();
				}
			}
		}
		
	}

}