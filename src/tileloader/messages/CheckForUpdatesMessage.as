package tileloader.messages
{
	/**
	 * Initiates update check
	 *  
	 * @author kochetkov
	 * 
	 */
	public class CheckForUpdatesMessage {

		/**
		 * Update URL 
		 */
		public var url:String;
		
		/**
		 * Constructor 
		 * @param url Update URL
		 */
		public function CheckForUpdatesMessage(url:String) {
			this.url = url;
		}
	}
}