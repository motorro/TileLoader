package tileloader.messages
{
	public class AuthenticateMessage {
		
		/**
		 * Authentication token 
		 */
		public var token:String;
		
		/**
		 * Constructor 
		 * @param token Authentication token 
		 */
		public function AuthenticateMessage(token:String) {
			this.token = token;
		}
	}
}