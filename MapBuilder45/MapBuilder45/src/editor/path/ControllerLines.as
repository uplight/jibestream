package editor.path
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import vos.VoDot;
	import vos.VoLine;
	

	public class ControllerLines  {
		
		protected var model:MapModel
		protected var container:Sprite;
		public function ControllerLines(model:MapModel,cont:Sprite):void{
			this.model=model;
			this.container=cont;
		}
		
		
		public function cutLine(mouseX:int,mouseY:int,line:VoLine):VoDot{
			
			var objDots:Object = model.objDots;
			var objLines:Object = model.objLines;
			
			var dot1:VoDot=line.dot1;
			var dot2:VoDot=line.dot2;
			dot1.join.splice(dot1.join.indexOf(dot2.id),1);
			dot2.join.splice(dot2.join.indexOf(dot1.id),1);
		
			var pt1:Point = new Point(dot1.x,dot1.y);
			var pt2:Point = new Point(dot2.x,dot2.y);
			var pt3:Point = new Point(mouseX,mouseY);
			var dist1:Number= Point.distance(pt1,pt2);
			var dist2:Number= Point.distance(pt2,pt3);
			var f:Number=dist2/dist1;
			pt3 = Point.interpolate(pt1,pt2,f);
			
			var vec:Vector.<String> = new Vector.<String>;
			vec.push(dot1.id,dot2.id);			
			var dot3:VoDot = model.newDot(pt3.x,pt3.y,vec);
					
			model.deliteLine(line);
			model.addLineCarefully(dot1,dot3);
			model.addLineCarefully(dot2,dot3);
			
			return dot3;
			
		}
		
	//	public static const LINECLICKED:String="Lineclicked";
	//	public var controllerDots:MainController;
		//public  var objLines:Object
		//private var containerLines:Sprite
		//private var _currentLine:Sprite
		//private var selectedItem:Sprite;
		//private var interactive:Sprite;
		////private var drawLayer:Sprite;
		//private var container:Sprite = new Sprite;
				
		//public function LinesController():void{
			//drawLayer= new Sprite
			//drawLayer.name="Draw Layer";
			///this.containerLines=new Sprite;		
		//}
		
		/*
		protected function lineClick(event:MouseEvent):void	{
			
			var ar:Array= this.selectedItem.name.split(",");
			var dot:VoDot = controllerDots.addDotBetween(event.localX,event.localY,ar[0],ar[1]);
			this.containerLines.removeChild(this.selectedItem);
			
			var ar2:Array = dot.joins
			//var dot1:VoDot = controllerDots.objDots[ar[0]];
			var sp:Sprite=	createLine( dot,controllerDots.objDots[ar2[0]],objLines);
			objLines[sp.name]=sp;
			this.containerLines.addChild(sp);
			
			sp= createLine(dot,controllerDots.objDots[ar2[1]],objLines);
			
			objLines[sp.name]=sp;
			this.containerLines.addChild(sp);
			
			delete	objLines[this.selectedItem.name];
			
			trace("Line Click");
		}
		public function addOverEffect():void{
			if(!this.containerLines.hasEventListener(MouseEvent.MOUSE_OVER)) this.containerLines.addEventListener(MouseEvent.MOUSE_OVER,lineMouseOver);
		}
		protected function lineMouseOver(event:MouseEvent):void{
			var sp:Sprite= event.target as Sprite;
			if(sp || objLines[sp.name])selectLine(sp.name)	
		}
		private function selectLine(str:String):void{
			var ar:Array=str.split(",");
			var p1:String=ar[0];
			var p2:String=ar[1];
			var obj:Object=controllerDots.objDots;
			this.selectedItem=this.containerLines.getChildByName(str) as Sprite;
			var sp:Sprite = this.drawLayer;
			sp.graphics.clear();
			sp.graphics.lineStyle(2,0x00FF00);
			sp.graphics.moveTo(obj[p1].x,obj[p1].y);
			sp.graphics.lineTo(obj[p2].x,obj[p2].y);
			clearTimeout(intDelay);
			intDelay= setTimeout(makeBlack,2000);
			
		}
		private function makeBlack():void{
			this.drawLayer.graphics.clear();
		}
		public function removeOverEffect():void{
			this.containerLines.removeEventListener(MouseEvent.MOUSE_OVER,lineMouseOver);
		}
		public function makeNewLine():void{
			
		}
		public function drawLineBetween(dot1:VoDot,dot2:VoDot):Boolean{
			if(dot1.id==dot2.id || this.objLines[dot1.id+","+dot2.id]!=null ||  this.objLines[dot2.id+","+dot1.id]!=null) return false;
			var sp:Sprite= new Sprite
			sp.graphics.lineStyle(1);
			sp.graphics.moveTo(dot1.x,dot1.y);
			sp.graphics.lineTo(dot2.x,dot2.y);
			sp.name=dot1.id+","+dot2.id;
			this.objLines[dot1.id+","+dot2.id]=sp;
			this.containerLines.addChild(sp);
			return true;
		}
		
		private function createLine(vo1:VoDot,vo2:VoDot,collection:Object):Sprite{
			
			var sp:Sprite= new Sprite
			sp.graphics.lineStyle(1);
			sp.graphics.moveTo(vo1.x,vo1.y);
			sp.graphics.lineTo(vo2.x,vo2.y);
			var str:String=vo1.id+","+vo2.id;
			collection[str]=sp;
			sp.name=str;
			return 	sp
		}
		public function startDrawLine(dot:VoDot):void{
			xStart=dot.x;
			yStart=dot.y;
			trace("startDrawLine:  "+xStart+"  "+yStart);
		//	drawLayer.stage.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDOWN);
			//drawLayer.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUP);
			//drawLayer.stage.addEventListener(MouseEvent.MOUSE_OUT,onMouseUP);
			drawLayer.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		public function activateClick():void{
			drawLayer.addEventListener(MouseEvent.CLICK,drawLayerClick);
		}
		private function drawLayerClick(evt:MouseEvent):void{
			this.dispatchEvent(new Event(LINECLICKED));
			//trace("ControllerLines.drawLayerClick: "+evt.target.name);
			//trace("ControllerLines.drawLayerClick: "+evt.currentTarget.name);
		}
		private function onMouseMove(evt:MouseEvent):void{
			//trace("onMouseMove  "+ xStart+"  "+yStart+"  "+evt.localX+"  "+evt.localY);
			drawLayer.graphics.clear();
			drawLayer.graphics.lineStyle(1.0,0x00FF00);
			drawLayer.graphics.moveTo(xStart,this.yStart);
			drawLayer.graphics.lineTo(drawLayer.mouseX,drawLayer.mouseY);
		
		}
		
		public function stopDrawLine():void{
			drawLayer.graphics.clear();
			drawLayer.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		private var xStart:Number;
		private var yStart:Number;
	
		public function drawLines(obj:Object):Sprite{
			this.container= new Sprite
			this.containerLines = new Sprite
			
			//sprt.graphics.lineStyle(1);
			this.objLines= new Object()
			for (var str:String in obj){
				var vo:VoDot= obj[str]
				var ar:Array= vo.joins;
				var n:int=ar.length;
				for(var i:int=0;i<n;i++){
						var vo1:VoDot= obj[ar[i]];
						if(objLines[vo1.id+","+vo.id]) continue;
						drawLineBetween(vo,vo1);
					
				}
				
			}
			
			this.container.addChild(this.containerLines);
			this.container.addChild(drawLayer);
			//this.objLines=objLines;
			return this.container;
		}
			
		private var intDelay:int;
		
		
		public function cutLineMode():void{
			drawLayer.addEventListener(MouseEvent.CLICK,lineClick);
			
		}
		
		
		public function reset():void{
			this.selectedItem=null;
			this.containerLines.removeEventListener(MouseEvent.MOUSE_OVER,lineMouseOver);
			drawLayer.removeEventListener(MouseEvent.CLICK,lineClick);
			stopDrawLine()
		}
		*/
	}
}