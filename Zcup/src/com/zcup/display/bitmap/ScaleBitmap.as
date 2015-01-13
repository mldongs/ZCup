package com.zcup.display.bitmap {
	
	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.geom.Matrix;	import flash.geom.Rectangle;	
	
	/**
	 * ...
	 * @author mldongs
	 * @qq:25772076
	 * @desc: 用于位图缩放
	 * p.s:
	 * var myScaleBitmap:ScaleBitmap=new ScaleBitmap(bmd);
	 * myScaleBitmap.scale9Grid=new Rectangle(20,20,80,80);
	 * myScaleBitmap.setSize(200,64);
	 * addChild(myScaleBitmap);
	 */
	
	public class ScaleBitmap extends Bitmap {

		protected var _originalBitmap : BitmapData;
		protected var _scale9Grid : Rectangle = null;

		function ScaleBitmap(bmpData : BitmapData = null, pixelSnapping : String = "auto", smoothing : Boolean = true) {
			
			super(bmpData, pixelSnapping, smoothing);
		
			// 原始位图
			_originalBitmap = bmpData.clone();
		}

		/**
		 * 设置 bitmapData
		 */
		override public function set bitmapData(bmpData : BitmapData) : void {
			_originalBitmap = bmpData.clone();
			if (_scale9Grid != null) {
				if (!validGrid(_scale9Grid)) {
					_scale9Grid = null;
				}
				setSize(bmpData.width, bmpData.height);
			} else {
				assignBitmapData(_originalBitmap.clone());
			}
		} 

		/**
		 * 设置 width
		 */
		override public function set width(w : Number) : void {
			if (w != width) {
				setSize(w, height);
			}
		}

		/**
		 * 设置 height
		 */
		override public function set height(h : Number) : void {
			if (h != height) {
				setSize(width, h);
			}
		}

		/**
		 * 设置 scale9Grid
		 */
		override public function set scale9Grid(r : Rectangle) : void {
			// Check if the given grid is different from the current one
			if ((_scale9Grid == null && r != null) || (_scale9Grid != null && !_scale9Grid.equals(r))) {
				if (r == null) {
					// If deleting scalee9Grid, restore the original bitmap
					// then resize it (streched) to the previously set dimensions
					var currentWidth : Number = width;					var currentHeight : Number = height;
					_scale9Grid = null;
					assignBitmapData(_originalBitmap.clone());
					setSize(currentWidth, currentHeight);
				} else {
					if (!validGrid(r)) {
						throw (new Error("#001 - The _scale9Grid does not match the original BitmapData"));
						return;
					}
					
					_scale9Grid = r.clone();
					resizeBitmap(width, height);
					scaleX = 1;
					scaleY = 1;
				}
			}
		}

		/**
		 * assignBitmapData
		 * Update the effective bitmapData
		 */
		private function assignBitmapData(bmp : BitmapData) : void {
			super.bitmapData.dispose();
			super.bitmapData = bmp;
		}

		private function validGrid(r : Rectangle) : Boolean {
			return r.right <= _originalBitmap.width && r.bottom <= _originalBitmap.height;
		}

		/**
		 * get scale9Grid
		 */
		override public function get scale9Grid() : Rectangle {
			return _scale9Grid;
		}

		
		/**
		 * setSize
		 */
		public function setSize(w : Number, h : Number) : void {
			if (_scale9Grid == null) {
				super.width = w;
				super.height = h;
			} else {
				w = Math.max(w, _originalBitmap.width - _scale9Grid.width);
				h = Math.max(h, _originalBitmap.height - _scale9Grid.height);
				resizeBitmap(w, h);
			}
		}

		/**
		 * get original bitmap
		 */
		public function getOriginalBitmapData() : BitmapData {
			return _originalBitmap;
		}

		/**
		 * resize bitmap
		 */
		protected function resizeBitmap(w : Number, h : Number) : void {
			
			var bmpData : BitmapData = new BitmapData(w, h, true, 0x00000000);
			
			var rows : Array = [0, _scale9Grid.top, _scale9Grid.bottom, _originalBitmap.height];
			var cols : Array = [0, _scale9Grid.left, _scale9Grid.right, _originalBitmap.width];
			
			var dRows : Array = [0, _scale9Grid.top, h - (_originalBitmap.height - _scale9Grid.bottom), h];
			var dCols : Array = [0, _scale9Grid.left, w - (_originalBitmap.width - _scale9Grid.right), w];

			var origin : Rectangle;
			var draw : Rectangle;
			var mat : Matrix = new Matrix();

			
			for (var cx : int = 0;cx < 3; cx++) {
				for (var cy : int = 0 ;cy < 3; cy++) {
					origin = new Rectangle(cols[cx], rows[cy], cols[cx + 1] - cols[cx], rows[cy + 1] - rows[cy]);
					draw = new Rectangle(dCols[cx], dRows[cy], dCols[cx + 1] - dCols[cx], dRows[cy + 1] - dRows[cy]);
					mat.identity();
					mat.a = draw.width / origin.width;
					mat.d = draw.height / origin.height;
					mat.tx = draw.x - origin.x * mat.a;
					mat.ty = draw.y - origin.y * mat.d;
					bmpData.draw(_originalBitmap, mat, null, null, draw, smoothing);
				}
			}
			assignBitmapData(bmpData);
		}
	}
}