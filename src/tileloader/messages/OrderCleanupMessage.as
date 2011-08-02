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
		 * Orders to cleanup
		 */		
		public var orders:Array;
		
		/**
		 * Constructor 
		 * @param orders Order names to cleanup or NULL to cleanup all orders
		 * 
		 */
		public function OrderCleanupMessage(order:Array = null) {
			this.orders = orders;
		}
	}
}