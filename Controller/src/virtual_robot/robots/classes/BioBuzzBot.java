package virtual_robot.robots.classes;

import com.qualcomm.robotcore.hardware.*;
import com.qualcomm.robotcore.hardware.configuration.MotorType;
import virtual_robot.controller.BotConfig;

/**
 * goBILDA StarterBot (2026-27) with mecanum drive, using the hardware names from the BioBuzz example OpModes.
 *
 * Drive motors: "left_front_drive", "right_front_drive", "left_back_drive", "right_back_drive". The real
 * robot's OpModes set LF and RF to REVERSE and LB and RB to FORWARD, so the back-left and front-right
 * wheels are modeled with flipped polarity relative to the simulator's usual convention.
 *
 * Mechanisms (not drawn on the field, but readable through telemetry): "intake", "launcher",
 * and continuous-rotation servos "windmillServo", "left_intake_servo", "right_intake_servo".
 */
@BotConfig(name = "BioBuzz Bot", filename = "biobuzz_bot")
public class BioBuzzBot extends MecanumPhysicsBase {

    private DcMotorExImpl intake = null;
    private DcMotorExImpl launcher = null;

    public BioBuzzBot() {
        super();
        // Index order: back_left, front_left, front_right, back_right
        wheelPolarityFlipped[0] = true;
        wheelPolarityFlipped[2] = true;
    }

    @Override
    protected void createHardwareMap() {
        super.createHardwareMap();

        // Aliases for the drive motors under the names used by the OpModes
        hardwareMap.setActive(true);
        hardwareMap.put("left_front_drive", hardwareMap.get(DcMotorEx.class, "front_left_motor"));
        hardwareMap.put("right_front_drive", hardwareMap.get(DcMotorEx.class, "front_right_motor"));
        hardwareMap.put("left_back_drive", hardwareMap.get(DcMotorEx.class, "back_left_motor"));
        hardwareMap.put("right_back_drive", hardwareMap.get(DcMotorEx.class, "back_right_motor"));
        hardwareMap.setActive(false);

        intake = new DcMotorExImpl(MotorType.Gobilda192, motorController0, 4);
        launcher = new DcMotorExImpl(MotorType.RevUltraPlanetaryOneToOne, motorController0, 5);
        hardwareMap.put("intake", intake);
        hardwareMap.put("launcher", launcher);
        hardwareMap.put("windmillServo", new CRServoImpl(720));
        hardwareMap.put("left_intake_servo", new CRServoImpl(720));
        hardwareMap.put("right_intake_servo", new CRServoImpl(720));
    }

    @Override
    public synchronized void updateStateAndSensors(double millis) {
        super.updateStateAndSensors(millis);
        intake.update(millis);
        launcher.update(millis);
    }

    @Override
    public void powerDownAndReset() {
        super.powerDownAndReset();
        intake.stopAndReset();
        launcher.stopAndReset();
    }
}
