package org.flixel.plugin.photonstorm.BaseTypes 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxRect;
	public class Weapon 
	{
		public var active:Boolean = false;
		
		public var name:String;
		public var ammoCount:int;
		//	set by flxcontrol maybe?
		public var fireRate:int;
		public var bulletType:Bullet;
		public var bulletBounds:FlxRect;
		
		public var group:FlxGroup;
		
		//	pixel perfect check or bounds?
		
		//	For future update :)
		private var bulletsPerMagazine:int;
		private var magazineCount:int;
		private var magazineSwapDelay:int;
		
		public function Weapon(name:String, bullet:Bullet, maxBulletsOnscreen:int, bounds:FlxRect)
		{
			this.name = name;
			
			bulletType = bullet;
			
			group = new FlxGroup(maxBulletsOnscreen);
			
			for (var b:int = 0; b < maxBulletsOnscreen; b++)
			{
				var tempBullet:Bullet = new(bulletType);
				
				group.add(tempBullet.sprite);
				
				tempBullet.exists = false;
			}
			
			bulletBounds = bounds;
			
			active = true;
		}
		
		public function fire():void
		{
			var bullet:Bullet = getFreeBullet();
			
			if (bullet != null)
			{
				bullet.fire();
			}
		}
		
		public function update():void
		{
			removeBulletsOutOfBounds();
		}
		
		private function removeBulletsOutOfBounds():void
		{
			for each (var bullet:Bullet in group.members)
			{
				if (bullet.exists && bullet.inBounds(bulletBounds) == false)
				{
					bullet.kill();
				}
			}
		}
		
		private function getFreeBullet():Bullet
		{
			var result:Bullet = null;
			
			for each (var bullet:Bullet in group.members)
			{
				if (bullet.exists == false)
				{
					result = bullet;
					break;
				}
			}
			
			return result;
		}
		
	}

}