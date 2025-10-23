
local ar = {}


function ar.init()
  
   -- params setup
  
  params:add_separator("awed","_awed parameters")
  
  params:add_group("Synth Engine",5)
  params:add{
    type = "number",
    id = "dTune",
    name = "detuning amount",
    min = 1,
    max = 400,
    default = 100,
    formatter = function(param)
      return (param:get().." %") end,
    action = function() dTune = params:get("dTune")/100 end
  }
  
  params:add{
    type = "number",
    id = "driftSpeed",
    name = "Drift Speed",
    min = 1,
    max = 4000,
    default = 12.5,
    formatter = function(param)
      local driftSpeed = params:get("driftSpeed")/100
    
      return (driftSpeed.."Hz") end,
    action = function() 
      local driftSpeed = params:get("driftSpeed")/100
    
      engine.driftSpeed(driftSpeed)
      end
  }
  
  params:add{
    type = "number",
    id = "driftSpread",
    name = "Drift Spread",
    min = 1,
    max = 100,
    default = 40,
    formatter = function(param)
      local dSpread = params:get("driftSpread")/100
      return (dSpread.." ") end,
    action = function() 
      driftSpread = params:get("driftSpread")/100
      engine.driftSpread(driftSpread)
      end
  }
  
  params:add{
    type = "number",
    id = "wrap",
    name = "Drift Wrap",
    min = 0,
    max = 1,
    default = 0,
    formatter = function(param)
      return (param:get().."") end,
    action = function() 
      wrap = params:get("wrap")
      engine.wrap(wrap)
      end
  }
  
  --filter deviation
  params:add{
    type = "number",
    id = "deviate",
    name = "Filter Deviation",
    min = 1,
    max = 500,
    default = 108,
    formatter = function(param)
      local dViate = params:get("deviate")/100
      dViate = util.linexp(0.01,5,0.01,500,dViate)
      dViate = math.floor(dViate * 100)/100
      return (dViate.." ") end,
    action = function() 
      deviate = params:get("deviate")/100
      deviate = util.linexp(0.01,5,0.01,500,deviate)
      deviate = math.floor(deviate * 100)/100
      engine.deviate(deviate)
      if deviate < 1 then
        engine.c3(-3)
      else
        engine.c3(3)
      end
    end
  }
  
  --lowshelf freq
  
  --lowshelf volume
  
  -- scale and tuning params
  params:add_group("Tuning",15)
  
  params:add_text("text1", "first...", "")
  params:add_text("text2", "choose a root FREQ", "")
  params:add_text("text3", "or use a note number", "")
   params:add_text("blank1", "", "")
   -- setting root notes using params
  params:add{
    type = "number",
    id = "rootFreq",
    name = "Root Frequency",
    min = 1,
    max = 90,
    default = 60,
    formatter = function(param) 
      
      return (param:get().." Hz") 
      end,
    action = function() build_Root(params:get("rootFreq")) end
  } 
  
   
  params:add{type = "number", id = "root_note", name = "Root Note",
    min =1, max = 40, default = 36, formatter = function(param) return MusicUtil.note_num_to_name(param:get(), true) end,
    action = function()
      local value = MusicUtil.note_num_to_freq(params:get("root_note"))
      build_Root(value) 
      value = value * 100
      value = math.floor(value)
      value = value / 100
     
      params:set("rootFreq",value)
      print(value)
      end
    
  } -- by employing build_scale() here, we update the scale
  params:add_text("text4", "param is set when adjusted", "")
  params:add_text("blank2", "", "")
  params:add_text("text5", "now choose", "")
  params:add_text("text6", "your temperament & scale", "")
  params:add_text("blank3", "", "")
 -- setting temperment type using params
  params:add{type = "option", id = "temperament", name = "temperament",
    options = temperament, default = 1,
    action = function() 
      
              if params:get("temperament") == "JI" then
                JI = true
                print("Just Intonation")
              else
                JI = false
                print("Unjust Intonation")
              end
      
             end
    
  } 
  
   params:add{type = "option", id = "ratios", name = "JI ratios",
    options = just_names, default = 1,
    action = function() build_scale() end}
  
  -- setting scale type using params
  params:add{type = "option", id = "scale", name = "scale",
    options = scale_names, default = 1,
    action = function() build_scale() end} -- by employing build_scale() here, we update the scale
   params:add_text("blank4", "", "")
   

  
 -- params:add_separator("loop_settings", "loop settings")
  
  params:add_group("Aggregator",8)
  scVoice = controlspec.AMP
  params:add_control("SC Amp","Main Loop Amp",scVoice)
  params:set("SC Amp",1)
  params:set_action("SC Amp", function() for i = 1, 2 do softcut.level(i,params:get("SC Amp")) end end)
  
  params:add{
    type = "number",
    id = "tapeLength",
    name = "Tape Length",
    min = 1,
    max = 160,
    default = 22,
    formatter = function(param) return (param:get().." sec") end,
    action = function() setLoop() end
  }
  
  params:add{
    type = "number",
    id = "lEnd",
    name = "loop duration",
    min = 1,
    max = 160,
    default = 22,
    formatter = function(param) return (param:get().." sec") end,
    action = function() setLoop() end
  }
  
  params:add{
    type = "number",
    id = "lStrt",
    name = "loop start",
    min = 1,
    max = 160,
    default = 1,
    formatter = function(param) return (param:get().." sec") end,
    action = function() setLoop() end
  }
  
   params:add{
    type = "number",
    id = "rateSlew",
    name = "rate slew",
    min = 0,
    max = 43,
    default = 12,
    formatter = function(param) return (param:get().." sec") end,
    action = function() setSlew() end
  }
  
  params:add{
    type = "number",
    id = "tapeWobble",
    name = "Tape Wobble",
    min = 0,
    max = 200,
    default = 100,
    formatter = function(param) return (param:get().." %") end,
    action = function() tapeWobble = params:get("tapeWobble")/100 end
  }
  
  params:add{
    type = "number",
    id = "wobRate",
    name = "Tape Wobble Rate",
    min = 1,
    max = 20,
    default = 12,
    formatter = function(param) return (param:get().."") end,
    action = function() wobRate = params:get("wobRate") end
  }
  
  scEngIn = controlspec.AMP
  params:add_control("Eng Amp","Synth Input Amp",scEngIn)
  params:set("Eng Amp",1)
  params:set_action("Eng Amp", function() audio.level_eng_cut(params:get("Eng Amp")) end)
  
  

-- adding mutator control params

  
  params:add_group("Mutator",8)
  params:add{
    type = "number",
    id = "mutLvl1",
    name = "mut 1 level",
    min = 1,
    max = 100,
    default = 100,
    formatter = function(param) return ((param:get())/100) end,
    action = function() setMutateLevel() end
  }
  
  params:add{
    type = "number",
    id = "mutLvl2",
    name = "mut 2 level",
    min = 1,
    max = 100,
    default = 50,
    formatter = function(param) return ((param:get())/100) end,
    action = function() setMutateLevel() end
  }
  
  params:add{
    type = "number",
    id = "rstChnc1",
    name = "mut 1 rest %",
    min = 1,
    max = 100,
    default = 50,
    formatter = function(param) return (param:get().." %") end,
    action = function() setRstChnc() end
  }
  
   params:add{
    type = "number",
    id = "rstChnc2",
    name = "mut 2 rest %",
    min = 1,
    max = 100,
    default = 50,
    formatter = function(param) return (param:get().." %") end,
    action = function() setRstChnc() end
  }
  
   params:add{
    type = "number",
    id = "revChnc1",
    name = "mut 1 reverse %",
    min = 1,
    max = 100,
    default = 50,
    formatter = function(param) return (param:get().." %") end,
    action = function() setRevChnc() end
  }
  
   params:add{
    type = "number",
    id = "revChnc2",
    name = "mut 2 reverse %",
    min = 1,
    max = 100,
    default = 50,
    formatter = function(param) return (param:get().." %") end,
    action = function() setRevChnc() end
  }
  
   params:add{
    type = "number",
    id = "micChnc1",
    name = "mut 1 micro %",
    min = 1,
    max = 100,
    default = 10,
    formatter = function(param) return (param:get().." %") end,
    action = function() setMicChnc() end
  }
  
   params:add{
    type = "number",
    id = "micChnc2",
    name = "mut 2 micro %",
    min = 1,
    max = 100,
    default = 10,
    formatter = function(param) return (param:get().." %") end,
    action = function() setMicChnc() end
  }

-- adding discombobulator control params


  params:add_group("Discombobulator",2)
  
  PdAmp = controlspec.AMP
  params:add_control("amplitude","amplitude",PdAmp)
  params:set("amplitude",1)
  
  PdbTime = controlspec.RATE
  params:add_control("time","time",PdbTime)
  params:set("time",2)
  
  
  print('hellooooooo')
  print('woooooooorld!')
end

return ar
