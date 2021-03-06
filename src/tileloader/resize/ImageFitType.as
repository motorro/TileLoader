package tileloader.resize
{
	/**
	 * Image fit types
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageFitType {
		/**
		 * Image is fit into window. No cropping. 
		 */
		public static const FIT_IMAGE:String = "image";
		/**
		 * Image is fit to fill the window. Cropping ocqures if ratios are different. 
		 */
		public static const FIT_WINDOW:String = "window";
	}
}