package tests.controls 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import tests.TestsHeader;

	public class ControlTest4 extends FlxState
	{
		//	Common variables
		public static var title:String = "Controls 4";
		public static var description:String = "Invaders sample";
		private var instructions:String = "LEFT / RIGHT to Move. Space to Fire.";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var controls:FlxControlHandler;
		private var player:FlxSprite;
		
		public function ControlTest4() 
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

			player = new FlxSprite(160, 200, AssetsRegistry.invaderPNG);
			
			//	Control the player
			
			//	Limited rigid movement
			FlxControl.create(player, FlxControlHandler.MOVEMENT_INSTANT, FlxControlHandler.STOPPING_INSTANT, 1, false, false);
			
			FlxControl.player1.setMovementSpeed(200, 0, 200, 0);
			
			FlxControl.player1.setCursorControl(false, false, true, true);
			
			FlxControl.player1.setFireButton("SPACE", 1000, fire);
			
			FlxControl.player1.setBounds(16, 200, 280, 16);
			
			
			//	Bring up the Flixel debugger if you'd like to watch these values in real-time
			FlxG.watch(player.velocity, "x", "vx");
			FlxG.watch(player.velocity, "y", "vy");
			
			add(player);
			
			//	Header overlay
			add(header.overlay);
		}
		
		private function fire():void
		{
			trace("bang");
		}
		
		override public function update():void
		{
			super.update();
		}
		
	}

}