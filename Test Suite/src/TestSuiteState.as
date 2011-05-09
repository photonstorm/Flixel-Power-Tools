/**
 * Flixel Power Tools Test Suite
 * 
 * Updated for Flixel v2.53
 * 
 * Test Selection Menu
 * 
 * @version 1.4 - May 5th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import tests.*;
	import flash.utils.getDefinitionByName;
	
	public class TestSuiteState extends FlxState
	{
		[Embed(source = '../assets/menu_burd.png')] private var menuBurdPNG:Class;
		
		private var version:String = "- Test Suite v1.4 -";
		private var options:Array;
		private var header:TestsHeader;
		private var dolly:FlxSprite;
		private var burd:FlxSprite;
		
		public function TestSuiteState()
		{
			options = new Array;
			
			options.push( { state: FlxVelocityTest1, color: [0xff008000, 0xff00FF00] } );
			options.push( { state: FlxVelocityTest2, color: [0xff008000, 0xff00FF00] } );
			options.push( { state: FlxVelocityTest3, color: [0xff008000, 0xff00FF00] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: FlxGradientTest1, color: [0xffFF8000, 0xffDFDF00] } );
			options.push( { state: FlxGradientTest2, color: [0xffFF8000, 0xffDFDF00] } );
			options.push( { state: FlxGradientTest3, color: [0xffFF8000, 0xffDFDF00] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: FlxBitmapFontTest1, color: [0xff0080FF, 0xff80FFFF] } );
			options.push( { state: FlxBitmapFontTest2, color: [0xff0080FF, 0xff80FFFF] } );
			
			options.push( { newColumn: true } );
			
			options.push( { state: FlxCollisionTest1, color: [0xff2E2E2E, 0xff606060] } );
			options.push( { state: FlxCollisionTest2, color: [0xff2E2E2E, 0xff606060] } );
			options.push( { state: FlxCollisionTest3, color: [0xff2E2E2E, 0xff606060] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: FlxColorTest1, color: [0xff8000FF, 0xffBE7DFF] } );
			options.push( { state: FlxColorTest2, color: [0xff8000FF, 0xffBE7DFF] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: FlxFlodTest1, color: [0xffC0C0C0, 0xff808080] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: FlxDelayTest1, color: [0xff6C3913, 0xffC96923] } );
			
			options.push( { newColumn: true } );
			
			options.push( { state: FlxHealthBarTest1, color: [0xffFF8000, 0xffFF0080] } );
			options.push( { state: FlxHealthBarTest2, color: [0xffFF8000, 0xffFF0080] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: FlxStarFieldTest1, color: [0xff2FA41E, 0xff266599] } );
			options.push( { state: FlxStarFieldTest2, color: [0xff2FA41E, 0xff266599] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: FlxButtonPlusTest1, color: [0xffFF0000, 0xffBC1BDE] } );
			
			options.push( { newColumn: true } );
			
			//	SCREEN TWO
			
			options.push( { state: FlxScrollZoneTest1, color: [0xff008000, 0xff00FF00] } );
			options.push( { state: FlxScrollZoneTest2, color: [0xff008000, 0xff00FF00] } );
			options.push( { state: FlxScrollZoneTest3, color: [0xff008000, 0xff00FF00] } );
			options.push( { state: FlxScrollZoneTest4, color: [0xff008000, 0xff00FF00] } );
			
			options.push( { spacer: true } );
			
			options.push( { state: FlxScreenGrabTest1, color: [0xffFF0000, 0xffBC1BDE] } );
			options.push( { state: FlxScreenGrabTest2, color: [0xffFF0000, 0xffBC1BDE] } );
			
			options.push( { newColumn: true } );
			
			options.push( { state: FlxScrollingTextTest1, color: [0xff0080FF, 0xff80FFFF] } );
			options.push( { state: FlxScrollingTextTest2, color: [0xff0080FF, 0xff80FFFF] } );
			options.push( { state: FlxScrollingTextTest3, color: [0xff0080FF, 0xff80FFFF] } );
			
		}
		
		override public function create():void
		{
			header = new TestsHeader(version, false);
			
			header.instructions.text = version;
			
			add(header);
			
			//	Our camera tracks this invisible sprite
			dolly = new FlxSprite(Registry.menuOffsetX, 0);
			dolly.makeGraphic(1, 1, 0x00ffffff);
			add(dolly);
			
			burd = new FlxSprite(230, 171, menuBurdPNG);
			add(burd);
			
			var xOffset:int = 16;
			var yOffset:int = 32;
			var currentY:int = yOffset;
			var padding:int = 2;
			
			for (var i:int = 0; i < options.length; i++)
			{
				var option:Object = options[i];
				
				if (option.newColumn)
				{
					xOffset += (80 + 16 + 8);
					currentY = yOffset;
				}
				else if (option.spacer)
				{
					currentY += 14;
				}
				else
				{
					var tempButton:FlxButtonPlus = new FlxButtonPlus(xOffset, currentY, startTest, [option.state], option.state.title, 80, 18);
					tempButton.updateInactiveButtonColors(option.color);
					tempButton.setMouseOverCallback(buttonOver, [option.state.description]);
					tempButton.setMouseOutCallback(buttonOut);
					
					add(tempButton);
					
					currentY += tempButton.height + padding;
				}
			}

			FlxG.camera.follow(dolly);
			FlxG.camera.setBounds(0, 0, 640, 240, true);
			
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
				
				if (dolly.x > 480)
				{
					dolly.x = 480;
				}
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