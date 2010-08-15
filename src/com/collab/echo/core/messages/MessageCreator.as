﻿/*Echo project.Copyright (C) 2003-2010 CollabThis program is free software: you can redistribute it and/or modifyit under the terms of the GNU General Public License as published bythe Free Software Foundation, either version 3 of the License, or(at your option) any later version.This program is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY; without even the implied warranty ofMERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See theGNU General Public License for more details.You should have received a copy of the GNU General Public Licensealong with this program.  If not, see <http://www.gnu.org/licenses/>.*/package com.collab.echo.core.messages{	import com.collab.echo.core.messages.chat.ChatMessage;
	
	import flash.errors.IllegalOperationError;
		/**	 * Abstract message creator.	 * 	 * @author Thijs Triemstra	 * 	 * @langversion 3.0 	 * @playerversion Flash 9	 */		public class MessageCreator	{ 		// ====================================		// PUBLIC METHODS		// ====================================				/**		 * Create a new chat message.		 * 		 * @see com.collab.echo.core.message.ChatMessageTypes		 * 		 * @param type 			Message type.		 * @param data			Message content.		 * @param includeSelf	Include local client for delivery.		 */				public function create( type:String, data:String, includeSelf:Boolean=false ):ChatMessage		{			var message:ChatMessage;						if ( type && data )			{				message = createMessage( type, data, includeSelf );			}						return message;		}				// ====================================		// PROTECTED METHODS		// ====================================				/**		 * Create and return a new chat message.		 * 		 * @param type			Message type.		 * @param data			Message content.		 * @param includeSelf	Include local client for delivery.		 * @return 				A new ChatMessage instance.		 */				protected function createMessage( type:String, data:String, includeSelf:Boolean=false ):ChatMessage		{ 			throw new IllegalOperationError( "Abstract method: must be overridden in a subclass" );			return null;		}			}}