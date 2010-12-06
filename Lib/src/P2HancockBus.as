package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;

	
	[Event(name="draw", type="DrawEvent")]
	[Event(name="resizeDrawingSurface", type="ResizeDrawingSurfaceEvent")]
	[Event(name="reset", type="flash.events.Event")]
	public class P2HancockBus extends EventDispatcher
	{
		private var netGroup:NetGroup;
		private var localNc:NetConnection;

		public var connected:Boolean = false;
		
		public static const GROUP_ID:String = "p2hancock";
		
		
		public function P2HancockBus()
		{
			localNc = new NetConnection();
			localNc.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			localNc.connect("rtmfp:");
		}
		
		protected function netStatus(event:NetStatusEvent):void{
			
			switch(event.info.code){
				case "NetConnection.Connect.Success":
					setupGroup();
					break;
				
				case "NetGroup.Connect.Success":
					connected = true;
					break;
				
				case "NetConnection.Connect.Closed":
					connected = false;
					break;
				
				case "NetGroup.SendTo.Notify":
					var e:Event;
					if (event.info.message is DrawPath)
					{
						e = new DrawEvent(DrawEvent.DRAW, event.info.message);
					}
					else if (event.info.message is Dimension)
					{
						e = new ResizeDrawingSurfaceEvent(ResizeDrawingSurfaceEvent.RESIZE_DRAWING_SURFACE, event.info.message);
					}
					else if (event.info.message is String)
					{
						e = new Event(event.info.message as String);
					}
					dispatchEvent(e);
			}
		}
		
		private function setupGroup():void
		{
			var groupspec:GroupSpecifier = new GroupSpecifier(GROUP_ID);
			groupspec.ipMulticastMemberUpdatesEnabled = true;
			groupspec.multicastEnabled = true;
			groupspec.routingEnabled = true;
			groupspec.postingEnabled = true;
			groupspec.addIPMulticastAddress("239.254.254.2:30304");
			
			netGroup = new NetGroup(localNc, groupspec.groupspecWithAuthorizations());
			netGroup.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
		}
		
		public function sendDraw(drawPath:DrawPath):void
		{
			netGroup.sendToAllNeighbors(drawPath);
		}
		
		public function sendResize(dimension:Dimension):void
		{
			netGroup.sendToAllNeighbors(dimension);
		}
		
		public function sendReset():void
		{
			netGroup.sendToAllNeighbors("reset");
		}
	}
}