package tests 
{
	//import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class FlxScrollZoneTest3 extends FlxState
	{
		//	Common variables
		public static var title:String = "ScrollZone 3";
		public static var description:String = "Updates the scroll values in real-time";
		private var instructions:String = "Updating the scroll values in real-time";
		private var header:TestsHeader;
		
		//	Test specific variables
		[Embed(source = '../../assets/agent-t-buggin-acf_logo.png')] private var acfPNG:Class;
		
		private var pic:FlxSprite;
		private var ot:int = 0;
		private var ang:Number = 0;
		
		public function FlxScrollZoneTest3() 
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
			
			//	Create a sprite from a 320x200 PNG (drawn by a friend of mine, Havoc, in just 16-colours on an Atari ST)
			pic = new FlxSprite(0, 24, acfPNG);
			
			FlxScrollZone.add(pic, new Rectangle(0, 0, 320, 200), 0, 0);
			
			add(pic);
		}
		
		override public function update():void
		{
			super.update();
			
			//	Just applies a sin/cos wave to the scrolling
			var os:Number = FlxG.elapsed * 20;
			ang += 0.1 * os;
				
			FlxScrollZone.updateX(pic, Math.sin(ang) * os * 20);
			FlxScrollZone.updateY(pic, Math.cos(ang) * os * 10);
		}
		
		override public function destroy():void
		{
			//	Important! Clear out the scrolling image from the plugin, otherwise resources will get messed right up after a while
			FlxScrollZone.clear();
			
			super.destroy();
		}
		
	}

}