package  
{
	import examples.test1;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Richard Davey
	 */
	public class DemoSuiteState extends FlxState 
	{
		
		public function DemoSuiteState() 
		{
		}
		
		override public function create():void
		{
			FlxG.switchState(new test1);
		}
		
	}

}