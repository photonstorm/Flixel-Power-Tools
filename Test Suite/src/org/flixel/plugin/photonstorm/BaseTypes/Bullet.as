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
		private var animated:Boolean;
		
		public function Bullet(weapon:Weapon, id:uint)
		{
			super(0, 0);
			
			this.weapon = weapon;
			this.id = id;
			
			exists = false;
		}
		
		/**
		 * Adds a new animation to the sprite.
		 * 
		 * @param	Name		What this animation should be called (e.g. "run").
		 * @param	Frames		An array of numbers indicating what frames to play in what order (e.g. 1, 2, 3).
		 * @param	FrameRate	The speed in frames per second that the animation should play at (e.g. 40 fps).
		 * @param	Looped		Whether or not the animation is looped or just plays once.
		 */
		override public function addAnimation(Name:String, Frames:Array, FrameRate:Number = 0, Looped:Boolean = true):void
		{
			super.addAnimation(Name, Frames, FrameRate, Looped);
			
			animated = true;
		}
		
		public function fire(fromX:int, fromY:int, velX:int, velY:int):void
		{
			x = fromX;
			y = fromY;
			
			velocity.x = velX;
			velocity.y = velY;
			
			if (animated)
			{
				play("fire");
			}
			
			exists = true;
		}
		
		public function fireAtMouse(fromX:int, fromY:int, speed:int):void
		{
			x = fromX;
			y = fromY;
			
			FlxVelocity.moveTowardsMouse(this, speed);
			
			if (animated)
			{
				play("fire");
			}
			
			exists = true;
		}
		
		public function fireAtPosition(fromX:int, fromY:int, toX:int, toY:int, speed:int):void
		{
			x = fromX;
			y = fromY;
			
			FlxVelocity.moveTowardsPoint(this, new FlxPoint(toX, toY), speed);
			
			if (animated)
			{
				play("fire");
			}
			
			exists = true;
		}
		
		public function fireAtTarget(fromX:int, fromY:int, target:FlxSprite, speed:int):void
		{
			x = fromX;
			y = fromY;
			
			FlxVelocity.moveTowardsObject(this, target, speed);
			
			if (animated)
			{
				play("fire");
			}
			
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