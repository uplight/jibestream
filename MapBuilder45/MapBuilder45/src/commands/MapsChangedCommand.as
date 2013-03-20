package commands
{
	import mediators.MapHolderMediator;
	import mediators.PathEditorMediator;
	
	import models.MapsDataProxy;
	
	import mx.collections.ArrayList;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import vos.VoMap;
	
	public class MapsChangedCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void{
			trace("MapsChangedCommand");
			var id:int=notification.getBody() as int;
			
			var arl:ArrayList = facade.retrieveProxy(MapsDataProxy.NAME).getData() as ArrayList;
			var vo:VoMap= arl.getItemAt(id) as VoMap;
			
			sendNotification(MapHolderMediator.LOADIMAGE,Registry.getInstance.MAPS+vo.img);
			sendNotification(PathEditorMediator.LOADXMLMAP,vo.xml);
		}
	}
}