package mediators{
	
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import editor.path.PathEditor;
	
	public class PathEditorMediator extends Mediator implements IMediator
	{
		public static const NAME:String="PathEditorMediator";
		public static const LOADXMLMAP:String=NAME+"LoadXMLMap";
		
		
			
		private var view:PathEditor
		
	
		private var respGetMap:Responder = new Responder(respGetMapResult,onFault);
		
		public function PathEditorMediator(viewComponent:Object=null){
			super(NAME,viewComponent);
			this.view = viewComponent as PathEditor;
			facade.registerMediator(this);
					
		}
		override public function onRegister():void{
			
		}
		
		protected function loaderCOMPLETE(event:Event):void	{
			viewComponent.buildMap(new XML(event.target.data));
			
		}
		override public function listNotificationInterests():Array{
			 return [
				 LOADXMLMAP
				]
		}
		
		override public function handleNotification(notification:INotification):void{
			//trace(NAME+notification.getName());
			switch(notification.getName()){
				case LOADXMLMAP:
					loadMap(notification.getBody() as String);
					break;
			}
		}
		
		private function loadMap(str:String):void{
			///trace(NAME+"   MapBuilder.getMap"+str);
			Registry.getInstance.connector.call("MapBuilder.getMap",this.respGetMap,str);
			
			//this.reqMaps.url=str
			//this.ldrMaps.load(this.reqMaps);
		}
		private function respGetMapResult(obj:Object):void	{
		//trace(NAME+"   respGetMapResult:"+obj);
			this.view.buildMap(new XML(obj));
			
		}
		
		private function onFault(res:Object):void{
			trace(NAME+"   Fault:"+  res.description);
			
		}
		
	}
}