package tests 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class FlxScrollingTextTest2 extends FlxState
	{
		//	Common variables
		public static var title:String = "Text Scroller 2";
		public static var description:String = "Multiple Scrolling Bitmap Texts!";
		private var instructions:String = "Click to toggle scrolling";
		private var header:TestsHeader;
		
		//	Test specific variables
		[Embed(source = '../../assets/fonts/070.png')] private var godsPNG:Class;
		[Embed(source = '../../assets/fonts/072.png')] private var tinyPNG:Class;
		
		private var canvas:FlxSprite;
		private var stars:FlxStarField;
		
		private var font:FlxBitmapFont;
	
		private var scroller1:FlxSprite;
		private var scroller2:FlxSprite;
		private var scroller3:FlxSprite;
		private var scroller4:FlxSprite;
		private var scroller5:FlxSprite;
		private var scroller6:FlxSprite;
		private var scroller7:FlxSprite;
		private var scroller8:FlxSprite;
		private var scroller9:FlxSprite;
		private var scroller10:FlxSprite;
		private var scroller11:FlxSprite;
		
		public function FlxScrollingTextTest2() 
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
			
			//	Our font - it's a lovely golden 16x16 font set from the Bitmap Brothers game Gods on the Atari ST
			font = new FlxBitmapFont(godsPNG, 16, 16, FlxBitmapFont.TEXT_SET10 + ".:0123456789<*>", 20);
			
			//	Just another font to try it with. This one is only 7x8 in size. Uncomment the line below (and comment-out the font line above to test)
			//font = new FlxBitmapFont(tinyPNG, 7, 8, FlxBitmapFont.TEXT_SET10 + ":/.!',-701234 6", 21, 1, 1);
			
			var diff:uint = 16;
			
			var s:String = "<<< WELCOME TO THE SCROLLING TEXT DEMO! >>>     ";
			
			scroller1 = FlxScrollingText.add(font, new Rectangle(14, 36, 292, 16), 6, 0, s);
			
			scroller2 = FlxScrollingText.add(font, new Rectangle(14, 64, 292, 16), 5, 0, s);
			scroller2.y = scroller1.y + diff;
			
			scroller3 = FlxScrollingText.add(font, new Rectangle(14, 64, 292, 16), 4, 0, s);
			scroller3.y = scroller2.y + diff;
			
			scroller4 = FlxScrollingText.add(font, new Rectangle(14, 64, 292, 16), 3, 0, s);
			scroller4.y = scroller3.y + diff;
			
			scroller5 = FlxScrollingText.add(font, new Rectangle(14, 64, 292, 16), 2, 0, s);
			scroller5.y = scroller4.y + diff;
			
			scroller6 = FlxScrollingText.add(font, new Rectangle(14, 64, 292, 16), 1, 0, s);
			scroller6.y = scroller5.y + diff;
			
			scroller7 = FlxScrollingText.add(font, new Rectangle(14, 64, 292, 16), 2, 0, s);
			scroller7.y = scroller6.y + diff;
			
			scroller8 = FlxScrollingText.add(font, new Rectangle(14, 64, 292, 16), 3, 0, s);
			scroller8.y = scroller7.y + diff;
			
			scroller9 = FlxScrollingText.add(font, new Rectangle(14, 64, 292, 16), 4, 0, s);
			scroller9.y = scroller8.y + diff;
			
			scroller10 = FlxScrollingText.add(font, new Rectangle(14, 64, 292, 16), 5, 0, s);
			scroller10.y = scroller9.y + diff;
			
			scroller11 = FlxScrollingText.add(font, new Rectangle(14, 64, 292, 16), 6, 0, s);
			scroller11.y = scroller10.y + diff;
			
			//	Just something pretty to look at from here down
			canvas = new FlxSprite(14, 32).makeGraphic(292, 186, 0xff000000, true);
			canvas.drawLine(0, 0, canvas.width, 0, 0xffffffff);
			canvas.drawLine(0, canvas.height - 1, canvas.width, canvas.height - 1, 0xffffffff);
			
			stars = new FlxStarField(14, 33, 292, 174, 90);
			stars.setBackgroundColor(0x00);
			
			add(canvas);
			add(stars);
			
			add(scroller1);
			add(scroller2);
			add(scroller3);
			add(scroller4);
			add(scroller5);
			add(scroller6);
			add(scroller7);
			add(scroller8);
			add(scroller9);
			add(scroller10);
			add(scroller11);
		}
		
		override public function update():void
		{
			super.update();
			
			//	Mouse clicked?
			if (FlxG.mouse.justReleased())
			{
				if (FlxScrollingText.isScrolling(scroller1))
				{
					//	We don't pass a specific scroller here, so it stops all of them
					FlxScrollingText.stopScrolling();
				}
				else
				{
					//	We don't pass a specific scroller here, so it stops all of them
					FlxScrollingText.startScrolling();
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