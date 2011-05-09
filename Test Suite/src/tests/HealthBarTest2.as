package tests 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class FlxHealthBarTest2 extends FlxState
	{
		//	Common variables
		public static var title:String = "HealthBar 2";
		public static var description:String = "Demonstrates the 3 ways to fill the health bars";
		private var instructions:String = "Each bar uses a different fill method.";
		private var header:TestsHeader;
		
		//	Test specific variables
		
		[Embed(source = '../../assets/healthbar.png')] private var healthBarPNG:Class;
		
		private var healthBar1:FlxHealthBar;
		private var healthBar2:FlxHealthBar;
		private var healthBar3:FlxHealthBar;
		
		private var red:FlxSprite;
		private var redDirection:int = 0;
		
		public function FlxHealthBarTest2() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			
			red = new FlxSprite;
			
			healthBar1 = new FlxHealthBar(red, 100, 10, 0, 100);
			healthBar1.createImageBar(null, healthBarPNG, 0xaa000000);
			healthBar1.setFillDirection(FlxHealthBar.FILL_LEFT_TO_RIGHT);
			FlxDisplay.screenCenter(healthBar1, true);
			healthBar1.y = 48;
			
			healthBar2 = new FlxHealthBar(red, 100, 10, 0, 100);
			healthBar2.createImageBar(null, healthBarPNG, 0xaa000000);
			healthBar2.setFillDirection(FlxHealthBar.FILL_RIGHT_TO_LEFT);
			FlxDisplay.screenCenter(healthBar2, true);
			healthBar2.y = 112;
			
			healthBar3 = new FlxHealthBar(red, 100, 10, 0, 100);
			healthBar3.createImageBar(null, healthBarPNG, 0xaa000000);
			healthBar3.setFillDirection(FlxHealthBar.FILL_INSIDE_OUT);
			FlxDisplay.screenCenter(healthBar3, true);
			healthBar3.y = 176;
			
			red.health = FlxMath.rand(10, 90);
			red.visible = false;
			
			add(red);
			
			add(healthBar1);
			add(healthBar2);
			add(healthBar3);
		}
		
		override public function update():void
		{
			super.update();
			
			//	This just cycles the health value up and down, so the bars animate
			if (redDirection == 0)
			{
				red.health++;
				
				if (red.health > 100)
				{
					redDirection = 1;
				}
			}
			else
			{
				red.health--;
				
				if (red.health <= 0)
				{
					redDirection = 0;
				}
			}
			
		}
		
	}

}