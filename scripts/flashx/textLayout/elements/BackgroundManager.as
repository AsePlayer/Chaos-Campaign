package flashx.textLayout.elements
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.engine.TextLine;
   import flash.utils.Dictionary;
   import flashx.textLayout.compose.TextFlowLine;
   import flashx.textLayout.container.ContainerController;
   import flashx.textLayout.tlf_internal;
   
   use namespace tlf_internal;
   
   [ExcludeClass]
   public class BackgroundManager
   {
       
      
      protected var _lineDict:Dictionary;
      
      public function BackgroundManager()
      {
         super();
         this._lineDict = new Dictionary(true);
      }
      
      public function addRect(tl:TextLine, fle:FlowLeafElement, r:Rectangle, color:uint, alpha:Number) : void
      {
         var currRecord:Object = null;
         var entry:Array = this._lineDict[tl];
         if(entry == null)
         {
            entry = this._lineDict[tl] = new Array();
         }
         var record:Object = new Object();
         record.rect = r;
         record.fle = fle;
         record.color = color;
         record.alpha = alpha;
         var fleAbsoluteStart:int = fle.getAbsoluteStart();
         for(var i:int = 0; i < entry.length; i++)
         {
            currRecord = entry[i];
            if(currRecord.hasOwnProperty("fle") && currRecord.fle.getAbsoluteStart() == fleAbsoluteStart)
            {
               entry[i] = record;
               return;
            }
         }
         entry.push(record);
      }
      
      public function addNumberLine(tl:TextLine, numberLine:TextLine) : void
      {
         var entry:Array = this._lineDict[tl];
         if(entry == null)
         {
            entry = this._lineDict[tl] = new Array();
         }
         entry.push({"numberLine":numberLine});
      }
      
      public function finalizeLine(line:TextFlowLine) : void
      {
      }
      
      tlf_internal function getEntry(line:TextLine) : *
      {
         return Boolean(this._lineDict) ? this._lineDict[line] : undefined;
      }
      
      public function drawAllRects(textFlow:TextFlow, bgShape:Shape, constrainWidth:Number, constrainHeight:Number) : void
      {
         var line:* = null;
         var entry:Array = null;
         var columnRect:Rectangle = null;
         var r:Rectangle = null;
         var record:Object = null;
         var i:int = 0;
         var numberLine:TextLine = null;
         var backgroundManager:BackgroundManager = null;
         var numberEntry:Array = null;
         var ii:int = 0;
         var numberRecord:Object = null;
         for(line in this._lineDict)
         {
            entry = this._lineDict[line];
            if(entry.length)
            {
               columnRect = entry[0].columnRect;
               for(i = 0; i < entry.length; i++)
               {
                  record = entry[i];
                  if(record.hasOwnProperty("numberLine"))
                  {
                     numberLine = record.numberLine;
                     backgroundManager = TextFlowLine.getNumberLineBackground(numberLine);
                     numberEntry = backgroundManager._lineDict[numberLine];
                     for(ii = 0; ii < numberEntry.length; ii++)
                     {
                        numberRecord = numberEntry[ii];
                        r = numberRecord.rect;
                        r.x += line.x + numberLine.x;
                        r.y += line.y + numberLine.y;
                        TextFlowLine.constrainRectToColumn(textFlow,r,columnRect,0,0,constrainWidth,constrainHeight);
                        bgShape.graphics.beginFill(numberRecord.color,numberRecord.alpha);
                        bgShape.graphics.drawRect(r.x,r.y,r.width,r.height);
                        bgShape.graphics.endFill();
                     }
                  }
                  else
                  {
                     r = record.rect;
                     r.x += line.x;
                     r.y += line.y;
                     TextFlowLine.constrainRectToColumn(textFlow,r,columnRect,0,0,constrainWidth,constrainHeight);
                     bgShape.graphics.beginFill(record.color,record.alpha);
                     bgShape.graphics.drawRect(r.x,r.y,r.width,r.height);
                     bgShape.graphics.endFill();
                  }
               }
            }
         }
      }
      
      public function removeLineFromCache(tl:TextLine) : void
      {
         delete this._lineDict[tl];
      }
      
      public function onUpdateComplete(controller:ContainerController) : void
      {
         var bgShape:Shape = null;
         var childIdx:int = 0;
         var tl:TextLine = null;
         var entry:Array = null;
         var r:Rectangle = null;
         var tfl:TextFlowLine = null;
         var i:int = 0;
         var record:Object = null;
         var numberLine:TextLine = null;
         var backgroundManager:BackgroundManager = null;
         var numberEntry:Array = null;
         var ii:int = 0;
         var numberRecord:Object = null;
         var container:Sprite = controller.container;
         if(container && container.numChildren)
         {
            bgShape = controller.getBackgroundShape();
            bgShape.graphics.clear();
            for(childIdx = 0; childIdx < controller.textLines.length; childIdx++)
            {
               tl = controller.textLines[childIdx];
               entry = this._lineDict[tl];
               if(entry)
               {
                  tfl = tl.userData as TextFlowLine;
                  for(i = 0; i < entry.length; i++)
                  {
                     record = entry[i];
                     if(record.hasOwnProperty("numberLine"))
                     {
                        numberLine = record.numberLine;
                        backgroundManager = TextFlowLine.getNumberLineBackground(numberLine);
                        numberEntry = backgroundManager._lineDict[numberLine];
                        for(ii = 0; ii < numberEntry.length; ii++)
                        {
                           numberRecord = numberEntry[ii];
                           r = numberRecord.rect.clone();
                           r.x += numberLine.x;
                           r.y += numberLine.y;
                           tfl.convertLineRectToContainer(r,true);
                           bgShape.graphics.beginFill(numberRecord.color,numberRecord.alpha);
                           bgShape.graphics.drawRect(r.x,r.y,r.width,r.height);
                           bgShape.graphics.endFill();
                        }
                     }
                     else
                     {
                        r = record.rect.clone();
                        tfl.convertLineRectToContainer(r,true);
                        bgShape.graphics.beginFill(record.color,record.alpha);
                        bgShape.graphics.drawRect(r.x,r.y,r.width,r.height);
                        bgShape.graphics.endFill();
                     }
                  }
               }
            }
         }
      }
   }
}
