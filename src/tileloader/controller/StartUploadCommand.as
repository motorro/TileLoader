package tileloader.controller
{
	import tileloader.messages.RescanUploadQueueMessage;
	import tileloader.messages.StartUploadMessage;
	import tileloader.model.UploaderModel;

	/**
	 * Starts image upload
	 *  
	 * @author kochetkov
	 * 
	 */
	public class StartUploadCommand {
		
		[Inject]
		/**
		 * @private
		 * Uploader model reference 
		 */
		public var uploaderModel:UploaderModel;
		
		[MessageDispatcher]
		/**
		 * @private
		 * Parsley event dispatcher
		 */ 
		public var sendMessage:Function;
		
		public function execute(message:StartUploadMessage):void {
			//TODO: Check authorization
			uploaderModel.uploading = true;
			
			sendMessage(new RescanUploadQueueMessage());
		}
	}
}