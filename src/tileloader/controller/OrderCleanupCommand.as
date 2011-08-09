package tileloader.controller
{
	import flash.filesystem.File;
	
	import org.spicefactory.lib.task.SequentialTaskGroup;
	import org.spicefactory.lib.task.Task;
	import org.spicefactory.lib.task.TaskGroup;
	
	import tileloader.controller.tasks.FolderCleanupTask;
	import tileloader.controller.tasks.OrderDataCleanupTask;
	import tileloader.messages.OrderCleanupMessage;
	import tileloader.model.AuthenticationModel;
	import tileloader.model.GlobalConstants;
	
	import utils.MD5;

	/**
	 * Removes any temporary data for given order 
	 * @author kochetkov
	 * 
	 */
	public class OrderCleanupCommand {
		
		[Inject]
		/**
		 * @private
		 * Authentication model reference 
		 */		
		public var model:AuthenticationModel;
		
		
		/**
		 * Removes temporary folder and data for given order 
		 */
		public function execute(message:OrderCleanupMessage):Task {
			var result:TaskGroup = new SequentialTaskGroup("Order folder cleanup");	
			result.data = model;
			var i:int;
			var file:File;
			
			if (null == message.orders) {
				//Cleanup all directories
				var dirList:Array = File.applicationStorageDirectory.getDirectoryListing();
				i = dirList.length;
				while (--i >=0) {
					file = File(dirList[i]);
					//Delete directories only
					if (false == file.isDirectory) continue;
					//Do not delete excludes
					if (GlobalConstants.FOLDER_CLEANUP_EXCLUDES.indexOf(file.name) >= 0) continue;
					result.addTask(new FolderCleanupTask(file));
				}
			} else {
				i = message.orders.length;
				while (--i >=0) {
					file = File.applicationStorageDirectory.resolvePath(MD5.encrypt(message.orders[i]));
					//Delete existing directories only
					if (false == file.isDirectory) continue;
					if (false == file.exists || false == file.isDirectory) continue;
					result.addTask(new FolderCleanupTask(file));
				}
			}
			
			result.addTask(new OrderDataCleanupTask());
			
			return result;
		}
	}
}