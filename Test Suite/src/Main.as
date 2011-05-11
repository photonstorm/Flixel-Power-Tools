/**
 * Flixel Power Tools Test Suite
 * 
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
			super(320, 256, TestSuiteState, 2, 60, 60);
			
			FlxG.stage.quality = StageQuality.LOW;
			
			forceDebugger = true;
		}
		
	}
	
}