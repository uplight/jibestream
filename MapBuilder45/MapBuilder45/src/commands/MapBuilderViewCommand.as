package commands
{
	import editor.PathTools;
	
	import flash.display.DisplayObject;
	
	import mediators.MapHolderMediator;
	import mediators.PathEditorMediator;
	import mediators.PathToolsMediator;
	import mediators.ToolsMenuMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MapBuilderViewCommand extends SimpleCommand implements ICommand
	{
		override public function  execute(notification:INotification):void{
			trace("MapBuilderViewCommand")
			
			//var med:IMediator = facade.retrieveMediator(PathEditorMediator.NAME);
			//var DO:DisplayObject = med.getViewComponent() as DisplayObject;
			sendNotification(MapHolderMediator.ADDCONTENT,facade.retrieveMediator(PathEditorMediator.NAME).getViewComponent());
			
			if(!facade.hasMediator(PathToolsMediator.NAME)) facade.registerMediator(new PathToolsMediator(new PathTools())) ;
			
			sendNotification(ToolsMenuMediator.ADDMENU,facade.retrieveMediator(PathToolsMediator.NAME).getViewComponent())
		}
	}
}