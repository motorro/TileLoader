package tileloader.controller.tasks
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.model.ResizerModel;
	
	/**
	 * Loads image file to Bitmap
	 *  
	 * @author kochetkov
	 * 
	 */
	public class LoadImageFileTask extends Task {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(LoadImageFileTask);
		
		/**
		 * @private
		 * File storage 
		 */
		private var _file:File;
		
		/**
		 * Image loader 
		 */
		private var _loader:Loader;
		
		/**
		 * Constructor 
		 * @param file File to load
		 */
		public function LoadImageFileTask(file:File){
			super();
			_file = file;
			
			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doStart():void {
			if (null != _logger) {
				_logger.info("Loading image: " + _file.nativePath);
			}
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			
			_loader.load(new URLRequest(_file.url));
		}
		
		/**
		 * @private
		 * Image loaded handler 
		 */
		private function onComplete(event:Event):void {
			//Clone bitmap
			try {
				ResizerModel(data).original = new Bitmap(Bitmap(_loader.content).bitmapData.clone());
				if (null != _logger) {
					_logger.info("Image loaded.");
				}
				_loader.unload();
				complete();
			} catch (e:Error) {
				var message:String = "Error loading image: " + e.message;
				if (null != _logger) {
					_logger.error(message);
				}
				error(message);
			}
		}
		
		/**
		 * @private
		 * Image load error handler 
		 */
		private function onError(event:ErrorEvent):void {
			var message:String = "Error loading image: " + event.text;
			if (null != _logger) {
				_logger.error(message);
			}
			error(message);
		}
	}
}