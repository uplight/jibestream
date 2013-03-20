package vos
{
	[Bindable]	public class VoDataMap
	{
		public function VoDataMap(obj:Object):void{
			this.x=obj.x;
			this.y=obj.y;
			this.label=obj.label;
			this.p=obj.p;
			this.data=obj.data;
		}
		public var x:int
		public var y:int
		public var label:String
		public var p:String;
		public var data:String;
	}
}