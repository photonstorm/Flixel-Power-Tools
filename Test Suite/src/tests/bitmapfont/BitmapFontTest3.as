package tests.bitmapfont 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import tests.TestsHeader;

	public class BitmapFontTest3 extends FlxState
	{
		//	Common variables
		private var header:TestsHeader;
		public static var title:String = "Bitmap Font 3";
		public static var description:String = "Using Bitmap Fonts in your games";
		private var instructions:String = "Using Bitmap Fonts in your games";
		
		//	Test specific variables
		private var canvas:FlxSprite;
		private var font:FlxBitmapFont;
		
		public function BitmapFontTest3() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);

			//	Test specific
			
			canvas = new FlxSprite(14, 32).makeGraphic(256+36, 176, 0xff000000, true);
			canvas.drawLine(0, 0, canvas.width, 0, 0xffffffff);
			canvas.drawLine(0, canvas.height - 1, canvas.width, canvas.height - 1, 0xffffffff);
			
			//font = new FlxBitmapFont(AssetsRegistry.shinyBlueFontPNG, 16, 16, FlxBitmapFont.TEXT_SET10 + ")!(", 20, 0, 0);
			//font = new FlxBitmapFont(AssetsRegistry.tskFontPNG, 32, 24, FlxBitmapFont.TEXT_SET10 + "!?().:-,'0123456789", 10, 0, 1);
			font = new FlxBitmapFont(AssetsRegistry.metalFontPNG, 46, 48, FlxBitmapFont.TEXT_SET10 + "0123456789?!().,", 6, 2, 2);
			//font = new FlxBitmapFont(knightHawksFontPNG, 31, 25, FlxBitmapFont.TEXT_SET6, 10, 1, 1);
			
			font.setText("flixel\npower\ntools", true, 1, 4, FlxBitmapFont.ALIGN_CENTER);
			FlxDisplay.screenCenter(font);
			font.y = 48;
			
			add(canvas);
			add(font);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
		}
		
	}

}