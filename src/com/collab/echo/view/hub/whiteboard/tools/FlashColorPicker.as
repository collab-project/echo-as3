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
package com.collab.echo.view.hub.whiteboard.tools
{
	import com.collab.echo.view.display.BaseView;
	import com.collab.echo.view.display.util.TextUtils;
	
	import fl.controls.ColorPicker;
	
	import flash.text.TextField;
	
	/**
	 * @author Thijs Triemstra
	 */	
	public class FlashColorPicker extends BaseView
	{
		// ====================================
		// PROTECTED VARS
		// ====================================
		
		/**
		 * Tool for selecting a line color.
		 * 
		 * <p>TODO: find alternative for fl.controls.ColorPicker.</p>
		 */		
		protected var colorPicker		: ColorPicker;
		
		/**
		 * Label field. 
		 */		
		protected var label				: TextField;
		
		// ====================================
		// PRIVATE VARS
		// ====================================
		
		private var _label				: String;
		
		/**
		 * Constructor.
		 * 
		 * @param label
		 */		
		public function FlashColorPicker( label:String=null )
		{
			_label = label;
			
			super();
			show();
		}
		
		// ====================================
		// PROTECTED METHODS
		// ====================================
		
		/**
		 * @private 
		 */		
		override protected function draw():void
		{
			// label
			label = TextUtils.createTextField( null, _label );
			addChild( label );
			
			// color picker
			colorPicker = new ColorPicker();
			addChild( colorPicker );
		}

		/**
		 * @private 
		 */		
		override protected function layout():void
		{
			// label
			label.x = 0
			label.y = 5;
			
			// color picker
			colorPicker.x = label.x + label.width + 5;
			colorPicker.y = 0;
		}
		
		/**
		 * @private 
		 */		
		override protected function invalidate():void
		{
			removeChildFromDisplayList( colorPicker );
			removeChildFromDisplayList( label );
			
			super.invalidate();
		}
		
	}
}