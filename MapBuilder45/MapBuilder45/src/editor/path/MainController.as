package editor.path
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	
	import mx.events.CloseEvent;
	
	//import org.puremvc.as3.core.Controller;
	
	import spark.components.BorderContainer;
	import spark.components.Label;
	
	import vos.VoDot;
	import vos.VoLine;
	

	public class MainController extends EventDispatcher	{
		
		
		public static const NAME:String="ControllerDots";
		public static const DOTCLICKED:String=NAME+"DotClicked";
		
		private var voCurrent:VoDot;
		//private var  strId:String;
		
		// public var selectedSprite:Sprite;
		 public var selectedDot:VoDot;
		private var container:Sprite;
		private var drawLayer:DrawLayer = new DrawLayer
			
		//protected var spDots:Sprite;
		
		public var txtHint:TextField;
		public var controllerLines:ControllerLines
				
		//public var objDots:Object;
		//public var objLines:Object;
		
		protected var model:MapModel
		protected var glGreen:GlowFilter = new GlowFilter(0x00FF00,1.0,6,6,2,1,true);
		
		protected var txtIndicator:Label
		
		public static const CUTLINE:String="cutline"
		public static const DOT:String="dot";
		public static const MAKE:String="make";
		protected const MAKING:String="makingLine";
		public static const MOVEDOT:String="movedot";
		public static const DELETE:String="delete"
			
			
		private var intNumber:int=1;
		
		public function MainController(){
			
		}
		public function setIndicator(txt:Label):void{
			txtIndicator=txt;
		}
		
		
		
		
		public function setRoot(param0:BorderContainer):void{
			this.myRoot=param0
			
		}
		
		protected var myRoot:BorderContainer
		
		public function createDots(xml:XML,cont:Sprite):void{
			model=new MapModel(xml,cont);
			this.drawLayer.mouseChildren=false;
			
			cont.addChild(model.spLines);
			cont.addChild(this.drawLayer);
			cont.addChild(model.spDots);
			
			container=cont;
			this.controllerLines= new ControllerLines(model,cont);
		}
		
		protected function hiliteSprite(sp:Sprite):void{
			spSelected=sp;
			sp.filters=[this.glGreen];
		}
		
		
		public function resetMode():void{
			if(this.container== null || this.container.stage==null) return;
			switch(this.mode){				
				case MOVEDOT:
					model.spDots.removeEventListener(MouseEvent.MOUSE_DOWN,moveDotMouseDown);
					removeOverDots()
					break;
				case DELETE:
					removeOverAll()
					this.model.spDots.removeEventListener(MouseEvent.CLICK,onDeleteCLICK)
					this.model.spLines.removeEventListener(MouseEvent.CLICK,onDeleteCLICK)
					this.spSelected=null;
					break;
				case MAKE:
					this.container.stage.removeEventListener(MouseEvent.CLICK,onMakeStageCLICK);
					removeOverAll();
					this.container.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMakingLineMouseMove);
					this.container.stage.removeEventListener(MouseEvent.CLICK,makeLineToNewDot);
					this.drawLayer.graphics.clear();
					break;
				case MAKING:
					this.mode=MAKE;
					this.container.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMakingLineMouseMove);
					this.container.stage.removeEventListener(MouseEvent.CLICK,makeLineToNewDot);
					this.container.stage.addEventListener(MouseEvent.CLICK,onMakeStageCLICK);
					addOverLines();
					this.drawLayer.graphics.clear();
					break;
				
			}
			this.modeCurrent="";
		}
		
		
		public function setMode(str:String):void{
			trace(this+ "  setMode: "+str);
			//resetMode();
			this.mode=str;
			switch(str){
				case MOVEDOT:
					addOverDots()
					model.spDots.addEventListener(MouseEvent.MOUSE_DOWN,moveDotMouseDown);
					this.mode=MOVEDOT;
					break;
				case DELETE:
					addOverAll();
					this.model.spDots.addEventListener(MouseEvent.CLICK,onDeleteCLICK);
					this.model.spLines.addEventListener(MouseEvent.CLICK,onDeleteCLICK);
					//this.modeCurrent=DELETE
					break;
				case MAKE:
					addOverAll();
					this.container.stage.addEventListener(MouseEvent.CLICK,onMakeStageCLICK);
				
					break;
			}
			
		}
		
		
		
		protected function onMakeStageCLICK(event:MouseEvent):void{
			event.stopPropagation();
			var dot:VoDot=event.target as VoDot
				
			if(event.target is VoLine) 	dot=controllerLines.cutLine(event.localX,event.localY,event.target as VoLine);
			else if(!dot ) {
				if(event.target is DrawLayer || event.target is Loader)	dot= model.addDotCarefully(event.localX,event.localY);
			}
				
			if(dot)	startAddingLineToDot(dot);
				
			//trace("   onMakeStageCLICK :"+event.target);
			
		}
			
		 
		protected function makeLineToNewDot(event:MouseEvent):void{
			trace("makeLineToNewDot: "+event.target)
			
			var dot:VoDot= event.target as VoDot;
			if(!dot) if(event.target is DrawLayer || event.target is Loader){
				var pt:Point
				if(isPolar) pt= secPoint(this.container.mouseX,this.container.mouseY);
				else pt= new Point(this.container.mouseX,this.container.mouseY);
				
				dot= this.model.addDotCarefully(pt.x,pt.y)
			}
			if(!this.dotSelected || !dot)return;
				
			this.model.addLineCarefully(this.dotSelected,dot);
			this.dotSelected=dot;
			this.ptStart= new Point(dot.x,dot.y)
			
			
		}
		private function startAddingLineToDot(dot:VoDot):void	{
			this.mode= MAKING;
			this.dotSelected=dot;
			this.ptStart= new Point(dot.x,dot.y)
			
			this.container.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMakingLineMouseMove);
			this.container.stage.addEventListener(MouseEvent.CLICK,makeLineToNewDot);
			this.container.stage.removeEventListener(MouseEvent.CLICK,onMakeStageCLICK);		
			
			removeOverLines();
			
		
		}
		private const ANG45:Number=45 * Math.PI / 180;
		private const ANG135:Number=135 * Math.PI / 180
		
		protected var angle:Number=180;
		
		public var isPolar:Boolean;
		
		public function setAngle(num:int):void{
			trace(this+" setAngle   "+num)
			this.angle=num * Math.PI / 180;
		}
		
		
		protected function secPoint(x:Number,y:Number):Point{
			var p2:Point= new Point(x,y);
			var p1:Point =this.ptStart;
			var dist:Number=Point.distance(p1,p2);
			if((this.angle>ANG45) && (this.angle<ANG135))	dist=p2.y>p1.y?dist:-dist;
			else if(this.angle>=ANG135) dist=p2.x<p1.x?dist:-dist;
			else if (this.angle<=ANG45) dist=p2.x>p1.x?dist:-dist;
			
			return Point.polar(dist,this.angle).add(p1);
		}
		
		protected function onMakingLineMouseMove(event:MouseEvent):void{
			this.drawLayer.graphics.clear();
			this.drawLayer.graphics.lineStyle(1.0,0x00FF00);
			this.drawLayer.graphics.moveTo(this.ptStart.x,this.ptStart.y);
				if(this.isPolar){
					var p2:Point=secPoint(this.container.mouseX,this.container.mouseY)
					this.drawLayer.graphics.lineTo(p2.x,p2.y);
				}else this.drawLayer.graphics.lineTo(this.container.mouseX,this.container.mouseY);
				
							
		}
		
		
		/*
		
		private function getSecF(p1:Point,p2:Point):Point{
			var ang:Number = Math.atan2(p2.y-p1.y,p2.x-p1.x)
			var dist:Number = Point.distance(p1,p2);
			var d:int = Math.round(dist/step);
			dist=d*step;
			//dist=((p2.y-p1.y)>0)?dist:-dist;
			
			return Point.polar(dist,ang).add(p1);
		}
		private function getSecH(p1:Point,p2:Point):Point{
			var dist=p2.x-p1.x;
			var d:int = Math.round(dist/step);
			//dist=((p2.y-p1.y)>0)?dist:-dist;
			var point = new Point(p1.x+(d*step),p1.y);
			return point;
		}
		private function getSecV(p1:Point,p2:Point):Point{
			var d:int = Math.round((p2.y-p1.y)/step);
			var point = new Point(p1.x,d*step+p1.y);
			return point;
		}
		private function getSecP(p1:Point,p2:Point):Point{
			
			var dist:Number = Point.distance(p1,p2);
			var d:int = Math.round(dist/step);
			dist=d*step;
			dist=((p2.y-p1.y)>0)?dist:-dist;
			var point = Point.polar(dist,angle).add(p1);
			return point;
		}
		*/
		
		///////////////////////////////////////////////////////////////////////////////
		private var selectedItem:Object;
		
		protected function onDeleteCLICK(event:MouseEvent):void{
			selectedItem=event.target;
			var dot:VoDot= event.target as VoDot
				if(dot){
					
					if(dot.join.length==2){
						Alert.show("You want to delete Dot "+dot.id+" ?",{buttons:["Yes, with Joins","Yes, leave Joins","Cancel"],callback:onDeleteClose,colour:0xAAAAAA});
					}else	Alert.show("You want to delete Dot "+dot.id+" ?",{buttons:["Delete","Cancel"],callback:onDeleteClose,colour:0xAAAAAA});
				}else {
					var ln:VoLine= event.target as VoLine;
					if(ln) Alert.show("You want to delete Line Between Dots "+ln.id.split("_").join(" ")+" ?",{buttons:["Delete","Cancel"],callback:onDeleteClose,colour:0xAAAAAA});
				}
				
				
			//Alert.show("You want to delete "+((this.selectedItem as VoDot)?"Dot ":"Line ")+this.selectedItem.id +" ?",{buttons:["","Yes with joins","Cancel"]callback:onDeleteClose});
			//Alert.show("You want to delete "+((this.selectedItem as VoDot)?"Dot ":"Line ")+this.selectedItem.id +" ?", | Alert.NO,this.myRoot,onDeleteClose);
			
		}
		
		private function onDeleteClose(str:String):void	{
			trace(str);
			if(str=="Yes, leave Joins"){
				
				var dot:VoDot = this.selectedItem as VoDot;
				this.model.deleteDotLeaveJoins(dot);
			}else if(str=="Delete" || str=="Yes, with Joins"){
				var ln:VoLine= this.selectedItem as VoLine;
				if(ln)	this.model.deliteLineCarefully(ln);
				var dot:VoDot = this.selectedItem as VoDot;
				if(dot) this.model.deleteDotCarefully(dot);
			}
			
			
			
		}		
		
		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		protected function removeOverAll():void{
			removeOverDots()
			removeOverLines()
		}
		protected function addOverAll():void{
			addOverDots();
			addOverLines();
		}
		protected function addOverDots():void{
			this.model.spDots.addEventListener(MouseEvent.MOUSE_OVER,onOver)
			this.model.spDots.addEventListener(MouseEvent.MOUSE_OUT,onOut)
		}
		protected function addOverLines():void{
			this.model.spLines.addEventListener(MouseEvent.MOUSE_OVER,onOver)
			this.model.spLines.addEventListener(MouseEvent.MOUSE_OUT,onOut)
		}
		
		protected function onOut(evt:MouseEvent):void{
			if(this.spSelected) this.spSelected.filters=[];
			this.spSelected=null;
			var sp:Sprite= evt.target as Sprite;
			if(sp)	sp.filters=[];
			
		}
		protected function onOver(event:MouseEvent):void{
			if(event.target.hasOwnProperty('id'))this.txtIndicator.text=event.target.id;
		 if(this.spSelected) this.spSelected.filters=[];
		 this.spSelected=null
		 var sp:Sprite= event.target as Sprite;
		 if(sp){
			 sp.filters=[this.glGreen];
			 this.spSelected=sp;
		 }
			
		}
		protected function removeOverDots():void{
			this.model.spDots.removeEventListener(MouseEvent.MOUSE_OVER,onOver)
			this.model.spDots.removeEventListener(MouseEvent.MOUSE_OUT,onOut)
		}
		protected function removeOverLines():void{
			this.model.spLines.removeEventListener(MouseEvent.MOUSE_OVER,onOver)
			this.model.spLines.removeEventListener(MouseEvent.MOUSE_OUT,onOut)
		}
		///////////////////////////////////////////////////////////////////////////////////////////////////////////
				
		
	
		
		
		
	
		
		
		
		//protected function onStageMouseDOWN(event:MouseEvent):void{
			//this.container.stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMouseMove);
			
		//}
		
		protected function onMouseOUT(event:MouseEvent):void{
			if(spSelected)spSelected.filters=[];
			
		}
				
		
		protected var modeCurrent:String="";
		
		private  var mode:String;
		
		
		public var spSelected:Sprite;
		private var dotSelected:VoDot;
		private var ptStart:Point
		//private var yStart:int;
		
		
		
		/*
		protected function onMouseOver(event:MouseEvent):void{
			switch (modeCurrent){
				case CUTLINE:
					if(event.target is VoLine) hiliteSprite(event.target as Sprite);
					break;
				case MAKE:
					hiliteSprite(event.target as Sprite);
					//hiliteDot(event.target as VoLine);
					break;
					
			}
			//var sp::e= event.target as Sprite;
		//	if(sp || objLines[sp.name])selectLine(sp.name)	
			
		}
		
		public function removeOver():void{
			this.container.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.container.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOUT)
		}
		public function addOverEffectLines():void{
			
			
		}
				
		*/
			////////////////////////////Dot Move /////////////////////////////////////////////	
		protected function moveDotMouseUp(event:MouseEvent):void{
			this.drawLayer.graphics.clear();
			this.container.stage.removeEventListener(MouseEvent.MOUSE_UP,moveDotMouseUp);
			model.addLinesToDot(this.dotSelected,this.vecDots);	
			this.container.stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveDotMouseMove);
		}
		
		protected function moveDotMouseDown(event:MouseEvent):void	{
			var dot:VoDot= event.target as VoDot;
			if(dot){
				this.container.stage.addEventListener(MouseEvent.MOUSE_UP,moveDotMouseUp);
				this.dotSelected= dot;
				vecDots=model.removeLinesToDot(dot);
				this.container.stage.addEventListener(MouseEvent.MOUSE_MOVE,moveDotMouseMove);
			}
		}
		
		protected function moveDotMouseMove(event:MouseEvent):void	{
			this.drawLayer.graphics.clear();
			this.drawLayer.graphics.lineStyle(1.0,0x00FF00);
			this.dotSelected.x=this.container.mouseX;
			this.dotSelected.y=this.container.mouseY;
			var n:int=vecDots.length
				for(var i:int; i<n;i++){
					var dot:VoDot =vecDots[i];
					this.drawLayer.graphics.moveTo(dot.x,dot.y);
					this.drawLayer.graphics.lineTo(this.container.mouseX,this.container.mouseY)
				}
				this.drawLayer.graphics.endFill();
				
			
		}
		protected var vecDots:Vector.<VoDot>;
		
		public function getMapId():String{
			return model.strId;
		}
		public function getAllDots():Object{
			return this.model.objDots;
		}
	
		
	}
}