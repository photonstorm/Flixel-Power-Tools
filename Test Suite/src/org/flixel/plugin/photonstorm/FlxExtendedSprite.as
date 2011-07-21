/**
 * FlxExtendedSprite
 * -- Part of the Flixel Power Tools set
 * 
 * v1.1 Added "setMouseDrag" and "mouse over" states
 * v1.0 Updated for the Flixel 2.5 Plugin system
 * 
 * @version 1.1 - May 18th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm 
{
	import flash.display.BitmapData;
	import org.flixel.*;

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
		public var boundsRect:FlxRect = null;
		
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
		 * @param	lockCenter			If true the Sprite will drag from where you click it. If false it will center itself to the tip of the mouse pointer.
		 * @param	boundsRect			If you want to restrict the drag of this sprite to a specific FlxRect, pass the FlxRect here, otherwise it's free to drag anywhere
		 * @param	pixelPerfect		If true it will use a pixel perfect test to see if you clicked the Sprite. False uses the bounding box.
		 * @param	alphaThreshold		If using pixel perfect collision this specifies the alpha level from 0 to 255 above which a collision is processed (default 255)
		 */
		public function enableMouseDrag(lockCenter:Boolean = true, boundsRect:FlxRect = null, pixelPerfect:Boolean = false, alphaThreshold:uint = 255):void
		{
			draggable = true;
			
			if (boundsRect)
			{
				this.boundsRect = boundsRect;
			}
			
			dragPixelPerfect = pixelPerfect;
			dragPixelPerfectAlpha = alphaThreshold;
			dragFromPoint = lockCenter;
		}
		
		private function checkBoundsRect():void
		{
			if (boundsRect == null)
			{
				return;
			}
			
			if (x < boundsRect.left)
			{
				x = boundsRect.x;
			}
			else if (x > boundsRect.right)
			{
				x = boundsRect.right;
			}
			
			if (y < boundsRect.top)
			{
				y = boundsRect.top;
			}
			else if (y > boundsRect.bottom)
			{
				y = boundsRect.bottom;
			}
		}
		
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
		
		override public function update():void
		{
			if (draggable && isDragged == false)
			{
				checkForDrag();
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
		
		public function startDrag():void
		{
			isDragged = true;
			
			if (dragFromPoint)
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
		
		public function updateDrag():void
		{
			x = int(FlxG.mouse.x) - dragOffsetX;
			y = int(FlxG.mouse.y) - dragOffsetY;
			
			checkBoundsRect();
		}
		
		public function stopDrag():void
		{
			isDragged = false;
		}
		
	}

}