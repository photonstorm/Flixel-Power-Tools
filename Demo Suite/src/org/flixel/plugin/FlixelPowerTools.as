/**
 * Flixel Power Tools
 * 
 * Version information and constants the other classes in this package can reference
 * 
 * @version 2.0
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin 
{
	import org.flixel.*;
	
	public class FlixelPowerTools extends FlxBasic
	{
		public static const LIBRARY_NAME:String = "flixel power tools";
		public static const LIBRARY_MAJOR_VERSION:int = 2;
		public static const LIBRARY_MINOR_VERSION:int = 0;
		
		public function FlixelPowerTools()
		{
		}
		
		/**
		 * Called by <code>FlxG.updatePlugins()</code> before the state update() has been called.
		 */
		override public function update():void
		{
		}
		
		/**
		 * Called by <code>FlxG.drawPlugins()</code> AFTER the state has been drawn.
		 */
		override public function draw():void
		{
		}
		
		/**
		 * Clean up memory.
		 */
		override public function destroy():void
		{
		}
		
	}

}