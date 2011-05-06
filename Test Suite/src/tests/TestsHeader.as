package tests 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class TestsHeader extends FlxGroup
	{
		[Embed(source = '../../assets/flixel_power_tools_logo.png')] private var logoPNG:Class;
		[Embed(source = '../../assets/back_button_up.png')] private var backUpPNG:Class;
		[Embed(source = '../../assets/back_button_down.png')] private var backDownPNG:Class;
		
		private var logo:FlxSprite;
		private var backButton:FlxButtonPlus;
		public var instructions:FlxText;
		
		public function TestsHeader(text:String, showButton:Boolean = true) 
		{
			super();
			
			logo = new FlxSprite(0, 3, logoPNG);
			logo.x = FlxG.width / 2 - logo.width / 2;
			logo.scrollFactor.x = 0;
			logo.scrollFactor.y = 0;
			
			var background:FlxSprite = FlxGradient.createGradientFlxSprite(320, 240, [0xff004080, 0xff3C3CFF], 10);
			FlxGridOverlay.overlay(background, 16, 16, 320, 240, false, true, 0x44e7e6e6, 0x44d9d5d5);
			background.scrollFactor.x = 0;
			background.scrollFactor.y = 0;
			
			instructions = new FlxText(0, FlxG.height - 16, 320, text);
			instructions.alignment = "center";
			instructions.shadow = 0x000001;
			instructions.scrollFactor.x = 0;
			instructions.scrollFactor.y = 0;
			
			add(background);
			add(logo);
			add(instructions);
			
			//	So we can take screen shots of any of the test suites
			if (FlxG.getPlugin(FlxScreenGrab) == null)
			{
				FlxG.addPlugin(new FlxScreenGrab);
			}
			
			//	Define our hotkey (string value taken from FlxG.keys) the parameters simply say "save it right away" and "hide the mouse first"
			FlxScreenGrab.defineHotKey("F1", true, true);
			
			if (showButton)
			{
				backButton = new FlxButtonPlus(303, 2, backToMenu);
				
				var buttonUp:FlxSprite = new FlxSprite(0, 0, backUpPNG);
				var buttonDown:FlxSprite = new FlxSprite(0, 0, backDownPNG);
				
				backButton.loadGraphic(buttonUp, buttonDown);
			
				add(backButton);
			}
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.justReleased("ESCAPE"))
			{
				backToMenu();
			}
		}
		
		private function backToMenu():void
		{
			if (FlxFlod.isPlaying)
			{
				FlxFlod.stopMod();
			}
			
			FlxG.switchState(new TestSuiteState);
		}
		
	}

}