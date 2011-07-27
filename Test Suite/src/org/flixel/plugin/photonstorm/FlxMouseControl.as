/**
 * FlxMouseControl
 * -- Part of the Flixel Power Tools set
 * 
 * v1.1 Moved to a native plugin
 * v1.0 First release
 * 
 * @version 1.1 - July 21st 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm 
{
	import org.flixel.*;
	
	public class FlxMouseControl extends FlxBasic
	{
		/**
		 * Use with <code>sort()</code> to sort in ascending order.
		 */
		public static const ASCENDING:int = -1;
		
		/**
		 * Use with <code>sort()</code> to sort in descending order.
		 */
		public static const DESCENDING:int = 1;
		
		public static var sortIndex:String = "y";
		public static var sortOrder:int = ASCENDING;
		
		public static var isDragging:Boolean = false;
		public static var dragTarget:FlxExtendedSprite;
		
		private static var clickStack:Array;
		private static var clickCoords:FlxPoint;
		public static var clickTarget:FlxExtendedSprite;
		private static var hasClickTarget:Boolean = false;
		
		private static var oldX:int;
		private static var oldY:int;
		public static var speedX:int;
		public static var speedY:int;
		
		public function FlxMouseControl() 
		{
		}
		
		public static function addToStack(item:FlxExtendedSprite):void
		{
			clickStack.push(item);
		}
		
		/**
		 * Main Update Loop - checks mouse status and updates FlxExtendedSprites accordingly
		 */
		override public function update():void
		{
			//	Update mouse speed
			speedX = FlxG.mouse.x - oldX;
			speedY = FlxG.mouse.y - oldY;
			
			oldX = FlxG.mouse.x;
			oldY = FlxG.mouse.y;
			
			//	Is the mouse currently pressed down on a target?
			if (hasClickTarget)
			{
				if (FlxG.mouse.pressed())
				{
					//	Has the mouse moved? If so then we're candidate for a drag
					if (isDragging == false && clickTarget.draggable && (clickCoords.x != FlxG.mouse.x || clickCoords.y != FlxG.mouse.y))
					{
						//	Drag on
						isDragging = true;
						
						dragTarget = clickTarget;
						
						dragTarget.startDrag();
					}
				}
				else
				{
					//	Mouse is no longer down, so tell the click target it's free - this will also stop dragging if happening
					clickTarget.mouseReleasedHandler();
					
					hasClickTarget = false;
					clickTarget = null;
					
					isDragging = false;
					dragTarget = null;
				}
			}
			else
			{
				//	No target, but is the mouse down?
				
				if (FlxG.mouse.justPressed())
				{
					clickStack = new Array;
				}
				
				//	If you are wondering how the brand new array can have anything in it by now, it's because FlxExtendedSprite
				//	adds itself to the clickStack
				
				if (FlxG.mouse.pressed() && clickStack.length > 0)
				{
					assignClickedSprite();
				}
			}
		}
		
		private function assignClickedSprite():void
		{
			//	If there is more than one potential target then sort them
			if (clickStack.length > 1)
			{
				clickStack.sort(sortHandler);
			}
			
			clickTarget = clickStack.pop();
			
			clickCoords = clickTarget.point;
			
			hasClickTarget = true;
			
			clickTarget.mousePressedHandler();
			
			clickStack = [];
		}
		
		/**
		 * Helper function for the sort process.
		 * 
		 * @param 	item1	The first object being sorted.
		 * @param	item2	The second object being sorted.
		 * 
		 * @return	An integer value: -1 (item1 before item2), 0 (same), or 1 (item1 after item2)
		 */
		private function sortHandler(item1:FlxExtendedSprite, item2:FlxExtendedSprite):int
		{
			if (item1[sortIndex] < item2[sortIndex])
			{
				return sortOrder;
			}
			else if (item1[sortIndex] > item2[sortIndex])
			{
				return -sortOrder;
			}
			
			return 0;
		}
		
		public static function clear():void
		{
			hasClickTarget = false;
			
			if (clickTarget)
			{
				clickTarget.mouseReleasedHandler();
			}
			
			clickTarget = null;
			
			isDragging = false;
			
			if (dragTarget)
			{
				dragTarget.stopDrag();
			}
			
			dragTarget = null;
		}
		
		/**
		 * Runs when this plugin is destroyed
		 */
		override public function destroy():void
		{
			clear();
		}
		
	}

}