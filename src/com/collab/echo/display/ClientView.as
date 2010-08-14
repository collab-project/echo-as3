/* * Echo project. * * Copyright (C) 2003-2010 Collab * * This program is free software: you can redistribute it and/or modify * it under the terms of the GNU General Public License as published by * the Free Software Foundation, either version 3 of the License, or * (at your option) any later version. * * This program is distributed in the hope that it will be useful, * but WITHOUT ANY WARRANTY; without even the implied warranty of * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the * GNU General Public License for more details. * * You should have received a copy of the GNU General Public License * along with this program.  If not, see <http://www.gnu.org/licenses/>. */package com.collab.echo.display{
	import com.collab.echo.core.DataOut;
	import com.collab.echo.core.IClient;
	import com.collab.echo.core.rooms.IRoom;
	import com.collab.echo.events.BaseRoomEvent;
	    /**     * Observer view.     *     * @author Thijs Triemstra     *      * @langversion 3.0 	 * @playerversion Flash 9     */    public class ClientView extends BaseView implements IClient, IRoom, DataOut    {		/**		 * 		 */    			protected var data 	: Array;		        /**         * Constructor.         *          * @param width         * @param height         */		        public function ClientView( width:int=0, height:int=0 )        {        	super( width, height );        	show();        }        public function outToDesign() : Array        {            return data;        }        /**         * @param notification         * @param args         */		        public function update( notification:String, ...args:Array ) : void        {            data = args;			            switch ( notification )            {            	case BaseRoomEvent.ADD_OCCUPANT:            		addOccupant( args );            		break;            		            	case BaseRoomEvent.REMOVE_OCCUPANT:            		removeOccupant( args );            		break;            		            	case BaseRoomEvent.OCCUPANT_COUNT:            		numClients( args );            		break;            		            	case BaseRoomEvent.JOIN_RESULT:            		joinedRoom( args );            		break;            }        }                /**		 * Notify the view that the local client joined the room.		 *		 * @param args		 */		public function joinedRoom( args:Array=null ):void		{		}		        /**		 * Add a new occupant to this view.		 *		 * @param args		 */		public function addOccupant( args:Array=null ):void        {        }                /**		 * Remove an existing occupant from this view.		 *		 * @param args		 */		public function removeOccupant( args:Array=null ):void		{		}				/**		 * Notify the view that the clients in the room updated.		 *		 * @param args		 */		public function numClients( args:Array=null ):void		{		}            }}