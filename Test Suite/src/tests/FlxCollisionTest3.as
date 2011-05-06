package tests 
{
	import flash.display.BitmapData;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class FlxCollisionTest3 extends FlxState
	{
		//	Common variables
		public static var title:String = "Collision 3";
		public static var description:String = "Pixel perfect collision with alpha tolerance";
		private var instructions:String = "";
		private var header:TestsHeader;
		
		//	Test specific variables
		[Embed(source = '../../assets/alpha-test.png')] private var alphaPNG:Class;
		[Embed(source = '../../assets/green_ball.png')] private var greenPNG:Class;
		
		private var alphaTest:FlxSprite;
		private var green:FlxSprite;
		
		private var movingBall:Boolean;
		
		public function FlxCollisionTest3() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			
			alphaTest = new FlxSprite(0, 0, alphaPNG);
			FlxDisplay.screenCenter(alphaTest, true, true);
			
			green = new FlxSprite(160, 120, greenPNG);
			
			add(alphaTest);
			add(green);
		}
		
		override public function update():void
		{
			super.update();
			
			green.x = FlxG.mouse.screenX;
			green.y = FlxG.mouse.screenY;
			
			//	By setting the alpha tolerance value you can control when a collision is made.
			//	In this case only pixels with an alpha level of 125 or above are counted
			//	(which includes the black text above and below the pink fade :)
			header.instructions.text = "Colliding when alpha > 125: " + FlxCollision.pixelPerfectCheck(alphaTest, green, 125);
		}
		
	}

}