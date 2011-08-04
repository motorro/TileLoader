package tileloader.view
{
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.utils.StringUtil;

	[ResourceBundle("messages")]

	/**
	 * Functions to find a localized ("user" readable) message 
	 * @author kochetkov
	 */
	public class LocalizedMessage {
		/**
		 * @private
		 * Prefix for error messages 
		 */
		private static const ERROR_PREFIX:String = "err";
		
		/**
		 * @private
		 * Prefix for ordinary messages 
		 */
		private static const MESSAGE_PERFIX:String = "msg";
		
		
		/**
		 * Returns localized message if possible, original message otherwize 
		 * @param message Original message text
		 * @param id Message ID to look resource file for
		 * @param parameters Optional parameters to substitute
		 * @return Localized message if found, original otherwize
		 */
		public static function getHumanReadableMessage(message:String = "", id:int = 0, parameters:Array = null):String {
			return getHRM(MESSAGE_PERFIX, message, id, parameters);
		}

		/**
		 * Returns localized error if possible, original error message otherwize 
		 * @param message Original error message text
		 * @param id Message ID to look resource file for
		 * @param parameters Optional parameters to substitute
		 * @return Localized error message if found, original otherwize
		 */
		public static function getHumanReadableError(message:String = "", id:int = 0, parameters:Array = null):String {
			return getHRM(ERROR_PREFIX, message, id, parameters);
		}
		
		/**
		 * @private
		 * Base function for getting localized messages 
		 * @param prefix Resource prefix
		 * @param message Original message
		 * @param id Resource ID
		 * @param parameters Optional parameters to substitute
		 * @return Localized message if found, original otherwize 
		 */
		private static function getHRM(prefix:String, message:String, id:int, parameters:Array):String {
			var result:String = null;
			
			//Try to find localized message
			if (0 != id) {
				result = getHRMFromResource(id, prefix, parameters);
			}
			
			return null != result ? result : returnMessage();
			
			function returnMessage():String {
				//No parameters passed - return message
				if (null == parameters) {
					return message;
				} 
				//Return message with substituted parameters
				parameters.unshift(message);
				return StringUtil.substitute.apply(null, parameters);
			}
		}
		
		/**
		 * @private
		 * Searches resource bundle for given "prefix+ID" resource 
		 * @param id Resource ID
		 * @param prefix REsource prefix
		 * @param parameters Optional parameters to substitute
		 * @return Localized message if found, null otherwize
		 */
		private static function getHRMFromResource(id:int, prefix:String, parameters:Array):String {
			var rm:IResourceManager = ResourceManager.getInstance();
			return rm.getString("messages", prefix + id.toString(), parameters)
		}
	
	
	}
}