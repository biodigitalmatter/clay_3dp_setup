MODULE tx_spd
    CONST num n_min_speed:=0;
    VAR num n_max_speed:=0.250;

    CONST num n_min_byte:=0;
    CONST num n_max_byte:=15;

    VAR signalgo go_TCPSpd;
    VAR signaldo do_extruderFwd;
    VAR signaldo do_extruderBwd;

    VAR bool b_extrudeRelSpeed;
    VAR bool b_forceExtrude;
    VAR bool b_forceRetract;

    PROC main()

        AliasIO Local_IO_0_GO1,go_TCPSpd;

        AliasIO LOCAL_IO_0_DO7,do_extruderFwd;
        AliasIO LOCAL_IO_0_DO8,do_extruderBwd;

        IF OpMode()=OP_AUTO OR OpMode()=OP_MAN_TEST THEN
            n_max_speed:=3.000;
        ENDIF

        WHILE TRUE DO
            b_forceExtrude:=DOutput(do_forceExtrude)=1;
            b_forceRetract:=DOutput(do_forceRetract)=1;
            b_extrudeRelSpeed:=DOutput(do_extrudeRelSpd)=1;

            IF NOT (b_forceExtrude OR b_forceRetract OR b_extrudeRelSpeed) THEN
                SetDO do_extruderBwd,0;
                SetDO do_extruderFwd,0;
                SetGO go_TCPSpd,0;

            ELSEIF (b_forceExtrude AND b_forceRetract) OR (b_forceExtrude AND b_extrudeRelSpeed) OR (b_forceRetract AND b_extrudeRelSpeed) THEN
                SetDO do_extruderBwd,0;
                SetDO do_extruderFwd,0;
                SetGO go_TCPSpd,0;

            ELSEIF b_forceExtrude THEN
                SetDO do_extruderBwd,0;
                SetDO do_extruderFwd,1;
                SetGO go_TCPSpd,n_max_byte;

            ELSEIF b_forceRetract THEN
                SetDO do_extruderBwd,1;
                SetDO do_extruderFwd,0;
                SetGO go_TCPSpd,n_max_byte;

            ELSE
                ! last case: b_extrudeRelSpeed = TRUE

                ! only run if robot is
                SetDO do_extruderFwd,DOutput(do_MOn);
                SetDO do_extruderBwd,0;

                SetGO go_TCPSpd,Round(ScaleValue(AOutput(ao_TCPSpd),
                        n_min_speed,
                        n_max_speed,
                        n_min_byte,
                        n_max_byte));

            ENDIF
        ENDWHILE
    ENDPROC

    FUNC num ScaleValue(num input_value,num input_min,num input_max,num output_min,num output_max)
        VAR num result;
        result:=((input_value-input_min)/(input_max-input_min))*(output_max-output_min)+output_min;
        RETURN result;
    ENDFUNC

    FUNC dionum BoolToDionum(bool value)
        VAR dionum result;
        IF value THEN
            RETURN 1;
        ENDIF
        RETURN 0;
    ENDFUNC
ENDMODULE
