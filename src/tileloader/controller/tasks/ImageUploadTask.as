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
	
	import jp.shichiseki.exif.ExifInfo;
	
	import mx.logging.ILogger;
	
	import tileloader.log.LogUtils;
	import tileloader.messages.ImageEvent;
	import tileloader.model.ResizerModel;
	import tileloader.model.UploaderModel;
	import tileloader.model.VO.ImageFormatFileVO;
	
	/**
	 * Task to upload file
	 *  
	 * @author kochetkov
	 * 
	 */
	public class ImageUploadTask extends RetriableTask {
		
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
		private var _formatFile:ImageFormatFileVO;
		
		/**
		 * @private
		 * File reference 
		 */
		private var _file:File;
		
		/**
		 * @private
		 * Model reference 
		 */
		private var _model:UploaderModel;
		
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
			_formatFile = file;
			
			setCancelable(false);
			setSkippable(false);
			setSuspendable(false);
			setRestartable(false);
		}
		
		/**
		 * @inheritDoc 
		 */
		override protected function doRetryStart():void {
			_model = UploaderModel(data);
			
			_file = _formatFile.file.clone();
			_file.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			_file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError, false, 0, true);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);

			if (null != _logger) {
				_logger.info("Uploading image " + _file.name + " to: " + _scriptUrl);
			}
			
			CONFIG::DEBUG {
				_file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onCompleteData, false, 0, true);
			}
			
			var request:URLRequest = new URLRequest(_scriptUrl);
			
			var requestVars:URLVariables = new URLVariables();
			requestVars.order = _order;
			requestVars.format = _formatFile.format.id;
			requestVars.originalFilename = _model.imageInProgress.path.name;
			requestVars.orientation = _model.imageInProgress.orientation;

			var exifData:ExifInfo = _model.imageInProgress.exifData;
			if (null != exifData) {
				try {
					requestVars.exifDate = exifData.ifds.primary.DateTime;
				} catch (e:Error) {
					//NOOP
				}
			}
			
			request.data = requestVars;
			
			request.method = URLRequestMethod.POST;
			
			try {
				_file.upload(request);
			} catch (e:Error) {
				unsubscribeEvents();
				CONFIG::DEBUG {
					_file.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onCompleteData);
				}
				var message:String = "Error uploading file: " + e.message;
				if (null != _logger) {
					_logger.error(message);
				}
				error(message);
			}
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
			_model.imageInProgress.dispatchEvent(new ImageEvent(ImageEvent.FORMAT_UPLOAD_COMPLETE));			
			complete();
		}
		
		CONFIG::DEBUG {
			/**
			 * @private
			 * Upload complete data received 
			 */
			private function onCompleteData(event:DataEvent):void {
				_file.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onCompleteData);
	
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
			CONFIG::DEBUG {
				_file.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onCompleteData);
			}
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
			_file.removeEventListener(Event.COMPLETE, onComplete);
			_file.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError);
			_file.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		}
	}
}