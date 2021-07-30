package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class Enemy extends MovieClip {
		
		var WaypointLeft : Waypoint;
		var WaypointRight : Waypoint;
		
		var Speed : Number;
		
		public function Enemy() {
			// constructor code
			Speed = 5;

			this.addEventListener(Event.ENTER_FRAME , Loop);
		}
		
		function FindWaypoints()
		{
			for(var i : int = 0 ; i < Game.myWaypointArray.length ; i++)
			{
				if(Game.myWaypointArray[i].y == this.y)
				{
					if(Game.myWaypointArray[i].x - 3 * Game.CellSize == this.x)
					{
						WaypointLeft = Game.myWaypointArray[i];
					}
					
					if(Game.myWaypointArray[i].x + 3 * Game.CellSize== this.x)
					{
						WaypointRight = Game.myWaypointArray[i];
					}
				}
			}
		}
		
		function Loop(E:Event)
		{
			this.x += Speed;
			
			if(this.x >= WaypointRight.x)
			{
				Speed*= -1;
				this.scaleX *= -1;
			}
			
			if(this.x <= WaypointLeft.x)
			{
				Speed *= -1;
				this.scaleX *= -1;
			}
		}
		
		function Destroy()
		{
			this.removeEventListener(Event.ENTER_FRAME , Loop);
		}
	}
	
}
