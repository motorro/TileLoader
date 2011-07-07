package tileloader.messages
{
	import tileloader.model.VO.ImageVO;

	/**
	 * Message to initiate image upload
	 *  
	 * @author kochetkov
	 * 
	 */
	public class UploadImageMessage	{

		/**
		 * Image to upload 
		 */
		public var image:ImageVO;
		
		/**
		 * Constructor 
		 * @param image Image to upload
		 */
		public function UploadImageMessage(image:ImageVO) {
			this.image = image;
		}
	}
}