package tileloader.controller
{
	import flash.filesystem.File;
	
	import org.spicefactory.lib.task.SequentialTaskGroup;
	import org.spicefactory.lib.task.Task;
	import org.spicefactory.lib.task.TaskGroup;
	
	import tileloader.controller.tasks.AuthenticateTask;
	import tileloader.controller.tasks.CreateOrderFolderTask;
	import tileloader.messages.AuthenticateMessage;
	import tileloader.model.AuthenticationModel;
	import tileloader.model.GlobalConstants;

	/**
	 * Authenticates new order
	 *  
	 * @author kochetkov
	 * 
	 */
	public class AuthenticateCommand {
		
		[Inject]
		/**
		 * @private
		 * Reference to authentication model 
		 */
		public var model:AuthenticationModel;
		
		/**
		 * Authenticates order that is passed in message 
		 */
		public function execute(message:AuthenticateMessage):Task {
			
			var result:TaskGroup = new SequentialTaskGroup("Order authentication");	
			result.data = model;
			
			//TODO: Order authentication code here
			
			result.addTask(new AuthenticateTask(message.order));
			
			var baseFolder:File = File.applicationStorageDirectory;
			result.addTask(new CreateOrderFolderTask(baseFolder));
			
			return result;
		}
	}
}