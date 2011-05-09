package tests 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class FlxVelocityTest2 extends FlxState
	{
		//	Common variables
		public static var title:String = "Velocity 2";
		public static var description:String = "Get the angle between 2 FlxObjects";
		private var instructions:String = "";
		private var header:TestsHeader;
		
		//	Test specific variables
		[Embed(source = '../../assets/red_ball.png')] private var redPNG:Class;
		[Embed(source = '../../assets/green_ball.png')] private var greenPNG:Class;
		
		private var red:FlxSprite;
		private var green:FlxSprite;
		
		public function FlxVelocityTest2() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			
			red = new FlxSprite(160, 120, redPNG);
			green = new FlxSprite( -32, 0, greenPNG);
			
			add(red);
			add(green);
		}
		
		override public function update():void
		{
			super.update();
			
			green.x = FlxG.mouse.screenX;
			green.y = FlxG.mouse.screenY;
			
			var a:Number = FlxVelocity.angleBetween(red, green);
			
			header.instructions.text = "Angle between red and green: " + Math.round(FlxMath.asDegrees(a));
		}
		
	}

}