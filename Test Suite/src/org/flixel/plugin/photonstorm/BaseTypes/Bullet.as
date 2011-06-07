package org.flixel.plugin.photonstorm.BaseTypes 
{
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxMath;
	import org.flixel.plugin.photonstorm.FlxVelocity;

	public class Bullet extends FlxSprite
	{
		public var id:uint;
		private var weapon:Weapon;
		private var bulletSpeed:int;
		
		public function Bullet(weapon:Weapon, id:uint, image:Class = null, width:int = 2, height:int = 2, color:uint = 0xffffffff)
		{
			super(0, 0);
			
			this.weapon = weapon;
			this.id = id;
			
			if (image)
			{
				loadGraphic(image);
			}
			else
			{
				makeGraphic(width, height, color);
			}
			
			exists = false;
		}
		
		public function fire(fromX:int, fromY:int, velX:int, velY:int):void
		{
			x = fromX;
			y = fromY;
			
			velocity.x = velX;
			velocity.y = velY;
			
			exists = true;
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxMath.pointInFlxRect(x, y, weapon.bounds) == false)
			{
				kill();
			}
		}
		
	}

}