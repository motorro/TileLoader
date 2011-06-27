package tileloader.messages
{
	/**
	 * Application exit message
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ExitMessage {
		/**
		 * Application exit code 
		 */
		public var exitCode:int;
		
		/**
		 * Constructor
		 *  
		 * @param exitCode Exit code
		 * 
		 */
		public function ExitMessage(exitCode:int = 0) {
			this.exitCode = exitCode;
		}
	}
}