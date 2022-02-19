#include maps\mp\gametypes\_gamelogic;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main()
{
	replacefunc(maps\mp\gametypes\_music_and_dialog::musicController, ::musicControllerUT);	
	replacefunc(maps\mp\_events::multiKill, ::multiKillUT);
	replacefunc(maps\mp\_events::headShot, ::headShotUT);
	replacefunc(maps\mp\_events::firstBlood, ::firstBloodUT);
	replacefunc(maps\mp\gametypes\_gamelogic::timeLimitClock, ::timeLimitClockUT);
	
	level thread onPlayerConnect();
}


multiKillUT(var_0, var_1)
{
	if ( var_1 == 2 )
    {
		self playsound("double_kill");
		self thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_DOUBLEKILL" );
		self maps\mp\killstreaks\_killstreaks::giveAdrenaline( "double" );
    }
    else if ( var_1 == 3 )
    {
		self playsound("multi_kill");
		self thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_MULTIKILL" );
		self maps\mp\killstreaks\_killstreaks::giveAdrenaline( "triple" );
		thread maps\mp\_utility::teamPlayerCardSplash( "callout_3xpluskill", self );
    }
    else if ( var_1 == 4 )
    {
		self playsound("mega_kill");
		self thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_MEGAKILL"  );
		self maps\mp\killstreaks\_killstreaks::giveAdrenaline( "multi" );
		thread maps\mp\_utility::teamPlayerCardSplash( "callout_4xkill", self );
    }
	else if ( var_1 == 5 )
	{
		self playsound("ultra_kill");
		self thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_ULTRAKILL" );
		self maps\mp\killstreaks\_killstreaks::giveAdrenaline( "multi" );
		thread maps\mp\_utility::teamPlayerCardSplash( "callout_5xkill", self );
	}
	else if ( var_1 == 6 )
	{
		self playsound("monster_kill");
		self thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_MONSTERKILL" );
		self maps\mp\killstreaks\_killstreaks::giveAdrenaline( "multi" );
		thread maps\mp\_utility::teamPlayerCardSplash( "callout_6xkill", self );
	}
	else if ( var_1 == 7 )
	{
		self playsound("ludicrous_kill");
		self thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_LUDICROUSKILL" );
		self maps\mp\killstreaks\_killstreaks::giveAdrenaline( "multi" );
		thread maps\mp\_utility::teamPlayerCardSplash( "callout_7xkill", self );
	}
	else
	{
		self playsound("holy_shit");
		self thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_HOLYSHIT" );
		self maps\mp\killstreaks\_killstreaks::giveAdrenaline( "multi" );
		thread maps\mp\_utility::teamPlayerCardSplash( "callout_8xpluskill", self );
	}
	

    thread maps\mp\_matchdata::logMultiKill( var_0, var_1 );
    maps\mp\_utility::setPlayerStatIfGreater( "multikill", var_1 );
    maps\mp\_utility::incPlayerStat( "mostmultikills", 1 );
}


headShotUT( killId, weapon, meansOfDeath )
{
	self.modifiers["headshot"] = true;

	self thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_HEADSHOT" );
	
	self thread maps\mp\gametypes\_rank::giveRankXP( "headshot", undefined, weapon, meansOfDeath );
	self maps\mp\killstreaks\_killstreaks::giveAdrenaline( "headshot" );
	self thread maps\mp\_matchdata::logKillEvent( killId, "headshot" );
	
	self playsound( "headshot" );
}


firstBloodUT( killId, weapon, meansOfDeath )
{
	self.modifiers["firstblood"] = true;

	self thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_FIRSTBLOOD" );
	
	self thread maps\mp\gametypes\_rank::giveRankXP( "firstblood", undefined, weapon, meansOfDeath );
	self thread maps\mp\_matchdata::logKillEvent( killId, "firstblood" );
	self maps\mp\killstreaks\_killstreaks::giveAdrenaline( "firstBlood" );

	thread maps\mp\_utility::teamPlayerCardSplash( "callout_firstblood", self );
	
	self playsound( "first_blood" );
}


timeLimitClockUT()
{
	level endon ( "game_ended" );
	
	wait .05;
	
	clockObject = spawn( "script_origin", (0,0,0) );
	clockObject hide();
	
	while ( game["state"] == "playing" )
	{
		if ( !level.timerStopped && getTimeLimit() )
		{
			timeLeft = getTimeRemaining() / 1000;
			timeLeftInt = int(timeLeft + 0.5); // adding .5 and flooring rounds it.
			
			if ( getHalfTime() && timeLeftInt > (getTimeLimit()*60) * 0.5 )
				timeLeftInt -= int((getTimeLimit()*60) * 0.5);
			
			if ( (timeLeftInt >= 30 && timeLeftInt <= 60) )
				level notify ( "match_ending_soon", "time" );

			if ( timeLeftInt <= 10 || (timeLeftInt <= 30 && timeLeftInt % 2 == 0) )
			{
				level notify ( "match_ending_very_soon" );
				// don't play a tick at exactly 0 seconds, that's when something should be happening!
				if ( timeLeftInt == 0 )
					break;
				
				//clockObject playSound( "ui_mp_timer_countdown" );
			}
			
			switch ( timeLeftInt )
			{
				case 300:
					clockObject playSound( "5min_remaining" );
					break;
				case 180:
					clockObject playSound( "3min_remaining" );
					break;
				case 120:
					clockObject playSound( "2min_remaining" );
					break;
				case 60:
					clockObject playSound( "1min_remaining" );
					break;
				case 30:
					clockObject playSound( "30sec_remaining" );
					break;
				case 20:
					clockObject playSound( "20sec_remaining" );
					break;
				case 10:
					clockObject playSound( "ten" );
					break;
				case 9:
					clockObject playSound( "nine" );
					break;
				case 8:
					clockObject playSound( "eight" );
					break;
				case 7:
					clockObject playSound( "seven" );
					break;
				case 6:
					clockObject playSound( "six" );
					break;
				case 5:
					clockObject playSound( "five" );
					break;
				case 4:
					clockObject playSound( "four" );
					break;
				case 3:
					clockObject playSound( "three" );
					break;
				case 2:
					clockObject playSound( "two" );
					break;
				case 1:
					clockObject playSound( "one" );
					break;
			}
			
			// synchronize to be exactly on the second
			if ( timeLeft - floor(timeLeft) >= .066 )
				wait timeLeft - floor(timeLeft);
		}

		wait ( 1.0 );
	}
}


musicControllerUT()
{
}


onPlayerConnect()
{
    for (;;)
    {
        level waittill( "connected",  player  );
        player thread onPlayerSpawned();
    }
}


onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill( "spawned_player" );
		self thread monitorKillstreakSounds();
	}
}


monitorKillstreakSounds()
{
	self endon("disconnect");
	self endon("death");
	
	prevCount = 0;
	
	for(;;)
	{
		self waittill( "killed_enemy" );
		
		
		if ( self.pers["cur_kill_streak"] >= 5 && prevCount < 5 )
		{
			self playsound( "killing_spree" );
		} 
		else if ( self.pers["cur_kill_streak"] >= 10 && prevCount < 10 )
		{
			self playsound( "rampage" );
		}
		else if ( self.pers["cur_kill_streak"] >= 15 && prevCount < 15 )
		{
			self playsound( "dominating" );
		}
		else if ( self.pers["cur_kill_streak"] >= 20 && prevCount < 20 )
		{
			self playsound( "unstoppable" );
		}
		else if ( self.pers["cur_kill_streak"] >= 25 && prevCount < 25 )
		{
			self playsound( "god_like" );
		}
		else if ( self.pers["cur_kill_streak"] >= 30 && prevCount < 30 )
		{
			self playsound( "wicked_sick" );
		}
		
		
		prevCount = self.pers["cur_kill_streak"];
	}
}
