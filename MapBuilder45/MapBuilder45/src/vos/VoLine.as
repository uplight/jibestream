package vos
{
	import flash.display.Sprite;

	public class VoLine extends Sprite
	{
		public var dot1:VoDot;
		public var dot2:VoDot;
		public var id:String;
		public function VoLine(vo1:VoDot,vo2:VoDot){
			this.name=vo1.id+"_"+vo2.id;
			this.id=vo1.id+"_"+vo2.id
			this.dot2=vo2;
			this.dot1=vo1;
			this.graphics.lineStyle(1.0,VoDot.color);
			this.graphics.moveTo(vo1.x,vo1.y);
			this.graphics.lineTo(vo2.x,vo2.y);
			
		}
		
	}
}