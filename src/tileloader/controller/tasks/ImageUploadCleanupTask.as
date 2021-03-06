package tileloader.controller.tasks
{
	import org.spicefactory.lib.task.Task;
	
	import tileloader.messages.ImageEvent;
	import tileloader.model.UploaderModel;
	
	/**
	 * Cleans up upon image is uploaded successfully
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageUploadCleanupTask extends Task {
		/**
		 * Constructor 
		 */
		public function ImageUploadCleanupTask() {
			super();
			
			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doStart():void {
			var model:UploaderModel = UploaderModel(data);
			
			model.imageInProgress.isBeingUploaded = false;
			model.imageInProgress.dispatchEvent(new ImageEvent(ImageEvent.UPLOAD_COMPLETE));
			
			model.initialize();
			
			complete();
		}
	}
}