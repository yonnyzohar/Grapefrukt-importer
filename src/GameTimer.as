package src
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.*;

	
	public class  GameTimer extends Sprite
	{
		private var users:Array = new Array();
		static private var instance:GameTimer = new GameTimer();
		
		public function GameTimer()
		{
			if (instance)
			{
				throw new Error("Singleton and can only be accessed through Singleton.getInstance()");
			}
		}
		
		public static function getInstance():GameTimer
		{
			return instance;
		}
		
		
		public function addUser(mc:*):void
		{
			var oldLength:int = users.length;
			
			if (users.indexOf(mc) == -1)
			{
				users.push(mc);
			}
			
			var newLength:int = users.length;
			
			if (oldLength == 0 && newLength == 1)
			{
				addEventListener(Event.ENTER_FRAME, go);
			}
		}
		
		public function removeUser(mc:*):void
		{
			var oldLength:int = users.length;
			
			if (users.indexOf(mc) != -1)
			{
				users.splice(users.indexOf(mc), 1);
			}
			
			var newLength:int = users.length;
			
			
			if (oldLength == 1 && newLength == 0)
			{
				removeEventListener(Event.ENTER_FRAME, go);
			}
		}
		
		private function go(e:Event):void 
		{
			trace("go!");
			
			for(var i:int = 0; i < users.length; i++)
			{
				users[i].update();
			}
			
		}
	}
	
}