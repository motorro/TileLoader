package tileloader.controller.tasks
{
	import org.spicefactory.lib.task.Task;
	
	import tileloader.model.AuthenticationModel;
	
	/**
	 * Cleans up order data
	 *  
	 * @author kochetkov
	 * 
	 */
	public class OrderDataCleanupTask extends Task {
		/**
		 * Constructor 
		 */
		public function OrderDataCleanupTask() {
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
			var model:AuthenticationModel = AuthenticationModel(data);
			
			model.orderToken = "";
			model.orderDirectory = null;
			
			complete();
		}
	}
}