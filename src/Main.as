package src
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import src.AnimationNode;
	import src.AnimationNodeMatrix;
	

	public class Main extends Sprite 
	{
		CONFIG::bob
        {
			trace("THIS IS BOB!!!!!!!!");
		}
		
		private var sheetXML:XML;
		private var currentSheetName:String;
		private var playList:XMLList;
		private var totalFiles:int;
		
		private var sheetArray:Array = new Array();
		private var count:int = 0;
		private var wrapper:Sprite = new Sprite();
		private var gameTimer:GameTimer = GameTimer.getInstance();
		
		private var frameCount:int;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			loadSheetXML();
		}
		
		private function loadSheetXML():void 
		{
			
			
			var l:URLLoader = new URLLoader();
			l.addEventListener(Event.COMPLETE, onComplete);
			l.load(new URLRequest("lib/sheets.xml"));
			
			
		}
		
		private function onComplete(e:Event):void 
		{
			sheetXML = new XML(e.target.data);
			
			currentSheetName = sheetXML.TextureSheet.@name;
			
			playList = sheetXML.TextureSheet.Texture;
			
			totalFiles = playList.length();
			
			for(var i:int = 0; i < totalFiles; i++)
			{
				var o:AnimationNode = new AnimationNode();
				//var o:AnimationNodeMatrix = new AnimationNodeMatrix();
				
				o.assetName = playList[i].@name;
				o.assetWidth = playList[i].@width;
				o.assetHeight = playList[i].@height;
				o.path = playList[i].@path;
				o.registrationPointX = playList[i].@registrationPointX;
				o.registrationPointY = playList[i].@registrationPointY;
				o.zIndex = playList[i].@zIndex;
				o.spriteSheet = false;
				
				if (playList[i].@frameCount)
				{
					o.spriteSheet = true;
					o.frameCount  = playList[i].@frameCount;
					o.frameWidth  = playList[i].@frameWidth;
					o.frameHeight = playList[i].@frameHeight;
					o.columns     = playList[i].@columns;
				}
				
				sheetArray.push(o);
			}
			
			loadInAnimXML();
		}
			
		
		private function loadInAnimXML():void 
		{
			var l:URLLoader = new URLLoader();
			l.addEventListener(Event.COMPLETE, onAnimXMLComplete);
			l.load(new URLRequest("lib/animations.xml"));
		}
		
		private function onAnimXMLComplete(e:Event):void 
		{
			sheetXML = new XML(e.target.data);
			
			frameCount = sheetXML.Animation.@frameCount;
			
			playList = sheetXML.Animation.Part;
			totalFiles = playList.length();
			
			for(var i:int = 0; i < totalFiles; i++)
			{
				var partName:String = playList[i].@name;
				
				for (var j:int = 0; j <  sheetArray.length; j++ )
				{
					if (partName == sheetArray[j].assetName)
					{
						trace("before lst");
						var lst:XMLList = playList[i].Frame;
						trace("lst: " + lst);
						sheetArray[j].parseFrames(lst);
						break;
					}
				}
				
				trace("===============================");
			}
			
			displayAnim();
			
		}
		
		private function displayAnim():void 
		{
			var j:int = 0;
			trace("WILL NOW DISPLAY ANIM!");
			addChild(wrapper);
			wrapper.x = stage.stageWidth / 2;
			wrapper.y = stage.stageHeight / 2;

			
			for (j = 0; j <  sheetArray.length; j++ )
			{
				wrapper.addChild(sheetArray[j]);
			}
			
			count = 0;
			
			for (j = 0; j <  sheetArray.length; j++ )
			{
				var mc:AnimationNode = AnimationNode(sheetArray[j]);
				//var mc:AnimationNodeMatrix = AnimationNodeMatrix(sheetArray[j]);
				
				wrapper.addChildAt(mc, mc.zIndex );
					
				sheetArray[j].playAnim(count);
			}
					
			stage.addEventListener(MouseEvent.CLICK, playAnim)
		}
		
		private function playAnim(e:MouseEvent = null):void 
		{
			for (var j:int = 0; j <  sheetArray.length; j++ )
			{
				sheetArray[j].curIndex = 0;
				sheetArray[j].innerIndex = 0;
			}

			stage.removeEventListener(MouseEvent.CLICK, playAnim);
			
			gameTimer.addUser(this);
		}
		
		public function update():void
		{
			if (count < frameCount)
			{
				var j:int = 0;
			
				for (j = 0; j <  sheetArray.length; j++ )
				{
					sheetArray[j].playAnim(count);
				}
				
				count++;
			}
			else
			{
				trace("ANIM Done");
				count = 0;
				playAnim();
				//gameTimer.removeUser(this);
				//stage.addEventListener(MouseEvent.CLICK, playAnim)
			}
		}
	}
}