package tileloader.model
{
	import flash.display.Bitmap;
	
	import tileloader.model.VO.ImageVO;

	/**
	 * Data model for image resizer
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ResizerModel {
		[Bindable]
		public var working:Boolean; 
		//[CommandStatus(type="fmsdm.messages.UserConnectionMessage")]
		
		[Bindable]
		/**
		 * Current file being resized 
		 */
		public var fileInProgress:ImageVO; 
		
		/**
		 * Original image BitmapData storage 
		 */
		public var original:Bitmap;
	}
}