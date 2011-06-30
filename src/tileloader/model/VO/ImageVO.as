package tileloader.model.VO
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import mx.controls.Image;

	/**
	 * Image VO
	 *  
	 * @author kochetkov
	 * 
	 */
	[Event (name="resizeComplete", type="tileloader.messages.ImageEvent")]
	[Event (name="resizeFailed", type="tileloader.messages.ImageEvent")]
	[Event (name="uploadComplete", type="tileloader.messages.ImageEvent")]
	[Event (name="uploadFailed", type="tileloader.messages.ImageEvent")]
	/**
	 * Image value object 
	 * @author kochetkov
	 * 
	 */
	public class ImageVO extends EventDispatcher{
		
		/**
		 * File reference 
		 */
		public var path:File;
		
		/**
		 * Resized files 
		 */
		public var formats:Dictionary;
		
		/**
		 * Constructor
		 * @param path Path to original file;
		 */
		public function ImageVO(path:File) {
			this.path = path;
		}
	}
}