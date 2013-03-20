package
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.NetConnection;
	
	import mx.utils.ObjectUtil;
	
	//import org.puremvc.as3.interfaces.IFacade;
	
	import spark.components.Application;
	
	import vos.VoMap;

	public final class Registry
	{
		public static const GETNEWMAP:String="GetaNewMap";
		public static const SAVECHANGESONSERVER:String="SaveChangesOnServer";
		static private const _instance:Registry = new Registry();
		
		public function Registry()
		{
		}
		static public function get getInstance():Registry{
			return _instance ;
		}
		public var application:Application 
		
		public var MAPS:String="data/maps/";
		private var _currentMap:VoMap;
		public var hasChanges:Boolean;
		
		public function set currentMap(vo:VoMap):void{
			this._currentMap=vo;
			dispMapChanged.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get currentMap():VoMap{
			return this._currentMap;
		}
		
		public var dispMapChanged:EventDispatcher = new EventDispatcher
			
		public var dispatcherGlobal:EventDispatcher = new EventDispatcher;
		
		
		public static const HINTINT:int=2000;
		
		public const connector:NetConnection = new NetConnection();
		public var screenid:String='1';
	
						
		
	}
}