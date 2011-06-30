package tileloader.messages
{
	/**
	 * Message to initiate file addition
	 *  
	 * @author kochetkov
	 * 
	 */
	public class FileAddMessage {
		
		/**
		 * File list 
		 */
		public var files:Array;
		
		/**
		 * Constructor 
		 * @param files Files to add
		 */
		public function FileAddMessage(files:Array) {
			this.files = files;			
		}
	}
}