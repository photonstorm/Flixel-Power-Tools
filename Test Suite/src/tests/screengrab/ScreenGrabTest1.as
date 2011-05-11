package tests.screengrab 
{
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import tests.TestsHeader;

	public class ScreenGrabTest1 extends FlxState
	{
		//	Common variables
		public static var title:String = "ScreenGrab 1";
		public static var description:String = "Captures the screen to a PNG";
		private var instructions:String = "Press F1 to capture the screen and save to PNG";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var canvas:FlxSprite;
		private var pic:FlxSprite;
		private var stars:FlxStarField;
		private var balls:FlxEmitter;
		
		public function ScreenGrabTest1() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			
			//	If the FlxScreenGrab Plugin isn't already in use, we add it here
			if (FlxG.getPlugin(FlxScreenGrab) == null)
			{
				FlxG.addPlugin(new FlxScreenGrab);
			}
			
			//	Define our hotkey (string value taken from FlxG.keys) the parameters simply say "save it right away" and "hide the mouse first"
			FlxScreenGrab.defineHotKey("F1", true, true);
			
			//	From here on down it's just graphics and stuff to make the screen grab interesting ;)
			canvas = new FlxSprite(0, 28).makeGraphic(320, 190, 0xff000000, true);
			canvas.drawLine(0, 0, canvas.width, 0, 0xffffffff);
			canvas.drawLine(0, canvas.height - 1, canvas.width, canvas.height - 1, 0xffffffff);
			
			stars = new FlxStarField(0, canvas.y + 1, 320, canvas.height - 50, 90);
			stars.setBackgroundColor(0x00);
			
			pic = new FlxSprite(0, 0, AssetsRegistry.spazPNG);
			pic.y = (canvas.y + canvas.height) - pic.height - 1;
			
			balls = new FlxEmitter(160, 150);
			balls.gravity = -100;
			balls.minRotation = 0;
			balls.maxRotation = 0;
			balls.makeParticles(AssetsRegistry.ballsPNG, 30, 0, true, 0);
			balls.start(false);
			
			add(canvas);
			add(pic);
			add(stars);
			add(balls);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function destroy():void
		{
			super.destroy();
		}
		
	}

}