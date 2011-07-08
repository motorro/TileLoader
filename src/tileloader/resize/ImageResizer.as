package tileloader.resize
{
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ShaderEvent;
	
	import mx.logging.ILogger;
	
	import tileloader.log.LogUtils;
	
	/**
	 * Fired when resize is complete 
	 */
	[Event (name="complete", type="tileloader.resize.ImageResizerEvent")]
	/**
	 * Fires if resize error occures 
	 */
	[Event (name="error", type="flash.events.ErrorEvent")]
	/**
	 * Image resizer abstraction to make compound resize methods
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageResizer extends EventDispatcher {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(ImageResizer);

		/**
		 * Constructor 
		 */
		public function ImageResizer() {
			super();
		}
		
		/**
		 * @private
		 * Resize job storage 
		 */
		private var _job:ResizeJob;
		
		/**
		 * @private
		 * Output storage 
		 */
		private var _output:BitmapData;
		/**
		 * Resulting BitmapData 
		 */
		public function get output():BitmapData {
			return _output;			
		}
		
		/**
		 * @private
		 */
		private var _busy:Boolean;
		/**
		 * Busy flag 
		 */
		public function get busy():Boolean {
			return _busy;	
		}
		
		/**
		 * Resizes image. Fires COMPLETE when finished 
		 * @param input Input BitmapData
		 * @param targetWidth Target width
		 * @param targetHeight Target height
		 * @param fit Image fit type (one of the ImageFitType values. Default FIT_IMAGE)
		 * @param resizeType Resize type (one of the ImageResizeType values. Default BILINEAR)
		 * @return True if resize operation validated 
		 * 
		 */
		public function resize(input:BitmapData, targetWidth:Number, targetHeight:Number, fit:String = null, resizeType:String = null):Boolean {
			if (null != _logger) {
				_logger.info("Resizing to: " + targetWidth + "x" + targetHeight + " using " + resizeType + " method");
			}

			if (busy) {
				if (null != _logger) {
					_logger.warn("Resizer busy!");
				}
				return false;
			}
			
			//Check resize parameters
			if (targetWidth <= 0 || targetHeight <= 0) return false;

			
			fit = validateFit(fit);
			
			switch (resizeType) {
				case ImageResizeType.BICUBIC:
					resizeBicubic(input, targetWidth, targetHeight, fit);
					break;
				case ImageResizeType.BILINEAR_ITERATIVE:
					resizeBilinearIterative(input, targetWidth, targetHeight, fit);
					break;
				case ImageResizeType.BILINEAR:
				case null:
					resizeBilinear(input, targetWidth, targetHeight, fit);
					break;
				default:
					if (null != _logger) {
						_logger.warn("Invalid resize method!");
					}
					return false;
			}
			
			return true;
		}
		
		/**
		 * Cleans up resulting BitmapData 
		 * @param dispose Should a BitmapData.dispose() method be called
		 * @return True if succes, false if resizer is busy
		 */
		public function cleanup(dispose:Boolean = false):Boolean {
			if (_busy) return false;

			if (null == _output) return true;
			
			if (dispose) _output.dispose();
			
			_output = null;
			
			return true;
		}
		
		/**
		 * @private 
		 * Performs bicubic resize
		 */
		private function resizeBicubic(input:BitmapData, targetWidth:Number, targetHeight:Number, fit:String):void {
			_job = BenderImageResizer.resize(input, targetWidth, targetHeight, fit, BenderImageResizer.BICUBIC);
			_job.job.addEventListener(ShaderEvent.COMPLETE, onResizeComplete, false, 0, true);
			try {
				_job.job.start(false);
			} catch (e:Error) {
				dispatchError(e);
			}
		}
		
		/**
		 * @private  
		 * Performs iterative bilinear resize
		 */
		private function resizeBilinearIterative(input:BitmapData, targetWidth:Number, targetHeight:Number, fit:String):void {
			//If original image is more than two times larger
			//than target - use chain of several 1/2 resizes
			var iterationResult:BitmapData;

			if (input.width / targetWidth <= 2 || input.height / targetHeight <= 2) {
				if (null != _logger) {
					_logger.info("Last iteration resize to: " + targetWidth + "x" + targetHeight);
				}
				resizeBilinear(input, targetWidth, targetHeight, fit);
				return;
			}
			
			var iterationWidth:Number = Math.floor(input.width / 2);
			var iterationHeight:Number = Math.floor(input.height / 2);
			
			if (null != _logger) {
				_logger.info("Resize iteration to: " + iterationWidth + "x" + iterationHeight);
			}
			
			_job = BenderImageResizer.resize(input, iterationWidth, iterationHeight, ImageFitType.FIT_IMAGE, ImageResizeType.BILINEAR);
			_job.job.addEventListener(ShaderEvent.COMPLETE, onIterationComplete);
			_job.job.start(false);
			
			function onIterationComplete(event:ShaderEvent):void {
				_job.job.removeEventListener(ShaderEvent.COMPLETE, onIterationComplete);
				if (null != iterationResult) {
					iterationResult.dispose();
				}
				iterationResult = _job.output;
				_job = null;
				
				resizeBilinearIterative(iterationResult, targetWidth, targetHeight, fit);
			}
		}
		
		/**
		 * @private 
		 * Performs bilinear resize
		 */
		private function resizeBilinear(input:BitmapData, targetWidth:Number, targetHeight:Number, fit:String):void {
			_job = BenderImageResizer.resize(input, targetWidth, targetHeight, fit, BenderImageResizer.BILINEAR);
			_job.job.addEventListener(ShaderEvent.COMPLETE, onResizeComplete, false, 0, true);
			try {
				_job.job.start(false);
			} catch (e:Error) {
				dispatchError(e);
			}
		}
		
		/**
		 * @private
		 * Resize complete event handler 
		 */
		private function onResizeComplete(event:ShaderEvent):void {
			if (null != _logger) {
				_logger.info("Resize complete.");
			}
			if (null != _job) {
				_output = _job.output;
			}
			_job = null;
			_busy = false;
			dispatchEvent(new ImageResizerEvent(ImageResizerEvent.COMPLETE, _output));
		}
		
		/**
		 * @private 
		 * Error cleanup and dispatch
		 */
		private function dispatchError(e:Error):void {
			if (null != _output) {
				_output.dispose();
				_output = null;
			}
			_job = null;
			if (null != _logger) {
				_logger.error("Resize error: " + e.message);
			}
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, e.message, e.errorID));
		}
		
		/**
		 * @private
		 * Fit type validator 
		 */
		private function validateFit(fit:String):String {
			switch (fit) {
				case ImageFitType.FIT_WINDOW:
					return ImageFitType.FIT_WINDOW;
				case ImageFitType.FIT_IMAGE:
				default:
					return ImageFitType.FIT_IMAGE;
			}
		}
	}
}