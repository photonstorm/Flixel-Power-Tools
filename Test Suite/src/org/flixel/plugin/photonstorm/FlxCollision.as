/**
 * FlxCollision
 * -- Part of the Flixel Power Tools set
 * 
 * v1.5 Added createCameraWall
 * v1.4 Added pixelPerfectPointCheck()
 * v1.3 Update fixes bug where it wouldn't accurately perform collision on AutoBuffered rotated sprites, or sprites with offsets
 * v1.2 Updated for the Flixel 2.5 Plugin system
 * 
 * @version 1.5 - July 27th 2011
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
		
		public static var CAMERA_WALL_OUTSIDE:uint = 0;
		public static var CAMERA_WALL_INSIDE:uint = 1;
		public static var CAMERA_WALL_OVERLAP:uint = 2;
		
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
		
		/**
		 * A Pixel Perfect Collision check between a given x/y coordinate and an FlxSprite<br>
		 * 
		 * @param	pointX			The x coordinate of the point given in local space (relative to the FlxSprite, not game world coordinates)
		 * @param	pointY			The y coordinate of the point given in local space (relative to the FlxSprite, not game world coordinates)
		 * @param	target			The FlxSprite to check the point against
		 * @param	alphaTolerance	The alpha tolerance level above which pixels are counted as colliding. Default to 255 (must be fully transparent for collision)
		 * 
		 * @return	Boolean True if the x/y point collides with the FlxSprite, false if not
		 */
		public static function pixelPerfectPointCheck(pointX:uint, pointY:uint, target:FlxSprite, alphaTolerance:int = 255):Boolean
		{
			//	Intersect check
			if (FlxMath.pointInCoordinates(pointX, pointY, target.x, target.y, target.width, target.height) == false)
			{
				return false;
			}
			
			//	How deep is pointX/Y within the rect?
			var test:BitmapData = target.framePixels;
			
			if (FlxColor.getAlpha(test.getPixel32(pointX - target.x, pointY - target.y)) >= alphaTolerance)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * Creates a "wall" around the given camera which can be used for FlxSprite collision
		 * 
		 * @param	camera				The FlxCamera to use for the wall bounds (can be FlxG.camera for the current one)
		 * @param	placement			CAMERA_WALL_OUTSIDE, CAMERA_WALL_INSIDE or CAMERA_WALL_OVERLAP
		 * @param	thickness			The thickness of the wall in pixels
		 * @param	adjustWorldBounds	Adjust the FlxG.worldBounds based on the wall (true) or leave alone (false)
		 * 
		 * @return	FlxGroup The 4 FlxTileblocks that are created are placed into this FlxGroup which should be added to your State
		 */
		public static function createCameraWall(camera:FlxCamera, placement:uint, thickness:uint, adjustWorldBounds:Boolean = false):FlxGroup
		{
			var region:Rectangle = new Rectangle(camera.x, camera.y, camera.width, camera.height);
			
			//	Region is now the same size as the camera bounds
			
			switch (placement)
			{
				case CAMERA_WALL_OUTSIDE:
					region.x -= thickness;
					region.y -= thickness;
					region.width += thickness * 2;
					region.height += thickness * 2;
					break;
					
				case CAMERA_WALL_INSIDE:
					region.width -= thickness;
					region.height -= thickness;
					break;
					
				case CAMERA_WALL_OVERLAP:
					region.x -= thickness / 2;
					region.y -= thickness / 2;
					//region.width -= thickness / 2;
					//region.height -= thickness / 2;
					break;
			}
			
			trace(region);
			
			var left:FlxTileblock = new FlxTileblock(region.x, region.y, thickness, region.height);
			var right:FlxTileblock = new FlxTileblock(region.right, region.y, thickness, region.height);
			var top:FlxTileblock = new FlxTileblock(region.x, region.y, region.width, thickness);
			var bottom:FlxTileblock = new FlxTileblock(region.x, region.height, region.width, thickness);
			
			if (adjustWorldBounds)
			{
				FlxG.worldBounds = new FlxRect(region.x, region.y, region.width, region.height);
			}
			
			var result:FlxGroup = new FlxGroup(4);
			
			result.add(left);
			result.add(right);
			result.add(top);
			result.add(bottom);
			
			return result;
		}
		
	}

}