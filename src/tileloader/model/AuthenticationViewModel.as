package tileloader.model
{
	/**
	 * Authentication view presentation model
	 *  
	 * @author kochetkov
	 * 
	 */
	public class AuthenticationViewModel {
		[MessageDispatcher]
		/**
		 * @private
		 * Parsley event dispatcher
		 */ 
		public var sendMessage:Function;
		
		/**
		 * Checks passed token at authorization server 
		 * @param token String token given for upload
		 */
		public function checkToken(token:String):void {
						
		}

	}
}