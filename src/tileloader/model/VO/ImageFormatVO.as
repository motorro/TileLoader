package tileloader.model.VO
{
	import tileloader.resize.ImageFitType;
	import tileloader.encoder.ImageTypes;

	/**
	 * Stores image format parameters
	 *  
	 * @author kochetkov
	 * 
	 */	
	public class ImageFormatVO {
		/**
		 * Format ID 
		 */
		public var id:String;
		
		/**
		 * Target format width (in pixels) 
		 */
		public var targetWidth:int;
		
		/**
		 * Target format height (in pixels) 
		 */
		public var targetHeight:int;
		
		/**
		 * Image fit (one of the ImageFitType values); 
		 */
		public var fit:String;
		
		/**
		 * Image file type (JPG, PNG) 
		 */
		public var fileType:String;
		
		/**
		 * Constructor 
		 * @param targetWidth Target image width
		 * @param targetHeight Target image height
		 * @param fit Target image fit type
		 * 
		 */
		public function ImageFormatVO(id:String = null, targetWidth:int = 0, targetHeight:int = 0, fit:String = null, fileType:String = null) {
			this.id = id;
			this.targetWidth = targetWidth;
			this.targetHeight = targetHeight;
			this.fit = getCorrectFit(fit);
			this.fileType = getCorrectFileType(fileType);
		}
		
		/**
		 * @private 
		 * Image fit validator 
		 */
		private function getCorrectFit(fit:String):String {
			switch (fit.toLowerCase()) {
				case ImageFitType.FIT_WINDOW:
					return ImageFitType.FIT_WINDOW;
				case ImageFitType.FIT_IMAGE:
				default:
					return ImageFitType.FIT_IMAGE;
			}
		}
		
		/**
		 * @private
		 * File type validator 
		 */
		private function getCorrectFileType(type:String):String {
			switch (type.toLowerCase()) {
				case ImageTypes.PNG:
					return ImageTypes.PNG;
				case ImageTypes.JPG:
				default:
					return ImageTypes.JPG;
			}
		}
	}
}