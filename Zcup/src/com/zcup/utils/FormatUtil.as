package com.zcup.utils{
	import flash.display.InteractiveObject;
	import flash.events.FocusEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	
	/**
	 * 字符串帮助类
	 * 
	 * @author wewell
	 */
	public class FormatUtil {
		
		// 格式化字符串, 仅支持 %nd 格式, 其中 n=1,2,3...
		static public function printf_d(fmt:String, ...args):String{
			
			var argIndex:int;
			var reg:RegExp = /%(\d)d/g;
			return fmt.replace(reg, onMatch);
			
			function onMatch(match:String, desc:String, index:int, str:String):String{
				var value:Object = args[argIndex++];
				if(value == null) return "null";
				
				var str:String = value.toString();
				var len:int = str.length;
				var len2:int = int(desc);
				for(; len<len2; len++) str = "0" + str;
				return str;
			};
		}
		
		// 按指定格式返回字符串
		// 如: printf(fmt, arg0, arg1, arg2, ...);
		static public function printf(fmt:String, ...args):String{
			var argIndex:int;
			var onMatch:Function = function (match:String,
											 desc:String,
											 index:int,
											 str:String):String
			{
				return match_token(match, args[argIndex++] );
			};
			return fmt.replace(exp_printf, onMatch);
		}
		
		// 批处理 printf, 把多个调用 printf 的参数, 合并到一个函数调用中
		// 如: printf_batch(fmt0, arg0_0, arg0_1, arg0_2, fmt1, arg1_0, arg1_1, arg1_2, fmt2, ...);
		static public function printf_batch(...args):String{
			var fmtIndex:int, argIndex:int;
			var onMatch:Function = function (match:String,
											 desc:String,
											 index:int,
											 str:String):String
			{
				return match_token(match, args[argIndex++]);
			};
			var str:String = "";
			while(fmtIndex < args.length){
				var fmt:String = args[fmtIndex] as String;
				argIndex = fmtIndex + 1;
				str += fmt.replace(exp_printf, onMatch);
				fmtIndex = argIndex;
			}
			return str;
		}
		
		// 和 printf_batch 类似, 每个 arg0 作为是否显示该记录的控制标志
		// 如: printf_select(fmt0, arg0_0, arg0_1, fmt1, arg1_0, fmt2, arg2_0, ...);		// arg(n)_0 同时作为参数, 也同时作为是否输出的控制标志
		static public function printf_select(...args):String{
			//tracing("printf_select");
			var fmtIndex:int, argIndex:int;
			var onMatch:Function = function (match:String,
											 desc:String,
											 index:int,
											 str:String):String
			{
				return match_token(match, args[argIndex++]);
			};
			var str:String = "";
			//tracing("args.length : ",args.length);
			while(fmtIndex < args.length)
			{
				var fmt:String = args[fmtIndex] as String;
				argIndex = fmtIndex + 1;
				var value:Object = args[argIndex];
				//tracing("value : ",value);
				var tmp:String = fmt.replace(exp_printf, onMatch);
				
				if( (argIndex!=fmtIndex+1) && ( value==null || value=="" || value==false || value==0 ) )
				{
					// ignore
					var iiii:int = 0;
				}
				else
				{
					str += tmp;
				}
				fmtIndex = argIndex;
			}
			
			return str;
		}
		static private function match_token(token:String, value:Object):String{
			if(value == null) return "null";
			switch(token)
			{
				case "%d":			return String(int(value));
				case "%D":			return int(value)>0 ? "+"+String(int(value)): String(int(value));
				case "%u":			return String(uint(value));
				case "%f":			return String(Number(value));
				case "%s":			return String(value);
				case "%e":			return encodeURIComponent(String(value));
				case "%?":			return "";
				default:			return token;
			}
		}
		
		// 返回 rep 的重复 times 次数后的值
		static public function repeat(times:int, rep:String):String{
			var str:String = "";
			while(times-- > 0) str += rep;
			return str;
		}
		
		// 转换 阿拉伯数字 到 中文数字, 暂不支持小数
		static public function chineseNumber(value:uint):String{
			
			// 常量
			const map_num:Array 	= ["零","一","二","三","四","五","六","七","八","九"];
			const map_a:Array 		= ["千","百","十", ""];			// 单位a
			//const map_b:Array 		= ["兆","亿","万", ""];			// 单位b
			const map_b:Array 		= ["亿","万", ""];			// 单位b
			const LEN:int	 		= map_a.length * map_b.length;	// 字符串最大长度
			
			// 转换 value 为字符串格式, 并前面填充 '0', 得到如 '0001'
			var buf:String = value.toString();
			buf = repeat(LEN-buf.length, "0") + buf;
			if(buf.length != LEN) return "超出上限";
			
			// 遍历每个数字
			var prev:int = 100;			// 上一个有效数字的位置
			var b:String = "";			// 单位b的名字, 在变更后才添加
			var str:String = "";		// 结果字符串
			for(var i:int=0; i<LEN; i++)
			{
				// 仅遍历有效数字
				var ch:String = buf.charAt(i);
				if(ch == '0') continue;
				
				// 单位b, 如果变动, 则添加到 str 上
				var b2:String = map_b[ int(i / 4) ];
				if(b2 != b){
					str += b;		// 添加先前的单位
					b = b2;			// 同一个单位b, 只可能添加一次
				}
				
				// 补零, 当有效数字非连续时
				if(prev < i-1){
					if( (i % 4) != 0 )		// 千位不允许
						str += map_num[0];
				} 
				prev = i;
				
				// 数字
				str += map_num[ch.charCodeAt(0) - 0x30];
				
				// 单位a
				str += map_a[ i % 4];
			}
			str += b;	// 补上单位b
			
			// 修饰
			{
				// 空串
				if(str == "") str = "零";
				
				// 以 "一十" 开始变为以 "十" 开始
				str = str.replace(new RegExp("^一十", ""), "十");
			}
			
			//
			return str;
		}
		
		
		/**
		 * 破坏 html 标签, 返回新的字符串, 如替换 '<' => '&lt;' 和 '&' => '&amp;' 
		 * @param dangerSource	危险的文本, 其中包含 html 标签
		 * @return 				安全的文本, 其中的 html 标签已经被破坏
		 */
		static public function html_destroyTag(dangerSource:String):String{
			if(! dangerSource ) return null;
			
			//
			var onMatch:Function = function (match:String,
											 desc:String,
											 index:int,
											 str:String):String
			{
				switch(match)
				{
					case "<":		return "&lt;";
					case "&":		return "&amp;"
					default:		return match;
				}
			}; 
			return dangerSource.replace(exp_htmlTag, onMatch);
		}
		
		/**
		 * 转换 html 标签中的 相对路径, 到绝对路径
		 * 
		 * 	示例: 
		 * 		var root:String = "http://www.baidu.com/";							// 根路径
		 * 		var html:String = "<a href='index.html'>click me</a>";				// 相对路径表示的 html 
		 * 		var html2:String = html_toFullPath(root, html);						// 转换为绝对路径
		 * 		tracing(html2);
		 * 
		 * 		输出:
		 * 		<a href='http://www.baidu.com/index.html'>click me</a>				// 绝对路径表示的 html
		 * 
		 * 	规则:
		 * 		1, 自动识别并忽略 href='event:' 标签
		 */ 
		static public function html_toFullPath(rootPath:String, html:String):String{
			var onMatch:Function = function(match:String,
											g0:String,
											g1:String,
											index:int,
											str:String):String
			{
				if(g1.toLocaleLowerCase() == "event") return match;
				return g0 + rootPath + g1; 
			};
			return html.replace(exp_toFullPath, onMatch);
		}		
		
		//
		static private const exp_toFullPath:RegExp = /(href\s*=\s*['"])([^'":]*)/gi;
		static private const exp_printf:RegExp = /(%[d|D|u|f|s|e|?])/g;
		static private const exp_htmlTag:RegExp	= /([<|&])/g;
		static private const dot3:String = "...      {F599C583-D6E7-4468-8FD0-FC0B80C94E4E}"; 
		
		
		/**
		 * 为文本控件提供显示 "..." 符号的功能, 不支持 html 显示(html仅支持 ellipsis_cut)
		 * 
		 * @param target 被监视的对象, 可以是一个 TextField, 或者包含它的父窗口 
		 */ 
		static public function ellipsis_provider(target:InteractiveObject):void{
			target.addEventListener(FocusEvent.FOCUS_IN, ellipsis_onFocusChange);
			target.addEventListener(FocusEvent.FOCUS_OUT, ellipsis_onFocusChange);
		}
		static private function ellipsis_onFocusChange(event:FocusEvent):void{
			var tf:TextField = event.target as TextField;
			if(event.type == FocusEvent.FOCUS_IN)	ellipsis_remove(tf);
			if(event.type == FocusEvent.FOCUS_OUT)	ellipsis_add(tf);
		}
		static private function ellipsis_valid(tf:TextField):Boolean{
			return 	tf != null
				&&	tf.text.length>0
				&&	tf.type == TextFieldType.DYNAMIC
				&&	tf.multiline == false;
			;		
		}
		
		// 为文本控件添加 "..."
		static public function ellipsis_add(tf:TextField, recoverable:Boolean=true):void{
			if(! ellipsis_valid(tf) ) return;
			
			ellipsis_remove(tf);
			
			// 计算 limit
			var limit:int = tf.width - int( tf.defaultTextFormat.rightMargin );
			if(tf.textWidth < limit) return;
			var text:String = tf.text;
			tf.text = dot3;
			var width:int = tf.getCharBoundaries(2).right;
			limit -= width;
			tf.text = text;
			
			var numChars:int = tf.getLineLength(0);
			for(var i:int=0; i<numChars; i++)
			{
				var b:Rectangle = tf.getCharBoundaries(i);
				if(b.right >= limit)
				{
					tf.scrollH = 0;
					var t0:String = tf.text.substr(0, i);
					
					if(recoverable){
						var t1:String = tf.text.substr(i);
						tf.text = t0 + dot3 + t1;
					}
					else{
						tf.text = t0 + "...";
					}
					break; 
				}
			}
		}
		
		// 为文本控件删除 "..."
		static public function ellipsis_remove(tf:TextField):void{
			if(! ellipsis_valid(tf) ) return;
			
			tf.text = tf.text.replace(dot3, "");
		}
		
		// 剪裁 text
		static public function ellipsis_cut(tf:TextField, text:String):String{
			
			tf.text = "......";
			var limit:int = tf.width - int( tf.defaultTextFormat.rightMargin ) - tf.textWidth;
			tf.text = text;
			var numChars:int = tf.getLineLength(0);
			for(var i:int=0; i<numChars; i++){
				var b:Rectangle = tf.getCharBoundaries(i);
				if(!b || b.right >= limit) return text.substr(0, i) + "...";
			}
			return text;
		}
	}
}
