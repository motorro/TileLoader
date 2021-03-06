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
		[Bindable]
		/**
		 * Initialization flag 
		 */
		public var configured:Boolean;

		/**
		 * User authenticating URL 
		 */
		public var authURL:String;
		
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