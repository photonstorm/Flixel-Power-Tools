package org.flixel.plugin.photonstorm.FX 
{
	import org.flixel.FlxSprite;
	import flash.display.BitmapData;
	
	public class BaseFX 
	{
		/**
		 * Set to false to stop this effect being updated by the FlxSpecialFX Plugin. Set to true to enable.
		 */
		public var active:Boolean;
		
		/**
		 * The FlxSprite into which the effect is drawn. Add this to your FlxState / FlxGroup to display the effect.
		 */
		public var sprite:FlxSprite;
		
		/**
		 * A scratch bitmapData used to build-up the effect before passing to sprite.pixels
		 */
		public var canvas:BitmapData;
		
		/**
		 * TODO A snapshot of the sprite background before the effect is applied
		 */
		public var back:BitmapData;
		
		public function BaseFX() 
		{
			active = false;
		}
		
	}

}