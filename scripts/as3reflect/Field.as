package as3reflect
{
   public class Field extends AbstractMember
   {
       
      
      public function Field(name:String, type:Type, declaringType:Type, isStatic:Boolean, metaData:Array = null)
      {
         super(name,type,declaringType,isStatic,metaData);
      }
      
      public function getValue(target:* = null) : *
      {
         if(!target)
         {
            target = declaringType.clazz;
         }
         return target[name];
      }
   }
}
