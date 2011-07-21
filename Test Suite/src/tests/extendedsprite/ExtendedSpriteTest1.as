package tests.extendedsprite 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import tests.TestsHeader;

	public class ExtendedSpriteTest1 extends FlxState
	{
		//	Common variables
		public static var title:String = "Sprite Drag 1";
		public static var description:String = "Draggable Sprites";
		private var instructions:String = "Drag the sprites with the mouse";
		private var header:TestsHeader;
		
		//	Test specific variables
		
		private var tasty:FlxGroup;
		
		private var melon:FlxExtendedSprite;
		private var tomato:FlxExtendedSprite;
		private var onion:FlxExtendedSprite;
		private var mushroom:FlxExtendedSprite;
		private var eggplant:FlxExtendedSprite;
		private var carrot:FlxExtendedSprite;
		
		public function ExtendedSpriteTest1() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			
			//	Enable the plugin - you only need do this once (unless you destroy the plugin)
			if (FlxG.getPlugin(FlxMouseControl) == null)
			{
				FlxG.addPlugin(new FlxMouseControl);
			}
			
			tasty = new FlxGroup(6);
			
			//	You can drag the carrot from anywhere inside the bounding area (including the transparent edges)
			//	This is the fastest method of dragging (in terms of CPU) so use it if you can!
			carrot = new FlxExtendedSprite(32, 32, AssetsRegistry.carrotPNG);
			carrot.enableMouseDrag();
			
			//	The mushroom needs a pixel perfect drag, so the edges are not included
			mushroom = new FlxExtendedSprite(34, 34, AssetsRegistry.mushroomPNG);
			mushroom.enableMouseDrag(true, null, true);
			
			//	The melon is pixel perfect as well, but this time the middle of the sprite snaps to the mouse coordinates
			melon = new FlxExtendedSprite(128, 128, AssetsRegistry.melonPNG);
			melon.enableMouseDrag(false, null, true);
						
			tasty.add(carrot);
			tasty.add(mushroom);
			tasty.add(melon);
			
			add(tasty);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
			
			//	Sorts the balls on the Y axis (further down the screen = on the top)
			tasty.sort();
		}
		
	}

}