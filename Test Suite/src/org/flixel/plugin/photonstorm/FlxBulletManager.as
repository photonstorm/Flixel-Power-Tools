package org.flixel.plugin.photonstorm 
{
	import flash.utils.Dictionary;
	import org.flixel.FlxBasic;
	import org.flixel.plugin.photonstorm.BaseTypes.Weapon;

	public class FlxBulletManager extends FlxBasic
	{
		private static var weapons:Dictionary = new Dictionary(true);
		private static var bullets:Dictionary = new Dictionary(true);
		
		public function FlxBulletManager() 
		{
		}
		
		public static function addBullet():void
		{
		}
		
		public static function addWeapon(source:Weapon):void
		{
			if (weapons[source])
			{
				throw Error("Weapon already exists in FlxBulletManager");
			}
			
			weapons[source] = source;
		}
		
		override public function update():void
		{
			for each (var weapon:Weapon in weapons)
			{
				if (weapon.active)
				{
					weapon.update();
				}
			}
		}
		
		override public function destroy():void
		{
			clear();
		}
		
		/**
		 * Removes a Weapon.
		 * 
		 * @param	source	The Weapon.
		 * @return	Boolean	true if the Weapon was removed, otherwise false.
		 */
		public static function removeWeapon(source:Weapon):Boolean
		{
			if (weapons[source])
			{
				delete weapons[source];
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Removes all Weapons and Bullets.<br />
		 * This is called automatically if the plugin is ever destroyed.
		 */
		public static function clear():void
		{
			for each (var weapon:Weapon in weapons)
			{
				delete weapons[weapon];
			}
		}
		
	}

}