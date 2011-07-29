package org.flixel.plugin.photonstorm.BaseTypes 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxExtendedSprite;
	
	public class Spring 
	{
		public var sprite1:FlxExtendedSprite;
		public var sprite2:FlxExtendedSprite;
		
		public var isMouseSpring:Boolean = false;
		
		public var tension:Number = 0.1;
		public var friction:Number = 0.95;
		public var gravity:Number = 0;
		
		private var vx:Number = 0;
		private var vy:Number = 0;
	
		private var dx:Number = 0;
		private var dy:Number = 0;
		
		private var ax:Number = 0;
		private var ay:Number = 0;
		
		public function Spring(mouseSpring:Boolean, sprite:FlxExtendedSprite, connectedTo:FlxExtendedSprite = null, tension:Number = 0.1, friction:Number = 0.95, gravity:Number = 0)
		{
			isMouseSpring = mouseSpring;
			
			sprite1 = sprite;
			sprite2 = connectedTo;
			
			sprite1.addSpring(this);
			
			this.tension = tension;
			this.friction = friction;
			this.gravity = gravity;
		}
		
		public function update():void
		{
			if (isMouseSpring)
			{
				dx = FlxG.mouse.x - sprite1.springX;
				dy = FlxG.mouse.y - sprite1.springY;
			}
			else
			{
				dx = sprite1.springX - sprite2.springX;
				dx = sprite1.springY - sprite2.springY;
			}
			
			ax = dx * tension;
			ay = dy * tension;
			
			vx += ax;
			vy += ay;
			
			vy += gravity;
			vx *= friction;
			vy *= friction;
			
			sprite1.x += vx;
			sprite1.y += vy;
		}
		
	}

}