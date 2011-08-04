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
		 * @private
		 * URL of authentication script. If null, no authentication check takes place. 
		 */
		private var _authenticationUrl:String;
		
		/**
		 * Constructor 
		 * @param order Order ID
		 * @param authenticationScriptURL URL of authentication script. If ommited, no authentication check takes place.
		 */
		public function AuthenticateTask(order:String, authenticationScriptURL:String = null) {
			super();
			_order = order;
			_authenticationUrl = authenticationScriptURL;
			
			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doStart():void {
			if (null != _logger) {
				_logger.info("Authenticating order: " + _order);
			}
			
			var authModel:AuthenticationModel = AuthenticationModel(data);
			authModel.orderToken = _order;
			
			complete();
		}
	}
}