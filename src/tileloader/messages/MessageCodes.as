package tileloader.messages
{
	/**
	 * Application exit messages 
	 * 
	 * @author kochetkov
	 * 
	 */
	public class MessageCodes {
		/**
		 * No error 
		 */
		public static const NO_ERROR:int = 0;

		//Error messages
		/**
		 * Error code 
		 */
		public static const ERROR:int = 1000;
		
		//Authorization messages
		/**
		 * Server responded with "empty token passed". 
		 */
		public static const ERROR_AUTH_EMPTY_TOKEN_PASSED:int = ERROR + 110;
		/**
		 * Server responded with "invalid token passed". 
		 */
		public static const ERROR_AUTH_INVALID_TOKEN_PASSED:int = ERROR + 120;
		/**
		 * Invalid data received from server 
		 */
		public static const ERROR_AUTH_INVALID_RESPONCE_RECEIVED:int = ERROR + 150;
		/**
		 * No token received from server 
		 */
		public static const ERROR_AUTH_NO_TOKEN_RECEIVED:int = ERROR + 160;
		
		
		//Exit messages
		
		/**
		 * Configuration error 
		 */
		public static const CONFIG_ERROR:int = 100;
		
		/**
		 * Disk operation error 
		 */
		public static const DISK_OPERATION_ERROR:int = 200;
	
		/**
		 * Disk operation error 
		 */
		public static const NETWORK_ERROR:int = 300;

	}
}