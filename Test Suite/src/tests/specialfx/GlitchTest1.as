package tests.specialfx 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FX.GlitchFX;
	import tests.TestsHeader;

	public class GlitchTest1 extends FlxState
	{
		//	Common variables
		public static var title:String = "GlitchFX 1";
		public static var description:String = "Glitch FX Plugin";
		private var instructions:String = "Click to start the drop down effect";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var glitch:GlitchFX;
		private var soPretty:FlxSprite;
		
		public function GlitchTest1() 
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
			
			var pic:FlxSprite = new FlxSprite(32, 48, AssetsRegistry.overdoseEyePNG);
			
			glitch = FlxSpecialFX.glitch();
			
			soPretty = glitch.createFromFlxSprite(pic, 4, 4);
			
			glitch.start(4);
			
			add(soPretty);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function destroy():void
		{
			//	Important! Clear out the plugin, otherwise resources will get messed right up after a while
			FlxSpecialFX.clear();
			
			super.destroy();
		}
		
	}

}