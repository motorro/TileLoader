package tileloader.controller.tasks
{
	import org.spicefactory.lib.task.Task;
	
	import tileloader.model.ResizerModel;
	
	/**
	 * Clean-up after image is resized
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageResizeCleanupTask extends Task
	{
		/**
		 * Constructor 
		 */
		public function ImageResizeCleanupTask() {
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
			var model:ResizerModel = ResizerModel(data);	
			
			model.original.unload();
			model.original = null;
			
			model.fileInProgress.complete = true;
			model.fileInProgress = null;
			
			if (null != model.output) {
				model.output.dispose();
				model.output = null;
			}
			
			model.encoded = null;
			
			complete();
		}
	}
}