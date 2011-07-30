package tileloader.model
{
	import tileloader.messages.StartUploadMessage;

	/**
	 * Main application view presentation model 
	 * @author kochetkov
	 */
	public class MainViewModel {
		
		[MessageDispatcher]
		/**
		 * @private
		 * Parsley event dispatcher
		 */ 
		public var sendMessage:Function;
		
		/**
		 * Starts image upload 
		 */
		public function startUpload():void {
			sendMessage(new StartUploadMessage());			
		}
	}
}