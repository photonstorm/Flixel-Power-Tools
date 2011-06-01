package tests.flxbar 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import tests.TestsHeader;

	public class FlxBarTest2 extends FlxState
	{
		//	Common variables
		public static var title:String = "FlxBar 2";
		public static var description:String = "Demonstrates the 6 ways to fill the bars";
		private var instructions:String = "Each bar uses a different fill method";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var healthBar1:FlxBar;
		private var healthBar2:FlxBar;
		private var healthBar3:FlxBar;
		private var healthBar4:FlxBar;
		
		private var healthBar5:FlxBar;
		
		private var v:int;
		private var vDirection:int = 0;
		
		public function FlxBarTest2() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			
			v = 0;
			
			//	We don't need to set the width/height of the bar itself as the createImageBar will set it
			
			healthBar1 = new FlxBar(16, 32, FlxBar.FILL_LEFT_TO_RIGHT);
			healthBar1.createImageBar(null, AssetsRegistry.healthBarPNG, 0xaa000000);
			
			healthBar2 = new FlxBar(16, 48, FlxBar.FILL_RIGHT_TO_LEFT);
			healthBar2.createImageBar(null, AssetsRegistry.healthBarPNG, 0xaa000000);
			
			healthBar3 = new FlxBar(16, 64, FlxBar.FILL_HORIZONTAL_INSIDE_OUT);
			healthBar3.createImageBar(null, AssetsRegistry.healthBarPNG, 0xaa000000);
			
			healthBar4 = new FlxBar(16, 80, FlxBar.FILL_HORIZONTAL_OUTSIDE_IN);
			healthBar4.createImageBar(null, AssetsRegistry.healthBarPNG, 0xaa000000);
			
			healthBar5 = new FlxBar(150, 80, FlxBar.FILL_TOP_TO_BOTTOM);
			healthBar5.createImageBar(null, AssetsRegistry.flectrumPNG, 0xaa000000);
			
			add(healthBar1);
			add(healthBar2);
			add(healthBar3);
			add(healthBar4);
			add(healthBar5);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
			
			//	This just cycles the health value up and down, so the bars animate
			if (vDirection == 0)
			{
				v++;
				
				if (v > 100)
				{
					vDirection = 1;
				}
			}
			else
			{
				v--;
				
				if (v <= 0)
				{
					vDirection = 0;
				}
			}
			
			//	If a FlxBar isn't tied to a sprite you can set the value of it directly via percentage
			healthBar1.percent = v;
			healthBar2.percent = v;
			healthBar3.percent = v;
			healthBar4.percent = v;
			healthBar5.percent = v;
		}
		
	}

}