package tileloader.model
{
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.events.ErrorEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	import mx.logging.ILogger;
	import mx.managers.PopUpManager;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.spicefactory.parsley.core.context.Context;
	
	import tileloader.log.LogUtils;
	import tileloader.messages.ConfigMessage;
	import tileloader.messages.ConfigResultMessage;
	import tileloader.messages.ExitMessage;
	import tileloader.messages.FileAddMessage;
	import tileloader.messages.MessageCodes;
	import tileloader.messages.OrderCleanupMessage;
	import tileloader.messages.RescanFileQueueMessage;
	import tileloader.messages.RescanUploadQueueMessage;
	import tileloader.messages.ResizeImageMessage;
	import tileloader.messages.StartUploadMessage;
	import tileloader.messages.UploadImageMessage;
	import tileloader.view.UploadProgress;

	/**
	 * Global application data model
	 *  
	 * @author kochetkov
	 * 
	 */
	public class SharedModel {
		
		[Bindable]
		/**
		 * Files to be processed with application 
		 */
		public var fileList:ArrayCollection;
		
		//Logging
		/**
		 * Maximum number of strings in log file 
		 */
		public static const MAX_LOG_MESSAGE_COUNT:int = 1000;
		
		[Bindable]
		/**
		 * Application log
		 */
		public var applicationLog:Vector.<String>;
		
		/**
		 * List of orders being processed
		 */
		public var currentOrders:Vector.<AuthenticationModel>;
		
	}
}