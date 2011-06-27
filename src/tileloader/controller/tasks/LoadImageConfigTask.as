package tileloader.controller.tasks
{
	import org.spicefactory.lib.task.Task;
	
	/**
	 * Loads image configuration data
	 *  
	 * @author kochetkov
	 * 
	 */
	public class LoadImageConfigTask extends Task {
		public function LoadImageConfigTask() {
			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
	}
}