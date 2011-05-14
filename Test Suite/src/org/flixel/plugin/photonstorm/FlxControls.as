/**
 * FlxControls
 * -- Part of the Flixel Power Tools set
 * 
 * v1.3 Major refactoring and enhancements, working really nicely
 * v1.2 First real version deployed to dev
 * v1.1 Updated for the Flixel 2.5 Plugin system
 * 
 * @version 1.3 - May 14th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm 
{
	import org.flixel.*;
	
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
	 * Redefined / Custom Key bindings
	 * Hotkeys (bind a key to a user function - for like weapon select)
	 * More Test Suite tests!
	 */
	public class FlxControls
	{
		private var entity:FlxSprite = null;
		
		private var upMoveSpeed:int;
		private var downMoveSpeed:int;
		private var leftMoveSpeed:int;
		private var rightMoveSpeed:int;
		
		private var up:Boolean;
		private var down:Boolean;
		private var left:Boolean;
		private var right:Boolean;
		private var fire:Boolean;
		private var jump:Boolean;
		private var xFacing:Boolean;
		private var yFacing:Boolean;
		
		private var upKey:String = "UP";
		private var downKey:String = "DOWN";
		private var leftKey:String = "LEFT";
		private var rightKey:String = "RIGHT";
		private var fireKey:String = "CONTROL";	// ctrl
		private var jumpKey:String = "SPACE";	// space
		
		public var fireCallback:Function;
		public var jumpCallback:Function;
		private var capVelocity:Boolean;
		
		private var checkArrows:Boolean = false;			//	Default
		private var checkWASD:Boolean = false;				//	FPS Homeboy
		private var checkESDF:Boolean = false;				//	Homerow (conflicts with WASD)
		private var checkIJKL:Boolean = false;				//	Inverted T / Secondary Player
		private var checkZQSD:Boolean = false;				//	Azerty
		private var checkDvorakSimplified:Boolean = false;	//	,AOE
		
		private var movement:int;
		private var stopping:int;
		
		//	Should these be split left/right/up/down??? So you could instant left and slide right - seems odd, but maybe?
		
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
		
		/**
		 * Sets the FlxSprite to be controlled by this class, and defines the initial movement and stopping types.<br>
		 * After creating an instance of this class you should call setMovementSpeed, and one of the enableXControl functions if you need more than basic cursors.
		 * 
		 * @param	source			The FlxSprite you want this class to control. It can only control one FlxSprite at once.
		 * @param	movementType	Set to either MOVEMENT_INSTANT or MOVEMENT_ACCELERATES
		 * @param	stoppingType	Set to STOPPING_INSTANT, STOPPING_DECELERATES or STOPPING_NEVER
		 * @param	updateFacing	If true it sets the FlxSprite.facing value to the direction pressed (default false)
		 * @param	enableArrowKeys	If true it will enable all arrow keys (default) - see enableCursorControl for more fine-grained control
		 * 
		 * @see		setMovementSpeed
		 */
		public function FlxControls(source:FlxSprite, movementType:int, stoppingType:int, updateFacing:Boolean = false, enableArrowKeys:Boolean = true)
		{
			entity = source;
			
			movement = movementType;
			stopping = stoppingType;
			
			xFacing = updateFacing;
			yFacing = updateFacing;
			
			enableCursorControl();
		}
		
		/**
		 * Set the speed at which the sprite will move when a direction key is pressed.<br>
		 * All values are given in pixels per second. So an xSpeed of 100 would move the sprite 100 pixels in 1 second (1000ms)<br>
		 * Due to the nature of the internal Flash timer this amount is not 100% accurate and will vary above/below the desired distance by a few pixels.<br>
		 * 
		 * If you need to be able to set different values for left/right or up/down then use setAdvancedMovementSpeed
		 * 
		 * @param	xSpeed			The speed in pixels per second in which the sprite will move/accelerate horizontally
		 * @param	ySpeed			The speed in pixels per second in which the sprite will move/accelerate vertically
		 * @param	xSpeedMax		The maximum speed in pixels per second in which the sprite can move horizontally
		 * @param	ySpeedMax		The maximum speed in pixels per second in which the sprite can move vertically
		 * @param	xDeceleration	A deceleration speed in pixels per second to apply to the sprites horizontal movement (default 0)
		 * @param	yDeceleration	A deceleration speed in pixels per second to apply to the sprites vertical movement (default 0)
		 */
		public function setMovementSpeed(xSpeed:int, ySpeed:int, xSpeedMax:int, ySpeedMax:int, xDeceleration:int = 0, yDeceleration:int = 0):void
		{
			leftMoveSpeed = -xSpeed;
			rightMoveSpeed = xSpeed;
			upMoveSpeed = -ySpeed;
			downMoveSpeed = ySpeed;
			
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
		public function setMaximumSpeed(xSpeed:int, ySpeed:int, limitVelocity:Boolean = true):void
		{
			entity.maxVelocity.x = xSpeed;
			entity.maxVelocity.y = ySpeed;
			
			capVelocity = limitVelocity;
		}
		
		public function setDeceleration(xSpeed:int, ySpeed:int):void
		{
			entity.drag.x = xSpeed;
			entity.drag.y = ySpeed;
		}
		
		/**
		 * Gravity can be applied to the sprite, pulling it in any direction.<br>
		 * Gravity is given in pixels per second and is applied as acceleration. The speed the sprite reaches under gravity will never exceed the Maximum Movement Speeds set.
		 * 
		 * @param	xForce	A positive value applies gravity dragging the sprite to the right. A negative value drags the sprite to the left.
		 * @param	yForce	A positive value applies gravity dragging the sprite down. A negative value drags the sprite up.
		 */
		public function setGravity(xForce:int, yForce:int):void
		{
			entity.acceleration.x = xForce;
			entity.acceleration.y = yForce;
		}
		
		public function setAdvancedMovementSpeed(leftSpeed:int, rightSpeed:int, upSpeed:int, downSpeed:int, xSpeedMax:int, ySpeedMax:int, xDeceleration:int = 0, yDeceleration:int = 0):void
		{
			leftMoveSpeed = leftSpeed;
			rightMoveSpeed = rightSpeed;
			upMoveSpeed = upSpeed;
			downMoveSpeed = downSpeed;
			
			setMaximumSpeed(xSpeedMax, ySpeedMax);
			setDeceleration(xDeceleration, yDeceleration);
		}
		
		//	TODO - vvvvvv style demo? :)
		public function flipGravity():void
		{
		}
		
		//	Add functions to update values in real-time (for advanced users!)
		//	Two player support should just be 2 FlxControls running, one per sprite - need to test though
		
		public function enableCursorControl(allowUp:Boolean = true, allowDown:Boolean = true, allowLeft:Boolean = true, allowRight:Boolean = true):void
		{
			up = allowUp;
			down = allowDown;
			left = allowLeft;
			right = allowRight;
			
			checkArrows = true;
		}
		
		public function enableWASDControl(allowUp:Boolean = true, allowDown:Boolean = true, allowLeft:Boolean = true, allowRight:Boolean = true):void
		{
			up = allowUp;
			down = allowDown;
			left = allowLeft;
			right = allowRight;
			
			checkWASD = true;
		}
		
		public function enableESDFControl(allowUp:Boolean = true, allowDown:Boolean = true, allowLeft:Boolean = true, allowRight:Boolean = true):void
		{
			up = allowUp;
			down = allowDown;
			left = allowLeft;
			right = allowRight;
			
			checkESDF = true;
		}
		
		public function enableIJKLControl(allowUp:Boolean = true, allowDown:Boolean = true, allowLeft:Boolean = true, allowRight:Boolean = true):void
		{
			up = allowUp;
			down = allowDown;
			left = allowLeft;
			right = allowRight;
			
			checkIJKL = true;
		}
		
		public function enableZQSDControl(allowUp:Boolean = true, allowDown:Boolean = true, allowLeft:Boolean = true, allowRight:Boolean = true):void
		{
			up = allowUp;
			down = allowDown;
			left = allowLeft;
			right = allowRight;
			
			checkZQSD = true;
		}
		
		public function enableDvorakSimplifiedControl(allowUp:Boolean = true, allowDown:Boolean = true, allowLeft:Boolean = true, allowRight:Boolean = true):void
		{
			up = allowUp;
			down = allowDown;
			left = allowLeft;
			right = allowRight;
			
			checkDvorakSimplified = true;
		}
		
		private function moveUp():Boolean
		{
			var move:Boolean = false;
			
			if (checkArrows && FlxG.keys.UP)
			{
				move = true;
			}
			
			if (checkWASD && FlxG.keys.W)
			{
				move = true;
			}
			
			if (checkESDF && FlxG.keys.E)
			{
				move = true;
			}
			if (checkIJKL && FlxG.keys.I)
			{
				move = true;
			}
			
			if (checkZQSD && FlxG.keys.Z)
			{
				move = true;
			}
			
			if (checkDvorakSimplified && FlxG.keys.COMMA)
			{
				move = true;
			}
			
			if (move)
			{
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
			}
			
			return move;
		}
		
		private function moveDown():Boolean
		{
			var move:Boolean = false;
			
			if (checkArrows && FlxG.keys.DOWN)
			{
				move = true;
			}
			
			if (checkWASD && FlxG.keys.S)
			{
				move = true;
			}
			
			if (checkESDF && FlxG.keys.D)
			{
				move = true;
			}
			if (checkIJKL && FlxG.keys.K)
			{
				move = true;
			}
			
			if (checkZQSD && FlxG.keys.S)
			{
				move = true;
			}
			
			if (checkDvorakSimplified && FlxG.keys.O)
			{
				move = true;
			}
			
			if (move)
			{
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
			}
			
			return move;
		}
		
		private function moveLeft():Boolean
		{
			var move:Boolean = false;
			
			if (checkArrows && FlxG.keys.LEFT)
			{
				move = true;
			}
			
			if (checkWASD && FlxG.keys.A)
			{
				move = true;
			}
			
			if (checkESDF && FlxG.keys.S)
			{
				move = true;
			}
			if (checkIJKL && FlxG.keys.J)
			{
				move = true;
			}
			
			if (checkZQSD && FlxG.keys.Q)
			{
				move = true;
			}
			
			if (checkDvorakSimplified && FlxG.keys.A)
			{
				move = true;
			}
			
			if (move)
			{
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
			}
			
			return move;
		}
		
		private function moveRight():Boolean
		{
			var move:Boolean = false;
			
			if (checkArrows && FlxG.keys.RIGHT)
			{
				move = true;
			}
			
			if (checkWASD && FlxG.keys.D)
			{
				move = true;
			}
			
			if (checkESDF && FlxG.keys.F)
			{
				move = true;
			}
			if (checkIJKL && FlxG.keys.L)
			{
				move = true;
			}
			
			if (checkZQSD && FlxG.keys.D)
			{
				move = true;
			}
			
			if (checkDvorakSimplified && FlxG.keys.E)
			{
				move = true;
			}
			
			if (move)
			{
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
			}
			
			return move;
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
			
		}
		
	}

}