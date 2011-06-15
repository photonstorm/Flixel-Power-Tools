/**
 * Flixel Power Tools Test Suite
 * 
 * v1.7 - New FlxBar and FlxWeapon tests
 * v1.6 - FlxControl and new Special FX Plugins
 * v1.5 - Massive restructure to split the tests up and move to git
 * v1.4 - Scrolling Text and new Special FX Plugin systems added
 * v1.3 - Updated for Flixel v2.53
 * 
 * @version 1.7 - June 10th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package  
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import tests.*;
	import tests.bitmapfont.*;
	import tests.buttonplus.*;
	import tests.collision.*;
	import tests.color.*;
	import tests.controls.*;
	import tests.delay.*;
	import tests.display.*;
	import tests.extendedsprite.*;
	import tests.flod.*;
	import tests.gradient.*;
	import tests.flxbar.*;
	import tests.screengrab.*;
	import tests.scrollingtext.*;
	import tests.scrollzone.*;
	import tests.specialfx.*;
	import tests.velocity.*;
	import tests.weapon.*;
	import tests.wip.*;
	
	public class TestSuite2State extends FlxState
	{
		[Embed(source = '../assets/suite/menu_burd.png')] private var menuBurdPNG:Class;
		[Embed(source = '../assets/suite/amigamouse.png')] public static var mouseCursorPNG:Class;
		
		private var version:String;
		private var options:Array;
		private var header:TestsHeader;
		private var dolly:FlxSprite;
		private var burd:FlxSprite;
		private var shortcut:Class = ControlTest7;
		
		public function TestSuite2State()
		{
			options = new Array;
			
			options.push( { state: VelocityTest1, color: [0xff008000, 0xff00FF00] } );
			options.push( { state: VelocityTest2, color: [0xff008000, 0xff00FF00] } );
			options.push( { state: VelocityTest3, color: [0xff008000, 0xff00FF00] } );
			options.push( { state: VelocityTest4, color: [0xff008000, 0xff00FF00] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: GradientTest1, color: [0xffFF8000, 0xffDFDF00] } );
			options.push( { state: GradientTest2, color: [0xffFF8000, 0xffDFDF00] } );
			options.push( { state: GradientTest3, color: [0xffFF8000, 0xffDFDF00] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: ColorTest1, color: [0xff8000FF, 0xffBE7DFF] } );
			options.push( { state: ColorTest2, color: [0xff8000FF, 0xffBE7DFF] } );
			
			options.push( { newColumn: true } );
			
			options.push( { state: BitmapFontTest1, color: [0xff0080FF, 0xff80FFFF] } );
			options.push( { state: BitmapFontTest2, color: [0xff0080FF, 0xff80FFFF] } );
			options.push( { state: BitmapFontTest3, color: [0xff0080FF, 0xff80FFFF] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: CollisionTest1, color: [0xff2E2E2E, 0xff606060] } );
			options.push( { state: CollisionTest2, color: [0xff2E2E2E, 0xff606060] } );
			options.push( { state: CollisionTest3, color: [0xff2E2E2E, 0xff606060] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: DelayTest1, color: [0xff6C3913, 0xffC96923] } );
			
			options.push( { newColumn: true } );
			
			options.push( { state: FlodTest1, color: [0xffC0C0C0, 0xff808080] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: FlxBarTest1, color: [0xffFF8000, 0xffFF0080] } );
			options.push( { state: FlxBarTest2, color: [0xffFF8000, 0xffFF0080] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: ScreenGrabTest1, color: [0xffFF0000, 0xffBC1BDE] } );
			options.push( { state: ScreenGrabTest2, color: [0xffFF0000, 0xffBC1BDE] } );
			
			options.push( { newColumn: true } );
			
			//	SCREEN TWO
			
			options.push( { state: ButtonPlusTest1, color: [0xffFF0000, 0xffBC1BDE] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: ScrollZoneTest1, color: [0xff008000, 0xff00FF00] } );
			options.push( { state: ScrollZoneTest2, color: [0xff008000, 0xff00FF00] } );
			options.push( { state: ScrollZoneTest3, color: [0xff008000, 0xff00FF00] } );
			options.push( { state: ScrollZoneTest4, color: [0xff008000, 0xff00FF00] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: ScrollingTextTest1, color: [0xff0080FF, 0xff80FFFF] } );
			options.push( { state: ScrollingTextTest2, color: [0xff0080FF, 0xff80FFFF] } );
			options.push( { state: ScrollingTextTest3, color: [0xff0080FF, 0xff80FFFF] } );
			
			//	SCREEN THREE
			
			options.push( { newColumn: true } );
			
			options.push( { state: RainbowLineTest1, color: [0xff2E2E2E, 0xff606060] } );
			options.push( { state: PlasmaTest1, color: [0xff2E2E2E, 0xff606060] } );
			options.push( { state: FloodFillTest1, color: [0xff2E2E2E, 0xff606060] } );
			options.push( { state: FloodFillTest2, color: [0xff2E2E2E, 0xff606060] } );
			options.push( { state: StarFieldTest1, color: [0xff2E2E2E, 0xff606060] } );
			options.push( { state: StarFieldTest2, color: [0xff2E2E2E, 0xff606060] } );
			options.push( { state: GlitchTest1, color: [0xff2E2E2E, 0xff606060] } );
			options.push( { state: BlurTest1, color: [0xff2E2E2E, 0xff606060] } );
			options.push( { state: BlurTest2, color: [0xff2E2E2E, 0xff606060] } );
			options.push( { state: CenterSlideTest1, color: [0xff2E2E2E, 0xff606060] } );
			
			options.push( { newColumn: true } );
			
			options.push( { state: SineWaveTest1, color: [0xff2E2E2E, 0xff606060] } );
			options.push( { state: SineWaveTest2, color: [0xff2E2E2E, 0xff606060] } );
			options.push( { state: SineWaveTest3, color: [0xff2E2E2E, 0xff606060] } );
			options.push( { state: SineWaveTest4, color: [0xff2E2E2E, 0xff606060] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: ControlTest1, color: [0xff8000FF, 0xffBE7DFF] } );
			options.push( { state: ControlTest2, color: [0xff8000FF, 0xffBE7DFF] } );
			options.push( { state: ControlTest3, color: [0xff8000FF, 0xffBE7DFF] } );
			options.push( { state: ControlTest4, color: [0xff8000FF, 0xffBE7DFF] } );
			options.push( { state: ControlTest5, color: [0xff8000FF, 0xffBE7DFF] } );
			
			options.push( { newColumn: true } );
			
			//	SCREEN 4
			
			options.push( { state: WeaponTest1, color: [0xffC0C0C0, 0xff808080] } );
			options.push( { state: WeaponTest2, color: [0xffC0C0C0, 0xff808080] } );
			options.push( { state: WeaponTest3, color: [0xffC0C0C0, 0xff808080] } );
			options.push( { state: WeaponTest4, color: [0xffC0C0C0, 0xff808080] } );
			options.push( { state: WeaponTest5, color: [0xffC0C0C0, 0xff808080] } );
			options.push( { state: WeaponTest6, color: [0xffC0C0C0, 0xff808080] } );
		}
		
		override public function create():void
		{
			version = "- Test Suite v" + FlxPowerTools.LIBRARY_MAJOR_VERSION + "." + FlxPowerTools.LIBRARY_MINOR_VERSION + " -";

			header = new TestsHeader(version, false);
			add(header);
			
			FlxG.mouse.load(mouseCursorPNG, 2);
			

			add(header.overlay);
			
			FlxG.mouse.show();
		}
		
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.LEFT || (FlxG.mouse.screenX <= 50 && FlxG.mouse.screenY > 60))
			{
				dolly.x -= 3;
				
				if (dolly.x < 160)
				{
					dolly.x = 160;
				}
			}
			else if (FlxG.keys.RIGHT || (FlxG.mouse.screenX >= 270 && FlxG.mouse.screenY > 60))
			{
				dolly.x += 3;
				
				if (dolly.x > 640)
				{
					dolly.x = 640;
				}
			}
			
			//	Short-cut to save scrolling when debugging!
			if (FlxG.keys.justReleased("SPACE"))
			{
				startTest(shortcut);
			}
		}
		
		private function startTest(state:Class):void
		{
			Registry.menuOffsetX = dolly.x;
			
			FlxG.switchState(new state);
		}
		
		private function buttonOver(text:String):void
		{
			header.instructions.text = text;
		}
		
		private function buttonOut():void
		{
			header.instructions.text = "";
		}
		
	}

}