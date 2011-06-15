package  
{
	/**
	 * Assets Registry
	 * 
	 * These sprites and tiles are NOT for use in your own games.
	 * By all means use them for testing and prototypes, but do not use them in commecial games,
	 * games seeking sponsorship or games carrying adverts (like Mochi Ads)
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
		[Embed(source = '../assets/sprites/red_ball.png')] public static var redPNG:Class;
		[Embed(source = '../assets/sprites/green_ball.png')] public static var greenPNG:Class;
		[Embed(source = '../assets/sprites/blue_ball.png')] public static var bluePNG:Class;
		[Embed(source = '../assets/sprites/ilkke.png')] public static var ilkkePNG:Class;
		[Embed(source = '../assets/sprites/healthbar.png')] public static var healthBarPNG:Class;
		[Embed(source = '../assets/sprites/flectrum.png')] public static var flectrumPNG:Class;
		[Embed(source = '../assets/sprites/balls.png')] public static var ballsPNG:Class;
		[Embed(source = '../assets/sprites/chick.png')] public static var chickPNG:Class;
		[Embed(source = '../assets/sprites/car.png')] public static var carPNG:Class;
		[Embed(source = '../assets/sprites/tinycar.png')] public static var tinyCarPNG:Class;
		[Embed(source = '../assets/sprites/ufo.png')] public static var ufoPNG:Class;
		[Embed(source = '../assets/sprites/thrust_ship.png')] public static var thrustShipPNG:Class;
		[Embed(source = '../assets/sprites/shmup-ship.png')] public static var shmupShipPNG:Class;
		[Embed(source = '../assets/sprites/player.png')] public static var invaderPNG:Class;
		[Embed(source = '../assets/sprites/space-baddie.png')] public static var spaceBaddiePNG:Class;
		[Embed(source = '../assets/sprites/bullet.png')] public static var bulletPNG:Class;
		[Embed(source = '../assets/sprites/chunk.png')] public static var chunkPNG:Class;
		[Embed(source = '../assets/sprites/metalslug_mummy37x45.png')] public static var mummyPNG:Class;
		[Embed(source = '../assets/sprites/metalslug_monster39x40.png')] public static var monsterPNG:Class;
		[Embed(source = '../assets/sprites/xenon2_ship.png')] public static var xenon2ShipPNG:Class;
		[Embed(source = '../assets/sprites/xenon2_bomb.png')] public static var xenon2BombPNG:Class;
		[Embed(source = '../assets/sprites/advanced_wars_tank.png')] public static var advWarsTankPNG:Class;
		[Embed(source = '../assets/sprites/advanced_wars_land.png')] public static var advWarsLandPNG:Class;
		[Embed(source = '../assets/sprites/asteroids_ship.png')] public static var asteroidsShipPNG:Class;
		
		//	Pictures
		[Embed(source = '../assets/pics/mask-test.png')] public static var alphaMaskPNG:Class;
		[Embed(source = '../assets/pics/mask-test2.png')] public static var alphaMask2PNG:Class;
		[Embed(source = '../assets/pics/1984-nocooper-space.png')] public static var noCooper1984PNG:Class;
		[Embed(source = '../assets/pics/spaz-bitch-beatnick.png')] public static var spazPNG:Class;
		[Embed(source = '../assets/pics/game14_angel_dawn.png')] public static var angelDawnPNG:Class;
		[Embed(source = '../assets/pics/spaz-oh_crikey-komische_sackratten_von_der_hohle.png')] public static var ohCrikeyPNG:Class;
		[Embed(source = '../assets/pics/lance-overdose-loader_eye.png')] public static var overdoseEyePNG:Class;
		[Embed(source = '../assets/pics/seven_seas_andromeda_fairfax.png')] public static var sevenseasPNG:Class;
		[Embed(source = '../assets/pics/alpha-test.png')] public static var alphaPNG:Class;
		[Embed(source = '../assets/pics/agent-t-buggin-acf_logo.png')] public static var acfPNG:Class;
		[Embed(source = '../assets/pics/auto_scroll_landscape.png')] public static var tcbPNG:Class;
		[Embed(source = '../assets/pics/questar.png')] public static var questarPNG:Class;
		[Embed(source = '../assets/pics/shocktroopers_angel2.png')] public static var shocktAngle2PNG:Class;
		[Embed(source = '../assets/pics/acryl_bladerunner.png')] public static var acrylBladeRunnerPNG:Class;
		[Embed(source = '../assets/pics/acryl_bobablast.png')] public static var acrylBobaFettPNG:Class;
		
		//	Music
		[Embed(source = '../assets/mods/battlechips3.mod', mimeType = 'application/octet-stream')] public static var battlechips3MOD:Class;
		[Embed(source = '../assets/mods/yo_africa.MOD', mimeType = 'application/octet-stream')] public static var yoAfricaMOD:Class;
		[Embed(source = '../assets/mods/obnoxious_seq3_front6.MOD', mimeType = 'application/octet-stream')] public static var obnoxiousMOD:Class;
		[Embed(source = '../assets/mods/alpine_cut.MOD', mimeType = 'application/octet-stream')] public static var alpineCutMOD:Class;
		[Embed(source = '../assets/mods/anarchy.mod', mimeType = 'application/octet-stream')] public static var anarchyMOD:Class;
		
		//	Platformer Game
		[Embed(source = '../assets/tiles/platformer_tiles.png')] public static var platformerTilesPNG:Class;
		[Embed(source = '../assets/pics/platformer_backdrop.png')] public static var platformerBackdropPNG:Class;
		[Embed(source = '../assets/maps/platformer_map.csv', mimeType = 'application/octet-stream')] public static var platformerMapCSV:Class;
		
		//	Sci-Fi Game
		[Embed(source = '../assets/sprites/humstar.png')] public static var humstarPNG:Class;
		[Embed(source = '../assets/tiles/sci-fi-tiles.png')] public static var scifiTilesPNG:Class;
		[Embed(source = '../assets/maps/mapCSV_SciFi_Map1.csv', mimeType = 'application/octet-stream')] public static var scifiMap1CSV:Class;
		
		public function AssetsRegistry() 
		{
		}
		
	}

}