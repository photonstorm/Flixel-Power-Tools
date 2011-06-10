package tests.weapon 
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.BaseTypes.Bullet;
	import org.flixel.plugin.photonstorm.BaseTypes.Weapon;
	import tests.TestsHeader;

	public class WeaponTest2 extends FlxState
	{
		//	Common variables
		public static var title:String = "Weapon 2";
		public static var description:String = "Fire from a fixed location to the mouse";
		private var instructions:String = "Left click to Fire at mouse";
		private var header:TestsHeader;
		
		//	Test specific variables
		private var ufo:FlxSprite;
		private var lazer:Weapon;
		
		public function WeaponTest2() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			//	Test specific
			header.showDarkBackground();
			
			//	Weapon
			lazer = new Weapon("lazer");
			lazer.makeImageBullet(50, AssetsRegistry.chunkPNG);
			lazer.setFiringPosition(160, 140, 12, 12);
			lazer.setFireRate(100);
			lazer.setBulletSpeed(300);
			
			//	Just some eye-candy, to make it look like the ufo is shooting :)
			ufo = new FlxSprite(160, 140, AssetsRegistry.ufoPNG);
			
			//	The group which contains all of the bullets
			add(lazer.group);
			add(ufo);
			
			//	Header overlay
			add(header.overlay);
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.mouse.pressed())
			{
				lazer.fireAtMouse();
			}
		}
		
		override public function destroy():void
		{
			//	Important! Clear out the plugin otherwise resources will get messed right up after a while
			FlxControl.clear();
			
			super.destroy();
		}
		
	}

}