package tileloader.messages
{
	import flash.filesystem.File;
	
	import tileloader.model.VO.ImageVO;

	/**
	 * Image resize initiating message
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ResizeImageMessage {
		
		/**
		 * Image to resize 
		 */
		public var image:ImageVO
		
		/**
		 * Constructor 
		 * @param image Image to resize
		 */
		public function ResizeImageMessage(image:ImageVO) {
			this.image = image;
		}
	}
}