package tests.scrollzone 
{
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import tests.TestsHeader;

	public class ScrollZoneTest4 extends FlxState
	{
		//	Common variables
		public static var title:String = "ScrollZone 4";
		public static var description:String = "Multi parallax scroll demo";
		private var instructions:String = "Multi parallax scroll demo";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var pic:FlxSprite;
		
		public function ScrollZoneTest4() 
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
			pic = new FlxSprite(0, 32, AssetsRegistry.tcbPNG);
			
			var y:int = 5;
			var speed:Number = 6;
			
			FlxScrollZone.add(pic, new Rectangle(0, 0, pic.width, 5), speed, 0);
				
			speed -= 0.3;
			
			//	The image consists of 5px high scrolling layers, this creates them quickly (top = fastest, getting slower as we move down)
			for (var z:int = 0; z < 31; z++)
			{
				FlxScrollZone.createZone(pic, new Rectangle(0, y, pic.width, 5), speed, 0);
				
				if (z <= 14)
				{
					speed -= 0.3;
				}
				else
				{
					speed += 0.3;
				}
					
				if (z == 14)
				{
					y = 120;
					speed += 0.3;
				}
				else
				{
					y += 5;
				}
			}
			
			add(pic);
			
			//	Header overlay
			add(header.overlay);
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