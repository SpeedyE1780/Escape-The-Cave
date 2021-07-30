package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class PickUps extends MovieClip {
		
		
		public function PickUps() {
			// constructor code
			this.addEventListener(Event.ENTER_FRAME , Loop);
			
		}
		
		function Loop(E:Event)
		{
			this.rotation += 5;
		}

	}
	
}
