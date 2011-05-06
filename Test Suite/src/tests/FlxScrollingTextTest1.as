package tests 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	
	public class FlxScrollingTextTest1 extends FlxState
	{
		//	Common variables
		public static var title:String = "Text Scroller 1";
		public static var description:String = "Using Scrolling Bitmap Text in your games";
		private var instructions:String = "Click to toggle scrolling";
		private var header:TestsHeader;
		
		//	Test specific variables
		[Embed(source = '../../assets/fonts/bluepink_font.png')] private var bluepinkFontPNG:Class;
		
		private var canvas:FlxSprite;
		private var stars:FlxStarField;
		
		private var font:FlxBitmapFont;
		private var scroller:FlxSprite;
		
		public function FlxScrollingTextTest1() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			
			//	If the FlxScrollingText Plugin isn't already in use, we add it here
			if (FlxG.getPlugin(FlxScrollingText) == null)
			{
				FlxG.addPlugin(new FlxScrollingText);
			}
			
			//	Create an FlxBitmapFont in the usual way
			font = new FlxBitmapFont(bluepinkFontPNG, 32, 32, FlxBitmapFont.TEXT_SET2, 10);
			
			//	Then create a scrolling text using it - this is just an FlxSprite, you can move it around, collide with it, all the things you can do with a sprite
			scroller = FlxScrollingText.add(font, new Rectangle(14, 40, 292, 32), 1, 0, "WELCOME!   ");
			
			FlxScrollingText.addText(scroller, "THIS IS AN EXAMPLE OF SROLLING BITMAP FONTS IN FLIXEL  ");
			FlxScrollingText.addText(scroller, "NICE AND EASY TO SET-UP, NICE AND EASY TO USE :)       ");
			FlxScrollingText.addText(scroller, "OK IT IS TIME TO WRAP ..............................   ");
			FlxScrollingText.addText(scroller, ":)                   ");
			
			//	Just moves it around, comment out if you don't have greensock.swc linked in (i.e. aren't on FlashDevelop)
			TweenMax.to(scroller, 2, { y: 170, yoyo: true, repeat: -1, ease: Sine.easeInOut } );
			
			//	Just something pretty to look at from here down
			canvas = new FlxSprite(14, 32).makeGraphic(292, 176, 0xff000000, true);
			canvas.drawLine(0, 0, canvas.width, 0, 0xffffffff);
			canvas.drawLine(0, canvas.height - 1, canvas.width, canvas.height - 1, 0xffffffff);
			
			stars = new FlxStarField(14, 33, 292, 174, 90);
			stars.setBackgroundColor(0x00);
			
			add(canvas);
			add(stars);
			add(scroller);
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.mouse.justReleased())
			{
				if (FlxScrollingText.isScrolling(scroller))
				{
					FlxScrollingText.stopScrolling(scroller);
				}
				else
				{
					FlxScrollingText.startScrolling(scroller);
				}
			}
		}
		
		override public function destroy():void
		{
			//	Important! Clear out the plugin otherwise it'll crash when changing state
			FlxScrollingText.clear();
			
			super.destroy();
		}
		
	}

}