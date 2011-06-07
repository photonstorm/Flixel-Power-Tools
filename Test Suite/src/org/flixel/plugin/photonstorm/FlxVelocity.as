/**
 * FlxVelocity
 * -- Part of the Flixel Power Tools set
 * 
 * v1.4 New methods: moveTowardsPoint, distanceToPoint, angleBetweenPoint
 * v1.3 Updated for the Flixel 2.5 Plugin system
 * 
 * @version 1.4 - June 7th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
 * @see Depends on FlxMath
*/

package org.flixel.plugin.photonstorm 
{
	import org.flixel.*;
	
	public class FlxVelocity 
	{
		
		public function FlxVelocity() 
		{
		}
		
		/**
		 * Sets the source FlxSprite x/y velocity so it will move directly towards the destination FlxObject at the speed given (in pixels per second)
		 * If you specify a maxTime then it will adjust the speed (over-writing what you set) so it arrives at the destination in that number of seconds
		 * Note that timings are approximate due to the way Flash timers work, and irrespective of SWF frame rate. Allow for a variance of +- 50ms.
		 * Note that source object doesn't stop moving automatically should it ever reach the destination coordinates
		 * Note: Doesn't take into account acceleration, maxVelocity or drag (if you set drag or acceleration too high this object may not move at all)
		 * 
		 * @param	source		The FlxSprite on which the velocity will be set
		 * @param	dest		The FlxSprite where the source object will move to
		 * @param	speed		The speed it will move, in pixels per second (default is 60 pixels/sec)
		 * @param	maxTime		Time given in milliseconds (1000 = 1 sec). If set the speed is adjusted so the source will arrive at destination in the given number of ms
		 */
		public static function moveTowardsObject(source:FlxSprite, dest:FlxSprite, speed:int = 60, maxTime:int = 0):void
		{
			var a:Number = angleBetween(source, dest);
			
			if (maxTime > 0)
			{
				var d:int = distanceBetween(source, dest);
				
				//	We know how many pixels we need to move, but how fast?
				speed = d / (maxTime / 1000);
			}
			
			source.velocity.x = Math.cos(a) * speed;
			source.velocity.y = Math.sin(a) * speed;
		}
		
		/**
		 * Move the given FlxSprite towards the mouse pointer coordinates
		 * 
		 * @param	source		The FlxSprite to move
		 * @param	speed		The speed it will move, in pixels per second (default is 60 pixels/sec)
		 * @param	maxTime		Time given in milliseconds (1000 = 1 sec). If set the speed is adjusted so the source will arrive at destination in the given number of ms
		 */
		public static function moveTowardsMouse(source:FlxSprite, speed:int = 60, maxTime:int = 0):void
		{
			var a:Number = angleBetweenMouse(source);
			
			if (maxTime > 0)
			{
				var d:int = distanceToMouse(source);
				
				//	We know how many pixels we need to move, but how fast?
				speed = d / (maxTime / 1000);
			}
			
			source.velocity.x = Math.cos(a) * speed;
			source.velocity.y = Math.sin(a) * speed;
			
		}
		
		/**
		 * Move the given FlxSprite towards the mouse pointer coordinates
		 * 
		 * @param	source		The FlxSprite to move
		 * @param	speed		The speed it will move, in pixels per second (default is 60 pixels/sec)
		 * @param	maxTime		Time given in milliseconds (1000 = 1 sec). If set the speed is adjusted so the source will arrive at destination in the given number of ms
		 */
		public static function moveTowardsPoint(source:FlxSprite, target:FlxPoint, speed:int = 60, maxTime:int = 0):void
		{
			var a:Number = angleBetweenPoint(source, target);
			
			if (maxTime > 0)
			{
				var d:int = distanceToPoint(source, target);
				
				//	We know how many pixels we need to move, but how fast?
				speed = d / (maxTime / 1000);
			}
			
			source.velocity.x = Math.cos(a) * speed;
			source.velocity.y = Math.sin(a) * speed;
			
		}
		
		/**
		 * Find the distance (in pixels, rounded) between two FlxSprites, taking their origin into account
		 * 
		 * @param	a	The first FlxSprite
		 * @param	b	The second FlxSprite
		 * @return	int	Distance (in pixels)
		 */
		public static function distanceBetween(a:FlxSprite, b:FlxSprite):int
		{
			var dx:Number = (a.x + a.origin.x) - (b.x + b.origin.x);
			var dy:Number = (a.y + a.origin.y) - (b.y + b.origin.y);
			
			return int(FlxMath.vectorLength(dx, dy));
		}
		
		/**
		 * Find the distance (in pixels, rounded) from an FlxSprite to the given FlxPoint, taking the source origin into account
		 * 
		 * @param	a		The first FlxSprite
		 * @param	target	The FlxPoint
		 * @return	int		Distance (in pixels)
		 */
		public static function distanceToPoint(a:FlxSprite, target:FlxPoint):int
		{
			var dx:Number = (a.x + a.origin.x) - (b.x);
			var dy:Number = (a.y + a.origin.y) - (b.y);
			
			return int(FlxMath.vectorLength(dx, dy));
		}
		
		/**
		 * Find the distance (in pixels, rounded) from the object x/y and the mouse x/y
		 * 
		 * @param	a	The FlxSprite to test against
		 * @return	int	The distance between the given sprite and the mouse coordinates
		 */
		public static function distanceToMouse(a:FlxSprite):int
		{
			var dx:Number = (a.x + a.origin.x) - FlxG.mouse.screenX;
			var dy:Number = (a.y + a.origin.y) - FlxG.mouse.screenY;
			
			return int(FlxMath.vectorLength(dx, dy));
		}
		
		/**
		 * Find the angle (in radians) between an FlxSprite and an FlxPoint. The source sprite takes its x/y and origin into account.
		 * The angle is calculated in clockwise positive direction (down = 90 degrees positive, right = 0 degrees positive, up = 90 degrees negative)
		 * 
		 * @param	a			The FlxSprite to test from
		 * @param	target		The FlxPoint to angle the FlxSprite towards
		 * @param	asDegrees	If you need the value in degrees instead of radians, set to true
		 * 
		 * @return	Number The angle (in radians unless asDegrees is true)
		 */
		public static function angleBetweenPoint(a:FlxSprite, target:FlxPoint, asDegrees:Boolean = false):Number
        {
			var dx:Number = (target.x) - (a.x + a.origin.x);
			var dy:Number = (target.y) - (a.y + a.origin.y);
			
			if (asDegrees)
			{
				return FlxMath.asDegrees(Math.atan2(dy, dx));
			}
			else
			{
				return Math.atan2(dy, dx);
			}
        }
		
		/**
		 * Find the angle (in radians) between the two FlxSprite, taking their x/y and origin into account.
		 * The angle is calculated in clockwise positive direction (down = 90 degrees positive, right = 0 degrees positive, up = 90 degrees negative)
		 * 
		 * @param	a			The FlxSprite to test from
		 * @param	b			The FlxSprite to test to
		 * @param	asDegrees	If you need the value in degrees instead of radians, set to true
		 * 
		 * @return	Number The angle (in radians unless asDegrees is true)
		 */
		public static function angleBetween(a:FlxSprite, b:FlxSprite, asDegrees:Boolean = false):Number
        {
			var dx:Number = (b.x + b.origin.x) - (a.x + a.origin.x);
			var dy:Number = (b.y + b.origin.y) - (a.y + a.origin.y);
			
			if (asDegrees)
			{
				return FlxMath.asDegrees(Math.atan2(dy, dx));
			}
			else
			{
				return Math.atan2(dy, dx);
			}
        }
		
		/**
		 * Find the angle (in radians) between an FlxSprite and the mouse, taking their x/y and origin into account.
		 * The angle is calculated in clockwise positive direction (down = 90 degrees positive, right = 0 degrees positive, up = 90 degrees negative)
		 * 
		 * @param	a			The FlxObject to test from
		 * @param	b			The FlxObject to test to
		 * @param	asDegrees	If you need the value in degrees instead of radians, set to true
		 * 
		 * @return	Number The angle (in radians unless asDegrees is true)
		 */
		public static function angleBetweenMouse(a:FlxSprite, asDegrees:Boolean = false):Number
		{
			//	In order to get the angle between the object and mouse, we need the objects screen coordinates (rather than world coordinates)
			var p:FlxPoint = a.getScreenXY();
			
			var dx:Number = FlxG.mouse.screenX - p.x;
			var dy:Number = FlxG.mouse.screenY - p.y;
			
			if (asDegrees)
			{
				return FlxMath.asDegrees(Math.atan2(dy, dx));
			}
			else
			{
				return Math.atan2(dy, dx);
			}
		}
        
		
		
	}

}