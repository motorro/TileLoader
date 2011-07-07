package tileloader.messages
{
	public class UploadCancelMessage {
		
		/**
		 * Upload cancelled by user 
		 */
		public static const USER_CANCELLED:String = "userCancelled";
		
		/**
		 * Upload cancelled as an error result 
		 */
		public static const ERROR_CANCELLED:String = "errorCancelled";
		
		[Selector]
		/**
		 * Message type selector 
		 */		
		public var type:String;
		
		/**
		 * Constructor 
		 * @param type Cancel type
		 */
		public function UploadCancelMessage(type:String) {
			this.type = type;
		}
	}
}