/**
 * FlxControls
 * -- Part of the Flixel Power Tools set
 * 
 * v1.1 Updated for the Flixel 2.5 Plugin system
 * 
 * @version 1.1 - April 23rd 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm 
{
	import org.flixel.*;
	
	public class FlxControls extends FlxBasic
	{
		//private var upKey:int = 38;
		//private var downKey:int = 40;
		//private var leftKey:int = 37;
		//private var rightKey:int = 39;
		//private var fireKey:int = 17;	// ctrl
		//private var jumpKey:int = 32;	// space
		
		private var upKey:String = "UP";
		private var downKey:String = "DOWN";
		private var leftKey:String = "LEFT";
		private var rightKey:String = "RIGHT";
		private var fireKey:String = "CONTROL";	// ctrl
		private var jumpKey:String = "SPACE";	// space
		
		//private var quitKey:int = ;	// Q
		
		public var upCallback:Function;
		public var downCallback:Function;
		public var leftCallback:Function;
		public var rightCallback:Function;
		public var fireCallback:Function;
		public var jumpCallback:Function;
		
		private var runBasicControl:Boolean = false;
		private var entity:FlxSprite = null;
		public var xVelocity:int;
		public var yVelocity:int;
		
		private var checkArrows:Boolean = false;
		private var checkWASD:Boolean = false;
		
		public function FlxControls() 
		{
			super();
			
			trace("c born");
			
			FlxG.state.add(this);
		}
		
		public function basicCursorControl(parent:FlxSprite, xSpeed:int, ySpeed:int):void
		{
			trace("c basic");
			
			entity = parent;
			runBasicControl = true;
			
			xVelocity = xSpeed;
			yVelocity = ySpeed;
			
			enableArrowKeys(moveUp, moveDown, moveLeft, moveRight);
		}
		
		private function moveLeft():void
		{
			trace("left");
			entity.velocity.x = -xVelocity;
		}
		
		private function moveRight():void
		{
			trace("right");
			entity.velocity.x = xVelocity;
		}
		
		private function moveUp():void
		{
			entity.velocity.y = -yVelocity;
		}
		
		private function moveDown():void
		{
			entity.velocity.y = yVelocity;
		}
		
		public function enableArrowKeys(up:Function = null, down:Function = null, left:Function = null, right:Function = null):void
		{
			if (up is Function)
			{
				upCallback = up;
			}
			
			if (down is Function)
			{
				downCallback = down;
			}
			
			if (left is Function)
			{
				leftCallback = left;
			}
			
			if (right is Function)
			{
				rightCallback = right;
			}
			
			checkArrows = true;
		}
		
		public function enableLeftKey(callback:Function):void
		{
		}
		
		//public function enableArrowKeys():void
		//{
		//}
		
		public function enableWASDKeys(up:Boolean = true, down:Boolean = true, left:Boolean = true, right: Boolean = true):void
		{
		}
		
		public function reDefineKeys(up:String, down:String, left:String, right:String, jump:String, fire:String):void
		{
		}
		
		override public function update():void
		{
			//super.update();
			
			trace("c update");
			
			if (checkArrows)
			{
				if (FlxG.keys.pressed(upKey) && upCallback is Function)
				{
					upCallback.call();
				}
				
				if (FlxG.keys.pressed(downKey) && downCallback is Function)
				{
					downCallback.call();
				}
				
				if (FlxG.keys.pressed(leftKey) && leftCallback is Function)
				{
					leftCallback.call();
				}
				
				if (FlxG.keys.pressed(rightKey) && rightCallback is Function)
				{
					rightCallback.call();
				}
			}
		}
		
	}

}