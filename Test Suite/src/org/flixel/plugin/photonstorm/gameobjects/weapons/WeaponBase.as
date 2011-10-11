package org.flixel.plugin.photonstorm.gameobjects.weapons 
{
	import org.flixel.plugin.photonstorm.FlxWeapon;
	
	/**
	 * ...
	 * @author Richard Davey
	 */
	public class WeaponBase extends FlxWeapon 
	{
		
		public function WeaponBase(name:String, parentRef:*=null, xVariable:String="x", yVariable:String="y") 
		{
			super(name, parentRef, xVariable, yVariable);
			
		}
		
	}

}