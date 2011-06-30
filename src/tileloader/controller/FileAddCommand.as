package tileloader.controller
{
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.SequentialTaskGroup;
	import org.spicefactory.lib.task.Task;
	import org.spicefactory.lib.task.TaskGroup;
	
	import tileloader.controller.tasks.AddFileTask;
	import tileloader.log.LogUtils;
	import tileloader.messages.FileAddMessage;
	import tileloader.model.SharedModel;

	/**
	 * Performs file addition to queue
	 *  
	 * @author kochetkov
	 * 
	 */
	public class FileAddCommand {
		
		/**
		 * @private
		 * Logger 
		 */
		private static const _logger:ILogger = LogUtils.getLoggerByClass(FileAddCommand);

		[Inject]
		/**
		 * @private
		 * Shared model reference 
		 */		
		public var model:SharedModel;
		
		/**
		 * Adds files to processing queue 
		 */
		public function execute(message:FileAddMessage):Task {
			
			var files:Array = message.files;
			
			if (null != _logger) {
				_logger.info("Adding files: " + files.length);
			}
			
			var data:ArrayCollection = model.fileList;
			if (null == data) {
				data = new ArrayCollection();
				model.fileList = data;
			}
			
			var result:TaskGroup = new SequentialTaskGroup("Adding files");	
			result.ignoreChildErrors = true;
			result.data = data;
			
			for each (var file:File in files) {
				result.addTask(new AddFileTask(file));
			}
			
			return result;
		}
	}
}