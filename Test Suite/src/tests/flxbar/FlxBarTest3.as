package tests.flxbar 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import tests.TestsHeader;

	public class FlxBarTest3 extends FlxState
	{
		//	Common variables
		public static var title:String = "FlxBar 3";
		public static var description:String = "Mini-game example";
		private var instructions:String = "Mouse to shoot. Kill them all!";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var bullets:FlxGroup;
		private var baddies:FlxGroup;
		private var baddieHealth:FlxGroup;
		
		public function FlxBarTest3() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			
			//	Let's make some bullets
			
			bullets = new FlxGroup(40);
			
			for (var b:int = 0; b < bullets.maxSize; b++)
			{
				bullets.add(new FlxSprite(0, 0, AssetsRegistry.chunkPNG));
			}
			
			//	Hide 'em all to start with
			bullets.setAll("alive", false);
			
			//	Let's make some baddies
			
			baddies = new FlxGroup(20);
			baddieHealth = new FlxGroup(20);
			
			for (b = 0; b < 20; b++)
			{
				var baddie:FlxSprite = new FlxSprite(FlxMath.rand(24, FlxG.width - 24), FlxMath.rand(24, FlxG.height - 100), AssetsRegistry.ufoPNG);
				baddie.health = 100;
				baddie.immovable = true;
				
				var badHealth:FlxBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, 32, 4, baddie, "health");
				badHealth.trackParent(0, -6);
				badHealth.killOnEmpty = true;
				
				baddies.add(baddie);
				baddieHealth.add(badHealth);
			}
			
			//	Hide 'em all to start with
			bullets.setAll("alive", false);
			
			add(baddieHealth);
			add(baddies);
			add(bullets);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
			
			FlxG.collide(bullets, baddies, blasted);
			
			for (var b:int = 0; b < bullets.length; b++)
			{
				if (FlxSprite(bullets.members[b]).alive)
				{
					if (FlxSprite(bullets.members[b]).x < 0 || FlxSprite(bullets.members[b]).x > 320 || FlxSprite(bullets.members[b]).y < 0)
					{
						FlxSprite(bullets.members[b]).alive = false;
					}
				}
			}
			
			if (FlxG.mouse.pressed())
			{
				if (bullets.countDead() > 0)
				{
					var bullet:FlxSprite = bullets.getFirstDead() as FlxSprite;
					
					bullet.x = 160;
					bullet.y = 240;
					bullet.alive = true;
					
					FlxVelocity.moveTowardsMouse(bullet, 320);
				}
			}
		}
		
		private function blasted(bullet:FlxSprite, baddie:FlxSprite):void
		{
			bullet.kill();
			
			baddie.hurt(10);
		}
		
	}

}