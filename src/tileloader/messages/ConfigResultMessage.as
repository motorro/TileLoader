package tileloader.messages
{
	/**
	 * Send upon configuration result
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ConfigResultMessage {
		/**
		 * Configuration complete successfully 
		 */
		public static const CONFIG_COMPLETE:String = "configComplete";
		
		/**
		 * Failed to configure 
		 */
		public static const CONFIG_FAILED:String = "configFailed";
		
		[Selector]
		/**
		 * Message selector 
		 */
		public var type:String;
		
		/**
		 * Constructor 
		 * @param type Message type
		 */
		public function ConfigResultMessage(type:String) {
			this.type = type;
		}
	}
}