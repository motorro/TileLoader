package tileloader.model.VO
{
	import tileloader.resize.ImageFitType;
	import tileloader.resize.ImageResizeType;

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
		 * Resize engine to use 
		 */
		public var resizeType:String;
		
		/**
		 * Constructor 
		 * @param targetWidth Target image width
		 * @param targetHeight Target image height
		 * @param fit Target image fit type
		 * 
		 */
		public function ImageFormatVO(id:String = null, targetWidth:int = 0, targetHeight:int = 0, fit:String = null, resizeType:String = null) {
			this.id = id;
			this.targetWidth = targetWidth;
			this.targetHeight = targetHeight;
			this.fit = getCorrectFit(fit);
			this.resizeType = getCorrectResizeType(resizeType);
		}
		
		/**
		 * @private 
		 * Image fit validator 
		 */
		private function getCorrectFit(fit:String):String {
			if (null == fit) return ImageFitType.FIT_IMAGE;
			
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
		 * Image resize type validator 
		 */
		private function getCorrectResizeType(type:String):String {
			if (null == type) return ImageResizeType.BILINEAR;
			
			switch (type.toLowerCase()) {
				case ImageResizeType.BICUBIC:
					return ImageResizeType.BICUBIC;
				case ImageResizeType.BILINEAR_ITERATIVE:
					return ImageResizeType.BILINEAR_ITERATIVE;
				case ImageResizeType.BILINEAR:
				default:
					return ImageResizeType.BILINEAR;
			}
		}
	}
}