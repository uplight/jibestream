package editor.path
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import spark.primitives.Line;
	
	import vos.VoDot;
	import vos.VoLine;
	
	public class MapModel extends EventDispatcher{
		
		public var objLines:Object
		public var objDots:Object
		public var spDots:Sprite;
		public var spLines:Sprite;
		protected var intNumber:int=0;
		public var strId:String;
		
		protected var container:Sprite;
		
		
		
		
		public function MapModel(xml:XML,cont:Sprite){
			var objD:Object= new Object
			var objL:Object= new Object
			var spD:Sprite = new Sprite;
			//var spL:Sprite = new Sprite;
			this.spLines = new Sprite;
			this.objLines=objL;
			this.objDots=objD;
			this.spDots=spD;
			this.container=cont;
			
			for each (var node:XML in xml.children()){
				var vo:VoDot=new VoDot(node.attribute('id'),node.attribute('x'),node.attribute('y'),Vector.<String>(String(node.attribute('join')).split(",")));
				objD[vo.id]=vo;
				var num:int=int(vo.id.substr(1));
				if(num>intNumber)intNumber=num;
				
				var n:int=vo.join.length
				for(var i:int =0; i<n;i++){
					var str:String=vo.join[i];
					if(objD[str]) {							
						this.addLine(objD[str] as VoDot,vo);  //   new VoLine(objD[str],vo)
						//objL[ln.id]=ln;
						//spL.addChild(ln);
					}
				}
				//trace(vo);
				spD.addChild(vo);			
			}
			this.strId=vo.id.substr(0,1);
			
			Registry.getInstance.hasChanges=false;
			
			
		}
		 public function addDot(x:int,y:int):VoDot{
			 
			var dot:VoDot = new VoDot(this.strId+(++this.intNumber).toString(),x,y,new Vector.<String>());
			this.objDots[dot.id]=dot;
			this.spDots.addChild(dot);
			return dot;
		}
		public function addDotCarefully(x:int,y:int):VoDot{
			for (var str:String in this.objDots){
				var dot:VoDot=this.objDots[str];
				if(Math.abs(dot.x-x)<10 && Math.abs(dot.y-y)<10){
				//	trace("found "+dot.x+"  "+x+ "   "+dot.y+"  "+y);
					return null;
				}
			}
			return this.addDot(x,y);
		}
		public function addLineCarefully(dot1:VoDot,dot2:VoDot):VoLine{
			if(dot1.join.indexOf(dot2.id)<0) dot1.join.push(dot2.id);
			if(dot2.join.indexOf(dot1.id)<0)dot2.join.push(dot1.id);
			return addLine(dot1,dot2);
		}
		public function addLine(dot1:VoDot,dot2:VoDot):VoLine{
					
			var ln:VoLine = new VoLine(dot1,dot2);
			this.objLines[ln.id]=ln;
			this.spLines.addChild(ln);
			Registry.getInstance.hasChanges=true;
			return ln;
		}
		public function getLine(dot1:VoDot,dot2:VoDot):VoLine{
			return this.objLines[dot1.id+'_'+dot2.id] || this.objLines[dot2.id+'_'+dot1.id] || null;
		}
		
		
		
		public function newDot(x:int,y:int,vec:Vector.<String>=null):VoDot{
			if(vec==null) vec= new Vector.<String>
			var dot:VoDot = new VoDot(this.strId+(++this.intNumber).toString(),x,y,vec);
			this.objDots[dot.id]=dot;
			this.spDots.addChild(dot);
			Registry.getInstance.hasChanges=true;
			return dot
		}
		
		public function deliteLine(line:VoLine):void{
			if(line){
				this.spLines.removeChild(line);
				delete objLines[line.id];
				Registry.getInstance.hasChanges=true;
			}
			
		}
		
		public function removeLinesToDot(dot:VoDot):Vector.<VoDot>	{
			var vecD:Vector.<VoDot> = new Vector.<VoDot>;
			var vec:Vector.<String>= dot.join;
			for each(var str:String in vec){
				var dot1:VoDot= this.objDots[str];
				vecD.push(dot1);
				deliteLine(this.getLine(dot1,dot));
		}
			
			return vecD;
		}
		
		public function addLinesToDot(dot1:VoDot, vecDots:Vector.<VoDot>):void{
			for each( var dot:VoDot in vecDots){
				addLine(dot,dot1);
			}
			
		}
		
		public function  deleteDotCarefully(dot:VoDot):void{
				var vec:Vector.<String>= dot.join;
				trace("deleteDotCarefully :"+dot.id+ " joins:  "+vec.toString() );
				for each(var str:String in vec){
					var dot1:VoDot = this.objDots[str];
					if(dot1){
						trace("Removing from :"+dot1.id);
						dot1.removeJoin(dot);
						deliteLine(getLine(dot1,dot));
					}else {
						trace(" deleteDotCarefully  no dot  " + str);
					}
					
					
				}
				
				deleteDot(dot);
				
		}
		
		private function deleteDot(dot:VoDot):void{
			
			this.spDots.removeChild(dot);
			delete this.objDots[dot.id];
			Registry.getInstance.hasChanges=true;
			
		}
		public function  deliteLineCarefully(ln:VoLine):void{
			var dot1:VoDot = ln.dot1
			var dot2:VoDot= ln.dot2;
			dot1.removeJoin(dot2);
			dot2.removeJoin(dot1);
			this.deliteLine(ln);
		}
		public  function deleteDotLeaveJoins(dot:VoDot):void{
			var dot1:VoDot= this.objDots[dot.join[0]];
			var dot2:VoDot= this.objDots[dot.join[1]];
			dot1.removeJoin(dot);
			dot2.removeJoin(dot);
			dot1.addJoin(dot2);
			dot2.addJoin(dot1);
			deliteLine(this.getLine(dot1,dot));
			deliteLine(this.getLine(dot2,dot));
			deleteDot(dot);
			addLine(dot1,dot2);
		}
	}
}