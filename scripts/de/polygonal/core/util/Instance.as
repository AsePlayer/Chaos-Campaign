package de.polygonal.core.util
{
   import flash.Boot;
   
   public class Instance
   {
       
      
      public function Instance()
      {
      }
      
      public static function create(C:Class, args:Array = undefined) : Object
      {
         if(args == null)
         {
            return new C();
         }
         switch(int(args.length))
         {
            case 0:
               break;
            case 1:
               break;
            case 2:
               break;
            case 3:
               break;
            case 4:
               break;
            case 5:
               break;
            case 6:
               break;
            case 7:
               break;
            case 8:
               break;
            case 9:
               break;
            case 10:
               break;
            case 11:
               break;
            case 12:
               break;
            case 13:
               break;
            case 14:
               break;
            default:
               Boot.lastError = new Error();
               new C();
               new C(args[0]);
               new C(args[0],args[1]);
               new C(args[0],args[1],args[2]);
               new C(args[0],args[1],args[2],args[3]);
               new C(args[0],args[1],args[2],args[3],args[4]);
               new C(args[0],args[1],args[2],args[3],args[4],args[5]);
               new C(args[0],args[1],args[2],args[3],args[4],args[5],args[6]);
               new C(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7]);
               new C(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8]);
               new C(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9]);
               new C(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10]);
               new C(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10],args[11]);
               new C(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10],args[11],args[12]);
               new C(args[0],args[1],args[2],args[3],args[4],args[5],args[6],args[7],args[8],args[9],args[10],args[11],args[12],args[13]);
               throw "too many arguments";
         }
         return §§pop();
      }
      
      public static function createEmpty(C:Class) : Object
      {
         var _loc3_:* = null as Object;
         var _loc4_:* = null;
         try
         {
            Boot.skip_constructor = true;
            _loc3_ = new C();
            Boot.skip_constructor = false;
            return _loc3_;
         }
         catch(_loc_e_:*)
         {
            Boot.skip_constructor = false;
            Boot.lastError = new Error();
            throw _loc4_;
         }
      }
   }
}
