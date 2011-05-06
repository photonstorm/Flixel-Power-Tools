/**
 * Flixel Power Tools Test Suite
 * 
 * You don't need to include this in your own game if you just wish to use the libs!
 * However there are lots of great examples how to use them in here, so worth studying.
 * 
 * @version 1.1 - May 25th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package 
{
	import flash.display.Sprite;
	import flash.display.StageQuality;
	
	import org.flixel.*;
	
	public class Main extends FlxGame
	{
		public function Main():void 
		{
			super(320, 240, TestSuiteState, 2, 60, 60);
			
			FlxG.stage.quality = StageQuality.LOW;
			
			//forceDebugger = true;
		}
		
	}
	
}