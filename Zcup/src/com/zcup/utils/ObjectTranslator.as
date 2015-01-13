package com.zcup.utils
{
	
	import flash.net.ObjectEncoding;
	import flash.net.getClassByAlias;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	/** *//**
	* Utility class to convert vanilla objects to class instances.
	*/
	public final class ObjectTranslator
	{
		
		/** *//**
		* Converts a plain vanilla object to be an instance of the class
		* passed as the second variable.  This is not a recursive funtion
		* and will only work for the first level of nesting.  When you have
		* deeply nested objects, you first need to convert the nested
		* objects to class instances, and then convert the top level object.
		* 
		* TODO: This method can be improved by making it recursive.  This would be 
		* done by looking at the typeInfo returned from describeType and determining
		* which properties represent custom classes.  Those classes would then
		* be registerClassAlias'd using getDefinititonByName to get a reference,
		* and then objectToInstance would be called on those properties to complete
		* the recursive algorithm.
		* 
		* @param object The plain object that should be converted
		* @param clazz The type to convert the object to
		*/
		public static function objectToInstance( object:Object, clazz:Class ):*
		{
			var bytes:ByteArray = new ByteArray();
			bytes.objectEncoding = ObjectEncoding.AMF0;
			
			// Find the objects and byetArray.writeObject them, adding in the
			// class configuration variable name -- essentially, we're constructing
			// and AMF packet here that contains the class information so that
			// we can simplly byteArray.readObject the sucker for the translation
			
			// Write out the bytes of the original object
			var objBytes:ByteArray = new ByteArray();
			objBytes.objectEncoding = ObjectEncoding.AMF0;
			objBytes.writeObject( object );
			
			// Register all of the classes so they can be decoded via AMF
			var typeInfo:XML = describeType( clazz );
			var fullyQualifiedName:String = typeInfo.@name.toString().replace( /::/, "." );
			registerClassAlias( fullyQualifiedName, clazz );
			
			// Write the new object information starting with the class information
			var len:int = fullyQualifiedName.length;
			bytes.writeByte( 0x10 );  // 0x10 is AMF0 for "typed object (class instance)"
			bytes.writeUTF( fullyQualifiedName );
			// After the class name is set up, write the rest of the object
			bytes.writeBytes( objBytes, 1 );
			
			// Read in the object with the class property added and return that
			bytes.position = 0;
			
			// This generates some ReferenceErrors of the object being passed in
			// has properties that aren't in the class instance, and generates TypeErrors
			// when property values cannot be converted to correct values (such as false
			// being the value, when it needs to be a Date instead).  However, these
			// errors are not thrown at runtime (and only appear in trace ouput when
			// debugging), so a try/catch block isn't necessary.  I'm not sure if this
			// classifies as a bug or not... but I wanted to explain why if you debug
			// you might seem some TypeError or ReferenceError items appear.
			var result:* = bytes.readObject();
			return result;
		}
		
		/**
		 * 优化后的转换方法
		 * 不会出现重复注册别名的情况 
		 * @param object
		 * @param clazz
		 * @return 
		 * 
		 */		
		public static function objectToInstance2( object:Object, clazz:Class ):* 
		{
			// Register all of the classes so they can be decoded via AMF
			var typeInfo:XML = describeType( clazz );
			var fullyQualifiedName:String = typeInfo.@name.toString().replace( /::/, "." );
			
			try{
				getClassByAlias(fullyQualifiedName);
			}
			catch(e:ReferenceError)
			{
				var bytes:ByteArray = new ByteArray();
				bytes.objectEncoding = ObjectEncoding.AMF0;
				
				// Find the objects and byetArray.writeObject them, adding in the
				// class configuration variable name -- essentially, we're constructing
				// and AMF packet here that contains the class information so that
				// we can simplly byteArray.readObject the sucker for the translation
				
				// Write out the bytes of the original object
				var objBytes:ByteArray = new ByteArray();
				objBytes.objectEncoding = ObjectEncoding.AMF0;
				objBytes.writeObject( object );
				
				registerClassAlias( fullyQualifiedName, clazz );
				
				// Write the new object information starting with the class information
				var len:int = fullyQualifiedName.length;
				bytes.writeByte( 0x10 );  // 0x10 is AMF0 for "typed object (class instance)"
				bytes.writeUTF( fullyQualifiedName );
				// After the class name is set up, write the rest of the object
				bytes.writeBytes( objBytes, 1 );
				
				// Read in the object with the class property added and return that
				bytes.position = 0;
				
				// This generates some ReferenceErrors of the object being passed in
				// has properties that aren't in the class instance, and generates TypeErrors
				// when property values cannot be converted to correct values (such as false
				// being the value, when it needs to be a Date instead).  However, these
				// errors are not thrown at runtime (and only appear in trace ouput when
				// debugging), so a try/catch block isn't necessary.  I'm not sure if this
				// classifies as a bug or not... but I wanted to explain why if you debug
				// you might seem some TypeError or ReferenceError items appear.
				var result:* = bytes.readObject();
				return result;
			}
			return object;
		}
			
	} // end class
} // end package 
