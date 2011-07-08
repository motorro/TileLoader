package tileloader.resize
{
	import flash.display.BitmapData;
	import flash.events.Event;
	
	/**
	 * Event fired upon image resize is complete
	 * 
	 * @author kochetkov
	 * 
	 */
	public class ImageResizerEvent extends Event {
		
		/**
		 * Resize complete 
		 */
		public static const COMPLETE:String = "complete";
		
		/**
		 * @private 
		 */
		private var _bitmapData:BitmapData;
		/**
		 * Resulting BitmapData 
		 */
		public function get bitmapData():BitmapData {
			return _bitmapData;
		}
		
		/**
		 * Constructor 
		 * @param type 
		 * @param bitmapData
		 * @param bubbles
		 * @param cancelable
		 * 
		 */
		public function ImageResizerEvent(type:String, bitmapData:BitmapData, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			_bitmapData = bitmapData;
		}
	}
}