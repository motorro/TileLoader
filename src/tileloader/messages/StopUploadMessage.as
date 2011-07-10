package tileloader.messages
{
	/**
	 * Message that stopps upload queues
	 *  
	 * @author kochetkov
	 * 
	 */
	public class StopUploadMessage {
		
		/**
		 * Upload cancelled by user 
		 */
		public static const USER_CANCELLED:String = "userCancelled";
		
		/**
		 * Upload cancelled as an error result 
		 */
		public static const ERROR:String = "error";
		
		/**
		 * Upload finished 
		 */
		public static const FINISHED:String = "finished";

		[Selector]
		/**
		 * Message type selector 
		 */		
		public var type:String;
		
		/**
		 * Constructor 
		 * @param type Stop type
		 */
		public function StopUploadMessage(type:String) {
			this.type = type;
		}
	}
}