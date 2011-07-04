package tileloader.messages
{
	public class AuthenticateMessage {
		
		/**
		 * Order to make active 
		 */
		public var order:String;
		
		/**
		 * Constructor 
		 * @param order Order to make active
		 */
		public function AuthenticateMessage(order:String) {
			this.order = order;
		}
	}
}