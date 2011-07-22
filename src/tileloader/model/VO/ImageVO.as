package tileloader.model.VO
{
	import flash.display.Bitmap;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import jp.shichiseki.exif.ExifInfo;
	
	import mx.controls.Image;
	import mx.core.IUID;
	
	/**
	 * Image VO
	 *  
	 * @author kochetkov
	 * 
	 */
	//TODO: Change resize errors to those events and add error state
	/**
	 * Image resize starts
	 */
	[Event (name="resizeStart", type="tileloader.messages.ImageEvent")]
	/**
	 * Image resize complete 
	 */
	[Event (name="formatResizeComplete", type="tileloader.messages.ImageEvent")]
	/**
	 * Resize complete 
	 */
	[Event (name="resizeComplete", type="tileloader.messages.ImageEvent")]
	/**
	 * Image format resize failure 
	 */
	[Event (name="resizeFailed", type="tileloader.messages.ImageEvent")]
	/**
	 * Image upload start 
	 */
	[Event (name="uploadStart", type="tileloader.messages.ImageEvent")]
	/**
	 * Image upload complete 
	 */
	[Event (name="formatUploadComplete", type="tileloader.messages.ImageEvent")]
	/**
	 * Image format upload complete 
	 */
	[Event (name="uploadComplete", type="tileloader.messages.ImageEvent")]
	/**
	 * Image upload failed 
	 */
	[Event (name="uploadFailed", type="tileloader.messages.ImageEvent")]
	/**
	 * Image value object 
	 * @author kochetkov
	 */
	public class ImageVO extends EventDispatcher implements IUID {
		
		/**
		 * Image is portrait 
		 */
		public static const PORTRAIT:String="portrait";
		
		/**
		 * Image is landscape 
		 */
		public static const LANDSCAPE:String="landscape";
		
		/**
		 * File reference 
		 */
		public var path:File;
		
		/**
		 * Image Orientation (portrait/landscape) 
		 */
		public var orientation:String;
		
		/**
		 * Image exif if available 
		 */
		public var exifData:ExifInfo;
		
		/**
		 * Resized files 
		 */
		public var formats:Dictionary;
		
		/**
		 * Thumbnail bitmap 
		 */
		public var thumbnail:Bitmap;
		
		/**
		 * Image being resized flag 
		 */
		public var isBeingResized:Boolean;
		
		/**
		 * All formats are complete flag 
		 */
		public var resizeComplete:Boolean;

		/**
		 * Image being uploaded
		 */
		public var isBeingUploaded:Boolean;
		
		/**
		 * All formats are uploaded flag 
		 */
		public var uploadComplete:Boolean;
		
		/**
		 * Constructor
		 * @param path Path to original file;
		 */
		public function ImageVO(path:File, uid:String) {
			this.path = path;
			_uid = uid;
		}
		
		private var _uid:String;
		/**
		 * IUID UID property 
		 */
		public function get uid():String {
			return _uid;
		}
		public function set uid(value:String):void {
			//No operation
		}
	}
}