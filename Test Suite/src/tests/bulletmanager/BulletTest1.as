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

			//	Our players space ship
			player = new FlxSprite(160, 200, AssetsRegistry.invaderPNG);
			
			//	Weapon
			lazer = new Weapon("lazer", player, "x", "y");
			lazer.makeImageBullet(50, AssetsRegistry.bulletPNG);
			lazer.setBulletDirection(Weapon.BULLET_UP, 200);
			
			
			//	Control the player
			FlxControl.create(player, FlxControlHandler.MOVEMENT_INSTANT, FlxControlHandler.STOPPING_INSTANT, 1, false, false);
			FlxControl.player1.setMovementSpeed(200, 0, 200, 0);
			FlxControl.player1.setCursorControl(false, false, true, true);
			FlxControl.player1.setFireButton("SPACE", FlxControlHandler.KEYMODE_PRESSED, 100, lazer.fire);
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