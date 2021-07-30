package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	
	public class Game extends MovieClip {
		
		var myLevels : Levels;
		var currentLevel : int;
		var myText : MenuText;
		var MenuScreen : Boolean;
		
		var myTheme : Theme;
		var myThemeTimer : Timer;
		
		public static var CellSize : Number;
		public static var myBlocksArray : Array;
		public static var myLaddersArray : Array;
		public static var myPickupsArray : Array;
		public static var myEnemiesArray : Array;
		public static var myDropEnemies : Array;
		public static var myBulletsArray : Array;
		public static var myWaypointArray: Array;
		public static var myDoor : Door;
		
		public static var ScrollingController : MovieClip;
		var maximumY : Number;
		var minimumY : Number;
		var ScrollingTimer : Timer;
		var Scrolling : Boolean;
		
		var myPlayer : Player;
		public static var myShootPowerUp : ShootPowerUp;
		public static var PowerUp : Boolean;
		
		public function Game() {
			// constructor code
			
			myLevels = new Levels();
			currentLevel = 0;
			
			myTheme = new Theme()
			myTheme.play();
			myThemeTimer = new Timer(myTheme.length);
			myThemeTimer.addEventListener(TimerEvent.TIMER , PlayTheme);
			myThemeTimer.start();
			
			CellSize = 40;
			
			ScrollingController = new MovieClip();
			maximumY = 0;
			minimumY = 720;
			Scrolling = false;
			ScrollingTimer = new Timer(5000 , 1);
			ScrollingTimer.addEventListener(TimerEvent.TIMER_COMPLETE , StartScrolling);
			
			BuildLevel(myLevels.LevelsArray[currentLevel]);
			this.addEventListener(Event.ENTER_FRAME , Loop);
		}
		
		//To Loop the music
		function PlayTheme(T:TimerEvent)
		{
			myTheme.play();
		}
		
		function StartScrolling(T:TimerEvent)
		{
			Scrolling = true;
		}
		
		function BuildLevel (Level : Array)
		{
			ScrollingController = new MovieClip();
			ScrollingController.y = 0;
			maximumY = 0;
			minimumY = 720;
			Scrolling = false;
			
			if(currentLevel == 0)
			{
				myText = new MenuText();
				myText.gotoAndStop('MainMenu');
				myText.x = stage.stageWidth/2;
				myText.y = myText.height/2;
				stage.addChild(myText);
				MenuScreen = true;
			}
			
			if(currentLevel == 9)
			{
				myText = new MenuText();
				myText.gotoAndStop('GameOver');
				myText.x = stage.stageWidth/2;
				myText.y = myText.height/2;
				stage.addChild(myText);
				MenuScreen = true;
			}

			if(currentLevel > 6 && currentLevel != myLevels.LevelsArray.length - 1)
			{
				
				ScrollingTimer.reset();
				ScrollingTimer.start();
			}
			
			myBlocksArray = new Array();
			myLaddersArray = new Array();
			myPickupsArray = new Array();
			myEnemiesArray = new Array();
			myBulletsArray = new Array();
			myWaypointArray = new Array();
			myDropEnemies = new Array();
			
			for(var j:int = 0; j< Level.length; j++)
			{
				for(var i:int = 0; i< Level[j].length; i++)
				{
					if(Level[j][i] == 1)
					{
						var myGround : Ground = new Ground();
						ScrollingController.addChild(myGround);
						myGround.x = myGround.width/2 + CellSize * i;
						myGround.y = myGround.height/2 + CellSize * (j-12);
						myBlocksArray.push(myGround);
					}
					
					if(Level[j][i] == 10)
					{
						var myGround : Ground = new Ground();
						ScrollingController.addChild(myGround);
						myGround.gotoAndStop('Right');
						myGround.x = myGround.width/2 + CellSize * i;
						myGround.y = myGround.height/2 + CellSize * (j-12);
						myBlocksArray.push(myGround);
					}
					
					if(Level[j][i] == 11)
					{
						var myGround : Ground = new Ground();
						myGround.gotoAndStop('Left');
						ScrollingController.addChild(myGround);
						myGround.x = myGround.width/2 + CellSize * i;
						myGround.y = myGround.height/2 + CellSize * (j-12);
						myBlocksArray.push(myGround);
					}
					
					if(Level[j][i] == 12)
					{
						var myGround : Ground = new Ground();
						myGround.gotoAndStop('Border');
						ScrollingController.addChild(myGround);
						myGround.x = myGround.width/2 + CellSize * i;
						myGround.y = myGround.height/2 + CellSize * (j-12);
						myBlocksArray.push(myGround);
					}
					
					if(Level[j][i] == 13)
					{
						var myGround : Ground = new Ground();
						myGround.rotation = 90;
						ScrollingController.addChild(myGround);
						myGround.x = myGround.width/2 + CellSize * i;
						myGround.y = myGround.height/2 + CellSize * (j-12);
						myBlocksArray.push(myGround);
					}
					
					if(Level[j][i] == 14)
					{
						var myGround : Ground = new Ground();
						myGround.rotation = -90;
						ScrollingController.addChild(myGround);
						myGround.x = myGround.width/2 + CellSize * i;
						myGround.y = myGround.height/2 + CellSize * (j-12);
						myBlocksArray.push(myGround);
					}
					
					if(Level[j][i] == 2)
					{
						var myLadder : Ladder = new Ladder();
						ScrollingController.addChild(myLadder);
						myLadder.x = myLadder.width/2 + CellSize * i;
						myLadder.y = myLadder.height/2 + CellSize * (j-12);
						myLaddersArray.push(myLadder);
						
						var myPickUps : PickUps = new PickUps();
						ScrollingController.addChild(myPickUps);
						myPickUps.x = CellSize/2 + CellSize * i;
						myPickUps.y = CellSize/2 + CellSize * (j-12);
						myPickupsArray.push(myPickUps);
						
					}
					
					if(Level[j][i] == 3)
					{
						myPlayer = new Player(this);
						myPlayer.x = myPlayer.width/2 + CellSize * i;
						myPlayer.y = myPlayer.height/2 + CellSize * (j-12);
					}
					
					if(Level[j][i] == 4)
					{
						var myPickUps : PickUps = new PickUps();
						ScrollingController.addChild(myPickUps);
						myPickUps.x = CellSize/2 + CellSize * i;
						myPickUps.y = CellSize/2 + CellSize * (j-12);
						myPickupsArray.push(myPickUps);
						
					}
					
					if(Level[j][i] == 5)
					{
						var myEnemy : Enemy = new Enemy();
						myEnemy.x = CellSize/2 + CellSize * i;
						myEnemy.y =  CellSize/2 + CellSize * (j-12);
						myEnemiesArray.push(myEnemy);
						
						var myPickUps : PickUps = new PickUps();
						ScrollingController.addChild(myPickUps);
						myPickUps.x = CellSize/2 + CellSize * i;
						myPickUps.y = CellSize/2 + CellSize * (j-12);
						myPickupsArray.push(myPickUps);

					}
					
					if(Level[j][i] == 6)
					{
						PowerUp = true;
						myShootPowerUp = new ShootPowerUp();
						ScrollingController.addChild(myShootPowerUp);
						myShootPowerUp.x =  CellSize/2 + CellSize * i;
						myShootPowerUp.y =  CellSize/2 + CellSize * (j-12);
					}
					
					if(Level[j][i] == 7)
					{
						
						var myWaypoints : Waypoint = new Waypoint();
						myWaypointArray.push(myWaypoints);
						ScrollingController.addChild(myWaypoints);
						myWaypoints.x =  CellSize/2 + CellSize * i;
						myWaypoints.y =  CellSize/2 + CellSize * (j-12);
						
						var myPickUps : PickUps = new PickUps();
						ScrollingController.addChild(myPickUps);
						myPickUps.x = CellSize/2 + CellSize * i;
						myPickUps.y = CellSize/2 + CellSize * (j-12);
						myPickupsArray.push(myPickUps);
					
					}
					
					if(Level[j][i] == 8)
					{
						myDoor = new Door(this);
						myDoor.x =  CellSize/2 + CellSize * i;
						myDoor.y =  CellSize/2 + CellSize * (j-12);
						ScrollingController.addChild(myDoor);
					}
					
					if(Level[j][i] == 9)
					{
						var myDropEnemy = new DropEnemy();
						ScrollingController.addChild(myDropEnemy);
						myDropEnemy.x = CellSize/2 + CellSize * i;
						myDropEnemy.y = CellSize/2 + CellSize * (j-12);
						myDropEnemies.push(myDropEnemy);
						myDropEnemy.UpdateY(myDropEnemy.y);
						
					}
				}
			}

			ScrollingController.addChild(myPlayer);
			stage.addChild(ScrollingController);
			
			for(var i : int = 0 ; i < myEnemiesArray.length ; i++)
			{
				ScrollingController.addChild(myEnemiesArray[i]);
				myEnemiesArray[i].FindWaypoints();
			}
			
		}
		
		function ClearLevel()
		{
			
			for(var i : int = 0 ; i < myBlocksArray.length ; i++)
			{
				ScrollingController.removeChild(myBlocksArray[i]);
			}
			
			for(var i : int = 0 ; i < myLaddersArray.length ; i++)
			{
				
				if(ScrollingController.contains(myLaddersArray[i]))
				{
					ScrollingController.removeChild(myLaddersArray[i]);
				}
				
			}
			
			for(var i : int = 0 ; i < myEnemiesArray.length ; i++)
			{
				if(ScrollingController.contains(myEnemiesArray[i]))
				{
					myEnemiesArray[i].Destroy();
					ScrollingController.removeChild(myEnemiesArray[i]);
				}
			}
			
			for(var i : int = 0 ; i < myPickupsArray.length ; i++)
			{
				if(ScrollingController.contains(myPickupsArray[i]))
				{
					ScrollingController.removeChild(myPickupsArray[i]);
				}
			}
			
			for(var i : int = 0 ; i < myBulletsArray.length ; i++)
			{
				if(ScrollingController.contains(myBulletsArray[i]))
				{
					myBulletsArray[i].DestroyEvents();
					ScrollingController.removeChild(myBulletsArray[i]);
				}
			}
			
			for(var i : int = 0 ; i < myDropEnemies.length ; i++)
			{
				if(ScrollingController.contains(myDropEnemies[i]))
				{
					ScrollingController.removeChild(myDropEnemies[i]);
				}
			}
			
			if(PowerUp)
			{
				PowerUp = false;
				if(ScrollingController.contains(myShootPowerUp))
				{
					ScrollingController.removeChild(myShootPowerUp);
				}
				
			}
			
			if(MenuScreen)
			{
				MenuScreen = false;
				stage.removeChild(myText);
			}
			
			
			myDoor.Destroy();
			ScrollingController.removeChild(myDoor);
			myPlayer.Destroy();
			ScrollingController.removeChild(myPlayer);
			stage.removeChild(ScrollingController);
			
			if(currentLevel == myLevels.LevelsArray.length)
			{
				currentLevel = 0;
			}
			
			BuildLevel(myLevels.LevelsArray[currentLevel]);
			
		}
		
		function Loop(E:Event)
		{
			if(Scrolling)
			{
				ScrollingController.y += CellSize/80;
				maximumY -= CellSize/80;
				minimumY -= CellSize/80;
			}
		}
	}
	
}
