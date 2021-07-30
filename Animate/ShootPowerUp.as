package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class ShootPowerUp extends MovieClip {
		
		
		public function ShootPowerUp() {
			// constructor code
			this.addEventListener(Event.ENTER_FRAME , Loop);
		}
		
		function Loop (E:Event)
		{
			this.rotation += 5;
		}
	}
	
}
