package tileloader.controller
{
	import tileloader.messages.UploadCancelMessage;
	import tileloader.model.UploaderModel;

	/**
	 * Command to handle user cancelled upload 
	 *  
	 * @author kochetkov
	 * 
	 */
	public class UploadCancelledByUserCommand {
		
		[Inject]
		/**
		 * @private
		 * Uploader model refeence 
		 */
		public var model:UploaderModel;
		
		/**
		 * Cancells upload
		 *  
		 * @param message
		 * 
		 */
		public function execute(message:UploadCancelMessage):void {
			model.uploading = false;
		}
	}
}