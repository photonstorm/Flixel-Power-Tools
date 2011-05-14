package tests.controls 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import flash.utils.getTimer;
	import tests.TestsHeader;

	public class ControlTest3 extends FlxState
	{
		//	Common variables
		public static var title:String = "Controls 3";
		public static var description:String = "2 Player (on same keyboard) demo";
		private var instructions:String = "Red uses WASD. Green uses IJKL.";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var player1:FlxSprite;
		private var player2:FlxSprite;
		
		private var controls1:FlxControls;
		private var controls2:FlxControls;
		
		private var scene:ControlTestScene1;
		
		public function ControlTest3() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific

			player1 = new FlxSprite(64, 150).makeGraphic(16, 16, 0xffFF0000);
			player2 = new FlxSprite(240, 150).makeGraphic(16, 16, 0xff00ff00);
			
			//	Control the players
			
			controls1 = new FlxControls(player1, FlxControls.MOVEMENT_INSTANT, FlxControls.STOPPING_INSTANT, false, false);
			controls1.setMovementSpeed(100, 100, 100, 100);
			controls1.enableWASDControl();
			
			controls2 = new FlxControls(player2, FlxControls.MOVEMENT_INSTANT, FlxControls.STOPPING_INSTANT, false, false);
			controls2.setMovementSpeed(100, 100, 100, 100);
			controls2.enableIJKLControl();
			
			//	A scene for our players to fly around
			scene = new ControlTestScene1;
			
			//	Bring up the Flixel debugger if you'd like to watch these values in real-time
			//FlxG.watch(player.velocity, "x", "vx");
			//FlxG.watch(player.velocity, "y", "vy");
			
			add(scene);
			add(player1);
			add(player2);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.collide(player1, scene);
			FlxG.collide(player2, scene);
			
			//	You need to call this in your update() function, as it won't be called directly for you (yet :)
			controls1.update();
			controls2.update();
		}
		
	}

}