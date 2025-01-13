MODULE bdm_spd2DO
    VAR num n_raw_spd_val;
    VAR byte n_spd_val;


    CONST num n_min_speed:=0;
    VAR num n_max_speed:=0.250;

    CONST num n_min_byte:=0;
    CONST num n_max_byte:=15;

    PROC main()

        IF OpMode()=OP_AUTO OR OpMode()=OP_MAN_TEST THEN
            n_max_speed:=3.000;
        ENDIF

        WHILE TRUE DO
            n_raw_spd_val:=AOutput(ao_TCPSpd);

            IF DOutput(do_MOn)=1 AND DOutput(do_extrudeRelSpd)=1 AND n_raw_spd_val>0 THEN
                n_spd_val:=Round(ScaleValue(n_raw_spd_val,
                    n_min_speed,
                    n_max_speed,
                    n_min_byte+1,
                    n_max_byte));
                ! Plus one to n_min_byte since we dont want to round to zero

            ELSE
                n_spd_val:=0;
            ENDIF

            SetGO go_TCPSpd,n_spd_val;
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
