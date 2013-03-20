package commands
{
	import editor.path.PathEditor;
	
	import flash.utils.setTimeout;
	
	import mediators.ListOfMapsMediator;
	import mediators.PathEditorMediator;
	
	import models.CurrentModel;
	import models.ItemsDataProxy;
	import models.MapsDataProxy;
	import models.ProjectProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StartUpCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void{
			trace("StartUpCommand");
			
			var pp:ProjectProxy= new ProjectProxy();
			facade.registerProxy(pp);
			
			Registry.getInstance.connector.connect('rem/gateway.php');
			pp.loadProject();
						
			facade.registerProxy(new CurrentModel());
			setTimeout(start,1000);		
			
			facade.registerProxy(new ItemsDataProxy());
			facade.registerCommand(ListOfMapsMediator.SELECTED,MapsChangedCommand);
			facade.registerProxy(new MapsDataProxy());
			var pe:PathEditorMediator = new PathEditorMediator(new PathEditor());
		}
		
		private function start():void{
			sendNotification(ApplicationMediator.MAPBUILDERVIEW);
		}
	}
}