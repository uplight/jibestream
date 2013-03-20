package mediators
{
	import editor.ZoomInMove;
	
	import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ZoomMoveMediator extends Mediator implements IMediator{
		public static const NAME:String="ZoomMoveMediator";
		public static const ZOOMP:String=NAME+"Zoomp";
		public static const ZOOMM:String=NAME+"Zoomm";
		public static const MOVE:String=NAME+"Move";
		public static const YAH:String=NAME+"YAH";
		
		private var view:ZoomInMove;
		public function ZoomMoveMediator(viewComponent:Object=null){
			super(NAME,viewComponent);
			this.view = viewComponent as ZoomInMove;
			facade.registerMediator(this);	
		}
		
		override public function listNotificationInterests():Array{
			return [
				MapHolderMediator.ZOOMCHANGED
				];
		}
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case MapHolderMediator.ZOOMCHANGED:
					this.view.myZoom(notification.getBody() as Number)
					break;
			}
		}
				
	}
}