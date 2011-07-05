package tileloader.model.VO
{
	import tileloader.resize.ImageFitType;

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
		 * Constructor 
		 * @param targetWidth Target image width
		 * @param targetHeight Target image height
		 * @param fit Target image fit type
		 * 
		 */
		public function ImageFormatVO(id:String = null, targetWidth:int = 0, targetHeight:int = 0, fit:String = null) {
			this.id = id;
			this.targetWidth = targetWidth;
			this.targetHeight = targetHeight;
			this.fit = (null == fit) ? ImageFitType.FIT_IMAGE : fit;
		}
	}
}