package models
{
	import flash.net.Responder;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ItemsDataProxy extends Proxy implements IProxy
	{
		public static const NAME:String="ItemsData"
		
		private var dataRes:Responder = new Responder(dataResult,onFault)
		public function ItemsDataProxy()	{
			super(NAME);	
			Registry.getInstance.connector.call("MapBuilder.loadSaveItems",dataRes,null);
		}
		
		private function dataResult(obj:Object):void{
			trace(NAME+"                    dataResult");
				this.data=obj;
		}
		
		private function onFault(obj:Object):void{
						
		}
	}
}