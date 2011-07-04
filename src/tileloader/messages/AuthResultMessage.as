package tileloader.messages
{
	/**
	 * Send upon configuration result
	 *  
	 * @author kochetkov
	 * 
	 */
	public class AuthResultMessage {
		/**
		 * Authentication complete successfully 
		 */
		public static const AUTH_COMPLETE:String = "authComplete";
		
		/**
		 * Current authentication dropped 
		 */
		public static const AUTH_REMOVED:String = "authComplete";

		/**
		 * Failed to authenticate 
		 */
		public static const AUTH_FAILED:String = "authFailed";
		
		[Selector]
		/**
		 * Message selector 
		 */
		public var type:String;
		
		/**
		 * Constructor 
		 * @param type Message type
		 */
		public function AuthResultMessage(type:String) {
			this.type = type;
		}
	}
}