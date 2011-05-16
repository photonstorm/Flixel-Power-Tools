/**
 * FlxControls
 * -- Part of the Flixel Power Tools set
 * 
 * v1.3 Major refactoring and lots of new enhancements
 * v1.2 First real version deployed to dev
 * v1.1 Updated for the Flixel 2.5 Plugin system
 * 
 * @version 1.3 - May 16th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm 
{
	import flash.geom.Rectangle;
	import org.flixel.*;
	import flash.utils.getTimer;
	
	/**
	 * Makes controlling an FlxSprite with the keyboard a LOT easier and quicker to set-up!<br>
	 * Sometimes it's hard to know what values to set, especially if you want gravity, jumping, sliding, etc.<br>
	 * This class helps sort that - and adds some cool extra functionality too :)
	 * 
	 * TODO
	 * ----
	 * 
	 * Gravity + Flipping
	 * Jump Key
	 * Action Key (fire, etc - hook to user function)
	 * Specify animation frames to play per direction (or speed?)
	 * Hotkeys (bind a key to a user function - for like weapon select)
	 * More Test Suite tests!
	 * Variable gravity (based on height)
	 */
	public class FlxControlHandler
	{
		public var enabled:Boolean = false;
		
		private var entity:FlxSprite = null;
		
		private var bounds:Rectangle;
		
		private var up:Boolean;
		private var down:Boolean;
		private var left:Boolean;
		private var right:Boolean;
		private var fire:Boolean;
		private var altFire:Boolean;
		private var jump:Boolean;
		private var xFacing:Boolean;
		private var yFacing:Boolean;
		
		private var upMoveSpeed:int;
		private var downMoveSpeed:int;
		private var leftMoveSpeed:int;
		private var rightMoveSpeed:int;
		
		private var xSpeedAdjust:Number = 0;
		private var ySpeedAdjust:Number = 0;
		
		private var gravityX:int;
		private var gravityY:int;
		
		private var fireRate:int; // ms delay between shots
		private var nextFireTime:int; // when they can next shoot
		private var lastFiredTime:int; // when they last fired
		private var fireContinuous:Boolean; // if fire key held down = stream of bullets
		private var fireOnRelease:Boolean; // if true fires once per key release
		private var fireCallback:Function;
		
		private var jumpRate:int; // ms delay between jumps
		private var lastJumpTime:int; // when they last fired
		private var jumpSurface:uint; // if true they can only jump if sprite is touching given surface (from FlxObject consts, bitwise supported)
		private var jumpOnRelease:Boolean; // if true jumps when key is released, if false jumps when key is pressed down
		private var jumpCallback:Function;
		
		private var movement:int;
		private var stopping:int;
		private var capVelocity:Boolean;
		
		//	Not yet used
		private var hotkeys:Array;
		
		private var upKey:String;
		private var downKey:String;
		private var leftKey:String;
		private var rightKey:String;
		private var fireKey:String;
		private var altFireKey:String;
		private var jumpKey:String;
		
		/**
		 * The "Instant" Movement Type means the sprite will move at maximum speed instantly, and will not "accelerate" (or speed-up) before reaching that speed.
		 */
		public static const MOVEMENT_INSTANT:int = 0;
		/**
		 * The "Accelerates" Movement Type means the sprite will accelerate until it reaches maximum speed.
		 */
		public static const MOVEMENT_ACCELERATES:int = 1;
		/**
		 * The "Instant" Stopping Type means the sprite will stop immediately when no direction keys are being pressed, there will be no deceleration.
		 */
		public static const STOPPING_INSTANT:int = 0;
		/**
		 * The "Decelerates" Stopping Type means the sprite will start decelerating when no direction keys are being pressed. Deceleration continues until the speed reaches zero.
		 */
		public static const STOPPING_DECELERATES:int = 1;
		/**
		 * The "Never" Stopping Type means the sprite will never decelerate, any speed built up will be carried on and never reduce.
		 */
		public static const STOPPING_NEVER:int = 2;
		
		public static const HOTKEY_MODE_FIRST_DOWN:int = 0;
		public static const HOTKEY_MODE_KEY_DOWN:int = 1;
		public static const HOTKEY_MODE_KEY_RELEASE:int = 2;
		
		/**
		 * Sets the FlxSprite to be controlled by this class, and defines the initial movement and stopping types.<br>
		 * After creating an instance of this class you should call setMovementSpeed, and one of the enableXControl functions if you need more than basic cursors.
		 * 
		 * @param	source			The FlxSprite you want this class to control. It can only control one FlxSprite at once.
		 * @param	movementType	Set to either MOVEMENT_INSTANT or MOVEMENT_ACCELERATES
		 * @param	stoppingType	Set to STOPPING_INSTANT, STOPPING_DECELERATES or STOPPING_NEVER
		 * @param	updateFacing	If true it sets the FlxSprite.facing value to the direction pressed (default false)
		 * @param	enableArrowKeys	If true it will enable all arrow keys (default) - see setCursorControl for more fine-grained control
		 * 
		 * @see		setMovementSpeed
		 */
		public function FlxControlHandler(source:FlxSprite, movementType:int, stoppingType:int, updateFacing:Boolean = false, enableArrowKeys:Boolean = true)
		{
			entity = source;
			
			movement = movementType;
			stopping = stoppingType;
			
			xFacing = updateFacing;
			yFacing = updateFacing;
			
			if (enableArrowKeys)
			{
				setCursorControl();
			}
			
			enabled = true;
		}
		
		/**
		 * Set the speed at which the sprite will move when a direction key is pressed.<br>
		 * All values are given in pixels per second. So an xSpeed of 100 would move the sprite 100 pixels in 1 second (1000ms)<br>
		 * Due to the nature of the internal Flash timer this amount is not 100% accurate and will vary above/below the desired distance by a few pixels.<br>
		 * 
		 * If you need different speed values for left/right or up/down then use setAdvancedMovementSpeed
		 * 
		 * @param	xSpeed			The speed in pixels per second in which the sprite will move/accelerate horizontally
		 * @param	ySpeed			The speed in pixels per second in which the sprite will move/accelerate vertically
		 * @param	xSpeedMax		The maximum speed in pixels per second in which the sprite can move horizontally
		 * @param	ySpeedMax		The maximum speed in pixels per second in which the sprite can move vertically
		 * @param	xDeceleration	A deceleration speed in pixels per second to apply to the sprites horizontal movement (default 0)
		 * @param	yDeceleration	A deceleration speed in pixels per second to apply to the sprites vertical movement (default 0)
		 */
		public function setMovementSpeed(xSpeed:uint, ySpeed:uint, xSpeedMax:uint, ySpeedMax:uint, xDeceleration:uint = 0, yDeceleration:uint = 0):void
		{
			leftMoveSpeed = -xSpeed;
			rightMoveSpeed = xSpeed;
			upMoveSpeed = -ySpeed;
			downMoveSpeed = ySpeed;
			
			setMaximumSpeed(xSpeedMax, ySpeedMax);
			setDeceleration(xDeceleration, yDeceleration);
		}
		
		/**
		 * Set the speed at which the sprite will move when a direction key is pressed.<br>
		 * All values are given in pixels per second. So an xSpeed of 100 would move the sprite 100 pixels in 1 second (1000ms)<br>
		 * Due to the nature of the internal Flash timer this amount is not 100% accurate and will vary above/below the desired distance by a few pixels.<br>
		 * 
		 * If you don't need different speed values for every direction on its own then use setMovementSpeed
		 * 
		 * @param	leftSpeed		The speed in pixels per second in which the sprite will move/accelerate to the left
		 * @param	rightSpeed		The speed in pixels per second in which the sprite will move/accelerate to the right
		 * @param	upSpeed			The speed in pixels per second in which the sprite will move/accelerate up
		 * @param	downSpeed		The speed in pixels per second in which the sprite will move/accelerate down
		 * @param	xSpeedMax		The maximum speed in pixels per second in which the sprite can move horizontally
		 * @param	ySpeedMax		The maximum speed in pixels per second in which the sprite can move vertically
		 * @param	xDeceleration	Deceleration speed in pixels per second to apply to the sprites horizontal movement (default 0)
		 * @param	yDeceleration	Deceleration speed in pixels per second to apply to the sprites vertical movement (default 0)
		 */
		public function setAdvancedMovementSpeed(leftSpeed:uint, rightSpeed:uint, upSpeed:uint, downSpeed:uint, xSpeedMax:uint, ySpeedMax:uint, xDeceleration:uint = 0, yDeceleration:uint = 0):void
		{
			leftMoveSpeed = -leftSpeed;
			rightMoveSpeed = rightSpeed;
			upMoveSpeed = -upSpeed;
			downMoveSpeed = downSpeed;
			
			setMaximumSpeed(xSpeedMax, ySpeedMax);
			setDeceleration(xDeceleration, yDeceleration);
		}
		
		/**
		 * Sets the maximum speed (in pixels per second) that the FlxSprite can move. You can set the horizontal and vertical speeds independantly.<br>
		 * When the FlxSprite is accelerating (movement type MOVEMENT_ACCELERATES) its speed won't increase above this value.<br>
		 * However Flixel allows the velocity of an FlxSprite to be set to anything. So if you'd like to check the value and restrain it, then enable "limitVelocity".
		 * 
		 * @param	xSpeed			The maximum speed in pixels per second in which the sprite can move horizontally
		 * @param	ySpeed			The maximum speed in pixels per second in which the sprite can move vertically
		 * @param	limitVelocity	If true the velocity of the FlxSprite will be checked and kept within the limit (true). If false it can be set to anything.
		 */
		public function setMaximumSpeed(xSpeed:uint, ySpeed:uint, limitVelocity:Boolean = true):void
		{
			entity.maxVelocity.x = xSpeed;
			entity.maxVelocity.y = ySpeed;
			
			capVelocity = limitVelocity;
		}
		
		/**
		 * Deceleration is a speed (in pixels per second) that is applied to the sprite if stopping type is "DECELERATES" and if no acceleration is taking place.<br>
		 * The velocity of the sprite will be reduced until it reaches zero, and can be configured separately per axis.
		 * 
		 * @param	xSpeed		The speed in pixels per second at which the sprite will have its horizontal speed decreased
		 * @param	ySpeed		The speed in pixels per second at which the sprite will have its vertical speed decreased
		 */
		public function setDeceleration(xSpeed:uint, ySpeed:uint):void
		{
			entity.drag.x = xSpeed;
			entity.drag.y = ySpeed;
		}
		
		/**
		 * Gravity can be applied to the sprite, pulling it in any direction.<br>
		 * Gravity is given in pixels per second and is applied as acceleration. The speed the sprite reaches under gravity will never exceed the Maximum Movement Speeds set.<br>
		 * If you don't want gravity for a specific direction pass a value of zero.
		 * 
		 * @param	xForce	A positive value applies gravity dragging the sprite to the right. A negative value drags the sprite to the left. Zero disables horizontal gravity.
		 * @param	yForce	A positive value applies gravity dragging the sprite down. A negative value drags the sprite up. Zero disables vertical gravity.
		 */
		public function setGravity(xForce:int, yForce:int):void
		{
			gravityX = xForce;
			gravityY = yForce;
			
			entity.acceleration.x = gravityX;
			entity.acceleration.y = gravityY;
		}
		
		/**
		 * Switches the gravity applied to the sprite. If gravity was +400 Y (pulling them down) this will swap it to -400 Y (pulling them up)<br>
		 * To reset call flipGravity again
		 */
		public function flipGravity():void
		{
			if (gravityX && gravityX != 0)
			{
				gravityX = -gravityX;
				entity.acceleration.x = gravityX;
			}
			
			if (gravityY && gravityY != 0)
			{
				gravityY = -gravityY;
				entity.acceleration.y = gravityY;
			}
		}
		
		// TODO
		public function speedUp(xFactor:Number, yFactor:Number):void
		{
		}
		
		// TODO
		public function slowDown(xFactor:Number, yFactor:Number):void
		{
		}
		
		// TODO
		public function resetSpeeds(resetX:Boolean = true, resetY:Boolean = true):void
		{
			if (resetX)
			{
				xSpeedAdjust = 0;
			}
			
			if (resetY)
			{
				ySpeedAdjust = 0;
			}
		}
		
		// TODO
		public function addHotKey(key:String, callback:Function, mode:int):void
		{
			
		}
		
		//	FIRE
		
		public function setFireButton(key:String, delay:uint, callback:Function, onRelease:Boolean = false, altKey:String = ""):void
		{
			fireKey = key;
			
			if (altKey != "")
			{
				altFireKey = altKey;
			}
			
			fireRate = delay;
			fireCallback = callback;
			fireOnRelease = onRelease;
			
			fire = true;
		}
		
		/**
		 * Sets Custom Key controls. Useful if none of the pre-defined sets work. All String values should be taken from org.flixel.system.input.Keyboard
		 * Pass a blank (empty) String to disable that key from being checked.
		 * 
		 * @param	customUpKey		The String to use for the Up key.
		 * @param	customDownKey	The String to use for the Down key.
		 * @param	customLeftKey	The String to use for the Left key.
		 * @param	customRightKey	The String to use for the Right key.
		 */
		public function setCustomKeys(customUpKey:String, customDownKey:String, customLeftKey:String, customRightKey:String):void
		{
			if (customUpKey != "")
			{
				up = true;
				upKey = customUpKey;
			}
			
			if (customDownKey != "")
			{
				down = true;
				downKey = customDownKey;
			}
			
			if (customLeftKey != "")
			{
				left = true;
				leftKey = customLeftKey;
			}
			
			if (customRightKey != "")
			{
				right = true;
				rightKey = customRightKey;
			}
		}
		
		/**
		 * Enables Cursor/Arrow Key controls. Can be set on a per-key basis. Useful if you only want to allow a few keys.<br>
		 * For example in a Space Invaders game you'd only enable LEFT and RIGHT.
		 * 
		 * @param	allowUp		Enable the UP key
		 * @param	allowDown	Enable the DOWN key
		 * @param	allowLeft	Enable the LEFT key
		 * @param	allowRight	Enable the RIGHT key
		 */
		public function setCursorControl(allowUp:Boolean = true, allowDown:Boolean = true, allowLeft:Boolean = true, allowRight:Boolean = true):void
		{
			up = allowUp;
			down = allowDown;
			left = allowLeft;
			right = allowRight;
			
			upKey = "UP";
			downKey = "DOWN";
			leftKey = "LEFT";
			rightKey = "RIGHT";
		}
		
		/**
		 * Enables WASD controls. Can be set on a per-key basis. Useful if you only want to allow a few keys.<br>
		 * For example in a Space Invaders game you'd only enable LEFT and RIGHT.
		 * 
		 * @param	allowUp		Enable the up (W) key
		 * @param	allowDown	Enable the down (S) key
		 * @param	allowLeft	Enable the left (A) key
		 * @param	allowRight	Enable the right (D) key
		 */
		public function setWASDControl(allowUp:Boolean = true, allowDown:Boolean = true, allowLeft:Boolean = true, allowRight:Boolean = true):void
		{
			up = allowUp;
			down = allowDown;
			left = allowLeft;
			right = allowRight;
			
			upKey = "W";
			downKey = "S";
			leftKey = "A";
			rightKey = "D";
		}
		
		/**
		 * Enables ESDF (home row) controls. Can be set on a per-key basis. Useful if you only want to allow a few keys.<br>
		 * For example in a Space Invaders game you'd only enable LEFT and RIGHT.
		 * 
		 * @param	allowUp		Enable the up (E) key
		 * @param	allowDown	Enable the down (D) key
		 * @param	allowLeft	Enable the left (S) key
		 * @param	allowRight	Enable the right (F) key
		 */
		public function setESDFControl(allowUp:Boolean = true, allowDown:Boolean = true, allowLeft:Boolean = true, allowRight:Boolean = true):void
		{
			up = allowUp;
			down = allowDown;
			left = allowLeft;
			right = allowRight;
			
			upKey = "E";
			downKey = "D";
			leftKey = "S";
			rightKey = "F";
		}
		
		/**
		 * Enables IJKL (right-sided or secondary player) controls. Can be set on a per-key basis. Useful if you only want to allow a few keys.<br>
		 * For example in a Space Invaders game you'd only enable LEFT and RIGHT.
		 * 
		 * @param	allowUp		Enable the up (I) key
		 * @param	allowDown	Enable the down (K) key
		 * @param	allowLeft	Enable the left (J) key
		 * @param	allowRight	Enable the right (L) key
		 */
		public function setIJKLControl(allowUp:Boolean = true, allowDown:Boolean = true, allowLeft:Boolean = true, allowRight:Boolean = true):void
		{
			up = allowUp;
			down = allowDown;
			left = allowLeft;
			right = allowRight;
			
			upKey = "I";
			downKey = "K";
			leftKey = "J";
			rightKey = "L";
		}
		
		/**
		 * Enables HJKL (Rogue / Net-Hack) controls. Can be set on a per-key basis. Useful if you only want to allow a few keys.<br>
		 * For example in a Space Invaders game you'd only enable LEFT and RIGHT.
		 * 
		 * @param	allowUp		Enable the up (K) key
		 * @param	allowDown	Enable the down (J) key
		 * @param	allowLeft	Enable the left (H) key
		 * @param	allowRight	Enable the right (L) key
		 */
		public function setHJKLControl(allowUp:Boolean = true, allowDown:Boolean = true, allowLeft:Boolean = true, allowRight:Boolean = true):void
		{
			up = allowUp;
			down = allowDown;
			left = allowLeft;
			right = allowRight;
			
			upKey = "K";
			downKey = "J";
			leftKey = "H";
			rightKey = "L";
		}
		
		/**
		 * Enables ZQSD (Azerty keyboard) controls. Can be set on a per-key basis. Useful if you only want to allow a few keys.<br>
		 * For example in a Space Invaders game you'd only enable LEFT and RIGHT.
		 * 
		 * @param	allowUp		Enable the up (Z) key
		 * @param	allowDown	Enable the down (Q) key
		 * @param	allowLeft	Enable the left (S) key
		 * @param	allowRight	Enable the right (D) key
		 */
		public function setZQSDControl(allowUp:Boolean = true, allowDown:Boolean = true, allowLeft:Boolean = true, allowRight:Boolean = true):void
		{
			up = allowUp;
			down = allowDown;
			left = allowLeft;
			right = allowRight;
			
			upKey = "Z";
			downKey = "S";
			leftKey = "Q";
			rightKey = "D";
		}
		
		/**
		 * Enables Dvoark Simplified Controls. Can be set on a per-key basis. Useful if you only want to allow a few keys.<br>
		 * For example in a Space Invaders game you'd only enable LEFT and RIGHT.
		 * 
		 * @param	allowUp		Enable the up (COMMA) key
		 * @param	allowDown	Enable the down (A) key
		 * @param	allowLeft	Enable the left (O) key
		 * @param	allowRight	Enable the right (E) key
		 */
		public function setDvorakSimplifiedControl(allowUp:Boolean = true, allowDown:Boolean = true, allowLeft:Boolean = true, allowRight:Boolean = true):void
		{
			up = allowUp;
			down = allowDown;
			left = allowLeft;
			right = allowRight;
			
			upKey = "COMMA";
			downKey = "O";
			leftKey = "A";
			rightKey = "E";
		}
		
		/**
		 * Enables Numpad (left-handed) Controls. Can be set on a per-key basis. Useful if you only want to allow a few keys.<br>
		 * For example in a Space Invaders game you'd only enable LEFT and RIGHT.
		 * 
		 * @param	allowUp		Enable the up (NUMPADEIGHT) key
		 * @param	allowDown	Enable the down (NUMPADTWO) key
		 * @param	allowLeft	Enable the left (NUMPADFOUR) key
		 * @param	allowRight	Enable the right (NUMPADSIX) key
		 */
		public function setNumpadControl(allowUp:Boolean = true, allowDown:Boolean = true, allowLeft:Boolean = true, allowRight:Boolean = true):void
		{
			up = allowUp;
			down = allowDown;
			left = allowLeft;
			right = allowRight;
			
			upKey = "NUMPADEIGHT";
			downKey = "NUMPADTWO";
			leftKey = "NUMPADFOUR";
			rightKey = "NUMPADSIX";
		}
		
		/**
		 * Limits the sprite to only be allowed within this rectangle. If its x/y coordinates go outside it will be repositioned back inside.<br>
		 * Coordinates should be given in GAME WORLD pixel values (not screen value, although often they are the two same things)
		 * 
		 * @param	x		The x coordinate of the top left corner of the area (in game world pixels)
		 * @param	y		The y coordinate of the top left corner of the area (in game world pixels)
		 * @param	width	The width of the area (in pixels)
		 * @param	height	The height of the area (in pixels)
		 */
		public function setBounds(x:int, y:int, width:uint, height:uint):void
		{
			bounds = new Rectangle(x, y, width, height);
		}
		
		/**
		 * Clears any previously set sprite bounds
		 */
		public function removeBounds():void
		{
			bounds = null;
		}
		
		private function moveUp():Boolean
		{
			var move:Boolean = false;
			
			if (FlxG.keys.pressed(upKey))
			{
				move = true;
				
				if (yFacing)
				{
					entity.facing = FlxObject.UP;
				}
				
				if (movement == MOVEMENT_INSTANT)
				{
					entity.velocity.y = upMoveSpeed;
				}
				else if (movement == MOVEMENT_ACCELERATES)
				{
					entity.acceleration.y = upMoveSpeed;
				}
				
				if (bounds && entity.y < bounds.top)
				{
					entity.y = bounds.top;
				}
			}
			
			return move;
		}
		
		private function moveDown():Boolean
		{
			var move:Boolean = false;
			
			if (FlxG.keys.pressed(downKey))
			{
				move = true;
				
				if (yFacing)
				{
					entity.facing = FlxObject.DOWN;
				}
				
				if (movement == MOVEMENT_INSTANT)
				{
					entity.velocity.y = downMoveSpeed;
				}
				else if (movement == MOVEMENT_ACCELERATES)
				{
					entity.acceleration.y = downMoveSpeed;
				}
				
				if (bounds && entity.y > bounds.bottom)
				{
					entity.y = bounds.bottom;
				}
				
			}
			
			return move;
		}
		
		private function moveLeft():Boolean
		{
			var move:Boolean = false;
			
			if (FlxG.keys.pressed(leftKey))
			{
				move = true;
				
				if (xFacing)
				{
					entity.facing = FlxObject.LEFT;
				}
				
				if (movement == MOVEMENT_INSTANT)
				{
					entity.velocity.x = leftMoveSpeed;
				}
				else if (movement == MOVEMENT_ACCELERATES)
				{
					entity.acceleration.x = leftMoveSpeed;
				}
				
				if (bounds && entity.x < bounds.x)
				{
					entity.x = bounds.x;
				}
			}
			
			return move;
		}
		
		private function moveRight():Boolean
		{
			var move:Boolean = false;
			
			if (FlxG.keys.pressed(rightKey))
			{
				move = true;
				
				if (xFacing)
				{
					entity.facing = FlxObject.RIGHT;
				}
				
				if (movement == MOVEMENT_INSTANT)
				{
					entity.velocity.x = rightMoveSpeed;
				}
				else if (movement == MOVEMENT_ACCELERATES)
				{
					entity.acceleration.x = rightMoveSpeed;
				}
				
				if (bounds && entity.x > bounds.right)
				{
					entity.x = bounds.right;
				}
			}
			
			return move;
		}
		
		private function runFire():Boolean
		{
			var fired:Boolean = false;
			
			if ((fireOnRelease == true && FlxG.keys.justReleased(fireKey)) || (fireOnRelease == false && FlxG.keys.pressed(fireKey)))
			{
				if (getTimer() > nextFireTime)
				{
					lastFiredTime = getTimer();
					nextFireTime = lastFiredTime + fireRate;
					
					fireCallback.call();
					
					fired = true;
				}
			}
			
			return fired;
		}
		
		public function update():void
		{
			if (entity == null)
			{
				return;
			}
			
			if (stopping == STOPPING_INSTANT)
			{
				if (movement == MOVEMENT_INSTANT)
				{
					entity.velocity.x = 0;
					entity.velocity.y = 0;
				}
				else if (movement == MOVEMENT_ACCELERATES)
				{
					entity.acceleration.x = 0;
					entity.acceleration.y = 0;
				}
			}
			else
			{
				if (capVelocity)
				{
					if (entity.velocity.x > entity.maxVelocity.x)
					{
						entity.velocity.x = entity.maxVelocity.x;
					}
					
					if (entity.velocity.y > entity.maxVelocity.y)
					{
						entity.velocity.y = entity.maxVelocity.y;
					}
				}
			}
			
			var movedX:Boolean = false;
			var movedY:Boolean = false;
			
			if (up)
			{
				movedY = moveUp();
			}
			
			if (down && movedY == false)
			{
				moveDown();
			}
			
			if (left)
			{
				movedX = moveLeft();
			}
			
			if (right && movedX == false)
			{
				moveRight();
			}
			
			if (fire)
			{
				runFire();
			}
			
			
		}
		
	}

}