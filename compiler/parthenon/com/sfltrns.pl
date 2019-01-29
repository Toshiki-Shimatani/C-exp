?-
    atom_value_set(tmp_value,sel_org),            /* sel_org (sel) | bus_org (bus) */
    atom_value_set(post_opt,single),          /* no | single | multi (this switch is valid when multi_level_opt is 'yes') */
    atom_value_set(time_limit,v100),          /* v<seconds> | r<seconds> (post optimization time limit v: virtual r: real) */
    atom_value_set(change_to_nand_nor,8),     /* 0 (no) | 1 (no) | 2 (yes, fin 2) | 3 (yes, fin 3) | ... (this switch is valid when multi_level_opt is 'yes') */
    atom_value_set(nld_out_mode,yes),         /* no | yes */
    atom_value_set(pcd_out_mode,no),          /* no | yes */
    atom_value_set(circuit_pcd_out_mode,no),  /* no | yes */

    atom_value_set(sel_type,hie),             /* hie | flat */
    atom_value_set(exp_mode_flg,group),       /* group | all */
    atom_value_set(multi_level_opt,yes),      /* yes | no */
    atom_value_set(dont_care_opt,yes),        /* yes | no (this switch is valid when post_opt is not 'no') */
    atom_value_set(level_factor,0),           /* 0 (default) | 1 () | 2 () | ... */
    atom_value_set(to_other_tool,no),         /* no | yes */
    atom_value_set(machine,sun),              /* apollo | sun */
    atom_value_set(partial_demo,partial),     /* partial | full */
    atom_value_set(test_syn_pass,0),          /* 0 (no) | 1 (pass 1) | 2 (pass 2) */
    atom_value_set(test_syn_top,test),
    /*
    atom_value_set(trns_mode,severe),         /* severe | loose */
    atom_value_set(mode_flg,exp),             /* exp | sim | demo | chk */
    atom_value_set(file_name,'test.sfl'),
    atom_value_set(out_file_name,'test.hsl'),
    atom_value_set(chk_mod_name,test),
    */
    main.
