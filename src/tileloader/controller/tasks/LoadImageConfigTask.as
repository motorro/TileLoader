package tileloader.controller.tasks
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.model.ApplicationConfig;
	import tileloader.model.GlobalConstants;
	import tileloader.model.VO.ImageFormatVO;
	import tileloader.resize.ImageFitType;
	import tileloader.resize.ImageResizeType;
	
	/**
	 * Loads image configuration data
	 *  
	 * @author kochetkov
	 * 
	 */
	public class LoadImageConfigTask extends Task {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(LoadImageConfigTask);

		/**
		 * Constructor 
		 */
		public function LoadImageConfigTask() {
			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doStart():void {
			var appConfig:ApplicationConfig = ApplicationConfig(data);
			
			//Reset data
			appConfig.imageFormats = null;
			appConfig.thumbnailFormat = null;
			
			if (null != _logger) {
				_logger.info("Loading image configuration: " + appConfig.imageFormatConfigURL);
			}
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onLoadError);
			loader.load(new URLRequest(appConfig.imageFormatConfigURL));
			
			function onLoadComplete(event:Event):void {
				try {
					
					var i:int;
					var format:ImageFormatVO;
					
					var content:XML = XML(loader.data);
					
					var imageData:XMLList = content.TileLoader.imageFormat;
					
					if (0 == imageData.length()) {
						if (null != _logger) {
							_logger.warn("Empty image format list!");
						}
						complete();
						return;
					}

					var imageConfig:Vector.<ImageFormatVO> = new Vector.<ImageFormatVO>(imageData.length(), true);
					
					//Create a VO for each format in configuration file
					i = imageData.length();
					while (--i >= 0) {
						var formatData:XML = imageData[i];
						
						var isThumbnail:Boolean = false;
						var thumbnailData:XMLList = formatData.@thumbnail;
						if (0 != thumbnailData.length()) {
							var s:String = thumbnailData.toString().toLowerCase();
							if ("true" == s || "1" == s) {
								isThumbnail = true;
							}
						}
						
						format = new ImageFormatVO(formatData.@id.toString(), int(formatData.@width.toString()), int(formatData.@height.toString()), formatData.@fit.toString(), formatData.@type.toString());
						imageConfig[i] = format;
						if (isThumbnail) {
							appConfig.thumbnailFormat = format;
							if (null != _logger) {
								_logger.info("Thumbnail format selected explicitly: " + format.id);
							}
						}
					}
					
					//Sort formats from biggest to smaller to optimize resize later
					//Use pixel count as a sort parameter
					imageConfig = imageConfig.sort(function (format1:ImageFormatVO, format2:ImageFormatVO):Number {
						return format2.targetWidth * format2.targetHeight - format1.targetWidth * format1.targetHeight;						
					});
					
					//If no format set as thumbnail explicitly - choose the one that is appropriate according to settings
					if (null == appConfig.thumbnailFormat) {
						var targetFormat:ImageFormatVO = null;
						i = imageConfig.length;
						while (--i >= 0) {
							format = imageConfig[i];
							var formatWidth:int = format.targetWidth;
							var formatHeight:int = format.targetHeight;
							if (	formatWidth >= GlobalConstants.THUMBNAIL_MIN_WIDTH 
								&& 	formatWidth <= GlobalConstants.THUMBNAIL_MAX_WIDTH
								&&	formatHeight >= GlobalConstants.THUMBNAIL_MIN_HEIGHT
								&&	formatHeight <= GlobalConstants.THUMBNAIL_MAX_HEIGHT) {
								targetFormat = format;
								if (null != _logger) {
									_logger.info("Thumbnail format selected implicitly: " + format.id);
								}
								break;
							}
						}
						
						//No appropriate format. Create new one
						if (null == targetFormat) {
							targetFormat = new ImageFormatVO("_thumbnail_", GlobalConstants.THUMBNAIL_MIN_WIDTH, GlobalConstants.THUMBNAIL_MIN_HEIGHT, ImageFitType.FIT_IMAGE, ImageResizeType.BILINEAR);
							if (null != _logger) {
								_logger.info("Thumbnail format created.");
							}
						}
						
						appConfig.thumbnailFormat = targetFormat;
					}
					
					//Sort formats from biggest to smaller to optimize resize later
					//Use pixel count as a sort parameter
					appConfig.imageFormats = imageConfig;
					
					if (null != _logger) {
						_logger.info("Image config loaded.");
					}
					
					complete();
				} catch (e:Error) {
					if (null != _logger) {
						_logger.error("Invalid image config format.");
					}
					error("Invalid image config format.");
				}
			}
		}
		
		/**
		 * @private
		 * Load error handler 
		 */
		private function onLoadError(event:ErrorEvent):void {
			var message:String = "Error loading image config: " + event.text;
			if (null != _logger) {
				_logger.error(message);
			}
			error(message);
		}
	}
}