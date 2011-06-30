package tileloader.controller
{
	import tileloader.messages.FileAddMessage;
	import tileloader.messages.FileDropMesage;

	/**
	 * Initiates file additon upon drop-in
	 *  
	 * @author kochetkov
	 * 
	 */
	public class FileDropCommand {
		[MessageDispatcher]
		/**
		 * @private
		 * Parsley event dispatcher
		 */ 
		public var sendMessage:Function;
		
		/**
		 * Adds files to queue 
		 */
		public function execute(message:FileDropMesage):void {
			sendMessage(new FileAddMessage(message.files));
		}
	}
}