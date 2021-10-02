package as3reflect
{
   import as3reflect.errors.ClassNotFoundError;
   import flash.system.ApplicationDomain;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getQualifiedSuperclassName;
   
   public class ClassUtils
   {
      
      private static const PACKAGE_CLASS_SEPARATOR:String = "::";
       
      
      public function ClassUtils()
      {
         super();
      }
      
      public static function getName(clazz:Class) : String
      {
         return getNameFromFullyQualifiedName(getFullyQualifiedName(clazz));
      }
      
      public static function getImplementedInterfaces(clazz:Class) : Array
      {
         var result:Array = getFullyQualifiedImplementedInterfaceNames(clazz);
         for(var i:int = 0; i < result.length; i++)
         {
            result[i] = getDefinitionByName(result[i]);
         }
         return result;
      }
      
      public static function getNameFromFullyQualifiedName(fullyQualifiedName:String) : String
      {
         var result:String = "";
         var startIndex:int = fullyQualifiedName.indexOf(PACKAGE_CLASS_SEPARATOR);
         if(startIndex == -1)
         {
            result = fullyQualifiedName;
         }
         else
         {
            result = fullyQualifiedName.substring(startIndex + PACKAGE_CLASS_SEPARATOR.length,fullyQualifiedName.length);
         }
         return result;
      }
      
      public static function getFullyQualifiedImplementedInterfaceNames(clazz:Class, replaceColons:Boolean = false) : Array
      {
         var numInterfaces:int = 0;
         var i:int = 0;
         var fullyQualifiedInterfaceName:String = null;
         var result:Array = [];
         var classDescription:XML = MetadataUtils.getFromObject(clazz);
         var interfacesDescription:XMLList = classDescription.factory.implementsInterface;
         if(interfacesDescription)
         {
            numInterfaces = interfacesDescription.length();
            for(i = 0; i < numInterfaces; i++)
            {
               fullyQualifiedInterfaceName = interfacesDescription[i].@type.toString();
               if(replaceColons)
               {
                  fullyQualifiedInterfaceName = convertFullyQualifiedName(fullyQualifiedInterfaceName);
               }
               result.push(fullyQualifiedInterfaceName);
            }
         }
         return result;
      }
      
      public static function isImplementationOf(clazz:Class, interfaze:Class) : Boolean
      {
         var result:Boolean = false;
         var classDescription:XML = null;
         if(clazz == null)
         {
            result = false;
         }
         else
         {
            classDescription = MetadataUtils.getFromObject(clazz);
            result = classDescription.factory.implementsInterface.(@type == getQualifiedClassName(interfaze)).length() != 0;
         }
         return result;
      }
      
      public static function forInstance(instance:*, applicationDomain:ApplicationDomain = null) : Class
      {
         var className:String = getQualifiedClassName(instance);
         return forName(className,applicationDomain);
      }
      
      public static function getFullyQualifiedSuperClassName(clazz:Class, replaceColons:Boolean = false) : String
      {
         var result:String = getQualifiedSuperclassName(clazz);
         if(replaceColons)
         {
            result = convertFullyQualifiedName(result);
         }
         return result;
      }
      
      public static function getFullyQualifiedName(clazz:Class, replaceColons:Boolean = false) : String
      {
         var result:String = getQualifiedClassName(clazz);
         if(replaceColons)
         {
            result = convertFullyQualifiedName(result);
         }
         return result;
      }
      
      public static function forName(name:String, applicationDomain:ApplicationDomain = null) : Class
      {
         var result:Class = null;
         if(!applicationDomain)
         {
            var applicationDomain:ApplicationDomain = ApplicationDomain.currentDomain;
         }
         while(!applicationDomain.hasDefinition(name))
         {
            if(!applicationDomain.parentDomain)
            {
               break;
            }
            applicationDomain = applicationDomain.parentDomain;
         }
         try
         {
            result = applicationDomain.getDefinition(name) as Class;
         }
         catch(e:ReferenceError)
         {
            throw new ClassNotFoundError("A class with the name \'" + name + "\' could not be found.");
         }
         return result;
      }
      
      public static function newInstance(clazz:Class, args:Array = null) : *
      {
         var result:* = undefined;
         var a:Array = args == null ? [] : args;
         switch(a.length)
         {
            case 1:
               result = new clazz(a[0]);
               break;
            case 2:
               result = new clazz(a[0],a[1]);
               break;
            case 3:
               result = new clazz(a[0],a[1],a[2]);
               break;
            case 4:
               result = new clazz(a[0],a[1],a[2],a[3]);
               break;
            case 5:
               result = new clazz(a[0],a[1],a[2],a[3],a[4]);
               break;
            case 6:
               result = new clazz(a[0],a[1],a[2],a[3],a[4],a[5]);
               break;
            case 7:
               result = new clazz(a[0],a[1],a[2],a[3],a[4],a[5],a[6]);
               break;
            case 8:
               result = new clazz(a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7]);
               break;
            case 9:
               result = new clazz(a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8]);
               break;
            case 10:
               result = new clazz(a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9]);
               break;
            default:
               result = new clazz();
         }
         return result;
      }
      
      public static function convertFullyQualifiedName(className:String) : String
      {
         return className.replace(PACKAGE_CLASS_SEPARATOR,".");
      }
      
      public static function isSubclassOf(clazz:Class, parentClass:Class) : Boolean
      {
         var classDescription:XML = MetadataUtils.getFromObject(clazz);
         var parentName:String = getQualifiedClassName(parentClass);
         return classDescription.factory.extendsClass.(@type == parentName).length() != 0;
      }
      
      public static function getSuperClass(clazz:Class) : Class
      {
         var result:Class = null;
         var classDescription:XML = MetadataUtils.getFromObject(clazz);
         var superClasses:XMLList = classDescription.factory.extendsClass;
         if(superClasses.length() > 0)
         {
            result = ClassUtils.forName(superClasses[0].@type);
         }
         return result;
      }
      
      public static function getImplementedInterfaceNames(clazz:Class) : Array
      {
         var result:Array = getFullyQualifiedImplementedInterfaceNames(clazz);
         for(var i:int = 0; i < result.length; i++)
         {
            result[i] = getNameFromFullyQualifiedName(result[i]);
         }
         return result;
      }
      
      public static function getSuperClassName(clazz:Class) : String
      {
         var fullyQualifiedName:String = getFullyQualifiedSuperClassName(clazz);
         var index:int = fullyQualifiedName.indexOf(PACKAGE_CLASS_SEPARATOR) + PACKAGE_CLASS_SEPARATOR.length;
         return fullyQualifiedName.substring(index,fullyQualifiedName.length);
      }
   }
}
