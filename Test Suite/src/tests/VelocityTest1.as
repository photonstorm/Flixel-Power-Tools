package tests 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class FlxVelocityTest1 extends FlxState
	{
		//	Common variables
		public static var title:String = "Velocity 1";
		public static var description:String = "Move an FlxObject towards another FlxObject";
		private var instructions:String = "Click with the mouse to position the green ball";
		private var header:TestsHeader;
		
		//	Test specific variables
		
		[Embed(source = '../../assets/red_ball.png')] private var redPNG:Class;
		[Embed(source = '../../assets/green_ball.png')] private var greenPNG:Class;
		[Embed(source = '../../assets/blue_ball.png')] private var bluePNG:Class;
		
		private var red:FlxSprite;
		private var green:FlxSprite;
		private var blue:FlxSprite;
		
		public function FlxVelocityTest1() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			
			red = new FlxSprite(160, 120, redPNG);
			green = new FlxSprite(-32, 0, greenPNG);
			blue = new FlxSprite(0, 0, bluePNG);
			blue.visible = false;
			
			add(blue);
			add(red);
			add(green);
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.mouse.justReleased())
			{
				green.x = FlxG.mouse.screenX;
				green.y = FlxG.mouse.screenY;
				
				blue.x = red.x;
				blue.y = red.y;
				blue.visible = true;
				
				FlxVelocity.moveTowardsObject(blue, green, 180);
			}
		}
		
	}

}