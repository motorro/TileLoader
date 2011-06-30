package tileloader.model.VO
{
	import flash.filesystem.File;

	/**
	 * Resized image VO
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageFormatFileVO {
		
		/**
		 * Resized file reference 
		 */
		public var file:File;
		
		/**
		 * Reference to resize format used 
		 */
		public var format:ImageFormatVO;
		
		
		/**
		 * Constructor 
		 * @param file Resized file reference 
		 * @param format Reference to resize format used
		 */
		public function ImageFormatFileVO(file:File, format:ImageFormatVO) {
			this.file = file;
			this.format = format;
		}
	}
}