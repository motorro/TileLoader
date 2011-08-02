package tileloader.model
{
	/**
	 * Global constants storage
	 *  
	 * @author kochetkov
	 * 
	 */
	public class GlobalConstants {
		CONFIG::RELEASE {
			/**
			 * Configuration file name 
			 */
			public static const CONFIG_FILE_NAME:String = "config.xml";
		}
		
		CONFIG::DEBUG {
			/**
			 * Configuration file name 
			 */
			public static const CONFIG_FILE_NAME:String = "config_local.xml";
		}
		
		/**
		 * Application update URL 
		 */
		public static const UPDATE_CHECK_URL:String = "http://www.motorro.com/tiles/tileloaderupdate.xml";
		
		/**
		 * Folder names to exclude from total cleanup
		 */
		public static const FOLDER_CLEANUP_EXCLUDES:Array = [
			"#ApplicationUpdater"
		];
		
		/**
		 * Number of task retries before failure 
		 */
		public static const TASK_RETRY_NUMBER:int = 3;
		
		/**
		 * Time interval (ms) before task retrying 
		 */
		public static const TASK_RETRY_INTERVAL:int = 1000;
		
		/**
		 * Minimum thumbnail width (pixels)
		 */
		public static const THUMBNAIL_MIN_WIDTH:int = 50;
		
		/**
		 * Minimum thumbnail height (pixels)  
		 */
		public static const THUMBNAIL_MIN_HEIGHT:int = 50;
		
		/**
		 * Maximum thumbnail width (pixels)
		 */
		public static const THUMBNAIL_MAX_WIDTH:int = 150;
		
		/**
		 * Maximum thumbnail height (pixels)  
		 */
		public static const THUMBNAIL_MAX_HEIGHT:int = 150;
	}
}