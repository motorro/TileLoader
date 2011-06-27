package tileloader.log
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	
	import mx.logging.ILogger;
	import mx.logging.Log;

	/**
	 * Logging utils
	 *  
	 * @author kochetkov
	 * 
	 */
	public class LogUtils {
		/**
		 * Returns logger name for given class 
		 * @param c Class
		 * @return Ilogger for that class
		 * 
		 */
		public static function getLoggerByClass(c:Class):ILogger {
			var className:String = getQualifiedClassName(c).replace(/:+/, ".");
			return Log.getLogger(className);
		}
		
		/**
		 * Returns logger name for given object 
		 * @param o Object
		 * @return  ILogger for that Object
		 * 
		 */
		public static function getLoggerByObject(o:Object):ILogger {
			var typeInfo:XML = describeType(o);
			var className:String = typeInfo.@name.toString().replace(/:+/, ".");
			return Log.getLogger(className);
		}
	}
}