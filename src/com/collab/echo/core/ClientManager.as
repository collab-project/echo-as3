/* * Echo project. * * Copyright (C) 2003-2010 Collab * * This program is free software: you can redistribute it and/or modify * it under the terms of the GNU General Public License as published by * the Free Software Foundation, either version 3 of the License, or * (at your option) any later version. * * This program is distributed in the hope that it will be useful, * but WITHOUT ANY WARRANTY; without even the implied warranty of * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the * GNU General Public License for more details. * * You should have received a copy of the GNU General Public License * along with this program.  If not, see <http://www.gnu.org/licenses/>. */package com.collab.echo.core{    import com.collab.echo.core.rooms.BaseRoom;    import com.collab.echo.events.BaseConnectionEvent;    import com.collab.echo.events.BaseRoomEvent;    import com.collab.echo.model.UserVO;    import com.collab.echo.net.Connection;    /**     * <p>Manages the connection with the server, rooms and clients.</p>     *     * @author Thijs Triemstra     *      * @langversion 3.0 	 * @playerversion Flash 10     */    public class ClientManager implements IClientManager    {        // ====================================		// PRIVATE VARS		// ====================================        private var _clients      					: Array;		private var _rooms							: Vector.<BaseRoom>;		private var _connection						: Connection;				// ====================================		// ACCESSOR/MUTATOR		// ====================================				/**		 * Get rooms we want to monitor.		 * 		 * @return 		 */				public function get rooms():Vector.<BaseRoom>		{			return _rooms;		}		        /**		 * Clients we're monitoring.		 * 		 * @return 		 */				public function get clients():Array		{			return _clients;		}	        /**         * Constructor.         *          * @param connectionType         * @param url         * @param port         * @param logging         * @param logLevel         */		        public function ClientManager( connectionType:Class, url:String="localhost",        							   port:int=9110, logging:Boolean=true,        							   logLevel:String="info" ) : void        {            _clients = [];            _rooms = new Vector.<BaseRoom>();			_connection = new connectionType( url, port, logging, logLevel );        }                /**         * Connect to server.         */		        public function connect():void        {            // listeners            _connection.addEventListener( BaseConnectionEvent.CONNECTING, connecting );            _connection.addEventListener( BaseConnectionEvent.CONNECTION_SUCCESS, connectionReady );            _connection.addEventListener( BaseConnectionEvent.CONNECTION_CLOSED, connectionClosed );                        // connect            _connection.connect();        }                /**         * Add a client.         *          * @param client         */		        public function subscribeClient( client : IClient ) : void        {            _clients.push( client );        }        /**         * Remove a client.         *           * @param client         */		        public function unsubscribeClient( client : IClient ) : void        {            for ( var ob:int = 0; ob < _clients.length; ob++ )            {                if ( _clients[ ob ] == client )                {                    _clients.splice( ob, 1 );                }            }        }        /**         * Notify all clients.         *           * @param notification         */		        public function notifyClient( notification:String, ...args:Array ) : void        {        	var client:*;        	var vo:UserVO;        	            for ( client in _clients )            {            	client = _clients[ client ];            	            	switch ( notification )            	{            		case BaseRoomEvent.ADD_OCCUPANT:            			vo = _connection.parseUser( args[0].data.getClient() );            			client.addOccupant( vo );            			break;            		            		case BaseRoomEvent.REMOVE_OCCUPANT:            			vo = _connection.parseUser( args[0].data.getClient() );            			client.removeOccupant( vo );            			break;            		            		case BaseRoomEvent.OCCUPANT_COUNT:            			client.numClients(  args[0] );            			break;            		            		case BaseRoomEvent.JOIN_RESULT:	            		break;	            		            	case BaseRoomEvent.CLIENT_ATTRIBUTE_UPDATE:	            		vo = _connection.parseUser( args[0].data.getClient() );	            		client.clientAttributeUpdate( vo, args[0].data.getChangedAttr() );	            		break;            		            		default:            			client.update( notification, args );            			break;            	}                            }        }                /**		 * Create one or more rooms.		 * 		 * @param rooms		 */				public function createRooms( rooms:Vector.<BaseRoom> ):void		{			_rooms = _rooms.concat( rooms );						for each ( var room:BaseRoom in rooms )			{				// listen for events				room.addEventListener( BaseRoomEvent.ADD_OCCUPANT, addOccupant, false, 0, true );				room.addEventListener( BaseRoomEvent.JOIN_RESULT, joinedRoom, false, 0, true );				room.addEventListener( BaseRoomEvent.REMOVE_OCCUPANT, removeOccupant, false, 0, true );				room.addEventListener( BaseRoomEvent.CLIENT_ATTRIBUTE_UPDATE, clientAttributeUpdate, false, 0, true );				room.addEventListener( BaseRoomEvent.OCCUPANT_COUNT, numClients, false, 0, true );			}			if ( _connection.connected )			{				_connection.createRooms( _rooms );			}		}        		// ====================================		// PROTECTED METHODS		// ====================================				/**		 * Triggered when the connection is created.		 *  		 * @param event		 */				protected function connecting( event:BaseConnectionEvent ):void		{			notifyClient( event.type );		}				/**		 * Triggered when the connection is established and ready for use.		 *  		 * @param event		 */				protected function connectionReady( event:BaseConnectionEvent ):void		{			notifyClient( event.type );						// create rooms			_connection.createRooms( _rooms );		}		/**		 * Triggered when the connection is closed.		 * 		 * @param event		 */		protected function connectionClosed( event:BaseConnectionEvent ):void		{			notifyClient( event.type );		}		        // ====================================		// EVENT HANDLERS		// ====================================		/**		 * Dispatched when the number of occupants in a room changes while the		 * current client is in, or observing, the room.		 *		 * @param event		 */		protected function numClients( event:BaseRoomEvent ):void		{			event.preventDefault();						notifyClient( event.type, event.data.getNumClients() );		}		/**		 * Add a new occupant to the room.		 *		 * @param event		 */		protected function addOccupant( event:BaseRoomEvent ):void		{			event.preventDefault();						notifyClient( event.type, event );		}		/**		 * Remove occupant from the room.		 *		 * @param event		 */		protected function removeOccupant( event:BaseRoomEvent ):void		{			event.preventDefault();						notifyClient( event.type, event );		}		/**		 * Joined room.		 *		 * @param event		 */		protected function joinedRoom( event:BaseRoomEvent ):void		{			event.preventDefault();						notifyClient( event.type, event );		}		/**		 * Triggered when one of the client's attributes changes.		 *		 * @param event		 */		protected function clientAttributeUpdate( event:BaseRoomEvent ):void		{			event.preventDefault();			notifyClient( event.type, event );		}		    }}