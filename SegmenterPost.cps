
/**
  Copyright (C) 2012-2021 by Autodesk, Inc.
  All rights reserved.

  Dump configuration.

  $Revision: 43630 544c777fc4bca7f5c85df68e41d544f0f6234fa3 $
  $Date: 2022-02-09 22:00:08 $

  FORKID {4E9DFE89-DA1C-4531-98C9-7FECF672BD47}
*/


var previousMotion = {}
previousMotion.z = undefined
previousMotion.x = undefined
previousMotion.type = undefined


function breaker(distance, startPoint, endPoint , motion_type) {

    let sub_divided_points = []
  
    x1 = startPoint.z
    y1 = startPoint.x * 2
  
    x2 = endPoint.z
    y2 = endPoint.x * 2
  
    let slope = (y2 - y1) / (x2 - x1)
  
    if (!isFinite(slope)) {
        //Line goes straight in Y Axis
        let max_rise = y2-y1
        //subdivide now !
        let sub_divisions = max_rise / distance
        sub_divisions = Math.floor(sub_divisions)
        sub_divisions = Math.abs(sub_divisions)
        distance = max_rise / sub_divisions
  
        for(let iterations = 1 ; iterations < sub_divisions ; iterations++){
            let sub_divided_rise = distance*iterations
            let sub_divided_run = x1
  
            //determine if sub_divided_rise should be positive or negative
            sub_divided_rise = y1 < y2 ? Math.abs(sub_divided_rise) : -Math.abs(sub_divided_rise)
  
            //determine if sub_divided_run should be positive or negative
            sub_divided_run = x1 < x2 ? Math.abs(sub_divided_run) : -Math.abs(sub_divided_run)
  
            sub_divided_rise = y1 + sub_divided_rise
            sub_divided_run = x1

            let small_points = {}
            small_points.rise = sub_divided_rise;
            small_points.run = sub_divided_run;
            small_points.type = '(STRAIGHT Y) G01'//motion_type
  
            sub_divided_points.push(small_points)
        
            //writeln('(BLOCK WITH X AXIS)')
            //writeln("G00 Z "+sub_divided_run.toFixed(2) + " X "+sub_divided_rise.toFixed())
        
        
          }
  
        return sub_divided_points
    }
  
    if (slope == 0) {
        //Line goes straight in X Axis
        let max_run = x2-x1
        //subdivide now !
        let sub_divisions = max_run / distance
        sub_divisions = Math.floor(sub_divisions)
        sub_divisions = Math.abs(sub_divisions)
        distance = max_run / sub_divisions
  
        for(let iterations = 1 ; iterations < sub_divisions ; iterations++){
            let sub_divided_run = distance*iterations
            let sub_divided_rise = y1
  
            //determine if sub_divided_rise should be positive or negative
            //sub_divided_rise = y1 < y2 ? Math.abs(sub_divided_rise) : -Math.abs(sub_divided_run)
  
            //determine if sub_divided_run should be positive or negative
            sub_divided_run = x1 < x2 ? Math.abs(sub_divided_run) : -Math.abs(sub_divided_run)
  
            sub_divided_rise = y1
            sub_divided_run = x1 + sub_divided_run
  
            
            let small_points = {}
            small_points.rise = sub_divided_rise;
            small_points.run = sub_divided_run;
            small_points.type = '(STRAIGHT X )G01'//motion_type
  
            sub_divided_points.push(small_points)
        
            //writeln('(BLOCK WITH STRAIGHT Z AXIS)')
            //writeln("G00 Z "+sub_divided_run.toFixed(2) + " X "+sub_divided_rise.toFixed())
        
          }
  
        return sub_divided_points
    }
  
    else {
  
        let max_run = x2 - x1
        let max_rise = y2 - y1
        let max_hyp = Math.sqrt(Math.pow(max_run,2) + Math.pow(max_rise,2))

        //subdivide now !
        let sub_divisions = max_hyp / distance
        sub_divisions = Math.floor(sub_divisions)
        distance = max_hyp / sub_divisions
  
        let slope_in_angle = (Math.atan(slope) * 180)/Math.PI
  
        for(let iterations = 1 ; iterations < sub_divisions ; iterations++){
            let sub_divided_hyp = distance * iterations
            let sub_divided_rise = Math.sin(slope_in_angle * (Math.PI/180)) * sub_divided_hyp
            let sub_divided_run = Math.sqrt(Math.pow(sub_divided_hyp,2)-Math.pow(sub_divided_rise,2))
  
            //determine if sub_divided_rise should be positive or negative
            sub_divided_rise = y1 < y2 ? Math.abs(sub_divided_rise) : -Math.abs(sub_divided_rise)
  
            //determine if sub_divided_run should be positive or negative
            sub_divided_run = x1 < x2 ? Math.abs(sub_divided_run) : -Math.abs(sub_divided_run)
  
            sub_divided_rise = y1 + sub_divided_rise
            sub_divided_run = x1 + sub_divided_run
            
            
            let small_points = {}
            small_points.rise = sub_divided_rise;
            small_points.run = sub_divided_run;
            small_points.type = '(HYP) G01'//motion_type
  
            sub_divided_points.push(small_points)
            //writeln('(BLOCK WITH HYP)')
            //writeln("G00 Z "+sub_divided_run.toFixed(10) + " X "+sub_divided_rise.toFixed(10))
        }
        return sub_divided_points
    }
  
  }
  
  
  description = "Dumper";
  vendor = "Autodesk";
  vendorUrl = "http://www.autodesk.com";
  legal = "Copyright (C) 2012-2021 by Autodesk, Inc.";
  certificationLevel = 2;
  
  longDescription = "Use this post to understand which information is available when developing a new post. The post will output the primary information for each entry function being called.";
  
  extension = "dmp";
  // using user code page
  
  capabilities = CAPABILITY_INTERMEDIATE;
  
  allowMachineChangeOnSection = true;
  allowHelicalMoves = true;
  allowSpiralMoves = true;
  allowedCircularPlanes = undefined; // allow any circular motion
  maximumCircularSweep = toRad(1000000);
  minimumCircularRadius = spatial(0.0001, MM);
  maximumCircularRadius = spatial(0.0002, MM);
  
  // user-defined properties
  properties = {
    showParameters: {
      title      : "Show Parameter values",
      description: "If enabled, all Parameter values will be displayed",
      type       : "boolean",
      value      : true,
      scope      : "post"
    },
    showTool: {
      title      : "Show Tool values",
      description: "If enabled, all Tool values will be displayed",
      type       : "boolean",
      value      : true,
      scope      : "post"
    },
    showState: {
      title      : "Show state",
      description: "Shows the commonly interesting current state.",
      type       : "boolean",
      value      : true,
      scope      : "post"
    },
    expandCycles: {
      title      : "Expand cycles",
      description: "If enabled, unhandled cycles are expanded.",
      type       : "boolean",
      value      : true,
      scope      : "post"
    },
    showTCP: {
      title      : "Show TCP values",
      description: "If enabled, XYZ positions are shown in the Setup system.  Disable to show the coordinates in the Working Plane system",
      type       : "boolean",
      value      : false,
      scope      : "post"
    }
  };
  
  var spatialFormat = createFormat({decimals:6});
  var angularFormat = createFormat({decimals:6, scale:DEG});
  var rpmFormat = createFormat({decimals:6});
  var otherFormat = createFormat({decimals:6});
  
  var expanding = false;
  
  function toString(value) {
    if (typeof value == "string") {
      return "'" + value + "'";
    } else {
      return value;
    }
  }
  
  function dumpImpl(name, text) {
    writeln(getCurrentRecordId() + ": " + name + "(" + text + ")");
  }
  
  function dump(name, _arguments) {
    var result = getCurrentRecordId() + ": " + (expanding ? "EXPANDED " : "") + name + "(";
    for (var i = 0; i < _arguments.length; ++i) {
      if (i > 0) {
        result += ", ";
      }
      if (typeof _arguments[i] == "string") {
        result += "'" + _arguments[i] + "'";
      } else {
        result += _arguments[i];
      }
    }
    result += ")";
    writeln(result);
  }
  
  function onMachine() {
    dump("onMachine", arguments);
    if (machineConfiguration.getVendor()) {
      writeln("  " + "Vendor" + ": " + machineConfiguration.getVendor());
    }
    if (machineConfiguration.getModel()) {
      writeln("  " + "Model" + ": " + machineConfiguration.getModel());
    }
    if (machineConfiguration.getDescription()) {
      writeln("  " + "Description" + ": "  + machineConfiguration.getDescription());
    }
  }
  
  function onOpen() {
    writeln("  Post Engine Version = " + getVersion());
    writeln("  Program Name = " + programName);
    writeln("  Program Comment = " + programComment);
    dump("onOpen", arguments);
  }
  
  function onPassThrough() {
    dump("onPassThrough", arguments);
  }
  
  function onComment() {
    dump("onComment", arguments);
  }
  
  var motion_list = []
  
  function store_motion_data(type , motion_x , motion_z){
    motion = {}
    motion.x = motion_x*2
    motion.z = motion_z*1
    motion.type = type
    motion_list.push(motion)
  }
  
  
  function onSection() {
    var initialPosition = getFramePosition(currentSection.getInitialPosition());
    previousMotion.x = initialPosition.x
    previousMotion.z = initialPosition.z
    previousMotion.type = 'G00'
    store_motion_data('G0' , initialPosition.x , initialPosition.z)
  }
  
  function onSpindleSpeed() {
    dump("onSpindleSpeed", arguments);
  }
  
  function onOrientateSpindle() {
    dump("onOrientateSpindle", arguments);
  }
  
  function onParameter() {
    if (getProperty("showParameters")) {
      //dump("onParameter", arguments);
    }
  }
  
  /**
    Returns the string id for the specified movement. Returns the movement id as
    a string if unknown.
  */
  function getMovementStringId(movement, jet) {
    switch (movement) {
    case MOVEMENT_RAPID:
      return "rapid";
    case MOVEMENT_LEAD_IN:
      return "lead in";
    case MOVEMENT_CUTTING:
      return "cutting";
    case MOVEMENT_LEAD_OUT:
      return "lead out";
    case MOVEMENT_LINK_TRANSITION:
      return !jet ? "transition" : "bridging";
    case MOVEMENT_LINK_DIRECT:
      return "direct";
    case MOVEMENT_RAMP_HELIX:
      return !jet ? "helix ramp" : "circular pierce";
    case MOVEMENT_RAMP_PROFILE:
      return !jet ? "profile ramp" : "profile pierce";
    case MOVEMENT_RAMP_ZIG_ZAG:
      return !jet ? "zigzag ramp" : "linear pierce";
    case MOVEMENT_RAMP:
      return !jet ? "ramp" : "pierce";
    case MOVEMENT_PLUNGE:
      return !jet ? "plunge" : "pierce";
    case MOVEMENT_PREDRILL:
      return "predrill";
    case MOVEMENT_EXTENDED:
      return "extended";
    case MOVEMENT_REDUCED:
      return "reduced";
    case MOVEMENT_FINISH_CUTTING:
      return "finish cut";
    case MOVEMENT_HIGH_FEED:
      return "high feed";
    case MOVEMENT_DEPOSITING:
      return "depositing";
    default:
      return String(movement);
    }
  }
  
  function getToolTypeStringId(toolType) {
    switch (toolType) {
  
    case TOOL_UNSPECIFIED:
      return "TOOL_UNSPECIFIED";
    case TOOL_DRILL:
      return "TOOL_DRILL";
    case TOOL_DRILL_CENTER:
      return "TOOL_DRILL_CENTER";
    case TOOL_DRILL_SPOT:
      return "TOOL_DRILL_SPOT";
    case TOOL_DRILL_BLOCK:
      return "TOOL_DRILL_BLOCK";
    case TOOL_MILLING_END_FLAT:
      return "TOOL_MILLING_END_FLAT";
    case TOOL_MILLING_END_BALL:
      return "TOOL_MILLING_END_BALL";
    case TOOL_MILLING_END_BULLNOSE:
      return "TOOL_MILLING_END_BULLNOSE";
    case TOOL_MILLING_CHAMFER:
      return "TOOL_MILLING_CHAMFER";
    case TOOL_MILLING_FACE:
      return "TOOL_MILLING_FACE";
    case TOOL_MILLING_SLOT:
      return "TOOL_MILLING_SLOT";
    case TOOL_MILLING_RADIUS:
      return "TOOL_MILLING_RADIUS";
    case TOOL_MILLING_DOVETAIL:
      return "TOOL_MILLING_DOVETAIL";
    case TOOL_MILLING_TAPERED:
      return "TOOL_MILLING_TAPERED";
    case TOOL_MILLING_LOLLIPOP:
      return "TOOL_MILLING_LOLLIPOP";
    case TOOL_TAP_RIGHT_HAND:
      return "TOOL_TAP_RIGHT_HAND";
    case TOOL_TAP_LEFT_HAND:
      return "TOOL_TAP_LEFT_HAND";
    case TOOL_REAMER:
      return "TOOL_REAMER";
    case TOOL_BORING_BAR:
      return "TOOL_BORING_BAR";
    case TOOL_COUNTER_BORE:
      return "TOOL_COUNTER_BORE";
    case TOOL_COUNTER_SINK:
      return "TOOL_COUNTER_SINK";
    case TOOL_HOLDER_ONLY:
      return "TOOL_HOLDER_ONLY";
    case TOOL_TURNING_GENERAL:
      return "TOOL_TURNING_GENERAL";
    case TOOL_TURNING_THREADING:
      return "TOOL_TURNING_THREADING";
    case TOOL_TURNING_GROOVING:
      return "TOOL_TURNING_GROOVING";
    case TOOL_TURNING_BORING:
      return "TOOL_TURNING_BORING";
    case TOOL_TURNING_CUSTOM:
      return "TOOL_TURNING_CUSTOM";
    case TOOL_PROBE:
      return "TOOL_PROBE";
    case TOOL_WIRE:
      return "TOOL_WIRE";
    case TOOL_WATER_JET:
      return "TOOL_WATER_JET";
    case TOOL_LASER_CUTTER:
      return "TOOL_LASER_CUTTER";
    case TOOL_WELDER:
      return "TOOL_WELDER";
    case TOOL_GRINDER:
      return "TOOL_GRINDER";
    case TOOL_MILLING_FORM:
      return "TOOL_MILLING_FORM";
    case TOOL_ROTARY_BROACH:
      return "TOOL_ROTARY_BROACH";
    case TOOL_SLOT_BROACH:
      return "TOOL_SLOT_BROACH";
    case TOOL_PLASMA_CUTTER:
      return "TOOL_PLASMA_CUTTER";
    case TOOL_MARKER:
      return "TOOL_MARKER";
    case TOOL_MILLING_THREAD:
      return "TOOL_MILLING_THREAD";
    case TOOL_DEPOSITING_ELECTRIC_ARC_WIRE:
      return "TOOL_DEPOSITING_ELECTRIC_ARC_WIRE";
    case TOOL_DEPOSITING_LASER_POWDER:
      return "TOOL_DEPOSITING_LASER_POWDER";
    case TOOL_DEPOSITING_LASER_WIRE:
      return "TOOL_DEPOSITING_LASER_WIRE";
    default:
      return String(toolType);
    }
  }
  
  function getSectionTypeStringId(sectionType) {
    switch (sectionType) {
    case TYPE_MILLING:
      return "TYPE_MILLING";
    case TYPE_TURNING:
      return "TYPE_TURNING";
    case TYPE_WIRE:
      return "TYPE_WIRE";
    case TYPE_JET:
      return "TYPE_JET";
    case TYPE_ADDITIVE:
      return "TYPE_ADDITIVE";
    default:
      return String(sectionType);
    }
  }
  
  function getInsertTypeStringId(insertType) {
    switch (insertType) {
    case TURNING_INSERT_USER_DEFINED:
      return "TURNING_INSERT_USER_DEFINED";
    case TURNING_INSERT_ISO_A:
      return "TURNING_INSERT_ISO_A";
    case TURNING_INSERT_ISO_B:
      return "TURNING_INSERT_ISO_B";
    case TURNING_INSERT_ISO_C:
      return "TURNING_INSERT_ISO_C";
    case TURNING_INSERT_ISO_D:
      return "TURNING_INSERT_ISO_D";
    case TURNING_INSERT_ISO_E:
      return "TURNING_INSERT_ISO_E";
    case TURNING_INSERT_ISO_H:
      return "TURNING_INSERT_ISO_H";
    case TURNING_INSERT_ISO_K:
      return "TURNING_INSERT_ISO_K";
    case TURNING_INSERT_ISO_L:
      return "TURNING_INSERT_ISO_L";
    case TURNING_INSERT_ISO_M:
      return "TURNING_INSERT_ISO_M";
    case TURNING_INSERT_ISO_O:
      return "TURNING_INSERT_ISO_O";
    case TURNING_INSERT_ISO_P:
      return "TURNING_INSERT_ISO_P";
    case TURNING_INSERT_ISO_R:
      return "TURNING_INSERT_ISO_R";
    case TURNING_INSERT_ISO_S:
      return "TURNING_INSERT_ISO_S";
    case TURNING_INSERT_ISO_T:
      return "TURNING_INSERT_ISO_T";
    case TURNING_INSERT_ISO_V:
      return "TURNING_INSERT_ISO_V";
    case TURNING_INSERT_ISO_W:
      return "TURNING_INSERT_ISO_W";
    case TURNING_INSERT_GROOVE_ROUND:
      return "TURNING_INSERT_GROOVE_ROUND";
    case TURNING_INSERT_GROOVE_RADIUS:
      return "TURNING_INSERT_GROOVE_RADIUS";
    case TURNING_INSERT_GROOVE_SQUARE:
      return "TURNING_INSERT_GROOVE_SQUARE";
    case TURNING_INSERT_GROOVE_CHAMFER:
      return "TURNING_INSERT_GROOVE_CHAMFER";
    case TURNING_INSERT_GROOVE_40DEG:
      return "TURNING_INSERT_GROOVE_40DEG";
    case TURNING_INSERT_THREAD_ISO_DOUBLE_FULL:
      return "TURNING_INSERT_THREAD_ISO_DOUBLE_FULL";
    case TURNING_INSERT_THREAD_ISO_TRIPLE_FULL:
      return "TURNING_INSERT_THREAD_ISO_TRIPLE_FULL";
    case TURNING_INSERT_THREAD_UTS_DOUBLE_FULL:
      return "TURNING_INSERT_THREAD_UTS_DOUBLE_FULL";
    case TURNING_INSERT_THREAD_UTS_TRIPLE_FULL:
      return "TURNING_INSERT_THREAD_UTS_TRIPLE_FULL";
    case TURNING_INSERT_THREAD_ISO_DOUBLE_VPROFILE:
      return "TURNING_INSERT_THREAD_ISO_DOUBLE_VPROFILE";
    case TURNING_INSERT_THREAD_ISO_TRIPLE_VPROFILE:
      return "TURNING_INSERT_THREAD_ISO_TRIPLE_VPROFILE";
    case TURNING_INSERT_THREAD_UTS_DOUBLE_VPROFILE:
      return "TURNING_INSERT_THREAD_UTS_DOUBLE_VPROFILE";
    case TURNING_INSERT_THREAD_UTS_TRIPLE_VPROFILE:
      return "TURNING_INSERT_THREAD_UTS_TRIPLE_VPROFILE";
    default:
      return String(insertType);
    }
  }
  
  function getHolderTypeStringId(holderType) {
    switch (holderType) {
    case TURNING_INSERT_USER_DEFINED:
      return "TURNING_INSERT_USER_DEFINED";
    case HOLDER_ISO_A:
      return "HOLDER_ISO_A";
    case HOLDER_ISO_B:
      return "HOLDER_ISO_B";
    case HOLDER_ISO_C:
      return "HOLDER_ISO_C";
    case HOLDER_ISO_D:
      return "HOLDER_ISO_D";
    case HOLDER_ISO_E:
      return "HOLDER_ISO_E";
    case HOLDER_ISO_F:
      return "HOLDER_ISO_F";
    case HOLDER_ISO_G:
      return "HOLDER_ISO_G";
    case HOLDER_ISO_H:
      return "HOLDER_ISO_H";
    case HOLDER_ISO_J:
      return "HOLDER_ISO_J";
    case HOLDER_ISO_K:
      return "HOLDER_ISO_K";
    case HOLDER_ISO_L:
      return "HOLDER_ISO_L";
    case HOLDER_ISO_M:
      return "HOLDER_ISO_M";
    case HOLDER_ISO_N:
      return "HOLDER_ISO_N";
    case HOLDER_ISO_P:
      return "HOLDER_ISO_P";
    case HOLDER_ISO_Q:
      return "HOLDER_ISO_Q";
    case HOLDER_ISO_R:
      return "HOLDER_ISO_R";
    case HOLDER_ISO_S:
      return "HOLDER_ISO_S";
    case HOLDER_ISO_T:
      return "HOLDER_ISO_T";
    case HOLDER_ISO_U:
      return "HOLDER_ISO_U";
    case HOLDER_ISO_V:
      return "HOLDER_ISO_V";
    case HOLDER_ISO_W:
      return "HOLDER_ISO_W";
    case HOLDER_ISO_Y:
      return "HOLDER_ISO_Y";
    case HOLDER_OFFSET_PROFILE:
      return "HOLDER_OFFSET_PROFILE";
    case HOLDER_STRAIGHT_PROFILE:
      return "HOLDER_STRAIGHT_PROFILE";
    case HOLDER_GROOVE_EXTERNAL:
      return "HOLDER_GROOVE_EXTERNAL";
    case HOLDER_GROOVE_INTERNAL:
      return "HOLDER_GROOVE_INTERNAL";
    case HOLDER_GROOVE_FACE:
      return "HOLDER_GROOVE_FACE";
    case HOLDER_THREAD_STRAIGHT:
      return "HOLDER_THREAD_STRAIGHT";
    case HOLDER_THREAD_OFFSET:
      return "HOLDER_THREAD_OFFSET";
    case HOLDER_THREAD_FACE:
      return "HOLDER_THREAD_FACE";
    case HOLDER_BORING_BAR_ISO_F:
      return "HOLDER_BORING_BAR_ISO_F";
    case HOLDER_BORING_BAR_ISO_G:
      return "HOLDER_BORING_BAR_ISO_G";
    case HOLDER_BORING_BAR_ISO_J:
      return "HOLDER_BORING_BAR_ISO_J";
    case HOLDER_BORING_BAR_ISO_K:
      return "HOLDER_BORING_BAR_ISO_K";
    case HOLDER_BORING_BAR_ISO_L:
      return "HOLDER_BORING_BAR_ISO_L";
    case HOLDER_BORING_BAR_ISO_P:
      return "HOLDER_BORING_BAR_ISO_P";
    case HOLDER_BORING_BAR_ISO_Q:
      return "HOLDER_BORING_BAR_ISO_Q";
    case HOLDER_BORING_BAR_ISO_S:
      return "HOLDER_BORING_BAR_ISO_S";
    case HOLDER_BORING_BAR_ISO_U:
      return "HOLDER_BORING_BAR_ISO_U";
    case HOLDER_BORING_BAR_ISO_W:
      return "HOLDER_BORING_BAR_ISO_W";
    case HOLDER_BORING_BAR_ISO_X:
      return "HOLDER_BORING_BAR_ISO_X";
    case HOLDER_BORING_BAR_ISO_Y:
      return "HOLDER_BORING_BAR_ISO_Y";
    default:
      return String(holderType);
    }
  }
  
  function getCompensationModeStringId(compensationMode) {
    switch (compensationMode) {
    case TOOL_COMPENSATION_INSERT_CENTER:
      return "TOOL_COMPENSATION_INSERT_CENTER";
    case TOOL_COMPENSATION_TIP:
      return "TOOL_COMPENSATION_TIP";
    case TOOL_COMPENSATION_TIP_CENTER:
      return "TOOL_COMPENSATION_TIP_CENTER";
    case TOOL_COMPENSATION_TIP_TANGENT:
      return "TOOL_COMPENSATION_TIP_TANGENT";
    default:
      return String(compensationMode);
    }
  }
  
  function getStrategyTypeString() {
  
    var id = "";
    if (currentSection.checkGroup(STRATEGY_2D)) {id += "STRATEGY_2D ";}
    if (currentSection.checkGroup(STRATEGY_3D)) {id += "STRATEGY_3D ";}
    if (currentSection.checkGroup(STRATEGY_ROUGHING)) {id += "STRATEGY_ROUGHING ";}
    if (currentSection.checkGroup(STRATEGY_FINISHING)) {id += "STRATEGY_FINISHING ";}
    if (currentSection.checkGroup(STRATEGY_MILLING)) {id += "STRATEGY_MILLING ";}
    if (currentSection.checkGroup(STRATEGY_TURNING)) {id += "STRATEGY_TURNING ";}
    if (currentSection.checkGroup(STRATEGY_JET)) {id += "STRATEGY_JET ";}
    if (currentSection.checkGroup(STRATEGY_ADDITIVE)) {id += "STRATEGY_ADDITIVE ";}
    if (currentSection.checkGroup(STRATEGY_PROBING)) {id += "STRATEGY_PROBING ";}
    if (currentSection.checkGroup(STRATEGY_INSPECTION)) {id += "STRATEGY_INSPECTION ";}
    if (currentSection.checkGroup(STRATEGY_DRILLING)) {id += "STRATEGY_DRILLING ";}
    if (currentSection.checkGroup(STRATEGY_HOLEMILLING)) {id += "STRATEGY_HOLEMILLING ";}
    if (currentSection.checkGroup(STRATEGY_THREAD)) {id += "STRATEGY_THREAD ";}
    if (currentSection.checkGroup(STRATEGY_SAMPLING)) {id += "STRATEGY_SAMPLING ";}
    if (currentSection.checkGroup(STRATEGY_ROTARY)) {id += "STRATEGY_ROTARY ";}
    if (currentSection.checkGroup(STRATEGY_SECONDARYSPINDLE)) {id += "STRATEGY_SECONDARYSPINDLE ";}
    if (currentSection.checkGroup(STRATEGY_SURFACE)) {id += "STRATEGY_SURFACE ";}
    if (currentSection.checkGroup(STRATEGY_CHECKSURFACE)) {id += "STRATEGY_CHECKSURFACE ";}
    if (currentSection.checkGroup(STRATEGY_MULTIAXIS)) {id += "STRATEGY_MULTIAXIS ";}
    return id;
  }
  
  function getJetModeTypeString(jetMode) {
  
    switch (jetMode) {
    case JET_MODE_THROUGH:
      return "JET_MODE_THROUGH";
    case JET_MODE_ETCHING:
      return "JET_MODE_ETCHING";
    case JET_MODE_VAPORIZE:
      return "JET_MODE_VAPORIZE";
    default:
      return String(jetMode);
    }
  }
  
  function getQualityTypeString(quality) {
    if (currentSection.jetMode == JET_MODE_THROUGH) {
      switch (quality) {
      case 0:
        return "{AUTO}";
      case 1:
        return "{HIGH}";
      case 2:
        return "{MEDIUM}";
      case 3:
        return "{LOW}";
      default:
        return String(quality);
      }
    }
    return "";
  }
  
  function onMovement(movement) {
    var jet = tool.isJetTool && tool.isJetTool();
    var id;
    switch (movement) {
    case MOVEMENT_RAPID:
      id = "MOVEMENT_RAPID";
      break;
    case MOVEMENT_LEAD_IN:
      id = "MOVEMENT_LEAD_IN";
      break;
    case MOVEMENT_CUTTING:
      id = "MOVEMENT_CUTTING";
      break;
    case MOVEMENT_LEAD_OUT:
      id = "MOVEMENT_LEAD_OUT";
      break;
    case MOVEMENT_LINK_TRANSITION:
      id = jet ? "MOVEMENT_BRIDGING" : "MOVEMENT_LINK_TRANSITION";
      break;
    case MOVEMENT_LINK_DIRECT:
      id = "MOVEMENT_LINK_DIRECT";
      break;
    case MOVEMENT_RAMP_HELIX:
      id = jet ? "MOVEMENT_PIERCE_CIRCULAR" : "MOVEMENT_RAMP_HELIX";
      break;
    case MOVEMENT_RAMP_PROFILE:
      id = jet ? "MOVEMENT_PIERCE_PROFILE" : "MOVEMENT_RAMP_PROFILE";
      break;
    case MOVEMENT_RAMP_ZIG_ZAG:
      id = jet ? "MOVEMENT_PIERCE_LINEAR" : "MOVEMENT_RAMP_ZIG_ZAG";
      break;
    case MOVEMENT_RAMP:
      id = "MOVEMENT_RAMP";
      break;
    case MOVEMENT_PLUNGE:
      id = jet ? "MOVEMENT_PIERCE" : "MOVEMENT_PLUNGE";
      break;
    case MOVEMENT_PREDRILL:
      id = "MOVEMENT_PREDRILL";
      break;
    case MOVEMENT_FINISH_CUTTING:
      id = "MOVEMENT_FINISH_CUTTING";
      break;
    case MOVEMENT_EXTENDED:
      id = "MOVEMENT_EXTENDED";
      break;
    case MOVEMENT_REDUCED:
      id = "MOVEMENT_REDUCED";
      break;
    case MOVEMENT_HIGH_FEED:
      id = "MOVEMENT_HIGH_FEED";
      break;
    case MOVEMENT_DEPOSITING:
      id = "MOVEMENT_DEPOSITING";
      break;
    }
    if (id != undefined) {
      //dumpImpl("onMovement", id + " /*" + getMovementStringId(movement, jet) + "*/");
    } else {
      //dumpImpl("onMovement", movement + " /*" + getMovementStringId(movement, jet) + "*/");
    }
  }
  
  var RADIUS_COMPENSATION_MAP = {0:"off", 1:"left", 2:"right"};
  
  function onRadiusCompensation() {
    var id;
    switch (radiusCompensation) {
    case RADIUS_COMPENSATION_OFF:
      id = "RADIUS_COMPENSATION_OFF";
      break;
    case RADIUS_COMPENSATION_LEFT:
      id = "RADIUS_COMPENSATION_LEFT";
      break;
    case RADIUS_COMPENSATION_RIGHT:
      id = "RADIUS_COMPENSATION_RIGHT";
      break;
    }
    dump("onRadiusCompensation", arguments);
    if (id != undefined) {
      writeln("  radiusCompensation=" + id + " // " + RADIUS_COMPENSATION_MAP[radiusCompensation]);
    } else {
      writeln("  radiusCompensation=" + radiusCompensation + " // " + RADIUS_COMPENSATION_MAP[radiusCompensation]);
    }
  }
  
  
  
  function onRapid(_x, _y, _z) {
    //dump("onRapid", arguments);
    currentPosition = {}
    currentPosition.x = _x
    currentPosition.z = _z
    currentPosition.type = 'G0'
    writeln('G0 '+"X "+currentPosition.x*2 +" Z"+ currentPosition.z)
    
    previousMotion.x = currentPosition.x
    previousMotion.z = currentPosition.z
    previousMotion.type = currentPosition.type
    store_motion_data('G00' , _x , _z)
  }
  
  function onLinear(_x, _y, _z, feed) {
    //dump("onLinear", arguments);
    currentPosition = {}
    currentPosition.x = _x
    currentPosition.z = _z
    currentPosition.type = 'G01'
    let broken_segments = breaker(0.1 , previousMotion , currentPosition , 'G01')

    writeln('')
    writeln('G0 From-------'+'X '+(previousMotion.x*2)+'--------Z '+previousMotion.z)
    for(let counter = 0 ; counter < broken_segments.length ; counter++)
    {
        writeln(broken_segments[counter].type +" X "+broken_segments[counter].rise.toFixed(4) +" Z"+ broken_segments[counter].run)
    }
    writeln('G0 To-------'+'X '+(currentPosition.x*2)+'--------Z '+currentPosition.z)

    previousMotion.x = currentPosition.x
    previousMotion.z = currentPosition.z
    previousMotion.type = currentPosition.type
    store_motion_data('G01' , _x , _z)
  }
  
  
  function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
    dump("onCircular", arguments);
    //writeln("  direction: " + (clockwise ? "CW" : "CCW"));
    //writeln("  sweep: " + angularFormat.format(getCircularSweep()) + "deg");
    var n = getCircularNormal();
    var plane = "";
    switch (getCircularPlane()) {
    case PLANE_XY:
      plane = "(XY)";
      break;
    case PLANE_ZX:
      plane = "(ZX)";
      break;
    case PLANE_YZ:
      plane = "(YZ)";
      break;
    }
    //writeln("  normal: X=" + spatialFormat.format(n.x) + " Y=" + spatialFormat.format(n.y) + " Z=" + spatialFormat.format(n.z) + " " + plane);
    if (isSpiral()) {
      //writeln("  spiral");
      //writeln("  start radius: " + spatialFormat.format(getCircularStartRadius()));
      //writeln("  end radius: " + spatialFormat.format(getCircularRadius()));
      //writeln("  delta radius: " + spatialFormat.format(getCircularRadius() - getCircularStartRadius()));
    } else {
      //writeln("  radius: " + spatialFormat.format(getCircularRadius()));
    }
    if (isHelical()) {
      //writeln("  helical pitch: " + spatialFormat.format(getHelicalPitch()));
    }
  }
  
  function onCommand(command) {
    if (isWellKnownCommand(command)) {
      dumpImpl("onCommand", getCommandStringId(command));
    } else {
      dumpImpl("onCommand", command);
    }
  }
  
  
  const subdivided_motion_list = []
  
  
  function onSectionEnd() {
    dump("onSectionEnd", arguments);
    
    for(counter = 1 ; counter < motion_list.length ; counter++){
        /*
      subdivided_motion_list.push.apply(
        subdivided_motion_list,breaker(0.1 , motion_list[counter-1],motion_list[counter],motion_list[counter].type))
        */
    }
  
    for(counter = 0 ; counter < subdivided_motion_list.length ; counter++){
      //writeln(subdivided_motion_list.motion_type+" X"+subdivided_motion_list[counter].rise + " Z" + subdivided_motion_list[counter].run)
      //writeln(subdivided_motion_list)
    }
    
  }
  
  
  
  
  
  function onClose() {
    dump("onClose", arguments);
  }
  
