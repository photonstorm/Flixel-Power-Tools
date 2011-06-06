package org.flixel.plugin.photonstorm.BaseTypes 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxRect;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.plugin.photonstorm.FlxMath;
	import org.flixel.plugin.photonstorm.FlxVelocity;

	public class Bullet
	{
		public var id:int;
		public var sprite:FlxSprite;
		public var active:Boolean;
		public var exists:Boolean;
		
		private var type:int;
		
		public static const FIRE_VERTICALLY:uint = 1;
		public static const FIRE_HORIZONTALLY:uint = 2;
		public static const FIRE_ANGLE:uint = 3;
		public static const FIRE_TO_TARGET:uint = 4;
		public static const FIRE_TO_MOUSE:uint = 5;
		public static const FIRE_TO_POSITION:uint = 6;
		
		private var speed:uint;
		private var rotateToAngle:Boolean;
		
		private var fireFromPosition:Boolean;
		private var fireX:int;
		private var fireY:int;
		
		private var fireAnimation:Boolean;
		
		private var fireFromParent:Boolean;
		private var parent:*;
		private var parentXVariable:String;
		private var parentYVariable:String;
		
		public var positionOffset:FlxPoint;
		
		public var onKillCallback:Function;
		public var onFireCallback:Function;
		
		public var playSounds:Boolean;
		public var onKillSound:FlxSound;
		public var onFireSound:FlxSound;
		
		//	Allow it to bounce / rebound? could have a bounce limit before kill
		//	Tween it so it can accelerate / decelerate? Or just use flxsprite accel for that
		
		public function Bullet(bulletType:uint, speed:uint, image:Class = null, width:int = 2, height:int = 2, color:uint = 0xffffffff)
		{
			type = bulletType;
			
			this.speed = speed;
			
			if (image)
			{
				sprite = new FlxSprite(0, 0, image);
			}
			else
			{
				sprite = new FlxSprite(0, 0).makeGraphic(width, height, color);
			}
			
			exists = true;
			active = false;
		}
		
		public function setLifeSpan():void
		{
			//	duration in ms or px?
		}
		
		public function fixedPosition():void
		{
		}
		
		public function setDirection():void
		{
			//	optional random variance (for stuttering bullets)
		}
		
		public function setParent(parentRef:*, xVariable:String, yVariable:String, offsetX:int = 0, offsetY:int = 0):void
		{
			parent = parentRef;
			parentXVariable = xVariable;
			parentYVariable = yVariable;
			fireFromParent = true;
			positionOffset = new FlxPoint(offsetX, offsetY);
		}
		
		public function createAnimatedBullet():void
		{
		}
		
		public function fire():void
		{
			trace("bullet", id, "fired");
			
			if (active)
			{
				return;
			}
			
			if (fireFromPosition)
			{
				// todo
			}
			else if (fireFromParent)
			{
				sprite.x = parent[parentXVariable] + positionOffset.x;
				sprite.y = parent[parentYVariable] + positionOffset.y;
				active = true;
				sprite.velocity.y = -speed;
				sprite.exists = true;
			}
		}
		
		public function kill():void
		{
			trace("bullet", id, "killed");
			
			exists = false;
			active = false;
			sprite.exists = false;
		}
		
		public function inBounds(bounds:FlxRect):Boolean
		{
			var point:FlxPoint = sprite.getScreenXY();
			
			return FlxMath.pointInFlxRect(point.x, point.y, bounds);
		}
		
		
	}

}