/**
 * FlxLinkedGroup
 * -- Part of the Flixel Power Tools set
 * 
 * v2.0 Moved to the new structure for FPT v2.0
 * 
 * @version 2.0 - October 11th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm.gameobjects 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import flash.utils.getTimer;

	public class FlxLinkedGroup extends FlxGroup
	{
		//private var queue
		
		
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