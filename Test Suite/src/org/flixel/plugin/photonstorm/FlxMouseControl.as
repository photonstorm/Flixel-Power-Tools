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
		
		public function FlxMouseControl() 
		{
		}
		
		public static function addToDragStack(item:FlxExtendedSprite):void
		{
			clickStack.push(item);
		}
		
		/**
		 * 
		 */
		override public function update():void
		{
			if (isDragging)
			{
				if (FlxG.mouse.pressed() && dragTarget)
				{
					// TODO Ideally we'd do it like this, but not until Adam adds support for plugins to run in post and pre Update loops
					//dragTarget.updateDrag();
				}
				else if (FlxG.mouse.pressed() == false && dragTarget)
				{
					dragTarget.stopDrag();
					
					dragTarget = null;
					
					isDragging = false;
				}
			}
			else
			{
				if (FlxG.mouse.justPressed())
				{
					clickStack = new Array();
				}
				
				//	If you are wondering how the brand new array can have anything in it by now, it's because FlxExtendedSprite
				//	adds itself to the clickStack
				
				if (FlxG.mouse.pressed() && clickStack.length > 0)
				{
					assignDraggedSprite();
				}
			}
		}
		
		private function assignDraggedSprite():void
		{
			if (clickStack.length == 1)
			{
				//	Easy, there's only one anyway ...
				dragTarget = clickStack.pop();
				
				dragTarget.startDrag();
				
				clickStack = [];
			}
			else
			{
				//	We've got more than one candidate, so we need to sort them
				clickStack.sort(sortHandler);
				
				dragTarget = clickStack.pop();
				
				dragTarget.startDrag();
				
				clickStack = [];
			}
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
		
		/**
		 * Runs when this plugin is destroyed
		 */
		override public function destroy():void
		{
			clear();
		}
		
		public static function clear():void
		{
			isDragging = false;
			
			if (dragTarget)
			{
				dragTarget.stopDrag();
			}
			
			dragTarget = null;
		}
		
	}

}