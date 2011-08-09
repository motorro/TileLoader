package tileloader.controller.tasks
{
	import flash.filesystem.File;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.model.AuthenticationModel;
	
	import utils.MD5;
	
	/**
	 * Creates order temp directory
	 *  
	 * @author kochetkov
	 * 
	 */
	public class CreateOrderFolderTask extends Task {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(CreateOrderFolderTask);
		
		/**
		 * @private
		 * Folder path storage 
		 */
		private var _baseFolder:File;
		
		/**
		 * Constructor 
		 * @param order Folder to create
		 */
		public function CreateOrderFolderTask(baseFolder:File) {
			super();
			_baseFolder = baseFolder;
			
			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doStart():void {
			
			var orderSubDir:String = MD5.encrypt(AuthenticationModel(data).userToken);
			
			var dir:File = _baseFolder.resolvePath(orderSubDir);
			
			if (null != _logger) {
				_logger.info("Creating folder: " + dir.nativePath);
			}
			
			try {
				dir.createDirectory();
				if (null != _logger) {
					_logger.info("Created.");
				}
				AuthenticationModel(data).orderDirectory = dir;
				complete();
			} catch (e:Error) {
				var message:String = "Error creating order directory: " + e.message;
				if (null != _logger) {
					_logger.error(message);
				}
				error(message);
			}
			
		}
	}
}