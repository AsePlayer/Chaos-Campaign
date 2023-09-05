package com.brockw.stickwar.engine.Ai.command
{
     import com.brockw.stickwar.engine.StickWar;
     import flash.utils.Dictionary;
     
     public class CommandFactory
     {
           
          
          private var commandMap:Dictionary;
          
          public function CommandFactory(game:StickWar)
          {
               super();
               this.commandMap = new Dictionary();
               this.commandMap[UnitCommand.MOVE] = MoveCommand;
               this.commandMap[UnitCommand.ATTACK_MOVE] = AttackMoveCommand;
               this.commandMap[UnitCommand.STAND] = StandCommand;
               this.commandMap[UnitCommand.HOLD] = HoldCommand;
               this.commandMap[UnitCommand.GARRISON] = GarrisonCommand;
               this.commandMap[UnitCommand.UNGARRISON] = UnGarrisonCommand;
               this.commandMap[UnitCommand.SWORDWRATH_RAGE] = SwordwrathRageCommand;
               this.commandMap[UnitCommand.STUN] = StunCommand;
               this.commandMap[UnitCommand.NUKE] = NukeCommand;
               this.commandMap[UnitCommand.STEALTH] = StealthCommand;
               this.commandMap[UnitCommand.HEAL] = HealCommand;
               this.commandMap[UnitCommand.CURE] = CureCommand;
               this.commandMap[UnitCommand.POISON_DART] = PoisonDartCommand;
               this.commandMap[UnitCommand.SLOW_DART] = SlowDartCommand;
               this.commandMap[UnitCommand.TECH] = TechCommand;
               this.commandMap[UnitCommand.SPEARTON_BLOCK] = BlockCommand;
               this.commandMap[UnitCommand.ARCHER_FIRE] = ArcherFireCommand;
               this.commandMap[UnitCommand.FIST_ATTACK] = FistAttackCommand;
               this.commandMap[UnitCommand.REAPER] = ReaperCommand;
               this.commandMap[UnitCommand.WINGIDON_SPEED] = WingidonSpeedCommand;
               this.commandMap[UnitCommand.SHIELD_BASH] = SpeartonShieldBashCommand;
               this.commandMap[UnitCommand.KNIGHT_CHARGE] = ChargeCommand;
               this.commandMap[UnitCommand.CAT_FURY] = CatFuryCommand;
               this.commandMap[UnitCommand.CAT_PACK] = CatPackCommand;
               this.commandMap[UnitCommand.DEAD_POISON] = DeadPoisonCommand;
               this.commandMap[UnitCommand.NINJA_STACK] = NinjaStackCommand;
               this.commandMap[UnitCommand.STONE] = StoneCommand;
               this.commandMap[UnitCommand.POISON_POOL] = PoisonPoolCommand;
               this.commandMap[UnitCommand.CONSTRUCT_TOWER] = ConstructTowerCommand;
               this.commandMap[UnitCommand.CONSTRUCT_WALL] = ConstructWallCommand;
               this.commandMap[UnitCommand.BOMBER_DETONATE] = BomberDetonateCommand;
               this.commandMap[UnitCommand.REMOVE_WALL_COMMAND] = RemoveWallCommand;
               this.commandMap[UnitCommand.REMOVE_TOWER_COMMAND] = RemoveTowerCommand;
          }
          
          public function createCommand(game:StickWar, type:int, goalX:int, goalY:int, arg0:int, arg1:int, arg2:int, arg3:int, arg4:int, isGroup:Boolean = true) : UnitCommand
          {
               var command:UnitCommand = null;
               if(!(type in this.commandMap))
               {
                    return null;
               }
               var c:Class = this.commandMap[type];
               command = new c(game);
               command.team = game.team;
               command.goalX = goalX;
               command.goalY = goalY;
               command.realX = arg0;
               command.realY = arg1;
               command.targetId = arg4;
               command.isGroup = isGroup;
               if(command == null)
               {
                    throw new Error("Null command error: " + type);
               }
               return command;
          }
     }
}
