package
{
		
	import commands.*;
	
	import flash.utils.setTimeout;
	
	import mediators.*;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator implements IMediator	{
		public static const NAME:String="ApplicationMediator";
		public static const LOADED:String=NAME+"Loaded";
		public static const CHANGED:String=NAME+"Changed";
		public static const START:String=NAME+"Start";
		
		public static const MAPBUILDERVIEW:String=NAME+"MapBuilder";
		
		
		private var isDataChanged:Boolean
		
		public function ApplicationMediator(viewComponent:Object=null)	{
			super(NAME, viewComponent);
			facade.registerCommand(START,StartUpCommand);
			facade.registerCommand(MAPBUILDERVIEW,MapBuilderViewCommand);
			setTimeout(start,1000);
		}
		private function start():void{
			sendNotification(START);
		}
		override public function onRegister():void{
			trace("onRegister ApplicationMediator");
		}
		override public function listNotificationInterests():Array{
			return [
				LOADED,
				ListOfMapsMediator.SELECTED,
				CHANGED
				//ListOfMapsMediator.LOCALIMAGE
				]
		}
		
		override public function handleNotification(notification:INotification):void{
			trace(NAME+"  "+notification.getName());
			switch(notification.getName()){
				case LOADED:
					//sendNotification(PathEditorEvent.LOADMAP,"b.xml");
					break;
				case ListOfMapsMediator.SELECTED:
					
					//sendNotification(PathEditorEvent.LOADMAP,notification.getBody());
					break;
				case CHANGED:
					isDataChanged=true;
					break;
				//case ListOfMapsMediator.LOCALIMAGE:
					//sendNotification(PathEditorMediator.LOADIMAGEFROMBA,notification.getBody());
				//	break;
			}
		}
	}
}