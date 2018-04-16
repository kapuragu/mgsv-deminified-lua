-- TppDbgStr32
local this={}
local StrCode32=Fox.StrCode32
local strCode32ToString={}
this.DEBUG_strCode32List={
  "Trap",
  "Enter",
  "Stay",
  "Exit",
  "Timer",
  "Start",
  "Finish",
  "debugRadioTimer",
  "debugRadioStartTimer",
  "Timer_WaitStartingGame",
  "Timer_HelicopterMoveStart",
  "Timer_FadeInStartOnNoTelopHelicopter",
  "Subtitles",
  "SubtitlesStartEventMessage",
  "SubtitlesEndEventMessage",
  "Weather",
  "Clock",
  "ShiftChangeAtNight",
  "ShiftChangeAtMorning",
  "AnimalRouteChangeAtNight00",
  "AnimalRouteChangeAtNight01",
  "AnimalRouteChangeAtNight02",
  "AnimalRouteChangeAtNight03",
  "AnimalRouteChangeAtNight04",
  "AnimalRouteChangeAtMorning00",
  "AnimalRouteChangeAtMorning01",
  "AnimalRouteChangeAtMorning02",
  "AnimalRouteChangeAtMorning03",
  "AnimalRouteChangeAtMorning04",
  "Marker",
  "ChangeToEnable",
  "GameObject",
  "AntiSniperNoticed",
  "ArrivedAtLandingZoneSkyNav",
  "ArrivedAtLandingZoneWaitPoint",
  "BreakGimmick",
  "BringPlayerEvent",
  "BuddyAppear",
  "BuddyArrived",
  "BuddyDogFinishSnarlAndStay",
  "BuddyEspionage",
  "CalledFromStandby",
  "CameraFindPlayer",
  "Carried",
  "ChangeLife",
  "ChangePhase",
  "CommandPostAnnihilated",
  "Conscious",
  "ConversationEnd",
  "Damage",
  "Dead",
  "DescendToLandingZone",
  "DisableTranslate",
  "DiscoveryHostage",
  "Down",
  "Dying",
  "DyingAll",
  "EspionageBoxGimmickOnGround",
  "EventDoorOpen",
  "FogCleared",
  "Fulton",
  "FultonFailed",
  "FultonFailedEnd",
  "GetInEnemyHeli",
  "HeadShot",
  "HeliDoorClosed",
  "Holdup",
  "InLocator",
  "Interrogate",
  "InterrogateEnd",
  "IsAnyoneNearBy",
  "LandedAtLandingZone",
  "LiquidChangePhase",
  "LiquidDefeatedByCqcInStartRoom",
  "LiquidEnterCombatPhaseTwo",
  "LostContainer",
  "LostControl",
  "LostHostage",
  "MapUpdate",
  "MonologueEnd",
  "Observed",
  "PlacedIntoVehicle",
  "PlayerGetAway",
  "PlayerGetNear",
  "PlayerHideHorse",
  "PutMarkerWithBinocle",
  "QuietLostPlayer",
  "QuietSnipeAtGrenade",
  "QuietStartSniping",
  "RadioEnd",
  "ReportDiscoveryHostage",
  "Restraint",
  "Returned",
  "RideHeli",
  "RouteEventFaild",
  "RoutePoint",
  "RoutePoint2",
  "SahelanChangePhase",
  "SleepingComradeRecoverd",
  "SmokeDiscovered",
  "SpecialActionEnd",
  "StartedCombat",
  "StartedDiscovery",
  "StartedMoveToLandingZone",
  "StartedPullingOut",
  "StartedSearch",
  "SwitchCamera",
  "SwitchGimmick",
  "TapFoundPlayerInAlert",
  "TapHeadShotFar",
  "TapHeadShotNear",
  "Unconscious",
  "Unlocked",
  "VehicleAction",
  "VehicleBroken",
  "VehicleDisappeared",
  "VolginAttack",
  "VolginChangePhase",
  "VolginDamagedByType",
  "VolginDestroyedFactoryWall",
  "VolginDestroyedTunnel",
  "VolginGameOverAttackSuccess",
  "VolginLifeStatusChanged",
  "WalkerGearBroken",
  "UI",
  "EndFadeOut",
  "EndFadeIn",
  "DemoPauseSkip",
  "BonusPopupAllClose",
  "StartMissionTelopFadeIn",
  "StartMissionTelopFadeOut",
  "StartMissionTelopCastTop",
  "StartMissionTelopCastEnd",
  "EndMissionTelopFadeIn",
  "EndMissionTelopHalfFadeOut",
  "EndMissionTelopFadeOut",
  "EndMissionTelopRadioStop",
  "MissionPreparationEnd",
  "GameOverOpen",
  "GameOverContinue",
  "GameOverRestart",
  "GameOverReturnToTitle",
  "PauseMenuCheckpoint",
  "PauseMenuRestart",
  "PauseMenuReturnToTitle",
  "PauseMenuRestartFromHelicopter",
  "TitleMenu",
  "PressStart",
  "Continue",
  "RestartHeli",
  "GameStart",
  "MissionGameEndFadeOutFinish",
  "MissionFinalizeFadeOutFinish",
  "MissionFinalizeAtGameOverFadeOutFinish",
  "RestartMissionFadeOutFinish",
  "ContinueFromCheckPointFadeOutFinish",
  "AborMissionFadeOutFinish",
  "ReloadFadeOutFinish",
  "FadeInOnStartTitle",
  "FadeInOnStartMissionGame",
  "StartAnnounceLog",
  "EndAnnounceLog",
  "AvatarEditEnd",
  "BonusPopupClose",
  "BonusPopupAllClose",
  "ConfigurationUpdated",
  "CustomizeSelectorStart",
  "CustomizeSelectorAbort",
  "CustomizeSelectorEnd",
  "TppEndingFinish",
  "SaveUiDisp",
  "LoadUiDisp",
  "CallAnnounceLog",
  "GetAllCassetteTapes",
  "GameOverFadeIn",
  "GameOverOpen",
  "GameOverContinue",
  "GameOverRestart",
  "GameOverRestartFromHelicopter",
  "GameOverReturnToTitle",
  "WorldMarkerAboutErase",
  "EndMissionTelopFadeIn",
  "EndMissionTelopDisplay",
  "EndMissionTelopHalfFadeOut",
  "EndMissionTelopFadeOut",
  "EndMissionTelopRadioStop",
  "EndResultBlockLoad",
  "MbDvcActOpenTop",
  "MbDvcActCloseTop",
  "MbDvcActTopModeMap",
  "MbDvcActTopModeMenu",
  "MbDvcActTopModeWalk",
  "MbDvcActOpenMenu",
  "MbDvcActOpenStaffList",
  "MbDvcActOpenMissionList",
  "MbDvcActOpenHeliCall",
  "MbDvcActSelectItemDropPoint",
  "MbDvcActRequestStrike",
  "MbDvcActAcceptMissionList",
  "MbDvcActSelectLandPoint",
  "MbDvcActCallRescueHeli",
  "MbDvcActWatchPhoto",
  "MbDvcActFocusMapIcon",
  "MbDvcActSelectNonActiveMenu",
  "MbDvcActCallBuddy",
  "MbDvcActSelectCboxDelivery",
  "NameEntryClose",
  "PauseMenuCheckpoint",
  "PauseMenuRestart",
  "PauseMenuRestartFromHelicopter",
  "PauseMenuReturnToTitle",
  "PauseMenuReturnToMission",
  "PauseMenuSkipTutorial",
  "DemoPauseSkip",
  "PopupClose",
  "DisplayTimerTimeUp",
  "DisplayTimerLap",
  "FadeInOnGameStart",
  "Terminal",
  "MbDvcActOpenTop",
  "MbDvcActCloseTop",
  "MbDvcActTopModeMap",
  "MbDvcActTopModeMenu",
  "MbDvcActTopModeWalk",
  "MbDvcActOpenMenu",
  "MbDvcActOpenStaffList",
  "MbDvcActOpenDevelopWeapon",
  "MbDvcActOpenMissionList",
  "MbDvcActOpenHeliCall",
  "MbDvcActAssignStaffDevelop",
  "MbDvcActDevelopWeapon",
  "MbDvcActSupportWeapon",
  "MbDvcActStrikeSmoke",
  "MbDvcActAcceptMissionList",
  "MbDvcActCallRescueHeli",
  "MbDvcActWatchPhoto",
  "MbDvcActFocusMapIcon",
  "MbDvcActSelectNonActiveMenu",
  "MbDvcActAcceptMissionList",
  "MbDvcActSelectLandPoint",
  "Radio",
  "debugRadioTimer",
  "Enemy",
  "caution",
  "hold",
  "default",
  "old",
  "immediately",
  "new",
  "SYS_Sneak",
  "SYS_Caution",
  "MessageRoutePoint",
  "EndGroupVehicleRouteMove",
  "Player",
  "FinishInterpCameraToDemo",
  "innerZone",
  "outerZone",
  "hotZone",
  "DemoSkipStart",
  "DemoSkipped",
  "CalcFultonPercent",
  "RideHelicopter",
  "CalcDogFultonPercent",
  "ConstrainCameraInterpEnd",
  "FinishMovingToPosition",
  "LookingTarget",
  "NotifyChangedPlayerCyprRideHorseAction",
  "NotifyChangedPlayerRailAction",
  "OnComeOutSupplyCbox",
  "OnPickUpCollection",
  "OnPickUpPlaced",
  "OnPickUpSupplyCbox",
  "OnPickUpWeapon",
  "WarpEnd",
  "LandingFromHeli",
  "EndCarryAction",
  "IntelIconInDisplay",
  "Demo",
  "Play",
  "Interrupt",
  "Skip",
  "Disable",
  "StartMissionTelop",
  "DemoSkipFadeIn",
  "DemoPlayFadeIn",
  "Video",
  "VideoPlay",
  "VideoStopped",
  "MotherBaseManagement",
  "Block",
  "OnChangeLargeBlockState",
  "OnChangeSmallBlockState"
}
function this.DEBUG_RegisterStrcode32invert(strCode32List)
  local newStr32ToStringTable={}
  for i,someString in pairs(strCode32List)do
    newStr32ToStringTable[StrCode32(someString)]=someString
  end
  strCode32ToString=newStr32ToStringTable
end
function this.DEBUG_RegisterStrcode32invertByString(someString)
  strCode32ToString[StrCode32(someString)]=someString
end
function this.DEBUG_StrCode32ToString(str32String)
  if strCode32ToString[str32String]then
    return strCode32ToString[str32String]
  end
end
return this
