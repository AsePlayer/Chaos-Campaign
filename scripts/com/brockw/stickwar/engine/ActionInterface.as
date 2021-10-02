package com.brockw.stickwar.engine
{
   import com.brockw.stickwar.GameScreen;
   import com.brockw.stickwar.engine.Ai.command.ArcherFireCommand;
   import com.brockw.stickwar.engine.Ai.command.AttackMoveCommand;
   import com.brockw.stickwar.engine.Ai.command.BlockCommand;
   import com.brockw.stickwar.engine.Ai.command.BomberDetonateCommand;
   import com.brockw.stickwar.engine.Ai.command.CatFuryCommand;
   import com.brockw.stickwar.engine.Ai.command.CatPackCommand;
   import com.brockw.stickwar.engine.Ai.command.ChargeCommand;
   import com.brockw.stickwar.engine.Ai.command.ConstructTowerCommand;
   import com.brockw.stickwar.engine.Ai.command.ConstructWallCommand;
   import com.brockw.stickwar.engine.Ai.command.CureCommand;
   import com.brockw.stickwar.engine.Ai.command.DeadPoisonCommand;
   import com.brockw.stickwar.engine.Ai.command.FistAttackCommand;
   import com.brockw.stickwar.engine.Ai.command.GarrisonCommand;
   import com.brockw.stickwar.engine.Ai.command.HealCommand;
   import com.brockw.stickwar.engine.Ai.command.HoldCommand;
   import com.brockw.stickwar.engine.Ai.command.MoveCommand;
   import com.brockw.stickwar.engine.Ai.command.NinjaStackCommand;
   import com.brockw.stickwar.engine.Ai.command.NukeCommand;
   import com.brockw.stickwar.engine.Ai.command.PoisonDartCommand;
   import com.brockw.stickwar.engine.Ai.command.PoisonPoolCommand;
   import com.brockw.stickwar.engine.Ai.command.ReaperCommand;
   import com.brockw.stickwar.engine.Ai.command.RemoveTowerCommand;
   import com.brockw.stickwar.engine.Ai.command.RemoveWallCommand;
   import com.brockw.stickwar.engine.Ai.command.SlowDartCommand;
   import com.brockw.stickwar.engine.Ai.command.SpeartonShieldBashCommand;
   import com.brockw.stickwar.engine.Ai.command.StandCommand;
   import com.brockw.stickwar.engine.Ai.command.StealthCommand;
   import com.brockw.stickwar.engine.Ai.command.StoneCommand;
   import com.brockw.stickwar.engine.Ai.command.StunCommand;
   import com.brockw.stickwar.engine.Ai.command.SwordwrathRageCommand;
   import com.brockw.stickwar.engine.Ai.command.TechCommand;
   import com.brockw.stickwar.engine.Ai.command.UnGarrisonCommand;
   import com.brockw.stickwar.engine.Ai.command.UnitCommand;
   import com.brockw.stickwar.engine.Ai.command.WingidonSpeedCommand;
   import com.brockw.stickwar.engine.Team.Team;
   import com.brockw.stickwar.engine.Team.TechItem;
   import com.brockw.stickwar.engine.units.Unit;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.ui.Mouse;
   import flash.utils.Dictionary;
   
   public class ActionInterface extends Sprite
   {
      
      private static const BOX_WIDTH:Number = 70;
      
      private static const BOX_HEIGHT:Number = 32.9;
      
      public static const ROWS:Number = 3;
      
      public static const COLS:Number = 3;
      
      private static const START_X:Number = 637.9;
      
      private static const START_Y:Number = 598.15;
      
      private static const SPACING:Number = 0;
       
      
      private var boxes:Array;
      
      private var currentActions:Array;
      
      private var actions:Dictionary;
      
      private var actionsToButtonMap:Dictionary;
      
      private var _currentMove:UnitCommand;
      
      private var _currentEntity:Entity;
      
      private var _currentCursor:MovieClip;
      
      protected var team:Team;
      
      private var _clicked:Boolean;
      
      private var _game:StickWar;
      
      public function ActionInterface(game:UserInterface)
      {
         super();
         this._game = game.gameScreen.game;
         this.setUpGrid(game);
         this.setUpActions();
         this._currentMove = null;
         this._currentEntity = null;
         this._currentCursor = null;
         this.clicked = false;
         this.team = game.team;
      }
      
      public function refresh() : void
      {
         var c:Sprite = Sprite(this._game.cursorSprite);
         if(this._currentMove)
         {
            this._currentMove.cleanUpPreClick(c);
         }
         this._currentMove = null;
         this._currentCursor = null;
         this.clicked = false;
         Mouse.show();
      }
      
      public function isInCommand() : Boolean
      {
         if(this.currentMove == null || (this._clicked == true || this.currentMove.type == UnitCommand.MOVE))
         {
            return false;
         }
         return true;
      }
      
      private function setUpGrid(game:UserInterface) : void
      {
         var s:MovieClip = null;
         var s2:Sprite = null;
         this.boxes = [];
         this.boxes.push(game.hud.hud.action1);
         this.boxes.push(game.hud.hud.action2);
         this.boxes.push(game.hud.hud.action3);
         this.boxes.push(game.hud.hud.action4);
         this.boxes.push(game.hud.hud.action5);
         this.boxes.push(game.hud.hud.action6);
         this.boxes.push(game.hud.hud.action7);
         this.boxes.push(game.hud.hud.action8);
         this.boxes.push(game.hud.hud.action9);
         var i:int = 0;
         while(i < this.boxes.length)
         {
            s = this.boxes[i];
            s.stop();
            s2 = new Sprite();
            s2.name = "overlay";
            s.visible = true;
            s.addChild(s2);
            game.hud.addChild(s);
            i++;
         }
      }
      
      public function drawCoolDown(box:MovieClip, fraction:Number) : void
      {
         var s:Sprite = null;
         s = Sprite(box.getChildByName("overlay"));
         var mc:DisplayObject = box.getChildByName("mc");
         box.removeChild(s);
         box.addChild(s);
         fraction = 1 - fraction;
         s.graphics.clear();
         var height:int = BOX_HEIGHT;
         var width:int = BOX_WIDTH;
         s.x = -width / 2;
         s.y = -height / 2;
         s.graphics.moveTo(0,height);
         s.graphics.beginFill(0,0.6);
         s.graphics.lineTo(width,height);
         s.graphics.lineTo(width,height * fraction);
         s.graphics.lineTo(0,height * fraction);
         s.graphics.lineTo(0,height);
      }
      
      public function drawToggle(box:MovieClip, enabled:Boolean) : void
      {
         var s:Sprite = null;
         s = Sprite(box.getChildByName("overlay"));
         var mc:DisplayObject = box.getChildByName("mc");
         box.removeChild(s);
         box.addChild(s);
         s.graphics.clear();
         var height:int = BOX_HEIGHT;
         var width:int = BOX_WIDTH;
         s.x = -width / 2;
         s.y = -height / 2;
         if(enabled)
         {
            s.graphics.beginFill(65280,0.8);
         }
         else
         {
            s.graphics.beginFill(16711680,0.8);
         }
         s.graphics.drawCircle(width * 0.75,height * 0.25,6);
      }
      
      public function updateActionAlpha(gameScreen:GameScreen) : void
      {
         var i:int = 0;
         if(this.currentEntity != null)
         {
            for(i = 0; i < this.currentActions.length; i++)
            {
               if(this.currentActions[i] < 0)
               {
                  if(this.team.tech.isResearching(this.currentActions[i]))
                  {
                     this.drawCoolDown(this.actionsToButtonMap[this.currentActions[i]],this.team.tech.getResearchCooldown(this.currentActions[i]));
                  }
                  else
                  {
                     this.drawCoolDown(this.actionsToButtonMap[this.currentActions[i]],0);
                  }
                  if(!this.team.tech.getTechAllowed(this.currentActions[i]))
                  {
                     MovieClip(this.actionsToButtonMap[this.currentActions[i]]).getChildByName("mc").alpha = 0.2;
                  }
                  else
                  {
                     MovieClip(this.actionsToButtonMap[this.currentActions[i]]).getChildByName("mc").alpha = 1;
                  }
               }
            }
         }
      }
      
      public function update(gameScreen:GameScreen) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Sprite = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:TechItem = null;
         var _loc10_:UnitCommand = null;
         var _loc11_:UnitCommand = null;
         for(_loc2_ = 0; _loc2_ < gameScreen.game.postCursors.length; _loc2_++)
         {
            _loc3_ = gameScreen.game.postCursors[_loc2_];
            if(_loc3_.currentFrame != _loc3_.totalFrames)
            {
               _loc3_.nextFrame();
            }
            else
            {
               _loc4_ = Sprite(gameScreen.game.cursorSprite);
               if(_loc4_.contains(_loc3_))
               {
                  _loc4_.removeChild(_loc3_);
               }
               gameScreen.game.postCursors.splice(_loc2_,1);
            }
         }
         if(gameScreen.userInterface.selectedUnits.hasChanged && this._currentMove != null)
         {
            this.refresh();
         }
         if(this.currentEntity != null)
         {
            for(_loc2_ = 0; _loc2_ < this.currentActions.length; _loc2_++)
            {
               if(this.currentActions[_loc2_] < 0)
               {
                  if(this.team.tech.isResearching(this.currentActions[_loc2_]))
                  {
                     this.drawCoolDown(this.actionsToButtonMap[this.currentActions[_loc2_]],this.team.tech.getResearchCooldown(this.currentActions[_loc2_]));
                  }
                  else
                  {
                     this.drawCoolDown(this.actionsToButtonMap[this.currentActions[_loc2_]],0);
                  }
                  if(!this.team.tech.getTechAllowed(this.currentActions[_loc2_]))
                  {
                     MovieClip(this.actionsToButtonMap[this.currentActions[_loc2_]]).getChildByName("mc").alpha = 0.2;
                  }
                  else
                  {
                     MovieClip(this.actionsToButtonMap[this.currentActions[_loc2_]]).getChildByName("mc").alpha = 1;
                  }
               }
               else
               {
                  if(UnitCommand(this.actions[this.currentActions[_loc2_]]).hasCoolDown)
                  {
                     if(gameScreen.userInterface.selectedUnits.unitTypes[this.currentEntity.type].length == 0)
                     {
                        continue;
                     }
                     _loc5_ = UnitCommand(this.actions[this.currentActions[_loc2_]]).coolDownTime(gameScreen.userInterface.selectedUnits.unitTypes[this.currentEntity.type][0]);
                     for(_loc6_ = 1; _loc6_ < gameScreen.userInterface.selectedUnits.unitTypes[this.currentEntity.type].length; _loc6_++)
                     {
                        _loc7_ = UnitCommand(this.actions[this.currentActions[_loc2_]]).coolDownTime(gameScreen.userInterface.selectedUnits.unitTypes[this.currentEntity.type][_loc6_]);
                        if(_loc7_ < _loc5_)
                        {
                           _loc5_ = _loc7_;
                        }
                     }
                     this.drawCoolDown(this.actionsToButtonMap[this.currentActions[_loc2_]],_loc5_);
                  }
                  if(UnitCommand(this.actions[this.currentActions[_loc2_]]).isToggle)
                  {
                     this.drawToggle(this.actionsToButtonMap[this.currentActions[_loc2_]],UnitCommand(this.actions[this.currentActions[_loc2_]]).isToggled(this.currentEntity));
                  }
                  else if(!UnitCommand(this.actions[this.currentActions[_loc2_]]).hasCoolDown)
                  {
                     _loc4_ = Sprite(this.actionsToButtonMap[this.currentActions[_loc2_]].getChildByName("overlay"));
                     _loc4_.graphics.clear();
                  }
               }
            }
         }
         if(this._currentMove != null && !this.clicked)
         {
            if(this._currentMove.type in this.actionsToButtonMap)
            {
               MovieClip(this.actionsToButtonMap[this._currentMove.type]).alpha = 0.2;
            }
            if(gameScreen.userInterface.mouseState.mouseDown && this.stage.mouseY <= 700 - 75)
            {
               if(this._currentMove.type != UnitCommand.MOVE && gameScreen.userInterface.mouseState.isRightClick == true)
               {
                  this.refresh();
                  gameScreen.userInterface.mouseState.mouseDown = false;
                  gameScreen.userInterface.mouseState.isRightClick = false;
               }
               else if(!(this._currentMove.type == UnitCommand.MOVE && gameScreen.userInterface.mouseState.isRightClick != true && this.stage.mouseY > 700 - 125))
               {
                  if(!(gameScreen.userInterface.mouseState.isRightClick == false && gameScreen.userInterface.keyBoardState.isShift))
                  {
                     gameScreen.userInterface.mouseState.mouseDown = false;
                     gameScreen.userInterface.mouseState.oldMouseDown = false;
                     gameScreen.userInterface.mouseState.clicked = false;
                     Mouse.show();
                     this._currentMove.team = gameScreen.team;
                     if(gameScreen.game.mouseOverUnit != null)
                     {
                        if(gameScreen.game.mouseOverUnit is Unit)
                        {
                           if(!Unit(gameScreen.game.mouseOverUnit).isTargetable())
                           {
                              this._currentMove.targetId = -1;
                           }
                           else
                           {
                              this._currentMove.targetId = gameScreen.game.mouseOverUnit.id;
                           }
                        }
                        else
                        {
                           this._currentMove.targetId = gameScreen.game.mouseOverUnit.id;
                        }
                     }
                     else
                     {
                        this._currentMove.targetId = -1;
                     }
                     this.clicked = true;
                     if(this.currentMove.mayCast(gameScreen,gameScreen.team))
                     {
                        this._currentMove.prepareNetworkedMove(gameScreen);
                     }
                     else
                     {
                        gameScreen.userInterface.helpMessage.showMessage(this._currentMove.unableToCastMessage());
                     }
                  }
               }
            }
         }
         if(this._currentMove == null || this._currentMove != null && !this.clicked || this._currentMove == UnitCommand(this.actions[UnitCommand.MOVE]) || this.clicked)
         {
            for(_loc8_ = 0; _loc8_ < this.currentActions.length; _loc8_++)
            {
               if(this.currentActions[_loc8_] < 0)
               {
                  _loc9_ = this.team.tech.upgrades[this.currentActions[_loc8_]];
                  if(MovieClip(this.actionsToButtonMap[this.currentActions[_loc8_]]).hitTestPoint(gameScreen.stage.mouseX,gameScreen.stage.mouseY,true))
                  {
                     gameScreen.game.team.updateButtonOver(gameScreen.game,_loc9_.name,_loc9_.tip,_loc9_.researchTime,_loc9_.cost,_loc9_.mana,0);
                  }
                  if(gameScreen.userInterface.keyBoardState.isDownForAction(_loc9_.hotKey) || gameScreen.userInterface.mouseState.clicked && MovieClip(this.actionsToButtonMap[this.currentActions[_loc8_]]).hitTestPoint(gameScreen.stage.mouseX,gameScreen.stage.mouseY,false))
                  {
                     MovieClip(this.actionsToButtonMap[this.currentActions[_loc8_]]).alpha = 0.2;
                     _loc10_ = new TechCommand(gameScreen.game);
                     _loc10_.goalX = this.currentActions[_loc8_];
                     _loc10_.goalY = this.team.id;
                     _loc10_.team = this.team;
                     _loc10_.prepareNetworkedMove(gameScreen);
                  }
                  else
                  {
                     MovieClip(this.actionsToButtonMap[this.currentActions[_loc8_]]).alpha = 1;
                  }
               }
               else
               {
                  if(MovieClip(this.actionsToButtonMap[this.currentActions[_loc8_]]).hitTestPoint(gameScreen.stage.mouseX,gameScreen.stage.mouseY,false))
                  {
                     gameScreen.game.team.updateButtonOverXML(gameScreen.game,UnitCommand(this.actions[this.currentActions[_loc8_]]).xmlInfo);
                  }
                  if(UnitCommand(this.actions[this.currentActions[_loc8_]]).isActivatable)
                  {
                     _loc11_ = UnitCommand(this.actions[this.currentActions[_loc8_]]);
                     if(gameScreen.userInterface.keyBoardState.isDownForAction(UnitCommand(this.actions[this.currentActions[_loc8_]]).hotKey) || gameScreen.userInterface.mouseState.clicked && MovieClip(this.actionsToButtonMap[this.currentActions[_loc8_]]).hitTestPoint(gameScreen.stage.mouseX,gameScreen.stage.mouseY,false))
                     {
                        gameScreen.userInterface.mouseState.clicked = false;
                        _loc5_ = _loc11_.coolDownTime(gameScreen.userInterface.selectedUnits.unitTypes[this.currentEntity.type][0]);
                        for(_loc6_ = 1; _loc6_ < gameScreen.userInterface.selectedUnits.unitTypes[this.currentEntity.type].length; _loc6_++)
                        {
                           _loc7_ = _loc11_.coolDownTime(gameScreen.userInterface.selectedUnits.unitTypes[this.currentEntity.type][_loc6_]);
                           if(_loc7_ < _loc5_)
                           {
                              _loc5_ = _loc7_;
                           }
                        }
                        if(_loc11_.getGoldRequired() > this.team.gold)
                        {
                           gameScreen.userInterface.helpMessage.showMessage("Not enough gold to cast ");
                        }
                        else if(_loc11_.getManaRequired() > this.team.mana)
                        {
                           gameScreen.userInterface.helpMessage.showMessage("Not enough mana to cast ");
                        }
                        else if(_loc5_ != 0)
                        {
                           gameScreen.userInterface.helpMessage.showMessage("Ability is on cooldown");
                        }
                        else if(!UnitCommand(this.actions[this.currentActions[_loc8_]]).requiresMouseInput)
                        {
                           UnitCommand(this.actions[this.currentActions[_loc8_]]).prepareNetworkedMove(gameScreen);
                           if(this.actionsToButtonMap[this.currentActions[_loc8_]] != null)
                           {
                              MovieClip(this.actionsToButtonMap[this.currentActions[_loc8_]]).alpha = 0.2;
                           }
                        }
                        else
                        {
                           this.refresh();
                           this._currentMove = UnitCommand(this.actions[this.currentActions[_loc8_]]);
                           Mouse.hide();
                           this.clicked = false;
                        }
                     }
                     else
                     {
                        MovieClip(this.actionsToButtonMap[this.currentActions[_loc8_]]).alpha = 1;
                     }
                  }
               }
            }
         }
         if(this._currentMove != null)
         {
            if(this.clicked)
            {
               if(this._currentMove)
               {
                  this._currentMove.cleanUpPreClick(Sprite(gameScreen.game.cursorSprite));
               }
               if(this._currentMove.drawCursorPostClick(Sprite(gameScreen.game.cursorSprite),gameScreen))
               {
                  this._currentMove = null;
               }
            }
            else
            {
               this._currentMove.drawCursorPreClick(Sprite(gameScreen.game.cursorSprite),gameScreen);
            }
         }
         if(gameScreen.userInterface.selectedUnits.hasFinishedSelecting && this._currentMove == null && gameScreen.userInterface.selectedUnits.interactsWith != 0 && gameScreen.userInterface.selectedUnits.interactsWith != Unit.I_IS_BUILDING)
         {
            this._currentMove = UnitCommand(this.actions[UnitCommand.MOVE]);
            Mouse.hide();
            this.clicked = false;
         }
      }
      
      public function clear() : void
      {
         var key:* = null;
         var x:int = 0;
         var s:Sprite = null;
         var c:DisplayObject = null;
         for(var y:int = 0; y < COLS; y++)
         {
            for(x = 0; x < ROWS; x++)
            {
               s = Sprite(MovieClip(this.boxes[y * COLS + x]).getChildByName("overlay"));
               s.graphics.clear();
               MovieClip(this.boxes[y * COLS + x]).alpha = 1;
               c = MovieClip(this.boxes[y * COLS + x]).getChildByName("mc");
               if(c != null)
               {
                  MovieClip(this.boxes[y * COLS + x]).removeChild(c);
               }
            }
         }
         for(key in this.actionsToButtonMap)
         {
            delete this.actionsToButtonMap[key];
         }
         this.currentActions.splice(0,this.currentActions.length);
      }
      
      public function setEntity(entity:Entity) : void
      {
         if(entity == null)
         {
            this.currentEntity = entity;
            this.clear();
         }
         else
         {
            entity.setActionInterface(this);
            this.currentEntity = entity;
         }
      }
      
      public function setAction(x:int, y:int, type:int) : void
      {
         var _loc6_:TechItem = null;
         var _loc7_:Bitmap = null;
         if(type < 0)
         {
            if(type in this.team.tech.upgrades)
            {
               _loc6_ = this.team.tech.upgrades[type];
               MovieClip(this.boxes[y * COLS + x]).visible = true;
               _loc7_ = _loc6_.mc;
               _loc7_.x = -_loc7_.width / 2;
               _loc7_.y = -_loc7_.height / 2;
               _loc7_.name = "mc";
               MovieClip(this.boxes[y * COLS + x]).addChild(_loc7_);
               this.actionsToButtonMap[type] = MovieClip(this.boxes[y * COLS + x]);
               this.currentActions.push(type);
            }
         }
         else if(type == UnitCommand.NO_COMMAND)
         {
            MovieClip(this.boxes[y * COLS + x]).visible = true;
         }
         else
         {
            MovieClip(this.boxes[y * COLS + x]).visible = true;
            _loc7_ = UnitCommand(this.actions[type]).buttonBitmap;
            _loc7_.x = -_loc7_.width / 2;
            _loc7_.y = -_loc7_.height / 2;
            _loc7_.name = "mc";
            MovieClip(this.boxes[y * COLS + x]).addChild(_loc7_);
            this.actionsToButtonMap[type] = MovieClip(this.boxes[y * COLS + x]);
            this.currentActions.push(type);
         }
         var _loc4_:Sprite = Sprite(MovieClip(this.boxes[y * COLS + x]).getChildByName("overlay"));
         var _loc5_:DisplayObject = MovieClip(this.boxes[y * COLS + x]).getChildByName("mc");
         MovieClip(this.boxes[y * COLS + x]).removeChild(_loc4_);
         MovieClip(this.boxes[y * COLS + x]).addChild(_loc4_);
      }
      
      private function setUpActions() : void
      {
         this.actionsToButtonMap = new Dictionary();
         this.currentActions = [];
         this.actions = new Dictionary();
         this.actions[new AttackMoveCommand(this._game).type] = new AttackMoveCommand(this._game);
         this.actions[new MoveCommand(this._game).type] = new MoveCommand(this._game);
         this.actions[new StandCommand(this._game).type] = new StandCommand(this._game);
         this.actions[new HoldCommand(this._game).type] = new HoldCommand(this._game);
         this.actions[new GarrisonCommand(this._game).type] = new GarrisonCommand(this._game);
         this.actions[new UnGarrisonCommand(this._game).type] = new UnGarrisonCommand(this._game);
         this.actions[new SwordwrathRageCommand(this._game).type] = new SwordwrathRageCommand(this._game);
         this.actions[new NukeCommand(this._game).type] = new NukeCommand(this._game);
         this.actions[new StunCommand(this._game).type] = new StunCommand(this._game);
         this.actions[new StealthCommand(this._game).type] = new StealthCommand(this._game);
         this.actions[new HealCommand(this._game).type] = new HealCommand(this._game);
         this.actions[new CureCommand(this._game).type] = new CureCommand(this._game);
         this.actions[new PoisonDartCommand(this._game).type] = new PoisonDartCommand(this._game);
         this.actions[new SlowDartCommand(this._game).type] = new SlowDartCommand(this._game);
         this.actions[new ArcherFireCommand(this._game).type] = new ArcherFireCommand(this._game);
         this.actions[new BlockCommand(this._game).type] = new BlockCommand(this._game);
         this.actions[new FistAttackCommand(this._game).type] = new FistAttackCommand(this._game);
         this.actions[new ReaperCommand(this._game).type] = new ReaperCommand(this._game);
         this.actions[new WingidonSpeedCommand(this._game).type] = new WingidonSpeedCommand(this._game);
         this.actions[new SpeartonShieldBashCommand(this._game).type] = new SpeartonShieldBashCommand(this._game);
         this.actions[new ChargeCommand(this._game).type] = new ChargeCommand(this._game);
         this.actions[new CatPackCommand(this._game).type] = new CatPackCommand(this._game);
         this.actions[new CatFuryCommand(this._game).type] = new CatFuryCommand(this._game);
         this.actions[new DeadPoisonCommand(this._game).type] = new DeadPoisonCommand(this._game);
         this.actions[new NinjaStackCommand(this._game).type] = new NinjaStackCommand(this._game);
         this.actions[new StoneCommand(this._game).type] = new StoneCommand(this._game);
         this.actions[new PoisonPoolCommand(this._game).type] = new PoisonPoolCommand(this._game);
         this.actions[new ConstructTowerCommand(this._game).type] = new ConstructTowerCommand(this._game);
         this.actions[new ConstructWallCommand(this._game).type] = new ConstructWallCommand(this._game);
         this.actions[new BomberDetonateCommand(this._game).type] = new BomberDetonateCommand(this._game);
         this.actions[new RemoveWallCommand(this._game).type] = new RemoveWallCommand(this._game);
         this.actions[new RemoveTowerCommand(this._game).type] = new RemoveTowerCommand(this._game);
      }
      
      public function get currentMove() : UnitCommand
      {
         return this._currentMove;
      }
      
      public function set currentMove(value:UnitCommand) : void
      {
         this._currentMove = value;
      }
      
      public function get currentEntity() : Entity
      {
         return this._currentEntity;
      }
      
      public function set currentEntity(value:Entity) : void
      {
         this._currentEntity = value;
      }
      
      public function get clicked() : Boolean
      {
         return this._clicked;
      }
      
      public function set clicked(value:Boolean) : void
      {
         this._clicked = value;
      }
   }
}
