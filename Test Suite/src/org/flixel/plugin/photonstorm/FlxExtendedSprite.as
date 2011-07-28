/**
 * FlxExtendedSprite
 * -- Part of the Flixel Power Tools set
 * 
 * v1.2 Now works fully with FlxMouseControl to be completely clickable and draggable!
 * v1.1 Added "setMouseDrag" and "mouse over" states
 * v1.0 Updated for the Flixel 2.5 Plugin system
 * 
 * @version 1.2 - July 26th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm 
{
	import org.flixel.*;

	/**
	 * 
	 * TODO
	 * 
	 * I need to do a "break limit / breaking point" - a distance which if the mouse pointer moves that far away from the sprite
	 * it'll break the drag, even if the button is still pressed down. That will stop the problem with dragging sprites through tile maps.
	 * 
	 */
	
	public class FlxExtendedSprite extends FlxSprite
	{
		/**
		 * Used by FlxMouseControl when multiple sprites overlap and register clicks, and you need to determine which sprite has priority
		 */
		public var priorityID:uint;
		
		/**
		 * If the mouse currently pressed down on this sprite?
		 */
		public var isPressed:Boolean = false;
		
		/**
		 * Is this sprite allowed to be clicked?
		 */
		public var clickable:Boolean = false;
		private var clickOnRelease:Boolean = false;
		private var clickPixelPerfect:Boolean = false;
		private var clickPixelPerfectAlpha:uint;
		private var clickCounter:uint;
		
		/**
		 * Function called when the mouse is pressed down on this sprite. Function is passed these parameters: obj:FlxExtendedSprite, x:int, y:int
		 */
		public var mousePressedCallback:Function;
		
		/**
		 * Function called when the mouse is released from this sprite. Function is passed these parameters: obj:FlxExtendedSprite, x:int, y:int
		 */
		public var mouseReleasedCallback:Function;
		
		public var throwable:Boolean = false;
		public var throwXFactor:int;
		public var throwYFactor:int;
		
		private var gravityX:int;
		private var gravityY:int;
		
		/**
		 * Is this sprite being dragged by the mouse or not?
		 */
		public var isDragged:Boolean = false;
		
		/**
		 * Is this sprite allowed to be dragged by the mouse? true = yes, false = no
		 */
		public var draggable:Boolean = false;
		private var dragPixelPerfect:Boolean = false;
		private var dragPixelPerfectAlpha:uint;
		private var dragOffsetX:int;
		private var dragOffsetY:int;
		private var dragFromPoint:Boolean;
		private var allowHorizontalDrag:Boolean = true;
		private var allowVerticalDrag:Boolean = true;
		
		/**
		 * Function called when the mouse starts to drag this sprite. Function is passed these parameters: obj:FlxExtendedSprite, x:int, y:int
		 */
		public var mouseStartDragCallback:Function;
		
		/**
		 * Function called when the mouse stops dragging this sprite. Function is passed these parameters: obj:FlxExtendedSprite, x:int, y:int
		 */
		public var mouseStopDragCallback:Function;
		
		/**
		 * An FlxRect region of the game world within which the sprite is restricted during mouse drag
		 */
		public var boundsRect:FlxRect = null;
		
		/**
		 * An FlxSprite the bounds of which this sprite is restricted during mouse drag
		 */
		public var boundsSprite:FlxSprite = null;
		
		public function FlxExtendedSprite(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null)
		{
			super(X, Y, SimpleGraphic);
		}
		
		/**
		 * Allow this Sprite to receive mouse clicks, the total number of times this sprite is clicked is stored in this.clicks<br>
		 * You can add callbacks via mousePressedCallback and mouseReleasedCallback
		 * 
		 * @param	onRelease			Set if you want to register a click as being when the mouse is pressed down (false) or when it's released from a press (true)
		 * @param	pixelPerfect		If true it will use a pixel perfect test to see if you clicked the Sprite. False uses the bounding box.
		 * @param	alphaThreshold		If using pixel perfect collision this specifies the alpha level from 0 to 255 above which a collision is processed (default 255)
		 */
		public function enableMouseClicks(onRelease:Boolean, pixelPerfect:Boolean = false, alphaThreshold:uint = 255):void
		{
			clickable = true;
			
			clickOnRelease = onRelease;
			clickPixelPerfect = pixelPerfect;
			clickPixelPerfectAlpha = alphaThreshold;
			clickCounter = 0;
		}
		
		/**
		 * Stops this sprite from checking for mouse clicks and clears any set callbacks
		 */
		public function disableMouseClicks():void
		{
			clickable = false;
			mousePressedCallback = null;
			mouseReleasedCallback = null;
		}
		
		/**
		 * Returns the number of times this sprite has been clicked (can be reset by setting clicks to zero)
		 */
		public function get clicks():uint
		{
			return clickCounter;
		}
		
		/**
		 * Sets the number of clicks this item has received. Usually you'd only set it to zero.
		 */
		public function set clicks(i:uint):void
		{
			clickCounter = i;
		}
		
		/**
		 * Make this Sprite draggable by the mouse. You can also optionally set mouseStartDragCallback and mouseStopDragCallback
		 * 
		 * @param	lockCenter			If false the Sprite will drag from where you click it. If true it will center itself to the tip of the mouse pointer.
		 * @param	pixelPerfect		If true it will use a pixel perfect test to see if you clicked the Sprite. False uses the bounding box.
		 * @param	alphaThreshold		If using pixel perfect collision this specifies the alpha level from 0 to 255 above which a collision is processed (default 255)
		 * @param	boundsRect			If you want to restrict the drag of this sprite to a specific FlxRect, pass the FlxRect here, otherwise it's free to drag anywhere
		 * @param	boundsSprite		If you want to restrict the drag of this sprite to within the bounding box of another sprite, pass it here
		 */
		public function enableMouseDrag(lockCenter:Boolean = false, pixelPerfect:Boolean = false, alphaThreshold:uint = 255, boundsRect:FlxRect = null, boundsSprite:FlxSprite = null):void
		{
			draggable = true;
			
			dragFromPoint = lockCenter;
			dragPixelPerfect = pixelPerfect;
			dragPixelPerfectAlpha = alphaThreshold;
			
			if (boundsRect)
			{
				this.boundsRect = boundsRect;
			}
			
			if (boundsSprite)
			{
				this.boundsSprite = boundsSprite;
			}
		}
		
		/**
		 * Stops this sprite from being able to be dragged. If it is currently the target of an active drag it will be stopped immediately. Also disables any set callbacks.
		 */
		public function disableMouseDrag():void
		{
			if (isDragged)
			{
				FlxMouseControl.dragTarget = null;
				FlxMouseControl.isDragging = false;
			}
			
			isDragged = false;
			draggable = false;
			
			mouseStartDragCallback = null;
			mouseStopDragCallback = null;
		}
		 
		/**
		* Restricts this sprite to drag movement only on the given axis. Note: If both are set to false the sprite will never move!
		 * 
		 * @param	allowHorizontal		To enable the sprite to be dragged horizontally set to true, otherwise false
		 * @param	allowVertical		To enable the sprite to be dragged vertically set to true, otherwise false
		 */
		public function setDragLock(allowHorizontal:Boolean = true, allowVertical:Boolean = true):void
		{
			allowHorizontalDrag = allowHorizontal;
			allowVerticalDrag = allowVertical;
		}
		
		/**
		 * Make this Sprite throwable by the mouse. The sprite is thrown only when the mouse button is released.
		 * 
		 * @param	xFactor		The sprites velocity is set to FlxMouseControl.speedX * xFactor. Try a value around 50+
		 * @param	yFactor		The sprites velocity is set to FlxMouseControl.speedY * yFactor. Try a value around 50+
		 */
		public function enableMouseThrow(xFactor:int, yFactor:int):void
		{
			throwable = true;
			throwXFactor = xFactor;
			throwYFactor = yFactor;
			
			if (clickable == false && draggable == false)
			{
				clickable = true;
			}
		}
		
		/**
		 * Stops this sprite from being able to be thrown. If it currently has velocity this is NOT removed from it.
		 */
		public function disableMouseThrow():void
		{
			throwable = false;
		}
		
		/**
		 * Core update loop
		 */
		override public function update():void
		{
			if (draggable && isDragged)
			{
				updateDrag();
			}
			
			if (isPressed == false && FlxG.mouse.justPressed())
			{
				checkForClick();
			}
			
			super.update();
		}
		
		/**
		 * Checks if the mouse is over this sprite and pressed, then does a pixel perfect check if needed and adds it to the FlxMouseControl check stack
		 */
		private function checkForClick():void
		{
			if (mouseOver && FlxG.mouse.justPressed())
			{
				if (dragPixelPerfect == false && clickPixelPerfect == false)
				{
					FlxMouseControl.addToStack(this);
				}
				else if ((clickPixelPerfect && FlxCollision.pixelPerfectPointCheck(FlxG.mouse.x, FlxG.mouse.y, this, clickPixelPerfectAlpha)) || (dragPixelPerfect && FlxCollision.pixelPerfectPointCheck(FlxG.mouse.x, FlxG.mouse.y, this, dragPixelPerfectAlpha)))
				{
					FlxMouseControl.addToStack(this);
				}
			}
		}
		
		/**
		 * Called by FlxMouseControl when this sprite is clicked. Should not usually be called directly.
		 */
		public function mousePressedHandler():void
		{
			isPressed = true;
			
			if (clickable && clickOnRelease == false)
			{
				clickCounter++;
			}
			
			if (mousePressedCallback is Function)
			{
				mousePressedCallback.apply(null, [ this, mouseX, mouseY ] );
			}
		}
		
		/**
		 * Called by FlxMouseControl when this sprite is released from a click. Should not usually be called directly.
		 */
		public function mouseReleasedHandler():void
		{
			isPressed = false;
			
			if (isDragged)
			{
				stopDrag();
			}
			
			if (clickable && clickOnRelease == true)
			{
				clickCounter++;
			}
			
			if (throwable)
			{
				velocity.x = FlxMouseControl.speedX * throwXFactor;
				velocity.y = FlxMouseControl.speedY * throwYFactor;
			}
			
			if (mouseReleasedCallback is Function)
			{
				mouseReleasedCallback.apply(null, [ this, mouseX, mouseY ] );
			}
		}
		
		/**
		 * Called by FlxMouseControl when Mouse Drag starts on this Sprite. Should not usually be called directly.
		 */
		public function startDrag():void
		{
			isDragged = true;
			
			if (dragFromPoint == false)
			{
				dragOffsetX = int(FlxG.mouse.x) - x;
				dragOffsetY = int(FlxG.mouse.y) - y;
			}
			else
			{
				//	Move the sprite to the middle of the mouse
				dragOffsetX = (frameWidth / 2);
				dragOffsetY = (frameHeight / 2);
			}
		}
		
		/**
		 * Updates the Mouse Drag on this Sprite.
		 */
		private function updateDrag():void
		{
			if (allowHorizontalDrag)
			{
				x = int(FlxG.mouse.x) - dragOffsetX;
			}
			
			if (allowVerticalDrag)
			{
				y = int(FlxG.mouse.y) - dragOffsetY;
			}
			
			if (boundsRect)
			{
				checkBoundsRect();
			}

			if (boundsSprite)
			{
				checkBoundsSprite();
			}
		}
		
		/**
		 * Bounds Rect check for the sprite drag
		 */
		private function checkBoundsRect():void
		{
			if (x < boundsRect.left)
			{
				x = boundsRect.x;
			}
			else if ((x + width) > boundsRect.right)
			{
				x = boundsRect.right - width;
			}
			
			if (y < boundsRect.top)
			{
				y = boundsRect.top;
			}
			else if ((y + height) > boundsRect.bottom)
			{
				y = boundsRect.bottom - height;
			}
		}
		
		/**
		 * Parent Sprite Bounds check for the sprite drag
		 */
		private function checkBoundsSprite():void
		{
			if (x < boundsSprite.x)
			{
				x = boundsSprite.x;
			}
			else if ((x + width) > (boundsSprite.x + boundsSprite.width))
			{
				x = (boundsSprite.x + boundsSprite.width) - width;
			}
			
			if (y < boundsSprite.y)
			{
				y = boundsSprite.y;
			}
			else if ((y + height) > (boundsSprite.y + boundsSprite.height))
			{
				y = (boundsSprite.y + boundsSprite.height) - height;
			}
		}
		
		/**
		 * Called by FlxMouseControl when Mouse Drag is stopped on this Sprite. Should not usually be called directly.
		 */
		public function stopDrag():void
		{
			isDragged = false;
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
			
			acceleration.x = gravityX;
			acceleration.y = gravityY;
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
				acceleration.x = gravityX;
			}
			
			if (gravityY && gravityY != 0)
			{
				gravityY = -gravityY;
				acceleration.y = gravityY;
			}
		}
		
		/**
		 * Returns an FlxPoint consisting of this sprites world x/y coordinates
		 */
		public function get point():FlxPoint
		{
			return _point;
		}
		
		/**
		 * Return true if the mouse is over this Sprite, otherwise false. Only takes the Sprites bounding box into consideration and does not check if there 
		 * are other sprites potentially on-top of this one. Check the value of this.isPressed if you need to know if the mouse is currently clicked on this sprite.
		 */
		public function get mouseOver():Boolean
		{
			return FlxMath.pointInCoordinates(FlxG.mouse.x, FlxG.mouse.y, x, y, width, height);
		}
		
		/**
		 * Returns how many horizontal pixels the mouse pointer is inside this sprite from the top left corner. Returns -1 if outside.
		 */
		public function get mouseX():int
		{
			if (mouseOver)
			{
				return FlxG.mouse.x - x;
			}
			
			return -1;
		}
		
		/**
		 * Returns how many vertical pixels the mouse pointer is inside this sprite from the top left corner. Returns -1 if outside.
		 */
		public function get mouseY():int
		{
			if (mouseOver)
			{
				return FlxG.mouse.y - y;
			}
			
			return -1;
		}
		
	}

}