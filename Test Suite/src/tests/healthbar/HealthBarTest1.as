package tests.healthbar 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import tests.TestsHeader;

	public class HealthBarTest1 extends FlxState
	{
		//	Common variables
		public static var title:String = "HealthBar 1";
		public static var description:String = "The 3 different types of health bar displayed";
		private var instructions:String = "Click the mouse to randomise the health values";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var red:FlxSprite;
		private var green:FlxSprite;
		private var blue:FlxSprite;
		
		private var redHealth:FlxBar;
		//private var greenHealth:FlxHealthBar;
		//private var blueHealth:FlxHealthBar;
		
		public function HealthBarTest1() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			
			//	Activate the plugin
			if (FlxG.getPlugin(FlxBarManager) == null)
			{
				FlxG.addPlugin(new FlxBarManager);
			}
			
			red = new FlxSprite(64, 120, AssetsRegistry.redPNG);
			green = new FlxSprite(64, 64, AssetsRegistry.greenPNG);
			blue = new FlxSprite(64, 180, AssetsRegistry.bluePNG);
			
			red.health = FlxMath.rand(10, 90);
			green.health = FlxMath.rand(10, 90);
			blue.health = FlxMath.rand(10, 90);
			
			
			
			redHealth = FlxBarManager.create();
			
			//redHealth.create(16, 100, FlxBar.FILL_VERTICAL_OUTSIDE_IN);
			redHealth.create(100, 8, FlxBar.FILL_LEFT_TO_RIGHT, 0, 100, red, "health");
			redHealth.trackParent(0, -5);
			
			
			//redHealth.create(50, 16, FlxBar.FILL_TOP_TO_BOTTOM, 0, 100);
			//redHealth.create(16, 50, FlxBar.FILL_LEFT_TO_RIGHT, 0, 100);
			//redHealth.percent = 32;
			
			redHealth.sprite.x = 32;
			redHealth.sprite.y = 32;
			
			/*
			
			//	The default health bar
			redHealth = new FlxHealthBar(red, 32, 4, 0, 100);
			//	This tells it to track the x/y position of the red FlxSprite, but offset by the values given
			redHealth.trackParent(0, -5);
			
			//	A gradient filled health bar, this time bigger in size with a border, and tracking the green FlxSprite
			greenHealth = new FlxHealthBar(green, 64, 10, 0, 100, true);
			greenHealth.createGradientBar([0xff800000, 0xffFF0000], [0xff00FF00, 0xffFFFFFF], 1, 0, true, 0xff000000);
			greenHealth.trackParent(0, -14);
			
			//	An image based health bar
			blueHealth = new FlxHealthBar(blue, 100, 10, 0, 100);
			blueHealth.createImageBar(null, AssetsRegistry.healthBarPNG, 0xaa000000);
			//	The blue health bar is in a fixed position (it doesn't follow the blue sprite around)
			blueHealth.x = 64;
			blueHealth.y = 100;
			*/
			
			
			
			add(red);
			add(green);
			add(blue);
			
			add(redHealth.sprite);
			//add(greenHealth);
			//add(blueHealth);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
			
			red.x = FlxG.mouse.screenX;
			red.y = FlxG.mouse.screenY;
		}
		
		override public function draw():void
		{
			super.draw();
			
			//red.x = FlxG.mouse.screenX;
			//red.y = FlxG.mouse.screenY;
			
			if (FlxG.mouse.justReleased())
			{
				var r:uint = FlxMath.rand(0, 100);
				
				//redHealth.percent = r;
				
				header.instructions.text = r.toString() + "%";
				
				red.health = r;
				green.health = FlxMath.rand(0, 100);
				blue.health = FlxMath.rand(0, 100);
			}
			
			//	If you notice a slight lag/delay in the health bar following the sprite then
			//	it's because you've called super.update() at the START of your update function.
			//	Leave it until the end and it'll run smoothly.
		}
		
		override public function destroy():void
		{
			//	Important! Clear out the plugin otherwise it'll crash when changing state
			
			super.destroy();
		}
		
	}

}