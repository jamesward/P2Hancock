package
{
	import flash.events.Event;

	public class ResizeDrawingSurfaceEvent extends Event
	{
		public static const RESIZE_DRAWING_SURFACE:String = "resizeDrawingSurface";
		public var dimension:Dimension;
		
		public function ResizeDrawingSurfaceEvent(type:String, dimension:Dimension)
		{
			super(type);
			
			this.dimension = dimension;
		}
	}
}