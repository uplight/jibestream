package mediators
{
		
	//import flash.display.DisplayObject;
	//import flash.events.Event;
	//import flash.events.EventDispatcher;
	//import flash.net.Responder;
	//import flash.net.URLLoader;
	//import flash.net.URLLoaderDataFormat;
	//import flash.net.URLRequest;
	//import flash.utils.ByteArray;
	
	import models.ProjectProxy;
	
	import mx.collections.ArrayList;
	import mx.utils.ObjectUtil;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import views.ListOfMaps;
	
			
	public class ListOfMapsMediator extends Mediator implements IMediator
	{
		public static const NAME:String="ListOfMapsMediator";
		public static const DATA:String=NAME+"Data";
		public static const SELECTED:String=NAME+"Selected";
		public static const NEWMAP:String=NAME+"NewMAP";
		public static const DELETE:String=NAME+"Delete";
		
			
		private var view:ListOfMaps
				
		
	//	private var baSave:Responder = new Responder(baSaved,onFault)
				
		//private var dataResponder:Responder = new Responder(dataResult,onFault);
		
		
		
		//private var ldrImage:URLLoader= new URLLoader();
		//private var reqImage:URLRequest = new URLRequest();
		
		public function ListOfMapsMediator(viewComponent:Object){			
			super(NAME,viewComponent);
			this.view = viewComponent as ListOfMaps;
			facade.registerMediator(this);
			
		}
		
		private function baSaved(obj:Object):void{
			trace(NAME+"baSaved"+ObjectUtil.toString(obj));
		}
	/*	
		protected function newDataReady(event:Event):void{
			var ba:ByteArray=view.data;
			var filename:String=view.filename;
			var label:String=view.label;
			Registry.instance.connector.call("MapBuilder.addImageMap",baSave,ba,filename,label);
		}
			
		*/
		
		private function onFault(res:Object):void
		{
			trace("Fault:"+  ObjectUtil.toString(res));
			
		}
		
		
		
		override public function onRegister():void{
			
		}
		
		
		override public function listNotificationInterests():Array{
			 return [
				ProjectProxy.GOTMAPS			
				]
		}
		
		override public function handleNotification(notification:INotification):void{
			//trace(NAME+notification.getName());
			switch(notification.getName()){
				case ProjectProxy.GOTMAPS:
					this.view.setData(notification.getBody() as ArrayList);
					break;
			}
		}
		
	
		
	}
}