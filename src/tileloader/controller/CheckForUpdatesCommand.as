package tileloader.controller
{
	import org.spicefactory.lib.task.SequentialTaskGroup;
	import org.spicefactory.lib.task.Task;
	import org.spicefactory.lib.task.TaskGroup;
	
	import tileloader.controller.tasks.CheckForUpdatesTask;
	import tileloader.messages.CheckForUpdatesMessage;

	/**
	 * Checks for software updates
	 *  
	 * @author kochetkov
	 * 
	 */
	public class CheckForUpdatesCommand {
		/**
		 * Checks if updates are available 
		 */
		public function execute(message:CheckForUpdatesMessage):Task {
			var result:TaskGroup = new SequentialTaskGroup("Checking for update");	
			
			result.addTask(new CheckForUpdatesTask(message.url));
			
			return result;
		}
	}
}