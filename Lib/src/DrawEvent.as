package
{
	import flash.events.Event;
	
	public class DrawEvent extends Event
	{
		public static const DRAW:String = "draw";
		
		public var drawPath:DrawPath;
		
		public function DrawEvent(type:String, drawPath:DrawPath)
		{
			super(type);
			
			this.drawPath = drawPath;
		}
	}
}