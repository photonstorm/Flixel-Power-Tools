package tests 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class FlxDelayTest1 extends FlxState
	{
		//	Common variables
		public static var title:String = "Delay 1";
		public static var description:String = "Example of the FlxDelay timer class";
		private var instructions:String = "Sprites change position every 2000ms (2 seconds)";
		private var header:TestsHeader;
		
		//	Test specific variables
		
		[Embed(source = '../../assets/red_ball.png')] private var redPNG:Class;
		[Embed(source = '../../assets/green_ball.png')] private var greenPNG:Class;
		[Embed(source = '../../assets/blue_ball.png')] private var bluePNG:Class;
		
		private var timer:FlxDelay;
		private var red:FlxSprite;
		private var green:FlxSprite;
		private var blue:FlxSprite;
		
		public function FlxDelayTest1() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			
			red = new FlxSprite(32, 32, redPNG);
			green = new FlxSprite(96, 96, greenPNG);
			blue = new FlxSprite(128, 128, bluePNG);
			
			timer = new FlxDelay(2000);
			timer.start();
			
			add(blue);
			add(red);
			add(green);
		}
		
		override public function update():void
		{
			super.update();
			
			if (timer.hasExpired)
			{
				//	If 1000ms (1 second) has passed then the timer expires
				
				//	Randomise the sprite positions
				red.x = FlxMath.rand(0, 320 - red.width);
				red.y = FlxMath.rand(32, 180);
				
				green.x = FlxMath.rand(0, 320 - green.width);
				green.y = FlxMath.rand(32, 180);

				blue.x = FlxMath.rand(0, 320 - blue.width);
				blue.y = FlxMath.rand(32, 180);
				
				//	And start the timer again
				timer.start();
			}
			
		}
		
	}

}