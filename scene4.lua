sim=require'sim'
simUI=require'simUI'

function sysCall_init()
         
    -- This is executed exactly once, the first time this script is executed
    bubbleRobBase=sim.getObject('..') -- this is bubbleRob's handle
    leftMotor=sim.getObject("../leftMotor") -- Handle of the left motor
    rightMotor=sim.getObject("../rightMotor") -- Handle of the right motor
    personSensor=sim.getObject("../survivorDetector")
    survivors = {} --Initializing a survivors table
    survivors["Handle"] = "Location"
    minMaxSpeed={150*math.pi/180,200*math.pi/180}-- Min and max speeds for each motor
    robotCollection=sim.createCollection(0)
    sim.addItemToCollection(robotCollection,sim.handle_tree,bubbleRobBase,0)
    distanceSegment=sim.addDrawingObject(sim.drawing_lines,4,0,-1,1,{0,1,0})
    robotTrace=sim.addDrawingObject(sim.drawing_linestrip+sim.drawing_cyclic,2,0,-1,200,{1,1,0},nil,nil,{1,1,0})
    xml = '<ui title="'..sim.getObjectAlias(bubbleRobBase,1)..' Steering Wheel" closeable="false" resizeable="false" activate="false">'..[[
                <hslider minimum="-50" maximum="50" id="1"/>
                <radiobutton text="Reverse" id="2"/> --I added a radio button to reverse the robot
            <label text="" style="* {margin-left: 300px;}"/>
        </ui>
        ]]
    ui=simUI.create(xml)
    speed=(minMaxSpeed[1]+minMaxSpeed[2])*.25 --I wanted the speed to stay consistent the whole time. A separate slider would be needed to adjust the speed
    simUI.setSliderValue(ui,1,0) --I set the slider to begin in the middle, at zero. The slider ranges from -50 to 50
end

function sysCall_sensing()
end 

local function locate(table, handle, place, sensPlace) --My locate function, used to determine the location of a person who is sensed
    uniqueIndicator = 0 --The unique indicator is used to make sure I dont add the same people more than once
    for k,v in pairs(table) do 
        if k == handle then  --I can tell if a person is unique based on their unique handle
            uniqueIndicator = uniqueIndicator + 1
        end
    end
    if (uniqueIndicator == 0) then --If the person is unique, I multiply my robot's location by the vector which it sensed the person at
        globalPosition = sim.multiplyVector(sensPlace, place)
        table[handle] = globalPosition --And I add that person's location to the table
        print(table) --I print the table when a new person is added so that I always have the most recent version in the console
    end
    return table --I have to return the table so that when the next survivor is found, they add that survivor to the same table
end

function sysCall_actuation()
    person, distance, place, handle=sim.handleProximitySensor(personSensor) --Bringing in my sensor
    sensorPosition = sim.getObjectPose(personSensor, -1) --And getting the sensor's location
    reverse = simUI.getRadiobuttonValue(ui, 2) --Some abstraction
    steer = simUI.getSliderValue(ui, 1)
    if (reverse == 1) then --If the reverse button is pressed
        speed=(minMaxSpeed[1]+minMaxSpeed[2])*-.5 --We reverse
    else
        speed=(minMaxSpeed[1]+minMaxSpeed[2])*.5 --Otherwise not
    end

    if (steer > 5 and reverse == 0) or (steer < -5 and reverse == 1) then --If we are going forward right or back left
        sim.setJointTargetVelocity(rightMotor, speed/2)
        sim.setJointTargetVelocity(leftMotor, speed)
    elseif (steer < -5 and reverse == 0) or (steer > 5 and reverse == 1)then  --If we are going forward left or back right
        sim.setJointTargetVelocity(rightMotor, speed)
        sim.setJointTargetVelocity(leftMotor, speed/2)
    else 
        sim.setJointTargetVelocity(rightMotor, speed) --Or if we're just going straight
        sim.setJointTargetVelocity(leftMotor, speed)
    end
        
    if (person > 0) then --If the person sensor senses anything
        if (sim.getObjectAlias(handle) == 'person') then --If the thing sensed has the handle "person"
            survivors = locate(survivors, handle, place, sensorPosition) --We call the locate function
        end
    end
end

function sysCall_cleanup() 
    simUI.destroy(ui)
end 
