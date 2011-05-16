package tests.controls 
{
	import org.flixel.*;

	public class ControlTestScene1 extends FlxGroup
	{
		private var floor:FlxTileblock;
		private var wallLeft:FlxTileblock;
		private var wallRight:FlxTileblock;
		private var platform1:FlxTileblock;
		private var platform2:FlxTileblock;
		private var platform3:FlxTileblock;
		private var platform4:FlxTileblock;
		
		public function ControlTestScene1() 
		{
			super(7);
			
			floor = new FlxTileblock(0, 200, 320, 16);
			floor.makeGraphic(320, 16, 0xaa689c16);
			
			wallLeft = new FlxTileblock(0, 30, 16, 170);
			wallLeft.makeGraphic(16, 170, 0xaa689c16);
			
			wallRight = new FlxTileblock(304, 30, 16, 170);
			wallRight.makeGraphic(16, 170, 0xaa689c16);
			
			platform1 = new FlxTileblock(100, 160, 128, 16);
			platform1.makeGraphic(128, 16, 0xaa689c16);
			
			platform2 = new FlxTileblock(64, 120, 96, 16);
			platform2.makeGraphic(96, 16, 0xaa689c16);
			
			platform3 = new FlxTileblock(16, 80, 16, 16);
			platform3.makeGraphic(16, 16, 0xaa689c16);
			
			platform4 = new FlxTileblock(120, 60, 16, 16);
			platform4.makeGraphic(16, 16, 0xaa689c16);
			
			add(floor);
			add(wallLeft);
			add(wallRight);
			add(platform1);
			add(platform2);
			add(platform3);
			add(platform4);
		}
		
	}

}