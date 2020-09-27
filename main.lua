local admob = require( "plugin.admob" )

local myAppId = "ADD_CORRECT_APP_ID_HERE"
--local myInterstitialAdUnitId = "YOUR_ANDROID_ADMOB_INTERSTITAL_AD_UNIT_ID"
--local myBannerAdUnitId = "YOUR_ANDROID_ADMOB_BANNER_AD_UNIT_ID"
local myRewardedAdUnitId = "ADD_CORRECT_AD_UNIT_ID_HERE"
 

local adParams = { appId=myAppId, testMode=false }

local function adListener( event )
    local json = require( "json" )
    print("Ad event: ")
    print( json.prettify( event ) )
  
    if ( event.phase == "init" ) then  -- Successful initialization
        print( event.provider )
        admob.load( "rewardedVideo", { adUnitId = myRewardedAdUnitId, hasUserConsent = false } )
    elseif event.phase == "failed" then
        if event.type == "rewardedVideo" then
            -- Put your ad loading failover code here
            print("We failed to load the rewardedVideo") 
        end
    elseif ( event.phase == "displayed" ) then -- Ads were loaded
        if event.type == "rewardedVideo" then
          print("------ We will now do again the load for the rewarded video") 
          admob.load( "rewardedVideo", { adUnitId = myRewardedAdUnitId, hasUserConsent = false } )
        end
    elseif ( event.phase == "reward" ) then -- A rewarded video was completed
        local data = json.decode( event.data )
        local rewardAmount = data.rewardAmount
        local rewardItem = data.rewardItem
        printTable("reward data back", data)
        -- code to give these to your user
        
        local fakeEvent = {}
        fakeEvent.target = {}
        fakeEvent.target.type = adReward
        upgradeSkill(fakeEvent)
    end
end

local function watchAdtoSkill(event)
  print("####### here we will show an ad")
  adReward = event.target.type
  admob.show( "rewardedVideo" )

  return true
end

local button = display.newRect( display.contentCenterX, display.contentCenterY, 200, 200 )
button:addEventListener( "tap", watchAdtoSkill )
local newText = display.newText(  "1.2 ", display.contentCenterX, display.contentCenterY, native.systemFont, 34 )
newText:setTextColor( 0, 0, 0 )


admob.init( adListener, adParams )