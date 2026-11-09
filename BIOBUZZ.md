# BioBuzz fork of virtual_robot

This fork adds a BioBuzz robot (goBILDA StarterBot, mecanum drive) and a BioBuzz field to
[virtual_robot](https://github.com/Beta8397/virtual_robot), so you can test OpModes without the real robot.

## Getting started

1. Clone this repo, then run `.\setup.ps1`. It clones the robot code (`BioBuzzExample`) next to this folder.
2. Open this folder in IntelliJ (any JDK 17 with JavaFX, e.g. Liberica 17 Full; `run-sim.ps1` finds it via `JAVA_HOME`, a Liberica install, or `javac` on PATH), or just run a script:
   - `.\run-sim.ps1` - on-screen virtual gamepad
   - `.\run-sim-gamepad.ps1` - USB gamepad (Logitech F310: set the back switch to **X**; press **Start+A** to make it gamepad1)

## First time in IntelliJ

The two repos must sit side by side (`workspace\virtual_robot` and `workspace\BioBuzzExample`); `setup.ps1` does this for you.
Open the `virtual_robot` folder. Your OpModes appear in the project tree under `BioBuzzExample\TeamCode\src\main\java`.

You may need to do two things once:

1. **"Project JDK is not defined"**: the project expects an SDK named `liberica-17`. Go to File > Project Structure > SDK,
   add **Liberica JDK 17 Full** (the Full build includes JavaFX; plain JDKs will not work), and name it `liberica-17`.
2. **"Unregistered VCS root detected"** (for `BioBuzzExample`): click **Add root**. This lets IntelliJ's Git panel branch and
   commit in both repos. Without it, use a terminal for the BioBuzzExample repo.

Use `.\run-sim.ps1` or `.\run-sim-gamepad.ps1` to launch the simulator. IntelliJ's own Run button compiles the stock
virtual_robot samples too, so the OpMode list will not match the Driver Station.

## Which OpModes show up

Like the FTC Driver Station, only OpModes from `..\BioBuzzExample` that are `@TeleOp`/`@Autonomous` and **not** `@Disabled` are listed.
The stock virtual_robot samples are not compiled. Only the BioBuzz bot is listed (`BOT_WHITELIST` in `Controller/src/virtual_robot/config/Config.java`).

## Workflow

- Robot code changes go in `BioBuzzExample`, in a feature branch, pushed to that repo as usual.
- Simulator changes go in this repo.
- To pull in updates from the original virtual_robot: `git fetch upstream` and merge `upstream/master`.
