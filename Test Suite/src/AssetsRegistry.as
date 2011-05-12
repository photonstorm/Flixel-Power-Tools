package  
{
	/**
	 * Assets Registry
	 * 
	 * Because lots of the Tests use the same assets we store them in here.
	 * 
	 * If we stored them in their respective Test classes then they will be compiled multiple times
	 * into the SWF! The Flex compiler isn't clever enough to tell you're using the same asset across
	 * classes, so you end up wasting a lot of space.
	 */
	public class AssetsRegistry 
	{
		//	Bitmap Fonts
		[Embed(source = '../assets/fonts/bluepink_font.png')] public static var bluepinkFontPNG:Class;
		[Embed(source = '../assets/fonts/gold_font.png')] public static var goldFontPNG:Class;
		[Embed(source = '../assets/fonts/knighthawks_font.png')] public static var knighthawksFontPNG:Class;
		[Embed(source = '../assets/fonts/knight3.png')] public static var knightHawksPurpleFontPNG:Class;
		[Embed(source = '../assets/fonts/087.png')] public static var shinyBlueFontPNG:Class;
		[Embed(source = '../assets/fonts/steel.png')] public static var steelFontPNG:Class;
		[Embed(source = '../assets/fonts/260.png')] public static var metalFontPNG:Class;
		[Embed(source = '../assets/fonts/tsk_font.png')] public static var tskFontPNG:Class;
		[Embed(source = '../assets/fonts/070.png')] public static var godsPNG:Class;
		[Embed(source = '../assets/fonts/072.png')] public static var tinyPNG:Class;
		
		//	Sprites
		[Embed(source = '../assets/mouse.png')] public static var mouseCursorPNG:Class;
		[Embed(source = '../assets/red_ball.png')] public static var redPNG:Class;
		[Embed(source = '../assets/green_ball.png')] public static var greenPNG:Class;
		[Embed(source = '../assets/blue_ball.png')] public static var bluePNG:Class;
		[Embed(source = '../assets/ilkke.png')] public static var ilkkePNG:Class;
		[Embed(source = '../assets/alpha-test.png')] public static var alphaPNG:Class;
		[Embed(source = '../assets/healthbar.png')] public static var healthBarPNG:Class;
		[Embed(source = '../assets/balls.png')] public static var ballsPNG:Class;
		[Embed(source = '../assets/agent-t-buggin-acf_logo.png')] public static var acfPNG:Class;
		[Embed(source = '../assets/auto_scroll_landscape.png')] public static var tcbPNG:Class;
		[Embed(source = '../assets/chick.png')] public static var chickPNG:Class;
		[Embed(source = '../assets/car.png')] public static var carPNG:Class;
		[Embed(source = '../assets/tinycar.png')] public static var tinyCarPNG:Class;
		[Embed(source = '../assets/ufo.png')] public static var ufoPNG:Class;
		[Embed(source = '../assets/thrust_ship.png')] public static var thrustShipPNG:Class;
		[Embed(source = '../assets/shmup-ship.png')] public static var shmupShipPNG:Class;
		
		//	Pictures
		[Embed(source='../assets/1984-nocooper-space.png')] public static var noCooper1984PNG:Class;
		[Embed(source = '../assets/spaz-bitch-beatnick.png')] public static var spazPNG:Class;
		[Embed(source = '../assets/game14_angel_dawn.png')] public static var angelDawnPNG:Class;
		[Embed(source = '../assets/spaz-oh_crikey-komische_sackratten_von_der_hohle.png')] public static var ohCrikeyPNG:Class;
		[Embed(source = '../assets/lance-overdose-loader_eye.png')] public static var overdoseEyePNG:Class;
		
		//	Music
		[Embed(source = '../assets/battlechips3.mod', mimeType = 'application/octet-stream')] public static var battlechips3MOD:Class;
		[Embed(source = '../assets/yo_africa.MOD', mimeType = 'application/octet-stream')] public static var yoAfricaMOD:Class;
		
		public function AssetsRegistry() 
		{
		}
		
	}

}