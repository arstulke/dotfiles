{
  config,
  pkgs,
  lib,
  ...
}: let
  basePath = "/opt/3d-printer-data";
  moonrakerPort = 7125;
  fluiddPort = 8081;
in {
  options.corsDomains = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [
      "http://localhost:8081"
    ];
    description = "List of CORS domains for Moonraker. Changing this may require restarting Moonraker manually.";
  };

  options.trustedClients = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [
      "127.0.0.0/8"
      "FE80::/10"
      "::1/128"
    ];
    description = "List of trusted client IPs for Moonraker. Changing this may require restarting Moonraker manually.";
  };

  config = cfg: {
    # Klipper: Server for low-level comms with 3D printer Klipper firmware
    services.klipper = {
      enable = true;

      settings = {
        printer = {
          kinematics = "cartesian";
          max_velocity = 300;
          max_accel = 1000;
          max_z_velocity = 20;
          max_z_accel = 100;
        };
        mcu.serial = "/dev/ttyUSB0";
        display = {
          lcd_type = "hd44780";
          rs_pin = "PA3";
          e_pin = "PA2";
          d4_pin = "PD2";
          d5_pin = "PD3";
          d6_pin = "PC0";
          d7_pin = "PC1";
          up_pin = "PA1";
          analog_range_up_pin = "9000, 13000";
          down_pin = "PA1";
          analog_range_down_pin = "800, 1300";
          click_pin = "PA1";
          analog_range_click_pin = "2000, 2500";
          back_pin = "PA1";
          analog_range_back_pin = "4500, 5000";
        };

        stepper_x = {
          step_pin = "PD7";
          dir_pin = "PC5";
          enable_pin = "!PD6";
          microsteps = 16;
          rotation_distance = 32;
          endstop_pin = "^!PC2";
          position_endstop = -33;
          position_min = -33;
          position_max = 220;
          homing_speed = 50;
        };
        stepper_y = {
          step_pin = "PC6";
          dir_pin = "PC7";
          enable_pin = "!PD6";
          microsteps = 16;
          rotation_distance = 32;
          endstop_pin = "^!PC3";
          position_endstop = -14;
          position_min = -14;
          position_max = 220;
          homing_speed = 50;
        };
        stepper_z = {
          step_pin = "PB3";
          dir_pin = "!PB2";
          enable_pin = "!PA5";
          microsteps = 16;
          rotation_distance = 8;
          endstop_pin = "^!PC4";
          position_min = -5;
          position_max = 240;
          homing_speed = 20;

          # may be optimized by calibration procedure
          position_endstop = -3.100;
        };

        extruder = {
          step_pin = "PB1";
          dir_pin = "PB0";
          enable_pin = "!PD6";
          microsteps = 16;
          rotation_distance = 33.600;
          nozzle_diameter = 0.400;
          filament_diameter = 1.750;
          heater_pin = "PD5";
          sensor_type = "ATC Semitec 104GT-2";
          sensor_pin = "PA7";
          min_temp = 0;
          max_temp = 250;

          # may be optimized by calibration procedure
          control = "pid";
          pid_kp = 21.727;
          pid_ki = 0.947;
          pid_kd = 124.660;
        };
        heater_bed = {
          heater_pin = "PD4";
          sensor_type = "ATC Semitec 104GT-2";
          sensor_pin = "PA6";
          min_temp = 0;
          max_temp = 130;

          # may be optimized by calibration procedure
          control = "pid";
          pid_kp = 69.898;
          pid_ki = 1.596;
          pid_kd = 765.383;
        };

        fan.pin = "PB4";

        virtual_sdcard.path = "/var/lib/moonraker/gcodes";
        pause_resume = {};

        "gcode_macro START_PRINT".gcode = "
        {% set BED_TEMP = params.BED_TEMP|default(60)|float %}
        {% set EXTRUDER_TEMP = params.EXTRUDER_TEMP|default(190)|float %}
        # Use absolute coordinates
        G90
        # Reset the G-Code Z offset (adjust Z offset if needed)
        SET_GCODE_OFFSET Z=0.0
        # Home the printer
        G28
        # Move the nozzle near the bed
        G1 Z5 F3000
        # Move the nozzle very close to the bed
        G1 Z0.15 F300
        # Set bed to temperature
        M140 S{BED_TEMP}
        # Set nozzle to temperature
        M104 S{EXTRUDER_TEMP}
        # Wait for bed to reach temperature
        M190 S{BED_TEMP}
        # Wait for nozzle to reach temperature
        M109 S{EXTRUDER_TEMP}
      ";

        "gcode_macro END_PRINT".gcode = "
        # Turn off bed, extruder, and fan
        M140 S0
        M104 S0
        M106 S0
        # Move print head
        G91 ;relative positioning
        G1 E-1 F300  ;retract the filament a bit before lifting the nozzle, to release some of the pressure
        G1 Z+0.5 E-5 X-20 Y-20 F9000 ;move Z up a bit and retract filament even more
        G28 X0 Y0 ;move X/Y to min endstops, so the head is out of the way
        G1 Y150 F5000 ;move completed part out
        G90
        # Disable steppers
        M84
      ";

        "gcode_macro CANCEL_PRINT".rename_existing = "CANCEL_PRINT_BASE";
        "gcode_macro CANCEL_PRINT".gcode = "
        TURN_OFF_HEATERS
        CANCEL_PRINT_BASE
      ";
      };
    };

    # Moonraker: Server for interacting with Klipper
    # Notes:
    #  - Changing this may require restarting Moonraker manually.
    services.moonraker = {
      user = "root";
      enable = true;
      address = "0.0.0.0";
      settings = {
        octoprint_compat = {};
        history = {};
        authorization = {
          cors_domains = cfg.corsDomains;
          trusted_clients = cfg.trustedClients;
        };
      };
    };

    # Fluidd: UI for Moonraker
    services.fluidd = {
      enable = true;
      nginx.listen = [
        {
          addr = "0.0.0.0";
          port = fluiddPort;
        }
      ];
      nginx.locations."/webcam".proxyPass = "http://127.0.0.1:${toString fluiddPort}/stream";
    };
    services.nginx.clientMaxBodySize = "1000m";

    # Firewall
    networking.firewall = {
      allowedTCPPorts = [moonrakerPort fluiddPort];
      allowedUDPPorts = [];
    };
  };
}
