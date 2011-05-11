package tests.starfield 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import tests.TestsHeader;

	public class StarFieldTest1 extends FlxState
	{
		//	Common variables
		public static var title:String = "StarField 1";
		public static var description:String = "Example of the default 2D Star field";
		private var instructions:String = "2D Star field. Click to randomise direction.";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var stars:FlxStarField;
		
		public function StarFieldTest1() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			stars = new FlxStarField(0, 32, 320, 176, 256);
			
			add(stars);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.mouse.justPressed())
			{
				stars.setStarSpeed(FlxMath.randFloat(-1, 1), FlxMath.randFloat(-1, 1));
			}
		}
		
	}

}