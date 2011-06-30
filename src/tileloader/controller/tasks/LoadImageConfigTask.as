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
	import tileloader.model.VO.ImageFormatVO;
	
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
					var i:int = imageData.length();
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
						
						var format:ImageFormatVO = new ImageFormatVO(formatData.@id.toString(), int(formatData.@width.toString()), int(formatData.@height.toString()), formatData.@fit.toString());
						imageConfig[i] = format;
						if (isThumbnail) {
							appConfig.thumbnailFormat = format;
						}
					}
					
					//Sort formats from biggest to smaller to optimize resize later
					//Use pixel count as a sort parameter
					imageConfig = imageConfig.sort(function (format1:ImageFormatVO, format2:ImageFormatVO):Number {
						return format2.targetWidth * format2.targetHeight - format1.targetWidth * format1.targetHeight;						
					});
					
					//If no format set as thumbnail explicitly - choose smallest
					if (null == appConfig.thumbnailFormat) {
						appConfig.thumbnailFormat = imageConfig[imageConfig.length - 1];
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