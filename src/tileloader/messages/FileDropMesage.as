package tileloader.messages
{
	/**
	 * Message dispatched on file drop
	 *  
	 * @author kochetkov
	 * 
	 */
	public class FileDropMesage {
		
		/**
		 * Dropped file list 
		 */
		public var files:Array;
		
		/**
		 * Constructor 
		 * @param files Dropped files
		 */
		public function FileDropMesage(files:Array) {
			this.files = files;
		}
	}
}