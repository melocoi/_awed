-- _awed 
--
--  into a state
--
-- a timbre 
-- dismantled
-- repurposed
-- & relayed
--
--                         ululo
--        harmonic aggregator
--                         v1.03

--///////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////
--///////////////////////////////////////////////////////////////////////////////////////////////////////////

  
engine.name = 'Sawed'

-- extras
s = require 'sequins'
MusicUtil = require("musicutil")

sft = include('lib/SoftSeas')
parms = include('lib/arams')


-- load scales from MusicUtil
scale_names = {}
for i = 1, #MusicUtil.SCALES do
  table.insert(scale_names, MusicUtil.SCALES[i].name)
end

-- load just Intonation table



justTab = {
  { name = "normal", 
    intervals = { 1/1, 16/15, 9/8, 6/5, 5/4, 4/3, 45/32, 3/2, 8/5, 5/3, 16/9, 15/8, 2/1 }},
  { name = "Ptolemy",
    intervals = {1/1, 16/15, 9/8, 6/5, 5/4, 4/3, 45/32, 3/2, 8/5, 5/3, 9/5, 15/8, 2/1 }},
  { name = "overtones",
    intervals = {1/1, 17/16, 9/8, 19/16, 5/4, 21/16, 11/8, 3/2, 13/8, 27/16, 7/4, 15/8, 2/1 }},
  { name = "undertones",
    intervals = { 1/1, 16/15, 8/7, 32/27, 16/13, 4/3, 16/11, 32/21, 8/5, 32/19, 16/9, 32/17, 2/1 }},
  { name = "tocantish Red",
    intervals = {1/1, 267/250, 333.333/250, 365.85/250, 384.61/250, 500/250, 535.71/250, 555.55/250, 731.70/250, 769.23/250, 833.33/250, 1071.42/250, 1111.11/250 }},
  { name = "tocantish Green",
    intervals = {1/1, 220.58/200, 272.72/200, 300/200, 319.14/200, 400/200, 441.17/200, 454.54/200, 600/200, 638.29/200, 681.81/200, 882.35/200, 909.09/200}}
}

justI = justTab[1].intervals

just_names = {}
for i = 1, #justTab do
  table.insert(just_names, justTab[i].name)
end

-- engine setup
mults = {1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/7, 1/8} -- uTone series for short saws/percussive rhythm


root = {} -- E minor scale Frequencies, overwritten by scale param
r = root[1] -- select root of scale to start
ry = 1
rootFreq = 60
notes = {} -- table for notes in scale, used for quantization funcions
notes_ratios = {}
notes_nums = {}
notes_freqs = {}
interval = 1
thisNote = 1
temperament = {"JI","TET"}

-- various tables
filtMax = 5000 -- initial value, overwritten below
--steps = {} 
izz = {} -- table for led intensity clock
tT = {} -- table of selected harmonics
tM1 = {} -- table for mutator 1 notes
tM2 = {} -- table for mutator 1 notes

-- cconnecting grid and checking if it is 8 or 16 columns (for X axis) 
g = grid.connect()
if g.device == nil then
  columns = 0
else
  columns = g and g.device.cols
end

XoffSet = 0
gPage = 1 -- default start page if < 16 columns (page 0 and page 1)
--adding softcut stuff
vol = 1
rec = 1.0
pre = 0.8
rte = 1
rteOff = 0
rteQuant = 1.0
newRate = 1.0
low = 1245 -- for low pass filter
tapeLength = 22
lStrt = 1 -- loop start
lEnd = 22  -- loop End/Length
newLow = 1245
dAmp = 1 -- discombobulator volume
dbTime = 2
tapeWobble = 1
wobRate = 12

-- for Engine
rq = 0.01
amp = 1.5
ampFac = 0.3
dTune = 1
driftSpeed = 0.125
driftSpread = 0.3
driftStart = 0
deviate = 1
--for screen
scX = 0
scY = 0
scXp = 0
scYp = 0
drawRec = true
menu = false
z1 = false
lowOff = 1



------------------------------------------------
------------------------------------------------
--- for mutator1 softcut
mutate = true
mPos = 1
mRte = rte/2
fin = false
rstChnc = 0.7
revChnc = 0.5
micChnc = 0.9
pan1 = 1
mutLvl1 = 1

m1 = metro.init()
m1.time = 2
m1.event = function()
  
  if mutate then
    m1.time = math.random()+math.random(1,(lEnd-lStrt))
    mPos = math.random()+math.random(1,(lEnd-lStrt))
    local newNote = table.randFrom(tM1)
   
     if newNote ~= nil then
        MnewRate = justI[notes_nums[newNote]]/(4*math.random(2))
      else
        MnewRate = 0
      end
    num = math.random() >= revChnc and 1 or -1
    MnewRate = MnewRate * num * newRate
    pan1 = (math.random(40,80)/100) * num
    sft.updateSlew(3,m1.time*3)
    sft.mutator(3,m1.time*3,MnewRate,((math.random(90,175)/100)*mutLvl1),pan1)
    softcut.position(3,mPos)
    local rando = math.random()
    if rando > micChnc then
      local newStart = math.random(1,lEnd)
      local newDur = lEnd - math.random(newStart,lEnd)
      softcut.loop_start(3,newStart)
      softcut.loop_end(3,newStart+newDur)
      --print(newStart, newStart+newDur)
    else
      softcut.loop_start(3,1)
      softcut.loop_end(3,lEnd)
    end
    mutate = false
   
  else
    sft.mutator(3,m1.time*3,MnewRate,0,pan1*-1)
    fin = true
  end
  
  if fin then
    local rest = math.random()
    
    if rest > rstChnc then
      m1.time = 0.1+math.random(1,lEnd)
      --print("resting")
    else
      fin = false
      mutate = true
    end
  end
  
  --print(mutate)
end
--------------------------------------------
--------------------------------------------

------------------------------------------------
------------------------------------------------
--- for mutator2 softcut
mutate2 = true
mPos2 = 1
mRte2 = rte/2
fin2 = false
rstChnc2 = 0.5
revChnc2 = 0.5
micChnc2 = 0.9
pan2 = -1
mutLvl2 = 1

m2 = metro.init()
m2.time = 2
m2.event = function()
  
  if mutate2 then
    m2.time = math.random()+math.random(1,(lEnd-lStrt))
    mPos2 = math.random()+math.random(1,(lEnd-lStrt))
    local newNote = table.randFrom(tM2)
   
      if newNote ~= nil then
        MnewRate2 = justI[notes_nums[newNote]]/(2*(math.random(2)*2))
      else
        MnewRate2 = 0
      end
      
    num2 = math.random() >= revChnc2 and 1 or -1
    pan2 = (math.random(70,100)/100) * num2
    MnewRate2 = MnewRate2 * num2
    sft.updateSlew(4,m2.time*3)
    sft.mutator(4,(m2.time*6),MnewRate2,((math.random(60,100)/100)*mutLvl2),pan2)
    softcut.position(4,mPos2)
    local rando = math.random()
    if rando > micChnc2 then
      local newStart = math.random(1,lEnd)
      local newDur = lEnd - math.random(newStart,lEnd)
      softcut.loop_start(4,newStart)
      softcut.loop_end(4,newStart+newDur)
      --print(newStart, newStart+newDur)
    else
      softcut.loop_start(4,1)
      softcut.loop_end(4,lEnd)
    end
    
    mutate2 = false
   
    
  else
    sft.mutator(4,(m2.time*3),MnewRate2,0,pan2*-1)
    fin2 = true
  end
  
  if fin2 then
    local rest = math.random()
    
    if rest > rstChnc2 then
      m2.time = 0.1+math.random(1,lEnd)
      --print("resting")
    else
      fin2 = false
      mutate2 = true
    end
  end
  
  --print(mutate2)
end
--------------------------------------------
--------------------------------------------

-- initialize values
function init()
 
 
 -- setup grid lighting
 
  for i = 1,72 do
    table.insert(izz,3) 
  end
  
  tT[1] = 1
  
  
  -- need to check for which grid, and adjust accordigly
 
  if columns < 16 and gPage == 1 then
    XoffSet = 8
  elseif columns == 16 then
    gPage = 0
  end
    
  
  initKB()
  
  
  
  -- start the clocks
  
  countDraw = clock.run(drawer)
  countWobb= clock.run(rteWobb)
  
  
  --adding softcut stuff
  sft.init()
  --adding params
  parms.init()
  
  --build_scale() -- builds initial scale
  build_Root(params:get("rootFreq"))
  m1:start()
  m2:start()
  r = root[1]
  loadKBawed()
   if g.device == nil then
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("no grid connected!!!!!!!!!!!!!!!!!!!!!!!")
    print("this script will not work completely")
    print("please connect a grid-like device")
    print("at your earliest conveniance")
    print("thank you")
    print("but you can still use audio inputs")
    print("and it might sound kind of cool")
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    --columns = 0
  end
end

function initKB()
  g:led(13 - XoffSet,1,15)
  g:led(12 - XoffSet,1,15)
  g:led(12 - XoffSet,8,1)
  loadLED(12 - XoffSet,1,1)
  loadMutator1(11 - XoffSet,1)--init Mutator 1
  loadMutator1(11 - XoffSet,3)--with shell voicing
  loadMutator1(11 - XoffSet,6)--maj7 chord
  loadMutator2(10 - XoffSet,1)--init Mutator 2
  loadMutator2(10 - XoffSet,3)--with shell voicing
  loadMutator2(10 - XoffSet,7)--maj7 chord
end

function setRstChnc()
  rstChnc =  (100 - params:get("rstChnc1") )/100
  rstChnc2 = (100 - params:get("rstChnc2") )/100
end

function setRevChnc()
  revChnc =  (params:get("revChnc1") )/100
  revChnc2 = (params:get("revChnc2") )/100
end

function setMicChnc()
  micChnc =  (100 - params:get("micChnc1") )/100
  micChnc2 = (100 - params:get("micChnc2") )/100
end

function setMutateLevel()
  mutLvl2 = params:get("mutLvl2")/100
  mutLvl1 = params:get("mutLvl1")/100
end

function setLoop()
  lStrt = params:get("lStrt")
  lEnd = params:get("lEnd")+lStrt
  sft.sft_loop_length(1,lStrt,lEnd)
  sft.sft_loop_length(2,lStrt,lEnd)
end

function setSlew()
  softcut.rate_slew_time(1,params:get("rateSlew"))  
  softcut.rate_slew_time(2,params:get("rateSlew"))  
end

function build_Root(R)
  rootFreq = R
  print("ROOT!!!!")
  build_scale()
end

function build_scale()
  
  justI = justTab[params:get("ratios")].intervals
  print(justTab[params:get("ratios")].name)
  notes_nums = MusicUtil.generate_scale_of_length(1, params:get("scale"), 32) -- builds scale
  
  notes_freq = {}
  
  -- creates a list of frequencies based on rootFreq
  for i = 1, #notes_nums-1 do
    --check if JI or ET 
    if JI then
      interval = justI[notes_nums[i]]
    else
      interval = 2 ^ ((notes_nums[i]-1) / 12)
    end
    notes_freq[i] = rootFreq * interval
  end
  
  root = notes_freq
  r = root[ry]
  
  notes = MusicUtil.generate_scale_of_length(MusicUtil.freq_to_note_num(r), params:get("scale"), 28)
  drones = notes_freq
  filtMax = MusicUtil.note_num_to_freq(notes[#notes])
  low=filtMax
end


-- quantizer based on current scale from FREQ to NOTE NUMBER
function quantize_note(freq)
  local note_num= MusicUtil.freq_to_note_num(freq)
  local new_note_num
  local new_note_freq
  for i=1,#notes-1,1 do
    if note_num >= notes[i] and note_num <= notes[i+1] then
      if note_num - notes[i] < notes[i+1] - note_num then
        new_note_num = notes[i]
      else
        new_note_num = notes[i+1]
      end
      break
    end
  end

  if new_note_num == nil then
    if note_num < notes[1] then
      new_note_num = notes[1]
    else
      new_note_num = notes[#notes]
    end
  end
  new_note_freq = MusicUtil.note_num_to_freq(new_note_num)
  return new_note_freq
end

--quantizer based on certain scale from NOTE NUMBER to RATIO
function quantize_interval(note_num)
  local new_note_num
  for i=1,#notes-1,1 do
    if note_num >= notes[i] and note_num <= notes[i+1] then
      if note_num - notes[i] < notes[i+1] - note_num then
        new_note_num = notes[i]
      else
        new_note_num = notes[i+1]
      end
      break
    end
  end

  if new_note_num == nil then
    if note_num < notes[1] then
      new_note_num = notes[1]
    else
      new_note_num = notes[#notes]
    end
  end
  
  return new_note_num
end


-- which grid key is pressed
g.key = function(x,y,z)
  
  if z1 and z == 1 then
    if columns < 16 then -- do we have a smaller grid????
      -- add grid page switch here?????
      print("grid 64!!!!")
      if gPage == 1 then
        gPage = 0
        XoffSet = 0
      else
        gPage = 1
        XoffSet = 8
      end
      loadKBawed()
    end
    g:refresh()
    -- create function to build specific page. 
  else
    if columns < 16 then -- do we have a smaller grid????
      x = x + XoffSet
    end
    --print(x)
    keyboardAwed(x,y,z)
  end
end



function keyboardAwed(x,y,z)

 if z == 1 then 
    
    loadLED(x,y,z)
    
    if x < 9 then
      playSawed(x ,y)
      --print('played')
    end
    
    if x == 9 then
      loadDiscob(x ,y)
    end
     
    if x == 10 then
      loadMutator2(x ,y)
    end
    
    if x == 11 then
      loadMutator1(x,y)
    end
 
    
    if x > 12 then
      loadHarms(x ,y)
    end
    
  end
  
 if x == 12  and y < 8 then
      --loadLED(x,y,z)
     if z == 1 then
      r = root[y]
      sT = util.time()
     elseif z==0 then
      eT = util.time()
      teT = eT-sT
      if teT > 1 then
        sft.rteOffset(y)
      end
     end
 end

  if x == 12  and y == 8 then
    if z == 1 then
      
      sT = util.time()
    elseif z==0 then
      eT = util.time()
      teT = eT-sT
      if teT > 1 then
         bLong = false
        bDrone = true
        g:led(x- XoffSet,y,15)
        print(bDrone)
      end
    end
  end

end

function loadKBawed()
  g:all(0)
  for i = 1,64 do
    table.insert(izz,3) 
  end
  iz = 0
  if gPage == 1 then
  
  else
    for x = 1 , 8 do
      for y = 1, 8 do
        iz = iz + 1
        g:led(x,y,izz[iz])
        
      end
    end
     print('loaded sawed')
  end
 
-- load mutator1
  for x = 10 , 12  do
    if x == 10  then
      for y = 1 , 8 do
        if tM2[y] == nil then
          g:led(x - XoffSet,y,2)
        elseif tM2[y] == y then
          g:led(x - XoffSet,y,15)
        end
      end
     print('loaded mutator1')
    end
 
    if x == 11 then
      for y = 1 , 8 do
        if tM1[y] == nil then
          g:led(x - XoffSet,y,2)
        elseif tM1[y] == y then
          g:led(x - XoffSet,y,15)
        end
      end
      print('loaded mutator2')
    end
  
-- load rootNote and bLong
    if x == 12  then
      for y=1,8 do
        if y == 8 then
          if bLong then
            g:led(x - XoffSet,y,8)
          else
            g:led(x - XoffSet,y,1)
          end
        
        elseif r == root[y] then
          g:led(12 - XoffSet,y,15)
        else
          g:led(12 - XoffSet,y,3)
        end
      end
       print('loaded root')
    end
 
end
  --load harmonics
  isz = 0
  for x = 13, 16 do
    for y = 1,8 do
      isz = isz + 1
      if tT[isz] == nil then
        g:led(x - XoffSet,y,0)
      elseif tT[isz] == isz then
        g:led(x - XoffSet,y,15)
      end
    end
  end
  print('loaded harmonics')
end



-- launch synthesizers 
function playSawed(x,y) 
  
  p = math.random()*2-1  --panning
    
 -- call note
  nRand = table.randFrom(tT)
  if nRand == nil then
    nRand = 1
  end
  
  n = r*nRand
  if n>1200 then
    n= n/math.random(1,4)
  end
  
  atk = x+y
  rel = x*y
  sus = x/2
  
  if bLong then
    freq = n
    rqmin = 1 * rq
    rqmax = 5 * rq -- was 30
    detuned = 0.2 * dTune
    amp = ((1 - (nRand/32))/2 + 0.1)*0.5
  elseif bDrone then
    freq = r * y
    atk = x+x
    rel = x*x
    sus = x/2
    rqmin = 1 * rq
    rqmax = 5 * rq
    n = drones[nRand]
    
    amp = 0.7 --((1 - (nRand/32))/2 + 0.1)*0.5
  else
    freq = mults[y]*(x*x)
    rqmin = 0.7 * rq
    rqmax = 0.9 * rq
    detuned = 1 * dTune
    amp = util.clamp((ampFac/rq)/10,0.4,2)
  end
  rqmin = util.clamp(rqmin,0.01,5)
  rqmax = util.clamp(rqmax,0.01,5)
  
  local newSpeed = math.random()*((driftSpeed *1.25) - driftSpeed) + driftSpeed
  --set up synth and sound
  engine.atk(atk)
  engine.rel(rel)
  engine.sus(sus)
  engine.rqmin(rqmin)
  engine.rqmax(rqmax)
  engine.freq(freq)
  engine.cfmin(n)
  engine.cfmax(n*1.001)
  engine.driftStart(p)
  engine.driftSpeed(newSpeed)
  engine.detune(detuned)
  engine.amp(amp)
  engine.hz(1)
  --print(n)
end


function loadLED(x,y,z)
  
-- launch saws into the ether  
  if gPage == 1 then
  
  else
    iz = 0
      for ix = 1,8 do
        
          for iy = 1,8 do
              
              iz = iz + 1
              
              if ix == x and iy == y then
                if bDrone then
                  izz[iz] = math.floor((x*x)+x+x+(x/2))
                else
                  izz[iz] = math.floor((x*y)+x+y+(x/2))
                end
                g:led(ix,iy,izz[iz])
    
              elseif izz[iz] > 1 and z ~= 1 then
                izz[iz] = izz[iz]-1
                g:led(ix,iy,izz[iz])
              end
         end
      end
    end
-- root note selector    
  if x == 12 and y < 8 then
    for iy = 1,7 do
      g:led(x- XoffSet,iy,3)
    end
    ry = y
    r = root[y]
    g:led(x - XoffSet,y,15)
 --[[ if z == 1 then
      
      sT = util.time()
     elseif z==0 then
      eT = util.time()
      tT = eT-sT
      if tT > 1 then
        sft.rteOffset(y)
      end
     end]]
  end

-- flip long tones
  if x == 12 and y == 8 then
    
    if bLong then
      bLong = false
      bDrone = false
      g:led(x- XoffSet,y,1)
    else
      bLong = true
      bDrone = false
      g:led(x- XoffSet,y,8)
    end
    print(bDrone)
    
  end 
  
-- set discomb
  if x == 9 then
    if y == discobC then
      g:led(x- XoffSet,y,0)
       for iy = 1,8 do
      g:led(x- XoffSet,iy,0)
       end
    else
      for iy = 1,8 do
        g:led(x- XoffSet,iy,0)
      end
      
      for iy = 1,y do
        g:led(x- XoffSet,iy,15)
      end
    end
    
  end
    
-- refresh grid states
  g:refresh() 
end


function loadDiscob(x,y)

  if discobC == y then
    discobC = 0 
  else
    discobC = y
  end

end

function loadHarms(x,y)
  
iz = 0
    for ix = 13,16 do
      
        for iy = 1,8 do
            
            iz = iz + 1
            
            if ix == x and iy == y then
              if tT[iz] == nil then
                tT[iz] = iz
                g:led(x- XoffSet,y,15)
              elseif tT[iz] == iz then
                --print(iz)
                tT[iz] = nil
                g:led(x- XoffSet,y,0)
              end
              
            end
          
        end
    end
      
-- refresh grid states
  g:refresh() 
end

function loadMutator1(x,y)

iz = 0
    
  for iy = 1,8 do
      
      iz = iz + 1
      
      if iy == y then
        if tM1[iz] == nil then
          tM1[iz] = iz
          g:led(x- XoffSet,y,15)
        elseif tM1[iz] == iz then
          --print(iz)
          tM1[iz] = nil
          g:led(x- XoffSet,y,2)
        end
        
      end
    
  end

-- refresh grid states
  g:refresh() 
end

function loadMutator2(x,y)

iz = 0
    
  for iy = 1,8 do
      
      iz = iz + 1
      
      if iy == y then
        if tM2[iz] == nil then
          tM2[iz] = iz
          g:led(x- XoffSet,y,15)
        elseif tM2[iz] == iz then
          --print(iz)
          tM2[iz] = nil
          g:led(x- XoffSet,y,2)
        end
        
      end
    
  end

-- refresh grid states
  g:refresh() 
end

function table.randFrom( t )
    local choice 
    local n = 0
    for i, o in pairs(t) do
        n = n + 1
        if math.random() < (1/n) then
            choice = o      
        end
    end
    return choice 
end


------------------------------------
------------------------------------
------CLOCKERS!!!!!!----------------

-- clock for led intensity
mCount = metro.init()
mCount.time = 1
mCount.event = function()
    loadLED()
end
mCount:start()

-- clock for screen redraw calls
function drawer()
  while true do 
    clock.sync(1/2)
    menuCheck()
    redraw()
  end
end

-- clock for tape head wobble
function rteWobb()
  while true do 
    clock.sync(math.random(1,wobRate))
    softcut.rate(1,calcRteWobble())
    softcut.rate(2,calcRteWobble())
    softcut.rate(5,calcRteWobble())
    softcut.rate(6,calcRteWobble())
  end
end

------------------------------------
------------------------------------
-- a few utilities
---------------------------------------------
---------------------------------------------
-- check if returned from menu level
function menuCheck()
  if _menu.mode then
          menu = true
  else
      if menu then
        drawRec = true
        menu = false
      end
  end  
end

-- calculate tape head wobble rate
function calcRteWobble()
  -- TODO
  -- create linlin that goes from no tape wobble to 200% tape wobble
  local noWob = newRate+rteOff
  local Wobble = (math.random(940,1000)/1000) 
  Wobble = util.linlin(0,2,1,Wobble,tapeWobble)
  rteWobble = Wobble * newRate + rteOff
  --rteWobble = rteWobble * tapeWobble
  --print(Wobble)
  return rteWobble
end

-- render recording rectangle for screen to display rate of tape/softcut
function calcRect(r)
  screen.rect(0,0+((64-(64*r))/2),128, 64*r)
end


------------------------------------------------------------------
------------------------------------------------------------------
----------------- ___________________ ----------------------------
-----------------|                   |----------------------------
-----------------|   /\    /\  /\    |----------------------------
-----------------|  /  \  /  \/  \   |----------------------------
-----------------| /    \/        \  |----------------------------
-----------------|___________________|----------------------------
----------------- draw screen         ----------------------------
------------------------------------------------------------------
------------------------------------------------------------------

function redraw()
  
--this will draw restangle for Rec level representation
  if drawRec then
    screen.level(math.floor(rec*15))
    calcRect(rte)
    screen.fill()
    drawRec = false
  end
  
--drawing random lines because it looks cool
  scX = math.random(1,128)
  scY = math.random(1,64)
  screen.move(scXp,scYp)
  screen.line_width(10*rq+0.1)
  screen.line(scX,scY)
  brite = math.random(4,13)
  screen.level(brite)
  screen.stroke()
  scXp = scX
  scYp = scY
  
--drawing circle for Pre level representation  
  screen.level(brite-4)
  size = (pre*100)/2+1
  radi = math.random(math.floor(size*lowOff+1),math.floor(size+1))
  screen.circle(128/2,64/2,radi,20,45)
  screen.fill()
  screen.level(math.floor(vol*15))
  screen.circle(128/2,64/2,math.floor(size*lowOff-1),20,45)
  screen.fill()
  screen.circle(128/2,64/2,size)
  
  screen.update()
end

-- adjust parameter with interface:::TODO create functions to handle the data changes. More versatile??
function enc(n,d)
  
  if n==2 and z1 then
    sft.sft_enc_rec(d)
    
  elseif n==2 then
    rq = util.clamp(rq+d/100,0.01,1)
    redraw()
    --print(rq)
  elseif n==3 and z1 then
    sft.sft_enc_pre(d)
   
  elseif n==3 then
    sft.sft_enc_filt(d)
  
  elseif n==1 and z1 then
    vol = util.clamp(vol+d/100,0.01,1)
    softcut.level(1,vol)
    softcut.level(2,vol)
    redraw()
    
  elseif n==1 then
    sft.sft_enc_rte(d)
    
  end
  
end


function key(n,z)
  if n==2 and z==1 then
    
    
    sT = util.time()
  elseif n==2 and z==0 then
    eT = util.time()
    teT = eT-sT
    if teT > 1 then
      sft.resetLoop()
      print("clear loop")
    else
      softcut.query_position(1)
    end
    
  elseif n==3 and z==1 then
    
    
  
   sT = util.time()
  elseif n==3 and z==0 then
    eT = util.time()
    teT = eT-sT
    if teT > 1 then
      softcut.buffer_clear()
      print("cleared buffers")
    else
      softcut.query_position(2)
    end
  
  elseif n==1 and z==0 then
   
    z1 = false
    
  elseif n==1 and z==1 then
    
    z1 = true
    print("z1",z1)
  end
  
  -- draw REC level
  screen.clear()
  screen.level(math.floor(rec*15))
  calcRect(rte)
  screen.fill()
  redraw()
  
  
end


