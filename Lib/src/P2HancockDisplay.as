package
{
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import mx.core.UIComponent;
	import mx.effects.Resize;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;

	[Event(name="draw", type="DrawEvent")]
	public class P2HancockDisplay extends UIComponent
	{
		private static const LINE_THICKNESS:Number = 3;
		private static const LINE_COLOR:Number = 0x000000;
		
		public var allowInput:Boolean = false;
		
		private var drawing:Boolean = false;
		
		private var background:Sprite;
		private var drawSurface:Sprite;
		
		private var lastX:Number;
		private var lastY:Number;
		
		private var drawSurfaceScaledWidth:Number;
		private var drawSurfaceScaledHeight:Number;
		
		public function P2HancockDisplay()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		
		private function handleAddedToStage(event:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			
			background = new Sprite();
			addChild(background);
			
			drawSurface = new Sprite();
			drawSurface.x = 2;
			drawSurface.y = 2;
			drawSurface.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			drawSurface.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			addChild(drawSurface);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			// update the background
			background.graphics.clear();
			background.graphics.lineStyle(2, 0x444444, 1, false, LineScaleMode.NONE);
			background.graphics.drawRect(0, 0, unscaledWidth, unscaledHeight);
			background.width = unscaledWidth;
			background.height = unscaledHeight;
			
			var dsw:Number = unscaledWidth - 4;
			var dsh:Number = unscaledHeight - 4;
			
			if (!(isNaN(drawSurfaceScaledWidth)) && !(isNaN(drawSurfaceScaledHeight)))
			{
				dsw = drawSurfaceScaledWidth;
				dsh = drawSurfaceScaledHeight;
				
				drawSurface.scaleX = unscaledWidth / dsw;
				drawSurface.scaleY = unscaledHeight / dsh;
			}

			drawSurface.graphics.lineStyle();
			drawSurface.graphics.beginFill(0xffffff, 0.00001);
			drawSurface.graphics.drawRect(0, 0, dsw, dsh);
			drawSurface.graphics.endFill();
			
			if (!enabled)
			{
				graphics.clear();
				graphics.beginFill(0xaaaaaa, 0.3);
				graphics.drawRect(1, 1, unscaledWidth - 4, unscaledHeight - 4);
				graphics.endFill();
			}
		}
		
		private function handleMouseDown(event:MouseEvent):void
		{
			if (allowInput)
			{
				drawing = true;
				
				lastX = event.localX;
				lastY = event.localY;
			}
		}
		
		private function handleMouseMove(event:MouseEvent):void
		{
			if (drawing)
			{
				var drawPath:DrawPath = new DrawPath();
				drawPath.x1 = lastX;
				drawPath.x2 = lastX = event.localX;
				drawPath.y1 = lastY;
				drawPath.y2 = lastY = event.localY;
				
				dispatchEvent(new DrawEvent(DrawEvent.DRAW, drawPath));
			}
		}
		
		private function handleMouseUp(event:MouseEvent):void
		{
			drawing = false;
		}

		public function doDraw(drawPath:DrawPath):void
		{
			drawSurface.graphics.lineStyle(LINE_THICKNESS, LINE_COLOR);
			drawSurface.graphics.moveTo(drawPath.x1, drawPath.y1);
			drawSurface.graphics.lineTo(drawPath.x2, drawPath.y2);
		}
		
		public function scaleDrawSurface(width:Number, height:Number):void
		{
			drawSurfaceScaledWidth = width;
			drawSurfaceScaledHeight = height;
			
			invalidateDisplayList();
		}
		
		public function clearDrawSurface():void
		{
			drawSurface.graphics.clear();
			
			invalidateDisplayList();
		}
	}
}