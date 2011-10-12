/**
 * FlxDistance
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
	import photonstorm.flixelpowertools.utils.FlxMath;
	
	public class FlxDistance
	{
		
		public function FlxDistance() 
		{
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
			var dx:Number = (a.x + a.origin.x) - (target.x);
			var dy:Number = (a.y + a.origin.y) - (target.y);
			
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
		 * Find the angle (in radians) between an FlxSprite and the mouse, taking their x/y and origin into account.
		 * The angle is calculated in clockwise positive direction (down = 90 degrees positive, right = 0 degrees positive, up = 90 degrees negative)
		 * 
		 * @param	a			The FlxObject to test from
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
		
		/**
		 * Given the angle and speed calculate the velocity and return it as an FlxPoint
		 * 
		 * @param	angle	The angle (in degrees) calculated in clockwise positive direction (down = 90 degrees positive, right = 0 degrees positive, up = 90 degrees negative)
		 * @param	speed	The speed it will move, in pixels per second sq
		 * 
		 * @return	An FlxPoint where FlxPoint.x contains the velocity x value and FlxPoint.y contains the velocity y value
		 */
		public static function velocityFromAngle(angle:int, speed:int):FlxPoint
		{
			var a:Number = FlxMath.asRadians(angle);
			
			var result:FlxPoint = new FlxPoint;
			
			result.x = int(Math.cos(a) * speed);
			result.y = int(Math.sin(a) * speed);
			
			return result;
		}
		
		/**
		 * Given the FlxSprite and speed calculate the velocity and return it as an FlxPoint based on the direction the sprite is facing
		 * 
		 * @param	parent	The FlxSprite to get the facing value from
		 * @param	speed	The speed it will move, in pixels per second sq
		 * 
		 * @return	An FlxPoint where FlxPoint.x contains the velocity x value and FlxPoint.y contains the velocity y value
		 */
		public static function velocityFromFacing(parent:FlxSprite, speed:int):FlxPoint
		{
			var a:Number;
			
			if (parent.facing == FlxObject.LEFT)
			{
				a = FlxMath.asRadians(180);
			}
			else if (parent.facing == FlxObject.RIGHT)
			{
				a = FlxMath.asRadians(0);
			}
			else if (parent.facing == FlxObject.UP)
			{
				a = FlxMath.asRadians( -90);
			}
			else if (parent.facing == FlxObject.DOWN)
			{
				a = FlxMath.asRadians(90);
			}
			
			var result:FlxPoint = new FlxPoint;
			
			result.x = int(Math.cos(a) * speed);
			result.y = int(Math.sin(a) * speed);
			
			return result;
		}
		
	}

}