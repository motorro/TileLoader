package tileloader.controller.tasks
{
	import air.update.ApplicationUpdaterUI;
	import air.update.events.UpdateEvent;
	
	import flash.desktop.Updater;
	import flash.events.ErrorEvent;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	
	/**
	 * Checks for application updates
	 *  
	 * @author kochetkov
	 * 
	 */
	public class CheckForUpdatesTask extends Task {
		
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(CheckForUpdatesTask);

		/**
		 * @private
		 * Update URL to check 
		 */
		private var _url:String;
		
		/**
		 * @private
		 * Application updater 
		 */
		private var _updater:ApplicationUpdaterUI;
		
		/**
		 * Constructor 
		 * @param url Update URL to check
		 */
		public function CheckForUpdatesTask(url:String) {
			super();
			
			_url = url;
			
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
				_logger.info("Checking for updates");
			}
			
			if (false == Updater.isSupported) {
				var message:String = "Update error: Application updates not supported!";
				if (null != _logger) {
					_logger.warn(message);
				}
				error(message);
				return;
			}

			
			_updater = new ApplicationUpdaterUI();
			
			_updater.updateURL = _url;
			_updater.isCheckForUpdateVisible = false;
			_updater.addEventListener(UpdateEvent.INITIALIZED, onUpdaterInitialized);
			_updater.addEventListener(ErrorEvent.ERROR, onUpdateError);
			
			_updater.initialize();
		}
		
		/**
		 * @private
		 * Updater initialized. Try to update 
		 */
		private function onUpdaterInitialized(event:UpdateEvent):void {
			_updater.checkNow();
		}
		
		/**
		 * @private 
		 * Update error handler
		 */
		private function onUpdateError(event:ErrorEvent):void {
			var message:String = "Update error: " + event.text;
			if (null != _logger) {
				_logger.warn(message);
			}
			error(message);
			return;
		}
	}
}