package tileloader.messages
{
	import flash.events.Event;
	
	import tileloader.model.VO.ImageFormatVO;
	
	/**
	 * ImageVO event
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageEvent extends Event {
		
		/**
		 * Image resize starts
		 */
		public static const RESIZE_START:String = "resizeStart";

		/**
		 * Image resize complete 
		 */
		public static const FORMAT_RESIZE_COMPLETE:String = "formatResizeComplete";
		
		/**
		 * Resize complete 
		 */
		public static const RESIZE_COMPLETE:String = "resizeComplete";

		/**
		 * Image format resize failure 
		 */
		public static const RESIZE_FAILED:String = "resizeFailed";

		/**
		 * Image upload start 
		 */
		public static const UPLOAD_START:String = "uploadStart";

		/**
		 * Image upload complete 
		 */
		public static const UPLOAD_COMPLETE:String = "uploadComplete";
		
		/**
		 * Image format upload complete 
		 */
		public static const FORMAT_UPLOAD_COMPLETE:String = "formatUploadComplete";

		/**
		 * Image upload failed 
		 */
		public static const UPLOAD_FAILED:String = "uploadFailed";
		
		/**
		 * Image format reference that has complete resizing 
		 */
		public var imageFormat:ImageFormatVO;
		
		/**
		 * Constructor 
		 * @param type Message type
		 * @param imageFormat Image format that has complete resize operation
		 */
		public function ImageEvent(type:String, imageFormat:ImageFormatVO = null) {
			super(type);
			this.imageFormat = imageFormat;
		}
		
		/**
		 * @inheritDoc 
		 */
		override public function clone():Event {
			return new ImageEvent(type, imageFormat);			
		}
	}
}