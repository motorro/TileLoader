package tileloader.model
{
	import tileloader.messages.StartUploadMessage;

	public class MainViewModel {
		[MessageDispatcher]
		/**
		 * @private
		 * Parsley event dispatcher
		 */ 
		public var sendMessage:Function;
		
		//FIXME: Temporary order token update

		[Inject]
		public var authModel:AuthenticationModel;
		
		public function updateOrderToken(token:String):void {
			authModel.tempToken = token;			
		}
		
		/**
		 * Starts image upload 
		 */
		public function startUpload():void {
			sendMessage(new StartUploadMessage());			
		}
	}
}