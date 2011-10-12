/**
 * FlxMotion
 * -- Part of the Flixel Power Tools set
 * 
 * v2.0 Moved to the new structure for FPT v2.0
 * 
 * @version 2.0 - October 11th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package photonstorm.flixelpowertools.motion 
{
	import org.flixel.*;
	import photonstorm.flixelpowertools.motion.FlxDistance;
	
	public class FlxMotion
	{
		
		public function FlxMotion() 
		{
		}
		
		/**
		 * Sets the source FlxSprite x/y velocity so it will move directly towards the destination FlxSprite at the speed given (in pixels per second)<br>
		 * If you specify a maxTime then it will adjust the speed (over-writing what you set) so it arrives at the destination in that number of seconds.<br>
		 * Timings are approximate due to the way Flash timers work, and irrespective of SWF frame rate. Allow for a variance of +- 50ms.<br>
		 * The source object doesn't stop moving automatically should it ever reach the destination coordinates.<br>
		 * If you need the object to accelerate, see accelerateTowardsObject() instead
		 * Note: Doesn't take into account acceleration, maxVelocity or drag (if you set drag or acceleration too high this object may not move at all)
		 * 
		 * @param	source		The FlxSprite on which the velocity will be set
		 * @param	dest		The FlxSprite where the source object will move to
		 * @param	speed		The speed it will move, in pixels per second (default is 60 pixels/sec)
		 * @param	maxTime		Time given in milliseconds (1000 = 1 sec). If set the speed is adjusted so the source will arrive at destination in the given number of ms
		 */
		public static function moveTowardsObject(source:FlxSprite, dest:FlxSprite, speed:int = 60, maxTime:int = 0):void
		{
			var a:Number = FlxDistance.angleBetween(source, dest);
			
			if (maxTime > 0)
			{
				var d:int = FlxDistance.distanceBetween(source, dest);
				
				//	We know how many pixels we need to move, but how fast?
				speed = d / (maxTime / 1000);
			}
			
			source.velocity.x = Math.cos(a) * speed;
			source.velocity.y = Math.sin(a) * speed;
		}
		
		/**
		 * Sets the x/y acceleration on the source FlxSprite so it will move towards the destination FlxSprite at the speed given (in pixels per second)<br>
		 * You must give a maximum speed value, beyond which the FlxSprite won't go any faster.<br>
		 * If you don't need acceleration look at moveTowardsObject() instead.
		 * 
		 * @param	source			The FlxSprite on which the acceleration will be set
		 * @param	dest			The FlxSprite where the source object will move towards
		 * @param	speed			The speed it will accelerate in pixels per second
		 * @param	xSpeedMax		The maximum speed in pixels per second in which the sprite can move horizontally
		 * @param	ySpeedMax		The maximum speed in pixels per second in which the sprite can move vertically
		 */
		public static function accelerateTowardsObject(source:FlxSprite, dest:FlxSprite, speed:int, xSpeedMax:uint, ySpeedMax:uint):void
		{
			var a:Number = FlxDistance.angleBetween(source, dest);
			
			source.velocity.x = 0;
			source.velocity.y = 0;
			
			source.acceleration.x = int(Math.cos(a) * speed);
			source.acceleration.y = int(Math.sin(a) * speed);
			
			source.maxVelocity.x = xSpeedMax;
			source.maxVelocity.y = ySpeedMax;
		}
		
		/**
		 * Move the given FlxSprite towards the mouse pointer coordinates at a steady velocity
		 * If you specify a maxTime then it will adjust the speed (over-writing what you set) so it arrives at the destination in that number of seconds.<br>
		 * Timings are approximate due to the way Flash timers work, and irrespective of SWF frame rate. Allow for a variance of +- 50ms.<br>
		 * The source object doesn't stop moving automatically should it ever reach the destination coordinates.<br>
		 * 
		 * @param	source		The FlxSprite to move
		 * @param	speed		The speed it will move, in pixels per second (default is 60 pixels/sec)
		 * @param	maxTime		Time given in milliseconds (1000 = 1 sec). If set the speed is adjusted so the source will arrive at destination in the given number of ms
		 */
		public static function moveTowardsMouse(source:FlxSprite, speed:int = 60, maxTime:int = 0):void
		{
			var a:Number = FlxDistance.angleBetweenMouse(source);
			
			if (maxTime > 0)
			{
				var d:int = FlxDistance.distanceToMouse(source);
				
				//	We know how many pixels we need to move, but how fast?
				speed = d / (maxTime / 1000);
			}
			
			source.velocity.x = Math.cos(a) * speed;
			source.velocity.y = Math.sin(a) * speed;
		}
		
		/**
		 * Sets the x/y acceleration on the source FlxSprite so it will move towards the mouse coordinates at the speed given (in pixels per second)<br>
		 * You must give a maximum speed value, beyond which the FlxSprite won't go any faster.<br>
		 * If you don't need acceleration look at moveTowardsMouse() instead.
		 * 
		 * @param	source			The FlxSprite on which the acceleration will be set
		 * @param	speed			The speed it will accelerate in pixels per second
		 * @param	xSpeedMax		The maximum speed in pixels per second in which the sprite can move horizontally
		 * @param	ySpeedMax		The maximum speed in pixels per second in which the sprite can move vertically
		 */
		public static function accelerateTowardsMouse(source:FlxSprite, speed:int, xSpeedMax:uint, ySpeedMax:uint):void
		{
			var a:Number = FlxDistance.angleBetweenMouse(source);
			
			source.velocity.x = 0;
			source.velocity.y = 0;
			
			source.acceleration.x = int(Math.cos(a) * speed);
			source.acceleration.y = int(Math.sin(a) * speed);
			
			source.maxVelocity.x = xSpeedMax;
			source.maxVelocity.y = ySpeedMax;
		}
		
		/**
		 * Sets the x/y velocity on the source FlxSprite so it will move towards the target coordinates at the speed given (in pixels per second)<br>
		 * If you specify a maxTime then it will adjust the speed (over-writing what you set) so it arrives at the destination in that number of seconds.<br>
		 * Timings are approximate due to the way Flash timers work, and irrespective of SWF frame rate. Allow for a variance of +- 50ms.<br>
		 * The source object doesn't stop moving automatically should it ever reach the destination coordinates.<br>
		 * 
		 * @param	source		The FlxSprite to move
		 * @param	target		The FlxPoint coordinates to move the source FlxSprite towards
		 * @param	speed		The speed it will move, in pixels per second (default is 60 pixels/sec)
		 * @param	maxTime		Time given in milliseconds (1000 = 1 sec). If set the speed is adjusted so the source will arrive at destination in the given number of ms
		 */
		public static function moveTowardsPoint(source:FlxSprite, target:FlxPoint, speed:int = 60, maxTime:int = 0):void
		{
			var a:Number = FlxDistance.angleBetweenPoint(source, target);
			
			if (maxTime > 0)
			{
				var d:int = FlxDistance.distanceToPoint(source, target);
				
				//	We know how many pixels we need to move, but how fast?
				speed = d / (maxTime / 1000);
			}
			
			source.velocity.x = Math.cos(a) * speed;
			source.velocity.y = Math.sin(a) * speed;
		}
		
		/**
		 * Sets the x/y acceleration on the source FlxSprite so it will move towards the target coordinates at the speed given (in pixels per second)<br>
		 * You must give a maximum speed value, beyond which the FlxSprite won't go any faster.<br>
		 * If you don't need acceleration look at moveTowardsPoint() instead.
		 * 
		 * @param	source			The FlxSprite on which the acceleration will be set
		 * @param	target			The FlxPoint coordinates to move the source FlxSprite towards
		 * @param	speed			The speed it will accelerate in pixels per second
		 * @param	xSpeedMax		The maximum speed in pixels per second in which the sprite can move horizontally
		 * @param	ySpeedMax		The maximum speed in pixels per second in which the sprite can move vertically
		 */
		public static function accelerateTowardsPoint(source:FlxSprite, target:FlxPoint, speed:int, xSpeedMax:uint, ySpeedMax:uint):void
		{
			var a:Number = FlxDistance.angleBetweenPoint(source, target);
			
			source.velocity.x = 0;
			source.velocity.y = 0;
			
			source.acceleration.x = int(Math.cos(a) * speed);
			source.acceleration.y = int(Math.sin(a) * speed);
			
			source.maxVelocity.x = xSpeedMax;
			source.maxVelocity.y = ySpeedMax;
		}
		
	}

}