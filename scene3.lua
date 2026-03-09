sim=require'sim'
simUI=require'simUI'

function sysCall_init()
         
    -- This is executed exactly once, the first time this script is executed
    bubbleRobBase=sim.getObject('..') -- this is bubbleRob's handle
    leftMotor=sim.getObject("../leftMotor") -- Handle of the left motor
    rightMotor=sim.getObject("../rightMotor") -- Handle of the right motor
    sensorNose=sim.getObject("../sensorNose") -- Handle of the proximity sensor
    sensorRight=sim.getObject("../sensorRight") --Adding in the rest of my sensors for the next few lines
    sensorCloseRight=sim.getObject("../sensorCloseRight")
    sensorCloseLeft=sim.getObject("../sensorCloseLeft")
    personSensor=sim.getObject("../survivorDetector")
    survivors = {} --Initializing a survivors table
    survivors["Handle"] = "Location" 
    minMaxSpeed={50*math.pi/180,300*math.pi/180}-- Min and max speeds for each motor
    robotCollection=sim.createCollection(0)
    backUntilTime=-1 --Initializing my backUntilTime
    sim.addItemToCollection(robotCollection,sim.handle_tree,bubbleRobBase,0)
    distanceSegment=sim.addDrawingObject(sim.drawing_lines,4,0,-1,1,{0,1,0})
    robotTrace=sim.addDrawingObject(sim.drawing_linestrip+sim.drawing_cyclic,2,0,-1,200,{1,1,0},nil,nil,{1,1,0})
    xml = '<ui title="'..sim.getObjectAlias(bubbleRobBase,1)..' speed" closeable="false" resizeable="false" activate="false">'..[[
                <hslider minimum="0" maximum="100" on-change="speedChange_callback" id="1"/>
            <label text="" style="* {margin-left: 300px;}"/>
        </ui>
        ]]
    ui=simUI.create(xml)
    speed=(minMaxSpeed[1]+minMaxSpeed[2])*0.5
    simUI.setSliderValue(ui,1,100*(speed-minMaxSpeed[1])/(minMaxSpeed[2]-minMaxSpeed[1]))
end

function sysCall_sensing()

end 

local function locate(table, handle, place, sensPlace) --My locate function, used to determine the location of a person who is sensed
    uniqueIndicator = 0 --The unique indicator is used to make sure I dont add the same people more than once
    for k,v in pairs(table) do 
        if k == handle then --I can tell if a person is unique based on their unique handle
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

function speedChange_callback(ui,id,newVal)
    speed=minMaxSpeed[1]+(minMaxSpeed[2]-minMaxSpeed[1])*newVal/100
end

function sysCall_actuation()
    local currentTime = sim.getSimulationTime()
    nose=sim.readProximitySensor(sensorNose)
    right=sim.readProximitySensor(sensorRight)
    closeRight=sim.readProximitySensor(sensorCloseRight)
    closeLeft=sim.readProximitySensor(sensorCloseLeft)
    person, distance, place, handle=sim.handleProximitySensor(personSensor)
    sensorPosition = sim.getObjectPose(personSensor, -1) --Getting all of my sensors in
    
    if (backUntilTime>sim.getSimulationTime()) then --If the back until time has been added, we will back up until the simulation time has again passed it
        sim.setJointTargetVelocity(leftMotor,-speed/1.25)
        sim.setJointTargetVelocity(rightMotor,0)
    elseif (closeRight > 0 or closeLeft > 0) then --We back up if any of the small wheel sensors see anything
        backUntilTime=sim.getSimulationTime()+1
    elseif (nose > 0) then --If the nose sees something, we turn left
        sim.setJointTargetVelocity(leftMotor,0)
        sim.setJointTargetVelocity(rightMotor,speed) 
    elseif (right == 0) then --If the right sensor sees nothing, we turn right
        sim.setJointTargetVelocity(leftMotor,speed)
        sim.setJointTargetVelocity(rightMotor,speed/5)
    else --Otherwise, we go straight
        sim.setJointTargetVelocity(leftMotor,speed)
        sim.setJointTargetVelocity(rightMotor,speed)
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
