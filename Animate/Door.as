package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Door extends MovieClip {
		
		var myGame : Game;
		
		public function Door(G : Game) {
			// constructor code
			myGame = G;
			
			this.addEventListener(Event.ENTER_FRAME , Loop);
			
		}
		
		function Loop(E:Event)
		{
			if(this.y > myGame.minimumY + this.height/2)
			{
				myGame.ClearLevel();
			}
		}
		
		function Destroy()
		{
			this.removeEventListener(Event.ENTER_FRAME , Loop);
		}
	}
	
}
