/**
 * FlxDisplay
 * -- Part of the Flixel Power Tools set
 * 
 * v1.3 Added "screenWrap" method
 * v1.2 Added "space" method
 * v1.1 Updated for the Flixel 2.5 Plugin system
 * 
 * @version 1.3 - June 15th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm 
{
	import org.flixel.*;
	
	public class FlxDisplay 
	{
		
		public function FlxDisplay() 
		{
		}
		
		public function pad():void
		{
			//	Pad the sprite out with empty pixels left/right/above/below it
		}
		
		public function flip():void
		{
			//	mirror / reverse?
			//	Flip image data horizontally / vertically without changing the angle
		}
		
		/**
		 * Checks the x/y coordinates of the source FlxSprite and keeps them within the area of 0, 0, FlxG.width, FlxG.height (i.e. wraps it around the screen)
		 * 
		 * @param	source	The FlxSprite to keep within the screen
		 */
		public static function screenWrap(source:FlxSprite):void
		{
			if (source.x < 0)
			{
				source.x = FlxG.width;
			}
			else if (source.x > FlxG.width)
			{
				source.x = 0;
			}
			
			if (source.y < 0)
			{
				source.y = FlxG.height;
			}
			else if (source.y > FlxG.height)
			{
				source.y = 0;
			}
		}
		
		/**
		 * Takes the bitmapData from the given source FlxSprite and rotates it 90 degrees clockwise.<br>
		 * Can be useful if you need to control a sprite under rotation but it isn't drawn facing right.<br>
		 * This change overwrites FlxSprite.pixels, but will not work with animated sprites.
		 * 
		 * @param	source		The FlxSprite who's image data you wish to rotate clockwise
		 */
		public static function rotateClockwise(source:FlxSprite):void
		{
		}
		
		/**
		 * Aligns a set of FlxSprites so there is equal spacing between them
		 * 
		 * @param	sprites				An Array of FlxSprites
		 * @param	startX				The base X coordinate to start the spacing from
		 * @param	startY				The base Y coordinate to start the spacing from
		 * @param	horizontalSpacing	The amount of pixels between each sprite horizontally (default 0)
		 * @param	verticalSpacing		The amount of pixels between each sprite vertically (default 0)
		 * @param	spaceFromBounds		If set to true the h/v spacing values will be added to the width/height of the sprite, if false it will ignore this
		 */
		public static function space(sprites:Array, startX:int, startY:int, horizontalSpacing:int = 0, verticalSpacing:int = 0, spaceFromBounds:Boolean = false):void
		{
			var prevWidth:int = 0;
			var prevHeight:int = 0;
			
			for (var i:int = 0; i < sprites.length; i++)
			{
				var sprite:FlxSprite = sprites[i];
				
				if (spaceFromBounds)
				{
					sprite.x = startX + prevWidth + (i * horizontalSpacing);
					sprite.y = startY + prevHeight + (i * verticalSpacing);
				}
				else
				{
					sprite.x = startX + (i * horizontalSpacing);
					sprite.y = startY + (i * verticalSpacing);
				}
			}
		}
		
		/**
		 * Centers the given FlxSprite on the screen, either by the X axis, Y axis, or both
		 * 
		 * @param	source	The FlxSprite to center
		 * @param	xAxis	Boolean true if you want it centered on X (i.e. in the middle of the screen)
		 * @param	yAxis	Boolean	true if you want it centered on Y
		 * 
		 * @return	The FlxSprite for chaining
		 */
		public static function screenCenter(source:FlxSprite, xAxis:Boolean = true, yAxis:Boolean = false):FlxSprite
		{
			if (xAxis)
			{
				source.x = (FlxG.width / 2) - (source.width / 2);
			}
			
			if (yAxis)
			{
				source.y = (FlxG.height / 2) - (source.height / 2);
			}

			return source;
		}
		
	}

}