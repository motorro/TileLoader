package tileloader.controller.tasks
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.logging.ILogger;
	import mx.utils.StringUtil;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.model.ApplicationConfig;
	
	/**
	 * Loads local configuration file
	 *  
	 * @author kochetkov
	 * 
	 */
	public class LoadConfigFileTask extends Task {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(LoadConfigFileTask);

		/**
		 * @private
		 * Reference to configuration file 
		 */
		private var _file:File;
		
		/**
		 * Constructor 
		 * @param file Configuration file reference
		 */
		public function LoadConfigFileTask(file:File) {
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
				_logger.info("Loading configuration file: " + _file.nativePath);
			}
			
			var stream:FileStream = new FileStream();
			stream.addEventListener(Event.COMPLETE, onFileComplete);
			stream.addEventListener(IOErrorEvent.IO_ERROR, onFileError);
			
			stream.openAsync(_file, FileMode.READ);
			
			function onFileComplete(event:Event):void {
				stream.removeEventListener(Event.COMPLETE, onFileComplete);
				
				var contents:String = stream.readUTFBytes(stream.bytesAvailable);
				
				try {
					var content:XML = XML(contents);
					var appConfig:ApplicationConfig = ApplicationConfig(data);
					
					var setupData:XMLList = content.TileLoader;
					
					appConfig.authURL = StringUtil.trim(setupData.authURL.toString());
					appConfig.albumListURL = StringUtil.trim(setupData.albumListURL.toString());
					appConfig.imageFormatConfigURL = StringUtil.trim(setupData.imageFormatConfigURL.toString());
					appConfig.imageUploadURL = StringUtil.trim(setupData.imageUploadURL.toString());
					
					if (null != _logger) {
						_logger.info("Config file loaded.");
					}

					complete();
				} catch (e:Error) {
					if (null != _logger) {
						_logger.error("Invalid config file format.");
					}
					error("Invalid config file format.");
				}
				
				stream.close();
			}			
		}
		
		/**
		 * @Private 
		 * File read error handler
		 */
		private function onFileError(event:IOErrorEvent):void {
			var message:String = "Error loading configuration file: " + event.text;
			if (null != _logger) {
				_logger.error(message);
			}
			error(message);
		}
	}
}