package tests.controls 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import flash.utils.getTimer;
	import tests.TestsHeader;

	public class ControlTest1 extends FlxState
	{
		//	Common variables
		public static var title:String = "Controls 1";
		public static var description:String = "";
		private var instructions:String = "move";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var controls:FlxControlHandler;
		private var player:FlxSprite;
		private var scene:ControlTestScene1;
		
		public function ControlTest1() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			
			//	Enable the plugin - you only need do this once (unless you destroy the plugin)
			if (FlxG.getPlugin(FlxControl) == null)
			{
				FlxG.addPlugin(new FlxControl);
			}

			player = new FlxSprite(64, 150, AssetsRegistry.ufoPNG);
			
			//	Control the player
			
			//	Rigid movement
			
			//	You can either set-up the controls like this ...
			FlxControl.create(player, FlxControlHandler.MOVEMENT_INSTANT, FlxControlHandler.STOPPING_INSTANT);
			FlxControl.player1.setMovementSpeed(100, 100, 100, 100);
			
			//	Or like this... both do the same thing, but this method is maybe more useful if you need fine-grained control over the returned ControlHandler
			//	or don't like the look of the method above (would rather assign to a local var)
			
			//controls = FlxControl.create(player, FlxControlHandler.MOVEMENT_INSTANT, FlxControlHandler.STOPPING_INSTANT);
			//controls.setMovementSpeed(100, 100, 100, 100);
			
			//	Slippy slidey
			//controls = new FlxControls(player, FlxControls.MOVEMENT_INSTANT, FlxControls.STOPPING_DECELERATES);
			//controls.setMovementSpeed(100, 100, 100, 100, 100, 100);
			
			//	A basic scene for our ufo to fly around
			scene = new ControlTestScene1;
			
			//	Bring up the Flixel debugger if you'd like to watch these values in real-time
			FlxG.watch(player.velocity, "x", "vx");
			FlxG.watch(player.velocity, "y", "vy");
			
			add(scene);
			add(player);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.collide(player, scene);
		}
		
	}

}