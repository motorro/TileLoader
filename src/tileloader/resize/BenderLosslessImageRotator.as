package tileloader.resize
{
	import flash.display.BitmapData;
	import flash.display.Shader;
	import flash.display.ShaderJob;
	import flash.geom.Point;
	import flash.utils.ByteArray;

	public class BenderLosslessImageRotator {
		/**
		 * 90 degrees lossless rotation 
		 */
		public static const ROTATE_90:String = "90";
		
		/**
		 * 180 degrees lossless rotation 
		 */
		public static const ROTATE_180:String = "180";

		/**
		 * 270 degrees lossless rotation 
		 */
		public static const ROTATE_270:String = "270";
		
		[Embed ( source="rotator90.pbj", mimeType="application/octet-stream" ) ]
		/**
		 * @private
		 * 90 degrees rotation kernel 
		 */
		private static const rotator90:Class;
		
		[Embed ( source="rotator180.pbj", mimeType="application/octet-stream" ) ]
		/**
		 * @private
		 * 180 degrees rotation kernel 
		 */
		private static const rotator180:Class;

		[Embed ( source="rotator270.pbj", mimeType="application/octet-stream" ) ]
		/**
		 * @private
		 * 270 degrees rotation kernel 
		 */
		private static const rotator270:Class;

		/**
		 * Lossless image rotator for 90, 180 and 270 degrees clockwise
		 * @param input Input BitmapData
		 * @param rotation Rotation angle (90, 180 or 270)
		 * @return Created ShaderJob/BitmapData pair for the operation
		 */
		public static function rotate(input:BitmapData, rotation:String):ResizeJob {

			var outputWidth:Number;
			var outputHeight:Number;
			
			//Check rotation and adjust output dimensions
			switch (rotation) {
				case ROTATE_180:
					outputWidth = input.width;
					outputHeight = input.height;
					break;
				case ROTATE_90:
				case ROTATE_270:
					outputWidth = input.height;
					outputHeight = input.width;
					break;
				default:
					return null;
			}
			
			var output:BitmapData = new BitmapData(outputWidth, outputHeight);  
			
			var shader:Shader = new Shader();
			
			switch (rotation) {
				case ROTATE_90:
					shader.byteCode = new rotator90 as ByteArray;
					shader.data.width.value = [outputWidth];
					break;
				case ROTATE_180:
					shader.byteCode = new rotator180 as ByteArray;
					shader.data.width.value = [outputWidth];
					shader.data.height.value = [outputHeight];
					break;
				case ROTATE_270:
					shader.byteCode = new rotator270 as ByteArray;
					shader.data.height.value = [outputHeight];
			}
			
			shader.data.src.input = input;
			
			var job:ShaderJob = new ShaderJob();
			job.target = output;
			job.shader = shader;
			
			return new ResizeJob(output, job);
		}		
		
	}
}