package tests.controls 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
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
		private var floor:FlxTileblock;
		private var wallLeft:FlxTileblock;
		private var wallRight:FlxTileblock;
		private var platform1:FlxTileblock;
		private var platform2:FlxTileblock;
		
		public function ControlTest1() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific

			if (FlxG.getPlugin(FlxControls) == null)
			{
				FlxG.addPlugin(new FlxControls);
			}
			
			player = new FlxSprite(64, 150);
			player.loadGraphic(AssetsRegistry.chickPNG, true, true, 16, 18, true);
			
			//	The sprite is 16x18 in size, but that includes a little feather of hair on its head which we don't want to include in collision checks.
			//	We also shave 2 pixels off each side to make it slip through gaps easier. Changing the width/height does NOT change the visual sprite, just the bounding box used for physics.
			player.width = 12;
			player.height = 16;
			
			//	Because we've shaved a few pixels off, we need to offset the sprite to compensate
			player.offset.x = 2;
			player.offset.y = 2;
			
			//	The Animation sequences we need
			player.addAnimation("idle", [0], 0, false);
			player.addAnimation("walk", [0, 1, 0, 2], 10, true);
			player.addAnimation("jump", [1], 0, false);
			player.addAnimation("hurt", [4], 0, false);
			
			//	By defaylt the sprite is facing to the right.
			//	Changing this tells Flixel to flip the sprite frames to show the left-facing ones instead.
			player.facing = FlxObject.RIGHT;
			
			//	This creates a little scene for our player to run around
			floor = new FlxTileblock(0, 200, 320, 16);
			floor.makeGraphic(320, 16, 0xaa689c16);
			
			wallLeft = new FlxTileblock(0, 30, 16, 170);
			wallLeft.makeGraphic(16, 170, 0xaa689c16);
			
			wallRight = new FlxTileblock(304, 30, 16, 170);
			wallRight.makeGraphic(16, 170, 0xaa689c16);
			
			platform1 = new FlxTileblock(100, 160, 128, 16);
			platform1.makeGraphic(128, 16, 0xaa689c16);
			
			platform2 = new FlxTileblock(64, 100, 96, 16);
			platform2.makeGraphic(96, 16, 0xaa689c16);
			
			//	Control the sprite
			controls = new FlxControls();
			controls.basicCursorControl(player, 400, 0);
			
			add(floor);
			add(wallLeft);
			add(wallRight);
			add(platform1);
			add(platform2);
			add(player);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
		}
		
	}

}