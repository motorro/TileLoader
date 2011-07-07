package tileloader.resize
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ShaderEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	

	/**
	 * Performs bilinear resizing of images 
	 *  
	 * @author kochetkov
	 * 
	 */
	public class BenderImageResizer extends EventDispatcher {
		
		[Embed ( source="resizer.pbj", mimeType="application/octet-stream" ) ]
		/**
		 * @private
		 * Bilinear kernel 
		 */
		private static const bilinearSampler:Class;
		
		[Embed ( source="bicubicResizer.pbj", mimeType="application/octet-stream" ) ]
		/**
		 * @private
		 * Bicubic kernel 
		 */
		private static const bicubicSampler:Class;
		
		/**
		 * Bilinear resize 
		 */
		public static const BILINEAR:String = "bilinear";
		
		/**
		 * Bicubic resize 
		 */
		public static const BICUBIC:String = "bicubic";

		/**
		 * Resizes BitmapData using bilinear bender 
		 * @param input Input bitmap
		 * @param targetWidth Target image width
		 * @param targetHeight Target image height
		 * @param fit Scale type (one of the ImageFitType values)
		 * @return Created ShaderJob/BitmapData pair for the operation
		 */
		public static function resize(input:BitmapData, targetWidth:Number, targetHeight:Number, fit:String, resizer:String = BenderImageResizer.BILINEAR):ResizeJob {
			//Correct fit type
			fit = correctScaleType(fit);
			
			var outputWidth:Number;
			var outputHeight:Number;
			var scale:Number;
			var shift:Point;
			
			//Rotate target if aspects are different
			if (input.width > input.height != targetWidth > targetHeight) {
				var tmp:Number = targetWidth;
				targetWidth = targetHeight;
				targetHeight = tmp;
			}

			//Get scale and shift value
			if (ImageFitType.FIT_IMAGE == fit) {
				scale = Math.max(input.width / targetWidth, input.height / targetHeight);
				
				outputWidth = Math.round(input.width / scale);
				outputHeight = Math.round(input.height / scale);
				
				shift = new Point(0, 0);
			} else {
				scale = Math.min(input.width / targetWidth, input.height / targetHeight);				
				
				outputWidth = targetWidth;
				outputHeight = targetHeight;
				
				shift = new Point(0.5 * input.width / scale - 0.5 * targetWidth, 0.5 * input.height / scale - 0.5 * targetHeight);
			}
			
			var output:BitmapData = new BitmapData(outputWidth, outputHeight);  
			
			var shader:Shader = new Shader();
			BenderImageResizer.setupShader(shader, resizer, scale, shift);
			shader.data.src.input = input;

			var job:ShaderJob = new ShaderJob();
			job.target = output;
			job.shader = shader;
			
			return new ResizeJob(output, job);
		}
		
		/**
		 * @private
		 * Ensures correct fit type passed 
		 */
		private static function correctScaleType(fit:String):String {
			switch (fit) {
				case ImageFitType.FIT_WINDOW:
					return ImageFitType.FIT_WINDOW;
				case ImageFitType.FIT_IMAGE:
				default:
					return ImageFitType.FIT_IMAGE;
			}
		}
		
		private static function setupShader(shader:Shader, resizeType:String, scale:Number, shift:Point):void {
			switch (resizeType) {
				case BenderImageResizer.BICUBIC:
					shader.byteCode = new bicubicSampler as ByteArray;
					shader.data.scale.value = [scale, scale];
					shader.data.shift.value = [shift.x, shift.y];
					return;
				case BenderImageResizer.BILINEAR:
				default:
					shader.byteCode = new bilinearSampler as ByteArray;
					shader.data.scale.value = [scale];
					shader.data.shift.value = [shift.x, shift.y];
			}
		}
	}
}