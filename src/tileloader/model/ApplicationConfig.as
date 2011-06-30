package tileloader.model
{
	import tileloader.model.VO.ImageFormatVO;

	/**
	 * Application configuration.
	 * Loaded from config.xml in application directory.
	 *  
	 * @author kochetkov
	 * 
	 */	
	public class ApplicationConfig {
		/**
		 * User authenticating URL 
		 */
		public var authURL:String;
		
		/**
		 * Album list URL 
		 */
		public var albumListURL:String;
		
		/**
		 * Target image format config URL 
		 */
		public var imageFormatConfigURL:String;
		
		/**
		 * Target image format storage 
		 */
		public var imageFormats:Vector.<ImageFormatVO>;
		
		/**
		 * Reference to image format that is used as thumbnail 
		 */
		public var thumbnailFormat:ImageFormatVO;
		
		/**
		 * Image upload script URL 
		 */
		public var imageUploadURL:String;
	}
}