package  {
	
	import flash.display.MovieClip;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Stage;
	import flash.events.Event;
	
	
	public class Bullet extends MovieClip {
		
		var Orientation : Number;
		
		var myStage : Stage;
		
		var DestroyTimer : Timer;
		
		public function Bullet(O : Number , S : Stage) {
			// constructor code
			
			Orientation = O;
			
			myStage = S;
			
			DestroyTimer = new Timer(1000 , 1);
			DestroyTimer.addEventListener(TimerEvent.TIMER_COMPLETE , Destroy);
			DestroyTimer.start();
			
			this.addEventListener(Event.ENTER_FRAME , Loop);
		}
		
		function Loop(E:Event)
		{
			if(Orientation == 1)
			{
				this.x += 15;
				this.rotation += 5;
			}
			
			if(Orientation == -1)
			{
				this.x -= 15;
				this.rotation -= 5;
			}
			
			for(var i : int = 0 ; i < Game.myEnemiesArray.length ; i++)
			{
				if(this.hitTestObject(Game.myEnemiesArray[i]))
				{
					if(Game.ScrollingController.contains(Game.myEnemiesArray[i]))
					{
						Game.ScrollingController.removeChild(Game.myEnemiesArray[i]);
						Game.myEnemiesArray[i].Destroy();
						this.removeEventListener(Event.ENTER_FRAME , Loop);
						if(Game.ScrollingController.contains(this))
						{
							Game.ScrollingController.removeChild(this);
						}
					}
				}
			}
			
			for(var i : int = 0 ; i < Game.myBlocksArray.length ; i++)
			{
				if(this.hitTestObject(Game.myBlocksArray[i]))
				{
					if(Game.ScrollingController.contains(Game.myBlocksArray[i]))
					{
						this.removeEventListener(Event.ENTER_FRAME , Loop);
						if(Game.ScrollingController.contains(this))
						{
							Game.ScrollingController.removeChild(this);
						}
					}
				}
			}
		}
		
		function Destroy(T : TimerEvent)
		{
			if(Game.ScrollingController.contains(this))
			{
				this.removeEventListener(Event.ENTER_FRAME , Loop);
				Game.ScrollingController.removeChild(this);
			}
		}
		
		function DestroyEvents()
		{
			this.removeEventListener(Event.ENTER_FRAME , Loop);
		}
	}
	
}
