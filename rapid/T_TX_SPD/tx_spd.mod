MODULE tx_spd
    CONST num SPD_COEFFICIENT:=500;

    CONST num BYTE_SPD_MAX:=127;
    CONST num BYTE_ABS_MAX:=255;

    VAR signalgo go_TCPSpd;
    VAR num spd;

    PROC main()
        ! Requires:
        ! - System output TCPSpeed as analog out: ao_TCPSpeed (in meters/s, default)
        ! - Real group output go_TCPSpeed (change this using the AliasIO below if needed)
        ! - Virtual DO: do_forceExtrude
        ! - Virtual DO: do_forceRetract
        ! - Virtual AO: ao_flowFactor (0.0 - 1.0)
        ! - Virtual AO: ao_printPtSpd (-1.0 - +1.0)
        !
        !   When ao_printPtSpd is non-zero, extrusion is active and multiplied by TCP speed and flow factor
        AliasIO Local_IO_0_GO1,go_TCPSpd;

        WHILE TRUE DO
            IF do_forceExtrude=1 AND do_forceRetract=0 THEN
                ! Force extrude at maximum speed
                spd:=BYTE_SPD_MAX;

            ELSEIF do_forceRetract=1 AND do_forceExtrude=0 THEN
                ! Force retract at maximum speed
                spd:=-BYTE_SPD_MAX;

            ELSEIF do_forceExtrude=0 AND do_forceRetract=0 AND Abs(AOutput(ao_printPtSpd))>0.001 THEN
                ! Normal operation: use TCP speed and print point speed
                spd:=AOutput(ao_TCPSpd)*AOutput(ao_printPtSpd)*SPD_COEFFICIENT;

            ELSE
                ! All other cases (including conflicting commands): stop
                spd:=0;
            ENDIF

            spd:=spd*AOutput(ao_flowFactor);

            IF spd>BYTE_SPD_MAX THEN
                spd:=BYTE_SPD_MAX;
            ELSEIF spd<-BYTE_SPD_MAX THEN
                spd:=-BYTE_SPD_MAX;
            ENDIF

            SetGO go_TCPSpd,SignedSpeedToUnsigned(spd);

        ENDWHILE
    ENDPROC

    FUNC num SignedSpeedToUnsigned(num spd_val)
        IF spd_val<0 THEN
            ! Negative speed (-127 to -1) -> (129 to 255)
            ! Since speed is negative, this is 256 - |speed|
            spd_val:=BYTE_ABS_MAX+1+spd_val;
        ENDIF

        RETURN Trunc(spd_val);
    ENDFUNC

ENDMODULE