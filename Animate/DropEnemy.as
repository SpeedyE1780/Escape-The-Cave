package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	
	public class DropEnemy extends MovieClip {
		
		var Velocity : Number;
		var initialY : Number;
		var DropTimer : Timer;
		var Dropping : Boolean;
		
		public function DropEnemy() {
			// constructor code
			Dropping = false;
			DropTimer = new Timer(Math.random() * 1000 + 500);
			DropTimer.start();
			DropTimer.addEventListener(TimerEvent.TIMER , Drop);
			
			Velocity = Math.random() *5 + 5;
			this.addEventListener(Event.ENTER_FRAME , Loop);
		}
		
		function Loop(E:Event)
		{
			
			if(Dropping)
			{
				this.y += Velocity;
			
				for(var i : int = 0 ; i < Game.myBlocksArray.length ; i++)
				{
					if(this.hitTestObject(Game.myBlocksArray[i]))
					{
						if(this.x == Game.myBlocksArray[i].x)
						{
							if(this.y < Game.myBlocksArray[i].y)
							{
								this.y = initialY;
								Dropping = false;
								DropTimer.start();
								Velocity = Math.random() *5 + 5;
							}
						}
						
					}
				}
			}
		}
			
		
		function UpdateY(Y: Number)
		{
			initialY = Y;
		}
		
		function Drop(T : TimerEvent)
		{
			Dropping = true;
			DropTimer.reset();
		}
		
	}
	
}
