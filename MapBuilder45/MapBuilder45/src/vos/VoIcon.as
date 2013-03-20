package vos
{
	[Bindable]
	public class VoIcon
	{
		public function VoIcon(id:String,sr:String):void{
			this.label=id;
			this.icon=sr;
		}
		public var label:String;
		public var icon:String;
	}
}