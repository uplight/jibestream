package mediators
{
	import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import views.ComponentsView;
	
	public class ComponentsViewMediator extends Mediator implements IMediator{
		public static const NAME:String="ComponentsViewMediator";
		public static const ADDVIEW:String=NAME+"Addview";
				
		
		private var view:ComponentsView;
		public function ComponentsViewMediator(viewComponent:Object=null){
			super(NAME,viewComponent);
			this.view = viewComponent as ComponentsView;
			//viewComponent.mediator=this;
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