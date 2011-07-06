package tileloader.controller.tasks
{
	import org.spicefactory.lib.task.Task;
	
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
		 * Format file storage 
		 */
		private var _formatFile:ImageFormatFileVO;

		public function ImageEncodeTask(formatFile:ImageFormatFileVO) {
			super();
			_formatFile = formatFile;
		
			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doStart():void {
			
		}		
	}
}