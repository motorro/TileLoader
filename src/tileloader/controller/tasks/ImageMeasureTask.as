package tileloader.controller.tasks
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import jp.shichiseki.exif.ExifInfo;
	import jp.shichiseki.exif.ExifLoader;
	import jp.shichiseki.exif.IFD;
	import jp.shichiseki.exif.IFDSet;
	import jp.shichiseki.exif.TIFFHeader;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.model.ResizerModel;
	import tileloader.model.VO.ImageVO;
	import tileloader.resize.BenderLosslessImageRotator;
	
	/**
	 * Measures original image
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageMeasureTask extends Task {
		
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(ImageMeasureTask);

		/**
		 * @private
		 * Image VO storage 
		 */
		private var _image:ImageVO;
		
		/**
		 * @private
		 * Resize model reference 
		 */
		private var _model:ResizerModel;
		
		/**
		 * Constructor 
		 * @param image Image to measure
		 */
		public function ImageMeasureTask(image:ImageVO) {
			super();
			
			_image = image;
			
			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doStart():void {
			
			_model = ResizerModel(data)
			var bitmap:Bitmap = _model.original.content as Bitmap;
			
			if (null == bitmap) {
				var message:String = "Error loading image: Loaded file is not an image!";
				if (null != _logger) {
					_logger.error(message);
				}
				error(message);
				return;
			}
			
			_image.orientation = bitmap.width >= bitmap.height ? ImageVO.LANDSCAPE : ImageVO.PORTRAIT;
			
			if (null != _logger) {
				_logger.info("Loaded image: " + bitmap.width + "x" + bitmap.height + " (" + _image.orientation + ")");
			}
			
			//Init rotation value
			_model.rotation = null;
			
			//Get EXIF data
			var exifData:ExifInfo = _image.exifData = _model.original is ExifLoader ? ExifLoader(_model.original).exif : null;
			
			if (null == exifData) {
				if (null != _logger) {
					_logger.warn("No EXIF data available");
				}
				complete();
				return;
			}
			
			if (null != _logger) {
				_logger.info("EXIF data available");
			}
			
			//Get EXIF orientation and change measured values according to following:
			// - Image orientation differs from EXIF pixel values:
			// 		rotatation has been applied manually without changing EXIF - do nothing 
			// - Image orientation corresponds to EXIF values and EXIF orientation is not 1:
			//		rotate image
			
			//Try to obtain required values. If any operation fails - do not rotate
			try {
				var exifWidth:int = exifData.ifds.exif.PixelXDimension;
				var exifHeight:int = exifData.ifds.exif.PixelYDimension;
				var exifOrientation:int = exifData.ifds.primary.Orientation;
				
				if (exifWidth > exifHeight != bitmap.width >= bitmap.height) {
					//Image was rotated manually without exif correction.
					//Abort
					if (null != _logger) {
						_logger.warn("Image was rotated manually. No correction.");
					}
					complete();
					return;
				}
				
				if (exifOrientation <= 0 || exifOrientation > 8) {
					//No orientation data or incorrect data
					//Abort
					if (null != _logger) {
						_logger.warn("No or incorrect rotation data in EXIF. No correction.");
					}
					complete();
					return;
				}
				
				if (1 == exifOrientation) {
					//Scene is normally alligned
					if (null != _logger) {
						_logger.info("No rotation needed.");
					}
					complete();
					return;
				}
				
				switch (exifOrientation) {
					case 3:
						_model.rotation = BenderLosslessImageRotator.ROTATE_180;
						break;
					case 6:
						_model.rotation = BenderLosslessImageRotator.ROTATE_90;
						//Update image orientation
						_image.orientation = exifHeight >= exifWidth ? ImageVO.LANDSCAPE : ImageVO.PORTRAIT;
						break;
					case 8:
						_model.rotation = BenderLosslessImageRotator.ROTATE_270;
						//Update image orientation
						_image.orientation = exifHeight >= exifWidth ? ImageVO.LANDSCAPE : ImageVO.PORTRAIT;
						break;
					default:
						//TOFO: Implement other modes
						if (null != _logger) {
							_logger.warn("Rotation mode " + exifOrientation.toString() + " is not supported!");
						}
						complete();
						return;
				}
				
				if (null != _logger) {
					_logger.warn("Rotation to apply: " + _model.rotation);
				}
				
				complete();
			} catch (e:Error) {
				if (null != _logger) {
					_logger.warn("Insufficient EXIF data. No rotation.");
				}
				complete();
				return;
			}
			
		}
	}
}