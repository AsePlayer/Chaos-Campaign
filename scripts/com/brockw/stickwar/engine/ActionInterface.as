package com.brockw.stickwar.engine
{
     import com.brockw.stickwar.GameScreen;
     import com.brockw.stickwar.engine.Ai.command.*;
     import com.brockw.stickwar.engine.Team.Team;
     import com.brockw.stickwar.engine.Team.TechItem;
     import com.brockw.stickwar.engine.units.Unit;
     import flash.display.*;
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
          
          private var _currentEntity:com.brockw.stickwar.engine.Entity;
          
          private var _currentCursor:MovieClip;
          
          protected var team:Team;
          
          private var _clicked:Boolean;
          
          private var _game:com.brockw.stickwar.engine.StickWar;
          
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
               if(Boolean(this._currentMove))
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
               var i:int = 0;
               var m:MovieClip = null;
               var s:Sprite = null;
               var min:Number = NaN;
               var j:int = 0;
               var v:Number = NaN;
               var action:int = 0;
               var t:TechItem = null;
               var c:UnitCommand = null;
               var candidate:UnitCommand = null;
               for(i = 0; i < gameScreen.game.postCursors.length; i++)
               {
                    m = gameScreen.game.postCursors[i];
                    if(m.currentFrame != m.totalFrames)
                    {
                         m.nextFrame();
                    }
                    else
                    {
                         s = Sprite(gameScreen.game.cursorSprite);
                         if(s.contains(m))
                         {
                              s.removeChild(m);
                         }
                         gameScreen.game.postCursors.splice(i,1);
                    }
               }
               if(gameScreen.userInterface.selectedUnits.hasChanged && this._currentMove != null)
               {
                    this.refresh();
               }
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
                         else
                         {
                              if(UnitCommand(this.actions[this.currentActions[i]]).hasCoolDown)
                              {
                                   if(gameScreen.userInterface.selectedUnits.unitTypes[this.currentEntity.type].length == 0)
                                   {
                                        continue;
                                   }
                                   min = UnitCommand(this.actions[this.currentActions[i]]).coolDownTime(gameScreen.userInterface.selectedUnits.unitTypes[this.currentEntity.type][0]);
                                   for(j = 1; j < gameScreen.userInterface.selectedUnits.unitTypes[this.currentEntity.type].length; j++)
                                   {
                                        v = UnitCommand(this.actions[this.currentActions[i]]).coolDownTime(gameScreen.userInterface.selectedUnits.unitTypes[this.currentEntity.type][j]);
                                        if(v < min)
                                        {
                                             min = v;
                                        }
                                   }
                                   this.drawCoolDown(this.actionsToButtonMap[this.currentActions[i]],min);
                              }
                              if(UnitCommand(this.actions[this.currentActions[i]]).isToggle)
                              {
                                   this.drawToggle(this.actionsToButtonMap[this.currentActions[i]],UnitCommand(this.actions[this.currentActions[i]]).isToggled(this.currentEntity));
                              }
                              else if(!UnitCommand(this.actions[this.currentActions[i]]).hasCoolDown)
                              {
                                   s = Sprite(this.actionsToButtonMap[this.currentActions[i]].getChildByName("overlay"));
                                   s.graphics.clear();
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
                    for(action = 0; action < this.currentActions.length; action++)
                    {
                         if(this.currentActions[action] < 0)
                         {
                              t = this.team.tech.upgrades[this.currentActions[action]];
                              if(MovieClip(this.actionsToButtonMap[this.currentActions[action]]).hitTestPoint(gameScreen.stage.mouseX,gameScreen.stage.mouseY,true))
                              {
                                   gameScreen.game.team.updateButtonOver(gameScreen.game,t.name,t.tip,t.researchTime,t.cost,t.mana,0);
                              }
                              if(gameScreen.userInterface.keyBoardState.isDownForAction(t.hotKey) || gameScreen.userInterface.mouseState.clicked && MovieClip(this.actionsToButtonMap[this.currentActions[action]]).hitTestPoint(gameScreen.stage.mouseX,gameScreen.stage.mouseY,false))
                              {
                                   MovieClip(this.actionsToButtonMap[this.currentActions[action]]).alpha = 0.2;
                                   c = new TechCommand(gameScreen.game);
                                   c.goalX = this.currentActions[action];
                                   c.goalY = this.team.id;
                                   c.team = this.team;
                                   c.prepareNetworkedMove(gameScreen);
                              }
                              else
                              {
                                   MovieClip(this.actionsToButtonMap[this.currentActions[action]]).alpha = 1;
                              }
                         }
                         else
                         {
                              if(MovieClip(this.actionsToButtonMap[this.currentActions[action]]).hitTestPoint(gameScreen.stage.mouseX,gameScreen.stage.mouseY,false))
                              {
                                   gameScreen.game.team.updateButtonOverXML(gameScreen.game,UnitCommand(this.actions[this.currentActions[action]]).xmlInfo);
                              }
                              if(UnitCommand(this.actions[this.currentActions[action]]).isActivatable)
                              {
                                   candidate = UnitCommand(this.actions[this.currentActions[action]]);
                                   if(gameScreen.userInterface.keyBoardState.isDownForAction(UnitCommand(this.actions[this.currentActions[action]]).hotKey) || gameScreen.userInterface.mouseState.clicked && MovieClip(this.actionsToButtonMap[this.currentActions[action]]).hitTestPoint(gameScreen.stage.mouseX,gameScreen.stage.mouseY,false))
                                   {
                                        gameScreen.userInterface.mouseState.clicked = false;
                                        min = candidate.coolDownTime(gameScreen.userInterface.selectedUnits.unitTypes[this.currentEntity.type][0]);
                                        for(j = 1; j < gameScreen.userInterface.selectedUnits.unitTypes[this.currentEntity.type].length; j++)
                                        {
                                             v = candidate.coolDownTime(gameScreen.userInterface.selectedUnits.unitTypes[this.currentEntity.type][j]);
                                             if(v < min)
                                             {
                                                  min = v;
                                             }
                                        }
                                        if(candidate.getGoldRequired() > this.team.gold)
                                        {
                                             gameScreen.userInterface.helpMessage.showMessage("Not enough gold to cast ");
                                        }
                                        else if(candidate.getManaRequired() > this.team.mana)
                                        {
                                             gameScreen.userInterface.helpMessage.showMessage("Not enough mana to cast ");
                                        }
                                        else if(min != 0)
                                        {
                                             gameScreen.userInterface.helpMessage.showMessage("Ability is on cooldown");
                                        }
                                        else if(!UnitCommand(this.actions[this.currentActions[action]]).requiresMouseInput)
                                        {
                                             UnitCommand(this.actions[this.currentActions[action]]).prepareNetworkedMove(gameScreen);
                                             if(this.actionsToButtonMap[this.currentActions[action]] != null)
                                             {
                                                  MovieClip(this.actionsToButtonMap[this.currentActions[action]]).alpha = 0.2;
                                             }
                                        }
                                        else
                                        {
                                             this.refresh();
                                             this._currentMove = UnitCommand(this.actions[this.currentActions[action]]);
                                             Mouse.hide();
                                             this.clicked = false;
                                        }
                                   }
                                   else
                                   {
                                        MovieClip(this.actionsToButtonMap[this.currentActions[action]]).alpha = 1;
                                   }
                              }
                         }
                    }
               }
               if(this._currentMove != null)
               {
                    if(this.clicked)
                    {
                         if(Boolean(this._currentMove))
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
               var key:String = null;
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
          
          public function setEntity(entity:com.brockw.stickwar.engine.Entity) : void
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
               var t:TechItem = null;
               var b:Bitmap = null;
               if(type < 0)
               {
                    if(type in this.team.tech.upgrades)
                    {
                         t = this.team.tech.upgrades[type];
                         MovieClip(this.boxes[y * COLS + x]).visible = true;
                         b = t.mc;
                         b.x = -b.width / 2;
                         b.y = -b.height / 2;
                         b.name = "mc";
                         MovieClip(this.boxes[y * COLS + x]).addChild(b);
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
                    b = UnitCommand(this.actions[type]).buttonBitmap;
                    b.x = -b.width / 2;
                    b.y = -b.height / 2;
                    b.name = "mc";
                    MovieClip(this.boxes[y * COLS + x]).addChild(b);
                    this.actionsToButtonMap[type] = MovieClip(this.boxes[y * COLS + x]);
                    this.currentActions.push(type);
               }
               var s:Sprite = Sprite(MovieClip(this.boxes[y * COLS + x]).getChildByName("overlay"));
               var mc:DisplayObject = MovieClip(this.boxes[y * COLS + x]).getChildByName("mc");
               MovieClip(this.boxes[y * COLS + x]).removeChild(s);
               MovieClip(this.boxes[y * COLS + x]).addChild(s);
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
          
          public function get currentEntity() : com.brockw.stickwar.engine.Entity
          {
               return this._currentEntity;
          }
          
          public function set currentEntity(value:com.brockw.stickwar.engine.Entity) : void
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
