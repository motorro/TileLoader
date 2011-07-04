package tileloader.messages
{
	/**
	 * Message to initiate application data cleanup
	 *  
	 * @author kochetkov
	 * 
	 */
	public class OrderCleanupMessage {
		
		/**
		 * Order to cleanup
		 */		
		public var order:String;
		
		/**
		 * Constructor 
		 * @param order Order to cleanup
		 * 
		 */
		public function OrderCleanupMessage(order:String) {
			this.order = order;
		}
	}
}