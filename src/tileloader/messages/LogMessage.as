package tileloader.messages
{
	/**
	 * A log message
	 *  
	 * @author kochetkov
	 * 
	 */
	public class LogMessage	{
		/**
		 * @private 
		 */
		private var _message:String;
		/**
		 * Log message 
		 */
		public function get message():String {
			return _message;
		}

		/**
		 * Constructor 
		 * @param message Log message
		 */
		public function LogMessage(message:String) {
			_message = message;
		}
	}
}