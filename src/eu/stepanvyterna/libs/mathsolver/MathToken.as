/**
 * Copyright (c) 2013 Stepan Vyterna
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 */
 
package eu.stepanvyterna.libs.mathsolver
{
	
	public class MathToken
	{
		
		private var _value:Number;
		private var _variable:String;
		private var _operation:String;
		
		public function MathToken() 
		{
			
		}
		
		public static function performOperation(op:MathToken, num1:MathToken, num2:MathToken):MathToken
		{
			var t:MathToken = new MathToken();
			switch(op.operation)
			{
				case "+":
				{
					t.value = num2.value + num1.value;
					break;
				}
				case "-":
				{
					t.value = num2.value - num1.value;
					break;
				}
				case "*":
				{
					t.value = num2.value * num1.value;
					break;
				}
				case "/":
				{
					t.value = num2.value / num1.value;
					break;
				}
				case "%":
				{
					t.value = num2.value % num1.value;
					break;
				}
				case "^":
				{
					t.value = Math.pow(num2.value, num1.value);
					break;
				}
				default:
				{
					t.value = 0;
				}
			}
			return t;
		}
		
		
		public function isNumber():Boolean
		{
			if (!isNaN(_value))
				return true;
			else
				return false;
		}
		
		public function isVariable():Boolean
		{
			if (_variable != null && !isNumber() && !isOperation())
				return true;
			else
				return false;
		}
		
		public function precendence():int
		{
			switch(_operation)
			{
				case '!':
					return 5;
				case '^':
					return 4;
				case '*':  case '/': case '%':
					return 3;
				case '+': case '-':
					return 2;
				case '=':
					return 1;
			}
			return 0;

		}
		
		public function isLeftAssoc():Boolean
		{
			switch(_operation)
			{
				// left to right
				case '*': case '/': case '%': case '+': case '-':
					return true;
				// right to left
				case '^': case '!':
					return false;
			}
			return false;
		}
		
		public function isParenthesisLeft():Boolean
		{
			if (_operation != null && _operation == "(")
			{
				return true;
			}
			return false;
		}
		
		public function isParenthesisRight():Boolean
		{
			if (_operation != null && _operation == ")")
			{
				return true;
			}
			return false;
		}
		
		public function isOperation():Boolean
		{
			if (_operation != null)
			{
				if (_operation != "" && _operation != "(" && _operation != ")")
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
		
		public function get value():Number { return _value; }
		
		public function set value(value:Number):void 
		{
			_value = value;
		}
		
		public function get operation():String { return _operation; }
		
		public function set operation(value:String):void 
		{
			_operation = value;
		}
		
		public function get variable():String { return _variable; }
		
		public function set variable(value:String):void 
		{
			_variable = value;
		}
		
		public function toString():String
		{
			if (isNumber())
			{
				return _value + "";
			}
			else
			{
				return _operation;
			}
		}
		
	}

}