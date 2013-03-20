package mediators
{
	import flash.display.DisplayObject;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import editor.MapHolder;

	public class MapHolderMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MapHolderMediator";
		public static const ADDCONTENT:String=NAME+"AddContent";
		public static const LOADIMAGE:String=NAME+"LoadImage";
		public static const ZOOMCHANGED:String=NAME+"ZoomChanged";
		
		
		
		private var view:MapHolder
		public function MapHolderMediator(viewComponent:Object=null){
			super(NAME, viewComponent);
			this.view=viewComponent as MapHolder;
			facade.registerMediator(this);
		}
		
		
		override public function listNotificationInterests():Array{
			return [
				ZoomMoveMediator.MOVE,
				ZoomMoveMediator.YAH,
				ZoomMoveMediator.ZOOMM,
				ZoomMoveMediator.ZOOMP,
				LOADIMAGE,
				ADDCONTENT
				];
		}
		
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case ZoomMoveMediator.MOVE:
				this.view.makeMovable();
				break;
				case ZoomMoveMediator.YAH:
				break;
				case ZoomMoveMediator.ZOOMM:
					sendNotification(ZOOMCHANGED,this.view.zoomOut());
				break;
				case ZoomMoveMediator.ZOOMP:
					sendNotification(ZOOMCHANGED, this.view.zoomIn());
				break;
				case LOADIMAGE:
					
					this.view.loadImage(notification.getBody() as String);
				break
				case ADDCONTENT:
					this.view.addContent(notification.getBody() as DisplayObject);
					break;
			}
		}
	}
}