package tileloader.model
{
	import mx.binding.utils.BindingUtils;
	import mx.binding.utils.ChangeWatcher;
	
	import tileloader.messages.StopUploadMessage;

	/**
	 * Presentation model for upload progress window
	 *  
	 * @author kochetkov
	 * 
	 */
	public class UploadProgressModel {
		[Inject]
		/**
		 * Shared model reference 
		 */
		public var sharedModel:SharedModel;
		
		[Bindable]
		/**
		 * Total files at view init moment 
		 */
		public var totalFiles:int;
		
		[Bindable]
		/**
		 * Number of files left to upload 
		 */
		public var filesLeft:int;
		
		[MessageDispatcher]
		/**
		 * @private
		 * Parsley event dispatcher
		 */ 
		public var sendMessage:Function;
		
		/**
		 * @private
		 * Watcher for collection count change 
		 */
		private var _numItemWatcher:ChangeWatcher;
		
		[Init]
		/**
		 * @private 
		 * Initializes data
		 */
		public function init():void {
			_numItemWatcher = BindingUtils.bindSetter(onCollectionLengthChanged, sharedModel, "fileList.length", false, true);
			totalFiles = null != sharedModel.fileList ? sharedModel.fileList.length : 0;
		}
		
		[Destroy]
		/**
		 * @private
		 * Cleans-up model upon removing 
		 */
		public function destroy():void {
			_numItemWatcher.unwatch();
		}
		
		/**
		 * Cancells uploads 
		 */
		public function cancel():void {
			sendMessage(new StopUploadMessage(StopUploadMessage.USER_CANCELLED));
		}
		
		/**
		 * @private
		 * File list length change handler 
		 */
		private function onCollectionLengthChanged(length:int):void {
			filesLeft = length;
		}
	}
}