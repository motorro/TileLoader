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
			if (null == model.orderToken || "" == model.orderToken) {
				return null;
			}

			var result:TaskGroup = new SequentialTaskGroup("Order cleanup");	
			result.data = model;
			
			//TODO: Order cleanup code here
			
			var tempFolder:File = File.applicationStorageDirectory.resolvePath(model.orderToken);
			result.addTask(new FolderCleanupTask(tempFolder));
			result.addTask(new OrderDataCleanupTask());
			
			return result;
		}
	}
}