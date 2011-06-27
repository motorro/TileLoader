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
	import tileloader.model.SharedModel;

	/**
	 * Loads configuration file config.xml from application directory.
	 * Loads configuration parameter from server.
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ConfigCommand {
		
		/**
		 * @private
		 * Configuration file name 
		 */
		private static const CONFIG_FILE_NAME:String = "config.xml";
		
		[Inject]
		/**
		 * @private
		 * Model reference 
		 */
		public var model:SharedModel;
		
		/**
		 * Execution method 
		 */
		public function execute(message:ConfigMessage):Task {
			//Create configuration section
			model.applicationConfig = new ApplicationConfig();
			
			var result:TaskGroup = new SequentialTaskGroup("Configuration");	
			result.data = model.applicationConfig;
		
			//Load local configuration file
			result.addTask(new LoadConfigFileTask(File.applicationDirectory.resolvePath(CONFIG_FILE_NAME)));			
			
			//Load image format configuration
			result.addTask(new LoadImageConfigTask());
			
			return result;
		}
		
	}
}