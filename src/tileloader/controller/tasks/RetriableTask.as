package tileloader.controller.tasks
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.model.GlobalConstants;

	/**
	 * Retriable task that retries itself on error
	 *  
	 * @author kochetkov
	 * 
	 */
	public class RetriableTask extends Task {
		
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(RetriableTask);

		/**
		 * @private
		 * Timer for retries 
		 */
		private var _retryTimer:Timer;
		
		/**
		 * @private
		 * Retry counter 
		 */
		private var _retryCount:int;
		
		/**
		 * Constructor 
		 */
		public function RetriableTask() {
			_retryTimer = new Timer(GlobalConstants.TASK_RETRY_INTERVAL, 1);
			_retryTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimer);
		}
		
		override protected function doStart():void {
			_retryCount = GlobalConstants.TASK_RETRY_NUMBER;
			_retryTimer.reset();
			doRetryStart();
		}
		
		/**
		 * Task process. Use instead of doStart
		 */
		protected function doRetryStart():void {
			super.error("Empty retry task!");
		}
		
		/**
		 * Retries task if retry count is not ectinct/ Otherwize throws error 
		 * @param message Error message
		 */
		override protected function error(message:String):Boolean {
			
			//Retries failed - return error
			if (_retryCount <= 0) {
				if (null != _logger) {
					_logger.warn("Last retry attempt failed. Returning error."); 
				}
				return super.error(message);
			}
			
			//Wait for set interval and retry
			_retryTimer.reset();
			if (null != _logger) {
				_logger.warn("Task retry. Retryies left: " + _retryCount); 
			}
			_retryTimer.start();
			--_retryCount;
			return false;
		}
		
		/**
		 * @private
		 * Retries task 
		 */
		private function onTimer(event:TimerEvent):void {
			doRetryStart();
		}
	}
}