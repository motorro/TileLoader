package tileloader.controller.tasks
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.ShaderEvent;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.model.ResizerModel;
	import tileloader.resize.BenderLosslessImageRotator;
	import tileloader.resize.ResizeJob;
	
	/**
	 * Lossless rotate image
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageRotateTask extends Task {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(ImageRotateTask);
		
		/**
		 * @private
		 * Rotation job 
		 */
		private var _job:ResizeJob;

		/**
		 * @private
		 * Resize model reference 
		 */
		private var _model:ResizerModel;
		
		/**
		 * Constructor 
		 */
		public function ImageRotateTask() {
			super();

			setCancelable(false);
			setSkippable(true);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doStart():void {
			_model = ResizerModel(data);
			
			if (null == _model.rotation) {
				if (null != _logger) {
					_logger.info("No rotation needed. Skipping...");
				}
				skip();
				return;
			}
			
			if (null != _logger) {
				_logger.error("Rotating image: " + _model.rotation);
			}
			
			_job = BenderLosslessImageRotator.rotate(Bitmap(_model.original.content).bitmapData, _model.rotation);
			if (null == _job) {
				if (null != _logger) {
					_logger.warn("Invalid rotation param!");
				}
				skip();
				return;
			}
			
			_job.job.addEventListener(ShaderEvent.COMPLETE, onRotationComplete);
			_job.job.start(false);
		}
		
		/**
		 * Rotation complete event
		 *  
		 * @param event
		 * 
		 */
		private function onRotationComplete(event:Event):void {
			_job.job.removeEventListener(ShaderEvent.COMPLETE, onRotationComplete);
			if (null != _logger) {
				_logger.info("Rotation complete");
			}
			Bitmap(_model.original.content).bitmapData = _job.output;
			complete();
		}
	}
}