/**
 * FlxFlod
 * -- Part of the Flixel Power Tools set
 * 
 * v1.2 Updated for the Flixel 2.5 Plugin system
 * 
 * @version 1.2 - April 23rd 2011
 * @link http://www.photonstorm.com
 * @author Richard Davey / Photon Storm
*/

package org.flixel.plugin.photonstorm 
{
	import org.flixel.*;
	import neoart.flod.*;
	
	import flash.utils.ByteArray;
	import flash.media.SoundTransform;
	
	/**
	 * FlxFlod adds support for the Flod AS3 Replay library by Christian Corti.<br />
	 * Flod is an incredibly powerful library allowing you to play tracker music from the Amiga / ST / PC (SoundTracker, ProTracker, etc)<br />
	 * More information about Flod can be found here: http://www.photonstorm.com/flod<br /><br />
	 * 
	 * This class works without modifying flixel, however the mute/volume/pause/resume commands won't be hooked into flixel.<br />
	 * You can either use a patched version of Flixel which is provided in this repository:<br />
	 * flash-game-dev-tips\Flixel Versions\Flixel v2.43 Patch 1.0
	 * <br />
	 * Or you can patch FlxG manually by doing the following:<br /><br />
	 * 
	 * 1) Add <code>import com.photonstorm.flixel.FlxFlod;</code> at the top of FlxG.as:<br />
	 * 2) Find the function <code>static public function set mute(Mute:Boolean):void</code> and add this line at the end of it: <code>FlxFlod.mute = Mute;</code><br />
	 * 3) Find the function <code>static public function set volume(Volume:Number):void</code> and add this line at the end of it: <code>FlxFlod.volume = Volume;</code><br />
	 * 4) Find the function <code>static protected function pauseSounds():void</code> and add this line at the end of it: <code>FlxFlod.pause();</code><br />
	 * 5) Find the function <code>static protected function playSounds():void</code> and add this line at the end of it: <code>FlxFlod.resume();</code><br /><br />
	 * 
	 * Flixel will now be patched so that any music playing via FlxFlod responds to the global flixel mute, volume and pause controls
	 */
	
	public class FlxFlod
	{
		private static var processor:ModProcessor;
		private static var modStream:ByteArray;
		private static var soundform:SoundTransform = new SoundTransform();
		
		private static var fadeTimer:FlxDelay;
		
		private static var callbackHooksCreated:Boolean = false;
		
		/**
		 * Starts playback of a tracker module
		 * 
		 * @param	toon	The music to play
		 * 
		 * @return	Boolean	true if playback started successfully, false if not
		 */
		public static function playMod(toon:Class):Boolean
		{
			stopMod();
			
			modStream = new toon() as ByteArray;
			
			processor = new ModProcessor();
			
			if (processor.load(modStream))
			{
				processor.loopSong = true;
				processor.stereo = 0;
				processor.play();
				
				if (processor.soundChannel)
				{
					soundform.volume = FlxG.volume;
					processor.soundChannel.soundTransform = soundform;
				}
				
				if (callbackHooksCreated == false)
				{
					FlxG.volumeHandler = updateVolume;
					callbackHooksCreated = true;
				}
				
				return true;
				
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * Pauses playback of this module, if started
		 */
		public static function pause():void
		{
			if (processor)
			{
				processor.pause();
			}
		}
		
		/**
		 * Resumes playback of this module if paused
		 */
		public static function resume():void
		{
			if (processor)
			{
				processor.resume();
			}
		}
		
		/**
		 * Stops playback of this module, if started
		 */
		public static function stopMod():void
		{
			if (processor)
			{
				processor.stop();
			}
		}
		
		/**
		 * Toggles playback mute
		 */
		public static function set mute(Mute:Boolean):void
		{
			if (processor)
			{
				if (Mute)
				{
					if (processor.soundChannel)
					{
						soundform.volume = 0;
						processor.soundChannel.soundTransform = soundform;
					}
				}
				else
				{
					if (processor.soundChannel)
					{
						soundform.volume = FlxG.volume;
						processor.soundChannel.soundTransform = soundform;
					}
				}
			}
		}
		
		/**
		 * Called by FlxG when the volume is adjusted in-game
		 * 
		 * @param	Volume
		 */
		public static function updateVolume(Volume:Number):void
		{
			volume = Volume;
		}
		
		/**
		 * Sets the playback volume directly (usually controlled by FlxG.volume)
		 */
		public static function set volume(Volume:Number):void
		{
			if (processor)
			{
				if (processor.soundChannel)
				{
					soundform.volume = Volume;
					processor.soundChannel.soundTransform = soundform;
				}
			}
		}
		
		/**
		 * TODO!
		 * @param	duration
		 */
		public static function fadeOut(duration:int):void
		{
		}
		
		/**
		 * Is a tune already playing?
		 */
		public static function get isPlaying():Boolean
		{
			if (processor)
			{
				return processor.isPlaying;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * Is a tune paused?
		 */
		public static function get isPaused():Boolean
		{
			if (processor)
			{
				return processor.isPaused;
			}
			else
			{
				return false;
			}
		}
		
		
		/*
		private function playSongWithFlectrum():void
		{
			//	1) First we get the module into a ByteArray
			
			stream = new Song1() as ByteArray;
			
			//	2) Create the ModProcessor which will play the song
			
			processor = new ModProcessor();
			
			//	3) Create the SoundEx, this keeps track of the sound channel and sound mixer
			
			sound = new SoundEx();
			
			//	4) Create the Flectrum - the first parameter is the soundEx above. The second two control the size of the flectrum
			
			flectrum = new Flectrum(sound, 64, 32);
			//	This bitmap is the vu meter
			flectrum.useBitmap(Bitmap(new FlectrumMeter2PNG()).bitmapData);
			//	You can control the spacing between the peaks with these pixel values
			flectrum.rowSpacing = 0;
			flectrum.columnSpacing = 0;
			//	Turn it on to see it in action :)
			flectrum.showBackground = false;
			//	Should the background pulse to the beat? You can also control its alpha
			flectrum.backgroundBeat = true;
			//	Location of the flectrum on-screen
			flectrum.x = 0;
			flectrum.y = 380;
			
			//	Add it to the display list
			addChild(flectrum);
			
			//	5) Load the song (now converted into a ByteArray) into the ModProcessor
			//	This returns true on success, meaning the module was parsed successfully
			
			if (processor.load(stream))
			{
				//	Will the song loop at the end? (boolean)
				processor.loopSong = true;
				
				//	6) Play it! Note that this time we pass in the SoundEx to the ModProcessor, so it can update the Flectrum
				processor.play(sound);
			}
		}
		*/
		
		
		
		
	}

}