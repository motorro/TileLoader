package tileloader.controller
{
	import tileloader.model.AuthenticationModel;
	import tileloader.model.OrderModel;

	/**
	 * Controller for order. Responsible for authentication, thumbnailing and uploading
	 *  
	 * @author kochetkov
	 * 
	 */
	public class OrderController {
		[Inject]
		/**
		 * @private
		 * Order data model 
		 */
		public var model:OrderModel;
		
		[Inject]
		/**
		 * @private
		 * Order authentication model 
		 */
		public var authentication:AuthenticationModel;
		
	}
}