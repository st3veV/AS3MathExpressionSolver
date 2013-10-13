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
	import flash.utils.Dictionary;
	
	public class MathExpressionSolver
	{
		
		private var _prepared:Vector.<MathToken>;
		private var _variables:Dictionary;
		
		public function MathExpressionSolver() 
		{
			_variables = new Dictionary();
		}
		
		/**
		 * Solves unprepared expression
		 * @param	expression
		 * @return
		 */
		public function solve(expression:String):Number
		{
			var tokens:Vector.<MathToken> = tokenize(expression);
			var rpn:Vector.<MathToken> = shuntingYard(tokens);
			var result:Number = compute(rpn);
			return result;
		}
		
		/**
		 * Prepares expression to be reused with changing variables
		 * @param	expression
		 */
		public function prepareExpression(expression:String):void
		{
			var tokens:Vector.<MathToken> = tokenize(expression);
			_prepared = shuntingYard(tokens);
		}
		
		/**
		 * Sets variable to value
		 * @param	character
		 * @param	value
		 */
		public function setVariable(character:String, value:Number):void
		{
			_variables[character] = value;
		}
		
		/**
		 * Solves prepared expression
		 * @return
		 */
		public function solvePrepared():Number
		{
			return compute(_prepared.slice(0, _prepared.length));
		}
		
		private function is_ident(s:String):Boolean
		{
			if (s.charAt(0) >= '0' && s.charAt(0) <= '9')
				return true;
			else
				return false;
		}
		
		private function is_var(s:String):Boolean
		{
			if (s.charAt(0) >= 'a' && s.charAt(0) <= 'z')
				return true;
			else
				return false;
		}
		
		private function tokenize(str:String):Vector.<MathToken>
		{
			var strpos:int;
			var len:int = str.length;
			var ret:Vector.<MathToken> = new Vector.<MathToken>();
			var s:String = "";
			var t:MathToken;
			
			while (strpos <= len)
			{
				if (is_ident(str.charAt(strpos)) || str.charAt(strpos) == ".")
				{
					s += str.charAt(strpos);
				}
				else if (is_var(str.charAt(strpos)))
				{
					t = new MathToken();
					t.variable = str.charAt(strpos);
					ret.push(t);
				}
				else if (str.charAt(strpos) != " ")
				{
					if (s.length != 0)
					{
						var tt:MathToken = new MathToken();
						tt.value = parseFloat(s);
						s = "";
						ret.push(tt);
					}
					t = new MathToken();
					t.operation = str.charAt(strpos);
					ret.push(t);
				}
				strpos++;
			}
			return ret;
		}
		
		private function shuntingYard(tokens:Vector.<MathToken>):Vector.<MathToken>
		{
			var ret:Vector.<MathToken> = new Vector.<MathToken>();
			var operators:Vector.<MathToken> = new Vector.<MathToken>();
			var t:MathToken;
			
			while (tokens.length > 0)
			{
				t = tokens.shift();
				if (t.isNumber() || t.isVariable())
				{
					ret.push(t);
				}
				else if (t.isOperation())
				{
					while (operators.length > 0 &&
					((t.isLeftAssoc() && t.precendence() <= operators[operators.length - 1].precendence()) ||
					(!t.isLeftAssoc() && t.precendence() < operators[operators.length - 1].precendence())))
					{
						ret.push(operators.pop());
					}
					operators.push(t);
				}
				else if (t.isParenthesisLeft())
				{
					operators.push(t);
				}
				else if (t.isParenthesisRight())
				{
					while (operators.length > 0 && !operators[operators.length - 1].isParenthesisLeft())
					{
						ret.push(operators.pop());
					}
					if (operators.length > 0 && operators[operators.length - 1].isParenthesisLeft())
					{
						operators.pop();
					}
				}
			}
			while (operators.length > 0)
			{
				ret.push(operators.pop());
			}
			
			return ret;
		}
		
		private function compute(tokens:Vector.<MathToken>):Number
		{
			var stack:Vector.<MathToken> = new Vector.<MathToken>();
			var t:MathToken;
			var tt:MathToken;
			while (tokens.length > 0) 
			{
				t = tokens.shift();
				
				if (t.isNumber())
				{
					stack.push(t);
				}
				else if (t.isVariable())
				{
					tt = new MathToken();
					var v:Number = _variables[t.variable];
					if (!isNaN(v))
						tt.value = v;
					else
						tt.value = 0;
					stack.push(tt);
				}
				else // if t is not a number nor variable then it is operation
				{
					tt = MathToken.performOperation(t, stack.pop(), stack.pop());
					stack.push(tt);
				}
			}
			return stack.pop().value;
		}
		
		
	}

}