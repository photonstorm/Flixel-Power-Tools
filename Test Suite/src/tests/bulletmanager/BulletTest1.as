package tests.bulletmanager 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	import org.flixel.plugin.photonstorm.BaseTypes.Weapon;
	import tests.TestsHeader;

	public class BulletTest1 extends FlxState
	{
		//	Common variables
		public static var title:String = "Bullets 1";
		public static var description:String = "Bullet Manager Invaders Example";
		private var instructions:String = "LEFT / RIGHT to Move. Space to Fire.";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var controls:FlxControlHandler;
		private var player:FlxSprite;
		private var bullets:FlxGroup;
		private var lazer:Weapon;
		private var lazerBullet:Bullet;
		
		public function BulletTest1() 
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
			
			if (FlxG.getPlugin(FlxBulletManager) == null)
			{
				FlxG.addPlugin(new FlxBulletManager);
			}

			//	Our players space ship
			player = new FlxSprite(160, 200, AssetsRegistry.invaderPNG);
			
			//	Bullet
			lazerBullet = new Bullet(Bullet.FIRE_VERTICALLY, 300, AssetsRegistry.bulletPNG);
			lazerBullet.setParent(player, "x", "y", 5, 0);
			
			//	Weapon
			lazer = new Weapon("lazer", lazerBullet, 1, new FlxRect(0, 0, FlxG.width, FlxG.height));

			//	Control the player
			FlxControl.create(player, FlxControlHandler.MOVEMENT_INSTANT, FlxControlHandler.STOPPING_INSTANT, 1, false, false);
			FlxControl.player1.setMovementSpeed(200, 0, 200, 0);
			FlxControl.player1.setCursorControl(false, false, true, true);
			FlxControl.player1.setFireButton("SPACE", FlxControlHandler.KEYMODE_PRESSED, 200, lazer.fire);
			FlxControl.player1.setBounds(16, 200, 280, 16);
			
			add(lazer.group);
			add(player);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		override public function destroy():void
		{
			//	Important! Clear out the plugin otherwise resources will get messed right up after a while
			
			FlxControl.clear();
			FlxBulletManager.clear();
			
			super.destroy();
		}
		
		
	}

}