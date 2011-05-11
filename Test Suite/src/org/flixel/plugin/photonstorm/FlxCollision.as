/**
 * FlxCollision
 * -- Part of the Flixel Power Tools set
 * 
 * Updated for the Flixel 2.5 Plugin system
 * 
 * v1.3 Update fixes bug where it wouldn't accurately perform collision on AutoBuffered rotated sprites, or sprites with offsets
 * 
 * @version 1.3 - April 27th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.BlendMode;
	
	import org.flixel.*;
	
	public class FlxCollision 
	{
		public static var debug:BitmapData = new BitmapData(1, 1, false);
		
		public function FlxCollision() 
		{
		}
		
		/**
		 * A Pixel Perfect Collision check between two FlxSprites.<br />
		 * It will do a bounds check first, and if that passes it will run a pixel perfect match on the intersecting area.<br />
		 * Works with rotated, scaled and animated sprites.<br /><br />
		 * 
		 * @param	contact			The first FlxSprite to test against
		 * @param	target			The second FlxSprite to test again, sprite order is irrelevant
		 * @param	alphaTolerance	The tolerance value above which alpha pixels are included. Default to 255 (must be fully opaque for collision).
		 * 
		 * @return	Boolean True if the sprites collide, false if not
		 */
		public static function pixelPerfectCheck(contact:FlxSprite, target:FlxSprite, alphaTolerance:int = 255):Boolean
		{
			var boundsA:Rectangle = new Rectangle(contact.x, contact.y, contact.width, contact.height);
			var boundsB:Rectangle = new Rectangle(target.x, target.y, target.width, target.height);
			
			var intersect:Rectangle = boundsA.intersection(boundsB);
			
			if (intersect.isEmpty() || intersect.width == 0 || intersect.height == 0)
			{
				return false;
			}
			
			//	Normalise the values or it'll break the BitmapData creation below
			intersect.x = Math.floor(intersect.x);
			intersect.y = Math.floor(intersect.y);
			intersect.width = Math.ceil(intersect.width);
			intersect.height = Math.ceil(intersect.height);
			
			if (intersect.isEmpty())
			{
				return false;
			}
			
			//	Thanks to Chris Underwood for helping with the translate logic :)
			
			var matrixA:Matrix = new Matrix;
			matrixA.translate(-((intersect.x - boundsA.x) + contact.offset.x), -((intersect.y - boundsA.y) + contact.offset.y));
			
			var matrixB:Matrix = new Matrix;
			matrixB.translate(-((intersect.x - boundsB.x) + target.offset.x), -((intersect.y - boundsB.y) + target.offset.y));
			
			var testA:BitmapData = contact.framePixels;
			var testB:BitmapData = target.framePixels;
			var overlapArea:BitmapData = new BitmapData(intersect.width, intersect.height, false);
			
			overlapArea.draw(testA, matrixA, new ColorTransform(1, 1, 1, 1, 255, -255, -255, alphaTolerance), BlendMode.NORMAL);
			overlapArea.draw(testB, matrixB, new ColorTransform(1, 1, 1, 1, 255, 255, 255, alphaTolerance), BlendMode.DIFFERENCE);
			
			//	Developers: If you'd like to see how this works, display it in your game somewhere. Or you can comment it out to save a tiny bit of performance
			debug = overlapArea;
			
			var overlap:Rectangle = overlapArea.getColorBoundsRect(0xffffffff, 0xff00ffff);
			overlap.offset(intersect.x, intersect.y);
			
			if (overlap.isEmpty())
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
	}

}