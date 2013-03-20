package mediators
{
	import editor.PathTools
	
	import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PathToolsMediator extends Mediator implements IMediator{
		public static const NAME:String="PathToolsMediator";
		public static const DRAW:String=NAME+"Draw";
		public static const ADDDOT:String=NAME+"adddot";
		public static const REMOVEDOT:String=NAME+"RemoveDot";
		public static const JOIN:String=NAME+"Join";
		public static const MOVEDOT:String=NAME+"Draw";
		//public static const ADDDOT:String=NAME+"adddot";
		//public static const REMOVEDOT:String=NAME+"RemoveDot";
		//public static const JOIN:String=NAME+"Join";
		
		
		private var view:PathTools;
		public function PathToolsMediator(viewComponent:Object=null){
			super(NAME,viewComponent);
			this.view = viewComponent as PathTools;
			viewComponent.mediator=this;
			facade.registerMediator(this);	
		}
		
		override public function listNotificationInterests():Array{
			return [
				
				];
		}
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case MapHolderMediator.ZOOMCHANGED:
					
					break;
			}
		}
				
	}
}