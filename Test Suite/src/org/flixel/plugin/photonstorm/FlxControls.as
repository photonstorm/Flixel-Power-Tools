/**
 * FlxControls
 * -- Part of the Flixel Power Tools set
 * 
 * v1.2 First real version deployed to dev
 * v1.1 Updated for the Flixel 2.5 Plugin system
 * 
 * @version 1.2 - May 12th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm 
{
	import org.flixel.*;
	
	public class FlxControls
	{
		private var upKey:String = "UP";
		private var downKey:String = "DOWN";
		private var leftKey:String = "LEFT";
		private var rightKey:String = "RIGHT";
		private var fireKey:String = "CONTROL";	// ctrl
		private var jumpKey:String = "SPACE";	// space
		
		//private var quitKey:int = ;	// Q
		
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
		}
		
		public function basicCursorControl(source:FlxSprite, xSpeed:int, ySpeed:int, horizontal:Boolean = true, vertical:Boolean = true):void
		{
			entity = source;
			runBasicControl = true;
			checkArrows = true;
			
			xVelocity = xSpeed;
			yVelocity = ySpeed;
			
			//active = true;
			
			//enableArrowKeys(moveUp, moveDown, moveLeft, moveRight);
		}
		
		private function moveLeft():void
		{
			entity.velocity.x = -xVelocity;
		}
		
		private function moveRight():void
		{
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
		
		public function enableWASDKeys(up:Boolean = true, down:Boolean = true, left:Boolean = true, right: Boolean = true):void
		{
		}
		
		public function reDefineKeys(up:String, down:String, left:String, right:String, jump:String, fire:String):void
		{
		}
		
		public function update():void
		{
			if (entity == null)
			{
				return;
			}
			
			//entity.acceleration.x = 0;
			//entity.acceleration.y = 0;
			//
			//if (checkArrows)
			//{
				//if (FlxG.keys.UP)
				//{
					//entity.acceleration.y = -yVelocity;
				//}
				//else if (FlxG.keys.DOWN)
				//{
					//entity.acceleration.y = yVelocity;
				//}
				//
				//if (FlxG.keys.LEFT)
				//{
					//entity.facing = FlxObject.LEFT;
					//entity.acceleration.x = -xVelocity;
				//}
				//else if (FlxG.keys.RIGHT)
				//{
					//entity.facing = FlxObject.RIGHT;
					//entity.acceleration.x = xVelocity;
				//}
			//}
			
			//entity.velocity.x = 0;
			//entity.velocity.y = 0;
			
			if (checkArrows)
			{
				if (FlxG.keys.UP)
				{
					entity.velocity.y = -yVelocity;
				}
				else if (FlxG.keys.DOWN)
				{
					entity.velocity.y = yVelocity;
				}
				
				if (FlxG.keys.LEFT)
				{
					entity.facing = FlxObject.LEFT;
					entity.velocity.x = -xVelocity;
				}
				else if (FlxG.keys.RIGHT)
				{
					entity.facing = FlxObject.RIGHT;
					entity.velocity.x = xVelocity;
				}
			}
			
		}
		
	}

}