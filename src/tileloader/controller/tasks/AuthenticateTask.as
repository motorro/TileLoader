package tileloader.controller.tasks
{
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.model.AuthenticationModel;
	
	/**
	 * Authenticates given order
	 *  
	 * @author kochetkov
	 * 
	 */
	public class AuthenticateTask extends Task {
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(AuthenticateTask);
		
		/**
		 * @private
		 * Order ID storage 
		 */
		private var _order:String;
		
		/**
		 * Constructor 
		 * @param order Order ID
		 */
		public function AuthenticateTask(order:String) {
			super();
			_order = order;
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doStart():void {
			if (null != _logger) {
				_logger.info("Authenticating order: " + _order);
			}
			
			//TODO: Order authentication here
			
			var authModel:AuthenticationModel = AuthenticationModel(data);
			authModel.orderToken = "-=ORDER=-";
			
			complete();
		}
	}
}