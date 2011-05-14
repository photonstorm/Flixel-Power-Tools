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
		private var controls:FlxControls;
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

			player = new FlxSprite(64, 150, AssetsRegistry.ufoPNG);
			
			//	Control the player
			
			//	Rigid movement
			controls = new FlxControls(player, FlxControls.MOVEMENT_INSTANT, FlxControls.STOPPING_INSTANT);
			controls.setMovementSpeed(100, 100, 100, 100);
			
			//	Slippy slidey
			//controls = new FlxControls(player, FlxControls.MOVEMENT_INSTANT, FlxControls.STOPPING_DECELERATES);
			//controls.setMovementSpeed(100, 100, 100, 100, 100, 100);
			
			//	A scene for our ufo to fly around
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
			
			//	You need to call this in your update() function, as it won't be called directly for you (yet :)
			controls.update();
		}
		
	}

}