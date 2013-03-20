package vos
{
	import flash.display.Sprite;
	
	public class VoDot extends Sprite{	
				
		public var join:Vector.<String>
		public var id:String;
		public static var color:int= 0x000000;
		
		public function VoDot(id:String,x:int,y:int,ar:Vector.<String>):void{
			super();
			this.x=x;
			this.y=y;
			this.id=id;
			this.name=id;
			this.join=ar;
			this.graphics.beginFill(color);
			this.graphics.drawCircle(0,0,3);
			this.graphics.endFill();
		}
		
		public function removeJoin(dot:VoDot):Boolean{
			var i:int= this.join.indexOf(dot.id);
			var have:Boolean=(i>-1);
			if(have) this.join.splice(i,1);
			return have;
		}
		
		public function addJoin(dot:VoDot):void{
			if(this.join.indexOf(dot.id)<0) this.join.push(dot.id);
			
		}
	}
}