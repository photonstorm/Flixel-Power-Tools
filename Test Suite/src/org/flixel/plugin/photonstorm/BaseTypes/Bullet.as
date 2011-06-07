package org.flixel.plugin.photonstorm.BaseTypes 
{
	import org.flixel.FlxPoint;
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
		
		public function fireAtMouse(fromX:int, fromY:int):void
		{
			x = fromX;
			y = fromY;
			
			FlxVelocity.moveTowardsMouse(this, 60);
		}
		
		public function fireAtPosition(fromX:int, fromY:int, toX:int, toY:int):void
		{
			x = fromX;
			y = fromY;
			
			FlxVelocity.moveTowardsPoint(this, new FlxPoint(toX, toY), 60);
		}
		
		public function fireAtTarget(fromX:int, fromY:int, target:FlxSprite):void
		{
			x = fromX;
			y = fromY;
			
			FlxVelocity.moveTowardsObject(this, target, 60);
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