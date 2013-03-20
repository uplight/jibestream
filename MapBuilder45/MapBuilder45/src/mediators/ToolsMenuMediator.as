package mediators
{
		
	import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	
	import mx.core.IVisualElement;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import views.ToolsMenu;
	
	public class ToolsMenuMediator extends Mediator implements IMediator{
		public static const NAME:String="ToolsMenuMediator";
		public static const ADDMENU:String=NAME+"AddMEnu";
		
		
		private var view:ToolsMenu
		public function ToolsMenuMediator(viewComponent:Object=null){
			super(NAME,viewComponent);
			this.view = viewComponent as ToolsMenu;
			facade.registerMediator(this);	
		}
		
		override public function listNotificationInterests():Array{
			return [
				ADDMENU
				];
		}
		override public function handleNotification(notification:INotification):void{
			switch(notification.getName()){
				case ADDMENU:
					this.view.addMenu(notification.getBody() as IVisualElement);
					break;
			}
		}
				
	}
}