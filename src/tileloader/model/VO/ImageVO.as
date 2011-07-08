package tileloader.model.VO
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import mx.controls.Image;
	import mx.core.IUID;
	
	/**
	 * Image VO
	 *  
	 * @author kochetkov
	 * 
	 */
	//TODO: Change resize errors to those events and add error state
	[Event (name="resizeComplete", type="tileloader.messages.ImageEvent")]
	[Event (name="resizeFailed", type="tileloader.messages.ImageEvent")]
	[Event (name="uploadComplete", type="tileloader.messages.ImageEvent")]
	[Event (name="uploadFailed", type="tileloader.messages.ImageEvent")]
	/**
	 * Image value object 
	 * @author kochetkov
	 * 
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
		 * Resized files 
		 */
		public var formats:Dictionary;
		
		/**
		 * All formats are complete flag 
		 */
		public var complete:Boolean;
		
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