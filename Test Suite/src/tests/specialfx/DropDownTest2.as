package tests.specialfx 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FX.DropDownFX;
	import tests.TestsHeader;

	public class DropDownTest2 extends FlxState
	{
		//	Common variables
		public static var title:String = "DropDown 2";
		public static var description:String = "DropDown FX - Stretched image";
		private var instructions:String = "Click to start the drop down effect";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var dropdown:DropDownFX;
		private var soPretty:FlxSprite;
		
		public function DropDownTest2() 
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
			
			var pic:FlxSprite = new FlxSprite(0, 0, AssetsRegistry.overdoseEyePNG);
			
			dropdown = FlxSpecialFX.dropDown();
			
			//	We're adding 100px to the height, so the image appears to drop even further down
			soPretty = dropdown.create(pic, 0, 0, pic.width, 232);

			FlxDisplay.screenCenter(soPretty, true, false);
			
			add(soPretty);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.mouse.justReleased())
			{
				dropdown.start(1);
			}
		}
		
		override public function destroy():void
		{
			//	Important! Clear out the plugin, otherwise resources will get messed right up after a while
			FlxSpecialFX.clear();
			
			super.destroy();
		}
		
	}

}