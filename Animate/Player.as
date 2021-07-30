package {

	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Player extends MovieClip {

		var myStage: Stage;
		var myGame : Game;

		var LeftDown: Boolean;
		var RightDown: Boolean;
		var UpDown: Boolean;
		var DownDown: Boolean;
		var Speed: Number;
		var Orientation : Number;
		var Idle : Boolean;
		var Walking : Boolean;
		
		var SpaceDown : Boolean;
		var canShoot : Boolean;
		var ShootingTimer : Timer;
		
		var LevelCleared : Boolean;
		
		public function Player(G : Game) {
			// constructor code
			myGame = G;
			myStage = G.stage;
			LevelCleared = true;

			Speed = 5;
			Orientation = 1;
			LeftDown = false;
			RightDown = false;
			UpDown = false;
			DownDown = false;
			
			SpaceDown = false;
			canShoot = false;
			ShootingTimer = new Timer(1000 , 1);
			ShootingTimer.addEventListener(TimerEvent.TIMER_COMPLETE , canShootTrue);

			this.addEventListener(Event.ENTER_FRAME, Loop);
			myStage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
			myStage.addEventListener(KeyboardEvent.KEY_UP, KeyUp);
			
			Idle = true;
			Walking = false;

		}

		function Loop(E: Event) {

			var Falling: Boolean = true;
			

			//Check if colliding with Blocks
			for (var i: int = 0; i < Game.myBlocksArray.length; i++) {
				if (this.hitTestObject(Game.myBlocksArray[i])) {
					if (this.y == Game.myBlocksArray[i].y - Game.CellSize) {
						Falling = false;
					}
					if (this.y == Game.myBlocksArray[i].y) {
						if (this.x < Game.myBlocksArray[i].x) {
							RightDown = false;
							if (Game.myBlocksArray[i].x - this.x < Game.CellSize) {
								this.x = Game.myBlocksArray[i].x - Game.CellSize;
							}
						}

						if (this.x > Game.myBlocksArray[i].x) {
							LeftDown = false;
							if (this.x - Game.myBlocksArray[i].x < Game.CellSize) {
								this.x = Game.myBlocksArray[i].x + Game.CellSize;
							}
						}
					}
				}
			}


			//Check if colliding with ladders
			for (var i: int = 0; i < Game.myLaddersArray.length; i++) {
				if (this.hitTestObject(Game.myLaddersArray[i])) {
					Falling = false;
					if (this.y == Game.myLaddersArray[i].y) {
						var CurrentLadder: Ladder = Game.myLaddersArray[i];
						var LadderAvailableDown: Boolean = false;

						//Check if there's a ladder under the current ladder
						for (var j: int = 0; j < Game.myLaddersArray.length; j++) {
							if (CurrentLadder.x == Game.myLaddersArray[j].x) {
								if (CurrentLadder.y == Game.myLaddersArray[j].y - Game.CellSize) {
									LadderAvailableDown = true;
								}
							}
						}

						if (LadderAvailableDown) {
							if (DownDown) {
								this.y += Game.CellSize;
								DownDown = false;
							}
						}

						if (UpDown) {
							//To keep the character visible on screen
							if(this.y - Game.CellSize > myGame.maximumY + this.height/2)
							{
								this.y -= Game.CellSize;
							}
							UpDown = false;
						}
					}

					//Check if there is a ladder under the player
					if (this.y == Game.myLaddersArray[i].y - Game.CellSize) {
						var CurrentLadder: Ladder = Game.myLaddersArray[i];
						var LadderAvailable: Boolean = false;

						for (var j: int = 0; j < Game.myLaddersArray.length; j++) {
							if (CurrentLadder.x == Game.myLaddersArray[j].x) {
								if (CurrentLadder.y == Game.myLaddersArray[j].y - Game.CellSize) {
									LadderAvailable = true;
								}
							}
						}

						if (LadderAvailable) {
							if (DownDown) {
								this.y += Game.CellSize;
								DownDown = false;
							}
						}

					}

				}
			}

			//Check if falling
			if (Falling) {
				LeftDown = false;
				RightDown = false;
				this.y += 10;
			}
			
			//Check if picking up a pickup
			for(var i : int = 0 ; i < Game.myPickupsArray.length ; i++)
			{
				if(this.hitTestObject(Game.myPickupsArray[i]))
				{
					if(Game.ScrollingController.contains(Game.myPickupsArray[i]))
					{
						Game.ScrollingController.removeChild(Game.myPickupsArray[i]);
					}
				}
			}
			
			//Check if colliding with an enemy
			for(var i : int = 0 ; i < Game.myEnemiesArray.length ; i++)
			{
				if(Game.ScrollingController.contains(Game.myEnemiesArray[i]))
				{
					if(this.hitTestObject(Game.myEnemiesArray[i]))
					{
						if(LevelCleared)
						{
							LevelCleared = false;
							myGame.ClearLevel();
						}
					}
				}
			}
			
			for(var i : int = 0 ; i < Game.myDropEnemies.length ; i++)
			{
				if(Game.ScrollingController.contains(Game.myDropEnemies[i]))
				{
					if(this.hitTestObject(Game.myDropEnemies[i]))
					{
						if(LevelCleared)
						{
							LevelCleared = false;
							myGame.ClearLevel();
						}
					}
				}
			}
			
			//Check if collided with shoot power up
			if(Game.PowerUp)
			{
				
				if(Game.ScrollingController.contains(Game.myShootPowerUp))
				{
					if(this.hitTestObject(Game.myShootPowerUp))
					{
						Game.ScrollingController.removeChild(Game.myShootPowerUp);
						canShoot = true;
					}
				}
			}
			
			
			//Check if collided with door
			if(myStage.contains(Game.myDoor))
			{
				if(this.hitTestObject(Game.myDoor))
				{
					myGame.currentLevel++;
					myGame.ClearLevel();
				}
			}
			

			if (LeftDown) {
				
				if(Idle)
				{
					Walking = true;
					Idle = false;
					gotoAndPlay('Walk');
				}
				
				Orientation = -1;
				this.scaleX = Orientation;
				this.x -= 5;
			}

			if (RightDown) {
				
				if(Idle)
				{
					Walking = true;
					Idle = false;
					gotoAndPlay('Walk');
				}
				
				Orientation = 1;
				this.scaleX = Orientation;
				this.x += 5;
			}
			
			if(!RightDown && !LeftDown)
			{
				if(Walking)
				{
					Idle = true;
					Walking = false;
					gotoAndPlay('Idle');
				}
			}
			
			if(canShoot)
			{
				if(SpaceDown)
				{
					var myBullet = new Bullet(Orientation , myGame.stage);
					
					if(Orientation == 1)
					{
						myBullet.x = this.x + this.width/2;
					}
					else
					{
						myBullet.x = this.x - this.width/2;
					}
					
					myBullet.y = this.y;
					Game.myBulletsArray.push(myBullet);
					Game.ScrollingController.addChild(myBullet);
					canShoot = false;
					ShootingTimer.reset();
					ShootingTimer.start();
					
				}
			}
			
			//Check if out of bounds
			if(this.y > myGame.minimumY + this.height/2)
			{
				myGame.ClearLevel();
			}
		}

		function KeyDown(K: KeyboardEvent) {
			if (K.keyCode == Keyboard.LEFT) {
				LeftDown = true;
			}

			if (K.keyCode == Keyboard.RIGHT) {
				RightDown = true;
			}

			if (K.keyCode == Keyboard.UP) {
				UpDown = true;
			}

			if (K.keyCode == Keyboard.DOWN) {
				DownDown = true;
			}
			
			if(K.keyCode == Keyboard.SPACE)
			{
				SpaceDown = true;
			}

		}

		function KeyUp(K: KeyboardEvent) {
			if (K.keyCode == Keyboard.LEFT) {
				LeftDown = false;
			}

			if (K.keyCode == Keyboard.RIGHT) {
				RightDown = false;
			}

			if (K.keyCode == Keyboard.UP) {
				UpDown = false;
			}

			if (K.keyCode == Keyboard.DOWN) {
				DownDown = false;
			}
			
			if(K.keyCode == Keyboard.SPACE)
			{
				SpaceDown = false;
			}

		}
		
		function Destroy()
		{
			this.x = 0;
			this.y = 0;
			this.removeEventListener(Event.ENTER_FRAME , Loop);
			myStage.removeEventListener(KeyboardEvent.KEY_DOWN , KeyDown);
			myStage.removeEventListener(KeyboardEvent.KEY_UP , KeyUp);
		}
		
		function canShootTrue(T:TimerEvent)
		{
			canShoot = true;
		}
	}

}