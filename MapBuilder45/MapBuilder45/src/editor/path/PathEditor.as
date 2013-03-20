package  editor.path
{
	import editor.MapHolder;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import mediators.PathEditorMediator;
	
	import spark.components.BorderContainer;
	import spark.components.Label;
	
	import vos.VoDot;
	//import fl.controls.Label;
	
	public class PathEditor extends Sprite{
		
		public static const NAME:String="PathEditor"
		public static const RESET:String=NAME+"Reset";
		
		private var dotsHolder:Sprite
		private var linesHolder:Sprite
		//private var drawingCanvas:Sprite;
				
		private var mainController:MainController= new MainController();
	//	private var controllerDraw:ControllerDraw = new ControllerDraw();
		//private var controllerLines:ControllerLines = new ControllerLines();
		private var mode:String='';
		public var txtHint:TextField = new TextField;
		
		private var overlay:Sprite = new Sprite();
		
		protected var objDots:Object;
		protected var objLines:Object;
		
		private var background:DisplayObject
		
		public  var ldrImage:Loader = new Loader
		protected var container:Sprite= new Sprite;;
		
		public function PathEditor(){
			super();
			Registry.getInstance.dispatcherGlobal.addEventListener(RESET,onResetEvent);
			Registry.getInstance.dispatcherGlobal.addEventListener(DataEvent.DATA,onMenuClicked);
			
			this.addEventListener(Event.ADDED_TO_STAGE,thisADDED);
			this.addEventListener(Event.REMOVED_FROM_STAGE,thisREMOVED);
				
			dotsHolder=new Sprite
			this.addChild(dotsHolder);
			linesHolder= new Sprite;
			this.addChild(linesHolder);
			
			this.txtHint.width=50;
			this.txtHint.height=30;
			this.txtHint.mouseEnabled=false;
			
			
			this.addChild(this.ldrImage);
			this.addChild(this.txtHint);
			
		}
		
		protected function onMenuClicked(event:DataEvent):void{
			this.mode=event.data;
			setTimeout(setCurentMode,100);
		}
		
		protected function onResetEvent(event:Event):void{
			this.mainController.resetMode();
			
		}		
		
		public var hasChanges:Boolean=false;
		
		//public function setMode(str:String):void{
			//trace(NAME+" setMode "+str);
			//resetMode();
			//this.mode=str;
			//setTimeout(setCurentMode,100);
		//}
			protected function setCurentMode():void{
				switch(this.mode){
					case "cutline":
						mainController.resetMode()
						mainController.setMode(MainController.CUTLINE)
					break;
					case "make":
						mainController.resetMode();
						mainController.setMode(MainController.MAKE);
						break
					case 'imgdelete':
						mainController.resetMode()
						mainController.setMode(MainController.DELETE);
						
						break;
					case MainController.MOVEDOT:
						mainController.resetMode()
						mainController.setMode(MainController.MOVEDOT);
						break;
					case "setpolar":
						this.lblAngle.text="0";
						this.mainController.setAngle(180);
						this.mainController.isPolar=true;
						stage.addEventListener(KeyboardEvent.KEY_UP,onKeyPolarUp);
						break;
					case "rempolar":
						this.mainController.setAngle(180);
						this.mainController.isPolar=false;
						stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyPolarUp);
						this.lblAngle.text="";
						break;
					
					
					default:
						mainController.resetMode();
						break;
				
				
			}
			
			
		}
		
			
		public function getMapAsString():String{
			var allDots:Object= this.mainController.getAllDots();
			
			var xml:XML= <body />;
			xml.@dbid=this.mainController.getMapId();
			for(var str:String in allDots){
				var dot:VoDot= allDots[str];
				var node:XML = <node/>;
				node.@id=dot.id;
				node.@x=dot.x;
				node.@y=dot.y;
				node.@join=dot.join.toString();
				xml.appendChild(node);
			}
			//trace("save XML:   "+xml) 
			return xml.toXMLString();
		}
		protected function thisREMOVED(event:Event):void{
			trace("Patheditor removed");
			
		}
		
		protected function thisADDED(event:Event):void{
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			
		}
		private function onKeyUp(evt:KeyboardEvent):void{
			trace(evt.keyCode);
			switch(evt.keyCode){
				case 27:
					this.mainController.resetMode();
					break;
				
			}
		}
		protected function onKeyPolarUp(evt:KeyboardEvent):void{
			
			switch(evt.keyCode){
				case 96:
					this.angle+="0"
					this.lblAngle.text=this.angle;
					break;
				case 97:
					this.angle+="1"
					this.lblAngle.text=this.angle;
					break;
				case 98:
					this.angle+="2"
					this.lblAngle.text=this.angle;
					break;
				case 99:
					this.angle+="3"
					this.lblAngle.text=this.angle;
					break;
				case 100:
					this.angle+="4"
					this.lblAngle.text=this.angle;
					break
				case 101:
					this.angle+="5"
					this.lblAngle.text=this.angle;
					break;
				case 102:
					this.angle+="6"
					this.lblAngle.text=this.angle;
					break;
				case 103:
					
					this.angle+="7"
					this.lblAngle.text=this.angle;
					break;
				case 104:
					this.angle+="8"
					this.lblAngle.text=this.angle;
					break;
				case 105:
					this.angle+="9"
					this.lblAngle.text=this.angle;
					break;
				case 13:
					var ang:int=int(this.angle);
					if(ang<180 && ang>=0){
							this.mainController.setAngle(180-ang);
					}
					
					this.angle="";
					return;
					break;
			}
			
		}
		protected var angle:String="";
		private var lblAngle:Label;
		
		
		public function  setAnglelabel(lbl:Label):void{
			this.lblAngle=lbl;
		}
		
		
		public function buildMap(xml:XML):void{
			mainController.resetMode();
			var sprt:Sprite = new Sprite
			mainController.createDots(xml,sprt);
			if(this.contains(this.container)) removeChild(this.container);
			this.addChild(sprt);
			this.container=sprt;
			
		}
			
		
		public function setRoot(param0:BorderContainer):void{
			
			mainController.setRoot(param0);			
		}
		
		public function setIndicator(indicator:Label):void{			
			this.mainController.setIndicator(indicator);
			
		}
	}
}