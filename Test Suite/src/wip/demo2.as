/**
 * FlxBitmapFont Demo 2
 * 
 * @author Richard Davey, Photon Storm, http://www.photonstorm.com
 * @version 1 - 20th May 2010
 */

package  
{
	import org.flixel.*;
	import flash.utils.getTimer;

	public class demo2 extends FlxState
	{
		[Embed(source = '../fonts/robocop_font.png')] private var robocopFont:Class;
		[Embed(source = '../fonts/knighthawks_font.png')] private var knighthawksFont:Class;
		
		private var fb:FlxBitmapFont;
		private var fb2:FlxBitmapFont;
		private var displayTimer:int;
		private var showingTimer:Boolean = false;

		public function demo2() 
		{
		}
		
		override public function create():void
		{
			super.create();
			
			fb = new FlxBitmapFont(robocopFont, 26, 32, " !\"aao '()  ;-./          :; = ?*ABCDEFGHIJKLMNOPQRSTUVWXYZ", 10, 6, 0, 3, 0);
			fb.setText("PRESS CURSORS\nAND NUMBER KEYS", true, 0, 4, FlxBitmapFont.ALIGN_CENTER, true);
			fb.x = (FlxG.width / 2) - (fb.width / 2);
			fb.y = FlxG.height / 2;
			fb.drag.x = 20;
			fb.drag.y = 20;
			
			fb2 = new FlxBitmapFont(knighthawksFont, 31, 25, FlxBitmapFont.TEXT_SET2, 10, 1, 0);
			fb2.y = 32;
			fb2.visible = false;
			
			add(fb);
			add(fb2);
		}
		
		override public function render():void
		{
			super.render();
			
			//	This simply lets us bounce the text around the screen
			//	As it's a normal FlxSprite, anything you can do to a sprite, you can do here
			
			if (FlxG.keys.UP)
			{
				fb.velocity.y -= FlxG.elapsed * 100;
			}
			
			if (FlxG.keys.DOWN)
			{
				fb.velocity.y += FlxG.elapsed * 100;
			}
			
			if (FlxG.keys.LEFT)
			{
				fb.velocity.x -= FlxG.elapsed * 100;
			}
			
			if (FlxG.keys.RIGHT)
			{
				fb.velocity.x += FlxG.elapsed * 100;
			}
			
			if (FlxG.keys.ONE)
			{
				fb.text = "CHANGE THE TEXT\nON THE FLY!";
			}
			
			if (FlxG.keys.TWO)
			{
				fb.text = "USE FOR SCORES\nAND OTHER UI INFO";
			}
			
			if (FlxG.keys.THREE)
			{
				fb.text = "PRETTY FAST TOO :)";
				showingTimer = true;
				displayTimer = getTimer();
				fb2.visible = true;
			}
			
			if (showingTimer)
			{
				fb2.text = "TIMER: " + int((getTimer() - displayTimer) / 100).toString();
				fb2.x = (FlxG.width / 2) - (fb2.width / 2);
			}
			
			if (fb.x < 0)
			{
				fb.x = 0;
				fb.velocity.x *= -1;
			}
			
			if (fb.x > FlxG.width - fb.width)
			{
				fb.x = FlxG.width - fb.width;
				fb.velocity.x *= -1;
			}
			
			if (fb.y < 0)
			{
				fb.y = 0;
				fb.velocity.y *= -1;
			}
			
			if (fb.y > FlxG.height - fb.height)
			{
				fb.y = FlxG.height - fb.height;
				fb.velocity.y *= -1;
			}
		}
	}

}