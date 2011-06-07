package org.flixel.plugin.photonstorm.BaseTypes 
{
	import org.flixel.*;
	
	/**
	 * A Weapon can only fire 1 type of bullet. But it can fire many of them at once (in different directions if needed)
	 * A Player could fire multiple Weapons at the same time however
	 */
	
	public class Weapon 
	{
		public var active:Boolean = false;
		
		public var name:String;
		
		public var group:FlxGroup;
		
		//	pixel perfect check or bounds?
		
		//	For future update :)
		private var magazineCount:int;
		private var roundsPerMagazine:int;
		private var magazineSwapDelay:int;
		private var magazineSwapCallback:Function;
		
		//	Firing directions
		public static const BULLET_VERTICAL:uint = 0;
		public static const BULLET_HORIZONTAL:uint = 1;
		public static const BULLET_ANGLE:uint = 2;
		
		public static const FIRE_TO_TARGET:uint = 0;
		public static const FIRE_TO_MOUSE:uint = 1;
		public static const FIRE_TO_POSITION:uint = 2;
		
		public static const FIRE_FROM_TARGET:uint = 0;
		public static const FIRE_FROM_MOUSE:uint = 1;
		public static const FIRE_FROM_POSITION:uint = 2;
		
		//	Bullet values
		private var bulletSprite:FlxSprite;
		private var bulletSpeed:uint;
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
		
		public var bounds:FlxRect;
		
		public function Weapon(name:String, parentRef:* = null, xVariable:String = "x", yVariable:String = "y")
		{
			this.name = name;
			
			if (parentRef)
			{
				setParent(parentRef, xVariable, yVariable);
			}
			
			bounds = new FlxRect(0, 0, FlxG.width, FlxG.height);
			positionOffset = new FlxPoint;
		}
		
		
		
		public function makePixelBullets(quantity:uint, width:int = 2, height:int = 2, color:uint = 0xffffffff, offsetX:int = 0, offsetY:int = 0):void
		{
			group = new FlxGroup(quantity);
			
			for (var b:uint = 0; b < quantity; b++)
			{
				var tempBullet:Bullet = new Bullet(this, b, null, width, height, color);
				
				group.add(tempBullet);
			}
			
			positionOffset.x = offsetX;
			positionOffset.y = offsetY;
		}
		
		public function makeImageBullets(quantity:uint, image:Class, offsetX:int = 0, offsetY:int = 0):void
		{
			group = new FlxGroup(quantity);
			
			for (var b:uint = 0; b < quantity; b++)
			{
				var tempBullet:Bullet = new Bullet(this, b, image);
				
				group.add(tempBullet);
			}
			
			positionOffset.x = offsetX;
			positionOffset.y = offsetY;
		}
		
		public function makeAnimatedBullets(quantity:uint, image:Class, frames:Array, animationSpeed:uint, looped:Boolean, offsetX:int = 0, offsetY:int = 0):void
		{
		}
		
		
		
		public function set bulletBounds(bounds:FlxRect):void
		{
			this.bounds = bounds;
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
		
		public function setParent(parentRef:*, xVariable:String, yVariable:String):void
		{
			parent = parentRef;
			parentXVariable = xVariable;
			parentYVariable = yVariable;
			fireFromParent = true;
		}
		
		public function fire():void
		{
			var bullet:Bullet = getFreeBullet();
			
			if (bullet != null)
			{
				bullet.fire(parent[parentXVariable], parent[parentYVariable], 0, -200);
			}
		}
		
		public function update():void
		{
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