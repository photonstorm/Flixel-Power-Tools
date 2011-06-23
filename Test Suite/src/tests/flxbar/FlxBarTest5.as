package tests.flxbar 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import tests.TestsHeader;

	public class FlxBarTest5 extends FlxState
	{
		//	Common variables
		public static var title:String = "FlxBar 5";
		public static var description:String = "Changing the range of an FlxBar";
		private var instructions:String = "Changing the range of an FlxBar";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var bar:FlxBar;
		private var currentLevel:uint;
		private var level:FlxText;
		private var levelUp:FlxButton;
		
		public function FlxBarTest5() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			
			currentLevel = 1;
			
			bar = new FlxBar(16, 32, FlxBar.FILL_LEFT_TO_RIGHT, 100, 10);
			bar.setRange(0, 10);
			bar.percent = 50;
			
			levelUp = new FlxButton(16, 64, "Level Up", increaseLevel);
			
			level = new FlxText(16, 96, 200, "Level 1 " + " px " + bar.pxPerPercent);
			
			add(bar);
			add(levelUp);
			add(level);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		private function increaseLevel():void
		{
			currentLevel++;
			
			level.text = "Level " + currentLevel + " px " + bar.pxPerPercent;
			
			switch (currentLevel)
			{
				case 2:
					bar.setRange(10, 100);
					//bar.percent = 50;
					break;
					
				case 3:
					bar.setRange(100, 200);
					//bar.percent = 50;
					break;
			}
			
		}
		
	}

}