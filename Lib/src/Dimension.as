package
{
	[RemoteClass(alias="Dimension")]
	public class Dimension
	{
		public var width:Number;
		public var height:Number;
		
		public function Dimension(width:Number=NaN, height:Number=NaN)
		{
			this.width = width;
			this.height = height;
		}
	}
}