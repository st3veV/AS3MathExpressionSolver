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
 * 
 * This class uses MinimalComps by Keith Peters
 * This library can be obtained at <https://github.com/minimalcomps/minimalcomps>
 */

package eu.stepanvyterna.libs
{
	import com.bit101.components.HBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	import eu.stepanvyterna.libs.mathsolver.MathExpressionSolver;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MathSolverTest extends Sprite
	{
		private var unpreparedSolver:MathExpressionSolver;
		private var unpreparedExpressionInput:InputText;
		private var unpreparedExpressionOutput:Label;
		private var preparedExpressionInputText:InputText;
		private var varA:InputText;
		private var varB:InputText;
		private var varC:InputText;
		private var varD:InputText;
		private var preparedSolver:MathExpressionSolver;
		private var preparedLetters:Vector.<String>;
		private var preparedValues:Vector.<String>;
		private var preparedInputs:Vector.<InputText>;
		private var preparedExpressionOutput:Label;
		
		public function MathSolverTest():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			unpreparedSolver = new MathExpressionSolver();
			preparedSolver = new MathExpressionSolver();
			
			var unprepared:Panel = new Panel(this);
			var layout:VBox = new VBox(unprepared);
			
			new Label(layout, 0, 0, "Unprepared expression");
			
			var line:HBox = new HBox(layout);
			unpreparedExpressionInput = new InputText(line, 0, 0, "6 / 2 * (1 + 2)");
			new PushButton(line, 0, 0, "Solve", onSolvePress);
			
			line = new HBox(layout);
			new Label(line, 0, 0, "Output: ");
			unpreparedExpressionOutput = new Label(line);
			unprepared.setSize(unprepared.content.width, unprepared.content.height);
			
			
			var prepared:Panel = new Panel(this, unprepared.x + unprepared.width + 10);
			layout = new VBox(prepared);
			
			new Label(layout, 0, 0, "Prepared expression");
			
			line = new HBox(layout);
			preparedExpressionInputText = new InputText(line, 0, 0, "a / b * (c + d)");
			new PushButton(line, 0, 0, "Prepare", onPreparePress);
			
			preparedLetters = new <String> ["a", "b", "c", "d"];
			preparedValues = new <String> ["6", "2", "1", "2"];
			preparedInputs = new <InputText> [varA, varB, varC, varD];
			
			for (var i:int = 0; i < preparedLetters.length; i++) 
			{
				line = new HBox(layout);
				new Label(line, 0, 0, preparedLetters[i] + ":");
				preparedInputs[i] = new InputText(line, 0, 0, preparedValues[i]);
				preparedInputs[i].width = 50;
			}
			
			new PushButton(layout, 0, 0, "Solve prepared", onPreparedSolvePress);
			
			
			line = new HBox(layout);
			new Label(line, 0, 0, "Output: ");
			preparedExpressionOutput = new Label(line);
			
			prepared.setSize(prepared.content.width, prepared.content.height);
		}
		
		private function onPreparedSolvePress(e:MouseEvent):void 
		{
			for (var i:int = 0; i < preparedInputs.length; i++) 
			{
				preparedSolver.setVariable(preparedLetters[i], parseFloat(preparedInputs[i].text));
			}
			var s:Number = preparedSolver.solvePrepared();
			preparedExpressionOutput.text = s + "";
		}
		
		private function onPreparePress(e:MouseEvent):void 
		{
			preparedSolver.prepareExpression(preparedExpressionInputText.text);
		}
		
		private function onSolvePress(e:MouseEvent):void 
		{
			var s:Number = unpreparedSolver.solve(unpreparedExpressionInput.text);
			unpreparedExpressionOutput.text = s + "";
		}
	
	}

}