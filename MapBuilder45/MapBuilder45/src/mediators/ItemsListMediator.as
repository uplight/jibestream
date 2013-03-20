package mediators
{
	import comps.ItemsList;
	
	import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ItemsListMediator extends Mediator implements IMediator{
		public static const NAME:String="ItemsListMediator";
		public static const ADDVIEW:String=NAME+"Addview";
		public static const CHANGE:String=NAME+"Change";
				
		
		private var view:ItemsList;
		public function ItemsListMediator(viewComponent:Object=null){
			super(NAME,viewComponent);
			this.view = viewComponent as ItemsList;
			viewComponent.mediator=this;
			facade.registerMediator(this);	
		}
		
		override public function listNotificationInterests():Array{
			return [
				ADDVIEW
				];
		}
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case ADDVIEW:
					
					break;
			}
		}
				
	}
}