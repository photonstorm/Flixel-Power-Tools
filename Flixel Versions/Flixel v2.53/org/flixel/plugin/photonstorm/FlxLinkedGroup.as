package org.flixel.plugin.photonstorm 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;

	public class FlxLinkedGroup extends FlxGroup
	{
		
		public function FlxLinkedGroup(MaxSize:uint = 0)
		{
			super(MaxSize);
		}
		
		public function addX(newX:int):void
		{
			for each (var s:FlxSprite in members)
			{
				s.x += newX;
			}
		}
		
		public function angle(newX:int):void
		{
			for each (var s:FlxSprite in members)
			{
				s.angle += newX;
			}
		}
		
	}

}