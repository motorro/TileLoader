package tileloader.controller
{
	import flash.filesystem.File;
	
	import mx.controls.Image;
	
	import org.spicefactory.lib.task.SequentialTaskGroup;
	import org.spicefactory.lib.task.Task;
	import org.spicefactory.lib.task.TaskGroup;
	
	import tileloader.controller.tasks.CreateThumbnailTask;
	import tileloader.controller.tasks.FormatResizeCleanupTask;
	import tileloader.controller.tasks.ImageEncodeTask;
	import tileloader.controller.tasks.ImageMeasureTask;
	import tileloader.controller.tasks.ImageResizeCleanupTask;
	import tileloader.controller.tasks.ImageResizeTask;
	import tileloader.controller.tasks.ImageRotateTask;
	import tileloader.controller.tasks.ImageSaveTask;
	import tileloader.controller.tasks.LoadImageFileTask;
	import tileloader.messages.ImageEvent;
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
			var image:ImageVO = resizerModel.imageInProgress = message.image;
			
			//Cleanup
			if (null != resizerModel.output) {
				resizerModel.output.dispose();
				resizerModel.output = null;
			}

			image.isBeingResized = true;
			image.dispatchEvent(new ImageEvent(ImageEvent.RESIZE_START));
			
			var result:TaskGroup = new SequentialTaskGroup("Resizing file");	
			result.data = resizerModel;
			
			//Load original file
			result.addTask(new LoadImageFileTask(message.image.path));
			
			//Measure original image
			result.addTask(new ImageMeasureTask(image));
			
			//Add rotation command if rotation enabled
			if (resizerModel.exifRotate) {
				result.addTask(new ImageRotateTask());
			}
			
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
				result.addTask(new FormatResizeCleanupTask(image, imageFormat, configModel.thumbnailFormat));
			}
			
			//Create image thumbnail if no thumbnail found
			result.addTask(new CreateThumbnailTask(image, configModel.thumbnailFormat));
			
			result.addTask(new ImageResizeCleanupTask());
			
			return result;
		}
	}
}