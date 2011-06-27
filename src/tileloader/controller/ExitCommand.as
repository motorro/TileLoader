package tileloader.controller
{
	import flash.desktop.NativeApplication;
	
	import tileloader.messages.ExitMessage;

	/**
	 * Application exit command
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ExitCommand {
		
		/**
		 * @private 
		 */
		public function execute(message:ExitMessage):void {
			NativeApplication.nativeApplication.exit(message.exitCode);			
		}
	}
}