/**
 * FlxSpecialFX
 * -- Part of the Flixel Power Tools set
 * 
 * v1.0 First release of the new FlxSpecialFX system
 * 
 * @version 1.0 - May 9th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm 
{
	import flash.utils.Dictionary;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FX.PlasmaFX;
	import org.flixel.plugin.photonstorm.FX.RainbowLineFX;
	
	/**
	 * FlxSpecialFX is a single point of access to all of the FX Plugins available in the Flixel Power Tools
	 */
	public class FlxSpecialFX extends FlxBasic
	{
		private static var members:Dictionary = new Dictionary(true);
		
		public function FlxSpecialFX() 
		{
		}
		
		//	THE SPECIAL FX PLUGINS AVAILABLE
		
		/**
		 * Creates a Plama field Effect
		 * 
		 * @return	PlasmaFX
		 */
		public static function plasma():PlasmaFX
		{
			var temp:PlasmaFX = new PlasmaFX;
			
			members[temp] = temp;
			
			return members[temp];
		}
		
		/**
		 * Creates a Rainbow Line Effect
		 * 
		 * @return	RainbowLineFX
		 */
		public static function rainbowLine():RainbowLineFX
		{
			var temp:RainbowLineFX = new RainbowLineFX;
			
			members[temp] = temp;
			
			return members[temp];
		}
		
		//	GLOBAL FUNCTIONS
		
		/**
		 * Starts the given FX Plugin running
		 * 
		 * @param	source	A reference to the FX Plugin you wish to run. If null it will start all currently added FX Plugins
		 */
		public static function startFX(source:Class = null):void
		{
			if (source)
			{
				members[source].active = true;
			}
			else
			{
				for each (var obj:Object in members)
				{
					obj.active = true;
				}
			}
		}
		
		/**
		 * Stops the given FX Plugin running
		 * 
		 * @param	source	A reference to the FX Plugin you wish to stop. If null it will stop all currently added FX Plugins
		 */
		public static function stopFX(source:Class = null):void
		{
			if (source)
			{
				members[source].active = false;
			}
			else
			{
				for each (var obj:Object in members)
				{
					obj.active = false;
				}
			}
		}
		
		/**
		 * Returns the active state of the given FX Plugin running
		 * 
		 * @param	source	A reference to the FX Plugin you wish to run. If null it will start all currently added FX Plugins
		 * @return	Boolean	true if the FX Plugin is active, false if not
		 */
		public static function isActive(source:Class):Boolean
		{
			if (members[source])
			{
				return members[source].active;
			}
			
			return false;
		}
		
		/**
		 * Called automatically by Flixels Plugin handler
		 */
		override public function draw():void
		{
			if (FlxG.paused)
			{
				return;
			}
			
			for each (var obj:Object in members)
			{
				if (obj.active)
				{
					obj.draw();
				}
			}
		}
		
		/**
		 * Removes a FX Plugin from the Special FX Handler
		 * 
		 * @param	source	The FX Plugin to remove
		 * @return	Boolean	true if the plugin was removed, otherwise false.
		 */
		public static function remove(source:Object):Boolean
		{
			if (members[source])
			{
				members[source].active = false;
				members[source].sprite.kill();
				members[source].canvas.dispose;
				
				delete members[source];
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Removes all FX Plugins<br>
		 * This is called automatically if the plugin is destroyed, but should be called manually by you if you change States
		 */
		public static function clear():void
		{
			for each (var obj:Object in members)
			{
				remove(obj);
			}
		}
		
		/**
		 * Destroys all FX Plugins currently added and then destroys this instance of the FlxSpecialFX Plugin
		 */
		override public function destroy():void
		{
			clear();
		}
		
		
	}

}