package tileloader.controller
{
	import flash.events.ErrorEvent;
	
	import mx.logging.ILogger;
	
	import tileloader.log.LogUtils;

	/**
	 * Application error handler
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ErrorHandler {
		/**
		 * Constructor 
		 */
		public function ErrorHandler() {

		}
		
		[MessageDispatcher]
		/**
		 * @private
		 * Parsley event dispatcher
		 */ 
		public var sendMessage:Function;

		/**
		 * Handles an error
		 *  
		 * @param e Error object
		 * @param victim The one who suffers an error
		 */
		public function handleError(e:Object, victim:Object = null):void {
			if (null == victim) {
				victim = this;
			}
			
			var logger:ILogger = LogUtils.getLoggerByObject(this);
			
			if (false != logger) {
				if (e is Error){
					logger.error(Error(e).message);
				} else if (e is ErrorEvent) {
					logger.error(ErrorEvent(e).text);
				} else {
					logger.error(e.toString());
				}
			}
			
			//TODO: Add dialog box error logic 
			//For example, pass button/message array to show a dialogue
		}
	}
}