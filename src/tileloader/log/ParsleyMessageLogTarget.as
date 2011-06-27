package tileloader.log
{
	import mx.core.mx_internal;
	use namespace mx_internal;
	
	import mx.logging.targets.LineFormattedTarget;
	
	import tileloader.messages.LogMessage;
	
	/**
	 * A log target that issues a Parsley event with processed text
	 * A Parsley listener may subscribe the event to output log
	 * @author kochetkov
	 * 
	 */
	public class ParsleyMessageLogTarget extends LineFormattedTarget {
		/**
		 * Constructor 
		 */
		public function ParsleyMessageLogTarget() {
			super();
		}
		
		[MessageDispatcher]
		/**
		 * @private
		 * Parsley event dispatcher
		 */ 
		public var sendMessage:Function;

		/**
		 *  @private
		 *  This method translates the specified message to Parsley LogEvent 
		 *
		 *  @param message String containing preprocessed log message which may
		 *  include time, date, category, etc. based on property settings,
		 *  such as <code>includeDate</code>, <code>includeCategory</code>, etc.
		 */
		override mx_internal function internalLog(message:String):void {
			if (null != sendMessage) {
				sendMessage(new LogMessage(message));	
			}
		}
	}
}