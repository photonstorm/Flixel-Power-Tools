/**
 * Weapon - Base Class for the FlxBulletManager
 * -- Part of the Flixel Power Tools set
 * 
 * v1.0 First release
 * 
 * @version 1.0 - June 10th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
 * @see Requires Bullet, FlxBulletManager
*/

package org.flixel.plugin.photonstorm.BaseTypes 
{
	import org.flixel.*;
	
	/**
	 * A Weapon can only fire 1 type of bullet. But it can fire many of them at once (in different directions if needed)
	 * A Player could fire multiple Weapons at the same time however
	 * 
	 * TODO
	 * ----
	 * 
	 * Baked Rotation support for angled bullets
	 * Animated bullets
	 * Bullet death styles (particle effects)
	 * Assigning sound effects
	 */
	
	public class Weapon 
	{
		/**
		 * If active this Weapon will be processed by the FlxBulletManager
		 */
		public var active:Boolean = false;
		
		/**
		 * Internal name for this weapon (i.e. "pulse rifle")
		 */
		public var name:String;
		
		/**
		 * The FlxGroup into which all the bullets for this weapon are drawn. This should be added to your display and collision checked against it.
		 */
		public var group:FlxGroup;
		
		//	Bullet values
		private var bounds:FlxRect;
		private var bulletSprite:FlxSprite;
		private var bulletSpeed:uint;
		private var rotateToAngle:Boolean;
		
		//	When firing from a fixed position (i.e. Missile Command)
		private var fireFromPosition:Boolean;
		private var fireX:int;
		private var fireY:int;
		
		//	When firing from a parent sprites position (i.e. Space Invaders)
		private var fireFromParent:Boolean;
		private var parent:*;
		private var parentXVariable:String;
		private var parentYVariable:String;
		private var positionOffset:FlxPoint;
		
		//	Callbacks
		public var onKillCallback:Function;
		public var onFireCallback:Function;
		
		//	Sounds
		public var playSounds:Boolean;
		public var onKillSound:FlxSound;
		public var onFireSound:FlxSound;
		
		//	Quick firing direction constants
		public static const BULLET_UP:int = 0;
		public static const BULLET_DOWN:int = 0;
		public static const BULLET_LEFT:int = 1;
		public static const BULLET_RIGHT:int = 1;
		public static const BULLET_NORTH_EAST:int = 1;
		public static const BULLET_NORTH_WEST:int = 1;
		public static const BULLET_SOUTH_EAST:int = 1;
		public static const BULLET_SOUTH_WEST:int = 1;
		
		//	TODO :)
		private var bulletsFired:uint;
		private var currentMagazine:uint;
		private var currentBullet:uint;
		private var magazineCount:uint;
		private var bulletsPerMagazine:uint;
		private var magazineSwapDelay:uint;
		private var magazineSwapCallback:Function;
		private var magazineSwapSound:FlxSound;
		
		private static const FIRE:uint = 0;
		private static const FIRE_AT_MOUSE:uint = 1;
		private static const FIRE_AT_POSITION:uint = 2;
		private static const FIRE_AT_TARGET:uint = 3;
		
		/**
		 * Creates the Weapon class which will fire your bullets.<br>
		 * You should call one of the makeBullet functions to visually create the bullets.<br>
		 * Then either use setDirection with fire() or one of the fireAt functions to launch them.
		 * 
		 * @param	name		The name of your weapon (i.e. "lazer" or "shotgun"). For your internal reference really, but could be displayed in-game.
		 * @param	parentRef	If this weapon belongs to a parent sprite, specify it here (bullets will fire from the sprites x/y vars as defined below).
		 * @param	xVariable	The x axis variable of the parent to use when firing. Typically "x", but could be "screenX" or any public getter that exposes the x coordinate.
		 * @param	yVariable	The y axis variable of the parent to use when firing. Typically "y", but could be "screenY" or any public getter that exposes the y coordinate.
		 */
		public function Weapon(name:String, parentRef:* = null, xVariable:String = "x", yVariable:String = "y")
		{
			this.name = name;
			
			if (parentRef)
			{
				setParent(parentRef, xVariable, yVariable);
			}
			
			bounds = new FlxRect(0, 0, FlxG.width, FlxG.height);
			positionOffset = new FlxPoint;
		}
		
		/**
		 * Makes a pixel bullet sprite (rather than an image). You can set the width/height and color of the bullet.
		 * 
		 * @param	quantity	How many bullets do you need to make? This value should be high enough to cover all bullets you need on-screen *at once* plus probably a few extra spare!
		 * @param	width		The width (in pixels) of the bullets
		 * @param	height		The height (in pixels) of the bullets
		 * @param	color		The color of the bullets. Must be given in 0xAARRGGBB format
		 * @param	offsetX		When the bullet is fired if you need to offset it on the x axis, for example to line it up with the "nose" of a space ship, set the amount here (positive or negative)
		 * @param	offsetY		When the bullet is fired if you need to offset it on the y axis, for example to line it up with the "nose" of a space ship, set the amount here (positive or negative)
		 */
		public function makePixelBullet(quantity:uint, width:int = 2, height:int = 2, color:uint = 0xffffffff, offsetX:int = 0, offsetY:int = 0):void
		{
			group = new FlxGroup(quantity);
			
			for (var b:uint = 0; b < quantity; b++)
			{
				var tempBullet:Bullet = new Bullet(this, b, null, width, height, color);
				
				group.add(tempBullet);
			}
			
			positionOffset.x = offsetX;
			positionOffset.y = offsetY;
		}
		
		/**
		 * Makes a bullet sprite from the given image. It will use the width/height of the image.
		 * 
		 * @param	quantity		How many bullets do you need to make? This value should be high enough to cover all bullets you need on-screen *at once* plus probably a few extra spare!
		 * @param	image			The image used to create the bullet from
		 * @param	offsetX			When the bullet is fired if you need to offset it on the x axis, for example to line it up with the "nose" of a space ship, set the amount here (positive or negative)
		 * @param	offsetY			When the bullet is fired if you need to offset it on the y axis, for example to line it up with the "nose" of a space ship, set the amount here (positive or negative)
		 */
		public function makeImageBullet(quantity:uint, image:Class, offsetX:int = 0, offsetY:int = 0):void
		{
			group = new FlxGroup(quantity);
			
			for (var b:uint = 0; b < quantity; b++)
			{
				var tempBullet:Bullet = new Bullet(this, b, image);
				
				group.add(tempBullet);
			}
			
			positionOffset.x = offsetX;
			positionOffset.y = offsetY;
		}
		
		// TODO
		public function makeAnimatedBullet(quantity:uint, imageSequence:Class, frames:Array, animationSpeed:uint, looped:Boolean, offsetX:int = 0, offsetY:int = 0):void
		{
		}
		
		/**
		 * Internal function that handles the actual firing of the bullets
		 * 
		 * @param	method
		 * @param	x
		 * @param	y
		 * @param	target
		 */
		private function runFire(method:uint, x:int = 0, y:int = 0, target:FlxSprite = null):void
		{
			var bullet:Bullet = getFreeBullet();
			
			if (bullet == null)
			{
				return;
			}
			
			var launchX:int = 0;
			var launchY:int = 0;
			
			if (fireFromParent)
			{
				launchX = parent[parentXVariable];
				launchY = parent[parentYVariable];
			}
			else if (fireFromPosition)
			{
				launchX = fireX;
				launchY = fireY;
			}
			
			//	Faster (less CPU) to use this small if-else ladder than a switch statement
			if (method == FIRE)
			{
				bullet.fire(launchX, launchY, 0, -200);
			}
			else if (method == FIRE_AT_MOUSE)
			{
				bullet.fireAtMouse(launchX, launchY);
			}
			else if (method == FIRE_AT_POSITION)
			{
				bullet.fireAtPosition(launchX, launchY, x, y);
			}
			else if (method == FIRE_AT_TARGET)
			{
				bullet.fireAtTarget(launchX, launchY, target);
			}
		}
		
		/**
		 * Fires a bullet (if one is available). The bullet will be given the velocity defined in setBulletDirection.
		 */
		public function fire():void
		{
			runFire(FIRE);
		}
		
		/**
		 * Fires a bullet (if one is available) at the mouse coordinates, using the speed set in setBulletSpeed.
		 */
		public function fireAtMouse():void
		{
			runFire(FIRE_AT_MOUSE);
		}
		
		/**
		 * Fires a bullet (if one is available) at the given x/y coordinates, using the speed set in setBulletSpeed.
		 * 
		 * @param	x	The x coordinate (in game world pixels) to fire at
		 * @param	y	The y coordinate (in game world pixels) to fire at
		 */
		public function fireAtPosition(x:int, y:int):void
		{
			runFire(FIRE_AT_POSITION, x, y);
		}
		
		/**
		 * Fires a bullet (if one is available) at the given targets x/y coordinates, using the speed set in setBulletSpeed.
		 * 
		 * @param	target	The FlxSprite you wish to fire the bullet at
		 */
		public function fireAtTarget(target:FlxSprite):void
		{
			runFire(FIRE_AT_TARGET, 0, 0, target);
		}
		
		/**
		 * Causes the Weapon to fire from the parents x/y value, as seen in Space Invaders and most shoot-em-ups.
		 * 
		 * @param	parentRef	If this weapon belongs to a parent sprite, specify it here (bullets will fire from the sprites x/y vars as defined below).
		 * @param	xVariable	The x axis variable of the parent to use when firing. Typically "x", but could be "screenX" or any public getter that exposes the x coordinate.
		 * @param	yVariable	The y axis variable of the parent to use when firing. Typically "y", but could be "screenY" or any public getter that exposes the y coordinate.
		 * @param	offsetX		When the bullet is fired if you need to offset it on the x axis, for example to line it up with the "nose" of a space ship, set the amount here (positive or negative)
		 * @param	offsetY		When the bullet is fired if you need to offset it on the y axis, for example to line it up with the "nose" of a space ship, set the amount here (positive or negative)
		 */
		public function setParent(parentRef:*, xVariable:String, yVariable:String, offsetX:int = 0, offsetY:int = 0):void
		{
			if (parentRef)
			{
				fireFromParent = true;
				
				parent = parentRef;
				
				parentXVariable = xVariable;
				parentYVariable = yVariable;
			
				positionOffset.x = offsetX;
				positionOffset.y = offsetY;
			}
		}
		
		/**
		 * Causes the Weapon to fire from a fixed x/y position on the screen, like in the game Missile Command.<br>
		 * If set this over-rides a call to setParent (which causes the Weapon to fire from the parents x/y position)
		 * 
		 * @param	x	The x coordinate (in game world pixels) to fire from
		 * @param	y	The y coordinate (in game world pixels) to fire from
		 * @param	offsetX		When the bullet is fired if you need to offset it on the x axis, for example to line it up with the "nose" of a space ship, set the amount here (positive or negative)
		 * @param	offsetY		When the bullet is fired if you need to offset it on the y axis, for example to line it up with the "nose" of a space ship, set the amount here (positive or negative)
		 */
		public function setFiringPosition(x:int, y:int, offsetX:int = 0, offsetY:int = 0):void
		{
			fireFromPosition = true;
			fireX = x;
			fireY = y;
			
			positionOffset.x = offsetX;
			positionOffset.y = offsetY;
		}
		
		/**
		 * The speed in pixels/sec (sq) that the bullet travels at when fired via fireAtMouse, fireAtPosition or fireAtTarget.<br>
		 * You can update this value in real-time, should you need to speed-up or slow-down your bullets (i.e. collecting a power-up)
		 * 
		 * @param	speed		The speed it will move, in pixels per second (sq)
		 */
		public function setBulletSpeed(speed:uint):void
		{
			bulletSpeed = speed;
		}
		
		/**
		 * The speed in pixels/sec (sq) that the bullet travels at when fired via fireAtMouse, fireAtPosition or fireAtTarget.
		 * 
		 * @return	The speed the bullet moves at, in pixels per second (sq)
		 */
		public function getBulletSpeed():uint
		{
			return bulletSpeed;
		}
		
		/**
		 * When a bullet goes outside of this bounds it will be automatically killed, freeing it up for firing again.
		 * 
		 * @param	bounds	An FlxRect area. Inside this area the bullet should be considered alive, once outside it will be killed.
		 */
		public function setBulletBounds(bounds:FlxRect):void
		{
			this.bounds = bounds;
		}
		
		/**
		 * Set the bullet direction it will be shot out at when fired.<br>
		 * You can use one of the consts such as BULLET_UP, BULLET_DOWN or BULLET_NORTH_EAST to set the angle easily.<br>
		 * Speed should be given in pixels/sec (sq) and is the speed at which the bullet travels when fired.
		 * 
		 * @param	angle		Angle of the bullet in degrees working clockwise from 0 where 0 is facing right, 90 = down, 180 = left, 240 = up
		 * @param	speed		The speed it will move, in pixels per second (sq)
		 * @param	autoRotate	When set to true the bullet sprite will automatically rotate to match the angle
		 */
		public function setBulletDirection(angle:int, speed:uint, autoRotate:Boolean = false):void
		{
		}
			
		/**
		 * To make the bullet apply a random factor to either its angle, speed, or both when fired, set these values. Can create a nice "scatter gun" effect.
		 * 
		 * @param	randomAngle		The +- value applied to the angle when fired. For example 20 means the bullet can fire up to 20 degrees under or over its angle when fired.
		 * @param	randomSpeed		The +- value applied to the speed when fired. For example 20 means the bullet can fire up to 20 px/sec slower or faster when fired.
		 */
		public function setBulletRandomFactor(randomAngle:uint, randomSpeed:uint):void
		{
		}
		
		/**
		 * If the bullet should have a fixed life span use this function to set it.<br>
		 * The bullet will be killed once it passes this lifespan, if still alive and in bounds.
		 * 
		 * @param	lifespan	The lifespan of the bullet, given in ms (milliseconds) calculated from the moment the bullet is fired
		 */
		public function setBulletLifeSpan(lifespan:int):void
		{
		}
		
		/**
		 * Internal function that returns the next available bullet from the pool (if any)
		 * 
		 * @return	A bullet
		 */
		private function getFreeBullet():Bullet
		{
			var result:Bullet = null;
			
			if (group == null || group.length == 0)
			{
				throw new Error("Weapon.as cannot fire a bullet until one has been created via a call to makePixelBullet or makeImageBullet");
				return null;
			}
			
			for each (var bullet:Bullet in group.members)
			{
				if (bullet.exists == false)
				{
					result = bullet;
					break;
				}
			}
			
			return result;
		}
		
		
		
		// TODO
		public function createBulletPattern(pattern:Array):void
		{
			//	Launches this many bullets
		}
		
	}

}