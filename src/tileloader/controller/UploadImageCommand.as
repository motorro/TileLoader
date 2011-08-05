package tileloader.controller
{
	import org.spicefactory.lib.task.SequentialTaskGroup;
	import org.spicefactory.lib.task.Task;
	import org.spicefactory.lib.task.TaskGroup;
	
	import tileloader.controller.tasks.ImageRemoveTask;
	import tileloader.controller.tasks.ImageUploadCleanupTask;
	import tileloader.controller.tasks.ImageUploadTask;
	import tileloader.messages.ImageEvent;
	import tileloader.messages.UploadImageMessage;
	import tileloader.model.ApplicationConfig;
	import tileloader.model.AuthenticationModel;
	import tileloader.model.SharedModel;
	import tileloader.model.UploaderModel;
	import tileloader.model.VO.ImageFormatFileVO;
	import tileloader.model.VO.ImageFormatVO;
	import tileloader.model.VO.ImageVO;

	/**
	 * Command to upload image on server
	 *  
	 * @author kochetkov
	 * 
	 */
	public class UploadImageCommand {
		[Inject]
		/**
		 * @private
		 * Reference to uploader model 
		 */		
		public var uploaderModel:UploaderModel;
		
		[Inject]
		/**
		 * @private
		 * Reference to shared model 
		 */		
		public var sharedModel:SharedModel;

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
		public function execute(message:UploadImageMessage):Task {
			var image:ImageVO = uploaderModel.imageInProgress = message.image;
			
			image.isBeingUploaded = true;
			image.dispatchEvent(new ImageEvent(ImageEvent.UPLOAD_START));
			
			var result:TaskGroup = new SequentialTaskGroup("Upload file");	
			result.data = uploaderModel;
			
			//Add upload task for each image format
			for each (var format:ImageFormatFileVO in image.formats) {
				result.addTask(new ImageUploadTask(configModel.imageUploadURL, authenticationModel.orderToken, format));
			}
			
			//Remove file from temp directory and queue
			result.addTask(new ImageRemoveTask(sharedModel.fileList, image));
				
			//Add cleanup task
			result.addTask(new ImageUploadCleanupTask());
			
			return result;
		}
		
	}
}