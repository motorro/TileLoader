package tileloader.controller.tasks
{
	import flash.utils.Dictionary;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.messages.ImageEvent;
	import tileloader.model.ResizerModel;
	import tileloader.model.VO.ImageFormatFileVO;
	import tileloader.model.VO.ImageVO;
	
	/**
	 * Performes cleanup after completing file resize and save
	 *  
	 * @author kochetkov
	 * 
	 */
	public class FormatResizeCleanupTask extends Task {
		/**
		 * @private
		 * Image VO being processed storage 
		 */
		private var _image:ImageVO;
		
		/**
		 * @private
		 * Format being processed storage 
		 */
		private var _format:ImageFormatFileVO;
		
		/**
		 * Constructor 
		 */
		public function FormatResizeCleanupTask(image:ImageVO, format:ImageFormatFileVO) {
			super();
			
			_image = image;
			_format = format;
			
			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */
		override protected function doStart():void {
			//Add encoded format reference to image VO
			if (null == _image.formats) {
				_image.formats = new Dictionary();
			}
			_image.formats[_format.format] = _format;
			
			//Dispatch format complete message
			_image.dispatchEvent(new ImageEvent(ImageEvent.RESIZE_COMPLETE, _format.format));
			
			//Cleanup model
			var model:ResizerModel = ResizerModel(data);
			model.encoded = null;
			
			complete();
		}
	}
}