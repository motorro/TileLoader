package tileloader.resize
{
	import flash.display.BitmapData;
	import flash.display.ShaderJob;

	public class ResizeJob {
		
		/**
		 * Bitmap data for output 
		 */
		public var output:BitmapData;
		
		/**
		 * Shader job that is used to perform resize 
		 */
		public var job:ShaderJob;
		
		/**
		 * Constructor 
		 * @param output Output bitmap data
		 * @param job Created shader job
		 */
		public function ResizeJob(output:BitmapData, job:ShaderJob)	{
			this.output = output;
			this.job = job;
		}
	}
}