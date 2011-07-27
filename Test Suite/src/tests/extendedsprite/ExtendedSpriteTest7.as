package tests.extendedsprite 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import tests.TestsHeader;

	public class ExtendedSpriteTest7 extends FlxState
	{
		//	Common variables
		public static var title:String = "Sprite Throw 1";
		public static var description:String = "Throwing Sprites";
		private var instructions:String = "Throw the sprite with the mouse";
		private var header:TestsHeader;
		
		//	Test specific variables
		
		private var ball:FlxExtendedSprite;
		
		public function ExtendedSpriteTest7() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			
			//	Enable the plugin - you only need do this once in your State (unless you destroy the plugin)
			if (FlxG.getPlugin(FlxMouseControl) == null)
			{
				FlxG.addPlugin(new FlxMouseControl);
			}
			
			ball = new FlxExtendedSprite(64, 48, AssetsRegistry.shinyBallPNG);
			ball.enableMouseDrag(false, true);
			ball.enableMouseClicks(true);
			ball.mouseReleasedCallback = throwSprite;
			ball.priorityID = 2;
			ball.elasticity = 0.6;
			
			add(FlxCollision.createCameraWall(FlxG.camera, FlxCollision.CAMERA_WALL_OVERLAP, 16, true));
			
			add(ball);
			
			//	Header overlay
			//add(header.overlay);
		}
		
		private function throwSprite(obj:FlxExtendedSprite, x:int, y:int):void
		{
			trace("mouse speed", FlxMouseControl.speedX, FlxMouseControl.speedY);
			
			obj.velocity.x = FlxMouseControl.speedX * 50;
			obj.velocity.y = FlxMouseControl.speedY * 50;
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.collide();
		}
		
		override public function destroy():void
		{
			//	Important! Clear out the plugin otherwise resources will get messed right up after a while
			FlxMouseControl.clear();
			
			super.destroy();
		}
		
	}

}