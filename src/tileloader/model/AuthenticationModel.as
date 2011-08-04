package tileloader.model
{
	import flash.events.ErrorEvent;
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.logging.ILogger;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import tileloader.log.LogUtils;
	import tileloader.messages.AuthResultMessage;
	import tileloader.messages.AuthenticateMessage;
	import tileloader.messages.ConfigResultMessage;
	import tileloader.messages.ExitMessage;
	import tileloader.messages.MessageCodes;
	import tileloader.messages.OrderCleanupMessage;

	/**
	 * Authentication model
	 * Holds user credentials and al
	 *  
	 * @author kochetkov
	 * 
	 */
	public class AuthenticationModel {
		
		[Bindable]
		/**
		 * Authenticated flag 
		 */
		public var authenticated:Boolean; 
		
		/**
		 * Order token that is provided from outside 
		 */
		public var orderToken:String;
		
		//FIXME: Temporary order token
		public var tempToken:String = "NOT_SET"; 
		
		/**
		 * Order temporary directory 
		 */
		public var orderDirectory:File;
		
		/**
		 * Arbitrary order data 
		 */
		public var orderData:XML;
		
	}
}