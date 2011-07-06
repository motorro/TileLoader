package tileloader.controller
{
	import flash.filesystem.File;
	
	import mx.controls.Image;
	
	import org.spicefactory.lib.task.SequentialTaskGroup;
	import org.spicefactory.lib.task.Task;
	import org.spicefactory.lib.task.TaskGroup;
	
	import tileloader.controller.tasks.FormatResizeCleanupTask;
	import tileloader.controller.tasks.ImageEncodeTask;
	import tileloader.controller.tasks.ImageResizeCleanupTask;
	import tileloader.controller.tasks.ImageResizeTask;
	import tileloader.controller.tasks.ImageSaveTask;
	import tileloader.controller.tasks.LoadImageFileTask;
	import tileloader.messages.ResizeImageMessage;
	import tileloader.model.ApplicationConfig;
	import tileloader.model.AuthenticationModel;
	import tileloader.model.ResizerModel;
	import tileloader.model.VO.ImageFormatFileVO;
	import tileloader.model.VO.ImageFormatVO;
	import tileloader.model.VO.ImageVO;

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
		public var resizerModel:ResizerModel;
		
		[Inject]
		/**
		 * @private
		 * Reference to application settings 
		 */
		public var configModel:ApplicationConfig;
		
		[Inject]
		/**
		 * @private
		 * Reference to order authentication 
		 */
		public var authenticationModel:AuthenticationModel;
		
		/**
		 * Starts image resize
		 */
		public function execute(message:ResizeImageMessage):Task {
			var image:ImageVO = resizerModel.fileInProgress = message.image;
			
			//Cleanup
			if (null != resizerModel.output) {
				resizerModel.output.dispose();
				resizerModel.output = null;
			}
			
			var result:TaskGroup = new SequentialTaskGroup("Resizing file");	
			result.data = resizerModel;
			
			//Load original file
			result.addTask(new LoadImageFileTask(message.image.path));
			
			//Add resize task for each required format
			for each (var format:ImageFormatVO in configModel.imageFormats) {
				//Generate file name
				var fileName:String = image.uid + "_" + format.id + ".jpg";
				var file:File = authenticationModel.orderDirectory.resolvePath(fileName);
				
				var imageFormat:ImageFormatFileVO = new ImageFormatFileVO(file, format);
				
				//Resize task
				result.addTask(new ImageResizeTask(format));
				//Encode task
				result.addTask(new ImageEncodeTask());
				//Save to disk task
				result.addTask(new ImageSaveTask(imageFormat));
				//Cleanup
				result.addTask(new FormatResizeCleanupTask(image, imageFormat));
			}
			
			result.addTask(new ImageResizeCleanupTask());
			
			return result;
		}
	}
}