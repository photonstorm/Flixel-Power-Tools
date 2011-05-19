package tests.extendedsprite 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import tests.TestsHeader;

	public class ExtendedSpriteTest1 extends FlxState
	{
		//	Common variables
		public static var title:String = "ExtSprite 1";
		public static var description:String = "Extended FlxSprite";
		private var instructions:String = "Drag the sprites with the mouse";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var red:FlxExtendedSprite;
		private var green:FlxExtendedSprite;
		private var blue:FlxExtendedSprite;
		
		public function ExtendedSpriteTest1() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			
			//	You can drag the red ball from anywhere inside the bounding area (including the transparent edges)
			//	This is the fastest method of dragging (in terms of CPU) so use it if you can!
			red = new FlxExtendedSprite(32, 32, AssetsRegistry.redPNG);
			red.setMouseDrag();
			
			//	The green ball needs a pixel perfect drag, so the edges are not included
			green = new FlxExtendedSprite(96, 96, AssetsRegistry.greenPNG);
			green.setMouseDrag(true, true);
			
			//	The blue ball is pixel perfect as well, but this time the middle of the sprite snaps to the mouse coordinates
			blue = new FlxExtendedSprite(128, 128, AssetsRegistry.bluePNG);
			blue.setMouseDrag(false, true);
						
			add(blue);
			add(red);
			add(green);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
		}
		
	}

}