package tests.specialfx 
{
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FX.SineWaveFX;
	import tests.TestsHeader;

	public class SineWaveTest1 extends FlxState
	{
		//	Common variables
		public static var title:String = "SineWave 1";
		public static var description:String = "SineWave FX Plugin";
		private var instructions:String = "The standard sine-wave effect";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var sinewave:SineWaveFX;
		private var soPretty:FlxSprite;
		private var font:FlxBitmapFont;
		private var scroller:FlxSprite;
		
		public function SineWaveTest1() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			if (FlxG.getPlugin(FlxSpecialFX) == null)
			{
				FlxG.addPlugin(new FlxSpecialFX);
			}
			
			if (FlxG.getPlugin(FlxScrollingText) == null)
			{
				FlxG.addPlugin(new FlxScrollingText);
			}
			
			//	Create an FlxBitmapFont in the usual way
			font = new FlxBitmapFont(AssetsRegistry.bluepinkFontPNG, 32, 32, FlxBitmapFont.TEXT_SET2, 10);
			
			//	Then create a scrolling text using it - this is just an FlxSprite, you can move it around, collide with it, all the things you can do with a sprite
			scroller = FlxScrollingText.add(font, new Rectangle(14, 40, 292, 32), 2, 0, "WELCOME!   ");
			
			FlxScrollingText.addText(scroller, "THIS IS AN EXAMPLE OF SCROLLING BITMAP FONTS IN FLIXEL ");
			FlxScrollingText.addText(scroller, "NICE AND EASY TO SET-UP, NICE AND EASY TO USE :)       ");
			FlxScrollingText.addText(scroller, "OK IT IS TIME TO WRAP ..............................   ");
			FlxScrollingText.addText(scroller, ":)                   ");
			
			var pic:FlxSprite = new FlxSprite(0, 32, AssetsRegistry.overdoseEyePNG);
			FlxDisplay.screenCenter(pic);
			
			sinewave = FlxSpecialFX.sineWave();
			
			soPretty = sinewave.createFromFlxSprite(pic, SineWaveFX.WAVETYPE_SINE, 32);
			
			//soPretty = sinewave.create(pic, 0, 32, pic.width, pic.height);
			//soPretty = sinewave.create(pic, 0, 0, 320, 256);
			//soPretty = sinewave.create(pic, 0, 0, 320, 256);
			
			//soPretty.y = 32;
			
			sinewave.start(0);
			
			add(soPretty);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
			
			//sinewave.image = scroller.pixels;
			//header.instructions.text = sinewave.f.toString();
		}
		
		override public function destroy():void
		{
			//	Important! Clear out the plugin, otherwise resources will get messed right up after a while
			FlxSpecialFX.clear();
			
			super.destroy();
		}
		
	}

}