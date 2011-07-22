package tileloader.model
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import tileloader.model.VO.ImageFormatVO;
	import tileloader.model.VO.ImageVO;

	/**
	 * Data model for image resizer
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ResizerModel {
		[Bindable]
		[CommandStatus(type="tileloader.messages.ResizeImageMessage")]
		public var working:Boolean; 
		
		[Bindable]
		/**
		 * Indicates that resizer suffers error
		 */
		public var sufferingError:Boolean;
		
		[Bindable]
		/**
		 * Perform image rotation according to exif orientation 
		 */
		public var exifRotate:Boolean = true;
		
		[Bindable]
		/**
		 * Current file being resized 
		 */
		public var imageInProgress:ImageVO; 
		
		/**
		 * Original image BitmapData storage 
		 */
		public var original:Loader;
		
		/**
		 * Rotation to apply to current image 
		 */
		public var rotation:String;
		
		/**
		 * Output bitmap data storage 
		 */
		public var output:BitmapData;
		
		/**
		 * Format used to produce last output 
		 */
		public var outputFormat:ImageFormatVO;
		
		/**
		 * Reference to encoded image 
		 */
		public var encoded:ByteArray;
		
		/**
		 * @private
		 * Storage for Alchemy encoder  
		 */
		public var encoder:Object;
		
		[Init]
		/**
		 * Initializes model and removes any temporary data 
		 */
		public function initialize():void {
			
			//Remove processed data
			if (null != original) {
				original.unload();
				original = null;
			}
			
			imageInProgress = null;
			
			if (null != output) {
				output.dispose();
				output = null;
			}
			
			encoded = null;
			
			//Drop encoding parameters
			rotation = null;
			outputFormat = null;
		}
		
	}
}