package tileloader.model
{
	import mx.logging.ILogger;
	import mx.utils.StringUtil;
	
	import tileloader.log.LogUtils;
	import tileloader.messages.AuthenticateMessage;

	/**
	 * Authentication view presentation model
	 *  
	 * @author kochetkov
	 * 
	 */
	public class AuthenticationViewModel {
		/**
		 * @private
		 * Logger 
		 */
		private static const _logger:ILogger = LogUtils.getLoggerByClass(AuthenticationViewModel);
		
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
			//Check for empty string
			if (null == token || "" == StringUtil.trim(token)) return;
			
			//TODO: Checking token serverside goes here
			
			if (null != _logger) {
				_logger.info("Authenticating upload token: " + token);
			}
			
			sendMessage(new AuthenticateMessage(token));
		}

	}
}