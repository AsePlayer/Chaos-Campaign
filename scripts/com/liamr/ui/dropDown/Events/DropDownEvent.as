package com.liamr.ui.dropDown.Events
{
     import flash.events.Event;
     
     public class DropDownEvent extends Event
     {
           
          
          public var selectedId:int;
          
          public var selectedLabel:String;
          
          public var selectedData;
          
          public function DropDownEvent(type:String, _selectedId:int, _selectedLabel:String, _selectedData:*, bubbles:Boolean = false, cancelable:Boolean = false)
          {
               super(type,bubbles,cancelable);
               this.selectedId = _selectedId;
               this.selectedLabel = _selectedLabel;
               this.selectedData = _selectedData;
          }
     }
}
