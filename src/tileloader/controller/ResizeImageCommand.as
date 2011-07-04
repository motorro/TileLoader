package tileloader.controller
{
	import org.spicefactory.lib.task.SequentialTaskGroup;
	import org.spicefactory.lib.task.Task;
	import org.spicefactory.lib.task.TaskGroup;
	
	import tileloader.controller.tasks.LoadImageFileTask;
	import tileloader.messages.ResizeImageMessage;
	import tileloader.model.ResizerModel;

	/**
	 * Command to resize image file
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ResizeImageCommand {

		[Inject]
		/**
		 * @private
		 * Reference to resizer model 
		 */		
		public var model:ResizerModel;
		
		/**
		 * Starts image resize
		 */
		public function execute(message:ResizeImageMessage):Task {
			model.fileInProgress = message.image;
			
			var result:TaskGroup = new SequentialTaskGroup("Resizing file");	
			result.data = model;
			
			//Load original file
			result.addTask(new LoadImageFileTask(message.image.path));
			
			return result;
		}
	}
}