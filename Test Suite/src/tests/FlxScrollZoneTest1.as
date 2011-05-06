package tests 
{
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class FlxScrollZoneTest1 extends FlxState
	{
		//	Common variables
		public static var title:String = "ScrollZone 1";
		public static var description:String = "Scrolls a whole FlxSprite horizontally";
		private var instructions:String = "Scrolls a whole FlxSprite horizontally";
		private var header:TestsHeader;
		
		//	Test specific variables
		[Embed(source = '../../assets/spaz-oh_crikey-komische_sackratten_von_der_hohle.png')] private var spazPNG:Class;
		
		private var pic:FlxSprite;
		
		public function FlxScrollZoneTest1() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			
			//	If the FlxScrollZone Plugin isn't already in use, we add it here
			if (FlxG.getPlugin(FlxScrollZone) == null)
			{
				FlxG.addPlugin(new FlxScrollZone);
			}
			
			//	Create a sprite from a 320x200 PNG
			pic = new FlxSprite(0, 24, spazPNG);
			
			//	This will scroll the whole image to the left by 2 pixels every frame
			FlxScrollZone.add(pic, new Rectangle(0, 0, pic.width, pic.height), -2, 0);
			
			add(pic);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function destroy():void
		{
			//	Important! Clear out the scrolling image from the plugin, otherwise resources will get messed right up after a while
			FlxScrollZone.clear();
			
			super.destroy();
		}
		
	}

}