package tileloader.model
{
	import flash.desktop.ClipboardFormats;
	import flash.events.NativeDragEvent;
	
	import mx.core.IUIComponent;
	import mx.logging.ILogger;
	import mx.managers.DragManager;
	
	import tileloader.log.LogUtils;

	/**
	 * Drop zone presentation model
	 *  
	 * @author kochetkov
	 * 
	 */
	public class DropZoneModel {

		/**
		 * @private
		 * Logger 
		 */
		private static const _logger:ILogger = LogUtils.getLoggerByClass(DropZoneModel);

		[Inject]
		/**
		 * Shared model reference 
		 */
		public var sharedModel:SharedModel;
		
		[MessageDispatcher]
		/**
		 * @private
		 * Parsley event dispatcher
		 */ 
		public var sendMessage:Function;

		/**
		 * Checks for dragged data.
		 * @param event Drag event received
		 */
		public function processDragEnter(event:NativeDragEvent):void {
			if (false == event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)) {
				return;
			}
			DragManager.acceptDragDrop(IUIComponent(event.target));
		}
	
		/**
		 * Processes dragged files.
		 * @param event Drag event received
		 */
		public function processDragDrop(event:NativeDragEvent):void {
			if (false == event.clipboard.hasFormat(ClipboardFormats.FILE_LIST_FORMAT)) {
				return;
			}
			
			if (null != _logger) {
				_logger.info("Files dropped");	
			}
		}
	}
}