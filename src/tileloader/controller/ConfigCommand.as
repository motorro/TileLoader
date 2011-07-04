package tileloader.controller
{
	import flash.filesystem.File;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.SequentialTaskGroup;
	import org.spicefactory.lib.task.Task;
	import org.spicefactory.lib.task.TaskGroup;
	
	import tileloader.controller.tasks.LoadConfigFileTask;
	import tileloader.controller.tasks.LoadImageConfigTask;
	import tileloader.log.LogUtils;
	import tileloader.messages.ConfigMessage;
	import tileloader.model.ApplicationConfig;
	import tileloader.model.GlobalConstants;
	import tileloader.model.SharedModel;

	/**
	 * Loads configuration file config.xml from application directory.
	 * Loads configuration parameter from server.
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ConfigCommand {
		
		[Inject]
		/**
		 * @private
		 * Config reference 
		 */
		public var config:ApplicationConfig;
		
		/**
		 * Execution method 
		 */
		public function execute(message:ConfigMessage):Task {
			
			var result:TaskGroup = new SequentialTaskGroup("Configuration");	
			result.data = config;
		
			//Load local configuration file
			result.addTask(new LoadConfigFileTask(File.applicationDirectory.resolvePath(GlobalConstants.CONFIG_FILE_NAME)));			
			
			//Load image format configuration
			result.addTask(new LoadImageConfigTask());
			
			return result;
		}
		
	}
}