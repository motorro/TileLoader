package tileloader.controller
{
	import tileloader.messages.LogMessage;
	import tileloader.model.SharedModel;

	/**
	 * Stores global log messages to SharedModel.
	 * 
	 * @author kochetkov
	 * 
	 */
	public class LogMessageCommand {
		[Inject]
		/**
		 * @private
		 * Reference to SharedModel 
		 */
		public var model:SharedModel;
		
		/**
		 * Stores global log messages to SharedModel.
	 	 * If log storage exceeds 
	 	 * 	SharedModel.MAX_LOG_MESSAGE_COUNT 
	 	 * removes lines from the beginning.		 
		 * @param message Log message to store
		 */
		public function execute(message:LogMessage):void {
			var log:Vector.<String> = model.applicationLog;
			
			if (null == log) {
				model.applicationLog = log = new Vector.<String>();
			}
			log.push(message.message);
			
			CONFIG::DEBUG {
				trace (message.message);
			}
			
			if (SharedModel.MAX_LOG_MESSAGE_COUNT > log.length) {
				log.shift();
			}
		}
	}
}