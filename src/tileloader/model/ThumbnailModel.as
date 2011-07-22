package tileloader.model
{
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	
	import tileloader.messages.ImageEvent;
	import tileloader.model.VO.ImageFormatFileVO;
	import tileloader.model.VO.ImageVO;

	public class ThumbnailModel {
		
		[Embed(source="/../assets/thumbnail.png")]
		/**
		 * Default thumbnail icon 
		 */
		public static var defaultThmIcon:Class;
		
		[MessageDispatcher]
		/**
		 * @private
		 * Parsley event dispatcher
		 */ 
		public var sendMessage:Function;
		
		[Inject]
		/**
		 * Reference to application configuration 
		 */
		public var config:ApplicationConfig;
		
		[Bindable]
		public var thumbnail:Object;
		
		[Bindable]
		/**
		 * Reference to rendered image VO 
		 */
		public var imageVO:ImageVO;
		
		[Init]
		/**
		 * Sets default image 
		 */
		public function init():void {
			thumbnail = defaultThmIcon;			
		}
		
		/**
		 * Handles new data setting 
		 * @param value Image VO for the renderer
		 */
		public function setImageVO(value:ImageVO):void {
			
			if (imageVO === value) return;
			
			//Deregister previous VO if has any
			if (null != imageVO) {
				imageVO.removeEventListener(ImageEvent.RESIZE_COMPLETE, onImageResizeComplete);
				thumbnail = defaultThmIcon;
			}
			
			imageVO = value;
			
			if (null != value) {
				if (null != imageVO.thumbnail) {
					thumbnail = imageVO.thumbnail;
					return;					
				}
				imageVO.addEventListener(ImageEvent.RESIZE_COMPLETE, onImageResizeComplete);
			}
		}
		
		/**
		 * @private 
		 * Resize complete handler
		 */
		private function onImageResizeComplete(event:ImageEvent):void {
			thumbnail = ImageVO(event.target).thumbnail;
		}
	}
}