# BioBuzz fork of virtual_robot

This fork adds a BioBuzz robot (goBILDA StarterBot, mecanum drive) and a BioBuzz field to
[virtual_robot](https://github.com/Beta8397/virtual_robot), so you can test OpModes without the real robot.

## Getting started

1. Clone this repo, then run `.\setup.ps1`. It clones the robot code (`BioBuzzExample`) next to this folder.
2. Open this folder in IntelliJ (Liberica 17 Full JDK), or just run a script:
   - `.\run-sim.ps1` - on-screen virtual gamepad
   - `.\run-sim-gamepad.ps1` - USB gamepad (Logitech F310: set the back switch to **X**; press **Start+A** to make it gamepad1)

## Which OpModes show up

Like the FTC Driver Station, only OpModes from `..\BioBuzzExample` that are `@TeleOp`/`@Autonomous` and **not** `@Disabled` are listed.
The stock virtual_robot samples are not compiled. Only the BioBuzz bot is listed (`BOT_WHITELIST` in `Controller/src/virtual_robot/config/Config.java`).

## Workflow

- Robot code changes go in `BioBuzzExample`, in a feature branch, pushed to that repo as usual.
- Simulator changes go in this repo.
- To pull in updates from the original virtual_robot: `git fetch upstream` and merge `upstream/master`.
