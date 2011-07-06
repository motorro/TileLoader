package tileloader.model
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.utils.ByteArray;
	
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
		public var original:Loader;
		
		/**
		 * Output bitmap data storage 
		 */
		public var output:BitmapData;
		
		/**
		 * Reference to encoded image 
		 */
		public var encoded:ByteArray;
	}
}