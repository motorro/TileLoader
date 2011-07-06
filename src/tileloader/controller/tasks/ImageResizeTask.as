package tileloader.controller.tasks
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.ShaderEvent;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.model.ResizerModel;
	import tileloader.model.VO.ImageFormatVO;
	import tileloader.resize.BenderImageResizer;
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
		 * Resize job to perform 
		 */
		private var _job:ResizeJob;
		
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
				_logger.info("Resizing to: " + _format.targetWidth + "x" + _format.targetHeight);
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
			
			_job = BenderImageResizer.resize(whichOne(), _format.targetWidth, _format.targetHeight, _format.fit);
			
			_job.job.addEventListener(ShaderEvent.COMPLETE, onComplete);
			
			_job.job.start(false);
			
			//Sets original BitmapData to use in an effort to use formats sorted by square
			function whichOne():BitmapData {
				var previous:BitmapData = model.output;
				
				//No previous step - use original
				if (null == previous) return original;
				
				//Required format is bigger than processed
				if (_format.targetWidth * _format.targetHeight > previous.width * previous.height) return original;
				
				//Return original if aspect ratios are different
				if (Math.abs(_format.targetWidth / _format.targetHeight - previous.width / previous.height) > 0.01) return original;
				
				return previous;
			}
		}
		
		/**
		 * @private
		 * Shader job complete handler 
		 */
		private function onComplete(event:ShaderEvent):void {
			if (null != _logger) {
				_logger.info("Resize complete.");
			}
			
			_job.job.removeEventListener(ShaderEvent.COMPLETE, onComplete);
			
			if (null != ResizerModel(data).output) {
				ResizerModel(data).output.dispose();
			}
			
			ResizerModel(data).output = _job.output;
			
			complete();
		}
		
	}
}