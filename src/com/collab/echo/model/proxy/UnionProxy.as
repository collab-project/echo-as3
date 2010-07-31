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
package com.collab.echo.model.proxy
{
	import com.collab.site.common.model.vo.UserVO;
	import com.collab.echo.view.hub.chat.events.ChatMessageEvent;
	
	import net.user1.logger.Logger;
	import net.user1.reactor.ClientManager;
	import net.user1.reactor.ConnectionManager;
	import net.user1.reactor.HTTPConnection;
	import net.user1.reactor.IClient;
	import net.user1.reactor.MessageManager;
	import net.user1.reactor.Reactor;
	import net.user1.reactor.ReactorEvent;
	import net.user1.reactor.Room;
	import net.user1.reactor.RoomManager;
	import net.user1.reactor.RoomManagerEvent;
	import net.user1.reactor.XMLSocketConnection;
	
	import org.osflash.thunderbolt.Logger;
	import com.collab.site.common.model.proxy.PresenceProxy;
	
	/**
	 * Presence <code>Proxy</code> for the Union platform.
	 * 
	 * <p>Manages connection and rooms. Users are managed in <code>BaseRoom</code>
	 * instances.</p>
	 * 
	 * @see com.collab.echo.view.rooms.BaseRoom BaseRoom
	 * @author Thijs Triemstra
	 */	
	public class UnionProxy extends PresenceProxy
	{
		// ====================================
		// CONSTANTS
		// ====================================
		
		/**
		 * Cannonical name of this <code>Proxy</code>.
		 */    
		public static const NAME				: String = "UnionProxy";
		
		// ====================================
		// ACCESSOR/MUTATOR
		// ====================================
		
		/**
		 * @private 
		 * @return 
		 */		
		override public function get isReady():Boolean
		{
			return Reactor( reactor ).isReady();
		}
		
		/**
		 * @private 
		 * @return 
		 */		
		override public function get self():*
		{
			return Reactor( reactor ).self();
		}
		
		/**
		 * @return 
		 */		
		public function get roomManager():RoomManager
		{
			return Reactor( reactor ).getRoomManager();
		}
		
		/**
		 * @return 
		 */		
		public function get clientManager():ClientManager
		{
			return Reactor( reactor ).getClientManager();
		}
		
		/**
		 * The ConnectionManager class manages all connections made by a
		 * Reactor application to the Union Server.
		 * 
		 * @return 
		 */		
		public function get connectionManager():ConnectionManager
		{
			return Reactor( reactor ).getConnectionManager();
		}
		
		/**
		 * @return 
		 */		
		public function get messageManager():MessageManager
		{
			return Reactor( reactor ).getMessageManager();
		}
		
		/**
		 * Constructor.
		 * 
		 * @param data
		 */		
		public function UnionProxy( data:Object=null )
		{
			super( data );
			
			logLevel = net.user1.logger.Logger.INFO;
		}

		// ====================================
		// PUBLIC/PROTECTED METHODS
		// ====================================

		/**
		 * Create the Reactor object and connect to the Union Server.
		 *  
		 * @param url
		 * @param port
		 * @param logging
		 */		
		override public function createConnection( url:String="localhost",
												   port:int=80, logging:Boolean=true ):void
		{
			super.createConnection( url, port );
			
			log( "Connecting to Union server on " + url + ":" + port );
			
			// create reactor
			reactor = new Reactor( "", logging );
			reactor.getLog().setLevel( logLevel );
			reactor.addEventListener( ReactorEvent.READY, unionConnectionReady );
			reactor.addEventListener( ReactorEvent.CLOSE, unionConnectionClose );
			
			// add fallover connections
			connectionManager.addConnection( new XMLSocketConnection( url, 9110 ));
			connectionManager.addConnection( new XMLSocketConnection( url, 80 ));
			connectionManager.addConnection( new XMLSocketConnection( url, 443 ));
			connectionManager.addConnection( new HTTPConnection( url, 80 ));
			connectionManager.addConnection( new HTTPConnection( url, 443 ));
			connectionManager.addConnection( new HTTPConnection( url, 9110 ));
			reactor.connect();
		}
		
		/**
		 * @param message
		 */		
		override public function sendLine( message:String ):void
		{
			super.sendLine( message );
			
			// send remotely
			// XXX: remove hardcoded room name, target rooms[].id instead
			roomManager.sendMessage( SEND_LINE, [ "collab.global" ],
									 false, null, message );
		}
		/**
		 * 
		 * @param name
		 * @return 
		 */		
		override public function getIPByUserName( name:String ):String
		{
			var ip:String;
			var client:IClient;
			var id:String = name.substr( 4 );
			
			if ( id )
			{
				// XXX: remove hardcoded name length
				var poss:Array = [ getClientByAttribute( UserVO.USERNAME, name ),
								   getClientById( id ) ];
				
				for each ( client in poss )
				{
					if ( client )
					{
						// UNION BUG: this only works for own client
						ip = client.getIP();
						break;
					}
				}
			}
			
			return ip;
		}
		
		/**
		 * Get user's client by attribute.
		 * 
		 * @param attrName
		 * @param attrValue
		 * @return 
		 */		
		override public function getClientByAttribute( attrName:String,
													   attrValue:String ):*
		{
			return clientManager.getClientByAttribute( attrName, attrValue );
		}
		
		/**
		 * @param id
		 * @return 
		 */		
		override public function getClientById( id:String ):*
		{
			return clientManager.getClient( id );
		}
		
		/**
		 * Ask to be notified when a room with the qualifier
		 * <code>roomQualifier</code> is updated on the server. 
		 * 
		 * @param roomQualifier
		 */		
		protected function watchForRooms( roomQualifier:String ):void
		{
			// watch for rooms.
			roomManager.watchForRooms( roomQualifier );

			// in response to this watchForRooms() call, the RoomManager will trigger 
			// RoomManagerEvent.ROOM_ADDED and RoomManagerEvent.ROOM_REMOVED events.
			roomManager.addEventListener( RoomManagerEvent.ROOM_ADDED, 		roomAddedListener );
			roomManager.addEventListener( RoomManagerEvent.ROOM_REMOVED, 	roomRemovedListener );
			roomManager.addEventListener( RoomManagerEvent.ROOM_COUNT, 		roomCountListener );
		}
		
		/**
		 * @param msg
		 */		
		protected function log( msg:* ):void
		{
			org.osflash.thunderbolt.Logger.debug( msg );
		}
			
		// ====================================
		// EVENT HANDLERS
		// ====================================

		/**
		 * @param event
		 * @private
		 */		
		override protected function onMessageComplete( event:ChatMessageEvent ):void
		{
			super.onMessageComplete( event );
			
			if ( message.local )
			{
				// perform only locally
				message.local = true;
				message.sender = self;
				sendNotification( RECEIVE_MESSAGE, message );
			}
			else
			{
				// send remotely
				// XXX: remove hardcoded room name, target rooms[].id instead
				roomManager.sendMessage( message.type, [ "collab.global" ],
										 message.includeSelf, null, message.message );
			}
		}
		
		/**
		 * Dispatched when a remote chat message is received.
		 * 
		 * @param fromClient
		 * @param toRoom
		 * @param chatMessage
		 */		
		public function centralChatListener( fromClient:IClient, toRoom:Room,
											 chatMessage:String ):void
		{
			// XXX: implement toRoom in BaseChatMessage
			message = messageCreator.create( this, RECEIVE_MESSAGE, chatMessage );
			message.sender = fromClient;
			message.receiver = self;
			
			log( "UnionProxy.centralChatListener: " + message );
			
			sendNotification( RECEIVE_MESSAGE, message );
		}
		
		/**
		 * Dispatched when a remote line is received.
		 * 
		 * @param fromClient
		 * @param toRoom
		 * @param shape
		 */		
		public function whiteBoardListener( fromClient:IClient, toRoom:Room,
											shape:String ):void
		{
			log( "UnionProxy.whiteBoardListener: " + shape );
			
			// XXX: formalize this
			var obj:Object = new Object();
			obj.shape = shape;
			obj.from = fromClient;
			
			sendNotification( RECEIVE_LINE, obj );
		}
		
		/**
		 * Triggered when the connection is established and ready for use.
		 *  
		 * @param event
		 */		
		protected function unionConnectionReady( event:ReactorEvent ):void 
		{
			event.preventDefault();
			
			// listen for events
			messageManager.addMessageListener( SEND_MESSAGE, centralChatListener );
			messageManager.addMessageListener( SEND_LINE, whiteBoardListener );
			
			connectionReady();
		}
		
		/**
		 * Triggered when the connection is closed.
		 *  
		 * @param event
		 */		
		protected function unionConnectionClose( event:ReactorEvent ):void 
		{
			event.preventDefault();
			
			connectionClosed();
		}
		
		/**
		 * Event listener triggered when a room is added to the 
         * room manager's room list.
		 *	 
		 * @param event
		 */		
		protected function roomAddedListener( event:RoomManagerEvent ):void
		{
			event.preventDefault();
			
			roomAdded( event );
		}
		
		/**
		 * Event listener triggered when a room is removed from the 
         * room manager's room list.
		 * 
		 * @param event
		 */		
		protected function roomRemovedListener( event:RoomManagerEvent ):void
		{
			event.preventDefault();
			
			roomRemoved( event );
		}
		
		/**
		 * Event listener triggered when the number of rooms has changed.
		 * 
		 * @param event
		 */		
		protected function roomCountListener( event:RoomManagerEvent ):void
		{
			event.preventDefault();
			
			roomCount( event );
		}

	}
}