package tests.starfield 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import tests.TestsHeader;

	public class StarFieldTest2 extends FlxState
	{
		//	Common variables
		public static var title:String = "StarField 2";
		public static var description:String = "Example of the 3D StarField";
		private var instructions:String = "Click to enable mouse follow";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var stars:FlxStarField;
		private var followingMouse:Boolean = false;
		
		public function StarFieldTest2() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			stars = new FlxStarField(0, 32, 320, 176, 256, 2);
			
			add(stars);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.mouse.justPressed())
			{
				followingMouse ? followingMouse = false : followingMouse = true;
			}
			
			if (followingMouse)
			{
				stars.centerX = FlxG.mouse.screenX - stars.x;
				stars.centerY = FlxG.mouse.screenY - stars.y;
			}
			
		}
		
	}

}