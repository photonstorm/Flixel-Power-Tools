/**
 * FlxExtendedSprite
 * -- Part of the Flixel Power Tools set
 * 
 * v1.2 Now works fully with FlxMouseControl to be completely draggable!
 * v1.1 Added "setMouseDrag" and "mouse over" states
 * v1.0 Updated for the Flixel 2.5 Plugin system
 * 
 * @version 1.2 - July 21st 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm 
{
	import flash.display.BitmapData;
	import org.flixel.*;

	/**
	 * 
	 * TODO
	 * 
	 * I need to do a "break limit / breaking point" - a distance which if the mouse pointer moves that far away from the sprite
	 * it'll break the drag, even if the button is still pressed down. That will stop the problem with dragging
	 * sprites through tile maps.
	 * 
	 */
	
	public class FlxExtendedSprite extends FlxSprite
	{
		public var priorityID:uint;
		
		/**
		 * Is this sprite being dragged by the mouse or not?
		 */
		public var isDragged:Boolean = false;
		
		private var draggable:Boolean = false;
		private var dragPixelPerfect:Boolean = false;
		private var dragPixelPerfectAlpha:uint;
		private var dragOffsetX:int;
		private var dragOffsetY:int;
		private var dragFromPoint:Boolean;
		private var allowHorizontalDrag:Boolean = true;
		private var allowVerticalDrag:Boolean = true;
		
		public var boundsRect:FlxRect = null;
		public var boundsSprite:FlxSprite = null;
		
		public function FlxExtendedSprite(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null)
		{
			super(X, Y, SimpleGraphic);
		}
		
		public function get point():FlxPoint
		{
			return _point;
		}
		
		public function set point(p:FlxPoint):void
		{
			_point = p;
		}
		
		/**
		 * Make this Sprite draggable by the mouse
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
		 * Stops this sprite from being able to be dragged. If it is currently the target of an active drag it will be stopped immediately.
		 */
		public function disableMouseDrag():void
		{
			if (isDragged)
			{
				FlxMouseControl.dragTarget = null;
				FlxMouseControl.isDragging = false;
				isDragged = false;
				draggable = false;
			}
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
		
		override public function update():void
		{
			if (draggable && isDragged == false)
			{
				checkForDrag();
			}
			else if (isDragged)
			{
				updateDrag();
			}
			
			super.update();
		}
		
		/**
		 * Return true if the mouse is over this Sprite, otherwise false. Only takes the Sprites bounding box into consideration.
		 */
		public function get mouseOver():Boolean
		{
			return FlxMath.pointInCoordinates(FlxG.mouse.x, FlxG.mouse.y, x, y, width, height);
		}

		private function checkForDrag():void
		{
			if (FlxG.mouse.justPressed() && mouseOver && FlxMouseControl.isDragging == false)
			{
				if ((dragPixelPerfect == true && FlxCollision.pixelPerfectPointCheck(FlxG.mouse.x, FlxG.mouse.y, this, dragPixelPerfectAlpha)) || dragPixelPerfect == false)
				{
					//	The mouse was just pressed, it's over this sprite and it's not dragging something already - so add it to the drag stack
					//	This doesn't mean it WILL be dragged as there might be another sprite on-top of it, just that it's a potential candidate
					FlxMouseControl.addToDragStack(this);
				}
			}
		}
		
		/**
		 * Starts Mouse Drag on this Sprite. Usually you never call this directly, it should be called by FlxMouseControl
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
			
			FlxMouseControl.isDragging = true;
			FlxMouseControl.dragTarget = this;
		}
		
		/**
		 * Updates the Mouse Drag on this Sprite. Usually you never call this directly, it should be called by FlxMouseControl
		 */
		public function updateDrag():void
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
		 * Stops Mouse Drag on this Sprite. Usually you never call this directly, it should be called by FlxMouseControl
		 */
		public function stopDrag():void
		{
			isDragged = false;
		}
		
	}

}