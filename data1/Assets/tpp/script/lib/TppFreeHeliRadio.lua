local this={}
local StrCode32=Fox.StrCode32
local StrCode32Table=Tpp.StrCode32Table
local band=bit.band
local SendCommand=GameObject.SendCommand

this.DAY_TIME=3
this.NIGHT_TIME=19
this.DAY_TO_NIGHT=string.format("%d:00:00",this.NIGHT_TIME)
this.NIGHT_TO_DAY=string.format("%d:00:00",this.DAY_TIME)

this.isPlayBreefing=false

this.ON_ENTER_RESULT={
  START_PANDEMIC_TUTORIAL=1
}

this.PANDEMIC_RADIO={
  START="f2000_rtrg9000",
  START_FREE={"f2000_rtrg9005"},
  START_CONTINED_IN_HELI={
    "f2000_rtrg9010",
    "f2000_rtrg9020",
    "f2000_rtrg9030",
    "f2000_rtrg9040"
  },
  OPEN_TERMINAL="f2000_rtrg9060",
  OPEN_TERMINAL_SELECT="f2000_rtrg9080",
  PANDEMIC_FACILITY="f2000_rtrg9100",
  ON_ISOLATE_STAFF="f2000_rtrg9110",
  NO_ISOLATED_YET="f2000_rtrg9150",
  ISOLATE_FAILED="f2000_rtrg9170",
  ISOLATE_FAILED_HINT="f2000_rtrg9190",
  ISOLATE_SUCCEED_A_FEW="f2000_rtrg9220",
  ISOLATE_SUCCEED_HINT="f2000_rtrg9200",
  ISOLATE_SUCCEED_MANY="f2000_rtrg9240",
  FINISH="f2000_rtrg9250",
  FINISH_ADD="f2000_rtrg9260"
}

function this.DeclareSVars()
  return{
    {name="freeRadio_isPlayed",type=TppScriptVars.TYPE_BOOL,value=false,save=true,sync=false,wait=false,category=TppScriptVars.CATEGORY_MISSION},
    nil
  }
end

function this.Messages()
  return StrCode32Table{
    Player={
      {
        msg="CalcFultonPercent",
        func=function(playerIndex,gameId,gimmickInstanceOrAnimalId,gimmickDataSet,staffOrResourceId)
          if Tpp.IsSoldier(gameId)then
            local radioName="f2000_rtrg0040"
            if(not TppRadio.IsPlayed(radioName)and TppRadio.IsPlayed"f2000_oprg0210")and(not TppStory.IsMissionCleard(10040))then
              this._PlayRadio(radioName)
            end
            if not TppStory.IsMissionCleard(10070)then
              local radioName="f2000_rtrg0060"
              local stateFlag=SendCommand(gameId,{id="GetStateFlag"})
              if(band(stateFlag,StateFlag.DYING_LIFE)~=0)then
                if not TppRadio.IsPlayed(radioName)then
                  this._PlayRadio(radioName)
                end
              end
            end
          end
        end
      }
    },
    GameObject={
      {
        msg="PlayerGetAway",
        func=function(gameObjectId)
          if Tpp.IsHostage(gameObjectId)then
            this._UnregisterOptionRadio"f2000_oprg0105"
          end
        end
      },
      {
        msg="PlayerGetNear",
        func=function(gameObjectId)
          if Tpp.IsHostage(gameObjectId)then
            this._RegisterOptionRadio"f2000_oprg0105"
          end
        end
      },
      {
        msg="Unconscious",
        func=function(gameId)
          local radioName="f2000_oprg0210"
          if (Tpp.IsSoldier(gameId)
          and (not mvars.FreeHeliRadio_addOptionRadioCount[radioName]))
          and (not TppStory.IsMissionCleard(10040))then
            this._RegisterOptionRadio(radioName)
          end
        end
      },
      {
        msg="FultonFailed",
        func=function(gameId,locatorName,locatorNameUpper,failureType)
          if Tpp.IsSoldier(gameId)and failureType==TppGameObject.FULTON_FAILED_TYPE_ON_FINISHED_RISE then
            local radioName="f2000_rtrg1240"
            if (vars.weather~=TppDefine.WEATHER.SUNNY) 
            and (not TppRadio.IsPlayed(radioName)) then
              this._PlayRadio(radioName)
            else
              local stateFlag=SendCommand(gameId,{id="GetStateFlag"})
              if (band(stateFlag,StateFlag.DYING_LIFE)~=0) 
              and (math.random(1,2)<2) then
                this._PlayRadio"f2000_rtrg0070"
              else
                this._PlayRadio"f2000_rtrg0050"
              end
            end
          end
        end
      }
    },
    MotherBaseManagement={
      {
        msg="UpdatedPandemic",
        func=this.UpdatePandemicEvent
      }
    },
    Terminal={
      {
        msg="MbDvcActCloseTop",
        func=function()
        end
      }
    },
    Weather={
      {
        msg="Clock",
        sender="ChangeDayToNight",
        func=function(sender,time)
          this.RegistNvgOptionRadio()
        end
      },
      {
        msg="Clock",
        sender="ChangeNightToDay",
        func=function(sender,time)
          this.UnregistNvgOptionRadio()
        end
      },
      {
        msg="ChangeWeathre",--RETAILBUG: typo
        func=function(weatherType)
          local radioName="f2000_oprg0185"
          if weatherType==TppDefine.WEATHER.SANDSTORM then
            this._RegisterOptionRadio(radioName)
          else
            this._UnregisterOptionRadio(radioName)
          end
        end
      }
    },
    Radio={
      {
        msg="Finish",
        sender="f1000_rtrg3120",
        func=function()
          TppStory.UpdateStorySequence{updateTiming="OnEndRtrg3120",isInGame=true}
        end
      }
    }
  }
end

function this._OnReload()
  this.SetupMessages()
end

function this.OnReload()
  local isHelispace=TppMission.IsHelicopterSpace(vars.missionCode)
  local isFree=TppMission.IsFreeMission(vars.missionCode)
  if(isHelispace or isFree)and(vars.missionCode~=30050)then
    this.SetupMessages()
  else
    this.messageExecTable=nil
  end
end

function this.SetupMessages()
  this.messageExecTable=Tpp.MakeMessageExecTable(this.Messages())
end

function this.OnMessage(sender,messageId,arg0,arg1,arg2,arg3,strLogText)
  Tpp.DoMessage(this.messageExecTable,TppMission.CheckMessageOption,sender,messageId,arg0,arg1,arg2,arg3,strLogText)
end

function this.OnEnter()
  this._RegistClock()
  this.SetupMessages()
  mvars.FreeHeliRadio_addOptionRadioCount={}
  mvars.FreeHeliRadio_animalRadioGroup=nil
  mvars.FreeHeliRadio_nvgRadioGroup=nil
  TppMission.RegisterMissionSystemCallback{OnAddStaffsFromTempBuffer=this.OnAddStaffsFromTempBuffer}
  TppCassette.OnEnterFreeHeliPlay()
  local unkT1={}
  if TppMotherBaseManagement.GetStaffCount()<=10 then
    this._RegisterOptionRadio"f2000_oprg0020"
  end
  if TppMotherBaseManagement.GetDevelopedEquipCount()<=5 then
    this._RegisterOptionRadio"f2000_oprg0030"
  end
  if not TppStory.IsMissionCleard(10040)then
    this._RegisterOptionRadio"f2000_oprg0220"
  end
  if not this._IsTimeOfDay()then
    this.RegistNvgOptionRadio()
  end
  if vars.weather==TppDefine.WEATHER.SANDSTORM then
    this._RegisterOptionRadio"f2000_oprg0185"
  end
  local tryPandemicStart=this.TryPandemicStart()
  if TppTerminal.CheckPandemicEventFinish()then
    TppTerminal.FinishPandemicEvent()
  end
  local currentStorySeq=TppStory.GetCurrentStorySequence()
  local numCleardAfghFlagMissions1=TppStory.GetClearedMissionCount{10036,10033,10043}
  local numCleardAfghFlagMissions2=TppStory.GetClearedMissionCount{10041,10044,10052,10054}
  local numCleardS10240Missions=TppStory.GetClearedMissionCount{10010,10020,10030,10036,10043,10033,10040,10041,10044,10052,10054,10050,10070,10080,10086,10082,10090,10091,10195,10100,10110,10121,10115,10120,10085,10200,10211,10081,10130,10140,10150,10151,10045,10156,10093,10171}
  if tryPandemicStart then
    return this.ON_ENTER_RESULT.START_PANDEMIC_TUTORIAL
  end
  if not svars.freeRadio_isPlayed then
    svars.freeRadio_isPlayed=true
    local demoOrRadio=TppStory.GetForceMBDemoNameOrRadioList"freeHeliRadio"
    if demoOrRadio then
      this._PlayRadio(demoOrRadio)
    end
  end
end

function this.Init()
  this.messageExecTable=nil
end

function this.OnLeave()
end

function this.RegistNvgOptionRadio()
  mvars.FreeHeliRadio_nvgRadioGroup=nil
  if not TppMotherBaseManagement.IsEquipDeveloped{equipID=TppEquip.EQP_IT_Nvg}then
    if TppPlayer.GetBulletNum(TppEquip.BL_IT_TimeCigarette)>0 then
      mvars.FreeHeliRadio_nvgRadioGroup="f2000_oprg0200"
    else
      mvars.FreeHeliRadio_nvgRadioGroup="f2000_oprg0190"
    end
    this._RegisterOptionRadio(mvars.FreeHeliRadio_nvgRadioGroup)
  end
end

function this.UnregistNvgOptionRadio()
  if mvars.FreeHeliRadio_nvgRadioGroup then
    this._UnregisterOptionRadio(mvars.FreeHeliRadio_nvgRadioGroup)
  end
end

function this.RegistAnimalOptionalRadio(animalTypeStr)
  if not mvars.FreeHeliRadio_addOptionRadioCount then
    return
  end
  if animalTypeStr=="Goat"then
    mvars.FreeHeliRadio_animalRadioGroup="f2000_oprg0065"
  elseif animalTypeStr=="Wolf"then
    mvars.FreeHeliRadio_animalRadioGroup="f2000_oprg0075"
  end
  if mvars.FreeHeliRadio_animalRadioGroup then
    this._RegisterOptionRadio(mvars.FreeHeliRadio_animalRadioGroup)
  end
end

function this.UnregistAnimalOptionalRadio()
  if not mvars.FreeHeliRadio_addOptionRadioCount then
    return
  end
  if mvars.FreeHeliRadio_animalRadioGroup then
    this._UnregisterOptionRadio(mvars.FreeHeliRadio_animalRadioGroup)
    mvars.FreeHeliRadio_animalRadioGroup=nil
  end
end

function this.OnEnterCpIntelTrap(cpName)
  if not mvars.FreeHeliRadio_addOptionRadioCount then
    return
  end
  this._RegisterOptionRadio"f2000_oprg0115"
  this._RegisterOptionRadio"f2000_oprg0125"
  this._RegisterOptionRadio"f2000_oprg0130"
  this._RegisterOptionRadio"f2000_oprg0165"
  this._RegisterOptionRadio"f2000_oprg0175"
  if TppClock.GetTimeOfDay()=="night"then
    this._RegisterOptionRadio"f2000_oprg0165"
  else
    this._RegisterOptionRadio"f2000_oprg0155"
  end
end

function this.OnExitCpIntelTrap(cpName)
  if not mvars.FreeHeliRadio_addOptionRadioCount then
    return
  end
  this._UnregisterOptionRadio"f2000_oprg0115"
  this._UnregisterOptionRadio"f2000_oprg0125"
  this._UnregisterOptionRadio"f2000_oprg0130"
  this._UnregisterOptionRadio"f2000_oprg0175"
  this._UnregisterOptionRadio"f2000_oprg0165"
  this._UnregisterOptionRadio"f2000_oprg0155"
end

function this.TryPandemicStart()
  local isStartPandemic=false
  if not TppTerminal.IsNeedPlayPandemicTutorialRadio()then
    return isStartPandemic
  end
  local isHelispace=TppMission.IsHelicopterSpace(vars.missionCode)
  local isFree=TppMission.IsFreeMission(vars.missionCode)
  if not TppMotherBaseManagement.IsPandemicEventMode()then
    TppTerminal.StartPandemicEvent()
    isStartPandemic=true
  end
  if TppMotherBaseManagement.IsPandemicEventMode()then
    if not TppRadio.IsPlayed"f2000_rtrg9010"then
      if isHelispace then
        this._PlayRadio(this.PANDEMIC_RADIO.START_CONTINED_IN_HELI)
        isStartPandemic=true
      end
    end
  end
  if TppDemo.IsPlayedMBEventDemo"QuietReceivesPersecution"then
    TppCassette.Acquire{cassetteList={"tp_c_00000_16"},pushReward=true}
  end
  return isStartPandemic
end

local pandemicRatioHigh=.85
local pandemicRatioLow=.2

function this.UpdatePandemicEvent(finalEvent,arg1)
  TppTerminal.UpdatePandemicEventBingoCount()
  local currentPandemicBingoCount,lastPandemicCountRatio,currentPandemicCountRatio=TppTerminal.GetPandemicBingoCount()
  if currentPandemicCountRatio>pandemicRatioHigh then
    if not TppRadio.IsPlayed(this.PANDEMIC_RADIO.FINISH)then
      this._PlayRadio(this.PANDEMIC_RADIO.FINISH)
    end
    return
  end
  if currentPandemicCountRatio>pandemicRatioLow then
    if not TppRadio.IsPlayed(this.PANDEMIC_RADIO.ISOLATE_SUCCEED_MANY)then
      this._PlayRadio(this.PANDEMIC_RADIO.ISOLATE_SUCCEED_MANY)
    end
    return
  end
  if(finalEvent>0)then
    if not gvars.trm_doneIsolateByManual then
      this._PlayRadio(this.PANDEMIC_RADIO.NO_ISOLATED_YET)
      return
    end
  end
end

function this._RegistClock()
  TppClock.RegisterClockMessage("ChangeDayToNight",this.DAY_TO_NIGHT)
  TppClock.RegisterClockMessage("ChangeNightToDay",this.NIGHT_TO_DAY)
end

function this._PlayRadio(radioGroup)
  TppRadio.Play(radioGroup,{isEnqueue=true,delayTime="long"})
end

function this._RegisterOptionRadio(radioName)
  local radioCount=mvars.FreeHeliRadio_addOptionRadioCount[radioName]
  if radioCount then
    mvars.FreeHeliRadio_addOptionRadioCount[radioName]=radioCount+1
  else
    local radioGroupIndex=0
    TppRadioCommand.RegisterRadioGroupToActiveRadioGroupSetInsert(radioName,radioGroupIndex)
    mvars.FreeHeliRadio_addOptionRadioCount[radioName]=1
  end
end

function this._UnregisterOptionRadio(radioName,radioGroupIndex)
  local radioCount=mvars.FreeHeliRadio_addOptionRadioCount[radioName]
  if radioCount then
    if radioCount>1 then
      mvars.FreeHeliRadio_addOptionRadioCount[radioName]=radioCount-1
    else
      mvars.FreeHeliRadio_addOptionRadioCount[radioName]=nil
    end
  else
    if radioGroupIndex then
    end
  end
  TppRadioCommand.UnregisterRadioGroupFromActiveRadioGroupSet(radioName)
end

function this._IsRegistOptionRadio(radioName)
  return mvars.FreeHeliRadio_addOptionRadioCount[radioName]
end

function this._IsTimeOfDay()
  local time=TppClock.GetTime"time"
  return (time>=this.DAY_TIME) and (time<=this.NIGHT_TIME)
end

return this
