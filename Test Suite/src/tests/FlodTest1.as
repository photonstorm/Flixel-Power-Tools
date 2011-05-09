package tests 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class FlxFlodTest1 extends FlxState
	{
		//	Common variables
		public static var title:String = "Flod 1";
		public static var description:String = "Replay of MOD files (tracker music)";
		private var instructions:String = "Button toggles music + try the flixel volume controls";
		private var header:TestsHeader;
		
		//	Test specific variables
		[Embed(source = '../../assets/battlechips3.mod', mimeType = 'application/octet-stream')] private var musicMOD:Class;
		
		private var playback:FlxButtonPlus;
		private var pause:FlxButtonPlus;
		
		public function FlxFlodTest1() 
		{
		}
		
		override public function create():void
		{
			header = new TestsHeader(instructions);
			add(header);
			
			playback = new FlxButtonPlus(80, 112, toggleMusic, null, "Play Music");
			
			pause = new FlxButtonPlus(196, 112, togglePause, null, "Pause", 60);
			pause.visible = false;
			
			add(playback);
			add(pause);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		private function toggleMusic():void
		{
			if (FlxFlod.isPlaying)
			{
				playback.text = "Play Music";
				FlxFlod.stopMod();
				pause.visible = false;
			}
			else
			{
				playback.text = "Stop Music";
				FlxFlod.playMod(musicMOD);
				pause.text = "Pause";
				pause.visible = true;
			}
		}
		
		private function togglePause():void
		{
			if (FlxFlod.isPaused)
			{
				pause.text = "Pause";
				FlxFlod.resume();
			}
			else
			{
				pause.text = "Resume";
				FlxFlod.pause();
			}
		}
		
	}

}