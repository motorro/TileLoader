package tileloader.controller.tasks
{
	import cmodule.aircall.CLibInit;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.model.ResizerModel;
	import tileloader.model.VO.ImageFormatFileVO;
	
	/**
	 * Encodes image to specified format 
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageEncodeTask extends Task {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(ImageEncodeTask);
		
		/**
		 * @private
		 * Encoder reference 
		 */
		private var _encoder:Object;

		public function ImageEncodeTask() {
			super();
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

			if (null != _logger) {
				_logger.info("Encoding image...");
			}
			
			try {
				//Init library
				var libInit:CLibInit = new CLibInit();
				_encoder = libInit.init();

				//Create output array
				model.encoded = new ByteArray();

				var inputBitmap:BitmapData = model.output;
				
				//Create input array
				var input:ByteArray = inputBitmap.getPixels(inputBitmap.rect);
				input.position = 0;

				_encoder.encodeAsync(onEncodeComplete, input, model.encoded, inputBitmap.width, inputBitmap.height, 100, 20);
			} catch (e:Error) {
				var message:String = "Error encoding image: " + e.message;
				if (null != _logger) {
					_logger.error(message);
				}
				error (message);
				return;
			}
		}	
		
		/**
		 * @private 
		 * Encode complete handler
		 */
		private function onEncodeComplete(data:Object):void {
			if (null != _logger) {
				_logger.info("Encoding complete.");
			}
			complete();			
		}
	}
}