package org.flixel.plugin.photonstorm 
{
	import flash.utils.Dictionary;
	import org.flixel.*;

	public class FlxBarManager extends FlxBasic
	{
		private static var members:Dictionary = new Dictionary(true);
		
		public function FlxBarManager() 
		{
		}
		
		/**
		 * Create a new FlxBar Object
		 * 
		 * @return	FlxBar		An FlxBar object
		 */
		public static function create():FlxBar
		{
			var result:FlxBar = new FlxBar();
			
			members[result] = result;
			
			return result;
		}
		
		/**
		 * Removes an FlxBar.
		 * 
		 * @param	source	The FlxBar to remove
		 * @return	Boolean	true if the FlxBar was removed, otherwise false.
		 */
		public static function remove(source:FlxBar):Boolean
		{
			if (members[source])
			{
				delete members[source];
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Removes all FlxBar.<br />
		 * This is called automatically if this plugin is ever destroyed.
		 */
		public static function clear():void
		{
			for each (var handler:FlxBar in members)
			{
				delete members[handler];
			}
		}
		
		/**
		 * Starts updating the given FlxBar, enabling keyboard actions for it. If no FlxControlHandler is given it starts updating all FlxControlHandlers currently added.<br />
		 * Updating is enabled by default, but this can be used to re-start it if you have stopped it via stop().<br />
		 * 
		 * @param	source	The FlxControlHandler to start updating on. If left as null it will start updating all handlers.
		 */
		public static function start(source:FlxBar = null):void
		{
			if (source)
			{
				members[source].enabled = true;
			}
			else
			{
				for each (var handler:FlxBar in members)
				{
					handler.enabled = true;
				}
			}
		}
		
		/**
		 * Stops updating the given FlxBar. If no FlxControlHandler is given it stops updating all FlxControlHandlers currently added.<br />
		 * Updating is enabled by default, but this can be used to stop it, for example if you paused your game (see start() to restart it again).<br />
		 * 
		 * @param	source	The FlxControlHandler to stop updating. If left as null it will stop updating all handlers.
		 */
		public static function stop(source:FlxBar = null):void
		{
			if (source)
			{
				members[source].enabled = false;
			}
			else
			{
				for each (var handler:FlxBar in members)
				{
					handler.enabled = false;
				}
			}
		}
		
		/**
		 * Runs update on all currently active FlxBar
		 */
		override public function draw():void
		{
			for each (var handler:FlxBar in members)
			{
				if (handler.enabled == true)
				{
					handler.update();
				}
			}
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