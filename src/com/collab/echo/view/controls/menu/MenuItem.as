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
package com.collab.echo.view.controls.menu
{
	import com.collab.echo.view.controls.buttons.LabelButton;
	import com.collab.echo.view.display.BaseView;
	import com.collab.echo.view.display.util.StyleDict;
	import com.collab.echo.view.events.MenuItemClickEvent;
	
	import flash.events.MouseEvent;
	
	// ====================================
	// EVENTS
	// ====================================
	
	/**
	 * Dispatched when the menu item is clicked.
	 *
	 * @eventType com.collab.echo.view.events.MenuItemClickEvent.CLICK
	 *
	 * @langversion 3.0
	 * @playerversion Flash 9.0.28.0
	 *  
	 *  @playerversion AIR 1.0
	 *  @productversion Flash CS3
	 */
	[Event(name="MenuItemClickEvent_click", type="com.collab.echo.view.events.MenuItemClickEvent")]
	
	/**
	 * Menu item.
	 *  
	 * @author Thijs Triemstra
	 */	
	public class MenuItem extends BaseView
	{
		// ====================================
		// CONSTANTS
		// ====================================
		
		public const UP_COLOR				: uint = StyleDict.GREY3;
		public const SELECT_COLOR			: uint = StyleDict.BLACK;
		
		// ====================================
		// PROTECTED VARS
		// ====================================
		
		protected var button				: LabelButton;
		protected var label					: String;
		
		// ====================================
		// INTERNAL VARS
		// ====================================
		
		/**
		 * @private 
		 */		
		internal var itemIndex				: int;
		
		/**
		 * @private 
		 */		
		internal var selectedState			: Boolean;
		
		// ====================================
		// GETTER/SETTER
		// ====================================
		
		/**
		 * @return 
		 */		
		public function get buttonHeight():Number
		{
			// XXX: 5?
			return button.height - 5;
		}
		
		/**
		 * @return 
		 */		
		public function get buttonWidth():Number
		{
			return button.width;
		}
		
		/**
		 * @return 
		 */		
		public function get selected():Boolean
		{
			return selectedState;
		}
		
		/**
		 * @return 
		 */		
		public function get index():int
		{
			return itemIndex;
		}
		
		/**
		 * Constructor.
		 *  
		 * @param index
		 * @param label
		 */		
		public function MenuItem( index:int=0, label:String=null )
		{
			this.label = label.toUpperCase();
			name = label;
			itemIndex = index;
			
			super();
			show();
		}
		
		// ====================================
		// PROTECTED METHODS
		// ====================================
		
		override protected function draw():void
		{
			// button
			button = new LabelButton( 0, 18, UP_COLOR, 0, 0 );
			button.addEventListener( MouseEvent.CLICK, onItemClick, false, 0, true );
			button.label = label;
			addChild( button );
		}
		
		override protected function layout():void
		{
			// button
			button.x = 0;
			button.y = 0;
		}
		
		override public function toString():String
		{
			return "<MenuItem label='" + label + "' index='" + itemIndex + "'/>";
		}
		
		override protected function invalidate():void
		{
			removeChildFromDisplayList( button );
			
			super.invalidate();
		}
		
		/**
		 * Select the menu item. 
		 */		
		public function select():void
		{
		}
		
		/**
		 * Deselect the menu item. 
		 */		
		public function deselect():void
		{
		}	
		
		// ====================================
		// EVENT HANDLERS
		// ====================================
		
		/**
		 * Invoked when the menu item was clicked.
		 * @param event
		 */		
		protected function onItemClick( event:MouseEvent ):void
		{
			event.stopImmediatePropagation();

			var evt:MenuItemClickEvent = new MenuItemClickEvent( MenuItemClickEvent.CLICK,
																 itemIndex, label, true, true );
			dispatchEvent( evt );
		}
		
	}
}