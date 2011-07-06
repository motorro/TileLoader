package tileloader.controller.tasks
{
	import mx.graphics.codec.IImageEncoder;
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.model.VO.ImageFormatFileVO;
	import tileloader.encoder.ImageTypes;
	
	/**
	 * Saves resized image
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageSaveTask extends Task {
		
		/**
		 * @private
		 * Format file storage 
		 */
		private var _formatFile:ImageFormatFileVO;
		
		/**
		 * Constructor 
		 * @param formatFile Image format storage VO
		 */
		public function ImageSaveTask(formatFile:ImageFormatFileVO)	{
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
			var encoder:IImageEncoder = getEncoder();
			
			function getEncoder():IImageEncoder {
				switch (_formatFile.format.fileType) {
					case ImageTypes.PNG:
						return new PNGEncoder();
					case ImageTypes.JPG:
					default:
						return new JPEGEncoder(80);
				}
			}
		}
		
		
	}
}