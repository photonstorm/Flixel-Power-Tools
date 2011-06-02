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
		private var isDragged:Boolean = false;
		private var draggable:Boolean = false;
		private var dragPixelPerfect:Boolean = false;
		private var dragPixelPerfectAlpha:uint;
		private var dragOffsetX:int;
		private var dragOffsetY:int;
		private var dragFromPoint:Boolean;
		
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
		 * @param	dragFromClickPoint	If true the Sprite will drag from where you click it. If false it will center itself to the tip of the mouse pointer.
		 * @param	pixelPerfect		If true it will use a pixel perfect test to see if you clicked the Sprite. False uses the bounding box.
		 * @param	alphaThreshold		If using pixel perfect collision this specifies the alpha level from 0 to 255 above which a collision is processed (default 255)
		 */
		public function setMouseDrag(dragFromClickPoint:Boolean = true, pixelPerfect:Boolean = false, alphaThreshold:uint = 255):void
		{
			draggable = true;
			dragPixelPerfect = pixelPerfect;
			dragPixelPerfectAlpha = alphaThreshold;
			dragFromPoint = dragFromClickPoint;
		}
		
		override public function update():void
		{
			if (draggable)
			{
				checkDragState();
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
		
		private function checkDragState():void
		{
			if (isDragged)
			{
				if (FlxG.mouse.pressed())
				{
					x = int(FlxG.mouse.x) - dragOffsetX;
					y = int(FlxG.mouse.y) - dragOffsetY;
				}
				else
				{
					isDragged = false;
					
					FlxMouseControl.isDragging = false;
					FlxMouseControl.dragTarget = null;
				}
			}
			else
			{
				if (FlxG.mouse.justPressed() && mouseOver && FlxMouseControl.isDragging == false)
				{
					if ((dragPixelPerfect == true && FlxCollision.pixelPerfectPointCheck(FlxG.mouse.x, FlxG.mouse.y, this, dragPixelPerfectAlpha)) || dragPixelPerfect == false)
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
				}
			}
		}
		
	}

}