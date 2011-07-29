package tests.extendedsprite 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.BaseTypes.Spring;
	import tests.TestsHeader;

	public class ExtendedSpriteTest12 extends FlxState
	{
		//	Common variables
		public static var title:String = "Springs 1";
		public static var description:String = "Throw a Sprite";
		private var instructions:String = "Throw the sprite with the mouse";
		private var header:TestsHeader;
		
		//	Test specific variables
		
		private var ball:FlxExtendedSprite;
		private var ball2:FlxExtendedSprite;
		private var mouseSpring:Spring;
		private var mouseSpring2:Spring;
		private var debug:FlxSprite;
		
		public function ExtendedSpriteTest12() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			ball = new FlxExtendedSprite(160, 120, AssetsRegistry.redPNG);
			ball.springOffsetX = 8;
			ball.springOffsetY = 8;
			
			ball2 = new FlxExtendedSprite(160, 160, AssetsRegistry.bluePNG);
			ball2.springOffsetX = 8;
			ball2.springOffsetY = 8;
			
			mouseSpring = new Spring(true, ball);
			mouseSpring2 = new Spring(false, ball2, ball);
			
			debug = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0x0);
			
			add(debug);
			add(ball);
			add(ball2);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
			
			//	Draw the spring
			
			debug.fill(0x0);
			debug.drawLine(ball.springX, ball.springY, FlxG.mouse.x, FlxG.mouse.y, 0xffFFFFFF, 1);
			debug.drawLine(ball.springX, ball.springY, ball2.springX, ball2.springY, 0xffFFFFFF, 1);
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
	}

}