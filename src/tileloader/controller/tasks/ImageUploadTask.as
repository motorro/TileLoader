package tileloader.controller.tasks
{
	import flash.events.DataEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.logging.ILogger;
	
	import org.spicefactory.lib.task.Task;
	
	import tileloader.log.LogUtils;
	import tileloader.model.UploaderModel;
	import tileloader.model.VO.ImageFormatFileVO;
	
	/**
	 * Task to upload file
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageUploadTask extends Task {
		
		/**
		 * @private
		 * Logger 
		 */
		private static var _logger:ILogger = LogUtils.getLoggerByClass(ImageUploadTask);

		/**
		 * @private
		 * Image upload script URL 
		 */
		private var _scriptUrl:String;
		
		/**
		 * @private
		 * Order ID 
		 */
		private var _order:String;
		
		/**
		 * @private
		 * Encoded format reference 
		 */
		private var _file:ImageFormatFileVO;
		
		/**
		 * Constructor 
		 * @param scriptUrl URL to receiving script
		 * @param order Order ID
		 * @param file File to upload
		 */
		public function ImageUploadTask(scriptUrl:String, order:String, file:ImageFormatFileVO) {
			super();
			
			_scriptUrl = scriptUrl;
			_order = order;
			_file = file;
			
			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doStart():void {
			if (null != _logger) {
				_logger.info("Uploading image to: " + _scriptUrl);
			}

			var model:UploaderModel = UploaderModel(data);
			
			var file:File = _file.file;
			file.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError, false, 0, true);
			file.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);

			CONFIG::DEBUG {
				file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onCompleteData, false, 0, true);
			}
			
			var request:URLRequest = new URLRequest(_scriptUrl);
			
			var requestVars:URLVariables = new URLVariables();
			requestVars.order = _order;
			requestVars.format = _file.format.id;
			requestVars.originalFilename = model.fileInProgress.path.name;
			requestVars.orientation = model.fileInProgress.orientation;
			request.data = requestVars;
			
			request.method = URLRequestMethod.POST;
			
			file.upload(request);
		}
		
		/**
		 * @private
		 * Upload complete handler 
		 */
		private function onComplete(event:Event):void {
			unsubscribeEvents();
			if (null != _logger) {
				_logger.info("Uploaded");
			}
			complete();
		}
		
		CONFIG::DEBUG {
			/**
			 * @private
			 * Upload complete data received 
			 */
			private function onCompleteData(event:DataEvent):void {
				var file:File = _file.file;
				file.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onCompleteData);
	
				if (null != _logger) {
					_logger.info("Upload data: " + event.data);
				}
			}
		}
		
		/**
		 * @private
		 * Upload error handler 
		 */
		private function onError(event:ErrorEvent):void {
			unsubscribeEvents();
			var message:String = "Error uploading file: " + event.text;
			if (null != _logger) {
				_logger.error(message);
			}
			error(message);
		}
		
		/**
		 * @private
		 * Removes event listeners from file 
		 */
		private function unsubscribeEvents():void {
			var file:File = _file.file;
			file.removeEventListener(Event.COMPLETE, onComplete);
			file.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			file.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		}
	}
}