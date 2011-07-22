package tileloader.model
{
	import tileloader.model.VO.ImageVO;

	/**
	 * Model class for uploader
	 *  
	 * @author kochetkov
	 * 
	 */
	public class UploaderModel {
		[Bindable]
		/**
		 * Flag to set uploader active/inactive 
		 */
		public var uploading:Boolean;
		
		[Bindable]
		[CommandStatus(type="tileloader.messages.UploadImageMessage")]
		/**
		 * Upload in progress flag 
		 */
		public var working:Boolean;
		
		[Bindable]
		/**
		 * Indicates that uploader suffers error
		 */
		public var sufferingError:Boolean;
		
		[Bindable]
		/**
		 * Current file being resized 
		 */
		public var imageInProgress:ImageVO; 
		
		[Init]
		/**
		 * Initializes model and removes any temporary data 
		 */
		public function initialize():void {
			
			imageInProgress = null;
			
		}
	}
}