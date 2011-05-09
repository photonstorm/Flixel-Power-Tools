/**
 * FlxExtendedSprite
 * -- Part of the Flixel Power Tools set
 * 
 * v1.0 Updated for the Flixel 2.5 Plugin system
 * 
 * @version 1.0 - April 25th 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm 
{
	import flash.display.BitmapData;
	import org.flixel.*;

	public class FlxExtendedSprite extends FlxSprite
	{
		
		public function FlxExtendedSprite(X:Number = 0, Y:Number = 0, SimpleGraphic:Class = null)
		{
			super(X, Y, SimpleGraphic);
		}
		
		public function get point():FlxPoint
		{
			return _point;
		}
		
		public function set point(p:FlxPoint):void
		{
			_point = p;
		}
		
	}

}