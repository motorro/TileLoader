package tileloader.controller.tasks
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.ShaderEvent;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.model.ResizerModel;
	import tileloader.model.VO.ImageFormatVO;
	import tileloader.resize.BenderImageResizer;
	import tileloader.resize.ImageFitType;
	import tileloader.resize.ImageResizer;
	import tileloader.resize.ImageResizerEvent;
	import tileloader.resize.ResizeJob;
	
	/**
	 * Resizes original image to meet given format
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageResizeTask extends Task {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(ImageResizeTask);

		/**
		 * @private
		 * Format data storage 
		 */
		private var _format:ImageFormatVO;
		
		/**
		 * @private
		 * Image resizer instance 
		 */
		private var _resizer:ImageResizer;
		
		/**
		 * Constructor 
		 * @param format Target format
		 */
		public function ImageResizeTask(format:ImageFormatVO) {
			super();
			_format = format;
			
			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doStart():void {
			var model:ResizerModel = ResizerModel(data);
			var message:String;
			
			if (null != _logger) {
				_logger.info("Resizing to: " + _format.targetWidth + "x" + _format.targetHeight + " using " + _format.resizeType + " method");
			}
			
			var original:BitmapData;
			try {
				original = Bitmap(model.original.content).bitmapData;
			} catch (e:Error) {
				message = "Original is not valid bitmap";
				if (null != _logger) {
					_logger.error(message);
				}
				error(message);
				return;
			}
			
			_resizer = new ImageResizer();
			_resizer.addEventListener(ImageResizerEvent.COMPLETE, onComplete);
			_resizer.addEventListener(ErrorEvent.ERROR, onError);
			
			var source:BitmapData = whichOne();
			if (null != _logger) {
				_logger.info("Using " + (source === original ? "original" : "previous") + " image as source");	
			}
			
			_resizer.resize(whichOne(), _format.targetWidth, _format.targetHeight, _format.fit, _format.resizeType);
			
			//Sets original BitmapData to use in an effort to use formats sorted by square
			function whichOne():BitmapData {
				var previous:ImageFormatVO = model.outputFormat;
				
				//No previous step - use original
				if (null == previous) return original;
				
				//Required format is bigger than processed
				if (_format.targetWidth * _format.targetHeight > previous.targetWidth * previous.targetHeight) return original;
				
				//Required format fit is IMAGE, original is WINDOW
				if (ImageFitType.FIT_IMAGE == _format.fit && ImageFitType.FIT_WINDOW == previous.fit) return original;
				
				//Return original if previous target dimensions are less than current
				if (previous.targetWidth < _format.targetWidth || previous.targetHeight < _format.targetHeight) return original; 	
				
				//Use result of previous resize
				return model.output;
			}
		}
		
		/**
		 * @private
		 * Shader job complete handler 
		 */
		private function onComplete(event:ImageResizerEvent):void {
			if (null != _logger) {
				_logger.info("Resize complete.");
			}
			
			if (null != ResizerModel(data).output) {
				ResizerModel(data).output.dispose();
			}
			
			ResizerModel(data).output = event.bitmapData;
			ResizerModel(data).outputFormat = _format;
			
			disposeResizer();
			
			complete();
		}
		
		/**
		 * @private
		 * Resize error message 
		 */
		private function onError(event:ErrorEvent):void {
			disposeResizer();
			var message:String = "Resize error: " + event.text;
			if (null != _logger) {
				_logger.error(message);
			}
			error(message);
		}
		
		/**
		 * @private 
		 * Disposes resizer in use
		 */
		private function disposeResizer():void {
			_resizer.removeEventListener(ImageResizerEvent.COMPLETE, onComplete);
			_resizer.removeEventListener(ErrorEvent.ERROR, onError);
			_resizer.cleanup(false);
			_resizer = null;
		}
		
	}
}