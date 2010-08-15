/*
Echo project.

Copyright (C) 2003-2010 Collab

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
package com.collab.echo.net
{
	import com.collab.echo.core.messages.chat.ChatMessage;
	import com.collab.echo.events.BaseConnectionEvent;
	
	import flash.errors.IllegalOperationError;
	
	/**
	 * Server connection.
	 * 
	 * @author Thijs Triemstra
	 * 
	 * @langversion 3.0
 	 * @playerversion Flash 9
	 */	
	public class Connection
	{
		// ====================================
		// INTERNAL VARS
		// ====================================
		
		/**
		 * @private 
		 */		
		internal var _connected      		: Boolean;
		
		/**
		 * @private 
		 */		
		internal var _conEvt				: BaseConnectionEvent;
		
		// ====================================
		// PRIVATE VARS
		// ====================================
		
		private var _hostUrl				: String;
		private var _hostPort				: int;
		private var _self					: *;
		private var _logLevel				: String;
		private var _logging				: Boolean;
		
		// ====================================
		// ACCESSOR/MUTATOR
		// ====================================
		
		/**
		 * Host URL.
		 *  
		 * @return 
		 */		
		public function get url():String
		{
			return _hostUrl;
		}
		
		/**
		 * Host port number.
		 *  
		 * @return 
		 */		
		public function get port():int
		{
			return _hostPort;
		}
		
		/**
		 * Enabled logging.
		 *  
		 * @return 
		 */		
		public function get logging():Boolean
		{
			return _logging;
		}
		
		/**
		 * Current log level.
		 *  
		 * @return 
		 */		
		public function get logLevel():String
		{
			return _logLevel;
		}
		
		/**
		 * Reference to local client.
		 * 
		 * @return 
		 */		
		public function get self():*
		{
			throw new IllegalOperationError("Implement self in subclass");
			return null;
		}
		
		/**
		 * Reference to message manager.
		 * 
		 * @return 
		 */		
		public function get messageManager():*
		{
			throw new IllegalOperationError("Implement messageManager in subclass");
			return null;
		}
		
		/**
         * Connection status.
         * 
         * <p>True if the connection to the presence server has been successfully
		 * completed.</p>
		 * 
         * @return 
         */		
        public function get connected():Boolean
        {
            return _connected;
        }
		
		/**
		 * Constructor.
		 * 
		 * @param host
		 * @param port
		 * @param logging
		 * @param logLevel
		 */		
		public function Connection( host:String, port:int,
									logging:Boolean=true, logLevel:String="info" )
		{
			_hostUrl = host;
			_hostPort = port;
			_logging = logging;
			_logLevel = logLevel;
			_connected = false;
		}
		
		// ====================================
		// PUBLIC METHODS
		// ====================================
		
		/**
         * Connect to server.
         */		
        public function connect():void
        {
            if ( _hostUrl && _hostPort )
            {
            	// notify others
				//notifyClient( BaseConnectionEvent.CONNECTING );
			
                trace( "Connecting to server on " + _hostUrl + ":" + _hostPort );

                // logging
                if ( _logLevel )
                {
                	trace( "Log level: " + _logLevel.toUpperCase() );
                }
            }
        }
        
        /**
		 * Watch for rooms.
		 */		
		public function watchRooms():void
		{
		}
        
        /**
         * Registers a method or function to be executed when the specified type of message
         * is received from the server. 
         * 
         * <p>This method can be used to register listeners that handle messages centrally
         * for a group of rooms.</p>
         * 
         * @example For example, suppose a multi-room chat application
         * displays a notification icon when a new message is received in any room.
         * To catch all incoming messages for all rooms, the application registers a
         * single, centralized method for all "CHAT" messages. Here's the registration code:
		 * 
		 * <listing version="3.0">
		 * msgManager.addServerMessageListener(Messages.CHAT, centralChatListener);</listing>
         * 
         * @param type 		The name of the message the listener is registering to receive.
         * @param method 	The function or method that will be invoked when the specified message
         *                  is received.
         * @param forRoomIDs  A list of room IDs. If the message was sent to any of the
         *                    rooms in the list, the listener is executed. Otherwise, the
         *                    listener is not executed. Applies to messages sent to rooms
         *                    only, not to messages sent to specific individual clients or
         *                    the entire server.
         * @return 			  A Boolean indicating whether the listener was successfully added.
         */        
        public function addServerMessageListener( type:String, method:Function,
        										  forRoomIDs:Array=null ):Boolean
        {
        	throw new IllegalOperationError("Implement addServerMessageListener in subclass");
			return null;
        }
        
        /**
         * Unregisters a message listener method that was earlier registered for message
         * notifications via addServerMessageListener().
         * 
         * @param type 		The string ID of the message for which the listener is unregistering.
         * @param method 	The function or method to unregister.
         * @return 			A Boolean indicating whether the listener was successfully removed.
         */        
        public function removeServerMessageListener( type:String, method:Function ):Boolean
        {
        	throw new IllegalOperationError("Implement removeServerMessageListener in subclass");
			return null;
        }
        
        /**
         * Sends a message to clients in the room(s) specified by <code>forRoomIDs</code>.
         * 
         * <p>To send a message to clients in a single room only, use the sendRoomMessage()
         * method.</p>
         *  
         * @param message		The name of the message to send.
         * @param forRoomIDs	The room(s) to which to send the message.
         */		
        public function sendServerMessage( message:ChatMessage, forRoomIDs:Array=null ) : void
        {
        	throw new IllegalOperationError("Implement sendServerMessage in subclass");
			return null;
        }
        
        /**
         * Sends a message to clients in the room specified by <code>forRoomID</code>.
         * 
         * @param type
         * @param message		The name of the message to send.
         * @param forRoomID		The room to which to send the message.
         */		
        public function sendRoomMessage( type:String, message:String, forRoomID:String ) : void
        {
        	throw new IllegalOperationError("Implement sendRoomMessage in subclass");
			return null;
        }
        
        /**
         * Create a new room.
         *  
         * @param id
         * @param settings
         * @param attrs
         * @param modules
         */        
        public function createRoom( id:String, settings:*, attrs:*, modules:* ):*
        {
        	throw new IllegalOperationError("Implement createRoom in subclass");
			return null;
        }
        
        /**
         * Get a user's IP address by <code>name</code>.
         * 
		 * @param name
		 * @return 
		 */		
		public function getIPByUserName( name:String ):String
		{
			throw new IllegalOperationError("Implement getIPByUserName in subclass");
			return null;
		}
		
		/**
		 * Get user's client by attribute.
		 * 
		 * @param attrName
		 * @param attrValue
		 * @return 
		 */		
		public function getClientByAttribute( attrName:String,
													   attrValue:String ):*
		{
			throw new IllegalOperationError("Implement getClientByAttribute in subclass");
			return null;
		}
		
		/**
		 * Get client reference by id.
		 * 
		 * @param id
		 * @return 
		 */		
		public function getClientById( id:String ):*
		{
			throw new IllegalOperationError("Implement getClientById in subclass");
			return null;
		}
		
		// ====================================
		// PROTECTED METHODS
		// ====================================
		
        /**
		 * Triggered when the connection is established and ready for use.
		 */
		protected function connectionReady():void
		{
			_connected = true;

			//notifyClient( BaseConnectionEvent.CONNECTION_SUCCESS );
		}
		
		/**
		 * Triggered when the connection is closed.
		 */
		protected function connectionClosed():void
		{
            _connected = false;

			//notifyClient( BaseConnectionEvent.CONNECTION_CLOSED );
		}

	}
}