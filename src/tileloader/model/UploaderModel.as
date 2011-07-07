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
		[CommandStatus(type="tileloader.controller.UploadImageCommand")]
		/**
		 * Upload in progress flag 
		 */
		public var working:Boolean;
		
		[Bindable]
		/**
		 * Current file being resized 
		 */
		public var fileInProgress:ImageVO; 
	}
}