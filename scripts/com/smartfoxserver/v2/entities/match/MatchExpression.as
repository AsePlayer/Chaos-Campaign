package com.smartfoxserver.v2.entities.match
{
     import com.smartfoxserver.v2.entities.data.ISFSArray;
     import com.smartfoxserver.v2.entities.data.SFSArray;
     
     public class MatchExpression
     {
           
          
          private var _varName:String;
          
          private var _condition:com.smartfoxserver.v2.entities.match.IMatcher;
          
          private var _value;
          
          internal var _logicOp:LogicOperator;
          
          internal var _parent:MatchExpression;
          
          internal var _next:MatchExpression;
          
          public function MatchExpression(varName:String, condition:com.smartfoxserver.v2.entities.match.IMatcher, value:*)
          {
               super();
               this._varName = varName;
               this._condition = condition;
               this._value = value;
          }
          
          internal static function chainedMatchExpression(varName:String, condition:com.smartfoxserver.v2.entities.match.IMatcher, value:*, logicOp:LogicOperator, parent:MatchExpression) : MatchExpression
          {
               var matchingExpression:MatchExpression = new MatchExpression(varName,condition,value);
               matchingExpression._logicOp = logicOp;
               matchingExpression._parent = parent;
               return matchingExpression;
          }
          
          public function and(varName:String, condition:com.smartfoxserver.v2.entities.match.IMatcher, value:*) : MatchExpression
          {
               this._next = chainedMatchExpression(varName,condition,value,LogicOperator.AND,this);
               return this._next;
          }
          
          public function or(varName:String, condition:com.smartfoxserver.v2.entities.match.IMatcher, value:*) : MatchExpression
          {
               this._next = chainedMatchExpression(varName,condition,value,LogicOperator.OR,this);
               return this._next;
          }
          
          public function get varName() : String
          {
               return this._varName;
          }
          
          public function get condition() : com.smartfoxserver.v2.entities.match.IMatcher
          {
               return this._condition;
          }
          
          public function get value() : *
          {
               return this._value;
          }
          
          public function get logicOp() : LogicOperator
          {
               return this._logicOp;
          }
          
          public function hasNext() : Boolean
          {
               return this._next != null;
          }
          
          public function get next() : MatchExpression
          {
               return this._next;
          }
          
          public function rewind() : MatchExpression
          {
               var currNode:MatchExpression = this;
               while(true)
               {
                    if(currNode._parent == null)
                    {
                         break;
                    }
                    currNode = currNode._parent;
               }
               return currNode;
          }
          
          public function asString() : String
          {
               var sb:String = "";
               if(this._logicOp != null)
               {
                    sb += " " + this.logicOp.id + " ";
               }
               sb += "(";
               sb += this._varName + " " + this._condition.symbol + " " + (this.value is String ? "\'" + this.value + "\'" : this.value);
               return sb + ")";
          }
          
          public function toString() : String
          {
               var expr:MatchExpression = this.rewind();
               var sb:String = expr.asString();
               while(expr.hasNext())
               {
                    expr = expr.next;
                    sb += expr.asString();
               }
               return sb;
          }
          
          public function toSFSArray() : ISFSArray
          {
               var expr:MatchExpression = this.rewind();
               var sfsa:ISFSArray = new SFSArray();
               sfsa.addSFSArray(expr.expressionAsSFSArray());
               while(expr.hasNext())
               {
                    expr = expr.next;
                    sfsa.addSFSArray(expr.expressionAsSFSArray());
               }
               return sfsa;
          }
          
          private function expressionAsSFSArray() : ISFSArray
          {
               var expr:ISFSArray = new SFSArray();
               if(this._logicOp != null)
               {
                    expr.addUtfString(this._logicOp.id);
               }
               else
               {
                    expr.addNull();
               }
               expr.addUtfString(this._varName);
               expr.addByte(this._condition.type);
               expr.addUtfString(this._condition.symbol);
               if(this._condition.type == 0)
               {
                    expr.addBool(this._value);
               }
               else if(this._condition.type == 1)
               {
                    expr.addDouble(this._value);
               }
               else
               {
                    expr.addUtfString(this._value);
               }
               return expr;
          }
     }
}
