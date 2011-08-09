package tileloader.controller.tasks
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.messages.MessageCodes;
	import tileloader.model.AuthenticationModel;
	import tileloader.view.LocalizedMessage;
	
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
		 * Authentication model reference 
		 */
		private var _model:AuthenticationModel;
		
		/**
		 * @private
		 * Order ID storage 
		 */
		private var _token:String;
		
		/**
		 * @private
		 * URL of authentication script. If null, no authentication check takes place. 
		 */
		private var _authenticationUrl:String;
		
		/**
		 * @private
		 * Authorization request loader 
		 */
		private var _loader:URLLoader;
		
		/**
		 * Constructor 
		 * @param token User provided authentication token
		 * @param authenticationScriptURL URL of authentication script. If ommited, no authentication check takes place.
		 */
		public function AuthenticateTask(token:String, authenticationScriptURL:String = null) {
			super();
			_token = token;
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
				_logger.info("Authenticating order: " + _token);
			}
			
			_model = AuthenticationModel(data);
			_model.userToken = _token;
			
			//Authorization shortcut
			if (null == _authenticationUrl) {
				_logger.warn("No authentication URL passed. Using shortcut.");
				_model.serverToken = _token;
				complete();
				return;
			}
			
			var request:URLRequest = new URLRequest(_authenticationUrl);
			request.method = URLRequestMethod.POST;
			
			var requestVars:URLVariables = new URLVariables();
			requestVars.token = _token;
			
			request.data = requestVars;
			
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			
			_loader.load(request);
		}
		
		/**
		 * @private
		 * Authorization attempt complete handler 
		 */
		private function onComplete(event:Event):void {
			cleanupLoader();
			
			try {
				var responseData:XML
				
				//Check for valid XML
				try {
					responseData = XML(_loader.data);
				} catch (e:Error) {
					throw(new Error("Invalid responce format. XML parse error.", MessageCodes.ERROR_AUTH_INVALID_RESPONCE_RECEIVED));
				}
				
				//Check for correct XML format
				var opResult:String = responseData.code.toString();
				if ("" == opResult) {
					throw(new Error("Invalid responce format. No result code.", MessageCodes.ERROR_AUTH_INVALID_RESPONCE_RECEIVED));
				}
				
				//Check for success
				if (MessageCodes.NO_ERROR != int(opResult)) {
					throw(new Error("Authorization error: " + responseData.message.toString(), int(opResult)));
				}
				
				//Check for correct order data received
				var orderData:XMLList = responseData.order;
				if (0 == orderData.length()) {
					throw(new Error("Invalid responce format. No order data.", MessageCodes.ERROR_AUTH_INVALID_RESPONCE_RECEIVED));
				}

				//Check for correct token received
				var orderToken:String = orderData.token.toString();
				if ("" == orderToken) {
					throw (new Error("Invalid responce format. No order token.", MessageCodes.ERROR_AUTH_NO_TOKEN_RECEIVED));
				}
				
				_model.serverToken = orderToken;
				_model.orderData = orderData[0];
				
				if (null != _logger) {
					_logger.info("Successfull server authorization for order: " + _token);
				}
				
				complete();
			} catch (e:Error) {
				if (null != _logger) {
					_logger.error("Authentication error: " + e.message);
				}
				error(LocalizedMessage.getHumanReadableError(e.message, e.errorID));
			}
		}
		
		/**
		 * @private
		 * Authorization attempt error handler 
		 */
		private function onError(event:ErrorEvent):void {
			cleanupLoader();
			if (null != _logger) {
				_logger.error("Authentication error: " + event.text);
			}
			error(LocalizedMessage.getHumanReadableError(event.text, event.errorID));
		}
		
		/**
		 * @private 
		 * Removes event listeners from authorization loader
		 */
		private function cleanupLoader():void {
			if (null == _loader) return;
			_loader.removeEventListener(Event.COMPLETE, onComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
		}
	}
}