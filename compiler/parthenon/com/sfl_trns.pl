/*****
test:-
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
    /**/
    atom_value_set(trns_mode,severe),         /* severe | loose */
    atom_value_set(mode_flg,exp),             /* exp | sim | demo | chk */
    atom_value_set(file_name,'test.sfl'),
    atom_value_set(out_file_name,'test.hsl'),
    atom_value_set(image_file_name, 'image.trn'), /*K.Nagami added: Tue May 23 15:28:06 2000*/
    atom_value_set(chk_mod_name,test),
    atom_value_set(test_syn_top,test),
    /**/
    main.
*****/
    /*****************************/
    /* Designed by Kiyoshi Oguri */
    /* SFL.TRNS.CMP              */
    /*****************************/

main:-

    dispf('This prolog image is designed and programmed by Kiyoshi Oguri.\n'),
    switch_set(tmp_value,           atom,0),  /* -bus-> tmp_value = bus_org, -sel-> tmp_value = sel_org */
    switch_set(post_opt,            atom,1),  /* -multi-> post_opt = multi, -single-> post_opt = single, -nopost-> post_opt = no */
    switch_set(time_limit,          atom,2),  /* -time-> time_limit = <string> */
    switch_set(change_to_nand_nor,  int, 3),  /* -fin-> change_to_nand_nor = <value> */
    switch_set(nld_out_mode,        atom,4),  /* -nonld-> nld_out_mode = no */
    switch_set(pcd_out_mode,        atom,5),  /* -pcd-> pcd_out_mode = yes */
    switch_set(circuit_pcd_out_mode,atom,6),  /* -pcd-> circuit_pcd_out_mode = yes */
    switch_set(sel_type,            atom,7),  /* -flat-> sel_type = flat, -hie-> sel_type = hie */
    switch_set(multi_level_opt,     atom,8),  /* -pla-> multi_level_opt = no */
    switch_set(dont_care_opt,       atom,9),  /* -nodc-> dont_care_opt = no */
    switch_set(level_factor,        int,10),  /* -level_factor-> level_factor = <value> */

    disp_sc,
    hash_table_clear,
    sfl_seen,
    seen_all,
    free_cube,
    switch_set(test_syn_pass,       int,11),  /* -tsyn_pass-> test_syn_pass = 0|1|2 */
    switch_set(test_syn_top,       atom,12),  /* -tsyn_top-> test_syn_top = <top_module_name> */
    atom_value_read(mode_flg,MODE),
    atom_value_read(file_name,File),
    atom_value_set(sequence_id,0),
    atom_value_set(under_back_truck_flg,0),
    atom_value_set(diff_position,0),
    sfl_see(File),
    macro_reset,
    atom_value_set(eor_id,0),
    if_then(
        eq(MODE,demo),
        sfl_window_open
    ),
    sfl_get_token(X),
    sfl_get_position(F_posit),
    sfl_get_append_posit(A_posit),
    chk_point(0,[start],F_posit,A_posit,_),
    sfl_trns_pre(X,[],R),                          /* 1992.08.13 */
    sfl_seen,
    atom_value_read(partial_demo,PARTIAL),
    if_then(
        and(
            eq(MODE,demo),
            eq(PARTIAL,partial)
        ),
        atom_value_set(mode_flg,exp)
    ),
    !,
    break,
    atom_value_read(mode_flg,MODE),
    if_then(
        eq(MODE,chk),
        and(
            atom_value_read(chk_mod_name,MODULE),
            exp_chk(R,MODULE)
        )
    ),
    if_then(
        or(eq(MODE,exp),eq(MODE,demo)),
        and(
            display('** translate completion **'),
            nl,
            test_synthesis(R,SR), /* 1992.11.05 pass 2 */
            expand_main(SR)       /* 1992.11.05 */
        )
    ).

trns_fac_exp(AA,Y,INFO):-
    atom_value_read(mode_flg,MODE),
    eq(MODE,sim),
    !,
    flat(AA,A),
    trn_fac_exp(A,Y),
    sfl_get_position(F_posit),
    sfl_get_append_posit(A_posit),
    chk_point(Y,INFO,F_posit,A_posit,A).

trns_fac_exp(_,Y,INFO):-
    atom_value_read(mode_flg,MODE),
    or(eq(MODE,exp),eq(MODE,chk)),
    !,
    atom_value_read(sequence_id,X),
    add1(X,Y),
    atom_value_set(sequence_id,Y),
    sfl_get_position(F_posit),
    sfl_get_append_posit(A_posit),
    chk_point(0,INFO,F_posit,A_posit,_).

trns_fac_exp(_,Y,INFO):-    /* demo mode */
    sfl_point,
    atom_value_read(sequence_id,X),
    add1(X,Y),
    atom_value_set(sequence_id,Y),
    sfl_get_position(F_posit),
    sfl_get_append_posit(A_posit),
    chk_point(0,INFO,F_posit,A_posit,_).

chk_point(_,_,_,_,_).   /* create facility */

chk_point(Y,IN,F_posit,A_posit,FLAT):-
    atom_value_read(under_back_truck_flg,UBF),
    if_then(
        eq(UBF,0),
        trns_command
    ),
    atom_value_read(diff_position,Position),
    bigger(Position,F_posit),
    !,
    atom_value_set(under_back_truck_flg,0),
    atom_value_read(file_name,File),
    sfl_see(File),
    atom_value_read(mode_flg,MODE),
    if_then(
        eq(MODE,demo),
        sfl_window_open
    ),
    sfl_skip(F_posit),
    sfl_set_append_posit(A_posit),
    chk_point(Y,IN,F_posit,A_posit,FLAT).

chk_point(Y,_,_,_,_):-   /* remove facility */
    not(eq(Y,0)),
    flat([2,Y],A),
    trn_fac_exp(A,_),
    fail.

    /*****************************/
    /* Designed by Kiyoshi Oguri */
    /*        TRANSLATOR         */
    /*****************************/

trns_command:-
    /*****
    atom_value_read(mode_flg,MODE),
    if_else(
        eq(MODE,demo), /* sim or exp */
        and(
            display('Shall I open the edit pad ? Type <CR> if ready.'),
            get(_),
            sfl_window_open
        )
    ),
    *****/
    sfl_window_open,
    sfl_point,
    /*****
    display('Error exist just before the cursor position. Please correct sfl source file and save it and type "r."'),
    nl,
    *****/
    repeat,
    display('TRNS(h. for help)'),
    read(Command),
    trns_exec(Command),
    eq(Command,r),
    !.

trns_exec(a):-
    !,
    sfl_seen,
    quit.
trns_exec(end_of_file):-
    !,
    sfl_seen,
    quit.
trns_exec(e(X)):-
    !,
    X.
trns_exec(r):-
    !,
    sfl_seen,
    atom_value_set(under_back_truck_flg,1),
    atom_value_read(file_name,File),
    atom_value_read(machine,Machine),
    if_then_else(
        eq(Machine,apollo),
        string_cat(File,'.bak',Backup),
        string_cat(File,'.bak',Backup)
    ),
    file_compare(File,Backup,Position),
    atom_value_set(diff_position,Position).
trns_exec(_):-
    display('Now, you are in error correction mode. I invoked "sfl_edit.sh".'),nl,
    display('available commands are'),nl,
    tab,display('h.   : help'),nl,
    tab,display('a.   : abort, exit with no effect'),nl,
    tab,display('r.   : retry'),nl.
    /*****************************/
    /* Designed by Kiyoshi Oguri */
    /*        CHECKER            */
    /*****************************/

exp_chk([facility(Name,module,_,_,Facility,Stage,BEH,_)|REST],Name):- /* 1990.05.25 */
    !,
    dispf('\n#### module: %s ####\n',Name),
    chk_exec_expand1(module,CHK_op,[],_,_,Facility,Stage,BEH,_,_,_), /* 1990.05.25 */
    !,
    chk_inter_stage(CHK_op),
    !,
    chk_stage_state(CHK_op),
    !,
    chk_all_states(CHK_op,Yoko2),
    !,
    chk_data_trns_src(CHK_op,Yoko1),
    !,
    chk_data_trns_dst(CHK_op,Tate1),
    !,
    chk_data_trns_a(CHK_op,Kumi1,Tate2),
    !,
    chk_data_trns_b(CHK_op),
    !,
    chk_data_trns_c(CHK_op),
    !,
    chk_data_trns_d(CHK_op,Kumi2),
    !,
    chk_data_trns_e(CHK_op),
    !,
    sdispf('%s.eval.yoko1',Name,Table1),
    see(Table1),
    list_fdisplay(Yoko1),
    seen,
    !,
    sdispf('%s.eval.tate1',Name,Table2),
    see(Table2),
    list_fdisplay(Tate1),
    seen,
    !,
    sdispf('%s.eval.kumi1',Name,Table3),
    see(Table3),
    list_fdisplay(Kumi1),
    seen,
    !,
    sdispf('%s.eval.yoko2',Name,Table4),
    see(Table4),
    list_fdisplay(Yoko2),
    seen,
    !,
    sdispf('%s.eval.tate2',Name,Table5),
    see(Table5),
    list_fdisplay(Tate2),
    seen,
    !,
    sdispf('%s.eval.kumi2',Name,Table6),
    see(Table6),
    list_fdisplay(Kumi2),
    seen,
    !,
    exp_chk(REST,Name).
exp_chk([_|REST],Name):-
    !,
    exp_chk(REST,Name).
exp_chk([],_).

/*------------------------------------*/
/* inter-stage task transfer relation */
/*------------------------------------*/
chk_inter_stage(CHK_op):-
    dispf('\n;;; inter-stage task transfer relations ;;;\n'),
    dispf(';;; t_act(STG,SEG|SUB,ST|INST,generate|relay|finish,STG,TSK) ;;;\n\n'),
    chk_inter_stage1(CHK_op,CHK_op1),
    sort(CHK_op1,S_CHK_op1,[]),
    list_display(S_CHK_op1).
/*-----------------------------------*/
chk_inter_stage1([chk_op('-',SUB,INST,_,_,_,hsl_op(generate,[STG,TSK,_]))|REST],
                 [t_act('-',SUB,INST,generate,STG,TSK)|RESULT]):-
    !,
    chk_inter_stage1(REST,RESULT).
chk_inter_stage1([chk_op(Stg,Seg,St,_,_,_,hsl_op(generate,[STG,TSK,_]))|REST],
                 [t_act(Stg,Seg,St,generate,STG,TSK)|RESULT]):-
    !,
    chk_inter_stage1(REST,RESULT).
chk_inter_stage1([chk_op(Stg,Seg,St,_,_,_,hsl_op(relay,[STG,TSK,_]))|REST],
                 [t_act(Stg,Seg,St,relay,STG,TSK)|RESULT]):-
    !,
    chk_inter_stage1(REST,RESULT).
chk_inter_stage1([chk_op(Stg,Seg,St,_,_,_,hsl_op(finish,_))|REST],
                 [t_act(Stg,Seg,St,finish,'-','-')|RESULT]):-
    !,
    chk_inter_stage1(REST,RESULT).
chk_inter_stage1([_|REST],RESULT):-
    !,
    chk_inter_stage1(REST,RESULT).
chk_inter_stage1([],[]).

/*-----------------------------------*/
/* stage state transfer relation     */
/*-----------------------------------*/
chk_stage_state(CHK_op):-
    dispf('\n;;; stage state transfer relations ;;;\n'),
    dispf(';;; s_trns(STG,SEG,ST,goto|call|through|return,SEG,ST) ;;;\n\n'),
    chk_stage_state1(CHK_op,CHK_op1),
    sort(CHK_op1,S_CHK_op1,[]),
    list_display(S_CHK_op1).
/*-----------------------------------*/
chk_stage_state1([chk_op(Stg,Seg,St,_,_,_,hsl_op(goto,ST))|REST],
                 [s_trns(Stg,Seg,St,goto,'-',ST)|RESULT]):-
    !,
    chk_stage_state1(REST,RESULT).
chk_stage_state1([chk_op(Stg,Seg,St,_,_,_,hsl_op(call,[_,SEG,RST]))|REST],
                 [s_trns(Stg,Seg,St,call,SEG,RST)|RESULT]):-
    !,
    chk_stage_state1(REST,RESULT).
chk_stage_state1([chk_op(Stg,Seg,St,_,_,_,hsl_op(through,SEG))|REST],
                 [s_trns(Stg,Seg,St,through,SEG,'-')|RESULT]):-
    !,
    chk_stage_state1(REST,RESULT).
chk_stage_state1([chk_op(Stg,Seg,St,_,_,_,hsl_op(return,_))|REST],
                 [s_trns(Stg,Seg,St,return,'-','-')|RESULT]):-
    !,
    chk_stage_state1(REST,RESULT).
chk_stage_state1([_|REST],RESULT):-
    !,
    chk_stage_state1(REST,RESULT).
chk_stage_state1([],[]).

/*-----------------------------------*/
/* time                              */
/*-----------------------------------*/
chk_all_states(CHK_op,Yoko):-
    dispf('\n;;; all states ;;;\n'),
    chk_all_states1(CHK_op,CHK_op1,[]),
    sort(CHK_op1,S_CHK_op1,[]),
    chk_data_display(S_CHK_op1),
    chk_all_states_yoko(S_CHK_op1,Yoko).
/*-----------------------------------*/
chk_all_states1([chk_op(STG,SEG,ST,_,_,_,_)|REST],
                [data(states,STG,SEG,ST)|B],C):-
    !,
    chk_all_states1(REST,B,C).
chk_all_states1([],A,A).
/*-----------------------------------*/
chk_all_states_yoko([data(states,STG,SEG,ST)|REST],[yoko(STG_SEG_ST)|RESULT]):-
    !,
    chk_change_tname(STG,SEG,ST,STG_SEG_ST),
    chk_all_states_yoko(REST,RESULT).
chk_all_states_yoko([],[]).

/*-----------------------------------*/
/* data trnsfer source               */
/*-----------------------------------*/
chk_data_trns_src(CHK_op,Yoko):-
    dispf('\n;;; data transfer source ;;;\n'),
    chk_data_trns1_src(CHK_op,CHK_op1,[]),
    sort(CHK_op1,S_CHK_op1,[]),
    chk_data_display(S_CHK_op1),
    chk_data_trns_src_yoko(S_CHK_op1,Yoko).
/*-----------------------------------*/
chk_data_trns1_src([chk_op(STG,SEG,ST,_,_,NET,_)|REST],A,C):-
    !,
    chk_data_trns2_src(NET,STG,SEG,ST,A,B),
    chk_data_trns1_src(REST,B,C).
chk_data_trns1_src([],A,A).
/*-----------------------------------*/
chk_data_trns2_src([net(pin(_,1,_),_)|REST],STG,SEG,ST,A,B):-
    !,
    chk_data_trns2_src(REST,STG,SEG,ST,A,B).
chk_data_trns2_src([net(_,pin(S_Type,Width,S_Name))|REST],STG,SEG,ST,
                 [data(SS_Name)|A],B):-
    !,
    chk_change_name(S_Type,S_Name,Width,SS_Name),
    chk_data_trns2_src(REST,STG,SEG,ST,A,B).
chk_data_trns2_src([],_,_,_,A,A).
/*-----------------------------------*/
chk_data_trns_src_yoko([data(Name)|REST],[yoko(Name)|RESULT]):-
    !,
    chk_data_trns_src_yoko(REST,RESULT).
chk_data_trns_src_yoko([],[]).

/*-----------------------------------*/
/* data trnsfer destination          */
/*-----------------------------------*/
chk_data_trns_dst(CHK_op,Tate):-
    dispf('\n;;; data transfer destination ;;;\n'),
    chk_data_trns1_dst(CHK_op,CHK_op1,[]),
    sort(CHK_op1,S_CHK_op1,[]),
    chk_data_display(S_CHK_op1),
    chk_data_trns_dst_tate(S_CHK_op1,Tate).
/*-----------------------------------*/
chk_data_trns1_dst([chk_op(STG,SEG,ST,_,_,NET,_)|REST],A,C):-
    !,
    chk_data_trns2_dst(NET,STG,SEG,ST,A,B),
    chk_data_trns1_dst(REST,B,C).
chk_data_trns1_dst([],A,A).
/*-----------------------------------*/
chk_data_trns2_dst([net(pin(_,1,_),_)|REST],STG,SEG,ST,A,B):-
    !,
    chk_data_trns2_dst(REST,STG,SEG,ST,A,B).
chk_data_trns2_dst([net(pin(D_Type,Width,D_Name),_)|REST],STG,SEG,ST,
                 [data(DD_Name)|A],B):-
    !,
    chk_change_name(D_Type,D_Name,Width,DD_Name),
    chk_data_trns2_dst(REST,STG,SEG,ST,A,B).
chk_data_trns2_dst([],_,_,_,A,A).
/*-----------------------------------*/
chk_data_trns_dst_tate([data(Name)|REST],[tate(Name)|RESULT]):-
    !,
    chk_data_trns_dst_tate(REST,RESULT).
chk_data_trns_dst_tate([],[]).

/*-----------------------------------*/
/* data trnsfer relation a: D<-S     */
/*-----------------------------------*/
chk_data_trns_a(CHK_op,Kumi,Tate):-
    dispf('\n;;; data transfer relations type A: ;;;\n'),
    chk_data_trns1_a(CHK_op,CHK_op1,[]),
    sort(CHK_op1,S_CHK_op1,[]),
    chk_data_display(S_CHK_op1),
    chk_data_trns_a_kumi_tate(S_CHK_op1,Kumi,Tate).
/*-----------------------------------*/
chk_data_trns1_a([chk_op(STG,SEG,ST,_,_,NET,_)|REST],A,C):-
    !,
    chk_data_trns2_a(NET,STG,SEG,ST,A,B),
    chk_data_trns1_a(REST,B,C).
chk_data_trns1_a([],A,A).
/*-----------------------------------*/
chk_data_trns2_a([net(pin(_,1,_),_)|REST],STG,SEG,ST,A,B):-
    !,
    chk_data_trns2_a(REST,STG,SEG,ST,A,B).
chk_data_trns2_a([net(pin(D_Type,Width,D_Name),pin(S_Type,_,S_Name))|REST],STG,SEG,ST,
                 [data('D<-S',DD_Name,SS_Name)|A],B):-
    !,
    chk_change_name(S_Type,S_Name,Width,SS_Name),
    chk_change_name(D_Type,D_Name,Width,DD_Name),
    chk_data_trns2_a(REST,STG,SEG,ST,A,B).
chk_data_trns2_a([],_,_,_,A,A).
/*-----------------------------------*/
chk_data_trns_a_kumi_tate([data('D<-S',DD_Name,SS_Name)|RA],[kumi(DD_Name,SS_Name)|RB],[tate(DS_Name)|RC]):-
    !,
    sdispf('%s^^||%s',DD_Name,SS_Name,DS_Name),
    chk_data_trns_a_kumi_tate(RA,RB,RC).
chk_data_trns_a_kumi_tate([],[],[]).

/*-----------------------------------*/
/* data trnsfer relation b: S->D     */
/*-----------------------------------*/
chk_data_trns_b(CHK_op):-
    dispf('\n;;; data transfer relations type B: ;;;\n'),
    chk_data_trns1_b(CHK_op,CHK_op1,[]),
    sort(CHK_op1,S_CHK_op1,[]),
    chk_data_display(S_CHK_op1).
/*-----------------------------------*/
chk_data_trns1_b([chk_op(STG,SEG,ST,_,_,NET,_)|REST],A,C):-
    !,
    chk_data_trns2_b(NET,STG,SEG,ST,A,B),
    chk_data_trns1_b(REST,B,C).
chk_data_trns1_b([],A,A).
/*-----------------------------------*/
chk_data_trns2_b([net(pin(_,1,_),_)|REST],STG,SEG,ST,A,B):-
    !,
    chk_data_trns2_b(REST,STG,SEG,ST,A,B).
chk_data_trns2_b([net(pin(D_Type,Width,D_Name),pin(S_Type,_,S_Name))|REST],STG,SEG,ST,
                 [data('S->D',SS_Name,DD_Name)|A],B):-
    !,
    chk_change_name(S_Type,S_Name,Width,SS_Name),
    chk_change_name(D_Type,D_Name,Width,DD_Name),
    chk_data_trns2_b(REST,STG,SEG,ST,A,B).
chk_data_trns2_b([],_,_,_,A,A).

/*-----------------------------------*/
/* data trnsfer relation c: st(D<-S) */
/*-----------------------------------*/
chk_data_trns_c(CHK_op):-
    dispf('\n;;; data transfer relations type C: ;;;\n'),
    chk_data_trns1_c(CHK_op,CHK_op1,[]),
    sort(CHK_op1,S_CHK_op1,[]),
    chk_data_display(S_CHK_op1).
/*-----------------------------------*/
chk_data_trns1_c([chk_op(STG,SEG,ST,_,_,NET,_)|REST],A,C):-
    !,
    chk_data_trns2_c(NET,STG,SEG,ST,A,B),
    chk_data_trns1_c(REST,B,C).
chk_data_trns1_c([],A,A).
/*-----------------------------------*/
chk_data_trns2_c([net(pin(_,1,_),_)|REST],STG,SEG,ST,A,B):-
    !,
    chk_data_trns2_c(REST,STG,SEG,ST,A,B).
chk_data_trns2_c([net(pin(D_Type,Width,D_Name),pin(S_Type,_,S_Name))|REST],STG,SEG,ST,
                 [data('st(D<-S)',STG,SEG,ST,DD_Name,SS_Name)|A],B):-
    !,
    chk_change_name(S_Type,S_Name,Width,SS_Name),
    chk_change_name(D_Type,D_Name,Width,DD_Name),
    chk_data_trns2_c(REST,STG,SEG,ST,A,B).
chk_data_trns2_c([],_,_,_,A,A).

/*-----------------------------------*/
/* data trnsfer relation d: (D<-S)st */
/*-----------------------------------*/
chk_data_trns_d(CHK_op,Kumi):-
    dispf('\n;;; data transfer relations type D: ;;;\n'),
    chk_data_trns1_d(CHK_op,CHK_op1,[]),
    sort(CHK_op1,S_CHK_op1,[]),
    chk_data_display(S_CHK_op1),
    chk_data_trns_d_kumi(S_CHK_op1,Kumi).
/*-----------------------------------*/
chk_data_trns1_d([chk_op(STG,SEG,ST,_,_,NET,_)|REST],A,C):-
    !,
    chk_data_trns2_d(NET,STG,SEG,ST,A,B),
    chk_data_trns1_d(REST,B,C).
chk_data_trns1_d([],A,A).
/*-----------------------------------*/
chk_data_trns2_d([net(pin(_,1,_),_)|REST],STG,SEG,ST,A,B):-
    !,
    chk_data_trns2_d(REST,STG,SEG,ST,A,B).
chk_data_trns2_d([net(pin(D_Type,Width,D_Name),pin(S_Type,_,S_Name))|REST],STG,SEG,ST,
                 [data('(D<-S)st',DD_Name,SS_Name,STG,SEG,ST)|A],B):-
    !,
    chk_change_name(S_Type,S_Name,Width,SS_Name),
    chk_change_name(D_Type,D_Name,Width,DD_Name),
    chk_data_trns2_d(REST,STG,SEG,ST,A,B).
chk_data_trns2_d([],_,_,_,A,A).
/*-----------------------------------*/
chk_data_trns_d_kumi([data('(D<-S)st',DD_Name,SS_Name,STG,SEG,ST)|REST],
                     [kumi(DS_Name,STG_SEG_ST)|RESULT]):-
    !,
    sdispf('%s^^||%s',DD_Name,SS_Name,DS_Name),
    chk_change_tname(STG,SEG,ST,STG_SEG_ST),
    chk_data_trns_d_kumi(REST,RESULT).
chk_data_trns_d_kumi([],[]).

/*-----------------------------------*/
/* data trnsfer relation e: D<-st-S  */
/*-----------------------------------*/
chk_data_trns_e(CHK_op):-
    dispf('\n;;; data transfer relations type E: ;;;\n'),
    chk_data_trns1_e(CHK_op,CHK_op1,[]),
    sort(CHK_op1,S_CHK_op1,[]),
    chk_data_display(S_CHK_op1).
/*-----------------------------------*/
chk_data_trns1_e([chk_op(STG,SEG,ST,_,_,NET,_)|REST],A,C):-
    !,
    chk_data_trns2_e(NET,STG,SEG,ST,A,B),
    chk_data_trns1_e(REST,B,C).
chk_data_trns1_e([],A,A).
/*-----------------------------------*/
chk_data_trns2_e([net(pin(_,1,_),_)|REST],STG,SEG,ST,A,B):-
    !,
    chk_data_trns2_e(REST,STG,SEG,ST,A,B).
chk_data_trns2_e([net(pin(D_Type,Width,D_Name),pin(S_Type,_,S_Name))|REST],STG,SEG,ST,
                 [data('D<-st-S',DD_Name,STG,SEG,ST,SS_Name)|A],B):-
    !,
    chk_change_name(S_Type,S_Name,Width,SS_Name),
    chk_change_name(D_Type,D_Name,Width,DD_Name),
    chk_data_trns2_e(REST,STG,SEG,ST,A,B).
chk_data_trns2_e([],_,_,_,A,A).

/*-----------------------------------*/
/*  chk data display                 */
/*-----------------------------------*/
chk_data_display([A|REST]):-
    !,
    chk_data_display1(A),
    chk_data_display(REST).
chk_data_display([]).
/*-----------------------------------*/
chk_data_display1(data(A)):-
    !,
    tab,display(A),nl.
chk_data_display1(data('D<-S',D,S)):-
    !,
    tab,display(D),display(' <- '),display(S),nl.
chk_data_display1(data('S->D',S,D)):-
    !,
    tab,display(S),display(' -> '),display(D),nl.
chk_data_display1(data(states,STG,SEG,ST)):-
    !,
    chk_change_tname(STG,SEG,ST,STG_SEG_ST),
    tab,display(STG_SEG_ST),nl.
chk_data_display1(data('st(D<-S)',STG,SEG,ST,D,S)):-
    !,
    chk_change_tname(STG,SEG,ST,STG_SEG_ST),
    tab,display('at ('),display(STG_SEG_ST),display(')'),tab,display(D),display(' <- '),display(S),nl.
chk_data_display1(data('(D<-S)st',D,S,STG,SEG,ST)):-
    !,
    chk_change_tname(STG,SEG,ST,STG_SEG_ST),
    tab,display(D),display(' <- '),display(S),tab,display('at ('),display(STG_SEG_ST),display(')'),nl.
chk_data_display1(data('D<-st-S',D,STG,SEG,ST,S)):-
    chk_change_tname(STG,SEG,ST,STG_SEG_ST),
    tab,display(D),display(' <- at ('),display(STG_SEG_ST),display(') -- '),display(S),nl.

/*-----------------------------------*/
/*  chk change name                  */
/*-----------------------------------*/
chk_change_name(cat,_,_,'??cat??'):-
    !.
chk_change_name(subst,_,_,'??subst??'):-
    !.
chk_change_name(const,_,_,'??const??'):-
    !.
chk_change_name(tmp_org(_),[A,_],Width,Name):-
    !,
    sdispf('%s.%d',A,Width,Name).
chk_change_name(_,[A,B],Width,Name):-
    !,
    sdispf('%s.%s.%d',B,A,Width,Name).
chk_change_name(_,A,Width,Name):-
    sdispf('%s.%d',A,Width,Name).
/*-----------------------------------*/
/*  chk change time name             */
/*-----------------------------------*/
chk_change_tname(STG,SEG,ST,STG_SEG_ST):-
    sdispf('%s-%s-%s',STG,SEG,ST,STG_SEG_ST).

    /**************************/    /*         facility()          */
    /* chk expand 1,2,3,4,5,6 */    /*             v               */
    /**************************/    /* chk_op(stg,seg,st,first,cnd,net,hsl_op) */

chk_exec_expand(A,A,none,_,_):-     /* kono gyou ha facility ga 'VAR' or 'none' no tokino tame */
    !.
chk_exec_expand(Flat_op,DBL,facility(Name,Type,_,P4,P5,P6,P7,P8),A1,A2):-
    !,
    chk_exec_expand1(Type,Flat_op,DBL,Name,P4,P5,P6,P7,P8,A1,A2).
chk_exec_expand(Flat_op,DBL,[facility(Name,Type,_,P4,P5,P6,P7,P8)|REST],A1,A2):-
    !,
    chk_exec_expand1(Type,Flat_op,Flat_op1,Name,P4,P5,P6,P7,P8,A1,A2),
    chk_exec_expand(Flat_op1,DBL,REST,A1,A2).
chk_exec_expand(A,A,[],_,_).
/*------------------------------------------*/
/*            chk_exec_expand1  (type)      */
/*------------------------------------------*/
chk_exec_expand1(module,Flat_op,DBL,_,_,Facility,Stage,BEH,_,_,_):- /* 1990.05.25 */
    !,
    chk_exec_expand2(Flat_op,Flat_op11,BEH,'-','-','-','-'), /* 1990.05.25 */
    chk_exec_expand(Flat_op11,Flat_op1,Facility,_,_), /* 1990.05.25 */
    chk_exec_expand(Flat_op1,DBL,Stage,_,_).
chk_exec_expand1(submod,Flat_op,DBL,Name,Facility,_,_,_,_,_,_):-
    !,
    chk_exec_expand(Flat_op,DBL,Facility,_,Name).
chk_exec_expand1(instrin,Flat_op,DBL,Name,_,BEH,_,_,_,_,_):-
    !,
    chk_exec_expand2(Flat_op,DBL,BEH,'-','-',Name,'-').
chk_exec_expand1(instrout,Flat_op,DBL,Name,_,BEH,_,_,_,_,A2):-
    !,
    chk_exec_expand2(Flat_op,DBL,BEH,'-',A2,Name,'-').
chk_exec_expand1(instrself,Flat_op,DBL,Name,_,BEH,_,_,_,_,_):-
    !,
    chk_exec_expand2(Flat_op,DBL,BEH,'-','+',Name,'-').
chk_exec_expand1(stage,Flat_op,DBL,Name,_,State,Segment,_,BEH,_,_):-
    !,
    chk_exec_expand2(Flat_op,Flat_op1,BEH,Name,'-','-','-'),
    chk_exec_expand(Flat_op1,Flat_op2,State,Name,'-'),
    chk_exec_expand(Flat_op2,DBL,Segment,Name,_).
chk_exec_expand1(segment,Flat_op,DBL,Name,State,_,BEH,_,_,A1,_):-
    !,
    chk_exec_expand2(Flat_op,Flat_op1,BEH,A1,Name,'-','-'),
    chk_exec_expand(Flat_op1,DBL,State,A1,Name).
chk_exec_expand1(state,Flat_op,DBL,Name,BEH,FIRST_F,_,_,_,A1,A2):-
    !,
    chk_exec_expand2(Flat_op,DBL,BEH,A1,A2,Name,FIRST_F).
chk_exec_expand1(submod_class,A,A,_,_,_,_,_,_,_,_):-
    !.
chk_exec_expand1(circuit_class,A,A,_,_,_,_,_,_,_,_):-
    !.
chk_exec_expand1(circuit,A,A,_,_,_,_,_,_,_,_):-
    !.
chk_exec_expand1(tmp_org(_),A,A,_,_,_,_,_,_,_,_):-
    !.
chk_exec_expand1(bus_org,A,A,_,_,_,_,_,_,_,_):-
    !.
chk_exec_expand1(sel_org,A,A,_,_,_,_,_,_,_,_):-
    !.
chk_exec_expand1(input,A,A,_,_,_,_,_,_,_,_):-
    !.
chk_exec_expand1(output,A,A,_,_,_,_,_,_,_,_):-
    !.
chk_exec_expand1(bidirect,A,A,_,_,_,_,_,_,_,_):-
    !.
chk_exec_expand1(reg,A,A,_,_,_,_,_,_,_,_):-
    !.

chk_exec_expand1(reg_wr,A,A,_,_,_,_,_,_,_,_):- /* 1990.05.29 */
    !.                                         /* 1990.05.29 */

chk_exec_expand1(reg_ws,A,A,_,_,_,_,_,_,_,_):- /* 1990.06.18 */
    !.                                         /* 1990.06.18 */

chk_exec_expand1(scan_reg,A,A,_,_,_,_,_,_,_,_):-
    !.
chk_exec_expand1(scan_reg_wr,A,A,_,_,_,_,_,_,_,_):-
    !.
chk_exec_expand1(scan_reg_ws,A,A,_,_,_,_,_,_,_,_):-
    !.

chk_exec_expand1(mem,A,A,_,_,_,_,_,_,_,_):-
    !.
chk_exec_expand1(task,A,A,_,_,_,_,_,_,_,_):-
    !.
chk_exec_expand1(Type,A,A,_,_,_,_,_,_,_,_):-
    dispf('Cannot expand here(%s)',Type),nl.
/*------------------------------------------*/
/*            chk_exec_expand2  (BEH)       */
/*------------------------------------------*/
chk_exec_expand2(A,A,none,_,_,_,_):-  /* kono gyou ha facility ga 'VAR' mataha 'none' no tokino tame */
    !.
chk_exec_expand2(Flat_op,
             DBL,
             facility(_,Type,_,P4,_,P6,_,_),
             A1,
             A2,
             A3,A4):-
    chk_exec_expand3(Type,Flat_op,DBL,P4,P6,A1,A2,A3,A4,pin(const,1,1)).
/*------------------------------------------*/
/*            chk_exec_expand3  (BEH type)  */
/*------------------------------------------*/
chk_exec_expand3(par,
             Flat_op,
             DBL,
             BEH,_,
             A1,A2,A3,A4,
             True_cnd):-
    !,
    chk_exec_expand4(Flat_op,DBL,BEH,A1,A2,A3,A4,True_cnd).
chk_exec_expand3(alt,
             Flat_op,
             DBL,
             BEH,_,
             A1,A2,A3,A4,
             True_cnd):-
    !,
    chk_exec_expand5(alt,Flat_op,DBL,BEH,A1,A2,A3,A4,True_cnd,pin(const,1,1),_).
chk_exec_expand3(any,
             Flat_op,
             DBL,
             BEH,_,
             A1,A2,A3,A4,
             True_cnd):-
    !,
    chk_exec_expand5(any,Flat_op,DBL,BEH,A1,A2,A3,A4,True_cnd,pin(const,1,1),_).
chk_exec_expand3(simple,
             [chk_op(A1,A2,A3,A4,True_cnd,NET,HSL_OP)|DBL],
             DBL,
             NET,HSL_OP,
             A1,A2,A3,A4,
             True_cnd).
/*------------------------------------------*/
/*            chk_exec_expand4  (par)       */
/*------------------------------------------*/
chk_exec_expand4(Flat_op,
             DBL,
             [facility(_,Type,_,P4,_,P6,_,_)|REST],
             A1,
             A2,
             A3,A4,
             True_cnd):-
    !,
    chk_exec_expand3(Type,Flat_op,Flat_op1,P4,P6,A1,A2,A3,A4,True_cnd),
    chk_exec_expand4(Flat_op1,
                     DBL,
                     REST,
                     A1,
                     A2,
                     A3,A4,
                     True_cnd).
chk_exec_expand4(A,A,[],_,_,_,_,_).
/*------------------------------------------*/
/*            chk_exec_expand5  (alt,any)   */
/*------------------------------------------*/
chk_exec_expand5(Type,
             Flat_op,
             DBL,
             [facility(_,Type1,_,P4,P5,P6,_,_)|REST],
             A1,
             A2,
             A3,A4,
             True_cnd,
             Else_cnd_in,
             Else_cnd_out1):-
    !,
    chk_exec_expand6(Type1,Flat_op,Flat_op1,Type,P4,P5,P6,A1,A2,A3,A4,True_cnd,Else_cnd_in,Else_cnd_out),
    chk_exec_expand5(Type,
                     Flat_op1,
                     DBL,
                     REST,
                     A1,
                     A2,
                     A3,A4,
                     True_cnd,
                     Else_cnd_out,
                     Else_cnd_out1).
chk_exec_expand5(_,A,A,[],_,_,_,_,_,_,_).
/*------------------------------------------*/
/*            chk_exec_expand6  (condition) */
/*------------------------------------------*/
chk_exec_expand6(condition,
             [chk_op(A1,A2,A3,A4,True_cnd,NET,[])|Flat_op],
             DBL,
             any,
             Value,
             facility(_,Type,_,P4,_,P6,_,_),
             NET,
             A1,
             A2,
             A3,A4,
             True_cnd,
             Else_cnd_in,
             pin(and,1,[Else_cnd_in,pin(not,1,Value)])):-
    !,
    chk_exec_expand3(Type,
                     Flat_op,
                     DBL,
                     P4,P6,
                     A1,
                     A2,
                     A3,A4,
                     pin(and,1,[True_cnd,Value])).
chk_exec_expand6(condition,
             [chk_op(A1,A2,A3,A4,pin(and,1,[True_cnd,Else_cnd_in]),NET,[])|Flat_op],
             DBL,
             alt,
             Value,
             facility(_,Type,_,P4,_,P6,_,_),
             NET,
             A1,
             A2,
             A3,A4,
             True_cnd,
             Else_cnd_in,
             pin(and,1,[Else_cnd_in,pin(not,1,Value)])):-
    !,
    chk_exec_expand3(Type,
                     Flat_op,
                     DBL,
                     P4,P6,
                     A1,
                     A2,
                     A3,A4,
                     pin(and,1,[pin(and,1,[True_cnd,Else_cnd_in]),Value])).
chk_exec_expand6(else,
             Flat_op,
             DBL,
             _,
             facility(_,Type,_,P4,_,P6,_,_),
             _,
             _,
             A1,
             A2,
             A3,A4,
             True_cnd,
             Else_cnd_in,
             _):-
    chk_exec_expand3(Type,
                     Flat_op,
                     DBL,
                     P4,P6,
                     A1,
                     A2,
                     A3,A4,
                     pin(and,1,[True_cnd,Else_cnd_in])).

    /*****************************/    
    /* Designed by Kiyoshi Oguri */
    /*          EXPANDER         */
    /*****************************/

expand_main(X):-
    dispf('** expantion start **\n'),
    dispf('** expand parameters are as follow **\n'),

    atom_value_read(mode_flg,             X15),
    tab,display('mode_flg---------------'),
    display(X15),nl,

    atom_value_read(tmp_value,            X1),
    tab,display('tmp_value--------------'),
    display(X1),nl,

    atom_value_read(post_opt,             X2),
    tab,display('post_opt---------------'),
    display(X2),nl,

    atom_value_read(time_limit,           X3),
    tab,display('time_limit-------------'),
    display(X3),nl,

    /** 1990.05.11 **/
    atom_value_read(multi_level_opt,      X9),
    if_then(
        eq(X9,no),
        atom_value_set(change_to_nand_nor,1)
    ),

    atom_value_read(change_to_nand_nor,   X4),
    tab,display('change_to_nand_nor-----'),
    display(X4),nl,

    atom_value_read(nld_out_mode,         X5),
    tab,display('nld_out_mode-----------'),
    display(X5),nl,

    atom_value_read(pcd_out_mode,         X6),
    tab,display('pcd_out_mode-----------'),
    display(X6),nl,

    atom_value_read(circuit_pcd_out_mode, X7),
    tab,display('circuit_pcd_out_mode---'),
    display(X7),nl,

    atom_value_read(sel_type,             X18),
    tab,display('sel_type---------------'),
    display(X18),nl,

    atom_value_read(exp_mode_flg,         X8),
    tab,display('exp_mode_flg-----------'),
    display(X8),nl,

/** 1990.05.11 **/
/*  atom_value_read(multi_level_opt,      X9), */
    tab,display('multi_level_opt--------'),
    display(X9),nl,

    atom_value_read(dont_care_opt,        X10),
    tab,display('dont_care_opt----------'),
    display(X10),nl,

    atom_value_read(level_factor,         X111),
    tab,display('level_factor-----------'),
    display(X111),nl,

    atom_value_read(to_other_tool,        X11),
    tab,display('to_other_tool----------'),
    display(X11),nl,

    atom_value_read(machine,              X12),
    tab,display('machine----------------'),
    display(X12),nl,

    atom_value_read(partial_demo,         X13),
    tab,display('partial_demo-----------'),
    display(X13),nl,
/*
    atom_value_read(trns_mode,            X14),
    tab,display('trns_mode--------------'),
    display(X14),nl,
*/
    atom_value_read(file_name,            X16),
    tab,display('file_name--------------'),
    display(X16),nl,

    atom_value_read(out_file_name,        X17),
    tab,display('out_file_name----------'),
    display(X17),nl,

    atom_value_set(error_flg,0),
    atom_value_read(mode_flg,MODE),
    atom_value_read(out_file_name,HSL_file_name),
    time(YEAR,MONTH,DAY,LOGNAME),
    see(HSL_file_name),
    fdispf('IDENT: SFL ;\n'),
    fdispf('DATE: %d/%d/%d ;\n',YEAR,MONTH,DAY),
    fdispf('AUTHOR: %s ;\n',LOGNAME),
    fdispf('VERSION: 1.8 ;\n'),
    fdispf('COMMENT: SFL pure logic ;\n'),
    fdispf('COLLECTION: SFL ;\n'),
    fdispf('PROJECT: SFL ;\n'),
    expand_module(X,MODE,CLASS,Test_Info), /* 1992.11.05 pass 1 */
    sort(CLASS,S_CLASS1,[]),
    atom_value_read(nld_out_mode,Nld_out_mode),
    atom_value_read(sel_type,Sel_type),
    if_then_else(
        eq(Sel_type,flat),
        eq(S_CLASS1,S_CLASS),
        and(
            sel_hie(S_CLASS1,S_CLASS2,[]),
            sort(S_CLASS2,S_CLASS,[])
        )
    ),
    submod_net_gen(Nld_out_mode,S_CLASS,PCDS,[]),
    fdispf('CEND ;\n'),
    seen,
    test_info_out(Test_Info),              /* 1992.11.05 pass 1 */
    atom_value_read(pcd_out_mode,Pcd_out_mode),
    if_then(
        eq(Pcd_out_mode,yes),
        and(
            sort(PCDS,S_PCDS,[]),
            submod_pcd_gen([pcd('high-','high-'),pcd('low-','low-')|S_PCDS])
        )
    ),
    atom_value_read(error_flg,Nof_error),
    dispf('\n\tThere are %d errors.\n\n',Nof_error).
/*------------------------------------------*/
expand_module([MODULE|REST],MODE,CLASS,[info(Name,Merged_Sels1,Class_Inst)|Rest_Test_Info]):- /* 1992.11.05 pass 1 */
    !,
    eq(MODULE,facility(Name,module,_,_,Facility,Stage,BEH,EOR_ID)), /* 1990.05.25 */
    test_class_inst(Facility,Class_Inst),  /* 1992.11.05 pass 1 */
    dispf('\n#### module: %s ####\n',Name),
    atom_value_read(exp_mode_flg,E_MODE),

    exp_exec_expand1(module,Flat_op,[],_,_,Facility,Stage,BEH,_,_,_), /* 1990.05.25 */
    detect_net_to_tmp(Flat_op,Net_to_tmp,[]),
    sort(Net_to_tmp,Net_to_tmp_sorted,[]),
    tmp_classify(Net_to_tmp_sorted,'????',_,TMP),

 /* assign_tmp(TMP), 1991.08.23 */
    dispf('** start checking exclusively constant assign **\n'),    /* 1991.08.27 */
    assign_tmp_flat_op_tmp(Flat_op,Flat_op_tmp,[]),                 /* 1991.08.27 */
    assign_tmp_do(TMP,Flat_op_tmp),                                 /* 1991.08.27 */
    dispf('** end checking exclusively constant assign **\n'),      /* 1991.08.27 */
                                                                    /* 1991.08.27 */
    if_then(
        eq(MODE,demo),
        and(
            dispf('** tmp reduction **\n'),
            list_list_display(TMP),
            nl
        )
    ),

    expand_module_flat(E_MODE,MODULE,GROUPS,GATES),
    !,
    dispf('** flatten end **\n'),
    expand_gate(Name,Cube_submod1,GATES,
                1,1,1,
                Not_id1,And_id1,Or_id1,
                Sorted_Nots1,Sorted_Ands1,Sorted_Ors1,
                Sorted_Sels1,MODE),
    !,
    expand_groups(Name,Cube_submod2,GROUPS,
                  Not_id1,And_id1,Or_id1,
                  _,_,Or_id2,
                  Sorted_Nots2,Sorted_Ands2,Sorted_Ors2,
                  STG_ST,Sorted_Sels2,MODE),
    !,
    append(Sorted_Nots1,Sorted_Nots2,Sorted_Nots),
    append(Sorted_Ands1,Sorted_Ands2,Sorted_Ands),
    append(Sorted_Ors1, Sorted_Ors2, Sorted_Ors),
    append(Sorted_Sels1,Sorted_Sels2,Sorted_Sels),
    !,
    dispf('\n#### into merge phase ####\n'),
    sel_merge(Name,Cube_submod3,Sorted_Sels,Merged_Sels,Or_id2,Add_Ors),
    !,
    list_count(Merged_Sels,Nof_sel),
    dispf('** selecter(%d) merge done **\n',Nof_sel),
    list_count(Add_Ors,Nof_or),
    dispf('** ors(%d) added **\n',Nof_or),
    if_then(
        eq(MODE,demo),
        and(
            dispf('** added ors are as follow **\n'),
            ors_display(Add_Ors,Or_id2),
            dispf('** merged selecters are as follow **\n'),
            sels_display(Merged_Sels,1)
        )
    ),
    append(Sorted_Ors,Add_Ors,Sorted_Ors_add),

    not_used_instr_check(Merged_Sels,Merged_Sels1,Facility), /* 1992.08.23 */

    multi(Sorted_Nots,Sorted_Ands,Sorted_Ors_add,Merged_Sels1, /* 1992.08.23 */
          NEW_Nots,NEW_Ands,NEW_Ors,NEW_Sels,MODE),

    /** 1990.05.11 **/
    atom_value_read(change_to_nand_nor,Max_Fin),
    if_then(
        eq(MODE,demo),
        if_then_else(
            bigger(Max_Fin,1),
            and(
                dispf('** result nots, nands, nors, selecters are as follow **\n'),
                nots_display(NEW_Nots,1),
                nands_display(NEW_Ands,1),
                nors_display(NEW_Ors,1),
                sels_display(NEW_Sels,1)
            ),
            and(
                dispf('** result nots, ands, ors, selecters are as follow **\n'),
                nots_display(NEW_Nots,1),
                ands_display(NEW_Ands,1),
                ors_display(NEW_Ors,1),
                sels_display(NEW_Sels,1)
            )
        )
    ),

    dispf('\n#### generating net list in HSL ####\n'),
    append(Cube_submod1,Cube_submod2,Cube_submod12),
    append(Cube_submod12,Cube_submod3,Cube_submod),
    hsl_out(Cube_submod,Name,
            Facility,
            Stage,
            STG_ST,
            NEW_Nots,NEW_Ands,NEW_Ors,NEW_Sels,
            C_CLASS,EOR_ID),
    !,
    dispf('** out one HSL module(%s) **\n',Name),
    expand_module(REST,MODE,R_CLASS,Rest_Test_Info),
    !,
    append(C_CLASS,R_CLASS,CLASS).
expand_module([],_,[],[]).

/*------------------------------------------*/ /* 1992.08.23 */
/*----- not used instr check ---------------*/
/*------------------------------------------*/
not_used_instr_check(Merged_Sels,Result_Sels,Facility):-
    detect_instr(Facility,Instr,[]),
    sort(Instr,S_Instr,[]),
    used_check(S_Instr,Merged_Sels,Added_Sels,[]),
    append(Merged_Sels,Added_Sels,Result_Sels).

/*------------------------------------------*/
detect_instr([facility(Name,submod,_,Facility,_,_,_,_)|Rest],A,C):-
    !,
    detect_instr1(Facility,A,B,Name),
    detect_instr(Rest,B,C).
detect_instr([facility(Name,circuit,_,Facility,_,_,_,_)|Rest],A,C):-
    !,
    detect_instr1(Facility,A,B,Name),
    detect_instr(Rest,B,C).
detect_instr([facility(Name,instrout,_,_,_,_,_,_)|Rest],[pin(instrout,1,Name)|B],C):-
    !,
    detect_instr(Rest,B,C).
detect_instr([facility(Name,instrself,_,_,_,_,_,_)|Rest],[pin(instrself,1,Name)|B],C):-
    !,
    detect_instr(Rest,B,C).
detect_instr([_|Rest],B,C):-
    !,
    detect_instr(Rest,B,C).
detect_instr([],A,A).
/*------------------------------------------*/
detect_instr1([facility(Name,instrin,_,_,_,_,_,_)|Rest],[pin(instrin,1,[Name,P_name])|B],C,P_name):-
    !,
    detect_instr1(Rest,B,C,P_name).
detect_instr1([_|Rest],B,C,P_name):-
    !,
    detect_instr1(Rest,B,C,P_name).
detect_instr1([],A,A,_).
/*------------------------------------------*/
used_check([Instr|Rest],Merged_Sels,B,C):-
    instr_find(Merged_Sels,Instr),
    !,
    used_check(Rest,Merged_Sels,B,C).
used_check([Instr|Rest],Merged_Sels,[sel(Instr,1,[src(pin(const,1,0),pin(const,1,1))])|B],C):-
    !,
    used_check(Rest,Merged_Sels,B,C).
used_check([],_,A,A).
/*------------------------------------------*/
instr_find([sel(Instr,_,_)|_],Instr):-
    !.
instr_find([_|Rest],Instr):-
    instr_find(Rest,Instr).

/*------------------------------------------*/
detect_net_to_tmp([flat_op(_,_,_,_,_,NETS)|REST],A,C):-
    !,
    detect_net_to_tmp1(NETS,A,B),
    detect_net_to_tmp(REST,B,C).
detect_net_to_tmp([],A,A).
/*------------------------------------------*/
detect_net_to_tmp1([NET|REST],[NET|B],C):-
    eq(NET,net(pin(tmp_org(_),_,_),_)),
    !,
    detect_net_to_tmp1(REST,B,C).
detect_net_to_tmp1([_|REST],B,C):-
    !,
    detect_net_to_tmp1(REST,B,C).
detect_net_to_tmp1([],A,A).
/*------------------------------------------*/
tmp_classify([ELM|REST],N,[ELM|RT1],RT2):-
    eq(ELM,net(pin(_,_,[N,_]),_)),
    !,
    tmp_classify(REST,N,RT1,RT2).
tmp_classify([ELM|REST],_,[],[RT1|RT2]):-
    !,
    eq(ELM,net(pin(_,_,[N,_]),_)),
    tmp_classify([ELM|REST],N,RT1,RT2).
tmp_classify([],_,[],[]).
/*------------------------------------------*/
/* 1991.08.23 *
assign_tmp([TMP|REST]):-
    !,
    list_count(TMP,N),
    if_then_else(
        eq(N,1),
        eq(TMP,[net(pin(_,_,[_,SRC]),SRC)]),
        eq(TMP,[net(pin(_,_,[_,multi_src]),_)|_])
    ),
    assign_tmp(REST).
assign_tmp([]).
* 1991.08.23 */
/********************************************************************************* 1991.08.27 */
assign_tmp_flat_op_tmp([flat_op(F1,F2,F3,F4,Cond,NETS)|REST],A,C):-             /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
    assign_tmp_flat_op_tmp1(NETS,F1,F2,F3,F4,Cond,A,B),                         /* 1991.08.27 */
    assign_tmp_flat_op_tmp(REST,B,C).                                           /* 1991.08.27 */
assign_tmp_flat_op_tmp([],A,A).                                                 /* 1991.08.27 */
/*-----------------------------------------*/                                   /* 1991.08.27 */
assign_tmp_flat_op_tmp1([NET|REST],                                             /* 1991.08.27 */
                        F1,F2,F3,F4,Cond,                                       /* 1991.08.27 */
                        [flat_op(F1,F2,F3,F4,Cond,NET)|B],C):-                  /* 1991.08.27 */
    eq(NET,net(pin(tmp_org(_),_,_),_)),                                                /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
    assign_tmp_flat_op_tmp1(REST,F1,F2,F3,F4,Cond,B,C).                         /* 1991.08.27 */
assign_tmp_flat_op_tmp1([_|REST],F1,F2,F3,F4,Cond,B,C):-                        /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
    assign_tmp_flat_op_tmp1(REST,F1,F2,F3,F4,Cond,B,C).                         /* 1991.08.27 */
assign_tmp_flat_op_tmp1([],_,_,_,_,_,A,A).                                      /* 1991.08.27 */
                                                                                /* 1991.08.27 */
/*******************************************/                                   /* 1991.08.27 */
assign_tmp_do([TMP|REST],Flat_op):-                                             /* 1991.08.27 */
    list_count(TMP,N),                                                          /* 1991.08.27 */
    eq(N,1),                                                                    /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
    eq(TMP,[net(pin(_,_,[_,SRC]),SRC)]),                                        /* 1991.08.27 */
    assign_tmp_do(REST,Flat_op).                                                /* 1991.08.27 */
assign_tmp_do([TMP|REST],Flat_op):-                                             /* 1991.08.27 */
    eq(TMP,[net(pin(_,Width,[Name,SRC]),_)|_]),                                 /* 1991.08.27 */
    assign_tmp_detect(Flat_op,Name,Flat_op_t),                                  /* 1991.08.27 */
    eq(Flat_op_t,[flat_op(F1,F2,F3,F4,_,_)|_]),                                 /* 1991.08.27 */
    assign_tmp_chk(Flat_op_t,F1,F2,F3,F4,Width,V,All_Cond),                     /* 1991.08.27 */
    assign_tmp_exclusive(All_Cond),                                             /* 1991.08.27 */
    dispf('** detect exclusively constant assign **\n'),                        /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
    assign_tmp_value1(V,V1,Width),                                              /* 1991.08.27 */
    rev_hierarchy(V1,V2),                                                       /* 1991.08.27 */
    assign_tmp_value2(V2,Width,SRC),                                            /* 1991.08.27 */
    assign_tmp_do(REST,Flat_op).                                                /* 1991.08.27 */
assign_tmp_do([TMP|REST],Flat_op):-                                             /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
    eq(TMP,[net(pin(_,_,[_,multi_src]),_)|_]),                                  /* 1991.08.27 */
    assign_tmp_do(REST,Flat_op).                                                /* 1991.08.27 */
assign_tmp_do([],_).                                                            /* 1991.08.27 */
                                                                                /* 1991.08.27 */
/*******************************************/                                   /* 1991.08.27 */
assign_tmp_detect([F|Rest],Name,[F|Result]):-                                   /* 1991.08.27 */
    eq(F,flat_op(_,_,_,_,_,net(pin(_,_,[Name,_]),_))),                          /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
   assign_tmp_detect(Rest,Name,Result).                                         /* 1991.08.27 */
assign_tmp_detect([_|Rest],Name,Result):-                                       /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
   assign_tmp_detect(Rest,Name,Result).                                         /* 1991.08.27 */
assign_tmp_detect([],_,[]).                                                     /* 1991.08.27 */
                                                                                /* 1991.08.27 */
/*******************************************/                                   /* 1991.08.27 */
assign_tmp_chk([flat_op(F1,F2,F3,F4,Cond,net(_,pin(const,Width,Const)))|Rest],  /* 1991.08.27 */
               F1,F2,F3,F4,Width,[[Cond,Const]|Result],[Cond|REsult]):-         /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
    assign_tmp_chk(Rest,F1,F2,F3,F4,Width,Result,REsult).                       /* 1991.08.27 */
assign_tmp_chk([],_,_,_,_,_,[],[]).                                             /* 1991.08.27 */
                                                                                /* 1991.08.27 */
/*******************************************/                                   /* 1991.08.27 */
assign_tmp_exclusive([Cond|REST]):-                                             /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
    assign_tmp_exclusive1(REST,Cond),                                           /* 1991.08.27 */
    assign_tmp_exclusive(REST).                                                 /* 1991.08.27 */
assign_tmp_exclusive([]).                                                       /* 1991.08.27 */
/*-----------------------------------------*/                                   /* 1991.08.27 */
assign_tmp_exclusive1([Cond|REST],Cond_t):-                                     /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
    bool_op_exp(pin(and,1,[Cond,Cond_t]),AND),                                  /* 1991.08.27 */
    bool_op_and_or_exp(AND,AND_OR,[]),                                          /* 1991.08.27 */
    eq(AND_OR,[]),                                                              /* 1991.08.27 */
    assign_tmp_exclusive1(REST,Cond_t).                                         /* 1991.08.27 */
assign_tmp_exclusive1([],_).                                                    /* 1991.08.27 */
                                                                                /* 1991.08.27 */
/*******************************************/                                   /* 1991.08.27 */
assign_tmp_value1([[Cond,Const]|Rest],[List_Cond|Result],Width):-               /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
    assign_tmp_reduction_const(Width,Const,List_Const,[]),                      /* 1991.08.27 */
    assign_tmp_value11(List_Const,Cond,List_Cond),                              /* 1991.08.27 */
    assign_tmp_value1(Rest,Result,Width).                                       /* 1991.08.27 */
assign_tmp_value1([],[],_).                                                     /* 1991.08.27 */
/*-----------------------------------------*/                                   /* 1991.08.27 */
assign_tmp_value11([Const|Rest],Cond,[pin(and,1,[Const,Cond])|Result]):-        /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
    assign_tmp_value11(Rest,Cond,Result).                                       /* 1991.08.27 */
assign_tmp_value11([],_,[]).                                                    /* 1991.08.27 */
/*-----------------------------------------*/                                   /* 1991.08.27 */
assign_tmp_value2([Bit],1,OR):-                                                 /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
    assign_tmp_value21(Bit,OR).                                                 /* 1991.08.27 */
assign_tmp_value2([Bit|Rest],W,pin(cat,W,[OR,Result])):-                        /* 1991.08.27 */
    assign_tmp_value21(Bit,OR),                                                 /* 1991.08.27 */
    sub1(W,W1),                                                                 /* 1991.08.27 */
    assign_tmp_value2(Rest,W1,Result).                                          /* 1991.08.27 */
/*-----------------------------------------*/                                   /* 1991.08.27 */
assign_tmp_value21([Pin],Pin):-!.                                               /* 1991.08.27 */
assign_tmp_value21([Pin|Rest],pin(or,1,[Pin,Result])):-                         /* 1991.08.27 */
    assign_tmp_value21(Rest,Result).                                            /* 1991.08.27 */
                                                                                /* 1991.08.27 */
/*******************************************/                                   /* 1991.08.27 */
/*      assign_tmp_reduction_const         */                                   /* 1991.08.27 */
/*******************************************/                                   /* 1991.08.27 */
assign_tmp_reduction_const(Width,[CONST|REST],T,B):-                            /* 1991.08.27 */
    bigger(Width,16),                                                           /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
    assign_tmp_reduction_const1(16,CONST,M,B),                                  /* 1991.08.27 */
    minus(Width,16,Width1),                                                     /* 1991.08.27 */
    assign_tmp_reduction_const(Width1,REST,T,M).                                /* 1991.08.27 */
assign_tmp_reduction_const(Width,CONST,T,B):-                                   /* 1991.08.27 */
    assign_tmp_reduction_const1(Width,CONST,T,B).                               /* 1991.08.27 */
/*-----------------------------------------*/                                   /* 1991.08.27 */
assign_tmp_reduction_const1(0,_,T,T):-                                          /* 1991.08.27 */
    !.                                                                          /* 1991.08.27 */
assign_tmp_reduction_const1(Width,CONST,[D|M],B):-                              /* 1991.08.27 */
    sub1(Width,Width1),                                                         /* 1991.08.27 */
    exp2(Width1,V),                                                             /* 1991.08.27 */
    if_then_else(                                                               /* 1991.08.27 */
        bigger(V,CONST),                                                        /* 1991.08.27 */
        and(                                                                    /* 1991.08.27 */
            eq(D,pin(const,1,0)),                                               /* 1991.08.27 */
            eq(CONST,CONST1)                                                    /* 1991.08.27 */
        ),                                                                      /* 1991.08.27 */
        and(                                                                    /* 1991.08.27 */
            eq(D,pin(const,1,1)),                                               /* 1991.08.27 */
            minus(CONST,V,CONST1)                                               /* 1991.08.27 */
        )                                                                       /* 1991.08.27 */
    ),                                                                          /* 1991.08.27 */
    assign_tmp_reduction_const1(Width1,CONST1,M,B).                             /* 1991.08.27 */
                                                                                /* 1991.08.27 */
/*******************************************/                                   /* 1991.08.27 */
/*      rev_hierarchy                      */                                   /* 1991.08.27 */
/*      ~~~~~~~~~~~~~                      */                                   /* 1991.08.27 */
/*      [[a1,a2,a3],[b1,b2,b3]]            */                                   /* 1991.08.27 */
/*                V                        */                                   /* 1991.08.27 */
/*     [[a1,b1],[a2,b2],[a3,b3]]           */                                   /* 1991.08.27 */
/*******************************************/                                   /* 1991.08.27 */
rev_hierarchy([A|Rest],RESULT):-                                                /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
    rev_hierarchy(Rest,Result),                                                 /* 1991.08.27 */
    rev_hierarchy1(Result,A,RESULT).                                            /* 1991.08.27 */
rev_hierarchy([],[]).                                                           /* 1991.08.27 */
/*-----------------------------------------*/                                   /* 1991.08.27 */
rev_hierarchy1([B|Rest_B],[A|Rest_A],[[A|B]|Result]):-                          /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
    rev_hierarchy1(Rest_B,Rest_A,Result).                                       /* 1991.08.27 */
rev_hierarchy1([],[A|Rest_A],[[A]|Result]):-                                    /* 1991.08.27 */
    !,                                                                          /* 1991.08.27 */
    rev_hierarchy1([],Rest_A,Result).                                           /* 1991.08.27 */
rev_hierarchy1([],[],[]).                                                       /* 1991.08.27 */
/********************************************************************************* 1991.08.27 */

expand_gate(_,[],[],
            Not_id,And_id,Or_id,
            Not_id,And_id,Or_id,
            [],[],[],[],_):-
    !.
expand_gate(M_Name,['-gate'],Flat_op,
            Not_id1,And_id1,Or_id1,
            Not_id2,And_id2,Or_id2,
            Sorted_Nots,Sorted_Ands,Sorted_Ors,
            Sorted_Sels_o,MODE):-
    dispf('\n#### start logic expand which appear in data transfer source ####\n'),
    expand_main_kernel(M_Name,'-gate',Flat_op,
           Not_id1,And_id1,Or_id1,
           Not_id2,And_id2,Or_id2,
           Sorted_Nots,Sorted_Ands,Sorted_Ors,
           _,Sorted_Sels_i,MODE),
    !,
    expand_gate1(Sorted_Sels_i,Sorted_Sels_o).
/*------------------------------------------*/
expand_gate1([sel(pin(gate,1,[_,CND]),1,[src(CND,_)])|REST],RESULT):-
    !,
    expand_gate1(REST,RESULT).
expand_gate1([Sel|REST],[Sel|RESULT]):-        /* for 'to_other_tool' */
    !,
    expand_gate1(REST,RESULT).
expand_gate1([],[]).
/*------------------------------------------*/
expand_groups(M_Name,Cube_submod,[g(Name,Flat_op)|REST],
              Not_id1,And_id1,Or_id1,
              Not_id3,And_id3,Or_id3,
              Sorted_Nots,Sorted_Ands,Sorted_Ors,
              STG_ST,Sorted_Sels,MODE):-
    !,
    dispf('\n#### start expand behavior in stage or instruct: %s ####\n',Name),
    if_then_else(
        eq(Flat_op,[]),
        and(
            eq(Not_id1,Not_id2),
            eq(And_id1,And_id2),
            eq(Or_id1,Or_id2),
            eq(Sorted_Nots1,[]),
            eq(Sorted_Ands1,[]),
            eq(Sorted_Ors1, []),
            eq(STG_ST1,     []),
            eq(Sorted_Sels1,[]),
            eq(Cube_submod1,[])
        ),
        and(
            expand_main_kernel(M_Name,Name,
                   Flat_op,
                   Not_id1,And_id1,Or_id1,
                   Not_id2,And_id2,Or_id2,
                   Sorted_Nots1,Sorted_Ands1,Sorted_Ors1,
                   STG_ST1,Sorted_Sels1,MODE),
            eq(Cube_submod1,[Name])
        )
    ),
    !,
    expand_groups(M_Name,Cube_submod2,REST,
                  Not_id2,And_id2,Or_id2,
                  Not_id3,And_id3,Or_id3,
                  Sorted_Nots2,Sorted_Ands2,Sorted_Ors2,
                  STG_ST2,Sorted_Sels2,MODE),
    !,
    append(Sorted_Nots1,Sorted_Nots2,Sorted_Nots),
    !,
    append(Sorted_Ands1,Sorted_Ands2,Sorted_Ands),
    !,
    append(Sorted_Ors1, Sorted_Ors2, Sorted_Ors),
    !,
    append(STG_ST1,     STG_ST2,     STG_ST),
    !,
    append(Sorted_Sels1,Sorted_Sels2,Sorted_Sels),
    append(Cube_submod1,Cube_submod2,Cube_submod).
expand_groups(_,[],[],
              A,B,C,
              A,B,C,
              [],[],[],
              [],[],_).
/*------------------------------------------*/
expand_module_flat(
        group,
        facility(_,module,_,_,Facility,Stage,BEH,_), /* 1990.05.25 */
        GROUPS,
        GATES):-
    !,
    expand_module_beh_flat(BEH, GROUPS0,GATES0), /* 1990.05.25 */
    expand_instrs_flat(Facility,GROUPS1,GATES1),
    expand_stages_flat(Stage,   GROUPS2,GATES2),
    append(GROUPS0, GROUPS1,GROUPS01), /* 1990.05.25 */
    append(GROUPS01,GROUPS2,GROUPS),   /* 1990.05.25 */
    append(GATES0,  GATES1, GATES01),  /* 1990.05.25 */
    append(GATES01, GATES2, GATES).    /* 1990.05.25 */
expand_module_flat(
        all,
        facility(_,module,_,_,Facility,Stage,BEH,_), /* 1990.05.25 */
        [g('-all',Flat_op1)],
        Flat_op2):-
    !,
    exp_exec_expand1(module,Flat_op,[],_,_,Facility,Stage,BEH,_,_,_), /* 1990.05.25 */
    detect_gate(Flat_op,Flat_op1,Flat_op2).
/*------------------------------------------*/

/** 1990.05.25 *----------------------------*/
expand_module_beh_flat(none,[],[]):-!.
expand_module_beh_flat(BEH,[g('-module',Flat_op1)],GATES):-
    !,
    exp_exec_expand2(Flat_op,[],BEH,'-','-','-','-'),
    detect_gate(Flat_op,Flat_op1,GATES).
/** 1990.05.25 *----------------------------*/

expand_instrs_flat(
        [facility(Name,instrin,_,_,BEH,_,_,_)|REST],
        [g(Name,Flat_op1)|GROUPS1],
        GATES):-
    !,
    exp_exec_expand1(instrin,Flat_op,[],Name,_,BEH,_,_,_,_,_),
    detect_gate(Flat_op,Flat_op1,Flat_op2),
    expand_instrs_flat(REST,GROUPS1,GATES1),
    append(Flat_op2,GATES1,GATES).
expand_instrs_flat(
        [facility(Name,instrself,_,_,BEH,_,_,_)|REST],
        [g(Name,Flat_op1)|GROUPS1],
        GATES):-
    !,
    exp_exec_expand1(instrself,Flat_op,[],Name,_,BEH,_,_,_,_,_),
    detect_gate(Flat_op,Flat_op1,Flat_op2),
    expand_instrs_flat(REST,GROUPS1,GATES1),
    append(Flat_op2,GATES1,GATES).
expand_instrs_flat(
        [facility(Name,submod,_,Facility,_,_,_,_)|REST],
        GROUPS,
        GATES):-
    !,
    expand_instrs_flat1(Facility,GROUPS1,GATES1,Name),
    expand_instrs_flat(REST,     GROUPS2,GATES2),
    append(GROUPS1,GROUPS2,GROUPS),
    append(GATES1,GATES2,GATES).
expand_instrs_flat(
        [_|REST],
        GROUPS,
        GATES):-
    !,
    expand_instrs_flat(REST,GROUPS,GATES).
expand_instrs_flat([],[],[]).
/*------------------------------------------*/
expand_instrs_flat1(
        [facility(Name,instrout,_,_,BEH,_,_,_)|REST],
        [g(Name,Flat_op1)|GROUPS1],
        GATES,P_Name):-
    !,
    exp_exec_expand1(instrout,Flat_op,[],Name,_,BEH,_,_,_,_,P_Name),
    detect_gate(Flat_op,Flat_op1,Flat_op2),
    expand_instrs_flat1(REST,GROUPS1,GATES1,P_Name),
    append(Flat_op2,GATES1,GATES).
expand_instrs_flat1(
        [_|REST],
        GROUPS,
        GATES,P_Name):-
    !,
    expand_instrs_flat1(REST,GROUPS,GATES,P_Name).
expand_instrs_flat1([],[],[],_).
/*------------------------------------------*/
expand_stages_flat(
        [facility(Name,stage,_,_,State,Segment,_,BEH)|REST],
        [g(Name,Flat_op1)|GROUPS1],
        GATES):-
    !,
    exp_exec_expand1(stage,Flat_op,[],Name,_,State,Segment,_,BEH,_,_),
    detect_gate(Flat_op,Flat_op1,Flat_op2),
    expand_stages_flat(REST,GROUPS1,GATES1),
    append(Flat_op2,GATES1,GATES).
expand_stages_flat([],[],[]).
/*--------------------------------------*/
/*      detect gate                     */
/*--------------------------------------*/
detect_gate([flat_op(A,B,C,D,E1,NET1)|REST1],
            [flat_op(A,B,C,D,E2,NET3)|REST2],
             Flat_op):-
    !,
    detect_subst_cat(E1,E2),
    detect_subst_cat_net(NET1,NET2),
    detect_gate1(NET2,NET3,F_OP),
    !,
    detect_gate(REST1,REST2,REST3),
    append(F_OP,REST3,Flat_op).
detect_gate([],[],[]).
/*--------------------------------------*/
detect_gate1([net(pin(tmp_org(old),W,[N,multi_src]),SRC)|REST1],[net(pin(TMP_V,W,N),SRC1)|REST2],Flat_op):-
    !,
    atom_value_read(tmp_value,TMP_V),
    detect_gate2(SRC,SRC1,F_OP),
    detect_gate1(REST1,REST2,REST3),
    append(F_OP,REST3,Flat_op).
detect_gate1([net(pin(tmp_org(TMP_V),W,[N,multi_src]),SRC)|REST1],[net(pin(TMP_V,W,N),SRC1)|REST2],Flat_op):-
    !,
    detect_gate2(SRC,SRC1,F_OP),
    detect_gate1(REST1,REST2,REST3),
    append(F_OP,REST3,Flat_op).
detect_gate1([net(pin(tmp_org(_),_,_),_)|REST1],REST2,REST3):-
    !,
    detect_gate1(REST1,REST2,REST3).
detect_gate1([net(DST,SRC)|REST1],[net(DST,SRC1)|REST2],Flat_op):-
    !,
    detect_gate2(SRC,SRC1,F_OP),
    detect_gate1(REST1,REST2,REST3),
    append(F_OP,REST3,Flat_op).
detect_gate1([],[],[]).
/*--------------------------------------*/
detect_gate2(pin(cat,W,[LP1,RP1]),pin(cat,W,[LP2,RP2]),Flat_op):-
    !,
    detect_gate2(LP1,LP2,FL),
    detect_gate2(RP1,RP2,FR),
    append(FL,FR,Flat_op).
detect_gate2(SRC,X,
   [flat_op('-','-','-','-',SRC,[net(pin(gate,1,[SRC,X]),pin(const,1,1))])]
    ):-
    detect_gate3(SRC),!.
detect_gate2(PIN,PIN,[]).
/*--------------------------------------*/
detect_gate3(pin(not,_,_)):-!.
detect_gate3(pin(or,_,_)):-!.
detect_gate3(pin(eor,_,_)):-!.
detect_gate3(pin(and,_,_)).
/*--------------------------------------*/
detect_subst_cat_net([net(DST,SRC1)|REST1],[net(DST,SRC2)|REST2]):-
    !,
    detect_subst_cat(SRC1,SRC2),
    detect_subst_cat_net(REST1,REST2).
detect_subst_cat_net([],[]).
/*--------------------------------------*/
/*  detect subst cat                    */
/*--not---------------------------------*/
detect_subst_cat(pin(not,1,PIN1),pin(not,1,PIN2)):-
    !,
    detect_subst_cat(PIN1,PIN2).
/*--or----------------------------------*/
detect_subst_cat(pin(or,1,[PIN1,PIN2]),pin(or,1,[PIN3,PIN4])):-
    !,
    detect_subst_cat(PIN1,PIN3),
    detect_subst_cat(PIN2,PIN4).
/*--eor---------------------------------*/
detect_subst_cat(pin(eor,1,[PIN1,PIN2]),pin(eor,1,[PIN3,PIN4])):-
    !,
    detect_subst_cat(PIN1,PIN3),
    detect_subst_cat(PIN2,PIN4).
/*--and---------------------------------*/
detect_subst_cat(pin(and,1,[PIN1,PIN2]),pin(and,1,[PIN3,PIN4])):-
    !,
    detect_subst_cat(PIN1,PIN3),
    detect_subst_cat(PIN2,PIN4).
/*--cat---------------------------------*/
detect_subst_cat(pin(cat,W,[PIN1,PIN2]),pin(cat,W,[PIN3,PIN4])):-
    !,
    detect_subst_cat(PIN1,PIN3),
    detect_subst_cat(PIN2,PIN4).
/*--subst-------------------------------*/
detect_subst_cat(pin(subst,1,[0,0,PIN1]),PIN2):-
    eq(PIN1,pin(_,1,_)),
    !,
    detect_subst_cat(PIN1,PIN2).

/** 1990.05.11 **/
detect_subst_cat(
    pin(subst,1,[LR,LR,PIN]),
    pin(const,1,0)
    ):-
    eq(PIN,pin(_,PW,_)),
    sub1(PW,PWP),
    bigger(LR,PWP),
    !.
detect_subst_cat(
    pin(subst,W,[L,R,PIN]),
    pin(cat,W,[pin(const,1,0),PIN1])
    ):-
    eq(PIN,pin(_,PW,_)),
    sub1(PW,PWP),
    bigger(L,R),
    bigger(L,PWP),
    !,
    sub1(L,LL),
    sub1(W,WW),
    detect_subst_cat(pin(subst,WW,[LL,R,PIN]),PIN1).
detect_subst_cat(
    pin(subst,W,[L,R,PIN]),
    pin(cat,W,[PIN1,pin(const,1,0)])
    ):-
    eq(PIN,pin(_,PW,_)),
    sub1(PW,PWP),
    bigger(R,L),
    bigger(R,PWP),
    !,
    sub1(R,RR),
    sub1(W,WW),
    detect_subst_cat(pin(subst,WW,[L,RR,PIN]),PIN1).

/*--subst-subst-------------------------*/
detect_subst_cat(
    pin(subst,W,[Left2,Right2,pin(subst,_,[Left1,Right1,PIN1])]),
    PIN                         /* 12 11 10 9 8 7 6 5 4 3 2 1 0 */
    ):-                         /*  (1)   r     :     l         */
    bigger(Right1,Left1),       /*        0 1 2 3 4 5 6         */
    !,                          /*  (2)     l  :  r             */
    minus(Right1,Left2,Left3),  /*  (3)     L  :  R             */
    minus(Right1,Right2,Right3),
    detect_subst_cat(pin(subst,W,[Left3,Right3,PIN1]),PIN).
detect_subst_cat(
    pin(subst,W,[Left2,Right2,pin(subst,_,[_,Right1,PIN1])]),
    PIN                        /* 12 11 10 9 8 7 6 5 4 3 2 1 0 */
    ):-                        /*  (1)   l     :     r         */
    !,                         /*        6 5 4 3 2 1 0         */
    plus(Right1,Left2,Left3),  /*  (2)       l  :  r           */
    plus(Right1,Right2,Right3),/*  (3)       L  :  R           */
    detect_subst_cat(pin(subst,W,[Left3,Right3,PIN1]),PIN).
/*--subst-cat---------------------------*/
detect_subst_cat(
    pin(subst,W,[Left,Right,pin(cat,_,[LPIN,RPIN])]),
    PIN
    ):-                     /*          R : L                 */
    bigger(Right,Left),     /* 12 11 10 9 8 7 6 | 5 4 3 2 1 0 */
    eq(RPIN,pin(_,RW,_)),   /*  6  5  4 3 2 1 0               */
    add1(Left,LLeft),       /*          r : l                 */
    bigger(LLeft,RW),
    !,
    minus(Left,RW,Leftn),
    minus(Right,RW,Rightn),
    detect_subst_cat(pin(subst,W,[Leftn,Rightn,LPIN]),PIN).
detect_subst_cat(
    pin(subst,W,[Left,Right,pin(cat,_,[_,RPIN])]),
    PIN
    ):-                     /*                      R  :  L   */
    bigger(Right,Left),     /* 12 11 10 9 8 7 6 | 5 4 3 2 1 0 */
    eq(RPIN,pin(_,RW,_)),   /*                      r  :  l   */
    bigger(RW,Right),
    !,
    detect_subst_cat(pin(subst,W,[Left,Right,RPIN]),PIN).
detect_subst_cat(
    pin(subst,W,[Left,Right,pin(cat,_,[LPIN,RPIN])]),
    pin(cat,W,[RPIN1,LPIN1])
    ):-                     /*           R      :      L       */
    bigger(Right,Left),     /*  12 11 10 9 8 7 6 | 5 4 3 2 1 0 */
    !,                      /*   6  5  4 3 2 1 0 | 5 4 3 2 1 0 */
    eq(RPIN,pin(_,RW,_)),   /*           R  :  l | r : L       */
    minus(Right,RW,Leftn),
    add1(Leftn,LWn),
    detect_subst_cat(pin(subst,LWn,[0,Leftn,LPIN]),LPIN1),
    sub1(RW,Rightn),
    minus(RW,Left,RWn),
    detect_subst_cat(pin(subst,RWn,[Left,Rightn,RPIN]),RPIN1).
detect_subst_cat(
    pin(subst,W,[Left,Right,pin(cat,_,[LPIN,RPIN])]),
    PIN
    ):-                     /*          L : R                 */
    eq(RPIN,pin(_,RW,_)),   /* 12 11 10 9 8 7 6 | 5 4 3 2 1 0 */
    add1(Right,RRight),     /*  6  5  4 3 2 1 0               */
    bigger(RRight,RW),      /*          l : r                 */
    !,
    minus(Left,RW,Leftn),
    minus(Right,RW,Rightn),
    detect_subst_cat(pin(subst,W,[Leftn,Rightn,LPIN]),PIN).
detect_subst_cat(
    pin(subst,W,[Left,Right,pin(cat,_,[_,RPIN])]),
    PIN
    ):-                     /*                      L  :  R   */
    eq(RPIN,pin(_,RW,_)),   /* 12 11 10 9 8 7 6 | 5 4 3 2 1 0 */
    bigger(RW,Left),        /*                      l  :  r   */
    !,
    detect_subst_cat(pin(subst,W,[Left,Right,RPIN]),PIN).
detect_subst_cat(
    pin(subst,W,[Left,Right,pin(cat,_,[LPIN,RPIN])]),
    pin(cat,W,[LPIN1,RPIN1])
    ):-                     /*           L      :      R       */
    !,                      /*  12 11 10 9 8 7 6 | 5 4 3 2 1 0 */
    eq(RPIN,pin(_,RW,_)),   /*   6  5  4 3 2 1 0 | 5 4 3 2 1 0 */
    minus(Left,RW,Leftn),   /*           l  :  r | l : R       */
    add1(Leftn,LWn),
    detect_subst_cat(pin(subst,LWn,[Leftn,0,LPIN]),LPIN1),
    sub1(RW,Rightn),
    minus(RW,Right,RWn),
    detect_subst_cat(pin(subst,RWn,[Rightn,Right,RPIN]),RPIN1).
/*--subst-tmp---------------------------*/
detect_subst_cat(
    pin(subst,W,[L,R,pin(tmp_org(old),TW,[TN,multi_src])]),
    pin(subst,W,[L,R,pin(TMP_V,TW,TN)])
    ):-
    !,
    atom_value_read(tmp_value,TMP_V).
detect_subst_cat(
    pin(subst,W,[L,R,pin(tmp_org(TMP_V),TW,[TN,multi_src])]),
    pin(subst,W,[L,R,pin(TMP_V,TW,TN)])
    ):-
    !.
detect_subst_cat(
    pin(subst,W,[L,R,pin(tmp_org(_),TW,[TN,Opt_Value])]),
    N_pin
    ):-!,
    detect_subst_cat(pin(subst,W,[L,R,Opt_Value]),N_pin).
/*--tmp---------------------------------*/
detect_subst_cat(
    pin(tmp_org(old),W,[N,multi_src]),
    pin(TMP_V,W,N)
    ):-
    !,
    atom_value_read(tmp_value,TMP_V).
detect_subst_cat(
    pin(tmp_org(TMP_V),W,[N,multi_src]),
    pin(TMP_V,W,N)
    ):-
    !.
detect_subst_cat(
    pin(tmp_org(_),W,[N,Opt_Value]),
    N_pin
    ):-!,
    detect_subst_cat(Opt_Value,N_pin).
/*--others------------------------------*/
detect_subst_cat(PIN,PIN).

    /********************************************/
    /*------------------------------------------*/
    /*          expand_main_kernel(    )        */
    /*------------------------------------------*/
    /********************************************/

expand_main_kernel(M_Name,Name,Flat_op,
       Not_start_id,And_start_id,Or_start_id,
       Not_start_nid,And_start_nid,Or_start_nid,
       Sorted_Nots,Sorted_Ands,Sorted_Ors,
       STG_ST,Sorted_Sels,MODE):-
    if_then(
        eq(MODE,demo),
        and(
            dispf('** input flatten operations are as follow **\n'),
            list_display(Flat_op)
        )
    ),
/**/remove_redundant_state(Flat_op,R_Flat_op),
    !,
/**/status_encode(R_Flat_op,Flat_op1,STG_ST),
    !,
/**/code_assign_show(STG_ST),
    dispf('** state encode done **\n'),
    if_then(
        eq(MODE,demo),
        and(
            dispf('** code assigned operations are as follow **\n'),
            list_display(Flat_op1)
        )
    ),
/**/bool_op(Flat_op1,All_Elements,[],All_Acts,[],Flat_cnd_net1,[],MODE),
    !,
    dispf('** bool op done **\n'),

    sort(Flat_cnd_net1,Sorted_Flat_cnd_net1),
    !,
    mini_divide(Sorted_Flat_cnd_net1,Blocked_Flat_cnd_net1,1),
    !,

    atom_value_read(to_other_tool,OTHER),
    if_then_else(
        eq(Flat_cnd_net1,[]),
        and(
            dispf('** remove this group **\n'),
            eq(Not_start_id,Not_start_nid),
            eq(And_start_id,And_start_nid),
            eq(Or_start_id,Or_start_nid),
            eq(Sorted_Nots,[]),
            eq(Sorted_Ands,[]),
            eq(Sorted_Ors, []),
            eq(Sorted_Sels,[])
        ),
        expand_after_bool_op_block(OTHER,M_Name,Name,1,
            MODE,All_Elements,All_Acts,Blocked_Flat_cnd_net1,
            Not_start_id,And_start_id,Or_start_id,
            Not_start_nid,And_start_nid,Or_start_nid,
            Sorted_Nots,Sorted_Ands,Sorted_Ors,Sorted_Sels)
    ).

/*------------------------------------------*/
/*---- remove redundant state --------------*/
/*------------------------------------------*/
remove_redundant_state(Flat_op,R_Flat_op):-
    !,
    flat(Flat_op,F_Flat_op),   /* tabun iranai */
    net_flat(F_Flat_op,N_Flat_op,[]),
    sort(N_Flat_op,S_Flat_op),
    remove_redundant_state1(S_Flat_op,R_Flat_op).
/*------------------------------------------*/
net_flat([flat_op(A,B,C,D,E,[])|Rest],Top,Btm):-
    !,
    net_flat(Rest,Top,Btm).
net_flat([flat_op(A,B,C,D,E,[NET|NRest])|Rest],[flat_op(A,B,C,D,E,[NET])|Top],Btm):-
    !,
    net_flat([flat_op(A,B,C,D,E,NRest)],Top,Mid),
    net_flat(Rest,Mid,Btm).
net_flat([],Top,Top).
/*------------------------------------------*/
remove_redundant_state1(Flat_op,NN_Flat_op):-
    state_hie(Flat_op,H_Flat_op),
    same_pair_chk(H_Flat_op,equal(Seg,St1,First1,St2,First2)),
    !,
    which_is_removable(St1,First1,St2,First2,RMV_St,RTN_St),
    dispf('\t%s.%s is removable\n',Seg,RMV_St),
    replace_redundant_state(Seg,Flat_op,N_Flat_op,RMV_St,RTN_St),
    remove_redundant_state1(N_Flat_op,NN_Flat_op).
remove_redundant_state1(F,F).
/*------------------------------------------*/
state_hie(List,[state(Seg,St,First,Block)|Result]):-
    eq(List,[flat_op(_,Seg,St,First,_,_)|_]),
    state_hie(List,[Seg,St,First],Block,[],Result).
/*------------------------------------------*/
state_hie([F|Rest],[Seg,St,First],[pair(Cond,Net)|T],B,Result):-
    eq(F,flat_op(_,Seg,St,First,Cond,Net)),
    !,
    state_hie(Rest,[Seg,St,First],T,B,Result).
state_hie(List,_,T,T,[state(Seg,St,First,Block)|Result]):-
    eq(List,[flat_op(_,Seg,St,First,_,_)|_]),
    !,
    state_hie(List,[Seg,St,First],Block,[],Result).
state_hie([],_,T,T,[]).
/*------------------------------------------*/
same_pair_chk([Target|Rest],Equal_States):-
    same_pair_chk1(Rest,Target,Equal_States),
    !.
same_pair_chk([_|Rest],Equal_States):-
    !,
    same_pair_chk(Rest,Equal_States).
same_pair_chk([],_):-
    fail.
/*------------------------------------------*/
same_pair_chk1([state(Seg,St1,First1,Pair)|_],state(Seg,St2,First2,Pair),equal(Seg,St1,First1,St2,First2)):-
    !.
same_pair_chk1([_|Rest],Target,Equal_States):-
    !,
    same_pair_chk1(Rest,Target,Equal_States).
same_pair_chk([],_,_):-
    fail.
/*------------------------------------------*/
which_is_removable(St1,t,St2,f,St2,St1):-!.
which_is_removable(St1,f,St2,f,St2,St1):-!.
which_is_removable(St1,f,St2,t,St1,St2).
/*------------------------------------------*/
replace_redundant_state(Seg,[flat_op(_,Seg,RMV_St,_,_,_)|Rest],Result,RMV_St,RTN_St):-
    !,
    replace_redundant_state(Seg,Rest,Result,RMV_St,RTN_St).
replace_redundant_state('-',
                        [flat_op(A,B,C,D,E,[net(Dst,pin(state,_,[RMV_St,A]))])|Rest],
                        [flat_op(A,B,C,D,E,[net(Dst,pin(state,_,[RTN_St,A]))])|Result],
                        RMV_St,RTN_St):-
    !,
    replace_redundant_state('-',Rest,Result,RMV_St,RTN_St).
replace_redundant_state(Seg,
                        [flat_op(A,B,C,D,E,[net(Dst,pin(state,_,[RMV_St,Seg,A]))])|Rest],
                        [flat_op(A,B,C,D,E,[net(Dst,pin(state,_,[RTN_St,Seg,A]))])|Result],
                        RMV_St,RTN_St):-
    !,
    replace_redundant_state(Seg,Rest,Result,RMV_St,RTN_St).
replace_redundant_state(Seg,
                        [Flat_op|Rest],
                        [Flat_op|Result],
                        RMV_St,RTN_St):-
    !,
    replace_redundant_state(Seg,Rest,Result,RMV_St,RTN_St).
replace_redundant_state(_,[],[],_,_).

/*------------------------------------------*/
/*---- mini divide -------------------------*/
/*------------------------------------------*/
expand_after_bool_op_block(OTHER,M_Name,Name,Blk_N_I,
            MODE,_,_,[Flat_cnd_net1|Rest],
            Not_start_id,And_start_id,Or_start_id,
            Not_start_nnid,And_start_nnid,Or_start_nnid,
            Sorted_Nots,Sorted_Ands,Sorted_Ors,Sorted_Sels):-
    !,
    mini_extract(Flat_cnd_net1,All_Elements,[],All_Acts,[]),
    !,
    expand_after_bool_op(OTHER,M_Name,Name,Blk_N_I,
            MODE,All_Elements,All_Acts,Flat_cnd_net1,
            Not_start_id,And_start_id,Or_start_id,
            Not_start_nid,And_start_nid,Or_start_nid,
            Sorted_Nots1,Sorted_Ands1,Sorted_Ors1,Sorted_Sels1),
    !,
    add1(Blk_N_I,Blk_N_O),
    expand_after_bool_op_block(OTHER,M_Name,Name,Blk_N_O,
            MODE,_,_,Rest,
            Not_start_nid,And_start_nid,Or_start_nid,
            Not_start_nnid,And_start_nnid,Or_start_nnid,
            Sorted_Nots2,Sorted_Ands2,Sorted_Ors2,Sorted_Sels2),
    !,
    append(Sorted_Nots1,Sorted_Nots2,Sorted_Nots),
    !,
    append(Sorted_Ands1,Sorted_Ands2,Sorted_Ands),
    !,
    append(Sorted_Ors1, Sorted_Ors2, Sorted_Ors),
    !,
    append(Sorted_Sels1,Sorted_Sels2,Sorted_Sels).
expand_after_bool_op_block(_,_,_,_,
            _,_,_,[],
            Not_start_id,And_start_id,Or_start_id,
            Not_start_id,And_start_id,Or_start_id,
            [],[],[],[]).
/*---------------------------------*/
mini_extract([flat_cnd_net1(Cnd,Net)|Rest],Top1,Btm1,Top2,Btm2):-
    !,
    mini_extract1(Cnd,Top1,Mid1),
    mini_extract1(Net,Top2,Mid2),
    mini_extract(Rest,Mid1,Btm1,Mid2,Btm2).
mini_extract([],A,A,B,B).
/*---------------------------------*/
mini_extract1([S|Rest],[S|Mid],Btm):-
    !,
    mini_extract1(Rest,Mid,Btm).
mini_extract1([],A,A).
/*---------------------------------*/
mini_subtract([C|A2],[C|B2],R):-
    !,
    mini_subtract(A2,B2,R).
mini_subtract([A1|A2],B,[A1|R]):-
    !,
    mini_subtract(A2,B,R).
mini_subtract([],_,[]).
/*---------------------------------*/
mini_divide([],[],_):-!.
mini_divide(All,[Block|Result],In):-         /* All must be sorted */
    list_count(All,Nof_All),
    dispf('** enter mini_divide ** level=%d, size=%d **\n',In,Nof_All),
    add1(In,Out),
    !,
    eq(All,[Seed|Target]),
    !,
    mini_block([Seed],[Seed],Target,Block),  /* Block must be sorted */
    !,
    mini_subtract(All,Block,Rest),
    !,
    mini_divide(Rest,Result,Out).
/*---------------------------------*/        /* Every arguments must be sorted */
mini_block([],Result,_,Result):-!.           /* Current and Target are complement */
mini_block(Seed,Current,Target,Result):-     /* Current includes Seed */
    mini_relation(Seed,Target,New_Seed),
    !,
    append(Current,New_Seed,Total),
    !,
    sort(Total,New_Current),
    !,
    mini_subtract(Target,New_Seed,New_Target),
    !,
    mini_block(New_Seed,New_Current,New_Target,Result).
/*---------------------------------*/
mini_relation([Seed|Rest],Target,Result):-
    !,
    mini_relation1(Target,Seed,Result1),
    !,
    mini_relation(Rest,Target,Result2),
    !,
    append(Result1,Result2,Result3),
    !,
    sort(Result3,Result).
mini_relation([],_,[]).
/*---------------------------------*/
mini_relation1([Target|Rest],Seed,[Target|Result]):-
    mini_intersection(Target,Seed),
    !,
    mini_relation1(Rest,Seed,Result).
mini_relation1([_|Rest],Seed,Result):-
    !,
    mini_relation1(Rest,Seed,Result).
mini_relation1([],_,[]).
/*---------------------------------*/
mini_intersection(flat_cnd_net1(_,Net_a),flat_cnd_net1(_,Net_b)):-
    mini_intersection_net(Net_a,Net_b),
    !.
mini_intersection(flat_cnd_net1(Cnd_a,_),flat_cnd_net1(Cnd_b,_)):-
    mini_intersection_cnd(Cnd_a,Cnd_b).
/*---------------------------------*/
mini_intersection_net([A|_],B):-
    mini_intersection_net1(B,A),
    !.
mini_intersection_net([_|A],B):-
    mini_intersection_net(A,B).
/*---------------------------------*/
mini_intersection_net1([B|_],B):-
    !.
mini_intersection_net1([_|B],A):-
    mini_intersection_net1(B,A).
/*---------------------------------*/
mini_intersection_cnd([A|_],B):-
    mini_intersection_cnd1(B,A),
    !.
mini_intersection_cnd([_|A],B):-
    mini_intersection_cnd(A,B).
/*---------------------------------*/
mini_intersection_cnd1([B|_],A):-
    intmini_eq(B,A),
    !.
mini_intersection_cnd1([_|B],A):-
    mini_intersection_cnd1(B,A).

/*------------------------------------------*/
/*---- expand after bool op ----------------*/
/*------------------------------------------*/
expand_after_bool_op(no,M_Name,Name,Blk_N,
    MODE,All_Elements,All_Acts,Flat_cnd_net1,
    Not_start_id,And_start_id,Or_start_id,
    Not_start_nid,And_start_nid,Or_start_nid,
    Sorted_Nots,Sorted_Ands,Sorted_Ors,Sorted_Sels):-
    !,
    if_then(
        eq(MODE,demo),
        and(
            dispf('** reduced operations are as follow **\n'),
            flat_cnd_net1_display(Flat_cnd_net1)
        )
    ),
    sort(All_Elements,SAll_Elements,[]),
    !,
/**/intmini_sort(SAll_Elements,Sorted_Elements,[]),
    !,
    dispf('** condition elements sort done **\n'),
    if_then(
        eq(MODE,demo),
        and(
            dispf('** all condition elements are as follow **\n'),
            list_display(Sorted_Elements)
        )
    ),
    sort(All_Acts,Sorted_Acts,[]),
    !,
    dispf('** actions sort done **\n'),
    if_then(
        eq(MODE,demo),
        and(
            dispf('** all actions are as follow **\n'),
            list_display(Sorted_Acts)
        )
    ),
/**/transfer_detect(Sorted_Acts,D_elms,S_elms),
    !,
    sort(D_elms,Sorted_D_elms,[]),
    !,
    dispf('** destinations sort done **\n'),
    if_then(
        eq(MODE,demo),
        and(
            dispf('** all destination elements are as follow **\n'),
            list_display(Sorted_D_elms)
        )
    ),
    sort(S_elms,Sorted_S_elms,[]),
    !,
    dispf('** sources sort done **\n'),
    if_then(
        eq(MODE,demo),
        and(
            dispf('** all source elements are as follow **\n'),
            list_display(Sorted_S_elms)
        )
    ),
    list_count(Sorted_Elements,N1),
    list_count(Sorted_Acts,N2),
    list_count(Flat_cnd_net1,N3),
    dispf('** Nof inputs = %d, Nof outputs = %d, Nof cubes = %d **\n',N1,N2,N3),
    sdispf('%s-%s-%d.cube',M_Name,Name,Blk_N,F_Name),
/**/intmini_out(F_Name,Flat_cnd_net1,Sorted_Elements,Sorted_Acts,N1,N2),
    !,
    dispf('** start logic compaction **\n'),
    if_then_else(
        eq(MODE,demo),
        and(
            catf(F_Name),
            mini(1,F_Name,Nof_cubes,ADRS)
        ),
        mini(0,F_Name,Nof_cubes,ADRS)
    ),
    dispf('** logic compaction done **\n'),
/**/get_mini2(Sorted_Elements,
              0,    /* 0 is the first value of part id */
              Nof_cubes,
    /*-->*/   Nots,
              ADRS),
    !,
    sort(Nots,Sorted_Nots,[]),
    !,
    list_count(Sorted_Nots,N4),
    plus(Not_start_id,N4,Not_start_nid),
    dispf('** nots(%d) extraction done **\n',N4),
    if_then(
        eq(MODE,demo),
        and(
            dispf('** generated nots are as follow **\n'),
            nots_display(Sorted_Nots,Not_start_id)
        )
    ),
/**/get_mini3(Nof_cubes,
              Sorted_Elements,
    /*-->*/   Ands,
              ADRS,
              Sorted_Nots,Not_start_id),
    !,
    sort(Ands,Sorted_Ands,[]),
    !,
    list_count(Sorted_Ands,N5),
    plus(And_start_id,N5,And_start_nid),
    dispf('** ands(%d) extraction done **\n',N5),
    if_then(
        eq(MODE,demo),
        and(
            dispf('** generated ands are as follow **\n'),
            ands_display(Sorted_Ands,And_start_id)
        )
    ),
    list_count(Sorted_Elements,Acts_prt),
/**/get_mini4(Sorted_Acts,
              0,    /* 0 is the first value of position */
              Nof_cubes,
    /*-->*/   Ors,
              ADRS,
              Acts_prt,
              Sorted_Elements,
              Sorted_Nots,Not_start_id,
              Sorted_Ands,And_start_id),
    !,
    sort(Ors,Sorted_Ors,[]),
    !,
    list_count(Sorted_Ors,N6),
    plus(Or_start_id,N6,Or_start_nid),
    dispf('** ors(%d) extraction done **\n',N6),
    if_then(
        eq(MODE,demo),
        and(
            dispf('** generated ors are as follow **\n'),
            ors_display(Sorted_Ors,Or_start_id)
        )
    ),
/**/get_mini5(Sorted_D_elms,
              Sorted_Acts,
              Nof_cubes,
    /*-->*/   Sels,
              ADRS,
              Acts_prt,
              Sorted_Elements,
              Sorted_Nots,Not_start_id,
              Sorted_Ands,And_start_id,
              Sorted_Ors,Or_start_id),
    !,
    sort(Sels,Sorted_Sels,[]),
    !,
    list_count(Sorted_Sels,N7),
    dispf('** selectors(%d) extraction done **\n',N7),
    if_then(
        eq(MODE,demo),
        and(
            dispf('** generated selectors are as follow **\n'),
            sels_display(Sorted_Sels,1)
        )
    ),
    free_cube.
/*------------------------------------------*/
expand_after_bool_op(yes,M_Name,Name,Blk_N,
    MODE,All_Elements,All_Acts,Flat_cnd_net1,
    Not_start_id,And_start_id,Or_start_id,
    Not_start_id,And_start_id,Or_start_id,
    [],[],[],Sorted_Sels):-
    !,
    if_then(
        eq(MODE,demo),
        and(
            dispf('** reduced operations are as follow **\n'),
            flat_cnd_net1_display(Flat_cnd_net1)
        )
    ),
    sort(All_Elements,SAll_Elements,[]),
    !,
/**/intmini_sort(SAll_Elements,Sorted_Elements,[]),
    !,
    dispf('** condition elements sort done **\n'),
    if_then(
        eq(MODE,demo),
        and(
            dispf('** all condition elements are as follow **\n'),
            list_display(Sorted_Elements)
        )
    ),
    sort(All_Acts,Sorted_Acts,[]),
    !,
    dispf('** actions sort done **\n'),
    if_then(
        eq(MODE,demo),
        and(
            dispf('** all actions are as follow **\n'),
            list_display(Sorted_Acts)
        )
    ),
    sdispf('%s-%s-%d',M_Name,Name,Blk_N,S_Name),
    sdispf('%s-%s-%d.cube',M_Name,Name,Blk_N,F_Name),
/**/cube_out(F_Name,S_Name,Flat_cnd_net1,Sorted_Elements,Sorted_Acts,Sorted_Sels),
    !.

    /**********************/    /*         facility()          */
    /* expand 1,2,3,4,5,6 */    /*             v               */
    /**********************/    /* flat_op(stg,seg,st,first,cnd,net) */

exp_exec_expand(A,A,none,_,_):-    /* kono gyou ha facility ga 'VAR' or 'none' no tokino tame */
    !.
exp_exec_expand(Flat_op,DBL,facility(Name,Type,_,P4,P5,P6,P7,P8),A1,A2):-
    !,
    exp_exec_expand1(Type,Flat_op,DBL,Name,P4,P5,P6,P7,P8,A1,A2).
exp_exec_expand(Flat_op,DBL,[facility(Name,Type,_,P4,P5,P6,P7,P8)|REST],A1,A2):-
    !,
    exp_exec_expand1(Type,Flat_op,Flat_op1,Name,P4,P5,P6,P7,P8,A1,A2),
    exp_exec_expand(Flat_op1,DBL,REST,A1,A2).
exp_exec_expand(A,A,[],_,_).
/*------------------------------------------*/
/*            exp_exec_expand1  (type)      */
/*------------------------------------------*/
exp_exec_expand1(module,Flat_op,DBL,_,_,Facility,Stage,BEH,_,_,_):- /* 1990.05.25 */
    !,
    exp_exec_expand2(Flat_op,Flat_op11,BEH,'-','-','-','-'), /* 1990.05.25 */
    exp_exec_expand(Flat_op11,Flat_op1,Facility,_,_), /* 1990.05.25 */
    exp_exec_expand(Flat_op1,DBL,Stage,_,_).
exp_exec_expand1(submod,Flat_op,DBL,Name,Facility,_,_,_,_,_,_):-
    !,
    exp_exec_expand(Flat_op,DBL,Facility,_,Name).
exp_exec_expand1(instrin,Flat_op,DBL,Name,_,BEH,_,_,_,_,_):-
    !,
    exp_exec_expand2(Flat_op,DBL,BEH,'-','-',Name,'-').
exp_exec_expand1(instrout,Flat_op,DBL,Name,_,BEH,_,_,_,_,A2):-
    !,
    exp_exec_expand2(Flat_op,DBL,BEH,'-',A2,Name,'-').
exp_exec_expand1(instrself,Flat_op,DBL,Name,_,BEH,_,_,_,_,_):-
    !,
    exp_exec_expand2(Flat_op,DBL,BEH,'-','+',Name,'-').
exp_exec_expand1(stage,Flat_op,DBL,Name,_,State,Segment,_,BEH,_,_):-
    !,
    exp_exec_expand2(Flat_op,Flat_op1,BEH,Name,'-','-','-'),
    exp_exec_expand(Flat_op1,Flat_op2,State,Name,'-'),
    exp_exec_expand(Flat_op2,DBL,Segment,Name,_).
exp_exec_expand1(segment,Flat_op,DBL,Name,State,_,BEH,_,_,A1,_):-
    !,
    exp_exec_expand2(Flat_op,Flat_op1,BEH,A1,Name,'-','-'),
    exp_exec_expand(Flat_op1,DBL,State,A1,Name).
exp_exec_expand1(state,Flat_op,DBL,Name,BEH,FIRST_F,_,_,_,A1,A2):-
    !,
    exp_exec_expand2(Flat_op,DBL,BEH,A1,A2,Name,FIRST_F).
exp_exec_expand1(submod_class,A,A,_,_,_,_,_,_,_,_):-
    !.
exp_exec_expand1(circuit_class,A,A,_,_,_,_,_,_,_,_):-
    !.
exp_exec_expand1(circuit,A,A,_,_,_,_,_,_,_,_):-
    !.
exp_exec_expand1(tmp_org(_),A,A,_,_,_,_,_,_,_,_):-
    !.
exp_exec_expand1(bus_org,A,A,_,_,_,_,_,_,_,_):-
    !.
exp_exec_expand1(sel_org,A,A,_,_,_,_,_,_,_,_):-
    !.
exp_exec_expand1(input,A,A,_,_,_,_,_,_,_,_):-
    !.
exp_exec_expand1(output,A,A,_,_,_,_,_,_,_,_):-
    !.
exp_exec_expand1(bidirect,A,A,_,_,_,_,_,_,_,_):-
    !.
exp_exec_expand1(reg,A,A,_,_,_,_,_,_,_,_):-
    !.

exp_exec_expand1(reg_wr,A,A,_,_,_,_,_,_,_,_):- /* 1990.05.29 */
    !.                                         /* 1990.05.29 */

exp_exec_expand1(reg_ws,A,A,_,_,_,_,_,_,_,_):- /* 1990.06.18 */
    !.                                         /* 1990.06.18 */

exp_exec_expand1(scan_reg,A,A,_,_,_,_,_,_,_,_):-
    !.
exp_exec_expand1(scan_reg_wr,A,A,_,_,_,_,_,_,_,_):-
    !.
exp_exec_expand1(scan_reg_ws,A,A,_,_,_,_,_,_,_,_):-
    !.

exp_exec_expand1(mem,A,A,_,_,_,_,_,_,_,_):-
    !.
exp_exec_expand1(task,A,A,_,_,_,_,_,_,_,_):-
    !.
exp_exec_expand1(Type,A,A,_,_,_,_,_,_,_,_):-
    dispf('Cannot expand here(%s)',Type),nl.
/*------------------------------------------*/
/*            exp_exec_expand2  (BEH)       */
/*------------------------------------------*/
exp_exec_expand2(A,A,none,_,_,_,_):-  /* kono gyou ha facility ga 'VAR' mataha 'none' no tokino tame */
    !.
exp_exec_expand2(Flat_op,
             DBL,
             facility(_,Type,_,P4,_,_,_,_),
             A1,
             A2,
             A3,A4):-
    exp_exec_expand3(Type,Flat_op,DBL,P4,A1,A2,A3,A4,pin(const,1,1)).
/*------------------------------------------*/
/*            exp_exec_expand3  (BEH type)  */
/*------------------------------------------*/
exp_exec_expand3(par,
             Flat_op,
             DBL,
             BEH,
             A1,A2,A3,A4,
             True_cnd):-
    !,
    exp_exec_expand4(Flat_op,DBL,BEH,A1,A2,A3,A4,True_cnd).
exp_exec_expand3(alt,
             Flat_op,
             DBL,
             BEH,
             A1,A2,A3,A4,
             True_cnd):-
    !,
    exp_exec_expand5(alt,Flat_op,DBL,BEH,A1,A2,A3,A4,True_cnd,pin(const,1,1),_).
exp_exec_expand3(any,
             Flat_op,
             DBL,
             BEH,
             A1,A2,A3,A4,
             True_cnd):-
    !,
    exp_exec_expand5(any,Flat_op,DBL,BEH,A1,A2,A3,A4,True_cnd,pin(const,1,1),_).
exp_exec_expand3(simple,
             [flat_op(A1,A2,A3,A4,True_cnd,NET)|DBL],
             DBL,
             NET,
             A1,A2,A3,A4,
             True_cnd).
/*------------------------------------------*/
/*            exp_exec_expand4  (par)       */
/*------------------------------------------*/
exp_exec_expand4(Flat_op,
             DBL,
             [facility(_,Type,_,P4,_,_,_,_)|REST],
             A1,
             A2,
             A3,A4,
             True_cnd):-
    !,
    exp_exec_expand3(Type,Flat_op,Flat_op1,P4,A1,A2,A3,A4,True_cnd),
    exp_exec_expand4(Flat_op1,
                     DBL,
                     REST,
                     A1,
                     A2,
                     A3,A4,
                     True_cnd).
exp_exec_expand4(A,A,[],_,_,_,_,_).
/*------------------------------------------*/
/*            exp_exec_expand5  (alt,any)   */
/*------------------------------------------*/
exp_exec_expand5(Type,
             Flat_op,
             DBL,
             [facility(_,Type1,_,P4,P5,P6,_,_)|REST],
             A1,
             A2,
             A3,A4,
             True_cnd,
             Else_cnd_in,
             Else_cnd_out1):-
    !,
    exp_exec_expand6(Type1,Flat_op,Flat_op1,Type,P4,P5,P6,A1,A2,A3,A4,True_cnd,Else_cnd_in,Else_cnd_out),
    exp_exec_expand5(Type,
                     Flat_op1,
                     DBL,
                     REST,
                     A1,
                     A2,
                     A3,A4,
                     True_cnd,
                     Else_cnd_out,
                     Else_cnd_out1).
exp_exec_expand5(_,A,A,[],_,_,_,_,_,_,_).
/*------------------------------------------*/
/*            exp_exec_expand6  (condition) */
/*------------------------------------------*/
exp_exec_expand6(condition,
             [flat_op(A1,A2,A3,A4,True_cnd,NET)|Flat_op],
             DBL,
             any,
             Value,
             facility(_,Type,_,P4,_,_,_,_),
             NET,
             A1,
             A2,
             A3,A4,
             True_cnd,
             Else_cnd_in,
             pin(and,1,[Else_cnd_in,pin(not,1,Value)])):-
    !,
    exp_exec_expand3(Type,
                     Flat_op,
                     DBL,
                     P4,
                     A1,
                     A2,
                     A3,A4,
                     pin(and,1,[True_cnd,Value])).
exp_exec_expand6(condition,
             [flat_op(A1,A2,A3,A4,pin(and,1,[True_cnd,Else_cnd_in]),NET)|Flat_op],
             DBL,
             alt,
             Value,
             facility(_,Type,_,P4,_,_,_,_),
             NET,
             A1,
             A2,
             A3,A4,
             True_cnd,
             Else_cnd_in,
             pin(and,1,[Else_cnd_in,pin(not,1,Value)])):-
    !,
    exp_exec_expand3(Type,
                     Flat_op,
                     DBL,
                     P4,
                     A1,
                     A2,
                     A3,A4,
                     pin(and,1,[pin(and,1,[True_cnd,Else_cnd_in]),Value])).
exp_exec_expand6(else,
             Flat_op,
             DBL,
             _,
             facility(_,Type,_,P4,_,_,_,_),
             _,
             _,
             A1,
             A2,
             A3,A4,
             True_cnd,
             Else_cnd_in,
             _):-
    exp_exec_expand3(Type,
                     Flat_op,
                     DBL,
                     P4,
                     A1,
                     A2,
                     A3,A4,
                     pin(and,1,[True_cnd,Else_cnd_in])).

    /*****************/     /* flat_op(STG,SEG,ST,FIRST,CND,NET) */
    /* status encode */     /*             v               */
    /*****************/     /*       flat_op1(CND,NET)     */

status_encode(Flat_op,Flat_op1,STG_ST):-
    encode_classify(Flat_op,STG,SEG,ST,INSTR,GOTO,[],FIRST,[]),
    /* classify into STG, SEG, ST, INSTR */
    /* STG, SEG means super behavior */
    sort(GOTO,S_GOTO),
    !,
    sort(FIRST,S_FIRST),
    encode_detect_sts(ST,STS),  /* generate STS: st(STG,SEG,ST) */
    sort(STS,S_STS),
    !,
    encode_detect_stgs(S_STS,STGS),  /* generate STGS: stg(STG) */
    sort(STGS,S_STGS),
    encode_detect_stg_st(S_STGS,S_STS,S_GOTO,S_FIRST,STG_ST),
    /* generate STG_ST: stg(STG,[st(SEG,ST),...],Size,[SEG,...]) */
    encode_super_seg(SEG,S_STS,SEG1,[]),
    append(SEG1,ST,SEG_ST),
    change_cond_nets_instr(INSTR,INSTR1),
    change_cond_nets_super(STG,STG1),
/**/change_cond_nets(SEG_ST,STG_ST,SEG_ST1),
    append(INSTR1,STG1,W),
    append(W,SEG_ST1,Flat_op1).
/*-------------------------------*/
encode_classify([Flat_op|REST],STG,SEG,ST,[Flat_op|INSTR],T,B,T1,B1):-
    eq(Flat_op,flat_op('-',_,_,_,_,_)),
    !,
    encode_classify(REST,STG,SEG,ST,INSTR,T,B,T1,B1).
encode_classify([Flat_op|REST],[Flat_op|STG],SEG,ST,INSTR,T,B,T1,B1):-
    eq(Flat_op,flat_op(_,'-','-',_,_,_)),
    !,
    encode_classify(REST,STG,SEG,ST,INSTR,T,B,T1,B1).
encode_classify([Flat_op|REST],STG,[Flat_op|SEG],ST,INSTR,T,B,T1,B1):-
    eq(Flat_op,flat_op(_,_,'-',_,_,_)),
    !,
    encode_classify(REST,STG,SEG,ST,INSTR,T,B,T1,B1).
encode_classify([Flat_op|REST],STG,SEG,[Flat_op|ST],INSTR,T,B,T1,B1):-
    !,
    eq(Flat_op,flat_op(Stg,Seg,St,Fst,_,Net)),
    detect_goto(Net,Stg,Seg,St,T,M),
    detect_first(Stg,Seg,St,Fst,T1,M1),
    encode_classify(REST,STG,SEG,ST,INSTR,M,B,M1,B1).
encode_classify([],[],[],[],[],A,A,B,B).
/*-------------------------------*/
detect_goto([NET|REST],STG,SEG,ST,T,B):-
    !,
    detect_goto1(NET,STG,SEG,ST,T,M),
    detect_goto(REST,STG,SEG,ST,M,B).
detect_goto([],_,_,_,T,T).
/*-------------------------------*/
detect_goto1(NET,STG,SEG,ST,[goto(STG,SEG,ST,SEG1,ST1)|B],B):-
    detect_goto2(NET,SEG1,ST1),
    !.
detect_goto1(_,_,_,_,T,T).
/*-------------------------------*/
detect_goto2(
    net(pin(stage,_,_),pin(state,_,[ST,_])),
    '-',
    ST):-!.
detect_goto2(
    net(pin(stage,_,_),pin(state,_,[ST,SEG,_])),
    SEG,
    ST):-!.
detect_goto2(
    net(pin(segment,_,_),pin(state,_,[ST,_])),
    '-',
    ST):-!.
detect_goto2(
    net(pin(segment,_,_),pin(state,_,[ST,SEG,_])),
    SEG,
    ST).
/*-------------------------------*/
detect_first(STG,'-',ST,t,[first(STG,'-',ST)|B],B):-
    !.
detect_first(_,_,_,_,T,T).
/*-------------------------------*/
encode_detect_sts([flat_op(STG,SEG,ST,_,_,_)|REST],
    [st(STG,SEG,ST)|RESULT]):-
    !,
    encode_detect_sts(REST,RESULT).
encode_detect_sts([],[]).
/*-------------------------------*/
encode_detect_stgs([st(STG,_,_)|REST],
    [stg(STG)|RESULT]):-
    !,
    encode_detect_stgs(REST,RESULT).
encode_detect_stgs([],[]).
/*-------------------------------*/
encode_detect_stg_st([stg(STG)|REST],
                     SSTS,      /* [st(STG,SEG,ST),...] */
                     SGOTO,     /* [goto(STG,SEG,ST,SEG1,ST1),...] */
                     SFIRST,    /* [first(STG,-,ST),...] */
                     [stg(STG,XX,Size,S_SEG)|RESULT]):-
    !,
    encode_detect_stg_st1(SSTS,STG,X),   /* X = [st(SEG,ST),...] */
    encode_detect_stg_st2(SGOTO,STG,Y),  /* Y = [goto(SEG,ST,SEG1,ST1),...] */
    encode_detect_stg_st3(SFIRST,STG,Z), /* Z = [first('-',ST),...] */
    /***********************************/
    /*  state code assignment          */
    /*  XX's order means code 0,1,2,.. */
    /***********************************/
    code_assign(X,Y,Z,XX),
    list_count(XX,N),
    exp2u(Size,N),
    encode_detect_seg(XX,SEG),            /* SEG = [seg,...] */
    sort(SEG,S_SEG),
    encode_detect_stg_st(REST,SSTS,SGOTO,SFIRST,RESULT).
encode_detect_stg_st([],_,_,_,[]).
/*-------------------------------*/
encode_detect_stg_st1([st(STG,SEG,ST)|REST],
                  STG,
                  [st(SEG,ST)|RESULT]):-
    !,
    encode_detect_stg_st1(REST,STG,RESULT).
encode_detect_stg_st1([_|REST],STG,RESULT):-
    !,
    encode_detect_stg_st1(REST,STG,RESULT).
encode_detect_stg_st1([],_,[]).
/*-------------------------------*/
encode_detect_stg_st2([goto(STG,SEG,ST,SEG1,ST1)|REST],
                  STG,
                  [goto(SEG,ST,SEG1,ST1)|RESULT]):-
    !,
    encode_detect_stg_st2(REST,STG,RESULT).
encode_detect_stg_st2([_|REST],STG,RESULT):-
    !,
    encode_detect_stg_st2(REST,STG,RESULT).
encode_detect_stg_st2([],_,[]).
/*-------------------------------*/
encode_detect_stg_st3([first(STG,'-',ST)|REST],
                  STG,
                  [first('-',ST)|RESULT]):-
    !,
    encode_detect_stg_st3(REST,STG,RESULT).
encode_detect_stg_st3([_|REST],STG,RESULT):-
    !,
    encode_detect_stg_st3(REST,STG,RESULT).
encode_detect_stg_st3([],_,[]).

/*-------------------------------*/
/*      code assignment          */
/*-------------------------------*/
code_assign(IN_ST,GOTO,FIRST,RESULT):-
    code_assign_pre(IN_ST,ALL_ST),
    eq(FIRST,[first(Seg,St)]),
    code_assign_goto_merge(ALL_ST,ALL_ST,GOTO),
    !,
    code_assign_find(ALL_ST,Seg,St,First),
    code_assign_reach(First,ALL_ST,OK,NG),
    list_count(NG,NGC),
    if_then(
        bigger(NGC,0),
        and(
            dispf('Warning! following states are nonsense, there are no path to the states.\n'),
            code_assign_list(NG)
        )
    ),
    list_count(OK,N),
    exp2u(Size,N),
    code_assign_allocate(OK,Size),
    code_assign_reset(First),
    sub1(N,M),
    atom_value_set(min,M),
    atom_value_read(mode_flg,MODE),
    code_assign_call_code(M,1,First,[First],MODE),
    !,
    code_assign_sort(OK,S_OK,[]),
    code_assign_insert_dummy(0,S_OK,RESULT).

/*--pre-----------------------------*/
code_assign_pre([st(SEG,ST)|REST],[st(SEG,ST,GOTO,CODE,CHK)|RESULT]):-
    !,
    code_assign_pre(REST,RESULT).
code_assign_pre([],[]).

/*--goto merge-----------------------------*/
code_assign_goto_merge([st(SEG,ST,Goto,_,_)|REST],ALL,GOTO):-
    !,
    code_assign_goto_merge1(GOTO,SEG,ST,ALL,Goto),
    code_assign_goto_merge(REST,ALL,GOTO).
code_assign_goto_merge([],_,_).
/*---------*/
code_assign_goto_merge1([goto(SEG,ST,SEG1,ST1)|REST],SEG,ST,ALL,[goto(GST)|RESULT]):-
    code_assign_find(ALL,SEG1,ST1,GST),
    !,
    code_assign_goto_merge1(REST,SEG,ST,ALL,RESULT).
code_assign_goto_merge1([_|REST],SEG,ST,ALL,RESULT):-
    !,
    code_assign_goto_merge1(REST,SEG,ST,ALL,RESULT).
code_assign_goto_merge1([],_,_,_,[]).

/*--find-----------------------------*/
code_assign_find([GST|_],SEG,ST,GST):-
    eq(GST,st(SEG,ST,_,_,_)),
    !.
code_assign_find([_|REST],SEG,ST,GST):-
    code_assign_find(REST,SEG,ST,GST).

/*--reach-----------------------------*/
code_assign_reach(FIRST,[S1|REST],[S1|OK],NG):-
    chk(code_assign_reach1(FIRST,S1)),
    !,
    code_assign_reach(FIRST,REST,OK,NG).
code_assign_reach(FIRST,[S1|REST],OK,[S1|NG]):-
    !,
    code_assign_reach(FIRST,REST,OK,NG).
code_assign_reach(_,[],[],[]).
/*---------*/
code_assign_reach1(st(SEG,ST,_,_,_),st(SEG,ST,_,_,_)):-
    !.
code_assign_reach1(st(_,_,GOTO,_,chk),END):-
    code_assign_reach2(GOTO,NEXT),
    code_assign_reach1(NEXT,END).
/*---------*/
code_assign_reach2([goto(NEXT)|_],NEXT):-
    eq(NEXT,st(_,_,_,_,CHK)),
    var(CHK).
code_assign_reach2([_|REST],NEXT):-
    code_assign_reach2(REST,NEXT).

/*--allocate-----------------------------*/
code_assign_allocate([st(_,_,_,Code,_)|REST],Size):-
    !,
    code_assign_allocate1(Size,Code),
    code_assign_allocate(REST,Size).
code_assign_allocate([],_).
/*---------*/
code_assign_allocate1(0,[]):-
    !.
code_assign_allocate1(IN,[C|RESULT]):-
    sub1(IN,OUT),
    code_assign_allocate1(OUT,RESULT).

/*--reset-----------------------------*/
code_assign_reset(st(_,_,_,CODE,_)):-
    code_assign_reset1(CODE).
code_assign_reset1([0|REST]):-
    !,
    code_assign_reset1(REST).
code_assign_reset1([]).

/*--call code-----------------------------*/
code_assign_call_code(M,Dist,First,Done,MODE):-
    code_assign_code(M,0,Dist,First,Done,RESULT,[First]),
    !,
    if_then(
        eq(MODE,demo),
        and(
            dispf('\tCode distance is %d\n',Dist),
            dispf('\tNof remained states is 0\n'),
            dispf('\tFollowings are last state-code assignment.\n'),
            code_assign_list_last(RESULT)
        )
    ).
code_assign_call_code(M,Dist,First,Done,MODE):-
    atom_value_read(min,MIN),
    code_assign_code(M,MIN,Dist,First,Done,RESULT,[First]),
    !,
    if_then(
        eq(MODE,demo),
        and(
            dispf('\tCode distance is %d\n',Dist),
            dispf('\tNof remained states is %d\n',MIN),
            dispf('\tFollowings are current state-code assignment.\n'),
            code_assign_list(RESULT)
        )
    ),
    add1(Dist,DDist),
    code_assign_call_code(MIN,DDist,First,RESULT,MODE).

/*--code-----------------------------*/
code_assign_code(IN,END,Dist,st(_,_,GOTO,CODE,CHK),DONE,RESULT,PATH):-
    if_then(
        var(CHK),
        eq(CHK,Dist)
    ),
    code_assign_code1(GOTO,CODE,NEXT,DONE,Dist,FLG,PATH),
    if_then_else(
        eq(FLG,new),
        and(
            sub1(IN,OUT),
            code_assign_code(OUT,END,Dist,NEXT,[NEXT|DONE],RESULT,[NEXT|PATH])
        ),
        code_assign_code(IN,END,Dist,NEXT,DONE,RESULT,[NEXT|PATH])
    ).
code_assign_code(IN,END,_,_,DONE,DONE,_):-
    atom_value_read(min,MIN),
    if_then(
        bigger(MIN,IN),
        atom_value_set(min,IN)
    ),
    eq(IN,END).
/*---------*/
code_assign_code1([goto(NEXT)|_],CODE,NEXT,DONE,Dist,new,_):-
    eq(NEXT,st(_,_,_,Code,CHK)),
    var(CHK),
    code_assign_code2(CODE,Code,DONE,Dist).
code_assign_code1([goto(NEXT)|_],_,NEXT,_,Dist,old,PATH):-
    eq(NEXT,st(_,_,_,_,CHK)),
    int(CHK),
    bigger(Dist,CHK),
    code_assign_new_state(PATH,NEXT).
code_assign_code1([_|REST],CODE,NEXT,DONE,Dist,FLG,PATH):-
    code_assign_code1(REST,CODE,NEXT,DONE,Dist,FLG,PATH).
/*---------*/
code_assign_code2(CODE,Code,DONE,Dist):-
    code_assign_inv_max(1,Dist,CODE,Code),
    code_assign_new_code(DONE,Code),
    !.
/*---------*/
code_assign_inv_max(N,_,CODE,Code):-
    code_assign_inv(N,CODE,Code).
code_assign_inv_max(N,M,CODE,Code):-
    bigger(M,N),
    add1(N,NN),
    code_assign_inv_max(NN,M,CODE,Code).
/*---------*/
code_assign_inv(1,[A|B],[C|D]):-
    code_assign_inv1(A,C),
    code_assign_eq(B,D).
code_assign_inv(1,[A|B],[C|D]):-
    code_assign_eq1(A,C),
    code_assign_inv(1,B,D).
code_assign_inv(N,[A|B],[C|D]):-
    code_assign_inv1(A,C),
    sub1(N,M),
    code_assign_inv(M,B,D).
code_assign_inv(N,[A|B],[C|D]):-
    code_assign_eq1(A,C),
    code_assign_inv(N,B,D).
/*---------*/
code_assign_inv1(1,0):-!.
code_assign_inv1(0,1).
/*---------*/
code_assign_eq([A|B],[C|D]):-
    !,
    code_assign_eq1(A,C),
    code_assign_eq(B,D).
code_assign_eq([],[]).
/*---------*/
code_assign_eq1(1,1):-!.
code_assign_eq1(0,0).

/*--insert dummy-----------------------------*/
code_assign_insert_dummy(_,[],[]):-
    !.
code_assign_insert_dummy(IN,[st(SEG,ST,_,CODE,_)|REST],[st(SEG,ST)|RESULT]):-
    code_assign_code_value(CODE,_,V),
    eq(IN,V),
    !,
    add1(IN,OUT),
    code_assign_insert_dummy(OUT,REST,RESULT).
code_assign_insert_dummy(IN,REST,[st('-','-')|RESULT]):-
    add1(IN,OUT),
    code_assign_insert_dummy(OUT,REST,RESULT).
/*---------*/
code_assign_code_value([1|REST],PP,VV):-
    !,
    code_assign_code_value(REST,P,V),
    plus(P,V,VV),
    plus(P,P,PP).
code_assign_code_value([0|REST],PP,V):-
    !,
    code_assign_code_value(REST,P,V),
    plus(P,P,PP).
code_assign_code_value([],1,0).

/*--new state-----------------------------*/
code_assign_new_state([st(A,B,_,_,_)|_],st(A,B,_,_,_)):-
    !,
    fail.
code_assign_new_state([_|REST],NEXT):-
    !,
    code_assign_new_state(REST,NEXT).
code_assign_new_state([],_).

/*--new code-----------------------------*/
code_assign_new_code([st(_,_,_,CODE,_)|_],CODE):-
    !,
    fail.
code_assign_new_code([_|REST],CODE):-
    !,
    code_assign_new_code(REST,CODE).
code_assign_new_code([],_).

/*--list-----------------------------*/
code_assign_list([st(SEG,ST,_,Code,_)|REST]):-
    !,
    dispf('\t%s %s ',SEG,ST),display(Code),nl,
    code_assign_list(REST).
code_assign_list([]).

/*--list last-----------------------------*/
code_assign_list_last([st(SEG,ST,GOTO,Code,_)|REST]):-
    !,
    dispf('\t** %s %s **\n\t\tcode: ',SEG,ST),
    display(Code),nl,
    code_assign_list_goto(GOTO),
    code_assign_list_last(REST).
code_assign_list_last([]).
/*---------*/
code_assign_list_goto([goto(st(SEG,ST,_,_,_))|REST]):-
    !,
    dispf('\t\tgoto: %s %s\n',SEG,ST),
    code_assign_list_goto(REST).
code_assign_list_goto([]).

/*--sort-----------------------------*/
code_assign_sort([X1|X2],Y1,Y2):-
    !,
    code_assign_part(X1,X2,P1,P2),
    code_assign_sort(P1,Y1,[X1|S]),
    code_assign_sort(P2,S,Y2).
code_assign_sort([],Y,Y).
/*---------*/
code_assign_part(X,[Y|Z],P1,[Y|P2]):-
    code_assign_cmp(X,Y),
    !,
    code_assign_part(X,Z,P1,P2).
code_assign_part(X,[Y|Z],[Y|P1],P2):-
    !,
    code_assign_part(X,Z,P1,P2).
code_assign_part(_,[],[],[]).
/*---------*/
code_assign_cmp(st(_,_,_,C1,_),st(_,_,_,C2,_)):-
    cmp(C2,C1).

/*-------------------------------*/
/*      end code assignment      */
/*-------------------------------*/

/*-------------------------------*/
encode_detect_seg([st('-',_)|REST],RESULT):-
    !,
    encode_detect_seg(REST,RESULT).
encode_detect_seg([st(SEG,_)|REST],[SEG|RESULT]):-
    !,
    encode_detect_seg(REST,RESULT).
encode_detect_seg([],[]).
/*-------------------------------*/
encode_super_seg([flat_op(A1,B1,_,_,D1,E1)|REST],ST,TOP,BTM):-
    !,
    encode_super_seg1(ST,A1,B1,D1,E1,TOP,MID),
    encode_super_seg(REST,ST,MID,BTM).
encode_super_seg([],_,A,A).
/*---------*/
encode_super_seg1([st(A1,B1,C)|REST],
              A1,
              B1,
              D1,
              E1,
              [flat_op(A1,B1,C,'-',D1,E1)|M],
              BT):-
    !,
    encode_super_seg1(REST,A1,B1,D1,E1,M,BT).
encode_super_seg1([_|REST],A1,B1,D1,E1,M,BT):-
    !,
    encode_super_seg1(REST,A1,B1,D1,E1,M,BT).
encode_super_seg1([],_,_,_,_,T,T).
/*-------------------------------*/
/*     change instr condition    */
/*-------------------------------*/
change_cond_nets_instr([flat_op('-','-','-',_,CND,NET)|REST],
    [flat_op1(CND,NET)|RESULT]):-
    !,
    change_cond_nets_instr(REST,RESULT).
change_cond_nets_instr([flat_op('-','-',INSTR,_,CND,NET)|REST],
    [flat_op1(pin(and,1,[pin(instrin,1,INSTR),CND]),NET)|RESULT]):-
    !,
    change_cond_nets_instr(REST,RESULT).
change_cond_nets_instr([flat_op('-','+',INSTR,_,CND,NET)|REST],
    [flat_op1(pin(and,1,[pin(instrself,1,INSTR),CND]),NET)|RESULT]):-
    !,
    change_cond_nets_instr(REST,RESULT).
change_cond_nets_instr([flat_op('-',SUBMOD,INSTR,_,CND,NET)|REST],
    [flat_op1(pin(and,1,[pin(instrout,1,[INSTR,SUBMOD]),CND]),NET)|RESULT]):-
    !,
    change_cond_nets_instr(REST,RESULT).
change_cond_nets_instr([],[]).
/*-------------------------------*/
/*     change super operation    */
/*-------------------------------*/
change_cond_nets_super([flat_op(STG,_,_,_,CND,NET)|REST],
    [flat_op1(pin(and,1,[pin(task,1,STG),CND]),NET)|RESULT]):-
    !,
    change_cond_nets_super(REST,RESULT).
change_cond_nets_super([],[]).
/*-------------------------------*/
/*      change state operation   */
/*-------------------------------*/
change_cond_nets([flat_op(STG,SEG,ST,_,CND,NET)|REST],
                 STG_ST,
                 [flat_op1(pin(and,1,[ST_CND,CND]),NETT)|RESULT]):-
    find_stg(STG_ST,STG,STS,Size,SEGS),
    detect_id(STS,SEG,ST,0,ID),
    !,
    if_then_else(       /* change 1990.03.22 */
        eq(STS,[_]),
        and(
            eq(ST_CND,pin(task,1,STG)),
            eq(NETT,NET)
        ),
        and(
            change_cond(Size,ID,STG,ST_CND),
            change_nets(NET,NETT,[],STG,STS,Size,SEGS,ID)
        )
    ),
    change_cond_nets(REST,STG_ST,RESULT).
change_cond_nets([_|REST],
                 STG_ST,
                 RESULT):-
    !,
    change_cond_nets(REST,STG_ST,RESULT).
change_cond_nets([],_,[]).
/*-------------------------------*/
find_stg([stg(STG,STS,Size,SEGS)|_],STG,STS,Size,SEGS):-
    !.
find_stg([_|REST],STG,STS,Size,SEGS):-
    find_stg(REST,STG,STS,Size,SEGS).
/*-------------------------------*/
find_seg([SEG|_],SEG):-
    !.
find_seg([_|REST],SEG):-
    find_seg(REST,SEG).
/*-------------------------------*/
detect_id([st(SEG,ST)|_],SEG,ST,ID,ID):-
    !.
detect_id([_|REST],SEG,ST,ID1,ID3):-
    add1(ID1,ID2),
    detect_id(REST,SEG,ST,ID2,ID3).
/*-------------------------------*/
/*  change condition     DO!     */
/*-------------------------------*/
change_cond(0,_,STG,pin(task,1,STG)):-
    !.
change_cond(S,
        V,
        STG,
        pin(and,1,[ pin(stage,1,[STG,S1]) ,RESULT])
    ):-         /* example S: 4,3,2,1 */
    sub1(S,S1),        /* S1: 3,2,1,0 */
    exp2(S1,V1),       /* V1: 8,4,2,1 */
    sub1(V1,V2),       /* V2: 7,3,1,0 */
    bigger(V,V2),
    !,
    minus(V,V1,V3),
    change_cond(S1,V3,STG,RESULT).
change_cond(S,
        V,
        STG,
        pin(and,1,[ pin(not,1, pin(stage,1,[STG,S1]) ) ,RESULT])
    ):-
    sub1(S,S1),
    change_cond(S1,V,STG,RESULT).
/*-------------------------------*/
/*  change net           DO!     */
/*-------------------------------*/
change_nets([NET|REST],TOP,BTM,STG,STS,Size,SEGS,ID):-
    !,
    change_nets1(NET,TOP,MID,STG,STS,Size,SEGS,ID),
    change_nets(REST,MID,BTM,STG,STS,Size,SEGS,ID).
change_nets([],T,T,_,_,_,_,_).
/*-------------------------------*/
change_nets1(net(pin(stage,Size,STG),pin(state,_,[ST,STG])),
             TOP,
             BTM,       /* stage <- state */
             STG,
             STS,
             Size,
             _,
             IID):-
    !,
    if_then_else(
        detect_id(STS,'-',ST,0,ID),
        change_nets2(Size,ID,IID,STG,TOP,BTM),
        and(
            dispf('???ERROR! transition state ''%s'' of stage ''%s'' is not exist ???\n',ST,STG),
            atom_value_read(error_flg,X),
            add1(X,Y),
            atom_value_set(error_flg,Y),
            eq(TOP,BTM)
        )
    ).
change_nets1(net(pin(stage,Size,STG),pin(state,_,[ST,SEG,STG])),
             TOP,
             BTM,       /* stage <- seg-state */
             STG,
             STS,
             Size,
             SEGS,
             IID):-
    !,
    if_then_else(
        find_seg(SEGS,SEG),
        if_then_else(
            detect_id(STS,SEG,ST,0,ID),
            change_nets2(Size,ID,IID,STG,TOP,BTM),
            and(
                dispf('???ERROR! transition state ''%s'' of seg ''%s'' of stage ''%s'' is not exist ???\n',ST,SEG,STG),
                atom_value_read(error_flg,X),
                add1(X,Y),
                atom_value_set(error_flg,Y),
                eq(TOP,BTM)
            )
        ),
        and(
            dispf('???ERROR! transition segment ''%s'' of stage ''%s'' is not exist ???\n',SEG,STG),
            atom_value_read(error_flg,X),
            add1(X,Y),
            atom_value_set(error_flg,Y),
            eq(TOP,BTM)
        )
    ).
/*-------------*/
change_nets1(net(pin(segment,Size,[SEG,STG]),pin(state,_,[ST,STG])),
             TOP,
             BTM,       /* segment <- state */
             STG,
             STS,
             Size,
             SEGS,
             _):-
    !,
    if_then_else(
        find_seg(SEGS,SEG),
        if_then_else(
            detect_id(STS,'-',ST,0,ID),
            change_nets3(Size,ID,STG,SEG,TOP,BTM),
            and(
                dispf('???ERROR! return state ''%s'' of stage ''%s'' is not exist ???\n',ST,STG),
                atom_value_read(error_flg,X),
                add1(X,Y),
                atom_value_set(error_flg,Y),
                eq(TOP,BTM)
            )
        ),
        and(
            dispf('???ERROR! return area with segment ''%s'' of stage ''%s'' is not exist ???\n',SEG,STG),
            atom_value_read(error_flg,X),
            add1(X,Y),
            atom_value_set(error_flg,Y),
            eq(TOP,BTM)
        )
    ).
change_nets1(net(pin(segment,Size,[SEG,STG]),pin(state,_,[ST,SEG1,STG])),
             TOP,
             BTM,       /* segment <- seg-state */
             STG,
             STS,
             Size,
             SEGS,
             _):-
    !,
    if_then_else(
        find_seg(SEGS,SEG),
        if_then_else(
            detect_id(STS,SEG1,ST,0,ID),
            change_nets3(Size,ID,STG,SEG,TOP,BTM),
            and(
                dispf('???ERROR! return state ''%s'' of seg ''%s'' of stage ''%s'' is not exist ???\n',ST,SEG1,STG),
                atom_value_read(error_flg,X),
                add1(X,Y),
                atom_value_set(error_flg,Y),
                eq(TOP,BTM)
            )
        ),
        and(
            dispf('???ERROR! return area with segment ''%s'' of stage ''%s'' is not exist ???\n',SEG,STG),
            atom_value_read(error_flg,X),
            add1(X,Y),
            atom_value_set(error_flg,Y),
            eq(TOP,BTM)
        )
    ).
/*-------------*/
change_nets1(net(pin(stage,Size,STG),pin(segment,Size,[SEG,STG])),
             TOP,
             BTM,       /* stage <- segment */
             STG,       /* all cpoy */
             _,
             Size,
             _,
             _):-
    !,
    change_nets4(Size,STG,SEG,TOP,BTM).
/*-------------*/
change_nets1(net(pin(segment,Size,[SEG,STG]),pin(segment,Size,[SEG1,STG])),
             TOP,
             BTM,       /* segment <- segment1 */
             STG,       /* all copy */
             _,
             Size,
             SEGS,
             _):-
    !,
    if_then_else(
        find_seg(SEGS,SEG),
        change_nets5(Size,STG,SEG,SEG1,TOP,BTM),
        and(
            dispf('???ERROR! return area with segment ''%s'' of stage ''%s'' is not exist ???\n',SEG,STG),
            atom_value_read(error_flg,X),
            add1(X,Y),
            atom_value_set(error_flg,Y),
            eq(TOP,BTM)
        )
    ).
/*-------------*/
change_nets1(NET,[NET|T],T,_,_,_,_,_).
/*-------------------------------*/ /* stage <- state */
change_nets2(0,_,_,_,T,T):-
    !.
change_nets2(S,
             V,
             ID,
             STG,
             MID,
             BTM):-
    sub1(S,S1),
    exp2(S1,V1),
    sub1(V1,V2),
    bigger(V,V2),
    bigger(ID,V2),
    !,
    minus(V,V1,V3),
    minus(ID,V1,ID3),
    change_nets2(S1,V3,ID3,STG,MID,BTM).
change_nets2(S,
         V,
         ID,
         STG,
         [net(pin(stage,1,[STG,S1]),pin(const,1,1))|MID],
         BTM
    ):-
    sub1(S,S1),
    exp2(S1,V1),
    sub1(V1,V2),
    bigger(V,V2),
    !,
    minus(V,V1,V3),
    change_nets2(S1,V3,ID,STG,MID,BTM).
change_nets2(S,
         V,
         ID,
         STG,
         [net(pin(stage,1,[STG,S1]),pin(const,1,0))|MID],
         BTM
    ):-
    sub1(S,S1),
    exp2(S1,V1),
    sub1(V1,V2),
    bigger(ID,V2),
    !,
    minus(ID,V1,ID3),
    change_nets2(S1,V,ID3,STG,MID,BTM).
change_nets2(S,
         V,
         ID,
         STG,
         MID,
         BTM
    ):-
    sub1(S,S1),
    change_nets2(S1,V,ID,STG,MID,BTM).
/*-------------------------------*/ /* segment <- state */
change_nets3(0,_,_,_,T,T):-
    !.
change_nets3(S,
         V,
         STG,
         SEG,
         [net(pin(segment,1,[SEG,STG,S1]),pin(const,1,1))|MID],
         BTM
    ):-
    sub1(S,S1),
    exp2(S1,V1),
    sub1(V1,V2),
    bigger(V,V2),
    !,
    minus(V,V1,V3),
    change_nets3(S1,V3,STG,SEG,MID,BTM).
change_nets3(S,
         V,
         STG,
         SEG,
         [net(pin(segment,1,[SEG,STG,S1]),pin(const,1,0))|MID],
         BTM
    ):-
    sub1(S,S1),
    change_nets3(S1,V,STG,SEG,MID,BTM).
/*-------------------------------*/ /* stage <- segment */
change_nets4(0,_,_,T,T):-
    !.
change_nets4(S,
         STG,
         SEG,
         [net(pin(stage,1,[STG,S1]),pin(segment,1,[SEG,STG,S1]))|MID],
         BTM
    ):-
    sub1(S,S1),
    change_nets4(S1,STG,SEG,MID,BTM).
/*-------------------------------*/ /* segment <- segment1 */
change_nets5(0,_,_,_,T,T):-
    !.
change_nets5(S,
         STG,
         SEG,
         SEG1,
         [net(pin(segment,1,[SEG,STG,S1]),pin(segment,1,[SEG1,STG,S1]))|MID],
         BTM
    ):-
    sub1(S,S1),
    change_nets5(S1,STG,SEG,SEG1,MID,BTM).

    /********************/
    /* code assign show */
    /********************/

code_assign_show([stg(STG,STS,_,_)|REST]):-
    !,
    dispf('    == stage %s''s state code assignment ==\n',STG),
    code_assign_show1(STS,0),
    code_assign_show(REST).
code_assign_show([]).
/*-------------------------------*/
code_assign_show1([st('-','-')|REST],I):-
    !,
    dispf('    -- code %d is not used --\n',I),
    add1(I,O),
    code_assign_show1(REST,O).
code_assign_show1([st('-',ST)|REST],I):-
    !,
    dispf('    -- code %d is assigned to %s --\n',I,ST),
    add1(I,O),
    code_assign_show1(REST,O).
code_assign_show1([st(SEG,ST)|REST],I):-
    !,
    dispf('    -- code %d is assigned to %s of %s --\n',I,ST,SEG),
    add1(I,O),
    code_assign_show1(REST,O).
code_assign_show1([],_).

    /***********/
    /* bool op */
    /***********/

bool_op([flat_op1(Cond,NET)|REST],TOP1,BTM1,TOP2,BTM2,TOP3,BTM3,MODE):-
    !,
    bool_op1(NET,Cond,TOP1,MID1,TOP2,MID2,TOP3,MID3,MODE),
    !,
    bool_op(REST,MID1,BTM1,MID2,BTM2,MID3,BTM3,MODE).
bool_op([],B,B,C,C,D,D,_).
/*-------------------------------------------------------*/
bool_op1([],_,B,B,C,C,D,D,_):-          /* net ga nai baai wo haijo */
    !.      /* all_elements, all_acts, flat_cnd_net1 */
bool_op1(NET,Cond,TOP1,BTM1,TOP2,BTM2,TOP3,BTM3,MODE):-
    bool_op_exp(Cond,AND),              /* wa wo fukumu seki no katati ni tenkai */
    if_then(
        eq(MODE,demo),
        and(
            dispf('** bool op "list as and, line means or-list" **\n'),
            list_display(AND),
            nl
        )
    ),
    !,
    bool_op_and_or_exp(AND,AND_OR,[]),  /* kou no seki no wa ni tenkaisuru */
    !,
    sort(AND_OR,S_AND_OR,[]),
    if_then(
        eq(MODE,demo),
        and(
            dispf('** bool op "list as or, line means and-list" **\n'),
            list_display(S_AND_OR),
            nl
        )
    ),
    !,
    sort(NET,S_NET,[]),
    !,
    bool_op2(S_AND_OR,S_NET,TOP1,BTM1,TOP3,BTM3),   /* 1: all_elements, 3:flat_cnd_net1 */
    if_then_else(
        eq(S_AND_OR,[]),
        eq(TOP2,BTM2),
        bool_op4(S_NET,TOP2,BTM2)                   /* 2: all_acts */
    ).
/*-------------------------------------*/
bool_op2([A|B],NET,TOP1,BTM1,[flat_cnd_net1(A,NET)|MID3],BTM3):-
    !,
    bool_op3(A,TOP1,MID1),
    bool_op2(B,NET,MID1,BTM1,MID3,BTM3).
bool_op2([],_,B,B,D,D).
/*-------------------------------------*/
bool_op3([A1|A2],[A1|MID],BTM):-
    !,
    bool_op3(A2,MID,BTM).
bool_op3([],A,A).
/*-------------------------------------*/
bool_op4([A1|A2],[A1|MID],BTM):-
    !,
    eq(A1,net(_,SRC)),
    bool_op5(SRC),
    bool_op4(A2,MID,BTM).
bool_op4([],A,A).
/*-------------------------------------*/
bool_op5(SRC):-
    var(SRC),
    !,
    eq(SRC,pin(const,1,0)).
bool_op5(pin(cat,_,[SRC1,SRC2])):-
    !,
    bool_op5(SRC1),
    bool_op5(SRC2).
bool_op5(_).

/*:::::::::::::::::::::::::::::::::::*/
/*            bool_op_exp            */
/*:::::::::::::::::::::::::::::::::::*/
/*******---------- not ----------*******/
/* ^(^A) = A */
bool_op_exp(pin(not,1,pin(not,1,A)),EXP):-
    !,
    bool_op_exp(A,EXP).
/* ^(A * B) = ^A + ^B */
bool_op_exp(pin(not,1,pin(and,1,[A,B])),EXP):-
    !,
    bool_op_exp(pin(or,1,[pin(not,1,A),pin(not,1,B)]),EXP).
/* ^(A + B) = ^A * ^B */
bool_op_exp(pin(not,1,pin(or,1,[A,B])),EXP):-
    !,
    bool_op_exp(pin(and,1,[pin(not,1,A),pin(not,1,B)]),EXP).
/* ^(A eor B) = (A * B) + (^A * ^B) */
bool_op_exp(pin(not,1,pin(eor,1,[A,B])),EXP):-
    !,
    bool_op_exp(pin(or,1,[pin(and,1,[A,B]),pin(and,1,[pin(not,1,A),pin(not,1,B)])]),EXP).
/* ^1 = 0 */
bool_op_exp(pin(not,1,pin(const,1,1)),[pin(const,1,0)]):-
    !.
/* ^0 = 1 */
bool_op_exp(pin(not,1,pin(const,1,0)),[]):-
    !.
/* ^A = not(A) */
bool_op_exp(pin(not,1,A),[not(A)]):-
    !.
/*******---------- and ----------*******/
/* 0 * A = 0 */
bool_op_exp(pin(and,1,[pin(const,1,0),_]),[pin(const,1,0)]):-
    !.
/* A * 0 = 0 */
bool_op_exp(pin(and,1,[_,pin(const,1,0)]),[pin(const,1,0)]):-
    !.
/**** A * B ****/
bool_op_exp(pin(and,1,[A,B]),EXP):-
    !,
    bool_op_exp(A,EXP1),
    bool_op_exp(B,EXP2),
    append(EXP1,EXP2,EXP).
/*******---------- or ----------*******/
/* 1 + A = 1 */
bool_op_exp(pin(or,1,[pin(const,1,1),_]),[]):-
    !.
/* A + 1 = 1 */
bool_op_exp(pin(or,1,[_,pin(const,1,1)]),[]):-
    !.
/**** A + B ****/
bool_op_exp(pin(or,1,[A,B]),[[EXP1,EXP2]]):-
    !,
    bool_op_exp(A,EXP1),
    bool_op_exp(B,EXP2).
/*******----- eor -----*******/
/* A eor B = (A * ^B) + (^A * B) */
bool_op_exp(pin(eor,1,[A,B]),EXP):-
    !,
    bool_op_exp(pin(or,1,[pin(and,1,[A,pin(not,1,B)]),pin(and,1,[pin(not,1,A),B])]),EXP).
/*******----- const -----*******/
bool_op_exp(pin(const,1,1),[]):-
    !.
/*******----- other -----*******/
bool_op_exp(pin(OTHER,1,A),[pin(OTHER,1,A)]):-
    !.
bool_op_exp(pin(OTHER,_,A),[pin(const,1,0)]):-
    dispf('???ERROR! in expand, you cannot use multi bits facility(%s). ???.',A),nl.

/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*            bool_op_and_or_exp                            */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*  [a,b,c,[ [d11,d12] , [d21,d22] ],e,f,g]                 */
/*  |      |             |                                  */
/*  and    or            and                                */
/*                                                          */
/*   ==> [ [a,b,c,d11,d12,e,f,g] , [a,b,c,d21,d22,e,f,g] ]  */
/*       |                         |                        */
/*       or                        and                      */
/*                                                          */
/*  [] ==> [ [] ]                                           */
/*         |                                                */
/*         or                                               */
/*::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
/*-------------------------------------*/
bool_op_and_or_exp([O|Rest],Result,T):-
    !,
    bool_op_or_and_exp(O,OResult,[]),
    !,
    bool_op_and_or_exp(Rest,RResult,[]),
    !,
    sort(RResult,SRResult,[]),
    !,
    bool_op_mul(OResult,SRResult,Result,T).
bool_op_and_or_exp([],[[]|T],T).
/*-------------------------------------*/
bool_op_or_and_exp([A|Rest],Result,T):-
    !,
    bool_op_and_or_exp(A,Result,Result1),
    !,
    bool_op_or_and_exp(Rest,Result1,T).
bool_op_or_and_exp([],T,T):-
    !.
bool_op_or_and_exp(A,[[A]|T],T).
/*-------------------------------------*/
bool_op_mul([A1|A2],B,M,T):-
    !,
    bool_op_add(A1,B,M,M1),
    !,
    bool_op_mul(A2,B,M1,T).
bool_op_mul([],_,T,T).
/*-------------------------------------*/
bool_op_add(A,[B1|B2],[C|M],T):-
    bool_op_merge(A,B1,C),
    !,
    bool_op_add(A,B2,M,T).
bool_op_add(A,[_|B2],M,T):-
    !,
    bool_op_add(A,B2,M,T).
bool_op_add(_,[],T,T).

/*:::::::::::::::::::::::::::::::::::::*/
/*           bool_op_merge             */
/*:::::::::::::::::::::::::::::::::::::*/
bool_op_merge([A1|A2],[B1|B2],M):-
    !,
    bool_op_merge1(A1,A2,B1,B2,M).
bool_op_merge(A,[],SA):-
    !,
    bool_op_and_sort(A,SA,[]),
    !,
    bool_op_chk(SA).
bool_op_merge([],B,SB):-
    bool_op_and_sort(B,SB,[]),
    !,
    bool_op_chk(SB).
/*-------------------------------------*/
bool_op_merge1(pin(const,1,0),_,_,_,_):-
    !,
    fail.
bool_op_merge1(_,_,pin(const,1,0),_,_):-
    !,
    fail.
bool_op_merge1(C,A2,C,B2,[C|C2]):-
    !,
    bool_op_merge(A2,B2,C2).
bool_op_merge1(C,_,not(C),_,_):-
    !,
    fail.
bool_op_merge1(not(C),_,C,_,_):-
    !,
    fail.
bool_op_merge1(A1,A2,B1,B2,[A1|C2]):-
    bool_op_cmp(A1,B1),
    !,
    bool_op_merge(A2,[B1|B2],C2).
bool_op_merge1(A1,A2,B1,B2,[B1|C2]):-
    bool_op_merge([A1|A2],B2,C2).

/*:::::::::::::::::::::::::::::::::::::*/
/*           bool_op_and_sort          */
/*:::::::::::::::::::::::::::::::::::::*/
/*------ bool_op_and_sort(qsort) ------------------*/
bool_op_and_sort([X1|X2],Y1,Y2):-
    !,
    bool_op_and_part(X1,X2,P1,P2),
    !,
    bool_op_and_sort(P1,Y1,[X1|S]),
    !,
    bool_op_and_sort(P2,S,Y2).
bool_op_and_sort([],Y,Y).
/*------ bool_op_and_part -------------------------*/
bool_op_and_part(X,[X|Z],P1,P2):-
    !,
    bool_op_and_part(X,Z,P1,P2).
bool_op_and_part(X,[Y|Z],P1,[Y|P2]):-
    bool_op_cmp(X,Y),
    !,
    bool_op_and_part(X,Z,P1,P2).
bool_op_and_part(X,[Y|Z],[Y|P1],P2):-
    !,
    bool_op_and_part(X,Z,P1,P2).
bool_op_and_part(_,[],[],[]).
/*------ bool_op_cmp ------------------------------*/
bool_op_cmp(not(X),not(Y)):-
    !,
    cmp(X,Y).
bool_op_cmp(not(X),Y):-
    !,
    cmp(X,Y).
bool_op_cmp(X,not(Y)):-
    !,
    cmp(X,Y).
bool_op_cmp(X,Y):-
    cmp(X,Y).

/*:::::::::::::::::::::::::::::::::*/
/*           bool_op_chk           */
/*:::::::::::::::::::::::::::::::::*/
bool_op_chk([pin(const,1,0)|_]):-
    !,
    fail.
bool_op_chk([not(A),A|_]):-
    !,
    fail.
bool_op_chk([A,not(A)|_]):-
    !,
    fail.
bool_op_chk([_|REST]):-
    !,
    bool_op_chk(REST).
bool_op_chk([]).

    /****************/
    /* intmini sort */
    /****************/

intmini_sort([X1|X2],Y1,Y2):-
    !,
    intmini_not(X1,X3),
    intmini_part(X1,X2,P1,P2),
    intmini_sort(P1,Y1,[X3|S]),
    intmini_sort(P2,S,Y2).
intmini_sort([],Y,Y).
/*-------------------*/
intmini_part(X,[Y|Z],P1,P2):-
    intmini_eq(X,Y),
    !,
    intmini_part(X,Z,P1,P2).
intmini_part(X,[Y|Z],P1,[Y|P2]):-
    intmini_cmp(X,Y),
    !,
    intmini_part(X,Z,P1,P2).
intmini_part(X,[Y|Z],[Y|P1],P2):-
    !,
    intmini_part(X,Z,P1,P2).
intmini_part(_,[],[],[]).
/*-------------------*/
intmini_not(not(X),X):-
    !.
intmini_not(X,X).
/*-------------------*/
intmini_eq(not(X),not(X)):-
    !.
intmini_eq(not(X),X):-
    !.
intmini_eq(X,not(X)):-
    !.
intmini_eq(X,X).
/*-------------------*/
intmini_cmp(not(X),not(Y)):-
    !,
    cmp(X,Y).
intmini_cmp(not(X),Y):-
    !,
    cmp(X,Y).
intmini_cmp(X,not(Y)):-
    !,
    cmp(X,Y).
intmini_cmp(X,Y):-
    cmp(X,Y).

    /*******************/
    /* transfer detect */
    /*******************/

transfer_detect([net(DST,SRC)|REST],[DST|Result],[SRC|Result1]):-
    !,
    transfer_detect(REST,Result,Result1).
transfer_detect([],[],[]).

    /***************/
    /* intmini out */
    /***************/

intmini_out(F_Name,Flat_cnd_net,Sorted_Elements,Sorted_Nets,N1,N2):-
    see(F_Name),
    fdispf('#'),
    while(N1,fdispf(' 2')),
    fdispf(' %d\n',N2),
    intmini_out1(Flat_cnd_net,Sorted_Elements,Sorted_Nets),
    fdispf('@\n@\n@\n'),
    seen.
/*--------------------*/
intmini_out1([flat_cnd_net1(CND,NET)|REST],Es,Ns):-
    !,
    intmini_out_element(Es,CND),
    intmini_out_net(Ns,NET),
    fdispf('\n'),
    intmini_out1(REST,Es,Ns).
intmini_out1([],_,_).
/*--------------------*/
intmini_out_element([E|Es],[E|CND]):-
    !,
    fdispf('01 '),
    intmini_out_element(Es,CND).
intmini_out_element([E|Es],[not(E)|CND]):-
    !,
    fdispf('10 '),
    intmini_out_element(Es,CND).
intmini_out_element([_|Es],CND):-
    !,
    fdispf('11 '),
    intmini_out_element(Es,CND).
intmini_out_element([],_).
/*--------------------*/
intmini_out_net([N|Ns],[N|NET]):-
    !,
    fdispf('1'),
    intmini_out_net(Ns,NET).
intmini_out_net([_|Ns],NET):-
    !,
    fdispf('0'),
    intmini_out_net(Ns,NET).
intmini_out_net([],_).

    /*--------------------*/
    /*    cube_out_ors    */
    /*--------------------*/

cube_out_ors([],_,[]):-!.
cube_out_ors(Added_ors,S_Name,Sorted_Sels):-
    list_count(Added_ors,NUM),
    sub1(NUM,NUM1),
    cube_out_ors_elm(Added_ors,Elms,[]),
    sort(Elms,S_Elms,[]),
    sdispf('%s.cube',S_Name,F_Name),
    see(F_Name),
    fdispf('(cover %s\n',S_Name),
    cube_out1(S_Elms,1,Acts_Cnts,S_Name),
    cube_out2_ors(Added_ors,1),
    cube_out3_ors(Added_ors,S_Elms,0,NUM1),
    fdispf(')\n'),
    seen,
    cube_out_classify(Acts_Cnts,'????',_,Acts_Cnts_classified),
    cube_out_sel(Acts_Cnts_classified,Sorted_Sels).
/*--------------------*/
cube_out_ors_elm([A|REST],T,B):-
    !,
    cube_out_ors_elm1(A,T,M),
    cube_out_ors_elm(REST,M,B).
cube_out_ors_elm([],T,T).
/*--------------------*/
cube_out_ors_elm1([A|REST],[A|M],B):-
    !,
    cube_out_ors_elm1(REST,M,B).
cube_out_ors_elm1([],T,T).
/*--------------------*/
cube_out2_ors([_|REST],IN):-
    !,
    fdispf('\t(output o%d)\n',IN),
    add1(IN,OUT),
    cube_out2_ors(REST,OUT).
cube_out2_ors([],_).
/*--------------------*/
cube_out3_ors([Or|REST],Elms,L,R):-
    !,
    cube_out3_ors1(Or,Elms,L,R),
    add1(L,L1),
    sub1(R,R1),
    cube_out3_ors(REST,Elms,L1,R1).
cube_out3_ors([],_,_,_).
/*--------------------*/
cube_out3_ors1([Elm|REST],Elms,L,R):-
    !,
    fdispf('\t(cube '),
    cube_out3_ors2(Elms,Elm),
    while(L,fdispf('0')),
    fdispf('1'),
    while(R,fdispf('0')),
    fdispf(')\n'),
    cube_out3_ors1(REST,Elms,L,R).
cube_out3_ors1([],_,_,_).
/*--------------------*/
cube_out3_ors2([Elm|REST],Elm):-
    !,
    fdispf('01 '),
    cube_out3_ors2(REST,Elm).
cube_out3_ors2([_|REST],Elm):-
    !,
    fdispf('11 '),
    cube_out3_ors2(REST,Elm).
cube_out3_ors2([],_).

    /*--------------------*/
    /*      cube_out      */
    /*--------------------*/

cube_out(F_Name,S_Name,Flat_cnd_net1,Sorted_Elements,Sorted_Acts,Sorted_Sels):-
    see(F_Name),
    fdispf('(cover %s\n',S_Name),
    cube_out1(Sorted_Elements,1,Acts_Cnts1,S_Name),
    cube_out2(Sorted_Acts,1,Acts_Cnts2,S_Name),
    cube_out3(Flat_cnd_net1,Sorted_Elements,Sorted_Acts),
    fdispf(')\n'),
    seen,
    append(Acts_Cnts1,Acts_Cnts2,Acts_Cnts),
    cube_out_classify(Acts_Cnts,'????',_,Acts_Cnts_classified),
    cube_out_sel(Acts_Cnts_classified,Sorted_Sels).
/*--------------------*/
cube_out1([PIN|REST],
          IN,
          [net(pin(input,1,[CNT,SM_Name]),PIN,pin(const,1,1))|RESULT],
          SM_Name):-
    !,
    cube_out_name(PIN,Name),
    sdispf('i%d-%s',IN,Name,CNT),
    fdispf('\t(input %s)\n',CNT),
    add1(IN,OUT),
    cube_out1(REST,OUT,RESULT,SM_Name).
cube_out1([],_,[],_).
/*--------------------*/
cube_out2([net(DST,SRC)|REST],
          IN,
          [net(DST,SRC,pin(output,1,[CNT,SM_Name]))|RESULT],
          SM_Name):-
    !,
    cube_out_name(DST,D_Name),
    cube_out_name(SRC,S_Name),
    sdispf('o%d-%s-to-%s',IN,S_Name,D_Name,CNT),
    fdispf('\t(output %s)\n',CNT),
    add1(IN,OUT),
    cube_out2(REST,OUT,RESULT,SM_Name).
cube_out2([],_,[],_).
/*--------------------*/
cube_out3([flat_cnd_net1(CND,NET)|REST],Es,Ns):-
    !,
    fdispf('\t(cube '),
    cube_out_element(Es,CND),
    cube_out_net(Ns,NET),
    fdispf(')\n'),
    cube_out3(REST,Es,Ns).
cube_out3([],_,_).
/*--------------------*/
cube_out_element([E|Es],[E|CND]):-
    !,
    fdispf('01 '),
    cube_out_element(Es,CND).
cube_out_element([E|Es],[not(E)|CND]):-
    !,
    fdispf('10 '),
    cube_out_element(Es,CND).
cube_out_element([_|Es],CND):-
    !,
    fdispf('11 '),
    cube_out_element(Es,CND).
cube_out_element([],_).
/*--------------------*/
cube_out_net([N|Ns],[N|NET]):-
    !,
    fdispf('1'),
    cube_out_net(Ns,NET).
cube_out_net([_|Ns],NET):-
    !,
    fdispf('0'),
    cube_out_net(Ns,NET).
cube_out_net([],_).
/*****--------------------------------*****/
cube_out_name(pin(stage,1,[A,B]),ID):-
    !,
    sdispf('%s_%d',A,B,ID).
cube_out_name(pin(segment,1,[A,B,C]),ID):-
    !,
    sdispf('%s_of_%s_%d',A,B,C,ID).
cube_out_name(pin(task,1,[A,B]),ID):-
    !,
    sdispf('%s_of_%s',A,B,ID).
cube_out_name(pin(task,1,ID),ID):-
    !.
cube_out_name(pin(const,1,1),'high'):-
    !.
cube_out_name(pin(const,1,0),'low'):-
    !.
cube_out_name(pin(const,_,_),const):-
    !.
cube_out_name(pin(instrself,1,ID),ID):-
    !.
cube_out_name(pin(bus_org,_,ID),ID):-
    !.
cube_out_name(pin(sel_org,_,ID),ID):-
    !.
cube_out_name(pin(reg,_,ID),ID):-
    !.

cube_out_name(pin(reg_wr,_,ID),ID):- /* 1990.05.29 */
    !.                               /* 1990.05.29 */

cube_out_name(pin(reg_ws,_,ID),ID):- /* 1990.06.18 */
    !.                               /* 1990.06.18 */

cube_out_name(pin(scan_reg,_,ID),ID):-
    !.
cube_out_name(pin(scan_reg_wr,_,ID),ID):-
    !.
cube_out_name(pin(scan_reg_ws,_,ID),ID):-
    !.

cube_out_name(pin(input,_,[A,B]),ID):-
    !,
    sdispf('%s_of_%s',A,B,ID).
cube_out_name(pin(output,_,[A,B]),ID):-
    !,
    sdispf('%s_of_%s',A,B,ID).
cube_out_name(pin(bidirect,_,[A,B]),ID):-
    !,
    sdispf('%s_of_%s',A,B,ID).
cube_out_name(pin(instrin,1,[A,B]),ID):-
    !,
    sdispf('%s_of_%s',A,B,ID).
cube_out_name(pin(instrout,1,[A,B]),ID):-
    !,
    sdispf('%s_of_%s',A,B,ID).
cube_out_name(pin(input,_,ID),ID):-
    !.
cube_out_name(pin(output,_,ID),ID):-
    !.
cube_out_name(pin(bidirect,_,ID),ID):-
    !.
cube_out_name(pin(instrin,1,ID),ID):-
    !.
cube_out_name(pin(instrout,1,ID),ID):-
    !.
cube_out_name(pin(subst,1,[P,P,PIN]),IDD):-
    !,
    cube_out_name(PIN,ID),
    sdispf('%s_%d',ID,P,IDD).
cube_out_name(pin(subst,_,[L,R,PIN]),IDD):-
    !,
    cube_out_name(PIN,ID),
    sdispf('%s_%d_%d',ID,L,R,IDD).
cube_out_name(pin(cat,_,[PIN,_]),IDD):-
    !,
    cube_out_name(PIN,ID),
    sdispf('cat_of_%s_etc',ID,IDD).
cube_out_name(pin(gate,1,_),gate):-
    !.
cube_out_name(PIN,'***ng***'):-
    dispf('***ng***\n'),
    display(PIN),nl,
    atom_value_read(error_flg,X),
    add1(X,Y),
    atom_value_set(error_flg,Y).


/*------------------------------------------*/
cube_out_classify([ELM|REST],N,[ELM|RT1],RT2):-
    eq(ELM,net(N,_,_)),
    !,
    cube_out_classify(REST,N,RT1,RT2).
cube_out_classify([ELM|REST],_,[],[RT1|RT2]):-
    !,
    eq(ELM,net(N,_,_)),
    cube_out_classify([ELM|REST],N,RT1,RT2).
cube_out_classify([],_,[],[]).
/*------------------------------------------*/
cube_out_sel([A|REST],[sel(DST,NUM,SRC)|RESULT]):-
    !,
    list_count(A,NUM),
    eq(A,[net(DST,_,_)|_]),
    cube_out_sel1(A,SRC),
    cube_out_sel(REST,RESULT).
cube_out_sel([],[]).
/*------------------------------------------*/
cube_out_sel1([net(_,SRC,CND)|REST],[src(CND,SRC)|RESULT]):-
    !,
    cube_out_sel1(REST,RESULT).
cube_out_sel1([],[]).

    /************/
    /* get mini */
    /************/

/*::::::::get_mini2:: not ::::::::*/
get_mini2([Elm|REST],I,NOF,[Elm|RESULT],ADRS):-
    get_mini22(NOF,I,ADRS),
    !,
    add1(I,O),
    get_mini2(REST,O,NOF,RESULT,ADRS).
get_mini2([_|REST],I,NOF,RESULT,ADRS):-
    !,
    add1(I,O),
    get_mini2(REST,O,NOF,RESULT,ADRS).
get_mini2([],_,_,[],_).
/*-------------------------------*/
get_mini22(0,_,_):-
    !,
    fail.
get_mini22(_,P,ADRS):-
    get_cube(ADRS,P,0,V1,_),
    eq(V1,1),
    get_cube(ADRS,P,1,V2,_),
    eq(V2,0),
    !.
get_mini22(I,P,ADRS):-
    get_cube(ADRS,0,0,_,NEXT),
    sub1(I,O),
    get_mini22(O,P,NEXT).

/*::::::::get_mini3:: and ::::::::*/
get_mini3(0,_,[],_,_,_):-
    !.
get_mini3(I,ELMS,OUTPUT,ADRS,NOTS,Not_start_id):-
    get_mini33(ELMS,0,AND,ADRS,NOTS,Not_start_id,NUM),   /* 0 is the first value of part id */
    if_then_else(
        bigger(NUM,1),
        eq(OUTPUT,[AND|RESULT]),
        eq(OUTPUT,RESULT)
    ),
    get_cube(ADRS,0,0,_,NEXT),
    sub1(I,O),
    get_mini3(O,ELMS,RESULT,NEXT,NOTS,Not_start_id).
/*-------------------------------*/
/*  get_mini33 makes AND be 0. []
                            1. [elm]
                            2. [elm1,elm2,...] */
get_mini33([Elm|REST],I,[not(ID)|RESULT],ADRS,NOTS,Not_start_id,NUM2):-
    get_cube(ADRS,I,0,V1,_),
    eq(V1,1),
    get_cube(ADRS,I,1,V2,_),
    eq(V2,0),
    !,
    slow_search_out_id(NOTS,Elm,ID,Not_start_id),
    add1(I,O),
    get_mini33(REST,O,RESULT,ADRS,NOTS,Not_start_id,NUM1),
    add1(NUM1,NUM2).
get_mini33([Elm|REST],I,[Elm|RESULT],ADRS,NOTS,Not_start_id,NUM2):-
    get_cube(ADRS,I,0,V1,_),
    eq(V1,0),
    get_cube(ADRS,I,1,V2,_),
    eq(V2,1),
    !,
    add1(I,O),
    get_mini33(REST,O,RESULT,ADRS,NOTS,Not_start_id,NUM1),
    add1(NUM1,NUM2).
get_mini33([_|REST],I,RESULT,ADRS,NOTS,Not_start_id,NUM):-
    !,
    add1(I,O),
    get_mini33(REST,O,RESULT,ADRS,NOTS,Not_start_id,NUM).
get_mini33([],_,[],_,_,_,0).

/*::::::::get_mini4:: or ::::::::*/
get_mini4([_|REST],
          I,
          NOF,
          OUTPUT,
          ADRS,
          Part,
          ELMS,
          NOTS,Not_start_id,
          ANDS,And_start_id):-
    !,
    get_mini44(NOF,OR,ADRS,Part,I,ELMS,NOTS,Not_start_id,ANDS,And_start_id,NUM),
    if_then_else(
        bigger(NUM,1),
        eq(OUTPUT,[OR|RESULT]),
        eq(OUTPUT,RESULT)
    ),
    add1(I,O),
    get_mini4(REST,O,NOF,RESULT,ADRS,Part,ELMS,NOTS,Not_start_id,ANDS,And_start_id).
get_mini4([],_,_,[],_,_,_,_,_,_,_).
/*-------------------------------*/
/*  get_mini44 makes OR be 0. []
                           1. [elm]
                           2. [elm1,elm2,...] */
get_mini44(0,[],_,_,_,_,_,_,_,_,0):-
    !.
get_mini44(I,[OUTPUT|RESULT],ADRS,Part,Post,ELMS,NOTS,Not_start_id,ANDS,And_start_id,NUMM2):-
    get_cube(ADRS,Part,Post,V,_),
    eq(V,1),
    !,
    get_mini33(ELMS,0,AND,ADRS,NOTS,Not_start_id,NUM),
    if_then_else(
        bigger(NUM,1),
        and(
            slow_search_out_id(ANDS,AND,ID,And_start_id),
            eq(OUTPUT,and(ID))
        ),
        if_then_else(
            eq(NUM,1),
            and(
                eq(AND,[AND1]),
                eq(OUTPUT,AND1)
            ),
            eq(OUTPUT,pin(const,1,1))
        )
    ),
    get_cube(ADRS,0,0,_,NEXT),
    sub1(I,O),
    get_mini44(O,RESULT,NEXT,Part,Post,ELMS,NOTS,Not_start_id,ANDS,And_start_id,NUMM1),
    add1(NUMM1,NUMM2).
get_mini44(I,RESULT,ADRS,Part,Post,ELMS,NOTS,Not_start_id,ANDS,And_start_id,NUMM):-
    get_cube(ADRS,0,0,_,NEXT),
    sub1(I,O),
    get_mini44(O,RESULT,NEXT,Part,Post,ELMS,NOTS,Not_start_id,ANDS,And_start_id,NUMM).

/*::::::::get_mini5:: sel ::::::::*/
get_mini5([DST|REST],
            ACTS,
            NOF,
            OUTPUT,
            ADRS,
            Part,
            ELMS,
            NOTS,Not_start_id,
            ANDS,And_start_id,
            ORS,Or_start_id):-
    !,
    get_mini55(ACTS,0,NOF,SRC,DST,ADRS,Part,ELMS,NOTS,Not_start_id,ANDS,And_start_id,ORS,Or_start_id,NUM),
    eq(OUTPUT,[sel(DST,NUM,SRC)|RESULT]),
    get_mini5(REST,ACTS,NOF,RESULT,ADRS,Part,ELMS,NOTS,Not_start_id,ANDS,And_start_id,ORS,Or_start_id).
get_mini5([],_,_,[],_,_,_,_,_,_,_,_,_).
/*-------------------------------*/
get_mini55([net(DST,SRC)|REST],
             I,
             NOF,
             [OUTPUT|RESULT],
             DST,
             ADRS,
             Part,
             ELMS,
             NOTS,Not_start_id,ANDS,And_start_id,ORS,Or_start_id,NUMM2):-
    !,
    get_mini44(NOF,OR,ADRS,Part,I,ELMS,NOTS,Not_start_id,ANDS,And_start_id,NUM),
    if_then_else(
        bigger(NUM,1),
        and(
            slow_search_out_id(ORS,OR,ID,Or_start_id),
            eq(OUTPUT,src(or(ID),SRC))
        ),
        if_then_else(
            eq(NUM,1),
            and(
                eq(OR,[OR1]),
                eq(OUTPUT,src(OR1,SRC))
            ),
            eq(OUTPUT,src(none,SRC))
        )
    ),
    add1(I,O),
    get_mini55(REST,O,NOF,RESULT,DST,ADRS,Part,ELMS,NOTS,Not_start_id,ANDS,And_start_id,ORS,Or_start_id,NUMM1),
    add1(NUMM1,NUMM2).
get_mini55([_|REST],
             I,
             NOF,
             RESULT,
             DST,
             ADRS,
             Part,
             ELMS,
             NOTS,Not_start_id,ANDS,And_start_id,ORS,Or_start_id,NUMM):-
    !,
    add1(I,O),
    get_mini55(REST,O,NOF,RESULT,DST,ADRS,Part,ELMS,NOTS,Not_start_id,ANDS,And_start_id,ORS,Or_start_id,NUMM).
get_mini55([],_,_,[],_,_,_,_,_,_,_,_,_,_,0).

    /***********/
    /* display */
    /***********/

flat_cnd_net1_display([flat_cnd_net1(CNDS,NETS)|REST]):-
    dispf('\t++++++++++++\n'),
    list_display(CNDS),
    nets_display(NETS),
    !,
    flat_cnd_net1_display(REST).
flat_cnd_net1_display([]).
/*------------------------------------------*/
nets_display([net(DST,SRC)|REST]):-
    !,
    dispf('\tfrom: '),display(SRC),nl,
    dispf('\tto  : '),display(DST),nl,
    nets_display(REST).
nets_display([]).
/*------------------------------------------*/
nots_display([NOT|REST],I):-
    !,
    dispf('not%d:\n',I),
    tab,display(NOT),nl,
    add1(I,O),
    nots_display(REST,O).
nots_display([],_).
/*------------------------------------------*/
ands_display([AND|REST],I):-
    !,
    dispf('and%d:\n',I),
    list_display(AND),
    add1(I,O),
    ands_display(REST,O).
ands_display([],_).

/** 1990.05.11 **/
/*------------------------------------------*/
nands_display([AND|REST],I):-
    !,
    dispf('nand%d:\n',I),
    list_display(AND),
    add1(I,O),
    nands_display(REST,O).
nands_display([],_).

/*------------------------------------------*/
ors_display([OR|REST],I):-
    !,
    dispf('or%d:\n',I),
    list_display(OR),
    add1(I,O),
    ors_display(REST,O).
ors_display([],_).

/** 1990.05.11 **/
/*------------------------------------------*/
nors_display([OR|REST],I):-
    !,
    dispf('nor%d:\n',I),
    list_display(OR),
    add1(I,O),
    nors_display(REST,O).
nors_display([],_).

/*------------------------------------------*/
sels_display([sel(DST,NUM,SRC)|REST],I):-
    !,
    dispf('sel%d: ',I),display(DST),nl,
    list_display(SRC),
    add1(I,O),
    sels_display(REST,O).
sels_display([],_).
/*------------------------------------------*/
sel1s_display([sel1(DST,NUM,SRC)|REST],I):-
    !,
    dispf('sel1%d: ',I),display(DST),nl,
    sel1s_display1(SRC),
    add1(I,O),
    sel1s_display(REST,O).
sel1s_display([],_).
/*----------*/
sel1s_display1([src1(CND,SRC)|REST]):-
    !,
    dispf('\tsrc: '),display(SRC),nl,
    if_then_else(
        eq(CND,[_|_]),
        list_display(CND),
        and(
            tab,
            display(CND)
        )
    ),
    sel1s_display1(REST).
sel1s_display1([]).

    /*************/     /* sel(DST,NUM,src)   */
    /* sel merge */     /*       V            */
    /*************/     /* sel1(DST,NUM,src1) */
                        /*       V            */
                        /* sel(DST,NUM,src)   */
sel_merge(Mod_Name,Cube_submod,
        Sorted_sels,                /* [sel(),...] */
        Merged_Added_Cube_sels,     /* [sel(),...] */
        Or_start_id,
        Added_ors_last):-
    !,
    sel_dst_classify(
        Sorted_sels,
        DST_classed_sels),          /* [[sel(DST,_,src),...],...] */
    !,
    make_merged_sel1s(
        DST_classed_sels,
        Merged_sel1s,
        ORS_SEL,                    /* [[CND,...],...] */
        []),
    !,
    sort(ORS_SEL,Ors_sel,[]),
    !,
    atom_value_read(to_other_tool,OTHER),
    !,
    sdispf('%s--merge',Mod_Name,SM_Name),
    !,
    merge_sel1s(
        Merged_sel1s,
        Ors_sel,
        Or_start_id,
        Merged_sels,OTHER,SM_Name),
    !,
    list_count(Ors_sel,N),
    !,
    plus(Or_start_id,N,Or_next_id),
    !,
    clk_etc_sel_detect(
        Merged_sels,
        Added_sel1s,
        ORS_CLK,
        []),
    !,
    sort(ORS_CLK,Ors_clk,[]),
    !,
    merge_sel1s(
        Added_sel1s,
        Ors_clk,
        Or_next_id,
        Added_sels,OTHER,SM_Name),
    !,
    append(Ors_sel,Ors_clk,Added_ors),
    !,
    append(Merged_sels,Added_sels,Merged_Added_sels),
    !,
    if_then_else(
        eq(Added_ors,[]),
        eq(Cube_submod,[]),
        eq(Cube_submod,['-merge'])
    ),
    !,
    if_then_else(
        eq(OTHER,no),
        and(
            eq(Added_ors_last,Added_ors),
            eq(Cube_sels,[])
        ),
        and(
            eq(Added_ors_last,[]),
            cube_out_ors(Added_ors,SM_Name,Cube_sels)
        )
    ),
    !,
    append(Merged_Added_sels,Cube_sels,Merged_Added_Cube_sels).


/**---------------------------------**/
sel_dst_classify([X1|X2],[[X1|P1]|R]):-
    !,
    sel_dst_apart(X1,X2,P1,P2),
    sel_dst_classify(P2,R).
sel_dst_classify([],[]).
/*-------------------*/
sel_dst_apart(X,[Y|Z],[Y|P1],P2):-
    sel_dst_eq(X,Y),
    !,
    sel_dst_apart(X,Z,P1,P2).
sel_dst_apart(X,[Y|Z],P1,[Y|P2]):-
    !,
    sel_dst_apart(X,Z,P1,P2).
sel_dst_apart(_,[],[],[]).
/*-------------------*/
sel_dst_eq(sel(DST,_,_),sel(DST,_,_)).

/*-------------------*/
make_merged_sel1s(
        [DST_classed_sels|REST],    /* [sel(DST,_,src),...] */
        [sel1(DST,NUM,Src1)|RESULT],
        TOP,
        BTM):-
    !,
    sel_detect_src(
        DST_classed_sels,
        Srcs,                       /* [src(CND,SRC),...] */
        DST),
    sel_src_classify(
        Srcs,
        SRC_classed_srcs),          /* [[src(CND,SRC),...],...] */
    sel_compose_src1(
        SRC_classed_srcs,
        Src1,                       /* [src1(CND,SRC),...] or [src1([CND,...],SRC),...] */
        TOP,
        MID),
    list_count(Src1,NUM),
    make_merged_sel1s(REST,RESULT,MID,BTM).
make_merged_sel1s([],[],A,A).

/**---------------------------------**/
sel_detect_src([sel(DST,_,SRC)|REST],SRC3,DST):-
    !,
    append(SRC,SRC2,SRC3),
    sel_detect_src(REST,SRC2,_).
sel_detect_src([],[],_).

/**---------------------------------**/
sel_src_classify([X1|X2],[[X1|P1]|R]):-
    !,
    sel_src_apart(X1,X2,P1,P2),
    sel_src_classify(P2,R).
sel_src_classify([],[]).
/*-------------------*/
sel_src_apart(X,[Y|Z],[Y|P1],P2):-
    sel_src_eq(X,Y),
    !,
    sel_src_apart(X,Z,P1,P2).
sel_src_apart(X,[Y|Z],P1,[Y|P2]):-
    !,
    sel_src_apart(X,Z,P1,P2).
sel_src_apart(_,[],[],[]).
/*-------------------*/
sel_src_eq(src(_,SRC),src(_,SRC)).

/*-------------------*/
sel_compose_src1(
        [SRC_classed_srcs|REST],    /* [src(CND,SRC),...] */
        [src1(RCNDS,SRC)|RESULT],
        TOP,
        BTM):-
    !,
    sel_detect_cnd(
        SRC_classed_srcs,
        CNDS,                       /* [CND,...] */
        SRC),
    sort(CNDS,S_CNDS,[]),
    list_count(S_CNDS,N),
    if_then_else(
        eq(N,1),
        and(
            eq(S_CNDS,[RCNDS]),
            eq(TOP,MID)
        ),
        and(
            eq(S_CNDS,RCNDS),
            eq(TOP,[S_CNDS|MID])
        )
    ),
    sel_compose_src1(REST,RESULT,MID,BTM).
sel_compose_src1([],[],A,A).

/**---------------------------------**/
sel_detect_cnd([src(CND,SRC)|REST],[CND|RESULT],SRC):-
    !,
    sel_detect_cnd(REST,RESULT,_).
sel_detect_cnd([],[],_).

/**---------------------------------**/
merge_sel1s(
        [sel1(DST,NUM,SRC1)|REST],
        Ors,
        Start_id,
        [sel(DST,NUM,SRC)|RESULT],OTHER,SM_Name):-
    !,
    merge_sel1s2(SRC1,Ors,Start_id,SRC,OTHER,SM_Name),
    merge_sel1s(REST,Ors,Start_id,RESULT,OTHER,SM_Name).
merge_sel1s([],_,_,[],_,_).
/**---------------------------------**/
merge_sel1s2(
        [src1(CNDS,SRC)|REST],
        Ors,
        Start_id,
        [src(RCND,SRC)|RESULT],OTHER,SM_Name):-
    !,
    if_then_else(
        eq(CNDS,[_|_]),
        and(
            slow_search_out_id(Ors,CNDS,ID,Start_id),
            if_then_else(
                eq(OTHER,no),
                eq(RCND,or(ID)),
                and(
                    sdispf('o%d',ID,CNT),
                    eq(RCND,pin(output,1,[CNT,SM_Name]))
                )
            )
        ),
        eq(RCND,CNDS)
    ),
    merge_sel1s2(REST,Ors,Start_id,RESULT,OTHER,SM_Name).
merge_sel1s2([],_,_,[],_,_).

/**---------------------------------**/
clk_etc_sel_detect(
    [sel(pin(Type,_,ID),_,SRC)|REST],
    [sel1(pin(N_type,1,ID),1,[src1(CND,pin(const,1,1))])|RESULT],
    TOP,
    BTM):-
    clk_etc(Type,N_type),
    !,
    sel_detect_cnd(SRC,CNDS,_),
    sort(CNDS,S_CNDS,[]),
    list_count(S_CNDS,N),
    if_then_else(
        eq(N,1),
        and(
            eq(S_CNDS,[CND]),
            eq(TOP,MID)
        ),
        and(
            eq(S_CNDS,CND),
            eq(TOP,[S_CNDS|MID])
        )
    ),
    clk_etc_sel_detect(REST,RESULT,MID,BTM).
clk_etc_sel_detect([_|REST],RESULT,TOP,BTM):-
    !,
    clk_etc_sel_detect(REST,RESULT,TOP,BTM).
clk_etc_sel_detect([],[],T,T).
/*-------------------*/
clk_etc(stage,stage_clk).
clk_etc(segment,segment_clk).
/* clk_etc(task,task_clk). */   /* add 1988.10.20 */
clk_etc(reg,reg_clk).

clk_etc(reg_wr,reg_clk). /* 1990.05.29 */

clk_etc(reg_ws,reg_clk). /* 1990.06.18 */

clk_etc(scan_reg,reg_clk).
clk_etc(scan_reg_wr,reg_clk).
clk_etc(scan_reg_ws,reg_clk).

clk_etc(bidirect,bidirect_enb).

    /***************/
    /* multi level */
    /***************/

multi(Nots,Ands,Ors,Sels,Nots,Ands,Ors,Sels,_):-
    atom_value_read(multi_level_opt,Multi_level_opt),
    eq(Multi_level_opt,no),
    !.
multi(Nots,   Ands,   Ors,   Sels,
   XX_Nots,XX_Ands,XX_Ors,XX_Sels,MODE):-
    dispf('\n#### into multi-level logic optimization ####\n'),
    !,
    atom_value_read(post_opt,Post_opt),
    if_then_else(
        eq(Post_opt,no),
        eq(Dont_care_opt,no),
        atom_value_read(dont_care_opt,Dont_care_opt)
    ),
    /*-- used gate --*/
    multi_used_gate(Sels,XX_Sels,Gates,[],Dont_care_opt),
    !,          /* Gates: [match(Gate,Dont_care,New_Gate,DST,DATA,CNT),...] */
    dispf('** used gate extract done **\n'),
    sort(Gates,S_Gates,[]),
    !,
    dispf('** used gate sort done **\n'),

    /** 1990.05.10 **/
    if_then(
        eq(MODE,demo),
        and(
            dispf('** used gates(match(Gate,Dont_care,New_Gate,DST,SRC,TYPE)) are as follow **\n'),
            list_display(S_Gates)
        )
    ),

    multi_pre_match(S_Gates,Result,Dont_care,COMMENT),
    !,
    /*-- used pin --*/
    multi_used_pin1(Nots,Pin1,Pin2),
    !,
    multi_used_pin( Ands,Pin2,Pin3),
    !,
    multi_used_pin( Ors, Pin3,Pin4),
    !,
    multi_used_pin( Dont_care,Pin4,[]),
    !,
    sort(Pin1,Pinss,[]),
    !,
    eq(Pins,[pin(const,1,1)|Pinss]),
    list_count(Pins,Nof_pins),
    !,
    dispf('** used pin extract and sort done **\n'),
    /*-- interface to c-program --*/
    list_count(Nots,Nof_nots),
    list_count(Ands,Nof_ands),
    list_count(Ors, Nof_ors),
    fin_count(Ands,A_fin),
    fin_count(Ors,O_fin),
    dispf('** nof_nots = %d, nof_ands = %d, nof_ors = %d **\n',Nof_nots,Nof_ands,Nof_ors),
    dispf('** nots_fin = %d, ands_fin = %d, ors_fin = %d **\n',Nof_nots,A_fin,O_fin),
    dispf('** input pins: pin(type,width,name) **\n'),
    list_display_n(Pins,1),

    /** 1990.05.10 **/
    dispf('** nots: not(fin) **\n'),
    multi_disp_nots(Nots,1,Pins),
    !,
    dispf('** ands: and(fin,...) **\n'),
    multi_disp_ands(Ands,1,Pins),
    !,
    dispf('** ors: or(fin,...) **\n'),
    multi_disp_ors(Ors,1,Pins),
    !,

    dispf('** actions: action(destination,source,type,target) **\n'), /* 1990.06.22 */
    list_display_n(COMMENT,1),
    dispf('** into interface to c-program **\n'),
    if_then_else(
        eq(MODE,demo),
        multi_level(100,1,1),
        multi_level(100,1,0)
    ),
    !,
    multi_level(1,0,Nof_pins),          /* 1-0-Nof_pin */
    !,
    multi_make_gate(Nots,1,1),          /* Type not: 1 */
    !,
    multi_make_gate(Ands,2,1),          /*      and: 2 */
    !,
    multi_make_gate(Ors,3,1),           /*       or: 3 */
    !,
    multi_make_gate([Result],4,1),      /*   result: 4 */
    !,
    multi_make_gate(Dont_care,5,1),     /*   dont_care: 5 */
    !,
    dispf('** make comp done **\n'),
    multi_make_fin(Nots,1,Pins,1),      /* Type not: 1 */
    !,
    dispf('** nots link done **\n'),
    multi_make_fin(Ands,2,Pins,1),      /*      and: 2 */
    !,
    dispf('** ands link done **\n'),
    multi_make_fin(Ors, 3,Pins,1),      /*       or: 3 */
    !,
    dispf('** ors link done **\n'),
    multi_make_fin([Result],4,Pins,1),  /*   result: 4 */
    !,
    dispf('** sels link done **\n'),
    multi_make_fin(Dont_care,5,Pins,1), /*   dont_care: 5 */
    !,
    dispf('** dont_cares link done **\n'),
    if_then_else(
        eq(Post_opt,no),
        multi_level(4,0,2),             /* 4-0-2 no */
        if_then_else(
            eq(Post_opt,single),
            multi_level(4,0,1),         /* 4-0-1 single */
            multi_level(4,0,0)          /* 4-0-0 multi  */
        )
    ),
    !,
    multi_level(5,1,_),                 /* set NOT root */
    !,
    multi_extract_comp(X_Nots,1,Pins),
    !,
    dispf('** nots extract done **\n'),
    multi_level(5,2,_),                 /* set AND root */
    !,
    multi_extract_comp(X_Ands,2,Pins),
    !,
    dispf('** ands extract done **\n'),
    multi_level(5,3,_),                 /* set OR root */
    !,
    multi_extract_comp(X_Ors,3,Pins),
    !,
    dispf('** ors extract done **\n'),
    multi_level(5,4,_),                 /* set RESULT root */
    !,
    multi_extract_comp([X_Result],4,Pins),
    !,
    dispf('** sels extract done **\n'),
    atom_value_read(change_to_nand_nor,Max_Fin),
    !,
    if_then_else(
        bigger(Max_Fin,1),
        polaris(Max_Fin,
                X_Result,Pins,X_Nots, X_Ands, X_Ors,
               XX_Result,    XX_Nots,XX_Ands,XX_Ors),
        and(
            eq(X_Result,XX_Result),
            eq(X_Nots,  XX_Nots),
            eq(X_Ands,  XX_Ands),
            eq(X_Ors,   XX_Ors)
        )
    ),
    !,
    multi_post_match(XX_Result,S_Gates).
/*------------------------------------------*/
fin_count([And|Rest],N3):-
    !,
    list_count(And,N1),
    fin_count(Rest,N2),
    plus(N1,N2,N3).
fin_count([],0).
/*------------------------------------------*/
/*      used pin                            */
/*------------------------------------------*/
multi_used_pin([LIST|REST],A,C):-
    !,
    multi_used_pin1(LIST,A,B),
    !,
    multi_used_pin(REST,B,C).
multi_used_pin([],C,C):-!.
/*------------------------------------------*/
multi_used_pin1([PIN|REST],[PIN|B],C):-
    eq(PIN,pin(_,_,_)),
    !,
    multi_used_pin1(REST,B,C).
multi_used_pin1([_|REST],B,C):-
    !,
    multi_used_pin1(REST,B,C).
multi_used_pin1([],C,C):-!.
/*------------------------------------------*/
/*      used gate                           */
/*------------------------------------------*/
multi_used_gate([sel(DST,1,SRC)|REST],
                [sel(DST,1,X_SRC)|RESULT],
                A,C,Dont_care_opt):-
    !,
    multi_used_gate1(SRC,X_SRC,[],A,B,DST),
    !,
    multi_used_gate(REST,RESULT,B,C,Dont_care_opt).
multi_used_gate([sel(DST,NUM,SRC)|REST],
                [sel(DST,NUM,X_SRC)|RESULT],
                A,C,Dont_care_opt):-
    eq(DST,pin(bus_org,_,_)),
    !,
    multi_used_gate1(SRC,X_SRC,[],A,B,DST),
    !,
    multi_used_gate(REST,RESULT,B,C,Dont_care_opt).
multi_used_gate([sel(DST,NUM,SRC)|REST],
                [sel(DST,NUM,X_SRC)|RESULT],
                A,C,Dont_care_opt):-
    eq(DST,pin(task,_,_)),
    !,
    multi_used_gate1(SRC,X_SRC,[],A,B,DST),
    !,
    multi_used_gate(REST,RESULT,B,C,Dont_care_opt).
multi_used_gate([sel(DST,NUM,SRC)|REST],
                [sel(DST,NUM,X_SRC)|RESULT],
                A,C,yes):-
    !,
    multi_used_gate1(SRC,X_SRC,SRC,A,B,DST),
    !,
    multi_used_gate(REST,RESULT,B,C,yes).
multi_used_gate([sel(DST,NUM,SRC)|REST],
                [sel(DST,NUM,X_SRC)|RESULT],
                A,C,no):-
    !,
    multi_used_gate1(SRC,X_SRC,[],A,B,DST),
    !,
    multi_used_gate(REST,RESULT,B,C,no).
multi_used_gate([],[],C,C,_):-!.
/*------------------------------------------*/
multi_used_gate1([src(CND,DATA)|REST],
                 [src(X_CND,X_DATA)|RESULT],
                 SRC,A,D,DST):-
    !,
    multi_used_gate2(CND,X_CND,SRC,A,B,DST,DATA,cnt),
    !,
    multi_used_gate2(DATA,X_DATA,[],B,C,DST,DATA,data),
    !,
    multi_used_gate1(REST,RESULT,SRC,C,D,DST).
multi_used_gate1([],[],_,D,D,_):-!.
/*------------------------------------------*/
multi_used_gate2(pin(cat,W,[PIN1,PIN2]),
                 pin(cat,W,[X_PIN1,X_PIN2]),
                 /** 1990.05.10 **/
                 SRC,A,C,DST,_,CNT):-
    !,
    eq(SRC,[]),
    !,
    /** 1990.05.10 **/
    multi_used_gate2(PIN1,X_PIN1,[],A,B,DST,PIN1,CNT),
    !,
    /** 1990.05.10 **/
    multi_used_gate2(PIN2,X_PIN2,[],B,C,DST,PIN2,CNT).
multi_used_gate2(PIN,
                 PIN,
                 _,A,A,_,_,_):-
    eq(PIN,pin(_,_,_)),
    !.
multi_used_gate2(Gate,
                 New_Gate,
                 SRC,[match(Gate,Dont_care,New_Gate,DST,DATA,CNT)|A],A,DST,DATA,CNT):-
    !,
    multi_dont_care(SRC,Dont_care).
/*------------------------------------------*/
/*      don't care                          */
/*------------------------------------------*/
multi_dont_care([src(CND,_)|REST],[CND|RESULT]):-
    !,
    multi_dont_care(REST,RESULT).
multi_dont_care([],[]).
/*------------------------------------------*/
/*      make gate                           */
/*------------------------------------------*/
multi_make_gate([_|REST],Type,N):-
    !,
    multi_level(1,Type,N),      /* 1-Type-ID */
    !,
    add1(N,M),
    !,
    multi_make_gate(REST,Type,M).
multi_make_gate([],_,_):-!.
/*------------------------------------------*/
/*      make fin                            */
/*------------------------------------------*/
multi_make_fin([Gate|REST],Type,Pin,N):-
    !,
    multi_level(2,Type,N),      /* 2-Type-ID */
    !,
    if_then_else(
        eq(Type,1), /* 1 means not */
        multi_make_fin2(Gate,Pin),
        multi_make_fin1(Gate,Pin)
    ),
    !,
    add1(N,M),
    !,
    multi_make_fin(REST,Type,Pin,M).
multi_make_fin([],_,_,_):-!.
/*---------------------------------------------*/
multi_make_fin1([FIN|REST],PIN):-
    !,
    multi_make_fin1(REST,PIN),  /* reverse these two lines on 1989.6.30 */
    !,
    multi_make_fin2(FIN,PIN).
multi_make_fin1([],_):-!.
/*------------------------------fan in---------*/
multi_make_fin2(not(ID),_):-
    !,
    multi_level(3,1,ID).        /* not: 3-1-ID */
multi_make_fin2(and(ID),_):-
    !,
    multi_level(3,2,ID).        /* and: 3-2-ID */
multi_make_fin2(or(ID),_):-
    !,
    multi_level(3,3,ID).        /* or:  3-3-ID */
multi_make_fin2(FIN,Pin):-
    !,
    slow_search_out_id(Pin,FIN,ID),
    !,
    multi_level(3,0,ID).        /* pin: 3-0-ID */

/** 1990.05.10 **/
/*------------------------------------------*/
/*      disp nots, ands, ors                */
/*------------------------------------------*/
multi_disp_nots([Gate|REST],N,Pin):-
    !,
    dispf('\t%d\tnot(',N),
    multi_disp_gate_fin2(Gate,Pin),
    !,
    dispf(')\n'),
    add1(N,M),
    multi_disp_nots(REST,M,Pin).
multi_disp_nots([],_,_):-!.
/*---------------------------------------------*/
multi_disp_ands([Gate|REST],N,Pin):-
    !,
    dispf('\t%d\tand(',N),
    multi_disp_gate_fin1(Gate,Pin),
    !,
    dispf(')\n'),
    add1(N,M),
    multi_disp_ands(REST,M,Pin).
multi_disp_ands([],_,_):-!.
/*---------------------------------------------*/
multi_disp_ors([Gate|REST],N,Pin):-
    !,
    dispf('\t%d\tor(',N),
    multi_disp_gate_fin1(Gate,Pin),
    !,
    dispf(')\n'),
    add1(N,M),
    multi_disp_ors(REST,M,Pin).
multi_disp_ors([],_,_):-!.
/*---------------------------------------------*/
multi_disp_gate_fin1([FIN],PIN):-
    !,
    multi_disp_gate_fin2(FIN,PIN).
multi_disp_gate_fin1([FIN|REST],PIN):-
    !,
    multi_disp_gate_fin1(REST,PIN),
    !,
    dispf(','),
    multi_disp_gate_fin2(FIN,PIN).
/*------------------------------fan in---------*/
multi_disp_gate_fin2(not(ID),_):-
    !,
    dispf('not(%d)',ID).
multi_disp_gate_fin2(and(ID),_):-
    !,
    dispf('and(%d)',ID).
multi_disp_gate_fin2(or(ID),_):-
    !,
    dispf('or(%d)',ID).
multi_disp_gate_fin2(FIN,Pin):-
    !,
    slow_search_out_id(Pin,FIN,ID),
    !,
    dispf('pin(%d)',ID).

/*------------------------------------------*/
/*      extract                             */
/*------------------------------------------*/
multi_extract_comp(Comps,Type,Pin):-
    !,
    multi_level(5,10,Id),  /* null check and set FIN root*/
    !,
    if_then_else(
        eq(Id,0),
        eq(Comps,[]),
        and(
            eq(Comps,[Comp|REST]),
            multi_extract_fin(Type,Comp,Pin),
            multi_level(5,20,_),    /* next comp */
            multi_extract_comp(REST,Type,Pin)
        )
    ).
/*------------------------------------------*/
multi_extract_fin(1,Fin,Pin):-
    !,
    multi_level(6,Type,Id), /* search next fin */
    !,
    multi_extract_compose(Type,Id,Pin,Fin).
multi_extract_fin(C_Type,Fins,Pin):-
    !,
    multi_level(6,Type,Id), /* search next fin */
    !,
    if_then_else(
        eq(Id,0),
        eq(Fins,[]),
        and(
            eq(Fins,[Fin|REST]),
            multi_extract_compose(Type,Id,Pin,Fin),
            multi_extract_fin(C_Type,REST,Pin)
        )
    ).
/*------------------------------------------*/
multi_extract_compose(0,Id,Pin,Fin):-
    !,
    index_search(Pin,Id,Fin).
multi_extract_compose(1,Id,_,not(Id)):-
    !.
multi_extract_compose(2,Id,_,and(Id)):-
    !.
multi_extract_compose(3,Id,_,or(Id)):-!.
/*------------------------------------------*/
/*      pre match                           */
/*------------------------------------------*/
multi_pre_match([match(Gate,Dont_care,_,DST,DATA,CNT)|REST],
                [Gate|RESULT],
                [Dont_care|Result],
                [action(DST,DATA,CNT,Gate)|REsult]):- /* 1990.06.22 */
    !,
    multi_pre_match(REST,RESULT,Result,REsult).
multi_pre_match([],[],[],[]):-!.
/*------------------------------------------*/
/*      post match                          */
/*------------------------------------------*/
multi_post_match([New_Gate|REST],[match(_,_,New_Gate,_,_,_)|RESULT]):-
    !,
    multi_post_match(REST,RESULT).
multi_post_match([],[]):-!.

    /***********/
    /* polaris */
    /***********/   /* comp(CHK,O_Type,O_ID,O_STR,N_Type,O_Fin,N_Fin,Inv) */

polaris(Max_Fin,Result,Pins,Nots,  Ands,  Ors,
              X_Result,   X_Nots,X_Ands,X_Ors):-
    dispf('\n#### start and-or to nand-nor exchange and limit fin ####\n'),
    !,

    polaris_exchange([Result],result,1,OWN, Own1),
    !,
    polaris_exchange(Pins,    pin,   1,Own1,Own2),
    !,
    polaris_exchange(Nots,    inv,   1,Own2,Own3),
    !,
    polaris_exchange(Ands,    and,   1,Own3,Own4),
    !,
    polaris_exchange(Ors,     or,    1,Own4,[]),
    !,
    dispf('** make comp done **\n'),
    polaris_link([Result],result,OWN, OWN),
    !,
    dispf('** sels link done **\n'),
    polaris_link(Pins,    pin,   Own1,OWN),
    !,
    dispf('** pins link done **\n'),
    polaris_link(Nots,    inv,   Own2,OWN),
    !,
    dispf('** nots link done **\n'),
    polaris_link(Ands,    and,   Own3,OWN),
    !,
    dispf('** ands link done **\n'),
    polaris_link(Ors,     or,    Own4,OWN),
    !,
    dispf('** ors link done **\n'),

    eq(OWN,[Top|_]),
    !,
    eq(Top,comp(_,_,_,_,result,O_Fin,O_Fin,[])),
    !,
    polaris_fin_trace(O_Fin,Max_Fin),
    !,
    polaris_validity_chk([Top],_,OWN1,[]),
    !,
    dispf('** fin limit done **\n'),

    eq(OWN1,[Top1|_]),
    !,
    eq(Top1,comp(_,_,_,_,result,O_Fin1,N_Fin1,[])),
    !,
    polaris(O_Fin1,N_Fin1),
    !,
    polaris_validity_chk([Top1],_,OWN2,[]),
    !,
    dispf('** and-or to nand-nor done **\n'),

    eq(OWN2,[Top2|Others2]),
    !,
    eq(Top2,comp(_,_,_,_,_,O_Fin2,_,_)),
    !,
    polaris_set_new_id(Others2,1,1,1),
    !,
    polaris_last1(O_Fin2,X_Result),
    !,
    polaris_last(Others2,X_Nots,X_Ands,X_Ors).

/*------------------*/
/*      link        */
/*------------------*/
polaris_exchange([STR|REST],Type,In,[comp(CHK,Type,In,STR,N_Type,O_Fin,N_Fin,Inv)|M],B):-
    !,
    add1(In,Out),
    !,
    polaris_exchange(REST,Type,Out,M,B).
polaris_exchange([],_,_,T,T):-!.
/*------------------*/
polaris_link([COMP|REST],Type,[comp(_,_,_,_,_,Fin,_,_)|Rest],Comps):-
    !,
    polaris_link1(Type,COMP,Fin,Comps),
    !,
    polaris_link(REST,Type,Rest,Comps).
polaris_link([],_,_,_):-!.
/*------------------*/
polaris_link1(pin,_,[],_):-
    !.
polaris_link1(inv,FIN,[Fin],Comps):-
    !,
    polaris_search1(FIN,Fin,Comps).
polaris_link1(_,FINS,Fins,Comps):-
    !,
    polaris_search(FINS,Fins,Comps).
/*------------------*/
polaris_search([FIN|REST],[Fin|Rest],Comps):-
    !,
    polaris_search1(FIN,Fin,Comps),
    !,
    polaris_search(REST,Rest,Comps).
polaris_search([],[],_):-!.
/*------------------*/
polaris_search1(and(ID),Comp,[Comp|_]):-
    eq(Comp,comp(_,and,ID,_,_,_,_,_)),
    !.
polaris_search1(or(ID),Comp,[Comp|_]):-
    eq(Comp,comp(_,or,ID,_,_,_,_,_)),
    !.
polaris_search1(not(ID),Comp,[Comp|_]):-
    eq(Comp,comp(_,inv,ID,_,_,_,_,_)),
    !.
polaris_search1(pin(A,B,C),Comp,[Comp|_]):-
    eq(Comp,comp(_,pin,_,pin(A,B,C),_,_,_,_)),
    !.
polaris_search1(FIN,Fin,[_|Rest]):-
    !,
    polaris_search1(FIN,Fin,Rest).

/*----------------------*/
/*      validity chk    */
/*----------------------*/
polaris_validity_chk([G|REST],[R|RESULT],T,B):-
    !,
    polaris_validity_chk1(G,R,T,M),
    !,
    polaris_validity_chk(REST,RESULT,M,B).
polaris_validity_chk([],[],T,T):-!.
/*----------------------*/
polaris_validity_chk1(comp(N_Comp,_,_,STR,N_Type,_,N_Fin,_),N_Comp,[N_Comp|T],B):-
    var(N_Comp),
    !,
    eq(N_Comp,comp(CHK,N_Type,Id,STR,NN_Type,NR_Fin,NN_Fin,Inv)),
    !,
    polaris_validity_chk(N_Fin,NR_Fin,T,B).
polaris_validity_chk1(comp(N_Comp,_,_,_,_,_,_,_),N_Comp,T,T):-!.

/*------------------*/
/*      fin trace   */
/*------------------*/
polaris_fin_trace([OWN|REST],Max):-
    !,
    polaris_fin_trace1(OWN,Max),
    !,
    polaris_fin_trace(REST,Max).
polaris_fin_trace([],_):-!.
/*------------------*/
polaris_fin_trace1(comp(_,O_Type,_,_,N_Type,O_Fin,N_Fin,_),Max):-
    var(N_Type),
    !,
    eq(N_Type,O_Type),
    !,
    list_count(O_Fin,Fin_Num),
    !,
    if_then_else(
        bigger(Fin_Num,Max),
        polaris_make_fin_tree(O_Fin,N_Fin,O_Type,Max),
        eq(N_Fin,O_Fin)
    ),
    !,
    polaris_fin_trace(O_Fin,Max).
polaris_fin_trace1(_,_):-!.
/*------------------*/
polaris_make_fin_tree(O_Fin,N_Fin,Type,Max):-
    !,
    polaris_make_fin_list(Max,0,O_Fin,[],M_Fin,Type),
    !,
    list_count(M_Fin,Fin_Num),
    !,
    if_then_else(
        bigger(Fin_Num,Max),
        polaris_make_fin_tree(M_Fin,N_Fin,Type,Max),
        eq(N_Fin,M_Fin)
    ).
/*------------------*/
polaris_make_fin_list(_,_,[],Fin,[COMP],Type):-
    !,
    polaris_make_comp(Type,Fin,COMP).
polaris_make_fin_list(Max,Max,REST,Fin,[COMP|RESULT],Type):-
    !,
    polaris_make_comp(Type,Fin,COMP),
    !,
    polaris_make_fin_list(Max,0,REST,[],RESULT,Type).
polaris_make_fin_list(Max,Now,[Fin|REST],FIN,RESULT,Type):-
    !,
    add1(Now,Next),
    !,
    polaris_make_fin_list(Max,Next,REST,[Fin|FIN],RESULT,Type).
/*------------------*/
polaris_make_comp(_,[Fin],Fin):-
    !.
polaris_make_comp(and,Fin,comp(CHK,_,_,_,and,_,Fin,_)):-
    !,
    dispf('** insert new and gate **\n').
polaris_make_comp(or,Fin,comp(CHK,_,_,_,or,_,Fin,_)):-
    !,
    dispf('** insert new or gate **\n').

/*------------------*/
/*      polaris     */
/*------------------*/
polaris([OWN|REST],[NEW|RESULT]):-
    !,
    polaris1(OWN,NEW),
    !,
    polaris(REST,RESULT).
polaris([],[]):-!.
/*------------------*/
polaris1(OWN,NEW):-
    !,
    eq(OWN,comp(_,O_Type,_,_,N_Type,O_Fin,N_Fin,Inv)),
    !,
    if_then_else(
        var(N_Type),
        polaris2(O_Type,N_Type,O_Fin,N_Fin,OWN,NEW,Inv),
        polaris_use(O_Type,N_Type,N_Fin,OWN,NEW,Inv)
    ).
/*------------------*/
polaris_inv([OWN|REST],[NEW|RESULT]):-
    !,
    polaris_inv1(OWN,NEW),
    !,
    polaris_inv(REST,RESULT).
polaris_inv([],[]):-!.
/*------------------*/
polaris_inv1(OWN,NEW):-
    !,
    eq(OWN,comp(_,O_Type,_,_,N_Type,O_Fin,N_Fin,Inv)),
    !,
    if_then_else(
        var(N_Type),
        polaris_inv2(O_Type,N_Type,O_Fin,N_Fin,OWN,NEW,Inv),
        polaris_use_inv(O_Type,N_Type,N_Fin,OWN,NEW,Inv)
    ).
/*------------------*/
polaris2(and,nor,O_Fin,N_Fin,OWN,OWN,_):-
    !,
    polaris_inv(O_Fin,N_Fin).
polaris2(or,nand,O_Fin,N_Fin,OWN,OWN,_):-
    !,
    polaris_inv(O_Fin,N_Fin).
polaris2(inv,inv,[O_Fin],[N_Fin],_,N_Fin,[]):-
    !,
    polaris_inv1(O_Fin,N_Fin).
polaris2(pin,pin,_,[],OWN,OWN,Inv):-
    !,
    eq(OWN,comp(_,_,_,STR,_,_,_,_)),
    !,
    polaris_make_inv_pin(STR,OWN,Inv).
/*------------------*/
polaris_inv2(and,nand,O_Fin,N_Fin,OWN,OWN,_):-
    !,
    polaris(O_Fin,N_Fin).
polaris_inv2(or,nor,O_Fin,N_Fin,OWN,OWN,_):-
    !,
    polaris(O_Fin,N_Fin).
polaris_inv2(inv,notinv,[O_Fin],[N_Fin],_,N_Fin,[]):-
    !,
    polaris1(O_Fin,N_Fin).
polaris_inv2(pin,pin,_,[],OWN,Inv,Inv):-
    !,
    eq(OWN,comp(_,_,_,STR,_,_,_,_)),
    !,
    polaris_make_inv_pin(STR,OWN,Inv).

/*-----------------*/
/*  make inv pin   */
/*-----------------*/
polaris_make_inv_pin(
    pin(stage,1,N),
    OWN,
    comp(CHK,_,_,pin(stagen,1,N),pin,_,[],OWN)):-
    !.
polaris_make_inv_pin(
    pin(segment,1,N),
    OWN,
    comp(CHK,_,_,pin(segmentn,1,N),pin,_,[],OWN)):-
    !.
polaris_make_inv_pin(
    pin(task,1,N),
    OWN,
    comp(CHK,_,_,pin(taskn,1,N),pin,_,[],OWN)):-
    !.
polaris_make_inv_pin(
    pin(const,1,1),
    OWN,
    comp(CHK,_,_,pin(const,1,0),pin,_,[],OWN)):-
    !.
polaris_make_inv_pin(
    pin(const,1,0),
    OWN,
    comp(CHK,_,_,pin(const,1,1),pin,_,[],OWN)):-
    !.
polaris_make_inv_pin(
    pin(reg,1,N),
    OWN,
    comp(CHK,_,_,pin(regn,1,N),pin,_,[],OWN)):-
    !.

polaris_make_inv_pin(                              /* 1990.05.29 */
    pin(reg_wr,1,N),                               /* 1990.05.29 */
    OWN,                                           /* 1990.05.29 */
    comp(CHK,_,_,pin(reg_wrn,1,N),pin,_,[],OWN)):- /* 1990.05.29 */
    !.                                             /* 1990.05.29 */

polaris_make_inv_pin(                              /* 1990.06.18 */
    pin(reg_ws,1,N),                               /* 1990.06.18 */
    OWN,                                           /* 1990.06.18 */
    comp(CHK,_,_,pin(reg_wsn,1,N),pin,_,[],OWN)):- /* 1990.06.18 */
    !.                                             /* 1990.06.18 */

polaris_make_inv_pin(
    pin(scan_reg,1,N),
    OWN,
    comp(CHK,_,_,pin(scan_regn,1,N),pin,_,[],OWN)):-
    !.
polaris_make_inv_pin(
    pin(scan_reg_wr,1,N),
    OWN,
    comp(CHK,_,_,pin(scan_reg_wrn,1,N),pin,_,[],OWN)):-
    !.
polaris_make_inv_pin(
    pin(scan_reg_ws,1,N),
    OWN,
    comp(CHK,_,_,pin(scan_reg_wsn,1,N),pin,_,[],OWN)):-
    !.

polaris_make_inv_pin(
    pin(subst,1,[P,P,pin(reg,W,N)]),
    OWN,
    comp(CHK,_,_,pin(substn,1,[P,P,pin(reg,W,N)]),pin,_,[],OWN)):-
    !.

polaris_make_inv_pin(                                                 /* 1990.05.29 */
    pin(subst,1,[P,P,pin(reg_wr,W,N)]),                               /* 1990.05.29 */
    OWN,                                                              /* 1990.05.29 */
    comp(CHK,_,_,pin(substn,1,[P,P,pin(reg_wr,W,N)]),pin,_,[],OWN)):- /* 1990.05.29 */
    !.                                                                /* 1990.05.29 */

polaris_make_inv_pin(                                                 /* 1990.06.18 */
    pin(subst,1,[P,P,pin(reg_ws,W,N)]),                               /* 1990.06.18 */
    OWN,                                                              /* 1990.06.18 */
    comp(CHK,_,_,pin(substn,1,[P,P,pin(reg_ws,W,N)]),pin,_,[],OWN)):- /* 1990.06.18 */
    !.                                                                /* 1990.06.18 */

polaris_make_inv_pin(
    pin(subst,1,[P,P,pin(scan_reg,W,N)]),
    OWN,
    comp(CHK,_,_,pin(substn,1,[P,P,pin(scan_reg,W,N)]),pin,_,[],OWN)):-
    !.
polaris_make_inv_pin(
    pin(subst,1,[P,P,pin(scan_reg_wr,W,N)]),
    OWN,
    comp(CHK,_,_,pin(substn,1,[P,P,pin(scan_reg_wr,W,N)]),pin,_,[],OWN)):-
    !.
polaris_make_inv_pin(
    pin(subst,1,[P,P,pin(scan_reg_ws,W,N)]),
    OWN,
    comp(CHK,_,_,pin(substn,1,[P,P,pin(scan_reg_ws,W,N)]),pin,_,[],OWN)):-
    !.

polaris_make_inv_pin(_,OWN,Inv):-
    !,
    polaris_inv_insert(Inv,OWN).

/*----------*/
/*  use     */
/*----------*/
polaris_use(and,nand,_,OWN,Inv,Inv):-
    !,
    polaris_inv_insert(Inv,OWN).
polaris_use(or,nor,_,OWN,Inv,Inv):-
    !,
    polaris_inv_insert(Inv,OWN).
polaris_use(inv,inv,[N_Fin],_,N_Fin,[]):-
    !.
polaris_use(and,nor,_,OWN,OWN,_):-
    !.
polaris_use(or,nand,_,OWN,OWN,_):-
    !.
polaris_use(inv,notinv,[comp(_,_,_,_,Type,_,Fin,Inv)],OWN,NEW,[]):-
    !,
    if_then_else(
        eq(Type,inv),
        eq([NEW],Fin),
        if_then_else(
            var(Inv),
            and(
                eq(NEW,OWN),
                eq(Inv,OWN)
            ),
            eq(NEW,Inv)
        )
    ).
polaris_use(pin,_,_,OWN,OWN,_):-!.

/*--------------*/
/*  inv use     */
/*--------------*/
polaris_use_inv(and,nand,_,OWN,OWN,_):-
    !.
polaris_use_inv(or,nor,_,OWN,OWN,_):-
    !.
polaris_use_inv(inv,inv,[comp(_,_,_,_,Type,_,Fin,Inv)],OWN,NEW,[]):-
    !,
    if_then_else(
        eq(Type,inv),
        eq([NEW],Fin),
        if_then_else(
            var(Inv),
            and(
                eq(NEW,OWN),
                eq(Inv,OWN)
            ),
            eq(NEW,Inv)
        )
    ).
polaris_use_inv(and,nor,_,OWN,Inv,Inv):-
    !,
    polaris_inv_insert(Inv,OWN).
polaris_use_inv(or,nand,_,OWN,Inv,Inv):-
    !,
    polaris_inv_insert(Inv,OWN).
polaris_use_inv(inv,notinv,[N_Fin],_,N_Fin,[]):-
    !.
polaris_use_inv(pin,_,_,_,Inv,Inv):-!.

/*--------------*/
/*  inv insert  */
/*--------------*/
polaris_inv_insert(Inv,OWN):-
    var(Inv),
    !,
    eq(Inv,comp(CHK,_,_,_,inv,_,[OWN],[])),
    !,
    dispf('** insert or replace not gate **\n').
polaris_inv_insert(_,_):-!.

/*------------------*/
/*      last        */
/*------------------*/
polaris_set_new_id([comp(_,pin,_,_,_,_,_,_)|REST],In1,In2,In3):-
    !,
    polaris_set_new_id(REST,In1,In2,In3).
polaris_set_new_id([comp(_,inv,In1,_,_,_,_,_)|REST],In1,In2,In3):-
    !,
    add1(In1,Out),
    !,
    polaris_set_new_id(REST,Out,In2,In3).
polaris_set_new_id([comp(_,notinv,In1,_,_,_,_,_)|REST],In1,In2,In3):-
    !,
    add1(In1,Out),
    !,
    polaris_set_new_id(REST,Out,In2,In3).
polaris_set_new_id([comp(_,nand,In2,_,_,_,_,_)|REST],In1,In2,In3):-
    !,
    add1(In2,Out),
    !,
    polaris_set_new_id(REST,In1,Out,In3).
polaris_set_new_id([comp(_,nor,In3,_,_,_,_,_)|REST],In1,In2,In3):-
    !,
    add1(In3,Out),
    !,
    polaris_set_new_id(REST,In1,In2,Out).
polaris_set_new_id([],_,_,_):-!.
/*------------------*/
polaris_last([comp(_,pin,_,_,_,_,_,_)|REST],
             Inv,Nand,Nor):-
    !,
    polaris_last(REST,Inv,Nand,Nor).
polaris_last([comp(_,inv,_,_,_,Fin,_,_)|REST],
             [FIN|Inv],Nand,Nor):-
    !,
    polaris_last1(Fin,[FIN]),
    !,
    polaris_last(REST,Inv,Nand,Nor).
polaris_last([comp(_,notinv,_,_,_,Fin,_,_)|REST],
             [FIN|Inv],Nand,Nor):-
    !,
    polaris_last1(Fin,[FIN]),
    !,
    polaris_last(REST,Inv,Nand,Nor).
polaris_last([comp(_,nand,_,_,_,Fin,_,_)|REST],
             Inv,[FIN|Nand],Nor):-
    !,
    polaris_last1(Fin,FIN),
    !,
    polaris_last(REST,Inv,Nand,Nor).
polaris_last([comp(_,nor,_,_,_,Fin,_,_)|REST],
             Inv,Nand,[FIN|Nor]):-
    !,
    polaris_last1(Fin,FIN),
    !,
    polaris_last(REST,Inv,Nand,Nor).
polaris_last([],[],[],[]):-!.
/*------------------*/
polaris_last1([comp(_,pin,_,STR,_,_,_,_)|REST],
              [STR|RESULT]):-
    !,
    polaris_last1(REST,RESULT).
polaris_last1([comp(_,inv,Id,_,_,_,_,_)|REST],
              [not(Id)|RESULT]):-
    !,
    polaris_last1(REST,RESULT).
polaris_last1([comp(_,notinv,Id,_,_,_,_,_)|REST],
              [not(Id)|RESULT]):-
    !,
    polaris_last1(REST,RESULT).
polaris_last1([comp(_,nand,Id,_,_,_,_,_)|REST],
              [nand(Id)|RESULT]):-
    !,
    polaris_last1(REST,RESULT).
polaris_last1([comp(_,nor,Id,_,_,_,_,_)|REST],
              [nor(Id)|RESULT]):-
    !,
    polaris_last1(REST,RESULT).
polaris_last1([],[]):-!.

/****************
    /***********/
    /* polaris */
    /***********/   /* comp(Id,CHK,O_Type,O_ID,STR,N_Type,O_Fin,N_Fin,Inv) */

polaris(Max_Fin,Result,Pins,Nots,  Ands,  Ors,
              X_Result,   X_Nots,X_Ands,X_Ors):-
    dispf('\n#### start and-or to nand-nor exchange and limit fin ####\n'),

    polaris_exchange([Result],result,1,0,           Pin_start_id,   OWN, Own1),
    polaris_exchange(Pins,    pin,   1,Pin_start_id,Not_start_id,   Own1,Own2),
    polaris_exchange(Nots,    inv,   1,Not_start_id,And_start_id,   Own2,Own3),
    polaris_exchange(Ands,    and,   1,And_start_id,Or_start_id,    Own3,Own4),
    polaris_exchange(Ors,     or,    1,Or_start_id, And_Or_start_id,Own4,[]),

    polaris_link([Result],result,OWN, OWN),
    polaris_link(Pins,    pin,   Own1,OWN),
    polaris_link(Nots,    inv,   Own2,OWN),
    polaris_link(Ands,    and,   Own3,OWN),
    polaris_link(Ors,     or,    Own4,OWN),
    polaris_comp_display(OWN),nl,

    eq(OWN,[Top|_]),
    eq(Top,comp(0,_,result,_,_,result,O_Fin,O_Fin,[])),
    polaris_fin_trace(O_Fin,Max_Fin,And_Or_start_id,Inv_start_id),
    polaris_validity_chk([Top],_,OWN1,[]),
    polaris_comp_display(OWN1),nl,

    eq(OWN1,[Top1|_]),
    eq(Top1,comp(0,_,result,_,_,result,O_Fin1,N_Fin1,[])),
    polaris(O_Fin1,N_Fin1,Inv_start_id,_),
    polaris_validity_chk([Top1],_,OWN2,[]),
    polaris_comp_display(OWN2),nl,

    eq(OWN2,[Top2|Others2]),
    eq(Top2,comp(_,_,_,_,_,_,O_Fin2,_,_)),
    polaris_last_pre(Others2,1,1,1),
    polaris_last1(O_Fin2,X_Result),
    polaris_last(Others2,X_Nots,X_Ands,X_Ors),

    list_display(X_Result),nl,
    nots_display(X_Nots,1),nl,
    ands_display(X_Ands,1),nl,
    ors_display(X_Ors,1),nl,
    dispf('** end polaris **\n').

/*------------------*/
/*      link        */
/*------------------*/
polaris_exchange([STR|REST],Type,O_In,In,Last,
                 [comp(In,CHK,Type,O_In,STR,N_Type,O_Fin,N_Fin,Inv)|M],B):-
    !,
    add1(In,Out),
    add1(O_In,O_Out),
    polaris_exchange(REST,Type,O_Out,Out,Last,M,B).
polaris_exchange([],_,_,N,N,T,T).
/*------------------*/
polaris_link([COMP|REST],Type,[comp(_,_,_,_,_,_,Fin,_,_)|Rest],Comps):-
    !,
    polaris_link1(Type,COMP,Fin,Comps),
    polaris_link(REST,Type,Rest,Comps).
polaris_link([],_,_,_).
/*------------------*/
polaris_link1(pin,_,[],_):-
    !.
polaris_link1(inv,FIN,[Fin],Comps):-
    !,
    polaris_search1(FIN,Fin,Comps).
polaris_link1(_,FINS,Fins,Comps):-
    polaris_search(FINS,Fins,Comps).
/*------------------*/
polaris_search([FIN|REST],[Fin|Rest],Comps):-
    !,
    polaris_search1(FIN,Fin,Comps),
    polaris_search(REST,Rest,Comps).
polaris_search([],[],_).
/*------------------*/
polaris_search1(and(ID),Comp,[Comp|_]):-
    eq(Comp,comp(_,_,and,ID,_,_,_,_,_)),
    !.
polaris_search1(or(ID),Comp,[Comp|_]):-
    eq(Comp,comp(_,_,or,ID,_,_,_,_,_)),
    !.
polaris_search1(not(ID),Comp,[Comp|_]):-
    eq(Comp,comp(_,_,inv,ID,_,_,_,_,_)),
    !.
polaris_search1(pin(A,B,C),Comp,[Comp|_]):-
    eq(Comp,comp(_,_,pin,_,pin(A,B,C),_,_,_,_)),
    !.
polaris_search1(FIN,Fin,[_|Rest]):-
    polaris_search1(FIN,Fin,Rest).

/*----------------------*/
/*      validity chk    */
/*----------------------*/
polaris_validity_chk([G|REST],[R|RESULT],T,B):-
    !,
    polaris_validity_chk1(G,R,T,M),
    polaris_validity_chk(REST,RESULT,M,B).
polaris_validity_chk([],[],T,T).
/*----------------------*/
polaris_validity_chk1(comp(Id,N_Comp,_,_,STR,N_Type,_,N_Fin,_),N_Comp,[N_Comp|T],B):-
    var(N_Comp),
    !,
    eq(N_Comp,comp(Id,CHK,N_Type,Last_Id,STR,NN_Type,NR_Fin,NN_Fin,Inv)),
    polaris_validity_chk(N_Fin,NR_Fin,T,B).
polaris_validity_chk1(comp(_,N_Comp,_,_,_,_,_,_,_),N_Comp,T,T).

/*------------------*/
/*      fin trace   */
/*------------------*/
polaris_fin_trace([OWN|REST],Max,In,Out):-
    !,
    polaris_fin_trace(OWN,Max,In,Mid),
    polaris_fin_trace(REST,Max,Mid,Out).
polaris_fin_trace([],_,N,N):-
    !.
polaris_fin_trace(
    comp(_,_,O_Type,_,_,N_Type,O_Fin,N_Fin,_),
    Max,In,Out):-
    var(N_Type),
    !,
    eq(N_Type,O_Type),
    list_count(O_Fin,Fin_Num),
    if_then_else(
        bigger(Fin_Num,Max),
        polaris_make_fin_tree(O_Fin,N_Fin,O_Type,Max,In,Mid),
        and(
            eq(N_Fin,O_Fin),
            eq(In,Mid)
        )
    ),
    polaris_fin_trace(O_Fin,Max,Mid,Out).
polaris_fin_trace(_,_,N,N).
/*------------------*/
polaris_make_fin_tree(O_Fin,N_Fin,Type,Max,In,Out):-
    polaris_make_fin_list(
                  Max,0,
                  O_Fin,    /* input */
                  [],
                  M_Fin,    /* result */
                  Type,In,Mid),
    list_count(M_Fin,Fin_Num),
    if_then_else(
        bigger(Fin_Num,Max),
        polaris_make_fin_tree(M_Fin,N_Fin,Type,Max,Mid,Out),
        and(
            eq(N_Fin,M_Fin),
            eq(Mid,Out)
        )
    ).
/*------------------*/
polaris_make_fin_list(
              _,_,
              [],       /* input */
              Fin,
              [COMP],   /* result */
              Type,In,Out):-
    !,
    polaris_make_comp(Type,Fin,COMP,In,Out).
polaris_make_fin_list(
              Max,Max,
              REST,     /* input */
              Fin,
              [COMP|RESULT],    /* result */
              Type,In,Out):-
    !,
    polaris_make_comp(Type,Fin,COMP,In,Mid),
    polaris_make_fin_list(
              Max,0,
              REST,
              [],
              RESULT,
              Type,Mid,Out).
polaris_make_fin_list(
              Max,Now,
              [Fin|REST],   /* input */
              FIN,
              RESULT,       /* result */
              Type,In,Out):-
    add1(Now,Next),
    polaris_make_fin_list(
              Max,Next,
              REST,
              [Fin|FIN],
              RESULT,
              Type,In,Out).
/*------------------*/
polaris_make_comp(_,[Fin],Fin,N,N):-
    !.
polaris_make_comp(and,Fin,
          comp(In,CHK,[],_,_,and,[],Fin,_),
          In,Out):-
    !,
    dispf('** insert new and gate(id=%d) **\n',In),
    add1(In,Out).
polaris_make_comp(or,Fin,
          comp(In,CHK,[],_,_,or,[],Fin,_),
          In,Out):-
    dispf('** insert new or gate(id=%d) **\n',In),
    add1(In,Out).

/*------------------*/
/*      polaris     */
/*------------------*/
polaris([OWN|REST],[NEW|RESULT],In,Out):-
    !,
    polaris(OWN,NEW,In,Mid),
    polaris(REST,RESULT,Mid,Out).
polaris([],[],N,N):-
    !.
polaris(OWN,NEW,In,Out):-
    eq(OWN,comp(_,_,O_Type,_,_,N_Type,O_Fin,N_Fin,Inv)),
    if_then_else(
        var(N_Type),
        polaris1(O_Type,N_Type,O_Fin,N_Fin,OWN,NEW,Inv,In,Out),
        polaris_use(O_Type,N_Type,N_Fin,OWN,NEW,Inv,In,Out)
    ).
/*------------------*/
polaris_inv([OWN|REST],[NEW|RESULT],In,Out):-
    !,
    polaris_inv(OWN,NEW,In,Mid),
    polaris_inv(REST,RESULT,Mid,Out).
polaris_inv([],[],N,N):-
    !.
polaris_inv(OWN,NEW,In,Out):-
    eq(OWN,comp(_,_,O_Type,_,_,N_Type,O_Fin,N_Fin,Inv)),
    if_then_else(
        var(N_Type),
        polaris_inv1(O_Type,N_Type,O_Fin,N_Fin,OWN,NEW,Inv,In,Out),
        polaris_use_inv(O_Type,N_Type,N_Fin,OWN,NEW,Inv,In,Out)
    ).
/*------------------*/
polaris1(and,nor,O_Fin,N_Fin,OWN,OWN,_,In,Out):-
    !,
    polaris_inv(O_Fin,N_Fin,In,Out).
polaris1(or,nand,O_Fin,N_Fin,OWN,OWN,_,In,Out):-
    !,
    polaris_inv(O_Fin,N_Fin,In,Out).
polaris1(inv,inv,[O_Fin],[N_Fin],_,N_Fin,[],In,Out):-
    !,
    polaris_inv(O_Fin,N_Fin,In,Out).
polaris1(pin,pin,[],[],OWN,OWN,_,N,N).
/*------------------*/
polaris_inv1(and,nand,O_Fin,N_Fin,OWN,OWN,_,In,Out):-
    !,
    polaris(O_Fin,N_Fin,In,Out).
polaris_inv1(or,nor,O_Fin,N_Fin,OWN,OWN,_,In,Out):-
    !,
    polaris(O_Fin,N_Fin,In,Out).
polaris_inv1(inv,notinv,[O_Fin],[N_Fin],_,N_Fin,[],In,Out):-
    !,
    polaris(O_Fin,N_Fin,In,Out).
polaris_inv1(pin,pin,[],[],OWN,Inv,Inv,In,Out):-
    eq(Inv,comp(In,CHK,[],_,_,inv,[],[OWN],[])),
    dispf('** insert new not gate(id=%d) **\n',In),
    add1(In,Out).
/*----------*/
/*  use     */
/*----------*/
polaris_use(and,nand,_,OWN,Inv,Inv,In,Out):-
    !,
    polaris_inv_insert(Inv,OWN,In,Out).
polaris_use(or,nor,_,OWN,Inv,Inv,In,Out):-
    !,
    polaris_inv_insert(Inv,OWN,In,Out).
polaris_use(inv,inv,[N_Fin],_,N_Fin,[],N,N):-
    !.
polaris_use(and,nor,_,OWN,OWN,_,N,N):-
    !.
polaris_use(or,nand,_,OWN,OWN,_,N,N):-
    !.
polaris_use(inv,notinv,
            [comp(_,_,_,_,_,Type,_,Fin,Inv)],
            OWN,NEW,[],N,N):-
    !,
    if_then_else(
        eq(Type,inv),
        eq([NEW],Fin),
        if_then_else(
            var(Inv),
            and(
                eq(NEW,OWN),
                eq(Inv,OWN)
            ),
            eq(NEW,Inv)
        )
    ).
polaris_use(pin,pin,[],OWN,OWN,_,N,N).
/*--------------*/
/*  inv use     */
/*--------------*/
polaris_use_inv(and,nand,_,OWN,OWN,_,N,N):-
    !.
polaris_use_inv(or,nor,_,OWN,OWN,_,N,N):-
    !.
polaris_use_inv(inv,inv,
            [comp(_,_,_,_,_,Type,_,Fin,Inv)],
            OWN,NEW,[],N,N):-
    !,
    if_then_else(
        eq(Type,inv),
        eq([NEW],Fin),
        if_then_else(
            var(Inv),
            and(
                eq(NEW,OWN),
                eq(Inv,OWN)
            ),
            eq(NEW,Inv)
        )
    ).
polaris_use_inv(and,nor,_,OWN,Inv,Inv,In,Out):-
    !,
    polaris_inv_insert(Inv,OWN,In,Out).
polaris_use_inv(or,nand,_,OWN,Inv,Inv,In,Out):-
    !,
    polaris_inv_insert(Inv,OWN,In,Out).
polaris_use_inv(inv,notinv,[N_Fin],_,N_Fin,[],N,N):-
    !.
polaris_use_inv(pin,pin,[],OWN,Inv,Inv,In,Out):-
    polaris_inv_insert(Inv,OWN,In,Out).
/*--------------*/
/*  inv insert  */
/*--------------*/
polaris_inv_insert(Inv,OWN,In,Out):-
    var(Inv),
    !,
    eq(Inv,comp(In,CHK,[],_,_,inv,[],[OWN],[])),
    dispf('** insert new not gate(id=%d) **\n',In),
    add1(In,Out).
polaris_inv_insert(_,_,N,N).

/*------------------*/
/*      display     */
/*------------------*/
polaris_comp_display([comp(Id,_,O_Type,_,_,_,O_Fin,_,_)|REST]):-
    !,
    dispf('comp(%d,%s)\n',Id,O_Type),
    polaris_fin_display(O_Fin),
    polaris_comp_display(REST).
polaris_comp_display([]).
/*------------------*/
polaris_fin_display([comp(Id,_,O_Type,_,_,_,_,_,_)|REST]):-
    !,
    dispf('\tcomp(%d,%s)\n',Id,O_Type),
    polaris_fin_display(REST).
polaris_fin_display([]).

/*------------------*/
/*      last        */
/*------------------*/
polaris_last_pre([comp(_,_,pin,_,_,_,_,_,_)|REST],In1,In2,In3):-
    !,
    polaris_last_pre(REST,In1,In2,In3).
polaris_last_pre([comp(_,_,inv,In1,_,_,_,_,_)|REST],In1,In2,In3):-
    !,
    add1(In1,Out),
    polaris_last_pre(REST,Out,In2,In3).
polaris_last_pre([comp(_,_,notinv,In1,_,_,_,_,_)|REST],In1,In2,In3):-
    !,
    add1(In1,Out),
    polaris_last_pre(REST,Out,In2,In3).
polaris_last_pre([comp(_,_,nand,In2,_,_,_,_,_)|REST],In1,In2,In3):-
    !,
    add1(In2,Out),
    polaris_last_pre(REST,In1,Out,In3).
polaris_last_pre([comp(_,_,nor,In3,_,_,_,_,_)|REST],In1,In2,In3):-
    !,
    add1(In3,Out),
    polaris_last_pre(REST,In1,In2,Out).
polaris_last_pre([],_,_,_).
/*------------------*/
polaris_last([comp(_,_,pin,_,_,_,_,_,_)|REST],
             Inv,Nand,Nor):-
    !,
    polaris_last(REST,Inv,Nand,Nor).
polaris_last([comp(Id,_,inv,_,_,_,Fin,_,_)|REST],
             [FIN|Inv],Nand,Nor):-
    !,
    polaris_last1(Fin,[FIN]),
    polaris_last(REST,Inv,Nand,Nor).
polaris_last([comp(Id,_,notinv,_,_,_,Fin,_,_)|REST],
             [FIN|Inv],Nand,Nor):-
    !,
    polaris_last1(Fin,[FIN]),
    polaris_last(REST,Inv,Nand,Nor).
polaris_last([comp(Id,_,nand,_,_,_,Fin,_,_)|REST],
             Inv,[FIN|Nand],Nor):-
    !,
    polaris_last1(Fin,FIN),
    polaris_last(REST,Inv,Nand,Nor).
polaris_last([comp(Id,_,nor,_,_,_,Fin,_,_)|REST],
             Inv,Nand,[FIN|Nor]):-
    !,
    polaris_last1(Fin,FIN),
    polaris_last(REST,Inv,Nand,Nor).
polaris_last([],[],[],[]).
/*------------------*/
polaris_last1([comp(_,_,pin,_,STR,_,_,_,_)|REST],
              [STR|RESULT]):-
    !,
    polaris_last1(REST,RESULT).
polaris_last1([comp(_,_,inv,Id,_,_,_,_,_)|REST],
              [not(Id)|RESULT]):-
    !,
    polaris_last1(REST,RESULT).
polaris_last1([comp(_,_,notinv,Id,_,_,_,_,_)|REST],
              [not(Id)|RESULT]):-
    !,
    polaris_last1(REST,RESULT).
polaris_last1([comp(_,_,nand,Id,_,_,_,_,_)|REST],
              [nand(Id)|RESULT]):-
    !,
    polaris_last1(REST,RESULT).
polaris_last1([comp(_,_,nor,Id,_,_,_,_,_)|REST],
              [nor(Id)|RESULT]):-
    !,
    polaris_last1(REST,RESULT).
polaris_last1([],[]).
****************/

    /***********/
    /* hsl out */
    /***********/

hsl_out(Cube_submod,Name,
        Facility,
        Stage,
        STG_ST,
        NOTS,ANDS,ORS,SELS,
        T_CLASS,EOR_ID):-
    chk_term_tmp(SELS,NOTS,ANDS,ORS),   /* add 1990.03.22 */
    !,
    atom_value_read(multi_level_opt,Multi_level_opt),
    if_then_else(
        eq(Multi_level_opt,yes),
        atom_value_read(change_to_nand_nor,Max_Fin),
        eq(Max_Fin,0)
    ),
    hsl_out_ext_det(Facility,L_EXT,L_INPUTS,L_OUTPUTS,L_BUS),
    hsl_out_detect_class(Facility,Classes,I_Facility),
    hsl_out_detect_task(Stage,I_Stage),
    hsl_out_detect_stage(STG_ST,I_STG_ST),  /* stg(STG,[st(SEG,ST)],Size,[SEG]) */
    append(I_Stage,I_STG_ST,I_STAGE),
    append(I_Facility,I_STAGE,INSTANCES),
    if_then_else(
        eq(I_Stage,[]),
        eq(CLASSESm,Classes),
        eq(CLASSESm,[class(reg,IDt,1,1)|Classes])
    ),
    atom_value_read(test_syn_pass,Pass),
    if_then_else(
        eq(Pass,2),
        sdispf('sreg---1',IDt),
        sdispf('reg---1',IDt)
    ),
    if_then_else(
        eq(I_STG_ST,[]),
        eq(CLASSES,CLASSESm),
        eq(CLASSES,[class(reg,IDs,1,1)|CLASSESm])
    ),
    atom_value_read(test_syn_pass,Pass),
    if_then_else(
        eq(Pass,2),
        sdispf('sreg--1',IDs),
        sdispf('reg--1',IDs)
    ),
    sort(CLASSES,S_CLASSES),
    hsl_out_detect_sels(SELS,
                        SELS1,
                        I_SELS,
                        1,
                        I_bus_dums,
                        I_instr_dums,
                        I_sel_dums,
                        I_buss,
                        I_sels,
                        I_task),    /* add 1988.10.20 */
    sort(SELS1,S_SELS),
    append(S_CLASSES,S_SELS,T_CLASS1),
    hsl_out_detect_nots(NOTS,NOTS1,I_NOTS,1),
    sort(NOTS1,S_NOTS),
    append(T_CLASS1,S_NOTS,T_CLASS2),
    hsl_out_detect_ands(ANDS,ANDS1,I_ANDS,1,Max_Fin),
    sort(ANDS1,S_ANDS),
    append(T_CLASS2,S_ANDS,T_CLASS3),
    hsl_out_detect_ors(ORS,ORS1,I_ORS,1,Max_Fin),
    sort(ORS1,S_ORS),
    append(T_CLASS3,S_ORS,T_CLASS),
    fdispf('\nNAME: %s ;\n',Name),
    fdispf('PURPOSE: SFL ;\n'),
    fdispf('PROCESS: SFL ;\n'),
    fdispf('LEVEL: SFL ;\n'),
    fdispf('EXT:\n'),
    hsl_out_ext_out(L_EXT),
    fdispf(' ;\n'),
    if_else(
        eq(L_INPUTS,[]),
        and(
            fdispf('INPUTS:\n'),
            hsl_out_ext_out(L_INPUTS),
            fdispf(' ;\n')
        )
    ),
    if_else(
        eq(L_OUTPUTS,[]),
        and(
            fdispf('OUTPUTS:\n'),
            hsl_out_ext_out(L_OUTPUTS),
            fdispf(' ;\n')
        )
    ),
    if_else(
        eq(L_BUS,[]),
        and(
            fdispf('BUS:\n'),
            hsl_out_ext_out(L_BUS),
            fdispf(' ;\n')
        )
    ),
    atom_value_read(to_other_tool,OTHER),
    if_then_else(
        eq(OTHER,no),
        and(
            eq(O_CLASS,[]),
            eq(O_INST,[])
        ),
        hsl_out_cube_submod(Cube_submod,
                            Name,
                            O_CLASS,
                            O_INST)
    ),
    append(O_CLASS,T_CLASS,OT_CLASS),
    fdispf('TYPES:\n'),
    if_then_else(
        eq(EOR_ID,0),
        hsl_out_class([class(_,'high-',_,_),class(_,'low-',_,_)|OT_CLASS]),
        hsl_out_class([class(_,'high-',_,_),class(_,'low-',_,_),class(_,'eor--2',_,_)|OT_CLASS])
    ),
    fdispf(' ;\n'),
    hsl_out_instance(O_CLASS,O_INST),
    hsl_out_instance(S_CLASSES,INSTANCES),
    hsl_out_instance(S_SELS   ,I_SELS),
    hsl_out_instance(S_NOTS   ,I_NOTS),
    hsl_out_instance(S_ANDS   ,I_ANDS),
    hsl_out_instance(S_ORS    ,I_ORS),
    hsl_out_instance_eor(EOR_ID),
    hsl_out_instance([class(_,'high-',_,_),class(_,'low-',_,_)],
                     [instance(_,_,'high-','high-',_),instance(_,_,'low-','low-',_)]),
    fdispf('END-TYPES ;\n'),
    fdispf('NET-SECTION ;\n'),
    fdispf('"***** task set reset *****"\n'),
    hsl_out_net_task_dum(I_task),
    fdispf('"***** dummy bus *****"\n'),
    hsl_out_net_bus_dum(I_bus_dums),
    fdispf('"***** dummy instrself *****"\n'),
    hsl_out_net_instr_dum(I_instr_dums),
    fdispf('"***** simple path *****"\n'),
    hsl_out_net_sel_dum(I_sel_dums),
    fdispf('"***** bus *****"\n'),
    hsl_out_net_bus(I_buss),
    fdispf('"***** selecter *****"\n'),
    hsl_out_net_sel(I_sels),
    fdispf('"***** or *****"\n'),
    hsl_out_net_and_or(I_ORS),
    fdispf('"***** and *****"\n'),
    hsl_out_net_and_or(I_ANDS),
    fdispf('"***** not *****"\n'),
    hsl_out_net_not(I_NOTS),
    fdispf('"***** reset clock *****"\n'),
    hsl_out_reset_clock(INSTANCES),
    hsl_out_reset_clock(I_SELS),
    hsl_out_scan(INSTANCES),
    fdispf('END-SECTION ;\n'),
    fdispf('END ;\n').

/*****--------------------------------*****/    /* add 1990.03.22 */
/*      check term tmp consistency        */
/*****--------------------------------*****/
chk_term_tmp(SELS,NOTS,ANDS,ORS):-
    !,
    chk_term_tmp_sels(SELS,DST,[],SRC,SRC1),
    !,
    chk_term_tmp_pins(NOTS,SRC1,SRC2),
    !,
    chk_term_tmp_and_ors(ANDS,SRC2,SRC3),
    !,
    chk_term_tmp_and_ors(ORS,SRC3,[]),
    !,
    sort(DST,S_DST),
    !,
    sort(SRC,S_SRC),
    !,
    chk_term_tmp_consistency(S_SRC,S_DST).
/*----------------------------------------*/
chk_term_tmp_sels([SEL|REST],T1,B1,T2,B2):-
    !,
    chk_term_tmp_sel(SEL,T1,M1,T2,M2),
    !,
    chk_term_tmp_sels(REST,M1,B1,M2,B2).
chk_term_tmp_sels([],A,A,B,B).
/*----------------------------------------*/
chk_term_tmp_sel(sel(DST,_,SRCS),T1,B1,T2,B2):-
    !,
    chk_term_tmp_pin(DST,T1,B1),
    !,
    chk_term_tmp_srcs(SRCS,T2,B2).
/*----------------------------------------*/
chk_term_tmp_srcs([SRC|REST],T,B):-
    !,
    chk_term_tmp_src(SRC,T,M),
    !,
    chk_term_tmp_srcs(REST,M,B).
chk_term_tmp_srcs([],A,A).
/*----------------------------------------*/
chk_term_tmp_src(src(CND,SRC),T,B):-
    !,
    chk_term_tmp_pin(CND,T,M),
    !,
    chk_term_tmp_pin(SRC,M,B).
/*----------------------------------------*/
chk_term_tmp_and_ors([G|REST],T,B):-
    !,
    chk_term_tmp_pins(G,T,M),
    !,
    chk_term_tmp_and_ors(REST,M,B).
chk_term_tmp_and_ors([],A,A).
/*----------------------------------------*/
chk_term_tmp_pins([PIN|REST],T,B):-
    !,
    chk_term_tmp_pin(PIN,T,M),
    !,
    chk_term_tmp_pins(REST,M,B).
chk_term_tmp_pins([],A,A).
/*----------------------------------------*/
chk_term_tmp_pin(and(_),A,A):-!.
chk_term_tmp_pin(or(_),A,A):-!.
chk_term_tmp_pin(not(_),A,A):-!.
chk_term_tmp_pin(nand(_),A,A):-!.
chk_term_tmp_pin(nor(_),A,A):-!.
chk_term_tmp_pin(pin(cat,_,[MS,LS]),T,B):-
    !,
    chk_term_tmp_pin(MS,T,M),
    !,
    chk_term_tmp_pin(LS,M,B).
chk_term_tmp_pin(pin(subst,_,[_,_,P]),T,B):-
    !,
    chk_term_tmp_pin(P,T,B).
chk_term_tmp_pin(P,[P|A],A):-
    eq(P,pin(reg,_,Name)),
    !.

chk_term_tmp_pin(P,[P|A],A):- /* 1990.05.29 */
    eq(P,pin(reg_wr,_,Name)), /* 1990.05.29 */
    !.                        /* 1990.05.29 */

chk_term_tmp_pin(P,[P|A],A):- /* 1990.06.18 */
    eq(P,pin(reg_ws,_,Name)), /* 1990.06.18 */
    !.                        /* 1990.06.18 */

chk_term_tmp_pin(P,[P|A],A):-
    eq(P,pin(scan_reg,_,Name)),
    !.
chk_term_tmp_pin(P,[P|A],A):-
    eq(P,pin(scan_reg_wr,_,Name)),
    !.
chk_term_tmp_pin(P,[P|A],A):-
    eq(P,pin(scan_reg_ws,_,Name)),
    !.

chk_term_tmp_pin(pin(regn,W,N),[pin(reg,W,N)|A],A):-
    !.

chk_term_tmp_pin(pin(reg_wrn,W,N),[pin(reg_wr,W,N)|A],A):- /* 1990.05.29 */
    !.                                                     /* 1990.05.29 */

chk_term_tmp_pin(pin(reg_wsn,W,N),[pin(reg_ws,W,N)|A],A):- /* 1990.06.18 */
    !.                                                     /* 1990.06.18 */

chk_term_tmp_pin(pin(scan_regn,W,N),[pin(scan_reg,W,N)|A],A):-
    !.
chk_term_tmp_pin(pin(scan_reg_wrn,W,N),[pin(scan_reg_wr,W,N)|A],A):-
    !.
chk_term_tmp_pin(pin(scan_reg_wsn,W,N),[pin(scan_reg_ws,W,N)|A],A):-
    !.

chk_term_tmp_pin(P,[P|A],A):-
    eq(P,pin(bus_org,_,Name)),
    !.
chk_term_tmp_pin(P,[P|A],A):-
    eq(P,pin(sel_org,_,Name)),
    !.
chk_term_tmp_pin(_,A,A).
/*****--------------------------------*****/
chk_term_tmp_consistency([SRC|REST],DSTS):-
    !,
    chk_term_tmp_consistency1(DSTS,SRC),
    !,
    chk_term_tmp_consistency(REST,DSTS).
chk_term_tmp_consistency([],_).
/*----------------------------------------*/
chk_term_tmp_consistency1([PIN|_],PIN):-
    !.
chk_term_tmp_consistency1([_|REST],SRC):-
    !,
    chk_term_tmp_consistency1(REST,SRC).
chk_term_tmp_consistency1([],pin(_,_,Name)):-
    !,
    atom_value_read(error_flg,X),
    add1(X,Y),
    atom_value_set(error_flg,Y),
    dispf('??? ERROR unset comp(%s) is used ???\n',Name).

/*****--------------------------------*****/
/*          detect                        */
/*****--------------------------------*****/
hsl_out_ext_det([facility(Name,input,_,1,_,_,_,_)|REST],
                [ID|R_EXT],
                [IID|R_IN],R_OUT,R_BUS):-
    !,
    sdispf('%s',Name,ID),
    sdispf('.%s',Name,IID),
    hsl_out_ext_det(REST,R_EXT,R_IN,R_OUT,R_BUS).
hsl_out_ext_det([facility(Name,input,_,Width,_,_,_,_)|REST],
                [ID|R_EXT],
                [IID|R_IN],R_OUT,R_BUS):-
    !,
    sub1(Width,W),
    sdispf('%s<%d:0>',Name,W,ID),
    sdispf('.%s<%d:0>',Name,W,IID),
    hsl_out_ext_det(REST,R_EXT,R_IN,R_OUT,R_BUS).
hsl_out_ext_det([facility(Name,output,_,1,_,_,_,_)|REST],
                [ID|R_EXT],
                R_IN,[IID|R_OUT],R_BUS):-
    !,
    sdispf('%s',Name,ID),
    sdispf('.%s',Name,IID),
    hsl_out_ext_det(REST,R_EXT,R_IN,R_OUT,R_BUS).
hsl_out_ext_det([facility(Name,output,_,Width,_,_,_,_)|REST],
                [ID|R_EXT],
                R_IN,[IID|R_OUT],R_BUS):-
    !,
    sub1(Width,W),
    sdispf('%s<%d:0>',Name,W,ID),
    sdispf('.%s<%d:0>',Name,W,IID),
    hsl_out_ext_det(REST,R_EXT,R_IN,R_OUT,R_BUS).
hsl_out_ext_det([facility(Name,bidirect,_,1,_,_,_,_)|REST],
                [ID|R_EXT],
                R_IN,R_OUT,[IID|R_BUS]):-
    !,
    sdispf('%s',Name,ID),
    sdispf('.%s',Name,IID),
    hsl_out_ext_det(REST,R_EXT,R_IN,R_OUT,R_BUS).
hsl_out_ext_det([facility(Name,bidirect,_,Width,_,_,_,_)|REST],
                [ID|R_EXT],
                R_IN,R_OUT,[IID|R_BUS]):-
    !,
    sub1(Width,W),
    sdispf('%s<%d:0>',Name,W,ID),
    sdispf('.%s<%d:0>',Name,W,IID),
    hsl_out_ext_det(REST,R_EXT,R_IN,R_OUT,R_BUS).
hsl_out_ext_det([facility(Name,instrin,_,_,_,_,_,_)|REST],
                [ID|R_EXT],
                [IID|R_IN],R_OUT,R_BUS):-
    !,
    sdispf('%s',Name,ID),
    sdispf('.%s',Name,IID),
    hsl_out_ext_det(REST,R_EXT,R_IN,R_OUT,R_BUS).
hsl_out_ext_det([facility(Name,instrout,_,_,_,_,_,_)|REST],
                [ID|R_EXT],
                R_IN,[IID|R_OUT],R_BUS):-
    !,
    sdispf('%s',Name,ID),
    sdispf('.%s',Name,IID),
    hsl_out_ext_det(REST,R_EXT,R_IN,R_OUT,R_BUS).
hsl_out_ext_det([_|REST],
                R_EXT,
                R_IN,R_OUT,R_BUS):-
    !,
    hsl_out_ext_det(REST,R_EXT,R_IN,R_OUT,R_BUS).
hsl_out_ext_det([],
                ['b_clock','m_clock','s_clock','p_reset','scan_in','scan_enb','scan_clock','scan_out'],
                ['.b_clock','.m_clock','.s_clock','.p_reset','.scan_in','.scan_enb','.scan_clock'],['.scan_out'],[]):-
    atom_value_read(test_syn_pass,Pass),
    eq(Pass,2),
    !.
hsl_out_ext_det([],
                ['b_clock','m_clock','s_clock','p_reset'],
                ['.b_clock','.m_clock','.s_clock','.p_reset'],[],[]).
/*****--------------------------------*****/
hsl_out_detect_class([facility(Name,submod,_,Facility,SName,_,_,_)|REST],
                     [class(submod,ID,1,PINS)|REsult],
                     [instance(submod,_,ID,IID,_)|REsult1]):-
    !,
    sdispf('%s',SName,ID),
    sdispf('%s',Name,IID),
    hsl_out_detect_bidirect(Facility,Name,Result,Result1),
    submod_pin_detect(Facility,PINS),
    append(Result,RESULT,REsult),
    append(Result1,RESULT1,REsult1),
    hsl_out_detect_class(REST,RESULT,RESULT1).
hsl_out_detect_class([facility(Name,circuit,_,Facility,CName,_,_,_)|REST],
                     [class(circuit,ID,1,PINS)|REsult],
                     [instance(circuit,_,ID,IID,_)|REsult1]):-
    !,
    sdispf('%s',CName,ID),
    sdispf('%s',Name,IID),
    hsl_out_detect_bidirect(Facility,Name,Result,Result1),
    submod_pin_detect(Facility,PINS),
    append(Result,RESULT,REsult),
    append(Result1,RESULT1,REsult1),
    hsl_out_detect_class(REST,RESULT,RESULT1).
hsl_out_detect_class([facility(Name,bidirect,_,Width,_,_,_,_)|REST],
                     [class(bus_drive,ID,Width,1)|RESULT],
                     [instance(bus_drive,Width,ID,IID,_)|RESULT1]):-
    !,
    sdispf('bdrv-%d',Width,ID),
    sdispf('%s-drive',Name,IID),
    hsl_out_detect_class(REST,RESULT,RESULT1).
hsl_out_detect_class([facility(Name,reg,_,Width,_,_,_,_)|REST],
                     [class(reg,ID,Width,1)|RESULT],
                     [instance(reg,Width,ID,IID,_)|RESULT1]):-
    !,
    sdispf('reg-%d',Width,ID),
    sdispf('%s',Name,IID),
    hsl_out_detect_class(REST,RESULT,RESULT1).

hsl_out_detect_class([facility(Name,reg_wr,_,Width,_,_,_,_)|REST], /* 1990.05.29 */
                     [class(reg_wr,ID,Width,1)|RESULT],            /* 1990.05.29 */
                     [instance(reg_wr,Width,ID,IID,_)|RESULT1]):-  /* 1990.05.29 */
    !,                                                             /* 1990.05.29 */
    sdispf('regr-%d',Width,ID),                                  /* 1990.05.29 */
    sdispf('%s',Name,IID),                                         /* 1990.05.29 */
    hsl_out_detect_class(REST,RESULT,RESULT1).                     /* 1990.05.29 */

hsl_out_detect_class([facility(Name,reg_ws,_,Width,_,_,_,_)|REST], /* 1990.06.18 */
                     [class(reg_ws,ID,Width,1)|RESULT],            /* 1990.06.18 */
                     [instance(reg_ws,Width,ID,IID,_)|RESULT1]):-  /* 1990.06.18 */
    !,                                                             /* 1990.06.18 */
    sdispf('regs-%d',Width,ID),                                  /* 1990.06.18 */
    sdispf('%s',Name,IID),                                         /* 1990.06.18 */
    hsl_out_detect_class(REST,RESULT,RESULT1).                     /* 1990.06.18 */

hsl_out_detect_class([facility(Name,scan_reg,_,Width,_,_,_,_)|REST],
                     [class(scan_reg,ID,Width,1)|RESULT],
                     [instance(scan_reg,Width,ID,IID,_)|RESULT1]):-
    !,
    sdispf('sreg-%d',Width,ID),
    sdispf('%s',Name,IID),
    hsl_out_detect_class(REST,RESULT,RESULT1).
hsl_out_detect_class([facility(Name,scan_reg_wr,_,Width,_,_,_,_)|REST],
                     [class(scan_reg_wr,ID,Width,1)|RESULT],
                     [instance(scan_reg_wr,Width,ID,IID,_)|RESULT1]):-
    !,
    sdispf('srgr-%d',Width,ID),
    sdispf('%s',Name,IID),
    hsl_out_detect_class(REST,RESULT,RESULT1).
hsl_out_detect_class([facility(Name,scan_reg_ws,_,Width,_,_,_,_)|REST],
                     [class(scan_reg_ws,ID,Width,1)|RESULT],
                     [instance(scan_reg_ws,Width,ID,IID,_)|RESULT1]):-
    !,
    sdispf('srgs-%d',Width,ID),
    sdispf('%s',Name,IID),
    hsl_out_detect_class(REST,RESULT,RESULT1).

hsl_out_detect_class([_|REST],
                     RESULT,
                     RESULT1):-
    !,
    hsl_out_detect_class(REST,RESULT,RESULT1).
hsl_out_detect_class([],[],[]).
/*----------------------------------------*/
hsl_out_detect_bidirect([facility(Name,bidirect,_,Width,_,_,_,_)|REST],
                        PName,
                        [class(bus_drive,ID,Width,1)|RESULT],
                        [instance(bus_drive,Width,ID,IID,_)|RESULT1]):-
    !,
    sdispf('bdrv-%d',Width,ID),
    sdispf('%s-%s-drive',PName,Name,IID),
    hsl_out_detect_bidirect(REST,PName,RESULT,RESULT1).
hsl_out_detect_bidirect([_|REST],
                        PName,
                        RESULT,
                        RESULT1):-
    !,
    hsl_out_detect_bidirect(REST,PName,RESULT,RESULT1).
hsl_out_detect_bidirect([],_,[],[]).
/*****--------------------------------*****/
hsl_out_detect_task([facility(Name,stage,_,TASK,_,_,_,_)|REST],
                    [instance(reg,1,ID,IID,_)|REsult]):-
    !,
    atom_value_read(test_syn_pass,Pass),
    if_then_else(
        eq(Pass,2),
        sdispf('sreg---1',ID),
        sdispf('reg---1',ID)
    ),
    sdispf('%s--all',Name,IID),
    hsl_out_detect_task1(TASK,Name,Result),
    append(Result,RESULT,REsult),
    hsl_out_detect_task(REST,RESULT).
hsl_out_detect_task([],[]).
/*----------------------------------------*/
hsl_out_detect_task1([facility(Name,task,_,_,_,_,_,_)|REST],
                     S_Name,
                     [instance(reg,1,ID,IID,_)|RESULT]):-
    !,
    atom_value_read(test_syn_pass,Pass),
    if_then_else(
        eq(Pass,2),
        sdispf('sreg---1',ID),
        sdispf('reg---1',ID)
    ),
    sdispf('%s-%s',S_Name,Name,IID),
    hsl_out_detect_task1(REST,S_Name,RESULT).
hsl_out_detect_task1([],_,[]).
/*****--------------------------------*****/
hsl_out_detect_stage([stg(Name,_,Width,SEG)|REST],
                     Result):-
    !,
    hsl_out_detect_stage_width(Width,Name,STG_INST),
    hsl_out_detect_stage_seg(SEG,Width,Name,SEG_INST),
    append(STG_INST,SEG_INST,INST),
    append(INST,RESULT,Result),
    hsl_out_detect_stage(REST,RESULT).
hsl_out_detect_stage([],[]).
/*----------------------------------------*/
hsl_out_detect_stage_width(0,_,[]):-
    !.
hsl_out_detect_stage_width(I,
                           Name,
                           [instance(reg,1,ID,IID,_)|RESULT]):-
    sub1(I,O),
    atom_value_read(test_syn_pass,Pass),
    if_then_else(
        eq(Pass,2),
        sdispf('sreg--1',ID),
        sdispf('reg--1',ID)
    ),
    sdispf('%s-%d',Name,O,IID),
    hsl_out_detect_stage_width(O,Name,RESULT).
/*----------------------------------------*/
hsl_out_detect_stage_seg([SEG_name|REST],
                         Width,
                         Name,
                         Result):-
    !,
    hsl_out_detect_stage_seg_width(Width,Name,SEG_name,SEG_INST),
    append(SEG_INST,RESULT,Result),
    hsl_out_detect_stage_seg(REST,Width,Name,RESULT).
hsl_out_detect_stage_seg([],_,_,[]).
/*----------------------------------------*/
hsl_out_detect_stage_seg_width(0,_,_,[]):-
    !.
hsl_out_detect_stage_seg_width(I,
                               Name,
                               S_Name,
                               [instance(reg,1,ID,IID,_)|RESULT]):-
    sub1(I,O),
    atom_value_read(test_syn_pass,Pass),
    if_then_else(
        eq(Pass,2),
        sdispf('sreg--1',ID),
        sdispf('reg--1',ID)
    ),
    sdispf('%s-%s-%d',Name,S_Name,O,IID),
    hsl_out_detect_stage_seg_width(O,Name,S_Name,RESULT).
/*****--------------------------------*****/
hsl_out_detect_sels([sel(DST,_,SRC)|REST],
                    RESULT,
                    RESULT1,
                    I,
                    BUS_DUM,
                    INSTR_DUM,
                    SEL_DUM,
                    BUS,
                    SEL,
                    [instance(task_dum,_,_,_,[DST,SRC])|TasK]):-
    eq(DST,pin(task,_,_)),
    !,
    hsl_out_detect_sels(REST,RESULT,RESULT1,I,BUS_DUM,INSTR_DUM,SEL_DUM,BUS,SEL,TasK).
hsl_out_detect_sels([sel(DST,1,SRC)|REST],
                    [class(bus_dum,ID,Width,1)|RESULT],
                    [instance(bus_dum,Width,ID,IID,[_,SRC])|RESULT1],
                    I,
                    [instance(bus_dum,Width,ID,IID,[_,SRC])|BUS_DUM],
                    INSTR_DUM,
                    SEL_DUM,
                    BUS,
                    SEL,
                    TasK):-
    or(                                    /* 1993.03.16 */
        eq(DST,pin(bus_org,Width,Name)),   /* 1993.03.16 */
        eq(DST,pin(sel_org,Width,Name))    /* 1993.03.16 */
    ),                                     /* 1993.03.16 */
    !,
    sdispf('bus-%d',Width,ID),
    sdispf('%s',Name,IID),
    hsl_out_detect_sels(REST,RESULT,RESULT1,I,BUS_DUM,INSTR_DUM,SEL_DUM,BUS,SEL,TasK).
hsl_out_detect_sels([sel(DST,1,SRC)|REST],
                    [class(instr_dum,ID,1,1)|RESULT],
                    [instance(instr_dum,1,ID,IID,[_,SRC])|RESULT1],
                    I,
                    BUS_DUM,
                    [instance(instr_dum,1,ID,IID,[_,SRC])|INSTR_DUM],
                    SEL_DUM,
                    BUS,
                    SEL,
                    TasK):-
    eq(DST,pin(instrself,1,Name)),
    !,
    sdispf('inst-dum',ID),
    sdispf('%s',Name,IID),
    hsl_out_detect_sels(REST,RESULT,RESULT1,I,BUS_DUM,INSTR_DUM,SEL_DUM,BUS,SEL,TasK).
hsl_out_detect_sels([sel(DST,1,SRC)|REST],
                    RESULT,
                    RESULT1,
                    I,
                    BUS_DUM,
                    INSTR_DUM,
                    [instance(sel_dum,Width,_,_,[DST,SRC])|SEL_DUM],
                    BUS,
                    SEL,
                    TasK):-
    !,
    eq(DST,pin(_,Width,_)),
    hsl_out_detect_sels(REST,RESULT,RESULT1,I,BUS_DUM,INSTR_DUM,SEL_DUM,BUS,SEL,TasK).
hsl_out_detect_sels([sel(DST,NUM,SRC)|REST],
                    [class(bus,ID,Width,NUM)|RESULT],
                    [instance(bus,Width,ID,IID,[_,SRC])|RESULT1],
                    I,
                    BUS_DUM,
                    INSTR_DUM,
                    SEL_DUM,
                    [instance(bus,Width,ID,IID,[_,SRC])|BUS],
                    SEL,
                    TasK):-
    eq(DST,pin(bus_org,Width,Name)),
    !,
    sdispf('bs%d-%d',Width,NUM,ID),
    sdispf('%s',Name,IID),
    hsl_out_detect_sels(REST,RESULT,RESULT1,I,BUS_DUM,INSTR_DUM,SEL_DUM,BUS,SEL,TasK).
hsl_out_detect_sels([sel(DST,NUM,SRC)|REST],
                    [class(sel,ID,Width,NUM)|RESULT],
                    [instance(sel,Width,ID,IID,[none,SRC])|RESULT1],
                    I,
                    BUS_DUM,
                    INSTR_DUM,
                    SEL_DUM,
                    BUS,
                    [instance(sel,Width,ID,IID,[none,SRC])|SEL],
                    TasK):-
    eq(DST,pin(sel_org,Width,Name)),
    !,
    sdispf('sl%d-%d',Width,NUM,ID),
    sdispf('%s',Name,IID),
    hsl_out_detect_sels(REST,RESULT,RESULT1,I,BUS_DUM,INSTR_DUM,SEL_DUM,BUS,SEL,TasK).
hsl_out_detect_sels([sel(DST,NUM,SRC)|REST],
                    [class(sel,ID,Width,NUM)|RESULT],
                    [instance(sel,Width,ID,IID,[DST,SRC])|RESULT1],
                    I,
                    BUS_DUM,
                    INSTR_DUM,
                    SEL_DUM,
                    BUS,
                    [instance(sel,Width,ID,IID,[DST,SRC])|SEL],
                    TasK):-
    !,
    eq(DST,pin(_,Width,_)),
    sdispf('sl%d-%d',Width,NUM,ID),
    sdispf('sel-%d',I,IID),
    add1(I,O),
    hsl_out_detect_sels(REST,RESULT,RESULT1,O,BUS_DUM,INSTR_DUM,SEL_DUM,BUS,SEL,TasK).
hsl_out_detect_sels([],[],[],_,[],[],[],[],[],[]).
/*****--------------------------------*****/
hsl_out_detect_nots(
    [A|REST],
    [class(inv,ID,1,1)|RESULT],
    [instance(inv,1,ID,IID,A)|RESULT1],
    I):-
    !,
    sdispf('inv-',ID),
    sdispf('inv-%d',I,IID),
    add1(I,O),
    hsl_out_detect_nots(REST,RESULT,RESULT1,O).
hsl_out_detect_nots([],[],[],_).
/*****--------------------------------*****/
hsl_out_detect_ands(
    [A|REST],
    [class(and,ID,1,NUM)|RESULT],
    [instance(and,1,ID,IID,A)|RESULT1],
    I,Max_Fin):-
    !,
    list_count(A,NUM),
    if_then_else(
        bigger(Max_Fin,1),
        and(
            sdispf('nand--%d',NUM,ID),
            sdispf('nand-%d',I,IID)
        ),
        and(
            sdispf('and--%d',NUM,ID),
            sdispf('and-%d',I,IID)
        )
    ),
    add1(I,O),
    hsl_out_detect_ands(REST,RESULT,RESULT1,O,Max_Fin).
hsl_out_detect_ands([],[],[],_,_).
/*****--------------------------------*****/
hsl_out_detect_ors(
    [A|REST],
    [class(or,ID,1,NUM)|RESULT],
    [instance(or,1,ID,IID,A)|RESULT1],
    I,Max_Fin):-
    !,
    list_count(A,NUM),
    if_then_else(
        bigger(Max_Fin,1),
        and(
            sdispf('nor--%d',NUM,ID),
            sdispf('nor-%d',I,IID)
        ),
        and(
            sdispf('or--%d',NUM,ID),
            sdispf('or-%d',I,IID)
        )
    ),
    add1(I,O),
    hsl_out_detect_ors(REST,RESULT,RESULT1,O,Max_Fin).
hsl_out_detect_ors([],[],[],_,_).

/*****--------------------------------*****/
/*             out                        */
/*****--------------------------------*****/
hsl_out_ext_out([A|B]):-
    !,
    hsl_out_ext_out1(A),
    hsl_out_ext_out2(B).
hsl_out_ext_out([]).
/*----------------------------------------*/
hsl_out_ext_out1(ID):-
    fdispf( '\t%s',ID).
/*----------------------------------------*/
hsl_out_ext_out2([A|B]):-
    !,
    fdispf(',\n'),
    hsl_out_ext_out1(A),
    hsl_out_ext_out2(B).
hsl_out_ext_out2([]).
/*****--------------------------------*****/
hsl_out_cube_submod(             /* interface to other CAD tool */
        [Name|REST],
        M_Name,
        [class(other,O_Name,_,_)|RESULT1],
        [instance(other,_,O_Name,O_Name,_)|RESULT2]
    ):-
    !,
    sdispf('%s-%s',M_Name,Name,O_Name),
    hsl_out_cube_submod(REST,M_Name,RESULT1,RESULT2).
hsl_out_cube_submod([],_,[],[]).
/*****--------------------------------*****/
hsl_out_class([A|B]):-
    !,
    hsl_out_class1(A),
    hsl_out_class2(B).
hsl_out_class([]).
/*----------------------------------------*/
hsl_out_class1(class(_,ID,_,_)):-
    fdispf( '\t%s',ID).
/*----------------------------------------*/
hsl_out_class2([A|B]):-
    !,
    fdispf(',\n'),
    hsl_out_class1(A),
    hsl_out_class2(B).
hsl_out_class2([]).
/*****--------------------------------*****/
hsl_out_instance_eor(X):-
    if_else(
        eq(X,0),
        and(
            fdispf('eor--2:\n'),
            hsl_out_instance_eor1(1,X)
        )
    ).
hsl_out_instance_eor1(X,X):-
    !,
    fdispf('\teor-%d ;\n',X).
hsl_out_instance_eor1(Y,X):-
    !,
    fdispf('\teor-%d,\n',Y),
    add1(Y,Z),
    hsl_out_instance_eor1(Z,X).
/*****--------------------------------*****/
hsl_out_instance([class(_,ID,_,_)|REST],A):-
    !,
    fdispf('%s:\n',ID),
    hsl_out_instance1(ID,A),
    fdispf(' ;\n'),
    hsl_out_instance(REST,A).
hsl_out_instance([],_).
/*----------------------------------------*/
hsl_out_instance1(ID,[instance(_,_,ID,A,_)|B]):-
    !,
    hsl_out_instance2(A),
    hsl_out_instance3(ID,B).
hsl_out_instance1(ID,[_|B]):-
    !,
    hsl_out_instance1(ID,B).
hsl_out_instance1(_,[]).
/*----------------------------------------*/
hsl_out_instance2(IID):-
    fdispf( '\t%s',IID).
/*----------------------------------------*/
hsl_out_instance3(ID,[instance(_,_,ID,A,_)|B]):-
    !,
    fdispf(',\n'),
    hsl_out_instance2(A),
    hsl_out_instance3(ID,B).
hsl_out_instance3(ID,[_|B]):-
    !,
    hsl_out_instance3(ID,B).
hsl_out_instance3(_,[]).

/*****--------------------------------*****/
/*           task set reset               */
/*****--------------------------------*****/
hsl_out_net_task_dum([instance(task_dum,
                              _,
                              _,
                              _,
                              [DST,SRC])
                     |REST]):-
    !,
    hsl_out_net_task_dum1(SRC,CND_set1,CND_reset1),
    hsl_out_net_task_dum2(CND_set1,CND_set),
    hsl_out_net_task_dum2(CND_reset1,CND_reset),
    name_cnd_pin(CND_set,SRC_set),
    name_cnd_pin(CND_reset,SRC_reset),
    name_compo_pin_task(DST,DST_set,DST_reset),
    hsl_out_net_net_src(nolist,1,SRC_set,DST_set),
    hsl_out_net_net_src(nolist,1,SRC_reset,DST_reset),
    hsl_out_net_task_dum(REST).
hsl_out_net_task_dum([]).
/*--------*/
hsl_out_net_task_dum1([src(CND,pin(const,1,1))|REST],[CND|A],B):-
    !,
    hsl_out_net_task_dum1(REST,A,B).
hsl_out_net_task_dum1([src(CND,pin(const,1,0))|REST],A,[CND|B]):-
    !,
    hsl_out_net_task_dum1(REST,A,B).
hsl_out_net_task_dum1([],[],[]).
/*--------*/
hsl_out_net_task_dum2([A|_],A):-!.
hsl_out_net_task_dum2([],pin(const,1,0)).

/*****--------------------------------*****/
/*           dummy bus                    */
/*****--------------------------------*****/
hsl_out_net_bus_dum([instance(bus_dum,
                              Width,
                              _,
                              NAME,
                              [_,[src(_,SRC)]])
                    |REST]):-
    !,
    name_compo_pin_src(SRC,SRC1,PIN_LIST),
    sdispf('%s.in',NAME,DST1),
    if_then_else(
        eq(PIN_LIST,[Pin_list]),
        hsl_out_net_net_src(nolist,Width,Pin_list,DST1),
        hsl_out_net_net_src(PIN_LIST,Width,SRC1,DST1)
    ),
    hsl_out_net_bus_dum(REST).
hsl_out_net_bus_dum([]).
/*****--------------------------------*****/
/*           dummy instrself              */
/*****--------------------------------*****/
hsl_out_net_instr_dum([instance(instr_dum,
                                _,
                                _,
                                NAME,
                                [_,[src(CND,_)]])
                      |REST]):-
    !,
    name_cnd_pin(CND,SRC1),
    sdispf('%s.in',NAME,DST1),
    hsl_out_net_net_src(nolist,1,SRC1,DST1),
    hsl_out_net_instr_dum(REST).
hsl_out_net_instr_dum([]).
/*****--------------------------------*****/
/*           simple path                  */
/*****--------------------------------*****/
hsl_out_net_sel_dum([instance(sel_dum,
                              _,
                              _,
                              _,
                              [DST,[src(CND,_)]])
                    |REST]):-
    name_compo_pin_cnd_dst(DST,DST1),
    !,
    name_cnd_pin(CND,SRC1),
    hsl_out_net_net_src(nolist,1,SRC1,DST1),
    hsl_out_net_sel_dum(REST).
hsl_out_net_sel_dum([instance(sel_dum,
                              Width,
                              _,
                              _,
                              [DST,[src(_,SRC)]])
                    |REST]):-
    name_compo_pin_bus_drive(DST,DST1,SRC2,DST2),
    !,
    name_compo_pin_src(SRC,SRC1,PIN_LIST),
    if_then_else(
        eq(PIN_LIST,[Pin_list]),
        hsl_out_net_net_src(nolist,Width,Pin_list,DST1),
        hsl_out_net_net_src(PIN_LIST,Width,SRC1,DST1)
    ),
    hsl_out_net_net_dst(nolist,Width,SRC2,DST2),
    hsl_out_net_sel_dum(REST).
hsl_out_net_sel_dum([instance(sel_dum,
                              Width,
                              _,
                              _,
                              [DST,[src(_,SRC)]])
                    |REST]):-
    !,
    name_compo_pin_dst(DST,DST1),
    name_compo_pin_src(SRC,SRC1,PIN_LIST),
    if_then_else(
        eq(PIN_LIST,[Pin_list]),
        hsl_out_net_net_src(nolist,Width,Pin_list,DST1),
        hsl_out_net_net_src(PIN_LIST,Width,SRC1,DST1)
    ),
    hsl_out_net_sel_dum(REST).
hsl_out_net_sel_dum([]).
/*****--------------------------------*****/
/*           bus                          */
/*****--------------------------------*****/
hsl_out_net_bus([instance(bus,
                          Width,
                          _,
                          NAME,
                          [_,SRC])
                |REST]):-
    !,
    hsl_out_net_sel1(SRC,NAME,Width,1),
    hsl_out_net_bus(REST).
hsl_out_net_bus([]).
/*****--------------------------------*****/
/*           selecter                     */
/*****--------------------------------*****/
hsl_out_net_sel([instance(sel,
                          Width,
                          _,
                          NAME,
                          [none,SRC])
                |REST]):-
    !,
    hsl_out_net_sel1(SRC,NAME,Width,1),
    hsl_out_net_sel(REST).
hsl_out_net_sel([instance(sel,
                          Width,
                          _,
                          NAME,
                          [DST,SRC])
                |REST]):-
    name_compo_pin_bus_drive(DST,DST1,SRC2,DST2),
    !,
    sdispf('%s.out',NAME,SRC1),
    hsl_out_net_net_src(nolist,Width,SRC1,DST1),
    hsl_out_net_net_dst(nolist,Width,SRC2,DST2),
    hsl_out_net_sel1(SRC,NAME,Width,1),
    hsl_out_net_sel(REST).
hsl_out_net_sel([instance(sel,
                          Width,
                          _,
                          NAME,
                          [DST,SRC])
                |REST]):-
    !,
    name_compo_pin_dst(DST,DST1),
    sdispf('%s.out',NAME,SRC1),
    hsl_out_net_net_src(nolist,Width,SRC1,DST1),
    hsl_out_net_sel1(SRC,NAME,Width,1),
    hsl_out_net_sel(REST).
hsl_out_net_sel([]).
/*****--------------------------------*****/
/*          sel bus input                 */
/*****--------------------------------*****/
hsl_out_net_sel1([src(CND,SRC)|REST],NAME,Width,I):-
    !,
    name_compo_pin_src(SRC,SRC1,PIN_LIST),
    sdispf('%s.in%d',NAME,I,DST1),
    if_then_else(
        eq(PIN_LIST,[Pin_list]),
        hsl_out_net_net_src(nolist,Width,Pin_list,DST1),
        hsl_out_net_net_src(PIN_LIST,Width,SRC1,DST1)
    ),
    name_cnd_pin(CND,SRC2),
    sdispf('%s.sel%d',NAME,I,DST2),
    hsl_out_net_net_src(nolist,1,SRC2,DST2),
    add1(I,O),
    hsl_out_net_sel1(REST,NAME,Width,O).
hsl_out_net_sel1([],_,_,_).

/*****--------------------------------*****/
/*           net net src out              */    /* <net name> = net-<src_name> */
/*****--------------------------------*****/
hsl_out_net_net_src(nolist,Width,SRC,DST):-
    !,
    if_then_else(
        eq(Width,1),
        and(
            sdispf('net-%s',SRC,NET_NAME),
            eq(SRC,SRC_NAME),
            eq(DST,DST_NAME)
        ),
        and(
            sub1(Width,W),
            sdispf('net-%s<%d:0>',SRC,W,NET_NAME),
            sdispf('%s<%d:0>',SRC,W,SRC_NAME),
            sdispf('%s<%d:0>',DST,W,DST_NAME)
        )
    ),
    change_net_name(NET_NAME,CNET_NAME),
    fdispf('%s =\tFROM( %s )\tTO( %s ) ;\n',CNET_NAME,SRC_NAME,DST_NAME).
hsl_out_net_net_src([SRC|REST],Width,_,DST):-
    !,
    sub1(Width,W),
    sdispf('net-%s',SRC,NET_NAME),
    eq(SRC,SRC_NAME),
    sdispf('%s<%d>',DST,W,DST_NAME),
    change_net_name(NET_NAME,CNET_NAME),
    fdispf('%s =\tFROM( %s )\tTO( %s ) ;\n',CNET_NAME,SRC_NAME,DST_NAME),
    hsl_out_net_net_src(REST,W,_,DST).
hsl_out_net_net_src([],_,_,_).

/*****--------------------------------*****/
/*           net net dst out              */    /* <net name> = net-<dst_name> */
/*****--------------------------------*****/
hsl_out_net_net_dst(nolist,Width,SRC,DST):-
    !,
    if_then_else(
        eq(Width,1),
        and(
            sdispf('net-%s',DST,NET_NAME),
            eq(SRC,SRC_NAME),
            eq(DST,DST_NAME)
        ),
        and(
            sub1(Width,W),
            sdispf('net-%s<%d:0>',DST,W,NET_NAME),
            sdispf('%s<%d:0>',SRC,W,SRC_NAME),
            sdispf('%s<%d:0>',DST,W,DST_NAME)
        )
    ),
    change_net_name(NET_NAME,CNET_NAME),
    fdispf('%s =\tFROM( %s )\tTO( %s ) ;\n',CNET_NAME,SRC_NAME,DST_NAME).
hsl_out_net_net_dst([SRC|REST],Width,_,DST):-
    !,
    sub1(Width,W),
    sdispf('net-%s<%d>',DST,W,NET_NAME),
    eq(SRC,SRC_NAME),
    sdispf('%s<%d>',DST,W,DST_NAME),
    change_net_name(NET_NAME,CNET_NAME),
    fdispf('%s =\tFROM( %s )\tTO( %s ) ;\n',CNET_NAME,SRC_NAME,DST_NAME),
    hsl_out_net_net_dst(REST,W,_,DST).
hsl_out_net_net_dst([],_,_,_).

change_net_name(A,B):-cdispf(A,'.','-',B).

/*****--------------------------------*****/
/*              or, and, inv              */
/*****--------------------------------*****/
hsl_out_net_and_or([instance(_,_,_,NAME,CND)|REST]):-
    !,
    hsl_out_net_and_or1(CND,NAME,1),
    hsl_out_net_and_or(REST).
hsl_out_net_and_or([]).
/*----------------------------------------*/
hsl_out_net_and_or1([CND|REST],NAME,I):-
    !,
    name_cnd_pin(CND,SRC1),
    sdispf('%s.in%d',NAME,I,DST1),
    hsl_out_net_net_src(nolist,1,SRC1,DST1),
    add1(I,O),
    hsl_out_net_and_or1(REST,NAME,O).
hsl_out_net_and_or1([],_,_).
/*****--------------------------------*****/
hsl_out_net_not([instance(_,_,_,NAME,CND)|REST]):-
    !,
    name_cnd_pin(CND,SRC1),
    sdispf('%s.in',NAME,DST1),
    hsl_out_net_net_src(nolist,1,SRC1,DST1),
    hsl_out_net_not(REST).
hsl_out_net_not([]).

/*****--------------------------------*****/
/*              reset clock               */
/*****--------------------------------*****/
hsl_out_reset_clock([instance(submod,_,_,NAME,_)|REST]):-
    !,
    atom_value_read(test_syn_pass,Pass),
    if_then_else(
        eq(Pass,2),
        hsl_out_reset_clock2(NAME),
        hsl_out_reset_clock1(NAME)
    ),
    hsl_out_reset_clock3(NAME),
    hsl_out_reset_clock(REST).
hsl_out_reset_clock([instance(circuit,_,_,NAME,_)|REST]):-
    !,
    hsl_out_reset_clock1(NAME),
    hsl_out_reset_clock3(NAME),
    hsl_out_reset_clock(REST).
hsl_out_reset_clock([instance(bus_drive,_,_,NAME,_)|REST]):-
    !,
    hsl_out_reset_clock3(NAME),
    hsl_out_reset_clock(REST).
hsl_out_reset_clock([instance(bus,_,_,NAME,_)|REST]):-
    !,
    hsl_out_reset_clock3(NAME),
    hsl_out_reset_clock(REST).

hsl_out_reset_clock([instance(reg,1,'sreg--1',NAME,_)|REST]):-
    !,
    hsl_out_reset_clock2(NAME),
    hsl_out_reset_clock(REST).

hsl_out_reset_clock([instance(reg,1,'sreg---1',NAME,_)|REST]):-
    !,
    hsl_out_reset_clock2(NAME),
    hsl_out_reset_clock(REST).

hsl_out_reset_clock([instance(reg,_,_,NAME,_)|REST]):-
    !,
    hsl_out_reset_clock1(NAME),
    hsl_out_reset_clock(REST).

hsl_out_reset_clock([instance(reg_wr,_,_,NAME,_)|REST]):- /* 1990.05.29 */
    !,                                                    /* 1990.05.29 */
    hsl_out_reset_clock1(NAME),                           /* 1990.05.29 */
    hsl_out_reset_clock(REST).                            /* 1990.05.29 */

hsl_out_reset_clock([instance(reg_ws,_,_,NAME,_)|REST]):- /* 1990.06.18 */
    !,                                                    /* 1990.06.18 */
    hsl_out_reset_clock1(NAME),                           /* 1990.06.18 */
    hsl_out_reset_clock(REST).                            /* 1990.06.18 */

hsl_out_reset_clock([instance(scan_reg,_,_,NAME,_)|REST]):-
    !,
    hsl_out_reset_clock2(NAME),
    hsl_out_reset_clock(REST).
hsl_out_reset_clock([instance(scan_reg_wr,_,_,NAME,_)|REST]):-
    !,
    hsl_out_reset_clock2(NAME),
    hsl_out_reset_clock(REST).
hsl_out_reset_clock([instance(scan_reg_ws,_,_,NAME,_)|REST]):-
    !,
    hsl_out_reset_clock2(NAME),
    hsl_out_reset_clock(REST).

hsl_out_reset_clock([_|REST]):-
    !,
    hsl_out_reset_clock(REST).
hsl_out_reset_clock([]).
/*----------*/
hsl_out_reset_clock1(NAME):-
    sdispf('%s.m_clock',NAME,DST1),
    hsl_out_net_net_src(nolist,1,'.m_clock',DST1),
    sdispf('%s.s_clock',NAME,DST2),
    hsl_out_net_net_src(nolist,1,'.s_clock',DST2),
    sdispf('%s.p_reset',NAME,DST3),
    hsl_out_net_net_src(nolist,1,'.p_reset',DST3).
hsl_out_reset_clock2(NAME):-
    sdispf('%s.m_clock',NAME,DST1),
    hsl_out_net_net_src(nolist,1,'.m_clock',DST1),
    sdispf('%s.s_clock',NAME,DST2),
    hsl_out_net_net_src(nolist,1,'.s_clock',DST2),
    sdispf('%s.p_reset',NAME,DST3),
    hsl_out_net_net_src(nolist,1,'.p_reset',DST3),
    sdispf('%s.scan_enb',NAME,DST4),
    hsl_out_net_net_src(nolist,1,'.scan_enb',DST4),
    sdispf('%s.scan_clock',NAME,DST5),
    hsl_out_net_net_src(nolist,1,'.scan_clock',DST5).
hsl_out_reset_clock3(NAME):-
    sdispf('%s.b_clock',NAME,DST1),
    hsl_out_net_net_src(nolist,1,'.b_clock',DST1).

/*****--------------------------------*****/
/*            scan path                   */
/*****--------------------------------*****/
hsl_out_scan(INST):-
    atom_value_read(test_syn_pass,Pass),
    eq(Pass,2),
    !,
    hsl_out_scan1(INST,SCAN),
    hsl_out_scan2(SCAN).
hsl_out_scan(_).
/*----------------------------------------*/
hsl_out_scan2([]):-
    !,
    fdispf('net_scan0=FROM(.scan_in) TO(.scan_out);\n').
hsl_out_scan2([NAME]):-
    !,
    fdispf('net_scan0=FROM(.scan_in) TO(%s.scan_in);\n',NAME),
    fdispf('net_scan1=FROM(%s.scan_out) TO(.scan_out);\n',NAME).
hsl_out_scan2([NAME|REST]):-
    fdispf('net_scan0=FROM(.scan_in) TO(%s.scan_in);\n',NAME),
    hsl_out_scan3([NAME|REST],1).
/*----------------------------------------*/
hsl_out_scan3([NAME1,NAME2],NUM):-
    !,
    add1(NUM,Num),
    fdispf('net_scan%d=FROM(%s.scan_out) TO(%s.scan_in);\n',NUM,NAME1,NAME2),
    fdispf('net_scan%d=FROM(%s.scan_out) TO(.scan_out);\n',Num,NAME2).
hsl_out_scan3([NAME1,NAME2|REST],NUM):-
    add1(NUM,Num),
    fdispf('net_scan%d=FROM(%s.scan_out) TO(%s.scan_in);\n',NUM,NAME1,NAME2),
    hsl_out_scan3([NAME2|REST],Num).
/*----------------------------------------*/
hsl_out_scan1([instance(submod,_,_,NAME,_)|REST],[NAME|Result]):-
    !,
    hsl_out_scan1(REST,Result).
hsl_out_scan1([instance(reg,1,'sreg--1',NAME,_)|REST],[NAME|Result]):-
    !,
    hsl_out_scan1(REST,Result).
hsl_out_scan1([instance(reg,1,'sreg---1',NAME,_)|REST],[NAME|Result]):-
    !,
    hsl_out_scan1(REST,Result).
hsl_out_scan1([instance(scan_reg,_,_,NAME,_)|REST],[NAME|Result]):-
    !,
    hsl_out_scan1(REST,Result).
hsl_out_scan1([instance(scan_reg_wr,_,_,NAME,_)|REST],[NAME|Result]):-
    !,
    hsl_out_scan1(REST,Result).
hsl_out_scan1([instance(scan_reg_ws,_,_,NAME,_)|REST],[NAME|Result]):-
    !,
    hsl_out_scan1(REST,Result).
hsl_out_scan1([_|REST],Result):-
    !,
    hsl_out_scan1(REST,Result).
hsl_out_scan1([],[]).

/*****--------------------------------*****/
/*            source pin name             */
/*****--------------------------------*****/
name_compo_pin_src(pin(stage,1,[A,B]),ID,nolist):-
    !,
    sdispf('%s-%d.out',A,B,ID).
name_compo_pin_src(pin(stagen,1,[A,B]),ID,nolist):-
    !,
    sdispf('%s-%d.nout',A,B,ID).
name_compo_pin_src(pin(segment,1,[A,B,C]),ID,nolist):-
    !,
    sdispf('%s-%s-%d.out',B,A,C,ID).
name_compo_pin_src(pin(segmentn,1,[A,B,C]),ID,nolist):-
    !,
    sdispf('%s-%s-%d.nout',B,A,C,ID).
name_compo_pin_src(pin(task,1,[A,B]),ID,nolist):-
    !,
    sdispf('%s-%s.out',B,A,ID).
name_compo_pin_src(pin(taskn,1,[A,B]),ID,nolist):-
    !,
    sdispf('%s-%s.nout',B,A,ID).
name_compo_pin_src(pin(task,1,A),ID,nolist):-
    !,
    sdispf('%s--all.out',A,ID).
name_compo_pin_src(pin(taskn,1,A),ID,nolist):-
    !,
    sdispf('%s--all.nout',A,ID).
name_compo_pin_src(pin(const,1,1),ID,nolist):-
    !,
    sdispf('high-.out',ID).
name_compo_pin_src(pin(const,1,0),ID,nolist):-
    !,
    sdispf('low-.nout',ID).
name_compo_pin_src(pin(const,A,B),const,OUT):-
    !,
    reduction_const(A,B,OUT,[]).
name_compo_pin_src(pin(bus_org,_,A),ID,nolist):-
    !,
    sdispf('%s.out',A,ID).
name_compo_pin_src(pin(sel_org,_,A),ID,nolist):-
    !,
    sdispf('%s.out',A,ID).
name_compo_pin_src(pin(instrself,_,A),ID,nolist):-
    !,
    sdispf('%s.out',A,ID).
name_compo_pin_src(pin(reg,_,A),ID,nolist):-
    !,
    sdispf('%s.out',A,ID).

name_compo_pin_src(pin(reg_wr,_,A),ID,nolist):- /* 1990.05.29 */
    !,                                          /* 1990.05.29 */
    sdispf('%s.out',A,ID).                      /* 1990.05.29 */

name_compo_pin_src(pin(reg_ws,_,A),ID,nolist):- /* 1990.06.18 */
    !,                                          /* 1990.06.18 */
    sdispf('%s.out',A,ID).                      /* 1990.06.18 */

name_compo_pin_src(pin(scan_reg,_,A),ID,nolist):-
    !,
    sdispf('%s.out',A,ID).
name_compo_pin_src(pin(scan_reg_wr,_,A),ID,nolist):-
    !,
    sdispf('%s.out',A,ID).
name_compo_pin_src(pin(scan_reg_ws,_,A),ID,nolist):-
    !,
    sdispf('%s.out',A,ID).

name_compo_pin_src(pin(regn,1,A),ID,nolist):-
    !,
    sdispf('%s.nout',A,ID).

name_compo_pin_src(pin(reg_wrn,1,A),ID,nolist):- /* 1990.05.29 */
    !,                                           /* 1990.05.29 */
    sdispf('%s.nout',A,ID).                      /* 1990.05.29 */

name_compo_pin_src(pin(reg_wsn,1,A),ID,nolist):- /* 1990.06.18 */
    !,                                           /* 1990.06.18 */
    sdispf('%s.nout',A,ID).                      /* 1990.06.18 */

name_compo_pin_src(pin(scan_regn,1,A),ID,nolist):-
    !,
    sdispf('%s.nout',A,ID).
name_compo_pin_src(pin(scan_reg_wrn,1,A),ID,nolist):-
    !,
    sdispf('%s.nout',A,ID).
name_compo_pin_src(pin(scan_reg_wsn,1,A),ID,nolist):-
    !,
    sdispf('%s.nout',A,ID).

name_compo_pin_src(pin(input,_,[A,B]),ID,nolist):-
    !,
    sdispf('%s.%s',B,A,ID).
name_compo_pin_src(pin(output,_,[A,B]),ID,nolist):-
    !,
    sdispf('%s.%s',B,A,ID).
name_compo_pin_src(pin(bidirect,_,[A,B]),ID,nolist):-
    !,
    sdispf('%s.%s',B,A,ID).
name_compo_pin_src(pin(instrin,_,[A,B]),ID,nolist):-
    !,
    sdispf('%s.%s',B,A,ID).
name_compo_pin_src(pin(instrout,_,[A,B]),ID,nolist):-
    !,
    sdispf('%s.%s',B,A,ID).
name_compo_pin_src(pin(input,_,A),ID,nolist):-
    !,
    sdispf('.%s',A,ID).
name_compo_pin_src(pin(output,_,A),ID,nolist):-
    !,
    sdispf('.%s',A,ID).
name_compo_pin_src(pin(bidirect,_,A),ID,nolist):-
    !,
    sdispf('.%s',A,ID).
name_compo_pin_src(pin(instrin,_,A),ID,nolist):-
    !,
    sdispf('.%s',A,ID).
name_compo_pin_src(pin(instrout,_,A),ID,nolist):-
    !,
    sdispf('.%s',A,ID).
name_compo_pin_src(not(NO),ID,nolist):-
    !,
    sdispf('inv-%d.nout',NO,ID).
name_compo_pin_src(pin(substn,1,[P,P,pin(reg,_,A)]),ID,nolist):-
    !,
    sdispf('%s.nout<%d>',A,P,ID).

name_compo_pin_src(pin(substn,1,[P,P,pin(reg_wr,_,A)]),ID,nolist):- /* 1990.05.29 */
    !,                                                              /* 1990.05.29 */
    sdispf('%s.nout<%d>',A,P,ID).                                   /* 1990.05.29 */

name_compo_pin_src(pin(substn,1,[P,P,pin(reg_ws,_,A)]),ID,nolist):- /* 1990.06.18 */
    !,                                                              /* 1990.06.18 */
    sdispf('%s.nout<%d>',A,P,ID).                                   /* 1990.06.18 */

name_compo_pin_src(pin(substn,1,[P,P,pin(scan_reg,_,A)]),ID,nolist):-
    !,
    sdispf('%s.nout<%d>',A,P,ID).
name_compo_pin_src(pin(substn,1,[P,P,pin(scan_reg_wr,_,A)]),ID,nolist):-
    !,
    sdispf('%s.nout<%d>',A,P,ID).
name_compo_pin_src(pin(substn,1,[P,P,pin(scan_reg_ws,_,A)]),ID,nolist):-
    !,
    sdispf('%s.nout<%d>',A,P,ID).

name_compo_pin_src(pin(subst,_,[L,R,P]),subst,OUT):-
    !,
    reduction_subst(L,R,P,OUT).
name_compo_pin_src(or(NO),ID,nolist):-
    !,
    sdispf('or-%d.out',NO,ID).
name_compo_pin_src(nor(NO),ID,nolist):-
    !,
    sdispf('nor-%d.nout',NO,ID).
name_compo_pin_src(and(NO),ID,nolist):-
    !,
    sdispf('and-%d.out',NO,ID).
name_compo_pin_src(nand(NO),ID,nolist):-
    !,
    sdispf('nand-%d.nout',NO,ID).
name_compo_pin_src(pin(cat,_,[A,B]),cat,OUT):-
    !,
    reduction_cat(A,B,OUT,[]).
name_compo_pin_src(pin(eor_out,1,Name),ID,nolist):-
    !,
    sdispf('%s.out',Name,ID).
name_compo_pin_src(A,'***ng***',nolist):-
    dispf('???ERROR! on '),
    display(A),
    dispf(' ???\n\tYou cannot use this for transfer source.\n'),
    atom_value_read(error_flg,X),
    add1(X,Y),
    atom_value_set(error_flg,Y).

/*****--------------------------------*****/
/*          task pin                      */
/*****--------------------------------*****/
name_compo_pin_task(pin(task,_,[A,B]),SET,RESET):-
    !,
    sdispf('%s-%s.set',B,A,SET),
    sdispf('%s-%s.reset',B,A,RESET).
name_compo_pin_task(pin(task,_,A),SET,RESET):-
    sdispf('%s--all.set',A,SET),
    sdispf('%s--all.reset',A,RESET).

/*****--------------------------------*****/
/*          cnd dst pin                   */
/*****--------------------------------*****/
name_compo_pin_cnd_dst(pin(stage_clk,1,[A,B]),ID):-
    !,
    sdispf('%s-%d.clk_enb',A,B,ID).
name_compo_pin_cnd_dst(pin(segment_clk,1,[A,B,C]),ID):-
    !,
    sdispf('%s-%s-%d.clk_enb',B,A,C,ID).
/*
name_compo_pin_cnd_dst(pin(task_clk,1,[A,B]),ID):-
    !,
    sdispf('%s-%s.clk_enb',B,A,ID).
name_compo_pin_cnd_dst(pin(task_clk,1,A),ID):-
    !,
    sdispf('%s--all.clk_enb',A,ID).
*/
name_compo_pin_cnd_dst(pin(reg_clk,1,A),ID):-
    !,
    sdispf('%s.clk_enb',A,ID).
name_compo_pin_cnd_dst(pin(bidirect_enb,1,[A,B]),ID):-
    !,
    sdispf('%s-%s-drive.enb',B,A,ID).
name_compo_pin_cnd_dst(pin(bidirect_enb,1,A),ID):-
    !,
    sdispf('%s-drive.enb',A,ID).
name_compo_pin_cnd_dst(pin(instrin,1,[A,B]),ID):-
    !,
    sdispf('%s.%s',B,A,ID).
name_compo_pin_cnd_dst(pin(instrout,1,A),ID):-
    sdispf('.%s',A,ID).

/*****--------------------------------*****/
/*          bidirect pin                  */
/*****--------------------------------*****/
name_compo_pin_bus_drive(pin(bidirect,_,[A,B]),D_IN,D_OUT,B_PIN):-
    !,
    sdispf('%s-%s-drive.in',B,A,D_IN),
    sdispf('%s-%s-drive.out',B,A,D_OUT),
    sdispf('%s.%s',B,A,B_PIN).
name_compo_pin_bus_drive(pin(bidirect,_,A),D_IN,D_OUT,B_PIN):-
    sdispf('%s-drive.in',A,D_IN),
    sdispf('%s-drive.out',A,D_OUT),
    sdispf('.%s',A,B_PIN).

/*****--------------------------------*****/
/*           condition pin name           */
/*****--------------------------------*****/
name_cnd_pin(PIN,Name):-
    name_compo_pin_src(PIN,Name,nolist),
    !.
name_cnd_pin(PIN,Name):-
    name_compo_pin_src(PIN,_,[Name]).

/*****--------------------------------*****/
/*          destination pin name          */
/*****--------------------------------*****/
name_compo_pin_dst(pin(stage,1,[A,B]),ID):-
    !,
    sdispf('%s-%d.in',A,B,ID).
name_compo_pin_dst(pin(segment,1,[A,B,C]),ID):-
    !,
    sdispf('%s-%s-%d.in',B,A,C,ID).
name_compo_pin_dst(pin(task,1,[A,B]),ID):-
    !,
    sdispf('%s-%s.in',B,A,ID).
name_compo_pin_dst(pin(task,1,A),ID):-
    !,
    sdispf('%s--all.in',A,ID).
name_compo_pin_dst(pin(reg,_,A),ID):-
    !,
    sdispf('%s.in',A,ID).

name_compo_pin_dst(pin(reg_wr,_,A),ID):- /* 1990.05.29 */
    !,                                   /* 1990.05.29 */
    sdispf('%s.in',A,ID).                /* 1990.05.29 */

name_compo_pin_dst(pin(reg_ws,_,A),ID):- /* 1990.06.18 */
    !,                                   /* 1990.06.18 */
    sdispf('%s.in',A,ID).                /* 1990.06.18 */

name_compo_pin_dst(pin(scan_reg,_,A),ID):-
    !,
    sdispf('%s.in',A,ID).
name_compo_pin_dst(pin(scan_reg_wr,_,A),ID):-
    !,
    sdispf('%s.in',A,ID).
name_compo_pin_dst(pin(scan_reg_ws,_,A),ID):-
    !,
    sdispf('%s.in',A,ID).

name_compo_pin_dst(pin(input,_,[A,B]),ID):-
    !,
    sdispf('%s.%s',B,A,ID).
name_compo_pin_dst(pin(output,_,A),ID):-
    !,
    sdispf('.%s',A,ID).
name_compo_pin_dst(pin(eor_in1,1,Name),ID):-
    !,
    sdispf('%s.in1',Name,ID).
name_compo_pin_dst(pin(eor_in2,1,Name),ID):-
    !,
    sdispf('%s.in2',Name,ID).
name_compo_pin_dst(A,'***ng***'):-
    dispf('???ERROR! on '),
    display(A),
    dispf(' ???\n\tYou cannot use this for transfer destination.\n'),
    atom_value_read(error_flg,X),
    add1(X,Y),
    atom_value_set(error_flg,Y).

/*****--------------------------------*****/
/*           reduction                    */
/*****--------------------------------*****/
reduction_const(Width,[CONST|REST],T,B):-
    bigger(Width,16),
    !,
    reduction_const1(16,CONST,M,B),
    minus(Width,16,Width1),
    reduction_const(Width1,REST,T,M).
reduction_const(Width,CONST,T,B):-
    reduction_const1(Width,CONST,T,B).
/*----------------------------------------*/
reduction_const1(0,_,T,T):-
    !.
reduction_const1(Width,CONST,[D|M],B):-
    sub1(Width,Width1),
    exp2(Width1,V),
    if_then_else(
        bigger(V,CONST),
        and(
            eq(D,'low-.nout'),
            eq(CONST,CONST1)
        ),
        and(
            eq(D,'high-.out'),
            minus(CONST,V,CONST1)
        )
    ),
    reduction_const1(Width1,CONST1,M,B).
/*----------------------------------------*/
reduction_subst(Left,Right,PIN,R):-
    bigger(Right,Left),
    !,
    name_compo_pin_src(PIN,Name,LIST),
    eq(PIN,pin(_,Width,_)),
    if_then_else(
        eq(LIST,nolist),
        reduction_subst1(Width,Name,Right,Left,T,[],Width),
        reduction_subst2(Width,LIST,Right,Left,T,[])
    ),
    reverse(T,R).
reduction_subst(Left,Right,PIN,T):-
    name_compo_pin_src(PIN,Name,LIST),
    eq(PIN,pin(_,Width,_)),
    if_then_else(
        eq(LIST,nolist),
        reduction_subst1(Width,Name,Left,Right,T,[],Width),
        reduction_subst2(Width,LIST,Left,Right,T,[])
    ).
/*----------------------------------------*/
reduction_subst1(0,_,_,_,T,T,_):-
    !.
reduction_subst1(Width,Name,Left,Right,T,B,Iwidth):-
    sub1(Width,Width1),
    bigger(Width1,Left),
    !,
    reduction_subst1(Width1,Name,Left,Right,T,B,Iwidth).
reduction_subst1(Width,Name,Left,Right,T,B,Iwidth):-
    sub1(Width,Width1),
    bigger(Right,Width1),
    !,
    reduction_subst1(Width1,Name,Left,Right,T,B,Iwidth).
reduction_subst1(Width,Name,Left,Right,[ID|T],B,Iwidth):-
    sub1(Width,Width1),
    if_then_else(
        eq(Iwidth,1),
        eq(Name,ID),
        sdispf('%s<%d>',Name,Width1,ID)
    ),
    reduction_subst1(Width1,Name,Left,Right,T,B,Iwidth).
/*----------------------------------------*/
reduction_subst2(0,_,_,_,T,T):-
    !.
reduction_subst2(Width,[_|REST],Left,Right,T,B):-
    sub1(Width,Width1),
    bigger(Width1,Left),
    !,
    reduction_subst2(Width1,REST,Left,Right,T,B).
reduction_subst2(Width,[_|REST],Left,Right,T,B):-
    sub1(Width,Width1),
    bigger(Right,Width1),
    !,
    reduction_subst2(Width1,REST,Left,Right,T,B).
reduction_subst2(Width,[PIN|REST],Left,Right,[PIN|T],B):-
    sub1(Width,Width1),
    reduction_subst2(Width1,REST,Left,Right,T,B).
/*----------------------------------------*/
reduction_cat(MSB_PIN,LSB_PIN,T,B):-
    name_compo_pin_src(MSB_PIN,MSB_Name,MSB_LIST),
    name_compo_pin_src(LSB_PIN,LSB_Name,LSB_LIST),
    pin_width(MSB_PIN,MSB_Width),
    pin_width(LSB_PIN,LSB_Width),
    sub1(MSB_Width,MSB_Width1),
    sub1(LSB_Width,LSB_Width1),
    if_then_else(
        eq(MSB_LIST,nolist),
        reduction_subst1(MSB_Width,MSB_Name,MSB_Width1,0,T,M,MSB_Width),
        reduction_subst2(MSB_Width,MSB_LIST,MSB_Width1,0,T,M)
    ),
    if_then_else(
        eq(LSB_LIST,nolist),
        reduction_subst1(LSB_Width,LSB_Name,LSB_Width1,0,M,B,LSB_Width),
        reduction_subst2(LSB_Width,LSB_LIST,LSB_Width1,0,M,B)
    ).
/*----------------*/
pin_width(pin(_,Width,_),Width):-!.
pin_width(_,1).

    /***********/
    /* sel_hie */
    /***********/

sel_hie([CLASS|REST],T,B):-
    !,
    sel_hie1(CLASS,T,M),
    sel_hie(REST,M,B).
sel_hie([],A,A).
/*----------------*/
sel_hie1(class(sel,Name,1,Num),[class(sel,Name,1,Num)|A],A):-
    !.
sel_hie1(class(sel,Name,Width,Num),[class(sel,Name,Width,Num),class(sel,NAME,1,Num)|A],A):-
    !,
    sdispf('sl1-%d',Num,NAME).
sel_hie1(CLASS,[CLASS|A],A).

    /******************/
    /* submod_net_gen */
    /******************/

submod_net_gen(yes,[class(T,I,W,N)|RETAIN],TOP,BTM):-
    !,
    submod_net_gen1(T,I,W,N,TOP,MID),
    submod_net_gen(yes,RETAIN,MID,BTM).
submod_net_gen(no,[class(T,I,W,N)|RETAIN],TOP,BTM):-
    !,
    submod_net_gen2(T,I,W,N,TOP,MID),
    submod_net_gen(no,RETAIN,MID,BTM).
submod_net_gen(_,[],A,A).
/*-------------------*/
/*-------------------*/
submod_net_gen1(reg,_,1,1,T,T):-
    !.

submod_net_gen1(reg_wr,_,1,1,T,T):- /* 1990.05.29 */
    !.                                                  /* 1990.05.29 */

submod_net_gen1(reg_ws,_,1,1,T,T):- /* 1990.06.18 */
    !.                                                  /* 1990.06.18 */

submod_net_gen1(scan_reg,_,1,1,T,T):-
    !.
submod_net_gen1(scan_reg_wr,_,1,1,T,T):-
    !.
submod_net_gen1(scan_reg_ws,_,1,1,T,T):-
    !.

submod_net_gen1(reg,Name,W,1,T,T):-
    !,
    sub1(W,WW),
    fdispf('\nNAME:%s;\n',Name),
    fdispf('PURPOSE:SFL;\n'),
    fdispf('PROCESS:SFL;\n'),
    fdispf('LEVEL:SFL;\n'),
    fdispf('EXT:in<%d:0>,clk_enb,m_clock,s_clock,p_reset,out<%d:0>,nout<%d:0>;\n',WW,WW,WW),
    fdispf('INPUTS:.in<%d:0>,.clk_enb,.m_clock,.s_clock,.p_reset;\n',WW),
    fdispf('OUTPUTS:.out<%d:0>,.nout<%d:0>;\n',WW,WW),
    fdispf('TYPES:reg-1;\n'),
    fdispf('reg-1:'),
    for(0,WW,I,
        fdispf('reg%d,',I)
    ),
    fdispf('reg%d;\n',WW),
    fdispf('END-TYPES ;\n'),
    fdispf('NET-SECTION ;\n'),
    for(0,W,I,
        fdispf('net_in%d=FROM(.in<%d>) TO(reg%d.in);\n',I,I,I)
    ),
    for(0,W,I,
        fdispf('net_out%d=FROM(reg%d.out) TO(.out<%d>);\n',I,I,I)
    ),
    for(0,W,I,
        fdispf('net_nout%d=FROM(reg%d.nout) TO(.nout<%d>);\n',I,I,I)
    ),
    for(0,W,I,
        fdispf('net_m_clock=FROM(.m_clock) TO(reg%d.m_clock);\n',I)
    ),
    for(0,W,I,
        fdispf('net_s_clock=FROM(.s_clock) TO(reg%d.s_clock);\n',I)
    ),
    for(0,W,I,
        fdispf('net_p_reset=FROM(.p_reset) TO(reg%d.p_reset);\n',I)
    ),
    for(0,W,I,
        fdispf('net_clk_enb=FROM(.clk_enb) TO(reg%d.clk_enb);\n',I)
    ),
    fdispf('END-SECTION ;\n'),
    fdispf('END ;\n'),
    dispf('** out one HSL module(%s) **\n',Name).

submod_net_gen1(reg_wr,Name,W,1,T,T):-                          /* 1990.05.29 */
    !,                                                                                       /* 1990.05.29 */
    sub1(W,WW),                                                                              /* 1990.05.29 */
    fdispf('\nNAME:%s;\n',Name),                                                             /* 1990.05.29 */
    fdispf('PURPOSE:SFL;\n'),                                                                /* 1990.05.29 */
    fdispf('PROCESS:SFL;\n'),                                                                /* 1990.05.29 */
    fdispf('LEVEL:SFL;\n'),                                                                  /* 1990.05.29 */
    fdispf('EXT:in<%d:0>,clk_enb,m_clock,s_clock,p_reset,out<%d:0>,nout<%d:0>;\n',WW,WW,WW), /* 1990.05.29 */
    fdispf('INPUTS:.in<%d:0>,.clk_enb,.m_clock,.s_clock,.p_reset;\n',WW),                    /* 1990.05.29 */
    fdispf('OUTPUTS:.out<%d:0>,.nout<%d:0>;\n',WW,WW),                                       /* 1990.05.29 */
    fdispf('TYPES:regr-1;\n'),                                                             /* 1990.05.29 */
    fdispf('regr-1:'),                                                                     /* 1990.05.29 */
    for(0,WW,I,                                                                              /* 1990.05.29 */
        fdispf('reg%d,',I)                                                                   /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    fdispf('reg%d;\n',WW),                                                                   /* 1990.05.29 */
    fdispf('END-TYPES ;\n'),                                                                 /* 1990.05.29 */
    fdispf('NET-SECTION ;\n'),                                                               /* 1990.05.29 */
    for(0,W,I,                                                                               /* 1990.05.29 */
        fdispf('net_in%d=FROM(.in<%d>) TO(reg%d.in);\n',I,I,I)                               /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    for(0,W,I,                                                                               /* 1990.05.29 */
        fdispf('net_out%d=FROM(reg%d.out) TO(.out<%d>);\n',I,I,I)                            /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    for(0,W,I,                                                                               /* 1990.05.29 */
        fdispf('net_nout%d=FROM(reg%d.nout) TO(.nout<%d>);\n',I,I,I)                         /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    for(0,W,I,                                                                               /* 1990.05.29 */
        fdispf('net_m_clock=FROM(.m_clock) TO(reg%d.m_clock);\n',I)                          /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    for(0,W,I,                                                                               /* 1990.05.29 */
        fdispf('net_s_clock=FROM(.s_clock) TO(reg%d.s_clock);\n',I)                          /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    for(0,W,I,                                                                               /* 1990.05.29 */
        fdispf('net_p_reset=FROM(.p_reset) TO(reg%d.p_reset);\n',I)                          /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    for(0,W,I,                                                                               /* 1990.05.29 */
        fdispf('net_clk_enb=FROM(.clk_enb) TO(reg%d.clk_enb);\n',I)                          /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    fdispf('END-SECTION ;\n'),                                                               /* 1990.05.29 */
    fdispf('END ;\n'),                                                                       /* 1990.05.29 */
    dispf('** out one HSL module(%s) **\n',Name).                                            /* 1990.05.29 */

submod_net_gen1(reg_ws,Name,W,1,T,T):-                          /* 1990.06.18 */
    !,                                                                                       /* 1990.06.18 */
    sub1(W,WW),                                                                              /* 1990.06.18 */
    fdispf('\nNAME:%s;\n',Name),                                                             /* 1990.06.18 */
    fdispf('PURPOSE:SFL;\n'),                                                                /* 1990.06.18 */
    fdispf('PROCESS:SFL;\n'),                                                                /* 1990.06.18 */
    fdispf('LEVEL:SFL;\n'),                                                                  /* 1990.06.18 */
    fdispf('EXT:in<%d:0>,clk_enb,m_clock,s_clock,p_reset,out<%d:0>,nout<%d:0>;\n',WW,WW,WW), /* 1990.06.18 */
    fdispf('INPUTS:.in<%d:0>,.clk_enb,.m_clock,.s_clock,.p_reset;\n',WW),                    /* 1990.06.18 */
    fdispf('OUTPUTS:.out<%d:0>,.nout<%d:0>;\n',WW,WW),                                       /* 1990.06.18 */
    fdispf('TYPES:regs-1;\n'),                                                             /* 1990.06.18 */
    fdispf('regs-1:'),                                                                     /* 1990.06.18 */
    for(0,WW,I,                                                                              /* 1990.06.18 */
        fdispf('reg%d,',I)                                                                   /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    fdispf('reg%d;\n',WW),                                                                   /* 1990.06.18 */
    fdispf('END-TYPES ;\n'),                                                                 /* 1990.06.18 */
    fdispf('NET-SECTION ;\n'),                                                               /* 1990.06.18 */
    for(0,W,I,                                                                               /* 1990.06.18 */
        fdispf('net_in%d=FROM(.in<%d>) TO(reg%d.in);\n',I,I,I)                               /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    for(0,W,I,                                                                               /* 1990.06.18 */
        fdispf('net_out%d=FROM(reg%d.out) TO(.out<%d>);\n',I,I,I)                            /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    for(0,W,I,                                                                               /* 1990.06.18 */
        fdispf('net_nout%d=FROM(reg%d.nout) TO(.nout<%d>);\n',I,I,I)                         /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    for(0,W,I,                                                                               /* 1990.06.18 */
        fdispf('net_m_clock=FROM(.m_clock) TO(reg%d.m_clock);\n',I)                          /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    for(0,W,I,                                                                               /* 1990.06.18 */
        fdispf('net_s_clock=FROM(.s_clock) TO(reg%d.s_clock);\n',I)                          /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    for(0,W,I,                                                                               /* 1990.06.18 */
        fdispf('net_p_reset=FROM(.p_reset) TO(reg%d.p_reset);\n',I)                          /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    for(0,W,I,                                                                               /* 1990.06.18 */
        fdispf('net_clk_enb=FROM(.clk_enb) TO(reg%d.clk_enb);\n',I)                          /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    fdispf('END-SECTION ;\n'),                                                               /* 1990.06.18 */
    fdispf('END ;\n'),                                                                       /* 1990.06.18 */
    dispf('** out one HSL module(%s) **\n',Name).                                            /* 1990.06.18 */

submod_net_gen1(scan_reg,Name,W,1,T,T):-
    !,
    sub1(W,WW),
    fdispf('\nNAME:%s;\n',Name),
    fdispf('PURPOSE:SFL;\n'),
    fdispf('PROCESS:SFL;\n'),
    fdispf('LEVEL:SFL;\n'),
    fdispf('EXT:in<%d:0>,scan_in,clk_enb,scan_enb,m_clock,s_clock,scan_clock,p_reset,out<%d:0>,scan_out,nout<%d:0>;\n',WW,WW,WW),
    fdispf('INPUTS:.in<%d:0>,.scan_in,.clk_enb,.scan_enb,.m_clock,.s_clock,.scan_clock,.p_reset;\n',WW),
    fdispf('OUTPUTS:.out<%d:0>,.scan_out,.nout<%d:0>;\n',WW,WW),
    fdispf('TYPES:sreg-1;\n'),
    fdispf('sreg-1:'),
    for(0,WW,I,
        fdispf('reg%d,',I)
    ),
    fdispf('reg%d;\n',WW),
    fdispf('END-TYPES ;\n'),
    fdispf('NET-SECTION ;\n'),
    for(0,W,I,
        fdispf('net_in%d=FROM(.in<%d>) TO(reg%d.in);\n',I,I,I)
    ),
    for(0,W,I,
        fdispf('net_out%d=FROM(reg%d.out) TO(.out<%d>);\n',I,I,I)
    ),
    for(0,W,I,
        fdispf('net_nout%d=FROM(reg%d.nout) TO(.nout<%d>);\n',I,I,I)
    ),
    for(0,W,I,
        fdispf('net_m_clock=FROM(.m_clock) TO(reg%d.m_clock);\n',I)
    ),
    for(0,W,I,
        fdispf('net_s_clock=FROM(.s_clock) TO(reg%d.s_clock);\n',I)
    ),
    for(0,W,I,
        fdispf('net_scan_clock=FROM(.scan_clock) TO(reg%d.scan_clock);\n',I)
    ),
    for(0,W,I,
        fdispf('net_p_reset=FROM(.p_reset) TO(reg%d.p_reset);\n',I)
    ),
    for(0,W,I,
        fdispf('net_clk_enb=FROM(.clk_enb) TO(reg%d.clk_enb);\n',I)
    ),
    for(0,W,I,
        fdispf('net_scan_enb=FROM(.scan_enb) TO(reg%d.scan_enb);\n',I)
    ),
    fdispf('net_scan0=FROM(.scan_in) TO(reg0.scan_in);\n'),
    for(1,W,I,
        and(
            sub1(I,II),
            fdispf('net_scan%d=FROM(reg%d.scan_out) TO(reg%d.scan_in);\n',I,II,I)
        )
    ),
    fdispf('net_scan%d=FROM(reg%d.scan_out) TO(.scan_out);\n',W,WW),
    fdispf('END-SECTION ;\n'),
    fdispf('END ;\n'),
    dispf('** out one HSL module(%s) **\n',Name).

submod_net_gen1(scan_reg_wr,Name,W,1,T,T):-                          /* 1990.05.29 */
    !,                                                                                       /* 1990.05.29 */
    sub1(W,WW),                                                                              /* 1990.05.29 */
    fdispf('\nNAME:%s;\n',Name),                                                             /* 1990.05.29 */
    fdispf('PURPOSE:SFL;\n'),                                                                /* 1990.05.29 */
    fdispf('PROCESS:SFL;\n'),                                                                /* 1990.05.29 */
    fdispf('LEVEL:SFL;\n'),                                                                  /* 1990.05.29 */
    fdispf('EXT:in<%d:0>,scan_in,clk_enb,scan_enb,m_clock,s_clock,scan_clock,p_reset,out<%d:0>,scan_out,nout<%d:0>;\n',WW,WW,WW), /* 1990.05.29 */
    fdispf('INPUTS:.in<%d:0>,.scan_in,.clk_enb,.scan_enb,.m_clock,.s_clock,.scan_clock,.p_reset;\n',WW),                    /* 1990.05.29 */
    fdispf('OUTPUTS:.out<%d:0>,.scan_out,.nout<%d:0>;\n',WW,WW),                                       /* 1990.05.29 */
    fdispf('TYPES:srgr-1;\n'),                                                             /* 1990.05.29 */
    fdispf('srgr-1:'),                                                                     /* 1990.05.29 */
    for(0,WW,I,                                                                              /* 1990.05.29 */
        fdispf('reg%d,',I)                                                                   /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    fdispf('reg%d;\n',WW),                                                                   /* 1990.05.29 */
    fdispf('END-TYPES ;\n'),                                                                 /* 1990.05.29 */
    fdispf('NET-SECTION ;\n'),                                                               /* 1990.05.29 */
    for(0,W,I,                                                                               /* 1990.05.29 */
        fdispf('net_in%d=FROM(.in<%d>) TO(reg%d.in);\n',I,I,I)                               /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    for(0,W,I,                                                                               /* 1990.05.29 */
        fdispf('net_out%d=FROM(reg%d.out) TO(.out<%d>);\n',I,I,I)                            /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    for(0,W,I,                                                                               /* 1990.05.29 */
        fdispf('net_nout%d=FROM(reg%d.nout) TO(.nout<%d>);\n',I,I,I)                         /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    for(0,W,I,                                                                               /* 1990.05.29 */
        fdispf('net_m_clock=FROM(.m_clock) TO(reg%d.m_clock);\n',I)                          /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    for(0,W,I,                                                                               /* 1990.05.29 */
        fdispf('net_s_clock=FROM(.s_clock) TO(reg%d.s_clock);\n',I)                          /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    for(0,W,I,                                                                               /* 1990.05.29 */
        fdispf('net_scan_clock=FROM(.scan_clock) TO(reg%d.scan_clock);\n',I)                          /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    for(0,W,I,                                                                               /* 1990.05.29 */
        fdispf('net_p_reset=FROM(.p_reset) TO(reg%d.p_reset);\n',I)                          /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    for(0,W,I,                                                                               /* 1990.05.29 */
        fdispf('net_clk_enb=FROM(.clk_enb) TO(reg%d.clk_enb);\n',I)                          /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    for(0,W,I,                                                                               /* 1990.05.29 */
        fdispf('net_scan_enb=FROM(.scan_enb) TO(reg%d.scan_enb);\n',I)                          /* 1990.05.29 */
    ),                                                                                       /* 1990.05.29 */
    fdispf('net_scan0=FROM(.scan_in) TO(reg0.scan_in);\n'),
    for(1,W,I,
        and(
            sub1(I,II),
            fdispf('net_scan%d=FROM(reg%d.scan_out) TO(reg%d.scan_in);\n',I,II,I)
        )
    ),
    fdispf('net_scan%d=FROM(reg%d.scan_out) TO(.scan_out);\n',W,WW),
    fdispf('END-SECTION ;\n'),                                                               /* 1990.05.29 */
    fdispf('END ;\n'),                                                                       /* 1990.05.29 */
    dispf('** out one HSL module(%s) **\n',Name).                                            /* 1990.05.29 */

submod_net_gen1(scan_reg_ws,Name,W,1,T,T):-                          /* 1990.06.18 */
    !,                                                                                       /* 1990.06.18 */
    sub1(W,WW),                                                                              /* 1990.06.18 */
    fdispf('\nNAME:%s;\n',Name),                                                             /* 1990.06.18 */
    fdispf('PURPOSE:SFL;\n'),                                                                /* 1990.06.18 */
    fdispf('PROCESS:SFL;\n'),                                                                /* 1990.06.18 */
    fdispf('LEVEL:SFL;\n'),                                                                  /* 1990.06.18 */
    fdispf('EXT:in<%d:0>,scan_in,clk_enb,scan_enb,m_clock,s_clock,scan_clock,p_reset,out<%d:0>,scan_out,nout<%d:0>;\n',WW,WW,WW), /* 1990.06.18 */
    fdispf('INPUTS:.in<%d:0>,.scan_in,.clk_enb,.scan_enb,.m_clock,.s_clock,.scan_clock,.p_reset;\n',WW),                    /* 1990.06.18 */
    fdispf('OUTPUTS:.out<%d:0>,.scan_out,.nout<%d:0>;\n',WW,WW),                                       /* 1990.06.18 */
    fdispf('TYPES:srgs-1;\n'),                                                             /* 1990.06.18 */
    fdispf('srgs-1:'),                                                                     /* 1990.06.18 */
    for(0,WW,I,                                                                              /* 1990.06.18 */
        fdispf('reg%d,',I)                                                                   /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    fdispf('reg%d;\n',WW),                                                                   /* 1990.06.18 */
    fdispf('END-TYPES ;\n'),                                                                 /* 1990.06.18 */
    fdispf('NET-SECTION ;\n'),                                                               /* 1990.06.18 */
    for(0,W,I,                                                                               /* 1990.06.18 */
        fdispf('net_in%d=FROM(.in<%d>) TO(reg%d.in);\n',I,I,I)                               /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    for(0,W,I,                                                                               /* 1990.06.18 */
        fdispf('net_out%d=FROM(reg%d.out) TO(.out<%d>);\n',I,I,I)                            /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    for(0,W,I,                                                                               /* 1990.06.18 */
        fdispf('net_nout%d=FROM(reg%d.nout) TO(.nout<%d>);\n',I,I,I)                         /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    for(0,W,I,                                                                               /* 1990.06.18 */
        fdispf('net_m_clock=FROM(.m_clock) TO(reg%d.m_clock);\n',I)                          /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    for(0,W,I,                                                                               /* 1990.06.18 */
        fdispf('net_s_clock=FROM(.s_clock) TO(reg%d.s_clock);\n',I)                          /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    for(0,W,I,                                                                               /* 1990.06.18 */
        fdispf('net_scan_clock=FROM(.scan_clock) TO(reg%d.scan_clock);\n',I)                          /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    for(0,W,I,                                                                               /* 1990.06.18 */
        fdispf('net_p_reset=FROM(.p_reset) TO(reg%d.p_reset);\n',I)                          /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    for(0,W,I,                                                                               /* 1990.06.18 */
        fdispf('net_clk_enb=FROM(.clk_enb) TO(reg%d.clk_enb);\n',I)                          /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    for(0,W,I,                                                                               /* 1990.06.18 */
        fdispf('net_scan_enb=FROM(.scan_enb) TO(reg%d.scan_enb);\n',I)                          /* 1990.06.18 */
    ),                                                                                       /* 1990.06.18 */
    fdispf('net_scan0=FROM(.scan_in) TO(reg0.scan_in);\n'),
    for(1,W,I,
        and(
            sub1(I,II),
            fdispf('net_scan%d=FROM(reg%d.scan_out) TO(reg%d.scan_in);\n',I,II,I)
        )
    ),
    fdispf('net_scan%d=FROM(reg%d.scan_out) TO(.scan_out);\n',W,WW),
    fdispf('END-SECTION ;\n'),                                                               /* 1990.06.18 */
    fdispf('END ;\n'),                                                                       /* 1990.06.18 */
    dispf('** out one HSL module(%s) **\n',Name).                                            /* 1990.06.18 */

submod_net_gen1(bus_drive,Name,1,1,T,T):-
    !,
    fdispf('\nNAME:bdrv-1;\n'),
    fdispf('PURPOSE:SFL;\n'),
    fdispf('PROCESS:SFL;\n'),
    fdispf('LEVEL:SFL;\n'),
    fdispf('EXT:in,enb,b_clock,out;\n'),
    fdispf('INPUTS:.in,.enb,.b_clock;\n'),
    fdispf('BUS:.out;\n'),
    fdispf('TYPES:ts_buf-,bgate--2;\n'),
    fdispf('ts_buf-:'),
    fdispf('bus_drive;\n'),
    fdispf('bgate--2:gate;\n'),
    fdispf('END-TYPES;\n'),
    fdispf('NET-SECTION;\n'),
    fdispf('net_in=FROM(.in) TO(bus_drive.in);\n'),
    fdispf('net_out=FROM(bus_drive.out) TO(.out);\n'),
    fdispf('net_cnt=FROM(gate.nout) TO(bus_drive.nenb);\n'),
    fdispf('net_enb=FROM(.enb) TO(gate.enb);\n'),
    fdispf('net_b_clock=FROM(.b_clock) TO(gate.clock);\n'),
    fdispf('END-SECTION;\n'),
    fdispf('END;\n'),
    dispf('** out one HSL module(%s) **\n',Name).
submod_net_gen1(bus_drive,Name,W,1,T,T):-
    !,
    sub1(W,WW),
    fdispf('\nNAME:%s;\n',Name),
    fdispf('PURPOSE:SFL;\n'),
    fdispf('PROCESS:SFL;\n'),
    fdispf('LEVEL:SFL;\n'),
    fdispf('EXT:in<%d:0>,enb,b_clock,out<%d:0>;\n',WW,WW),
    fdispf('INPUTS:.in<%d:0>,.enb,.b_clock;\n',WW),
    fdispf('BUS:.out<%d:0>;\n',WW),
    fdispf('TYPES:ts_buf-,bgate--2;\n'),
    fdispf('ts_buf-:'),
    for(0,WW,I,
        fdispf('bus_drive%d,',I)
    ),
    fdispf('bus_drive%d;\n',WW),
    fdispf('bgate--2:gate;\n'),
    fdispf('END-TYPES;\n'),
    fdispf('NET-SECTION;\n'),
    for(0,W,I,
        fdispf('net_in%d=FROM(.in<%d>) TO(bus_drive%d.in);\n',I,I,I)
    ),
    for(0,W,I,
        fdispf('net_out%d=FROM(bus_drive%d.out) TO(.out<%d>);\n',I,I,I)
    ),
    for(0,W,I,
        fdispf('net_cnt=FROM(gate.nout) TO(bus_drive%d.nenb);\n',I)
    ),
    fdispf('net_enb=FROM(.enb) TO(gate.enb);\n'),
    fdispf('net_b_clock=FROM(.b_clock) TO(gate.clock);\n'),
    fdispf('END-SECTION;\n'),
    fdispf('END;\n'),
    dispf('** out one HSL module(%s) **\n',Name).
submod_net_gen1(instr_dum,Name,1,1,T,T):-
    !,
    fdispf('\nNAME:%s;\n',Name),
    fdispf('PURPOSE:SFL;\n'),
    fdispf('PROCESS:SFL;\n'),
    fdispf('LEVEL:SFL;\n'),
    fdispf('EXT:in,out;\n'),
    fdispf('INPUTS:.in;\n'),
    fdispf('OUTPUTS:.out;\n'),
    fdispf('NET-SECTION ;\n'),
    fdispf('net=FROM(.in) TO(.out);\n'),
    fdispf('END-SECTION ;\n'),
    fdispf('END ;\n'),
    dispf('** out one HSL module(%s) **\n',Name).
submod_net_gen1(bus,Name,1,N,T,T):-
    !,
    fdispf('\nNAME:%s;\n',Name),
    fdispf('PURPOSE:SFL;\n'),
    fdispf('PROCESS:SFL;\n'),
    fdispf('LEVEL:SFL;\n'),
    fdispf('EXT:\n    b_clock,\n    out,\n'),
    fore(1,N,I,
        fdispf('    in%d,\n',I)
    ),
    for(1,N,I,
        fdispf('    sel%d,\n',I)
    ),
    fdispf('    sel%d;\n',N),
    fdispf('INPUTS:\n    .b_clock,\n'),
    fore(1,N,I,
        fdispf('    .in%d,\n',I)
    ),
    for(1,N,I,
        fdispf('    .sel%d,\n',I)
    ),
    fdispf('    .sel%d;\n',N),
    fdispf('BUS:\n    .out;\n'),
    fdispf('TYPES:ts_buf-,bgate--2;\n'),
    fdispf('ts_buf-:\n'),
    for(1,N,I,
        fdispf('    bus_drive%d,\n',I)
    ),
    fdispf('    bus_drive%d;\n',N),
    fdispf('bgate--2:\n'),
    for(1,N,I,
        fdispf('    gate%d,\n',I)
    ),
    fdispf('    gate%d;\n',N),
    fdispf('END-TYPES ;\n'),
    fdispf('NET-SECTION ;\n'),
    fdispf('\n'),
    fore(1,N,I,
        fdispf('net_in%d=FROM(.in%d) TO(bus_drive%d.in);\n',I,I,I)
    ),
    fdispf('\n'),
    fore(1,N,I,
        fdispf('net_out=FROM(bus_drive%d.out) TO(.out);\n',I)
    ),
    fdispf('\n'),
    fore(1,N,I,
        fdispf('net_cnt%d=FROM(gate%d.nout) TO(bus_drive%d.nenb);\n',I,I,I)
    ),
    fdispf('\n'),
    fore(1,N,I,
        fdispf('net_sel%d=FROM(.sel%d) TO(gate%d.enb);\n',I,I,I)
    ),
    fdispf('\n'),
    fore(1,N,I,
        fdispf('net_b_clock=FROM(.b_clock) TO(gate%d.clock);\n',I)
    ),
    fdispf('\n'),
    fdispf('END-SECTION ;\n'),
    fdispf('END ;\n'),
    dispf('** out one HSL module(%s) **\n',Name).
submod_net_gen1(bus,Name,W,N,T,T):-
    !,
    sub1(W,WW),
    fdispf('\nNAME:%s;\n',Name),
    fdispf('PURPOSE:SFL;\n'),
    fdispf('PROCESS:SFL;\n'),
    fdispf('LEVEL:SFL;\n'),
    fdispf('EXT:\n    b_clock,\n    out<%d:0>,\n',WW),
    fore(1,N,I,
        fdispf('    in%d<%d:0>,\n',I,WW)
    ),
    for(1,N,I,
        fdispf('    sel%d,\n',I)
    ),
    fdispf('    sel%d;\n',N),
    fdispf('INPUTS:\n    .b_clock,\n'),
    fore(1,N,I,
        fdispf('    .in%d<%d:0>,\n',I,WW)
    ),
    for(1,N,I,
        fdispf('    .sel%d,\n',I)
    ),
    fdispf('    .sel%d;\n',N),
    fdispf('BUS:\n    .out<%d:0>;\n',WW),
    fdispf('TYPES:ts_buf-,bgate--2;\n'),
    fdispf('ts_buf-:\n'),
    for(1,N,I,
        for(0,W,J,
            fdispf('    bdrv-%d-%d,\n',I,J)
        )
    ),
    for(0,WW,J,
        fdispf('    bdrv-%d-%d,\n',N,J)
    ),
    fdispf('    bdrv-%d-%d;\n',N,WW),
    fdispf('bgate--2:\n'),
    for(1,N,I,
        fdispf('    gate%d,\n',I)
    ),
    fdispf('    gate%d;\n',N),
    fdispf('END-TYPES ;\n'),
    fdispf('NET-SECTION ;\n'),
    fdispf('\n'),
    fore(1,N,I,
        for(0,W,J,
            fdispf('net_in-%d-%d=FROM(.in%d<%d>) TO(bdrv-%d-%d.in);\n',I,J,I,J,I,J)
        )
    ),
    fdispf('\n'),
    fore(1,N,I,
        for(0,W,J,
            fdispf('net_out-%d=FROM(bdrv-%d-%d.out) TO(.out<%d>);\n',J,I,J,J)
        )
    ),
    fdispf('\n'),
    fore(1,N,I,
        for(0,W,J,
            fdispf('net_cnt-%d=FROM(gate%d.nout) TO(bdrv-%d-%d.nenb);\n',I,I,I,J)
        )
    ),
    fdispf('\n'),
    fore(1,N,I,
        fdispf('net_sel-%d=FROM(.sel%d) TO(gate%d.enb);\n',I,I,I)
    ),
    fdispf('\n'),
    fore(1,N,I,
        fdispf('net_b_clock=FROM(.b_clock) TO(gate%d.clock);\n',I)
    ),
    fdispf('\n'),
    fdispf('END-SECTION ;\n'),
    fdispf('END ;\n'),
    dispf('** out one HSL module(%s) **\n',Name).
submod_net_gen1(bus_dum,Name,1,1,T,T):-
    !,
    fdispf('\nNAME:%s;\n',Name),
    fdispf('PURPOSE:SFL;\n'),
    fdispf('PROCESS:SFL;\n'),
    fdispf('LEVEL:SFL;\n'),
    fdispf('EXT:in,out;\n'),
    fdispf('INPUTS:.in;\n'),
    fdispf('OUTPUTS:.out;\n'),
    fdispf('NET-SECTION ;\n'),
    fdispf('net=FROM(.in) TO(.out);\n'),
    fdispf('END-SECTION ;\n'),
    fdispf('END ;\n'),
    dispf('** out one HSL module(%s) **\n',Name).
submod_net_gen1(bus_dum,Name,W,1,T,T):-
    !,
    sub1(W,WW),
    fdispf('\nNAME:%s;\n',Name),
    fdispf('PURPOSE:SFL;\n'),
    fdispf('PROCESS:SFL;\n'),
    fdispf('LEVEL:SFL;\n'),
    fdispf('EXT:in<%d:0>,out<%d:0>;\n',WW,WW),
    fdispf('INPUTS:.in<%d:0>;\n',WW),
    fdispf('OUTPUTS:.out<%d:0>;\n',WW),
    fdispf('NET-SECTION ;\n'),
    fdispf('net<%d:0>=FROM(.in<%d:0>) TO(.out<%d:0>);\n',WW,WW,WW),
    fdispf('END-SECTION ;\n'),
    fdispf('END ;\n'),
    dispf('** out one HSL module(%s) **\n',Name).
submod_net_gen1(sel,Name,1,Way,T,T):-
    atom_value_read(multi_level_opt,M_OPT),
    atom_value_read(change_to_nand_nor,Max_Fin),
    eq(M_OPT,yes),
    bigger(Max_Fin,1),
    !,
    sel_make(Name,1,Way,_,_,Max_Fin).
submod_net_gen1(sel,Name,1,N,T,T):-
    !,
    fdispf('\nNAME:%s;\n',Name),
    fdispf('PURPOSE:SFL;\n'),
    fdispf('PROCESS:SFL;\n'),
    fdispf('LEVEL:SFL;\n'),
    fdispf('EXT:out,'),
    fore(1,N,I,
        fdispf('in%d,',I)
    ),
    for(1,N,I,
        fdispf('sel%d,',I)
    ),
    fdispf('sel%d;\n',N),
    fdispf('INPUTS:'),
    fore(1,N,I,
        fdispf('.in%d,',I)
    ),
    for(1,N,I,
        fdispf('.sel%d,',I)
    ),
    fdispf('.sel%d;\n',N),
    fdispf('OUTPUTS:.out;\n'),
    fdispf('TYPES:and--2,or--%d;\n',N),
    fdispf('and--2:'),
    for(1,N,I,
        fdispf('and-%d,',I)
    ),
    fdispf('and-%d;\n',N),
    fdispf('or--%d:',N),
    fdispf('or-0;\n'),
    fdispf('END-TYPES ;\n'),
    fdispf('NET-SECTION ;\n'),
    fore(1,N,I,
        fdispf('net_in%d=FROM(.in%d) TO(and-%d.in1);\n',I,I,I)
    ),
    fore(1,N,I,
        fdispf('net_sel%d=FROM(.sel%d) TO(and-%d.in2);\n',I,I,I)
    ),
    fore(1,N,I,
        fdispf('net_mid%d=FROM(and-%d.out) TO(or-0.in%d);\n',I,I,I)
    ),
    fdispf('net_out=FROM(or-0.out) TO(.out);\n'),
    fdispf('END-SECTION ;\n'),
    fdispf('END ;\n'),
    dispf('** out one HSL module(%s) **\n',Name).
submod_net_gen1(sel,Name,W,N,T,T):-
    atom_value_read(sel_type,Sel_type),
    eq(Sel_type,hie),
    !,
    sub1(W,WW),
    fdispf('\nNAME:%s;\n',Name),
    fdispf('PURPOSE:SFL;\n'),
    fdispf('PROCESS:SFL;\n'),
    fdispf('LEVEL:SFL;\n'),
    fdispf('EXT:out<%d:0>,',WW),
    fore(1,N,I,
        fdispf('in%d<%d:0>,',I,WW)
    ),
    for(1,N,I,
        fdispf('sel%d,',I)
    ),
    fdispf('sel%d;\n',N),
    fdispf('INPUTS:'),
    fore(1,N,I,
        fdispf('.in%d<%d:0>,',I,WW)
    ),
    for(1,N,I,
        fdispf('.sel%d,',I)
    ),
    fdispf('.sel%d;\n',N),
    fdispf('OUTPUTS:.out<%d:0>;\n',WW),
    fdispf('TYPES:sl1-%d;\n',N),
    fdispf('sl1-%d:',N),
    for(0,WW,J,
        fdispf('sel-%d,',J)
    ),
    fdispf('sel-%d;\n',WW),
    fdispf('END-TYPES ;\n'),
    fdispf('NET-SECTION ;\n'),
    fore(1,N,I,
        for(0,W,J,
            fdispf('net_in-%d-%d=FROM(.in%d<%d>) TO(sel-%d.in%d);\n',I,J,I,J,J,I)
        )
    ),
    fore(1,N,I,
        for(0,W,J,
            fdispf('net_sel-%d=FROM(.sel%d) TO(sel-%d.sel%d);\n',I,I,J,I)
        )
    ),
    for(0,W,J,
        fdispf('net_out-%d=FROM(sel-%d.out) TO(.out<%d>);\n',J,J,J)
    ),
    fdispf('END-SECTION ;\n'),
    fdispf('END ;\n'),
    dispf('** out one HSL module(%s) **\n',Name).
submod_net_gen1(sel,Name,Width,Way,T,T):-
    atom_value_read(multi_level_opt,M_OPT),
    atom_value_read(change_to_nand_nor,Max_Fin),
    eq(M_OPT,yes),
    bigger(Max_Fin,1),
    !,
    sel_make(Name,Width,Way,_,_,Max_Fin).
submod_net_gen1(sel,Name,W,N,T,T):-
    !,
    sub1(W,WW),
    fdispf('\nNAME:%s;\n',Name),
    fdispf('PURPOSE:SFL;\n'),
    fdispf('PROCESS:SFL;\n'),
    fdispf('LEVEL:SFL;\n'),
    fdispf('EXT:out<%d:0>,',WW),
    fore(1,N,I,
        fdispf('in%d<%d:0>,',I,WW)
    ),
    for(1,N,I,
        fdispf('sel%d,',I)
    ),
    fdispf('sel%d;\n',N),
    fdispf('INPUTS:'),
    fore(1,N,I,
        fdispf('.in%d<%d:0>,',I,WW)
    ),
    for(1,N,I,
        fdispf('.sel%d,',I)
    ),
    fdispf('.sel%d;\n',N),
    fdispf('OUTPUTS:.out<%d:0>;\n',WW),
    fdispf('TYPES:and--2,or--%d;\n',N),
    fdispf('and--2:'),
    for(1,N,I,
        for(0,W,J,
            fdispf('and-%d-%d,',I,J)
        )
    ),
    for(0,WW,J,
        fdispf('and-%d-%d,',N,J)
    ),
    fdispf('and-%d-%d;\n',N,WW),
    fdispf('or--%d:',N),
    for(0,WW,J,
        fdispf('or-%d,',J)
    ),
    fdispf('or-%d;\n',WW),
    fdispf('END-TYPES ;\n'),
    fdispf('NET-SECTION ;\n'),
    fore(1,N,I,
        for(0,W,J,
            fdispf('net_in-%d-%d=FROM(.in%d<%d>) TO(and-%d-%d.in1);\n',I,J,I,J,I,J)
        )
    ),
    fore(1,N,I,
        for(0,W,J,
            fdispf('net_sel-%d=FROM(.sel%d) TO(and-%d-%d.in2);\n',I,I,I,J)
        )
    ),
    fore(1,N,I,
        for(0,W,J,
            fdispf('net_mid-%d-%d=FROM(and-%d-%d.out) TO(or-%d.in%d);\n',I,J,I,J,J,I)
        )
    ),
    for(0,W,J,
        fdispf('net_out-%d=FROM(or-%d.out) TO(.out<%d>);\n',J,J,J)
    ),
    fdispf('END-SECTION ;\n'),
    fdispf('END ;\n'),
    dispf('** out one HSL module(%s) **\n',Name).
submod_net_gen1(inv,_,_,_,T,T):-!.
submod_net_gen1(and,_,_,_,T,T):-!.
submod_net_gen1(or,_,_,_,T,T):-!.
submod_net_gen1(submod,_,_,_,T,T):-!.
submod_net_gen1(circuit,Name,_,PINS,[pcd(Name,circuit(Name,PINS))|T],T):-
    atom_value_read(circuit_pcd_out_mode,Circuit_pcd_out_mode),
    eq(Circuit_pcd_out_mode,yes),
    !.
submod_net_gen1(circuit,_,_,_,T,T):-!.
submod_net_gen1(_,_,_,_,T,T):-dispf('internal ERROR in net_gen\n').
/*-------------------*/
/*-------------------*/
submod_net_gen2(circuit,Name,_,PINS,[pcd(Name,circuit(Name,PINS))|T],T):-
    atom_value_read(circuit_pcd_out_mode,Circuit_pcd_out_mode),
    eq(Circuit_pcd_out_mode,yes),
    !.
submod_net_gen2(_,_,_,_,T,T).
/*-------------------*/
/*-------------------*/
submod_pin_detect([facility(Name,input,_,Width,_,_,_,_)|REST1],[pin(Name,input,Width)|REST2]):-
    !,
    submod_pin_detect(REST1,REST2).
submod_pin_detect([facility(Name,output,_,Width,_,_,_,_)|REST1],[pin(Name,output,Width)|REST2]):-
    !,
    submod_pin_detect(REST1,REST2).
submod_pin_detect([facility(Name,bidirect,_,Width,_,_,_,_)|REST1],[pin(Name,bidirect,Width)|REST2]):-
    !,
    submod_pin_detect(REST1,REST2).
submod_pin_detect([facility(Name,instrin,_,_,_,_,_,_)|REST1],[pin(Name,instrin,1)|REST2]):-
    !,
    submod_pin_detect(REST1,REST2).
submod_pin_detect([facility(Name,instrout,_,_,_,_,_,_)|REST1],[pin(Name,instrout,1)|REST2]):-
    !,
    submod_pin_detect(REST1,REST2).
submod_pin_detect([],[]).

    /************/
    /* sel make */
    /************/

sel_make(Name,1,Way,PCD_out,PCD_in,Max_Fin):-
    !,
    fdispf('\nNAME:%s;\n',Name),
    fdispf('PURPOSE:SFL;\n'),
    fdispf('PROCESS:SFL;\n'),
    fdispf('LEVEL:SFL;\n'),
    /*-- ext --*/
    fdispf('EXT:\n    out,\n'),
    fore(1,Way,I,
        fdispf('    in%d,\n',I)
    ),
    for(1,Way,I,
        fdispf('    sel%d,\n',I)
    ),
    fdispf('    sel%d;\n',Way),
    /*-- inputs --*/
    fdispf('INPUTS:\n'),
    fore(1,Way,I,
        fdispf('    .in%d,\n',I)
    ),
    for(1,Way,I,
        fdispf('    .sel%d,\n',I)
    ),
    fdispf('    .sel%d;\n',Way),
    /*-- outputs --*/
    fdispf('OUTPUTS:\n    .out;\n'),
    /*-- body --*/
    sel_make_nand_in(Way,Nand_In),
    sel_make_neg_tree(Nand_In,Tree,Max_Fin),
    sel_make_trace1(Tree,1,_,Str_List,[]),
    sel_make_cut_str(Str_List,List),
    sort(List,S_List,[]),
    sel_make_classify(S_List,'????','???',_,C_List),
    /*-- types --*/
    fdispf('TYPES:\n'),
    sel_make_class(C_List,PCD),
    sel_make_class_instance(C_List),
    fdispf('END-TYPES;\n'),
    /*-- net --*/
    fdispf('NET-SECTION;\n'),
    sel_make_top_net(Tree),
    sel_make_net(List),
    fdispf('END-SECTION;\n'),
    fdispf('END;\n'),
    dispf('** out one HSL module(%s) **\n',Name),
    append(PCD,PCD_in,PCD_out).

sel_make(Name,Width,Way,PCD_out,PCD_in,Max_Fin):-
    sub1(Width,WWidth),
    fdispf('\nNAME:%s;\n',Name),
    fdispf('PURPOSE:SFL;\n'),
    fdispf('PROCESS:SFL;\n'),
    fdispf('LEVEL:SFL;\n'),
    /*-- ext --*/
    fdispf('EXT:\n    out<%d:0>,\n',WWidth),
    fore(1,Way,I,
        fdispf('    in%d<%d:0>,\n',I,WWidth)
    ),
    for(1,Way,I,
        fdispf('    sel%d,\n',I)
    ),
    fdispf('    sel%d;\n',Way),
    /*-- inputs --*/
    fdispf('INPUTS:\n'),
    fore(1,Way,I,
        fdispf('    .in%d<%d:0>,\n',I,WWidth)
    ),
    for(1,Way,I,
        fdispf('    .sel%d,\n',I)
    ),
    fdispf('    .sel%d;\n',Way),
    /*-- outputs --*/
    fdispf('OUTPUTS:\n    .out<%d:0>;\n',WWidth),
    /*-- body --*/
    sel_make_nand_in_list(Way,Nand_In,Width),
    sel_make_neg_tree_list(Nand_In,Tree,Max_Fin),
    sel_make_trace1_list(Tree,1,Str_List),
    sel_make_cut_str_list(Str_List,List),
    flat(List,F_List),
    sort(F_List,S_List,[]),
    sel_make_classify(S_List,'????','???',_,C_List),
    /*-- types --*/
    fdispf('TYPES:\n'),
    sel_make_class(C_List,PCD),
    sel_make_class_instance(C_List),
    fdispf('END-TYPES;\n'),
    /*-- net --*/
    fdispf('NET-SECTION;\n'),
    sel_make_top_net_list(Tree,Width),
    sel_make_net_list(List),
    fdispf('END-SECTION;\n'),
    fdispf('END;\n'),
    dispf('** out one HSL module(%s) **\n',Name),
    append(PCD,PCD_in,PCD_out).

/*------------------*/
/*--nand in---------*/
/*------------------*/
sel_make_nand_in_list(_,[],0):-!.
sel_make_nand_in_list(Way,[Nand_In|RESULT],Width):-
    sub1(Width,WWidth),
    sel_make_nand_in_w(Way,Nand_In,WWidth),
    sel_make_nand_in_list(Way,RESULT,WWidth).
/*------------------*/
sel_make_nand_in_w(0,[],_):-!.
sel_make_nand_in_w(Way,[comp(nand,Num,Id,[Data,Sel])|Result],WWidth):-
    sdispf('.in%d<%d>',Way,WWidth,Data),
    sdispf('.sel%d',Way,Sel),
    sub1(Way,Next),
    sel_make_nand_in_w(Next,Result,WWidth).
/*------------------*/
sel_make_nand_in(0,[]):-!.
sel_make_nand_in(Way,[comp(nand,Num,Id,[Data,Sel])|Result]):-
    sdispf('.in%d',Way,Data),
    sdispf('.sel%d',Way,Sel),
    sub1(Way,Next),
    sel_make_nand_in(Next,Result).

/*------------------*/
/*--tree------------*/
/*------------------*/
sel_make_neg_tree_list([Nand_In|REST],[Tree|RESULT],Max_Fin):-
    !,
    sel_make_neg_tree(Nand_In,Tree,Max_Fin),
    sel_make_neg_tree_list(REST,RESULT,Max_Fin).
sel_make_neg_tree_list([],[],_).
/*------------------*/
sel_make_neg_tree(Fin1,Fin3,Max):-
    list_count(Fin1,Num1),
    bigger(Num1,Max),
    !,
    sel_make_nand_list(Max,0,Fin1,[],Fin2),
    list_count(Fin2,Num2),
    if_then_else(
        bigger(Num2,Max),
        sel_make_pos_tree(Fin2,Fin3,Max),
        eq(Fin3,comp(inv,1,Inv_Id,comp(nor,Num,Nor_Id,Fin2)))
    ).
sel_make_neg_tree(Fin1,Fin3,_):-
    eq(Fin3,comp(nand,Num,Id,Fin1)).
/*------------------*/
sel_make_pos_tree(Fin1,Fin3,Max):-
    sel_make_nor_list(Max,0,Fin1,[],Fin2),
    list_count(Fin2,Num2),
    if_then_else(
        bigger(Num2,Max),
        sel_make_neg_tree(Fin2,Fin3,Max),
        eq(Fin3,comp(nand,Num,Id,Fin2))
    ).
/*------------------*/
sel_make_nand_list(_,_,[],Fin,[COMP]):-
    !,
    sel_make_nand(Fin,COMP).
sel_make_nand_list(Max,Max,REST,Fin,[COMP|RESULT]):-
    !,
    sel_make_nand(Fin,COMP),
    sel_make_nand_list(Max,0,REST,[],RESULT).
sel_make_nand_list(Max,Now,[Fin|REST],FIN,RESULT):-
    add1(Now,Next),
    sel_make_nand_list(Max,Next,REST,[Fin|FIN],RESULT).
/*------------------*/
sel_make_nor_list(_,_,[],Fin,[COMP]):-
    !,
    sel_make_nor(Fin,COMP).
sel_make_nor_list(Max,Max,REST,Fin,[COMP|RESULT]):-
    !,
    sel_make_nor(Fin,COMP),
    sel_make_nor_list(Max,0,REST,[],RESULT).
sel_make_nor_list(Max,Now,[Fin|REST],FIN,RESULT):-
    add1(Now,Next),
    sel_make_nor_list(Max,Next,REST,[Fin|FIN],RESULT).
/*------------------*/
sel_make_nand([comp(inv,_,_,Fin)],Fin):-
    !.
sel_make_nand([Fin],comp(inv,1,Id,Fin)):-
    !.
sel_make_nand(Fin,comp(nand,Num,Id,Fin)).
/*------------------*/
sel_make_nor([comp(inv,_,_,Fin)],Fin):-
    !.
sel_make_nor([Fin],comp(inv,1,Id,Fin)):-
    !.
sel_make_nor(Fin,comp(nor,Num,ID,Fin)).

/*------------------*/
/*--trace-----------*/
/*------------------*/
sel_make_trace([Tree|REST],Id1,Id3,Top,Btm):-
    !,
    sel_make_trace1(Tree,Id1,Id2,Top,Mid),
    sel_make_trace(REST,Id2,Id3,Mid,Btm).
sel_make_trace([],Id,Id,T,T).
/*------------------*/
sel_make_trace1_list([Tree|REST],Id1,[Str_List|RESULT]):-
    !,
    sel_make_trace1(Tree,Id1,Id2,Str_List,[]),
    sel_make_trace1_list(REST,Id2,RESULT).
sel_make_trace1_list([],_,[]).
/*------------------*/
sel_make_trace1(comp(inv,1,Id1,Fin),Id1,Id3,[comp(inv,1,Id1,Fin)|Mid],Btm):-
    !,
    add1(Id1,Id2),
    sel_make_trace1(Fin,Id2,Id3,Mid,Btm).
sel_make_trace1(comp(Type,Num,Id1,Fin),Id1,Id3,[comp(Type,Num,Id1,Fin)|Mid],Btm):-
    !,
    list_count(Fin,Num),
    add1(Id1,Id2),
    sel_make_trace(Fin,Id2,Id3,Mid,Btm).
sel_make_trace1(_,Id,Id,T,T).

/*------------------*/
/*--cut str---------*/
/*------------------*/
sel_make_cut_str_list([Str_List|REST],[List|RESULT]):-
    !,
    sel_make_cut_str(Str_List,List),
    sel_make_cut_str_list(REST,RESULT).
sel_make_cut_str_list([],[]).
/*------------------*/
sel_make_cut_str([comp(inv,1,Id,Fin1)|REST],[comp(inv,1,Id,Fin2)|RESULT]):-
    !,
    sel_make_name(Fin1,Fin2),
    sel_make_cut_str(REST,RESULT).
sel_make_cut_str([comp(Type,Num,Id,Fin1)|REST],[comp(Type,Num,Id,Fin2)|RESULT]):-
    !,
    sel_make_cut_str1(Fin1,Fin2),
    sel_make_cut_str(REST,RESULT).
sel_make_cut_str([],[]).
/*------------------*/
sel_make_cut_str1([A|REST],[B|RESULT]):-
    !,
    sel_make_name(A,B),
    sel_make_cut_str1(REST,RESULT).
sel_make_cut_str1([],[]).

/*------------------*/
/*--name------------*/
/*------------------*/
sel_make_name(comp(Type,_,Id,_),Name):-
    !,
    sdispf('%s-%d.nout',Type,Id,Name).
sel_make_name(A,A).

/*------------------*/
/*--classify--------*/
/*------------------*/
sel_make_classify([ELM|REST],Type,Fin,[ELM|RT1],RT2):-
    eq(ELM,comp(Type,Fin,_,_)),
    !,
    sel_make_classify(REST,Type,Fin,RT1,RT2).
sel_make_classify([ELM|REST],_,_,[],[RT1|RT2]):-
    !,
    eq(ELM,comp(Type,Fin,_,_)),
    sel_make_classify([ELM|REST],Type,Fin,RT1,RT2).
sel_make_classify([],_,_,[],[]).

/*------------------*/
/*--class-----------*/
/*------------------*/
sel_make_class([[comp(inv,_,_,_)|_]],[pcd('inv-',inv)]):-
    !,
    fdispf('    inv-;\n').
sel_make_class([[comp(nand,Num,_,_)|_]],[pcd(C_Name,nand(Num))]):-
    !,
    sdispf('nand--%d',Num,C_Name),
    fdispf('    %s;\n',C_Name).
sel_make_class([[comp(nor,Num,_,_)|_]],[pcd(C_Name,nor(Num))]):-
    !,
    sdispf('nor--%d',Num,C_Name),
    fdispf('    %s;\n',C_Name).
sel_make_class([[comp(inv,_,_,_)|_]|REST],[pcd('inv-',inv)|RESULT]):-
    !,
    fdispf('    inv-,\n'),
    sel_make_class(REST,RESULT).
sel_make_class([[comp(nand,Num,_,_)|_]|REST],[pcd(C_Name,nand(Num))|RESULT]):-
    !,
    sdispf('nand--%d',Num,C_Name),
    fdispf('    %s,\n',C_Name),
    sel_make_class(REST,RESULT).
sel_make_class([[comp(nor,Num,_,_)|_]|REST],[pcd(C_Name,nor(Num))|RESULT]):-
    !,
    sdispf('nor--%d',Num,C_Name),
    fdispf('    %s,\n',C_Name),
    sel_make_class(REST,RESULT).
sel_make_class([],[]).

/*------------------*/
/*--class instance--*/
/*------------------*/
sel_make_class_instance([List|REST]):-
    eq(List,[comp(inv,1,_,_)|_]),
    !,
    fdispf('inv-:\n'),
    sel_make_class_instance1(List),
    sel_make_class_instance(REST).
sel_make_class_instance([List|REST]):-
    !,
    eq(List,[comp(Type,Num,_,_)|_]),
    fdispf('%s--%d:\n',Type,Num),
    sel_make_class_instance1(List),
    sel_make_class_instance(REST).
sel_make_class_instance([]).
/*------------------*/
sel_make_class_instance1([comp(Type,_,Id,_)]):-
    !,
    fdispf('    %s-%d;\n',Type,Id).
sel_make_class_instance1([comp(Type,_,Id,_)|REST]):-
    !,
    fdispf('    %s-%d,\n',Type,Id),
    sel_make_class_instance1(REST).
sel_make_class_instance1([]).

/*------------------*/
/*--top net---------*/
/*------------------*/
sel_make_top_net_list([Tree|REST],Width):-
    !,
    sub1(Width,WWidth),
    sel_make_top_net_w(Tree,WWidth),
    sel_make_top_net_list(REST,WWidth).
sel_make_top_net_list([],_).
/*------------------*/
sel_make_top_net_w(Tree,WWidth):-
    sel_make_name(Tree,Out_Name),
    sdispf('net-%s',Out_Name,Net_Name),
    change_net_name(Net_Name,NC_Name),
    fdispf('%s = FROM(%s) TO(.out<%d>);\n',NC_Name,Out_Name,WWidth).
/*------------------*/
sel_make_top_net(Tree):-
    sel_make_name(Tree,Out_Name),
    sdispf('net-%s',Out_Name,Net_Name),
    change_net_name(Net_Name,NC_Name),
    fdispf('%s = FROM(%s) TO(.out);\n',NC_Name,Out_Name).

/*------------------*/
/*--net-------------*/
/*------------------*/
sel_make_net_list([List|REST]):-
    !,
    sel_make_net(List),
    sel_make_net_list(REST).
sel_make_net_list([]).
/*------------------*/
sel_make_net([Net|REST]):-
    !,
    sel_make_net1(Net),
    sel_make_net(REST).
sel_make_net([]).
/*------------------*/
sel_make_net1(comp(inv,_,Id,Fin)):-
    !,
    sdispf('net-%s',Fin,Net_Name),
    change_net_name(Net_Name,NC_Name),
    fdispf('%s = FROM(%s) TO(inv-%d.in);\n',NC_Name,Fin,Id).
sel_make_net1(comp(Type,_,Id,Fin)):-
    sel_make_net2(Fin,1,Type,Id).
/*------------------*/
sel_make_net2([Fin|REST],In,Type,Id):-
    !,
    sdispf('net-%s',Fin,Net_Name),
    change_net_name(Net_Name,NC_Name),
    fdispf('%s = FROM(%s) TO(%s-%d.in%d);\n',NC_Name,Fin,Type,Id,In),
    add1(In,Out),
    sel_make_net2(REST,Out,Type,Id).
sel_make_net2([],_,_,_).

    /******************/
    /* submod_pcd_gen */
    /******************/

submod_pcd_gen([pcd(Name,PCD)|REST]):-
    !,
    sdispf('%s.pcd',Name,P_FILE),
    see(P_FILE),
    submod_pcd_gen1(PCD),
    seen,
    dispf('** %s written **\n',P_FILE),
    submod_pcd_gen(REST).
submod_pcd_gen([]).
/*-------------------*/
submod_pcd_gen1(inv):-
    !,
    fdispf('(def-module inv- power 2800 area 737 gates 1\n\n'),
    fdispf('\t(def-pin in   type input  load 0.09)\n'),
    fdispf('\t(def-pin nout type output load 0.08)\n\n'),
    fdispf('\t(def-function ^nout in)\n\n'),
    fdispf('\t(def-delay /in /nout (+ 0.4 (* 3600 ~nout)))\n'),
    fdispf('\t(def-delay %%in %%nout (+ 0.4 (* 3600 ~nout)))\n\n'),
    fdispf('\t(def-constraint drive (- 0 ~nout) type max)\n'),
    fdispf(')\n').
submod_pcd_gen1(and(N)):-
    !,
    divide(N,2,HN),
    plus(1,HN,GATES),
    multiply(N,1383,N1383),
    plus(5134,N1383,POWER),
    multiply(N,307,N307),
    plus(861,N307,AREA),
    fdispf('(def-module and--%d power %d area %d gates %d\n\n',N,POWER,AREA,GATES),
    fore(1,N,I,
        fdispf('\t(def-pin in%d type input load 0.09)\n',I)
    ),
    fdispf('\t(def-pin out type output load 0.07)\n\n'),
    fdispf('\t(def-function out (and\n'),
    fore(1,N,I,
        fdispf('\t\tin%d\n',I)
    ),
    fdispf('\t))\n\n'),
    fore(1,N,I,
        fdispf('\t(def-delay /in%d /out (+ 1.3 (* 4600 ~out)))\n',I)
    ),
    fore(1,N,I,
        fdispf('\t(def-delay %%in%d %%out (+ 1.3 (* 4600 ~out)))\n',I)
    ),
    fdispf('\n\t(def-constraint drive (- 0 ~out) type max)\n'),
    fdispf(')\n').
submod_pcd_gen1(nand(N)):- /* nand */
    !,
    sub1(N,SN),
    divide(SN,2,HN),
    plus(1,HN,GATES),
    multiply(N,1333,N1333),
    plus(1334,N1333,POWER),
    multiply(N,369,N369),
    plus(368,N369,AREA),
    fdispf('(def-module nand--%d power %d area %d gates %d\n\n',N,POWER,AREA,GATES),
    fore(1,N,I,
        fdispf('\t(def-pin in%d type input load 0.10)\n',I)
    ),
    fdispf('\t(def-pin nout type output load 0.09)\n'),
    fdispf('\n\t(def-function ^nout (and\n'),
    fore(1,N,I,
        fdispf('\t\tin%d\n',I)
    ),
    fdispf('\t))\n\n'),
    fore(1,N,I,
        fdispf('\t(def-delay /in%d /nout (+ 0.5 (* 4100 ~nout)))\n',I)
    ),
    fore(1,N,I,
        fdispf('\t(def-delay %%in%d %%nout (+ 0.5 (* 4100 ~nout)))\n',I)
    ),
    fdispf('\n\t(def-constraint drive (- 0 ~nout) type max)\n'),
    fdispf(')\n').
submod_pcd_gen1(or(N)):-
    !,
    divide(N,2,HN),
    plus(1,HN,GATES),
    multiply(N,1700,N1700),
    plus(4000,N1700,POWER),
    multiply(N,307,N307),
    plus(861,N307,AREA),
    fdispf('(def-module or--%d power %d area %d gates %d\n\n',N,POWER,AREA,GATES),
    fore(1,N,I,
        fdispf('\t(def-pin in%d type input load 0.06)\n',I)
    ),
    fdispf('\t(def-pin out type output load 0.07)\n'),
    fdispf('\n\t(def-function out (or\n'),
    fore(1,N,I,
        fdispf('\t\tin%d\n',I)
    ),
    fdispf('\t))\n\n'),
    fore(1,N,I,
        fdispf('\t(def-delay /in%d /out (+ 2.0 (* 4400 ~out)))\n',I)
    ),
    fore(1,N,I,
        fdispf('\t(def-delay %%in%d %%out (+ 2.0 (* 4400 ~out)))\n',I)
    ),
    fdispf('\n\t(def-constraint drive (- 0 ~out) type max)\n'),
    fdispf(')\n').
submod_pcd_gen1(nor(N)):-  /* nor */
    !,
    sub1(N,SN),
    divide(SN,2,HN),
    plus(1,HN,GATES),
    multiply(N,1367,N1367),
    plus(1666,N1367,POWER),
    multiply(N,369,N369),
    plus(368,N369,AREA),
    fdispf('(def-module nor--%d power %d area %d gates %d\n\n',N,POWER,AREA,GATES),
    fore(1,N,I,
        fdispf('\t(def-pin in%d type input load 0.08)\n',I)
    ),
    fdispf('\t(def-pin nout type output load 0.08)\n'),

    fdispf('\n\t(def-function ^nout (or\n'),
    fore(1,N,I,
        fdispf('\t\tin%d\n',I)
    ),
    fdispf('\t))\n\n'),
    fore(1,N,I,
        fdispf('\t(def-delay /in%d /nout (+ 1.0 (* 7100 ~nout)))\n',I)
    ),
    fore(1,N,I,
        fdispf('\t(def-delay %%in%d %%nout (+ 1.0 (* 7100 ~nout)))\n',I)
    ),
    fdispf('\n\t(def-constraint drive (- 0 ~nout) type max)\n'),
    fdispf(')\n').
submod_pcd_gen1('reg-1'):-
    !,
    fdispf('(def-module reg-1 power 25600 area 8110 gates 11\n\n'),
    fdispf('    (def-pin in      type input  load 0.05)\n'),
    fdispf('    (def-pin clk_enb type input  load 0.08)\n'),
    fdispf('    (def-pin m_clock type input  load 0.09 note clock)\n'),
    fdispf('    (def-pin s_clock type input)\n'),
    fdispf('    (def-pin p_reset type input  load 0.08)\n'),
    fdispf('    (def-pin out     type output load 0.14)\n'),
    fdispf('    (def-pin nout    type output load 0.08)\n\n'),
    fdispf('    (def-function out   (reg-1 ^m_clock ^s_clock ^p_reset clk_enb in))\n'),
    fdispf('    (def-function ^nout (reg-1 ^m_clock ^s_clock ^p_reset clk_enb in))\n\n'),
    fdispf('    (def-delay /m_clock /out  (+ 5.3 (* 3800 ~out)))\n'),
    fdispf('    (def-delay /m_clock /nout  (+ 6.7 (* 3700 ~nout)))\n\n'),
    fdispf('\t(def-constraint setup_in (- (+ /m_clock ?cycle) /in 3.4) type setup)\n'),
    fdispf('\t(def-constraint setup_enb (- (+ /m_clock ?cycle) /clk_enb 3.4) type setup)\n'),
    fdispf('\t(def-constraint hold_in1 (- /in /m_clock) type hold)\n'),
    fdispf('\t(def-constraint hold_enb1 (- /clk_enb /m_clock) type hold)\n'),
    fdispf('\t(def-constraint hold_in2 (- %%in (+ /m_clock ?cycle)) type hold)\n'),
    fdispf('\t(def-constraint hold_enb2 (- %%clk_enb (+ /m_clock ?cycle)) type hold)\n'),
    fdispf('\t(def-constraint freq (- ?cycle 12.255))\n'),
    fdispf('\t(def-constraint drive (- 0 ~out) type max)\n'),
    fdispf('\t(def-constraint drive (- 0 ~nout) type max)\n'),
    fdispf(')\n').

submod_pcd_gen1('regr-1'):-                                                                 /* 1990.05.29 */
    !,                                                                                        /* 1990.05.29 */
    fdispf('(def-module regr-1 power 25600 area 8110 gates 11\n\n'),                        /* 1990.05.29 */
    fdispf('    (def-pin in      type input  load 0.05)\n'),                                  /* 1990.05.29 */
    fdispf('    (def-pin clk_enb type input  load 0.08)\n'),                                  /* 1990.05.29 */
    fdispf('    (def-pin m_clock type input  load 0.09 note clock)\n'),                       /* 1990.05.29 */
    fdispf('    (def-pin s_clock type input)\n'),                                             /* 1990.05.29 */
    fdispf('    (def-pin p_reset type input  load 0.08)\n'),                                  /* 1990.05.29 */
    fdispf('    (def-pin out     type output load 0.14)\n'),                                  /* 1990.05.29 */
    fdispf('    (def-pin nout    type output load 0.08)\n\n'),                                /* 1990.05.29 */
    fdispf('    (def-function out   (regr-1 ^m_clock ^s_clock ^p_reset clk_enb in))\n'),    /* 1990.05.29 */
    fdispf('    (def-function ^nout (regr-1 ^m_clock ^s_clock ^p_reset clk_enb in))\n\n'),  /* 1990.05.29 */
    fdispf('    (def-delay /m_clock /out  (+ 5.3 (* 3800 ~out)))\n'),                         /* 1990.05.29 */
    fdispf('    (def-delay /m_clock /nout  (+ 6.7 (* 3700 ~nout)))\n\n'),                     /* 1990.05.29 */
    fdispf('\t(def-constraint setup_in (- (+ /m_clock ?cycle) /in 3.4) type setup)\n'),       /* 1990.05.29 */
    fdispf('\t(def-constraint setup_enb (- (+ /m_clock ?cycle) /clk_enb 3.4) type setup)\n'), /* 1990.05.29 */
    fdispf('\t(def-constraint hold_in1 (- /in /m_clock) type hold)\n'),                       /* 1990.05.29 */
    fdispf('\t(def-constraint hold_enb1 (- /clk_enb /m_clock) type hold)\n'),                 /* 1990.05.29 */
    fdispf('\t(def-constraint hold_in2 (- %%in (+ /m_clock ?cycle)) type hold)\n'),           /* 1990.05.29 */
    fdispf('\t(def-constraint hold_enb2 (- %%clk_enb (+ /m_clock ?cycle)) type hold)\n'),     /* 1990.05.29 */
    fdispf('\t(def-constraint freq (- ?cycle 12.255))\n'),                                    /* 1990.05.29 */
    fdispf('\t(def-constraint drive (- 0 ~out) type max)\n'),                                 /* 1990.05.29 */
    fdispf('\t(def-constraint drive (- 0 ~nout) type max)\n'),                                /* 1990.05.29 */
    fdispf(')\n').                                                                            /* 1990.05.29 */

submod_pcd_gen1('regs-1'):-                                                                 /* 1990.06.18 */
    !,                                                                                        /* 1990.06.18 */
    fdispf('(def-module regs-1 power 25600 area 8110 gates 11\n\n'),                        /* 1990.06.18 */
    fdispf('    (def-pin in      type input  load 0.05)\n'),                                  /* 1990.06.18 */
    fdispf('    (def-pin clk_enb type input  load 0.08)\n'),                                  /* 1990.06.18 */
    fdispf('    (def-pin m_clock type input  load 0.09 note clock)\n'),                       /* 1990.06.18 */
    fdispf('    (def-pin s_clock type input)\n'),                                             /* 1990.06.18 */
    fdispf('    (def-pin p_reset type input  load 0.08)\n'),                                  /* 1990.06.18 */
    fdispf('    (def-pin out     type output load 0.14)\n'),                                  /* 1990.06.18 */
    fdispf('    (def-pin nout    type output load 0.08)\n\n'),                                /* 1990.06.18 */
    fdispf('    (def-function out   (regs-1 ^m_clock ^s_clock ^p_reset clk_enb in))\n'),    /* 1990.06.18 */
    fdispf('    (def-function ^nout (regs-1 ^m_clock ^s_clock ^p_reset clk_enb in))\n\n'),  /* 1990.06.18 */
    fdispf('    (def-delay /m_clock /out  (+ 5.3 (* 3800 ~out)))\n'),                         /* 1990.06.18 */
    fdispf('    (def-delay /m_clock /nout  (+ 6.7 (* 3700 ~nout)))\n\n'),                     /* 1990.06.18 */
    fdispf('\t(def-constraint setup_in (- (+ /m_clock ?cycle) /in 3.4) type setup)\n'),       /* 1990.06.18 */
    fdispf('\t(def-constraint setup_enb (- (+ /m_clock ?cycle) /clk_enb 3.4) type setup)\n'), /* 1990.06.18 */
    fdispf('\t(def-constraint hold_in1 (- /in /m_clock) type hold)\n'),                       /* 1990.06.18 */
    fdispf('\t(def-constraint hold_enb1 (- /clk_enb /m_clock) type hold)\n'),                 /* 1990.06.18 */
    fdispf('\t(def-constraint hold_in2 (- %%in (+ /m_clock ?cycle)) type hold)\n'),           /* 1990.06.18 */
    fdispf('\t(def-constraint hold_enb2 (- %%clk_enb (+ /m_clock ?cycle)) type hold)\n'),     /* 1990.06.18 */
    fdispf('\t(def-constraint freq (- ?cycle 12.255))\n'),                                    /* 1990.06.18 */
    fdispf('\t(def-constraint drive (- 0 ~out) type max)\n'),                                 /* 1990.06.18 */
    fdispf('\t(def-constraint drive (- 0 ~nout) type max)\n'),                                /* 1990.06.18 */
    fdispf(')\n').                                                                            /* 1990.06.18 */

submod_pcd_gen1('reg--1'):-
    !,
    fdispf('(def-module reg--1 power 25600 area 8110 gates 11\n\n'),
    fdispf('    (def-pin in      type input  load 0.05)\n'),
    fdispf('    (def-pin clk_enb type input  load 0.08)\n'),
    fdispf('    (def-pin m_clock type input  load 0.09 note clock)\n'),
    fdispf('    (def-pin s_clock type input)\n'),
    fdispf('    (def-pin p_reset type input  load 0.08)\n'),
    fdispf('    (def-pin out     type output load 0.14)\n'),
    fdispf('    (def-pin nout    type output load 0.08)\n\n'),
    fdispf('    (def-function out   (reg--1 ^m_clock ^s_clock ^p_reset clk_enb in))\n'),
    fdispf('    (def-function ^nout (reg--1 ^m_clock ^s_clock ^p_reset clk_enb in))\n\n'),
    fdispf('    (def-delay /m_clock /out  (+ 5.3 (* 3800 ~out)))\n'),
    fdispf('    (def-delay /m_clock /nout  (+ 6.7 (* 3700 ~nout)))\n\n'),
    fdispf('\t(def-constraint setup_in (- (+ /m_clock ?cycle) /in 3.4) type setup)\n'),
    fdispf('\t(def-constraint setup_enb (- (+ /m_clock ?cycle) /clk_enb 3.4) type setup)\n'),
    fdispf('\t(def-constraint hold_in1 (- /in /m_clock) type hold)\n'),
    fdispf('\t(def-constraint hold_enb1 (- /clk_enb /m_clock) type hold)\n'),
    fdispf('\t(def-constraint hold_in2 (- %%in (+ /m_clock ?cycle)) type hold)\n'),
    fdispf('\t(def-constraint hold_enb2 (- %%clk_enb (+ /m_clock ?cycle)) type hold)\n'),
    fdispf('\t(def-constraint freq (- ?cycle 12.255))\n'),
    fdispf('\t(def-constraint drive (- 0 ~out) type max)\n'),
    fdispf('\t(def-constraint drive (- 0 ~nout) type max)\n'),
    fdispf(')\n').
submod_pcd_gen1('reg---1'):-
    !,
    fdispf('(def-module reg---1 power 30000 area 9216 gates 12\n\n'),
    fdispf('    (def-pin set     type input  load 0.12)\n'),
    fdispf('    (def-pin reset   type input  load 0.08)\n'),
    fdispf('    (def-pin m_clock type input  load 0.09 note clock)\n'),
    fdispf('    (def-pin s_clock type input)\n'),
    fdispf('    (def-pin p_reset type input  load 0.08)\n'),
    fdispf('    (def-pin out     type output load 0.14)\n'),
    fdispf('    (def-pin nout    type output load 0.08)\n\n'),
    fdispf('    (def-function out   (reg---1 ^m_clock ^s_clock ^p_reset set reset))\n'),
    fdispf('    (def-function ^nout (reg---1 ^m_clock ^s_clock ^p_reset set reset))\n\n'),
    fdispf('    (def-delay /m_clock /out  (+ 5.3 (* 3800 ~out)))\n'),
    fdispf('    (def-delay /m_clock /nout  (+ 6.7 (* 3700 ~nout)))\n\n'),
    fdispf('\t(def-constraint setup_set   (- (+ /m_clock ?cycle) /set 5.54) type setup)\n'),
    fdispf('\t(def-constraint setup_reset (- (+ /m_clock ?cycle) /reset 5.54) type setup)\n'),
    fdispf('\t(def-constraint hold_set1   (- /set /m_clock) type hold)\n'),
    fdispf('\t(def-constraint hold_reset1 (- /reset /m_clock) type hold)\n'),
    fdispf('\t(def-constraint hold_set2   (- %%set (+ /m_clock ?cycle)) type hold)\n'),
    fdispf('\t(def-constraint hold_reset2 (- %%reset (+ /m_clock ?cycle)) type hold)\n'),
    fdispf('\t(def-constraint freq (- ?cycle 12.255))\n'),
    fdispf('\t(def-constraint drive (- 0 ~out) type max)\n'),
    fdispf('\t(def-constraint drive (- 0 ~nout) type max)\n'),
    fdispf(')\n').
submod_pcd_gen1('high-'):-
    !,
    fdispf('(def-module high- power 0 area 0 gates 0\n\n'),
    fdispf('\t(def-pin out type output load 0)\n\n'),
    fdispf('\t(def-function out (true))\n'),
    fdispf(')\n').
submod_pcd_gen1('low-'):-
    !,
    fdispf('(def-module low- power 0 area 0 gates 0\n\n'),
    fdispf('\t(def-pin nout type output load 0)\n\n'),
    fdispf('\t(def-function ^nout (true))\n'),
    fdispf(')\n').
submod_pcd_gen1('ts_buf-'):-
    !,
    fdispf('(def-module ts_buf- power 9900 area 1843 gates 2\n\n'),
    fdispf('\t(def-pin in type input load 0.05)\n'),
    fdispf('\t(def-pin out type bidirect load 0.07)\n'),
    fdispf('\t(def-pin nenb type input load 0.10 note clock)\n\n'),
    fdispf('\t(def-function out (ts_buf- ^nenb in))\n\n'),
    fdispf('\t(def-delay /in /out (+ 1.9 (* 7100 ~out)))\n'),
    fdispf('\t(def-delay \\nenb /out (+ 0.7 (* 7600 ~out)))\n'),
    fdispf('\t(def-delay /nenb %%out 0.6)\n\n'),
    fdispf('\t(def-constraint drive (- 0 ~out) type max)\n'),
    fdispf(')\n').
submod_pcd_gen1('bgate--2'):-
    !,
    fdispf('(def-module bgate--2 power 4000 area 1106 gates 1\n\n'),
    fdispf('\t(def-pin enb   type input  load 0.10)\n'),
    fdispf('\t(def-pin clock type input  load 0.10 note clock)\n'),
    fdispf('\t(def-pin nout  type output load 0.09)\n\n'),
    fdispf('\t(def-function ^nout (bgate--2 clock enb))\n\n'),
    fdispf('\t(def-delay /clock \\nout (+ 0.4 (* 2800 ~nout)))\n'),
    fdispf('\t(def-delay \clock /nout  (+ 0.5 (* 4100 ~nout)))\n\n'),
    fdispf('\t(def-constraint setup (- /clock /enb) type setup)\n'),
    fdispf('\t(def-constraint hold1 (- (+ /enb ?cycle) \clock) type hold)\n'),
    fdispf('\t(def-constraint hold2 (- %%enb \clock) type hold)\n'),
    fdispf('\t(def-constraint drive (- 0 ~nout) type max)\n'),
    fdispf(')\n').
submod_pcd_gen1(circuit(Name,PINS)):-
    !,
    fdispf('(def-module %s power 0 area 0 gates 0\n',Name),
    submod_pcd_gen2(PINS),
    fdispf('\t(def-pin p_reset type input load 0)\n'),
    fdispf('\t(def-pin m_clock type input load 0)\n'),
    fdispf('\t(def-pin s_clock type input load 0)\n'),
    fdispf('\t(def-pin b_clock type input load 0)\n'),
    fdispf(')\n').
submod_pcd_gen1(_):-fdispf('internal ERROR in pcd_gen\n').
/*-------------------*/
submod_pcd_gen2([pin(Name,Type,Width)|REST]):-
    !,
    submod_pcd_gen3(Type,Name,Width),
    submod_pcd_gen2(REST).
submod_pcd_gen2([]).
/*-------------------*/
submod_pcd_gen3(input,Name,1):-
    !,
    fdispf('\t(def-pin %s type input load 0)\n',Name).
submod_pcd_gen3(input,Name,Width):-
    !,
    for(0,Width,I,
        fdispf('\t(def-pin %s[%d] type input load 0)\n',Name,I)
    ).
submod_pcd_gen3(output,Name,1):-
    !,
    fdispf('\t(def-pin %s type output load 0)\n',Name).
submod_pcd_gen3(output,Name,Width):-
    !,
    for(0,Width,I,
        fdispf('\t(def-pin %s[%d] type output load 0)\n',Name,I)
    ).
submod_pcd_gen3(bidirect,Name,1):-
    !,
    fdispf('\t(def-pin %s type bidirect load 0)\n',Name).
submod_pcd_gen3(bidirect,Name,Width):-
    !,
    for(0,Width,I,
        fdispf('\t(def-pin %s[%d] type bidirect load 0)\n',Name,I)
    ).
submod_pcd_gen3(instrin,Name,1):-
    !,
    fdispf('\t(def-pin %s type input load 0)\n',Name).
submod_pcd_gen3(instrout,Name,1):-
    fdispf('\t(def-pin %s type output load 0)\n',Name).

/********************************************/
/***** TEST SYNTHESIS ***********************/
/********************************************/
/********************************************/
/*-------- test_class_inst ----pass 1-------*/
/********************************************/
test_class_inst([facility(Inst,submod,_,_,Class,_,_,_)|Rest],
                [info(Class,Inst)|Result]):-
    !,
    test_class_inst(Rest,Result).
test_class_inst([_|Rest],Result):-
    !,
    test_class_inst(Rest,Result).
test_class_inst([],[]).

/********************************************/
/*-------- test_info_out ------pass 1-------*/
/********************************************/
test_info_out(Info):-
    atom_value_read(test_syn_pass,Pass),
    if_then(
        eq(Pass,1),
        test_info_out1(Info)
    ).
/*------------------------------------------*/
test_info_out1(Info):-          /* Info: [info(Mod_name,Merged_sel,Class_Inst),...] */
    dispf('\n#### make infomation for test synthesis ####\n'),
    atom_value_read(test_syn_top,Top),
    test_info_struct(Info,Top,[Top],Struct,[]),
    test_info_flat(Struct,Flat,[]),
    test_info_display(Flat),
    sdispf('%s.tif',Top,File),
    see(File),
    fdispf('/***** info1([info(Src,Dst),...]). *****/\n'),
    fdispf('info1([\n'),
    test_info_fout(Flat),
    fdispf(').\n'),
    fdispf('/***** info(Src,Dst). *****/\n'),
    test_info_fout1(Flat),
    seen.

/*------------------------------------------*/
/*-------- test_info_struct ----------------*/
/*------------------------------------------*/
/* Info: [info(Class,Sel,Class_Inst),...]   */
/*                    |                     */
/*                    V                     */
/* Struct: [info([Inst,...],Sel),...]       */
/*------------------------------------------*/
test_info_struct(Info,Class,Inst,[info(Inst,Sel)|B],C):-
    test_info_struct1(Info,Class,Sel,Class_Inst),
    test_info_struct2(Class_Inst,Info,Inst,B,C).
/*------------------------------------------*/
test_info_struct1([info(Class,Sel,Class_Inst)|_],Class,Sel,Class_Inst):-
    !.
test_info_struct1([_|Rest],Class,Sel,Class_Inst):-
    !,
    test_info_struct1(Rest,Class,Sel,Class_Inst).
test_info_struct1([],Class,[],[]):-
    dispf('#### ERROR error Error : Test synthesis:\n'),
    dispf('#### ERROR error Error : Cannot find the module(%s) in this file\n',Class),
    dispf('#### ERROR error Error : Skip Test synthesis for this module\n'),
    atom_value_read(error_flg,X),
    add1(X,Y),
    atom_value_set(error_flg,Y).
/*------------------------------------------*/
test_info_struct2([info(Class,Inst)|Rest],Info,Inst_in,A,C):-
    !,
    test_info_struct(Info,Class,[Inst|Inst_in],A,B),
    test_info_struct2(Rest,Info,Inst_in,B,C).
test_info_struct2([],_,_,A,A).

/*------------------------------------------*/
/*-------- test_info_flat ------------------*/
/*------------------------------------------*/
/*   Struct: [info([Inst,...],Sel),...]     */
/*                    |                     */
/*                    V                     */
/*        Flat: [info(Src,Dst),...]         */
/*------------------------------------------*/
test_info_flat([info(Inst,Sel)|Rest],A,C):-
    !,
    test_info_flat1(Sel,Inst,A,B),
    test_info_flat(Rest,B,C).
test_info_flat([],A,A).
/*------------------------------------------*/
test_info_flat1([sel(Dst,_,Src)|Rest],Inst,A,C):-
    !,
    test_info_flat2(Src,Dst,Inst,A,B),
    test_info_flat1(Rest,Inst,B,C).
test_info_flat1([],_,A,A).
/*------------------------------------------*/
test_info_flat2([src(_,Src)|Rest],Dst,Inst,A,C):-
    !,
    test_info_flat3(Src,Dst,Inst,A,B),
    test_info_flat2(Rest,Dst,Inst,B,C).
test_info_flat2([],_,_,A,A).
/*------------------------------------------*/
test_info_flat3(Src,Dst,Inst,[info(Src1,Dst1)|A],A):-
    test_info_flat4(Src,Src1,Inst),
    test_info_flat4(Dst,Dst1,Inst),
    !.
test_info_flat3(Src,_,Inst,[info(Src1,ng_pin)|A],A):-
    test_info_flat4(Src,Src1,Inst),
    !.
test_info_flat3(_,Dst,Inst,[info(ng_pin,Dst1)|A],A):-
    test_info_flat4(Dst,Dst1,Inst),
    !.
test_info_flat3(_,_,_,A,A).
/*------------------------------------------*/
test_info_flat4(pin(input,W,[N,S]),
                pin(input,W,[N,[S|Inst]]),
                Inst):-
    !.
test_info_flat4(pin(input,W,N),
                pin(input,W,[N,Inst]),
                Inst):-
    !.
test_info_flat4(pin(output,W,[N,S]),
                pin(output,W,[N,[S|Inst]]),
                Inst):-
    !.
test_info_flat4(pin(output,W,N),
                pin(output,W,[N,Inst]),
                Inst):-
    !.
test_info_flat4(pin(bidirect,W,[N,S]),
                pin(bidirect,W,[N,[S|Inst]]),
                Inst):-
    !.
test_info_flat4(pin(bidirect,W,N),
                pin(bidirect,W,[N,Inst]),
                Inst):-
    !.
test_info_flat4(pin(reg,W,N),
                pin(reg,W,[N,Inst]),
                Inst):-
    !.
test_info_flat4(pin(reg_wr,W,N),
                pin(reg_wr,W,[N,Inst]),
                Inst):-
    !.
test_info_flat4(pin(reg_ws,W,N),
                pin(reg_ws,W,[N,Inst]),
                Inst):-
    !.
test_info_flat4(pin(sel_org,W,N),
                pin(sel_org,W,[N,Inst]),
                Inst):-
    !.
test_info_flat4(pin(bus_org,W,N),
                pin(bus_org,W,[N,Inst]),
                Inst).

/*------------------------------------------*/
/*-------- test_info_fout ------------------*/
/*------------------------------------------*/
test_info_fout([Info]):-
    !,
    fdisplay(Info),
    fdispf(']\n').
test_info_fout([Info|Rest]):-
    fdisplay(Info),
    fdispf(',\n'),
    test_info_fout(Rest).
/*------------------------------------------*/
test_info_fout1([Info|Rest]):-
    !,
    fdisplay(Info),
    fdispf('.\n'),
    test_info_fout1(Rest).
test_info_fout1([]).

/*------------------------------------------*/
/*-------- test_info_display ---------------*/
/*------------------------------------------*/
test_info_display([info(Src,Dst)|Rest]):-
    !,
    tab,
    test_info_display1(Src),
    dispf(' --> '),
    test_info_display1(Dst),
    nl,
    test_info_display(Rest).
test_info_display([]).
/*------------------------------------------*/
test_info_display1(pin(T,W,[N,S])):-
    !,
    reverse(S,R),
    test_info_display2(R),
    dispf('/%s:%s(%dbit)',N,T,W).
test_info_display1(ng_pin):-
    dispf('ng_pin').
/*------------------------------------------*/
test_info_display2([A|Rest]):-
    !,
    dispf('/%s',A),
    test_info_display2(Rest).
test_info_display2([]).

/********************************************/
/*-------- test_synthesis -----pass 2-------*/
/********************************************/
test_synthesis(In,Out):-
    atom_value_read(test_syn_pass,Pass),
    if_then_else(
        eq(Pass,2),
        syn_main(In,Out),
        eq(In,Out)
    ).
/*------------------------------------------*/
syn_main(Mods_In,Mods_Out):-
    dispf('\n#### start test synthesis ####\n'),
    atom_value_read(test_syn_top,Top),
    info1(Info),

    syn_detect_input(Info,Input,Top),
    sort(Input,S_Input,[]),
    dispf('** Input pin: pin(input,width,[name,module]) **\n'),
    list_display(S_Input),

    syn_detect_output(Info,Output,Top),
    sort(Output,S_Output,[]),
    dispf('** Output pin: pin(output,width,[name,module]) **\n'),
    list_display(S_Output),

    syn_detect_src_reg(Info,Reg_S,Reg_D),
    syn_detect_dst_reg(Info,Reg_D,[]),
    sort(Reg_S,S_Reg,[]),
    dispf('** Register: pin(reg,width,[name,module]) **\n'),
    list_display(S_Reg),

    dispf('## observability check ##\n'),
    syn_observe_order(S_Reg,Obs_Reg,Not_Obs_Reg,[],Top,[ng_pin]),
    dispf('** Not Observable Register **\n'),
    list_display(Not_Obs_Reg),

    dispf('## controllability check ##\n'),
    syn_control_order(S_Reg,Cnt_Reg,Not_Cnt_Reg,[],Top,[ng_pin]),
    dispf('** Not Controllable Register **\n'),
    list_display(Not_Cnt_Reg),

    append(Not_Obs_Reg,Not_Cnt_Reg,Scan_Reg),
    sort(Scan_Reg,S_Scan_Reg,[]),

    dispf('## classify paths between registers ##\n'),
    syn_cycle(Obs_Reg,Obs_Cycle,T_Cycle,M_Cycle),
    syn_cycle(Cnt_Reg,Cnt_Cycle,M_Cycle,[]),
    sort(T_Cycle,S_Cycle,[]),
    syn_cycle_id(S_Cycle,1),

    sdispf('%s.trg',Top,File),
    see(File),

    fdispf('(def-module %s\n',Top),

    fdispf('\t(def-cycle'),
    syn_cycle_fdisplay(S_Cycle),
    fdispf(')\n'),

    fdispf('\t(def-cnt'),
    syn_result_cnt(Cnt_Cycle),
    fdispf(')\n'),

    fdispf('\t(def-obs'),
    reverse(Obs_Cycle,R_Obs_Cycle),
    syn_result_obs(R_Obs_Cycle),
    fdispf(')\n'),

    fdispf('\t(def-scan'),
    syn_result_scan(S_Scan_Reg),
    fdispf(')\n'),

    fdispf(')\n'),
    seen,

    dispf('## separate class for instance ##\n'),
    syn_sfl_exp_class(Mods_In,Mods_In,Mods_Mid,[],Top,[Top],S_Scan_Reg),

    dispf('## insert test circuit ##\n'),
    list_count(S_Cycle,Cycle_Num),
    add1(Cycle_Num,Cycle_Num1),
    exp2u(Num,Cycle_Num1),
    syn_sfl_insert(Mods_Mid,Mods_Out,S_Cycle,Num).

/*------------------------------------------*/
/*------ expand class ----------------------*/
/*------------------------------------------*/
/*  syn_sfl_exp_class(                      */
/*  LIST:  current search space             */
/*  LIST:  total search space               */
/*  DLIST: result top                       */
/*  DLIST: result bottom                    */
/*  ATOM:  target class name for searching  */
/*  LIST:  new class name for target        */
/*  LIST:  scan reg)                        */
/*------------------------------------------*/
syn_sfl_exp_class([Mod|_],Mods,[MOD|B],C,Name,List_Name,Scan_Reg):-
    eq(Mod,facility(Name,module,_,_,Facility,Stage,Beh,Eor)),
    !,
    eq(MOD,facility(NAME,module,_,_,FACILITY,Stage,Beh,Eor)),
    syn_sfl_exp_name(List_Name,NAME),
    syn_sfl_exp_class1(Facility,FACILITY,Mods,B,C,List_Name,Scan_Reg).
syn_sfl_exp_class([_|REST],Mods,B,C,Name,List_Name,Scan_Reg):-
    syn_sfl_exp_class(REST,Mods,B,C,Name,List_Name,Scan_Reg).
/*------------------------------------------*/
syn_sfl_exp_class1([Facility|Rest],[FACILITY|Result],Mods,A,C,List_Name,Scan_Reg):-
    eq(Facility,facility(S_Name,submod,_,S_Facility,C_Name,_,_,_)),
    !,
    eq(FACILITY,facility(S_Name,submod,_,S_Facility,C_NAME,_,_,_)),
    syn_sfl_exp_name([S_Name|List_Name],C_NAME),
    syn_sfl_exp_class(Mods,Mods,A,B,C_Name,[S_Name|List_Name],Scan_Reg),
    syn_sfl_exp_class1(Rest,Result,Mods,B,C,List_Name,Scan_Reg).
syn_sfl_exp_class1([Facility|Rest],[FACILITY|Result],Mods,B,C,List_Name,Scan_Reg):-
    eq(Facility,facility(Name,reg,_,Width,_,_,_,_)),
    include(Scan_Reg,pin(reg,Width,[Name,List_Name])),
    !,
    eq(FACILITY,facility(Name,scan_reg,_,Width,_,_,_,_)),
    syn_sfl_exp_class1(Rest,Result,Mods,B,C,List_Name,Scan_Reg).
syn_sfl_exp_class1([Facility|Rest],[FACILITY|Result],Mods,B,C,List_Name,Scan_Reg):-
    eq(Facility,facility(Name,reg_wr,_,Width,_,_,_,_)),
    include(Scan_Reg,pin(reg_wr,Width,[Name,List_Name])),
    !,
    eq(FACILITY,facility(Name,scan_reg_wr,_,Width,_,_,_,_)),
    syn_sfl_exp_class1(Rest,Result,Mods,B,C,List_Name,Scan_Reg).
syn_sfl_exp_class1([Facility|Rest],[FACILITY|Result],Mods,B,C,List_Name,Scan_Reg):-
    eq(Facility,facility(Name,reg_ws,_,Width,_,_,_,_)),
    include(Scan_Reg,pin(reg_ws,Width,[Name,List_Name])),
    !,
    eq(FACILITY,facility(Name,scan_reg_ws,_,Width,_,_,_,_)),
    syn_sfl_exp_class1(Rest,Result,Mods,B,C,List_Name,Scan_Reg).
syn_sfl_exp_class1([Facility|Rest],[Facility|Result],Mods,B,C,List_Name,Scan_Reg):-
    !,
    syn_sfl_exp_class1(Rest,Result,Mods,B,C,List_Name,Scan_Reg).
syn_sfl_exp_class1([],[],_,A,A,_,_).
/*------------------------------------------*/
syn_sfl_exp_name([Name],Name):-
    !.
syn_sfl_exp_name([A|Rest],Name):-
    syn_sfl_exp_name(Rest,Result),
    sdispf('%s_%s',Result,A,Name).

/*------------------------------------------*/
/*------ insert test circuit ---------------*/
/*------------------------------------------*/
syn_sfl_insert([facility(Name,module,_,_,Fac,Stg,none,Eor)|Rest],
               [facility(Name,module,_,_,FAC,Stg,facility(_,par,_,BEHS,_,_,_,_),Eor)|Result],
               Cycle,Num):-
    !,
    syn_sfl_insert_fac(Num,FAc),
    append(Fac,FAc,FAC),
    syn_sfl_insert_simp(Fac,SIMPS,[],Num),
    syn_sfl_insert_cond(Cycle,Name,CONDS,Num),
    if_then_else(
        eq(CONDS,[]),
        eq(SIMPS,BEHS),
        append([facility(_,any,_,CONDS,_,_,_,_)],SIMPS,BEHS)
    ),
    syn_sfl_insert(Rest,Result,Cycle,Num).
syn_sfl_insert([facility(Name,module,_,_,Fac,Stg,Beh,Eor)|Rest],
               [facility(Name,module,_,_,FAC,Stg,facility(_,par,_,BEHS,_,_,_,_),Eor)|Result],
               Cycle,Num):-
    !,
    syn_sfl_insert_fac(Num,FAc),
    append(Fac,FAc,FAC),
    syn_sfl_insert_simp(Fac,SIMPS,[],Num),
    syn_sfl_insert_cond(Cycle,Name,CONDS,Num),
    eq(Suppressed_Beh,facility(_,condition,_,Cond,Beh,[],_,_)),
    syn_sfl_insert_and(Num,0,Cond),
    if_then_else(
        eq(CONDS,[]),
        append([facility(_,any,_,[Suppressed_Beh],_,_,_,_)],SIMPS,BEHS),
        append([facility(_,any,_,[Suppressed_Beh|CONDS],_,_,_,_)],SIMPS,BEHS)
    ),
    syn_sfl_insert(Rest,Result,Cycle,Num).
syn_sfl_insert([],[],_,_).
/*------------------------------------------*/
syn_sfl_insert_fac(0,[]):-!.
syn_sfl_insert_fac(In,[facility(Name,input,_,1,_,_,_,_)|Result]):-
    sub1(In,Out),
    sdispf('t_adrs_%d',Out,Name),
    syn_sfl_insert_fac(Out,Result).
/*------------------------------------------*/
syn_sfl_insert_simp([facility(Name,submod,_,_,_,_,_,_)|Rest],A,C,Num):-
    !,
    syn_sfl_insert_simp1(Num,Name,A,B),
    syn_sfl_insert_simp(Rest,B,C,Num).
syn_sfl_insert_simp([_|Rest],B,C,Num):-
    !,
    syn_sfl_insert_simp(Rest,B,C,Num).
syn_sfl_insert_simp([],A,A,_).
/*------------------------------------------*/
syn_sfl_insert_simp1(0,_,A,A):-!.
syn_sfl_insert_simp1(In,Name,[facility(_,simple,_,[net(pin(input,1,[TP,Name]),pin(input,1,TP))],_,_,_,_)|B],C):-
    sub1(In,Out),
    sdispf('t_adrs_%d',Out,TP),
    syn_sfl_insert_simp1(Out,Name,B,C).
/*------------------------------------------*/
syn_sfl_insert_cond([cycle(Cycle,Id)|Rest],Name,
                    [facility(_,condition,_,Cond,facility(_,par,_,DTRNSS,_,_,_,_),[],_,_)|Result],Num):-
    syn_sfl_insert_dtrns(Cycle,Name,DTRNSS),
    not(eq(DTRNSS,[])),
    !,
    syn_sfl_insert_and(Num,Id,Cond),
    syn_sfl_insert_cond(Rest,Name,Result,Num).
syn_sfl_insert_cond([_|Rest],Name,Result,Num):-
    !,
    syn_sfl_insert_cond(Rest,Name,Result,Num).
syn_sfl_insert_cond([],_,[],_).
/*------------------------------------------*/
syn_sfl_insert_dtrns([path(SRC,DST)|Rest],Name,
                     [facility(_,simple,_,[net(pin(D_T,W,[D_N,D_submod]),pin(S_T,W,[S_N,S_submod]))],_,_,_,_)|Result]):-
    eq(SRC,pin(S_T,W,[S_N,[S_submod|S_S]])),
    eq(DST,pin(D_T,W,[D_N,[D_submod|D_S]])),
    syn_sfl_exp_name(S_S,S_Name),
    syn_sfl_exp_name(D_S,D_Name),
    eq(Name,S_Name),
    eq(Name,D_Name),
    eq(S_T,output),
    eq(D_T,input),
    !,
    syn_sfl_insert_dtrns(Rest,Name,Result).
syn_sfl_insert_dtrns([path(SRC,DST)|Rest],Name,
                     [facility(_,simple,_,[net(pin(D_T,W,[D_N,D_submod]),pin(S_T,W,S_N))],_,_,_,_)|Result]):-
    eq(SRC,pin(S_T,W,[S_N,S_S])),
    eq(DST,pin(D_T,W,[D_N,[D_submod|D_S]])),
    syn_sfl_exp_name(S_S,S_Name),
    syn_sfl_exp_name(D_S,D_Name),
    eq(Name,S_Name),
    eq(Name,D_Name),
    eq(D_T,input),
    !,
    syn_sfl_insert_dtrns(Rest,Name,Result).
syn_sfl_insert_dtrns([path(SRC,DST)|Rest],Name,
                     [facility(_,simple,_,[net(pin(D_T,W,D_N),pin(S_T,W,[S_N,S_submod]))],_,_,_,_)|Result]):-
    eq(SRC,pin(S_T,W,[S_N,[S_submod|S_S]])),
    eq(DST,pin(D_T,W,[D_N,D_S])),
    syn_sfl_exp_name(S_S,S_Name),
    syn_sfl_exp_name(D_S,D_Name),
    eq(Name,S_Name),
    eq(Name,D_Name),
    eq(S_T,output),
    !,
    syn_sfl_insert_dtrns(Rest,Name,Result).
syn_sfl_insert_dtrns([path(SRC,DST)|Rest],Name,
                     [facility(_,simple,_,[net(pin(D_T,W,D_N),pin(S_T,W,S_N))],_,_,_,_)|Result]):-
    eq(SRC,pin(S_T,W,[S_N,S_S])),
    eq(DST,pin(D_T,W,[D_N,D_S])),
    syn_sfl_exp_name(S_S,S_Name),
    syn_sfl_exp_name(D_S,D_Name),
    eq(Name,S_Name),
    eq(Name,D_Name),
    !,
    syn_sfl_insert_dtrns(Rest,Name,Result).
syn_sfl_insert_dtrns([_|Rest],Name,Result):-
    !,
    syn_sfl_insert_dtrns(Rest,Name,Result).
syn_sfl_insert_dtrns([],_,[]).
/*------------------------------------------*/
syn_sfl_insert_and(1,1,pin(input,1,t_adrs_0)):-!.
syn_sfl_insert_and(1,0,pin(not,1,pin(input,1,t_adrs_0))):-!.
syn_sfl_insert_and(Adrs_in,Id_in,
                   pin(and,1,[pin(input,1,TP),Rest])
                  ):-
    sub1(Adrs_in,Adrs_out),
    sdispf('t_adrs_%d',Adrs_out,TP),
    exp2(Adrs_out,Exp),
    or(
        bigger(Id_in,Exp),
        eq(Id_in,Exp)
    ),
    !,
    minus(Id_in,Exp,Id_out),
    syn_sfl_insert_and(Adrs_out,Id_out,Rest).
syn_sfl_insert_and(Adrs_in,Id_in,
                   pin(and,1,[pin(not,1,pin(input,1,TP)),Rest])
                  ):-
    !,
    sub1(Adrs_in,Adrs_out),
    sdispf('t_adrs_%d',Adrs_out,TP),
    syn_sfl_insert_and(Adrs_out,Id_in,Rest).

/*------------------------------------------*/
/*------ observability check ---------------*/
/*------------------------------------------*/
syn_observe_order(Regs,O_Reg,N_Reg1,N_Reg3,Top,Used_Regs):-
    syn_observe(Regs,O_reg,N_Reg1,N_Reg2,Top,Used_Regs),
    syn_observe_order1(O_reg,O_Reg,N_Reg2,N_Reg3,Top,Used_Regs).
/*------------------------------------------*/
syn_observe_order1([],[],A,A,_,_):-!.
syn_observe_order1(O_reg,[S_rega|O_Reg],N_Reg1,N_Reg2,Top,Used_Regs):-
    sort(O_reg,S_reg,[]),
    eq(S_reg,[S_rega|S_regb]),
    eq(S_rega,keiro(Deep,Reg,Route)),
    dispf('** found route(%d step) for ',Deep),display(Reg),dispf('\n'),list_display(Route),
    syn_reg_detect(S_regb,Regs),
    syn_observe_order(Regs,O_Reg,N_Reg1,N_Reg2,Top,[Reg|Used_Regs]).
/*------------------------------------------*/
syn_observe([Reg|Rest],[keiro(Deep,Reg,Route)|Obs_Reg],N_Reg1,N_Reg2,Top,Used_Reg):-
    syn_observe1(Reg,[Reg|Used_Reg],Route,Top),
    !,
    list_count(Route,Deep),
    syn_observe(Rest,Obs_Reg,N_Reg1,N_Reg2,Top,Used_Reg).
syn_observe([Reg|Rest],Obs_Reg,[Reg|N_Reg1],N_Reg2,Top,Used_Reg):-
    !,
    syn_observe(Rest,Obs_Reg,N_Reg1,N_Reg2,Top,Used_Reg).
syn_observe([],[],A,A,_,_).
/*------------------------------------------*/
syn_observe1(Dst,_,[],Top):-
    eq(Dst,pin(output,_,[_,[Top]])),
    !.
syn_observe1(Src,List,[path(Src,Dst)|Result],Top):-
    info(Src,Dst),
    not(include(List,Dst)),
    syn_observe1(Dst,[Dst|List],Result,Top).
/*------------------------------------------*/
syn_reg_detect([keiro(_,Reg,_)|Rest],[Reg|Result]):-
    !,
    syn_reg_detect(Rest,Result).
syn_reg_detect([],[]).

/*------------------------------------------*/
/*------ controllability check -------------*/
/*------------------------------------------*/
syn_control_order(Regs,C_Reg,N_Reg1,N_Reg3,Top,Used_Regs):-
    syn_control(Regs,C_reg,N_Reg1,N_Reg2,Top,Used_Regs),
    syn_control_order1(C_reg,C_Reg,N_Reg2,N_Reg3,Top,Used_Regs).
/*------------------------------------------*/
syn_control_order1([],[],A,A,_,_):-!.
syn_control_order1(C_reg,[S_rega|C_Reg],N_Reg1,N_Reg2,Top,Used_Regs):-
    sort(C_reg,S_reg,[]),
    eq(S_reg,[S_rega|S_regb]),
    eq(S_rega,keiro(Deep,Reg,Route)),
    dispf('** found route(%d step) for ',Deep),display(Reg),dispf('\n'),list_display(Route),
    syn_reg_detect(S_regb,Regs),
    syn_control_order(Regs,C_Reg,N_Reg1,N_Reg2,Top,[Reg|Used_Regs]).
/*------------------------------------------*/
syn_control([Reg|Rest],[keiro(Deep,Reg,Route)|Cnt_Reg],N_Reg1,N_Reg2,Top,Used_Reg):-
    syn_control1(Reg,[Reg|Used_Reg],R_Route,Top),
    !,
    reverse(R_Route,Route),
    list_count(Route,Deep),
    syn_control(Rest,Cnt_Reg,N_Reg1,N_Reg2,Top,Used_Reg).
syn_control([Reg|Rest],Cnt_Reg,[Reg|N_Reg1],N_Reg2,Top,Used_Reg):-
    !,
    syn_control(Rest,Cnt_Reg,N_Reg1,N_Reg2,Top,Used_Reg).
syn_control([],[],A,A,_,_).
/*------------------------------------------*/
syn_control1(Src,_,[],Top):-
    eq(Src,pin(input,_,[_,[Top]])),
    !.
syn_control1(Dst,List,[path(Src,Dst)|Result],Top):-
    info(Src,Dst),
    not(include(List,Src)),
    syn_control1(Src,[Src|List],Result,Top).

/*------------------------------------------*/
/*------ classify paths between registers --*/
/*------------------------------------------*/
syn_cycle([keiro(_,Reg,Route)|Rest],[keiro(Reg,[cycle(S_Cycle1,Id)|Cycle2])|Result],[cycle(S_Cycle1,Id)|A],C):-
    !,
    syn_cycle1(Route,Cycle1,Cycle2,A,B),
    sort(Cycle1,S_Cycle1,[]),
    syn_cycle(Rest,Result,B,C).
syn_cycle([],[],A,A).
/*------------------------------------------*/
syn_cycle1([Info],[Info],[],A,A):-
    !.
syn_cycle1([Info|Rest],[Info],[cycle(S_R1,Id)|R2],[cycle(S_R1,Id)|B],C):-
    eq(Info,path(_,Dst)),
    syn_reg(Dst),
    !,
    syn_cycle1(Rest,R1,R2,B,C),
    sort(R1,S_R1,[]).
syn_cycle1([Info|Rest],[Info|R1],R2,B,C):-
    !,
    syn_cycle1(Rest,R1,R2,B,C).
/*------------------------------------------*/
syn_reg(pin(reg,_,_)):-!.
syn_reg(pin(reg_wr,_,_)):-!.
syn_reg(pin(reg_ws,_,_)).
/*------------------------------------------*/
syn_cycle_id([cycle(_,In)|Rest],In):-
    !,
    add1(In,Out),
    syn_cycle_id(Rest,Out).
syn_cycle_id([],_).

/*------------------------------------------*/
/*------ output module.test_reg_info -------*/
/*------------------------------------------*/
syn_cycle_fdisplay([cycle(Path,Id)|Rest]):-
    !,
    fdispf('\n\t\t(%d',Id),
    syn_cycle_fdisplay1(Path),
    syn_cycle_fdisplay(Rest).
syn_cycle_fdisplay([]).
/*------------------------------------------*/
syn_cycle_fdisplay1([path(Src,Dst)|Rest]):-
    !,
    fdispf('\t('),
    syn_result_name(Src,Src_Name),
    fdisplay(Src_Name),
    fdispf(' ---> '),
    syn_result_name(Dst,Dst_Name),
    fdisplay(Dst_Name),
    fdispf(')'),
    syn_cycle_fdisplay1(Rest).
syn_cycle_fdisplay1([]):-
    fdispf(')').
/*------------------------------------------*/
syn_result_cnt([keiro(Reg,Cycle)|Rest]):-
    !,
    syn_result_find_input(Cycle,Src),
    fdispf('\n\t\t('),
    syn_result_name(Src,Src_Name),
    fdisplay(Src_Name),
    fdispf('\t'),
    syn_result_name(Reg,Reg_Name),
    fdisplay(Reg_Name),
    syn_result_cnt1(Cycle),
    syn_result_cnt(Rest).
syn_result_cnt([]).
/*------------------------------------------*/
syn_result_cnt1([cycle(_,Id)|Rest]):-
    !,
    fdispf('\t%d',Id),
    syn_result_cnt1(Rest).
syn_result_cnt1([]):-
    fdispf(')').
/*------------------------------------------*/
syn_result_find_input([cycle(Path,_)|_],Src):-
    syn_result_find_input1(Path,Src).
syn_result_find_input1([path(Src,_)|_],Src):-
    eq(Src,pin(input,_,[_,[_]])),
    !.
syn_result_find_input1([_|Rest],Src):-
    syn_result_find_input1(Rest,Src).
/*------------------------------------------*/
syn_result_obs([keiro(Reg,Cycle)|Rest]):-
    !,
    reverse(Cycle,R_Cycle),
    syn_result_find_output(R_Cycle,Dst),
    fdispf('\n\t\t('),
    syn_result_name(Reg,Reg_Name),
    fdisplay(Reg_Name),
    fdispf('\t'),
    syn_result_name(Dst,Dst_Name),
    fdisplay(Dst_Name),
    syn_result_obs1(Cycle),
    syn_result_obs(Rest).
syn_result_obs([]).
/*------------------------------------------*/
syn_result_obs1([cycle(_,Id)|Rest]):-
    !,
    fdispf('\t%d',Id),
    syn_result_obs1(Rest).
syn_result_obs1([]):-
    fdispf(')').
/*------------------------------------------*/
syn_result_find_output([cycle(Path,_)|_],Dst):-
    syn_result_find_output1(Path,Dst).
syn_result_find_output1([path(_,Dst)|_],Dst):-
    eq(Dst,pin(output,_,[_,[_]])),
    !.
syn_result_find_output1([_|Rest],Dst):-
    syn_result_find_output1(Rest,Dst).
/*------------------------------------------*/
syn_result_scan([Reg|Rest]):-
    !,
    syn_result_name(Reg,Reg_Name),
    fdispf('\t'),
    fdisplay(Reg_Name),
    syn_result_scan(Rest).
syn_result_scan([]).
/*------------------------------------------*/
syn_result_name(pin(_,_,[E_Name,S_Name]),Name):-
    reverse(S_Name,[_|S1_Name]),
    syn_result_name1(S1_Name,E_Name,Name).
/*------------------------------------------*/
syn_result_name1([A|B],E_Name,NAME):-
    !,
    syn_result_name1(B,E_Name,Name),
    sdispf('%s_%s',A,Name,NAME).
syn_result_name1([],Name,Name).

/*------------------------------------------*/
/*------ detect external pin & reg ---------*/
/*------------------------------------------*/
syn_detect_input([info(Src,_)|Rest],[Src|Result],Top):-
    eq(Src,pin(input,_,[_,[Top]])),
    !,
    syn_detect_input(Rest,Result,Top).
syn_detect_input([_|Rest],Result,Top):-
    !,
    syn_detect_input(Rest,Result,Top).
syn_detect_input([],[],_).
/*------------------------------------------*/
syn_detect_output([info(_,Dst)|Rest],[Dst|Result],Top):-
    eq(Dst,pin(output,_,[_,[Top]])),
    !,
    syn_detect_output(Rest,Result,Top).
syn_detect_output([_|Rest],Result,Top):-
    !,
    syn_detect_output(Rest,Result,Top).
syn_detect_output([],[],_).
/*------------------------------------------*/
syn_detect_src_reg([info(Reg,_)|Rest],[Reg|B],C):-
    or(
        eq(Reg,pin(reg,_,_)),
        eq(Reg,pin(reg_wr,_,_)),
        eq(Reg,pin(reg_ws,_,_))
    ),
    !,
    syn_detect_src_reg(Rest,B,C).
syn_detect_src_reg([_|Rest],B,C):-
    !,
    syn_detect_src_reg(Rest,B,C).
syn_detect_src_reg([],A,A).
/*------------------------------------------*/
syn_detect_dst_reg([info(_,Reg)|Rest],[Reg|B],C):-
    or(
        eq(Reg,pin(reg,_,_)),
        eq(Reg,pin(reg_wr,_,_)),
        eq(Reg,pin(reg_ws,_,_))
    ),
    !,
    syn_detect_dst_reg(Rest,B,C).
syn_detect_dst_reg([_|Rest],B,C):-
    !,
    syn_detect_dst_reg(Rest,B,C).
syn_detect_dst_reg([],A,A).

/********************************************/
/*-------- common --------------------------*/
/********************************************/
include([X|_],X):-!.
include([_|REST],X):-
    include(REST,X).
        /*****************************/
        /*****************************/
        /* Designed by Kiyoshi Oguri */
        /*        sfl_trns           */
        /*****************************/
        /*****************************/

sfl_trns_pre(V1,V3,R):-                 /* 1992.08.13 */
        atom_value_read(mode_flg,MODE),
        atom_value_set(mode_flg,exp),   /* This exist not to invoke nomura's c-program */
        atom_value_set(op_mode,loose),  /* This exist to allow '+' operator in circuit */
        class_def(V1,V2,_,0),
        !,
        atom_value_set(mode_flg,MODE),
        sfl_trns(V2,V3,R,[deff(V1)],[]).

sfl_trns([module,Name,'{'|V3],
       V11,
       [facility(Name,module,Ptr,Class,Facility,Stage,BEH,EOR_ID)|REST], /* 1990.05.25 */
       Class_List,Mod_list):- /* 1992.08.13 */
        !,
        atom_value_set(eor_id,0),
        atom_value_set(op_mode,loose),
        alpha_name(Name),

        chk_double(Mod_list,Name),

        module_def(Ptr,Name),
        nl,display('Module: '),display(Name),display(' definition start.'),nl,
        class_def_list(Class_List,Class1,Ptr),
        class_def(V3,V4,Class2,Ptr),
        append(Class1,Class2,Class),
        chk_same_class(Class),
/**/    hash_class(Class),
        atom_value_read(trns_mode,Trns_mode),
        atom_value_set(op_mode,Trns_mode),
        module_facility(V4,V5,Facility,Class,Ptr),
        display('All facilities of module: '),display(Name),display(' defined.'),nl,
/**/    hash(Facility),
        instr_arg_def(V5,V6,Facility),
        stage_task_def(V6,V7,Stage,Facility,Ptr),
        display('Instructs arguments and stages tasks of module: '),display(Name),display(' defined.'),nl,
/**/    hash(Stage),
        module_behavior(V7,V77,Facility,Stage,Ptr,BEH), /* 1990.05.25 */
        instr_behavior(V77,V8,Facility,Stage), /* 1990.05.25 */
        display('Instructs behavior of module: '),display(Name),display(' defined.'),nl,
        stage_segment_state_def(V8,V9,Facility,Stage),
        '}'(V9,V10),
        atom_value_read(eor_id,EOR_ID),
        atom_value_read(mode_flg,MODE),
        atom_value_set(mode_flg,exp),
        atom_value_set(op_mode,loose),
        class_def(V10,V101,_,0),
        !,
        atom_value_set(mode_flg,MODE),
        sfl_trns(V101,V11,REST,[deff(V10)|Class_List],[Name|Mod_list]).
sfl_trns([circuit,Name,'{'|V3],
       V11,
       REST,
       Class_List,Mod_list):- /* 1992.08.13 */
        !,
        atom_value_set(eor_id,0),
        atom_value_set(op_mode,loose),
        alpha_name(Name),

        chk_double(Mod_list,Name),

        new_circuit_def(Ptr,Name),
        nl,display('Module: '),display(Name),display(' definition start.'),nl,
        class_def_list(Class_List,Class1,Ptr),
        class_def(V3,V4,Class2,Ptr),
        append(Class1,Class2,Class),
        chk_same_class(Class),
/**/    hash_class(Class),
        module_facility(V4,V5,Facility,Class,Ptr),
        display('All facilities of module: '),display(Name),display(' defined.'),nl,
/**/    hash(Facility),
        instr_arg_def(V5,V6,Facility),
        stage_task_def(V6,V7,Stage,Facility,Ptr),
        display('Instructs arguments and stages tasks of module: '),display(Name),display(' defined.'),nl,
/**/    hash(Stage),
        module_behavior(V7,V77,Facility,Stage,Ptr,_), /* 1990.05.25 */
        instr_behavior(V77,V8,Facility,Stage), /* 1990.05.25 */
        display('Instructs behavior of module: '),display(Name),display(' defined.'),nl,
        stage_segment_state_def(V8,V9,Facility,Stage),
        '}'(V9,V10),
        atom_value_read(mode_flg,MODE),
        atom_value_set(mode_flg,exp),
        atom_value_set(op_mode,loose),
        class_def(V10,V101,_,0),
        !,
        atom_value_set(mode_flg,MODE),
        sfl_trns(V101,V11,REST,[deff(V10)|Class_List],[Name|Mod_list]).
sfl_trns(V,V,[],_,_).

chk_double([Name|_],Name):-
        !,
        and(
            display('??? The module or circuit: '),
            display(Name),
            display(' is double defined.'),
            nl
        ),
        fail.
chk_double([_|List],Name):-
        !,
        chk_double(List,Name).
chk_double([],_).

class_def_list([deff(V1)|Rest],Class,Ptr):-
        !,
        class_def_list(Rest,Class1,Ptr),
        class_def(V1,_,Class2,Ptr),
        append(Class1,Class2,Class).
class_def_list([],[],_).

/** 1990.05.25 **/
module_behavior(V0,V1,Facility,Stage,Ptr,BEH):-
        behavior(V0,
                 V1,
                 1,
                 _,
                 BEH,
                 Facility,
                 Stage,
                 notin_stage,
                 notin_segment,
                 [],
                 [],
                 Ptr),
        !.
module_behavior(V,V,_,_,_,none).
/** 1990.05.25 **/

/*-------------------------------------*/
/*----- chk same class ----------------*/
/*-------------------------------------*/
chk_same_class(Darty):-  /* check only */
        !,
        chk_same_class_copy(Darty,Darty1),
        sort(Darty1,Darty2),
        chk_same_class_chk(Darty2,Darty2).
/*-------------------------------------*/
chk_same_class_copy(
        [facility(Name,submod_class,_,Facility1,_,_,_,_)|REST1],
        [facility(Name,submod_class,_,Facility3,_,_,_,_)|REST2]):-
        !,
        chk_same_class_copy1(Facility1,Facility2),
        sort(Facility2,Facility3),
        chk_same_class_copy(REST1,REST2).
chk_same_class_copy([],[]).
/*-------------------------------------*/
chk_same_class_copy1(
        [facility(Name,input,_,Width,_,_,_,_)|REST1],
        [facility(Name,input,_,Width,_,_,_,_)|REST2]):-
        !,
        chk_same_class_copy1(REST1,REST2).
chk_same_class_copy1(
        [facility(Name,output,_,Width,_,_,_,_)|REST1],
        [facility(Name,output,_,Width,_,_,_,_)|REST2]):-
        !,
        chk_same_class_copy1(REST1,REST2).
chk_same_class_copy1(
        [facility(Name,bidirect,_,Width,_,_,_,_)|REST1],
        [facility(Name,bidirect,_,Width,_,_,_,_)|REST2]):-
        !,
        chk_same_class_copy1(REST1,REST2).
chk_same_class_copy1(
        [facility(Name,instrout,_,_,_,_,_,_)|REST1],
        [facility(Name,instrout,_,_,_,_,_,_)|REST2]):-
        !,
        chk_same_class_copy1(REST1,REST2).
chk_same_class_copy1(
        [facility(Name,instrin,_,Arg1,_,_,_,_)|REST1],
        [facility(Name,instrin,_,Arg2,_,_,_,_)|REST2]):-
        var(Arg1),
        !,
        chk_same_class_copy1(REST1,REST2).
chk_same_class_copy1(
        [facility(Name,instrin,_,Arg1,_,_,_,_)|REST1],
        [facility(Name,instrin,_,Arg2,_,_,_,_)|REST2]):-
        !,
        chk_same_class_copy1(Arg1,Arg2),
        chk_same_class_copy1(REST1,REST2).
chk_same_class_copy1([],[]).
/*-------------------------------------*/
chk_same_class_chk([facility(Name,_,_,_,_,_,_,_)|REST],All):-
        !,
        chk_same_class_chk1(All,Name,0),
        chk_same_class_chk(REST,All).
chk_same_class_chk([],_).
/*-------------------------------------*/
chk_same_class_chk1([facility(Name,_,_,_,_,_,_,_)|REST],Name,0):-
        !,
        chk_same_class_chk1(REST,Name,1).
chk_same_class_chk1([facility(Name,_,_,_,_,_,_,_)|REST],Name,1):-
        !,
        and(
            display('??? The different sub modules have same name: '),
            display(Name),
            display('.'),
            nl
        ),
        fail.
chk_same_class_chk1([_|REST],Name,Num):-
        !,
        chk_same_class_chk1(REST,Name,Num).
chk_same_class_chk1([],_,_).
/*-------------------------------------*/

/******* class def ***********************/
class_def([declare,Name,'{'|V3],
         V6,
         [facility(Name,submod_class,Ptr,Facility,_,_,_,_)|REST],
         Par):-
        !,
        alpha_name(Name),
        submod_class_def(Ptr,Name,Par),
        submod_facility(V3,V4,Facility,Ptr),
/**/    hash(Facility),                                             /* 1991.01.24 */
        circuit_inst_arg_def(V4,V45,Facility),                      /* 1991.01.24 */
        '}'(V45,V5),                                                /* 1991.01.24 */
        display('Submod_class: '),display(Name),display(' defined.'),nl,
        class_def(V5,V6,REST,Par).
class_def(V,V,[],_).

/** 1990.06.02 **/
circuit_behavior(V0,V1,Facility,Ptr,BEH):-
        behavior(V0,
                 V1,
                 1,
                 _,
                 BEH, /* 1990.06.18 */
                 Facility,
                 [],
                 notin_stage,
                 notin_segment,
                 [],
                 [],
                 Ptr),
        !.
circuit_behavior(V,V,_,_,none).
/** 1990.06.02 **/

/*------ submod facility def ----------------------*/
submod_facility([input|V0],V2,Result,Par):-
        !,
        inputs_def(V0,V1,Result,REST,Par),
        submod_facility(V1,V2,REST,Par).
submod_facility([output|V0],V2,Result,Par):-
        !,
        outputs_def(V0,V1,Result,REST,Par),
        submod_facility(V1,V2,REST,Par).
submod_facility([bidirect|V0],V2,Result,Par):-
        !,
        bidirects_def(V0,V1,Result,REST,Par,z),
        submod_facility(V1,V2,REST,Par).
submod_facility([bidirect_pu|V0],V2,Result,Par):-
        !,
        bidirects_def(V0,V1,Result,REST,Par,1),
        submod_facility(V1,V2,REST,Par).
submod_facility([bidirect_pd|V0],V2,Result,Par):-
        !,
        bidirects_def(V0,V1,Result,REST,Par,0),
        submod_facility(V1,V2,REST,Par).
submod_facility([instrin|V0],V2,Result,Par):-
        !,
        instrins_def(V0,V1,Result,REST,Par),
        submod_facility(V1,V2,REST,Par).
submod_facility([instrout|V0],V2,Result,Par):-
        !,
        instrouts_def(V0,V1,Result,REST,Par),
        submod_facility(V1,V2,REST,Par).
submod_facility(V,V,[],_).
/*------ circuit facility def ----------------------*/
circuit_facility([tmp|V0],V2,Result,Par):-
        !,
        tmps_def(V0,V1,Result,REST,Par),
        circuit_facility(V1,V2,REST,Par).
circuit_facility([bus_v|V0],V2,Result,Par):-
        !,
        tmps_bus_def(V0,V1,Result,REST,Par),
        circuit_facility(V1,V2,REST,Par).
circuit_facility([sel_v|V0],V2,Result,Par):-
        !,
        tmps_sel_def(V0,V1,Result,REST,Par),
        circuit_facility(V1,V2,REST,Par).
circuit_facility([term|V0],V2,Result,Par):-
        !,
        terms_def(V0,V1,Result,REST,Par),
        circuit_facility(V1,V2,REST,Par).
circuit_facility([bus|V0],V2,Result,Par):-
        !,
        terms_def(V0,V1,Result,REST,Par),
        circuit_facility(V1,V2,REST,Par).
circuit_facility([sel|V0],V2,Result,Par):-
        !,
        terms_sel_def(V0,V1,Result,REST,Par),
        circuit_facility(V1,V2,REST,Par).
circuit_facility([input|V0],V2,Result,Par):-
        !,
        inputs_def(V0,V1,Result,REST,Par),
        circuit_facility(V1,V2,REST,Par).
circuit_facility([output|V0],V2,Result,Par):-
        !,
        outputs_def(V0,V1,Result,REST,Par),
        circuit_facility(V1,V2,REST,Par).
circuit_facility([bidirect|V0],V2,Result,Par):-
        !,
        bidirects_def(V0,V1,Result,REST,Par,z),
        circuit_facility(V1,V2,REST,Par).
circuit_facility([instrin|V0],V2,Result,Par):-
        !,
        instrins_def(V0,V1,Result,REST,Par),
        circuit_facility(V1,V2,REST,Par).
circuit_facility([reg|V0],V2,Result,Par):-
        !,
        regs_def(V0,V1,Result,REST,Par),
        circuit_facility(V1,V2,REST,Par).

circuit_facility([reg_wr|V0],V2,Result,Par):- /* 1990.05.29 */
        !,                                    /* 1990.05.29 */
        reg_wrs_def(V0,V1,Result,REST,Par),   /* 1990.05.29 */
        circuit_facility(V1,V2,REST,Par).     /* 1990.05.29 */

circuit_facility([reg_ws|V0],V2,Result,Par):- /* 1990.06.18 */
        !,                                    /* 1990.06.18 */
        reg_wss_def(V0,V1,Result,REST,Par),   /* 1990.06.18 */
        circuit_facility(V1,V2,REST,Par).     /* 1990.06.18 */

circuit_facility([mem|V0],V2,Result,Par):-
        !,
        mems_def(V0,V1,Result,REST,Par),
        circuit_facility(V1,V2,REST,Par).
circuit_facility(V,V,[],_).
/*------ circuit inst arg def ----------------------*/
circuit_inst_arg_def([instruct_arg,Name,'('|V3],V7,Facility):-
        !,
        if_else(
            search(Facility,facility(Name,instrin,Ptr,ARG,_,_,_,_)),
            and(
                display('??? The instrin name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        instr_arg_inbis(V3,V4,ARG,Facility,Number,Ptrs),
        ')'(V4,V5),
        instr_def_second(Ptr,Number,Ptrs),
        ';'(V5,V6),
        circuit_inst_arg_def(V6,V7,Facility).
circuit_inst_arg_def([instr_arg,Name,'('|V3],V7,Facility):-
        !,
        if_else(
            search(Facility,facility(Name,instrin,Ptr,ARG,_,_,_,_)),
            and(
                display('??? The instrin name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        instr_arg_inbis(V3,V4,ARG,Facility,Number,Ptrs),
        ')'(V4,V5),
        instr_def_second(Ptr,Number,Ptrs),
        ';'(V5,V6),
        circuit_inst_arg_def(V6,V7,Facility).
circuit_inst_arg_def(V,V,_).
/*------ circuit inst beh ----------------------*/
circuit_inst_beh([instruct,Name|V2],V4,Facility):-
        !,
        if_else(
            search(Facility,facility(Name,instrin,Ptr,_,BEH,_,_,_)),
            and(
                display('??? The instrin name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        behavior(V2,
                 V3,
                 1,
                 _,
                 BEH,
                 Facility,
                 [],
                 notin_stage,
                 notin_segment,
                 [],
                 [],
                 Ptr),
        circuit_inst_beh(V3,V4,Facility).
circuit_inst_beh(V,V,_).
/******* module facility def ***********************/
module_facility([tmp|V0],V2,Result,Class,Par):-
        !,
        tmps_def(V0,V1,Result,REST,Par),
        module_facility(V1,V2,REST,Class,Par).
module_facility([bus_v|V0],V2,Result,Class,Par):-
        !,
        tmps_bus_def(V0,V1,Result,REST,Par),
        module_facility(V1,V2,REST,Class,Par).
module_facility([sel_v|V0],V2,Result,Class,Par):-
        !,
        tmps_sel_def(V0,V1,Result,REST,Par),
        module_facility(V1,V2,REST,Class,Par).
module_facility([term|V0],V2,Result,Class,Par):-
        !,
        terms_def(V0,V1,Result,REST,Par),
        module_facility(V1,V2,REST,Class,Par).
module_facility([bus|V0],V2,Result,Class,Par):-
        !,
        terms_def(V0,V1,Result,REST,Par),
        module_facility(V1,V2,REST,Class,Par).
module_facility([sel|V0],V2,Result,Class,Par):-
        !,
        terms_sel_def(V0,V1,Result,REST,Par),
        module_facility(V1,V2,REST,Class,Par).
module_facility([input|V0],V2,Result,Class,Par):-
        !,
        inputs_def(V0,V1,Result,REST,Par),
        module_facility(V1,V2,REST,Class,Par).
module_facility([output|V0],V2,Result,Class,Par):-
        !,
        outputs_def(V0,V1,Result,REST,Par),
        module_facility(V1,V2,REST,Class,Par).
module_facility([bidirect|V0],V2,Result,Class,Par):-
        !,
        bidirects_def(V0,V1,Result,REST,Par,z),
        module_facility(V1,V2,REST,Class,Par).
module_facility([bidirect_pu|V0],V2,Result,Class,Par):-
        !,
        bidirects_def(V0,V1,Result,REST,Par,1),
        module_facility(V1,V2,REST,Class,Par).
module_facility([bidirect_pd|V0],V2,Result,Class,Par):-
        !,
        bidirects_def(V0,V1,Result,REST,Par,0),
        module_facility(V1,V2,REST,Class,Par).
module_facility([instrin|V0],V2,Result,Class,Par):-
        !,
        instrins_def(V0,V1,Result,REST,Par),
        module_facility(V1,V2,REST,Class,Par).
module_facility([instrself|V0],V2,Result,Class,Par):-
        !,
        instrselfs_def(V0,V1,Result,REST,Par),
        module_facility(V1,V2,REST,Class,Par).
module_facility([instrout|V0],V2,Result,Class,Par):-
        !,
        instrouts_def(V0,V1,Result,REST,Par),
        module_facility(V1,V2,REST,Class,Par).
module_facility([reg|V0],V2,Result,Class,Par):-
        !,
        regs_def(V0,V1,Result,REST,Par),
        module_facility(V1,V2,REST,Class,Par).

module_facility([reg_wr|V0],V2,Result,Class,Par):- /* 1990.05.29 */
        !,                                         /* 1990.05.29 */
        reg_wrs_def(V0,V1,Result,REST,Par),        /* 1990.05.29 */
        module_facility(V1,V2,REST,Class,Par).     /* 1990.05.29 */

module_facility([reg_ws|V0],V2,Result,Class,Par):- /* 1990.06.18 */
        !,                                         /* 1990.06.18 */
        reg_wss_def(V0,V1,Result,REST,Par),        /* 1990.06.18 */
        module_facility(V1,V2,REST,Class,Par).     /* 1990.06.18 */

module_facility([mem|V0],V2,Result,Class,Par):-
        !,
        atom_value_read(op_mode,Op_mode),
        if_else(
            eq(Op_mode,loose),
            and(
                dispf('??? mem cannot be used for module facility.\n'),
                fail
            )
        ),
        mems_def(V0,V1,Result,REST,Par),
        module_facility(V1,V2,REST,Class,Par).
module_facility([submod,Name|V0],V2,[Output|REST],Class,Par):-
        if_else(
            search(Class,facility(Name,Type,Ptr,Facility,_,_,_,_)),

            /** 1990.05.25 **
            if_then_else(
                or(
                    eq(Name,instruct_arg),
                    eq(Name,instr_arg),
                    eq(Name,stage_name),
                    eq(Name,instruct),
                    eq(Name,stage)
                ),
                fail,
                and(
                    display('??? The class name: '),
                    display(Name),
                    display(' is not defined.'),
                    nl,
                    cut(3),
                    fail
                )
            )
            **/
            fail    /** 1990.05.25 **/

        ),
        !,
        module_facility1(Type,V0,V1,Ptr,Facility,Output,Par,Name),
        module_facility1s_rest(V1,V2,Type,Ptr,Facility,REST,Class,Par,Name).
module_facility([Name|V0],V2,[Output|REST],Class,Par):-
        if_else(
            search(Class,facility(Name,Type,Ptr,Facility,_,_,_,_)),

            /** 1990.05.25 **
            if_then_else(
                or(
                    eq(Name,instruct_arg),
                    eq(Name,instr_arg),
                    eq(Name,stage_name),
                    eq(Name,instruct),
                    eq(Name,stage)
                ),
                fail,
                and(
                    display('??? The class name: '),
                    display(Name),
                    display(' is not defined.'),
                    nl,
                    cut(3),
                    fail
                )
            )
            **/
            fail    /** 1990.05.25 **/

        ),
        !,
        module_facility1(Type,V0,V1,Ptr,Facility,Output,Par,Name),
        module_facility1s_rest(V1,V2,Type,Ptr,Facility,REST,Class,Par,Name).
module_facility(V,V,[],_,_).
/*-------------------------------------------*/
module_facility1s_rest([','|V0],
                       V2,
                       Type,
                       Ptr,
                       Facility,
                       [Output|REST],
                       Class,
                       Par,
                       C_Name):-
        !,
        module_facility1(Type,V0,V1,Ptr,Facility,Output,Par,C_Name),
        module_facility1s_rest(V1,V2,Type,Ptr,Facility,REST,Class,Par,C_Name).
module_facility1s_rest([';'|V0],V1,_,_,_,REST,Class,Par,_):-
        module_facility(V0,V1,REST,Class,Par).
/*-------------------------------------------*/
module_facility1(submod_class,
                 [Name|Y],
                 Y,
                 PPtr,
                 FFacility,
                 facility(Name,submod,Ptr,Facility,C_Name,_,_,_),
                 Par,
                 C_Name):-
        !,
        alpha_name(Name),
        submod_def(Ptr,Name,PPtr,Par),
        copy_submod_fac(FFacility,Facility,Instrins,Ptr),           /* 1991.01.24 */
/**/    hash(Facility),                                             /* 1991.01.24 */
        copy_submod_instr(Instrins,Facility).                       /* 1991.01.24 */
module_facility1(circuit_class,
                 [Name|Y],
                 Y,
                 PPtr,
                 FFacility,
                 facility(Name,circuit,Ptr,Facility,C_Name,_,_,_),
                 Par,
                 C_Name):-
        alpha_name(Name),
        circuit_def(Ptr,Name,PPtr,Par),
        copy_circuit_fac(FFacility,Facility,Instrins,Ptr),
/**/    hash(Facility),
        copy_circuit_instr(Instrins,Facility).
/*-------------------------------------------*/
/********************************************************           /* 1991.01.24 */
copy_submod_fac([facility(Name,Type,_,P4,P5,_,_,_)|S2],
                [facility(Name,Type,PPtr,PP4,PP5,_,_,_)|D2],Par):-
        !,
        copy_submod_type(Type,P4,PP4,P5,PP5),
        trns_fac_exp(
            [GET_FACILITY,
            Par,
            Name],
            PPtr,
            [get_facility,Name]
        ),
        copy_submod_fac(S2,D2,Par).
copy_submod_fac([],[],_).
/*-------------------------------------------*/
copy_submod_type(input,P4,P4,_,_):-!.
copy_submod_type(output,P4,P4,_,_):-!.
copy_submod_type(bidirect,P4,P4,_,_):-!.
copy_submod_type(instrin,_,_,_,none):-!.
copy_submod_type(instrout,_,[],_,_).
********************************************************/           /* 1991.01.24 */
/*-------------------------------------------*/                     /* 1991.01.24 */
copy_submod_fac([facility(Name,Type,_,P4,_,_,_,_)|S2],              /* 1991.01.24 */
                 Facility,                                          /* 1991.01.24 */
                 Instrins,                                          /* 1991.01.24 */
                 Par):-                                             /* 1991.01.24 */
        !,                                                          /* 1991.01.24 */
        copy_submod_fac1(Type,                                      /* 1991.01.24 */
                          Name,                                     /* 1991.01.24 */
                          P4,                                       /* 1991.01.24 */
                          Rest,                                     /* 1991.01.24 */
                          Facility,                                 /* 1991.01.24 */
                          Instrins_rest,                            /* 1991.01.24 */
                          Instrins,                                 /* 1991.01.24 */
                          Par),                                     /* 1991.01.24 */
        copy_submod_fac(S2,Rest,Instrins_rest,Par).                 /* 1991.01.24 */
copy_submod_fac([],[],[],_).                                        /* 1991.01.24 */
/*-------------------------------------------*/                     /* 1991.01.24 */
copy_submod_fac1(input,Name,Width,                                  /* 1991.01.24 */
                  IN,                                               /* 1991.01.24 */
                  [facility(Name,input,PPtr,Width,_,_,_,_)|IN],     /* 1991.01.24 */
                  Y,Y,Par):-                                        /* 1991.01.24 */
        !,                                                          /* 1991.01.24 */
        trns_fac_exp(                                               /* 1991.01.24 */
            [1,                                        /* 1991.01.24 */
            Par,                                                    /* 1991.01.24 */
            Name],                                                  /* 1991.01.24 */
            PPtr,                                                   /* 1991.01.24 */
            [get_facility,Name]                                     /* 1991.01.24 */
        ).                                                          /* 1991.01.24 */
copy_submod_fac1(output,Name,Width,                                 /* 1991.01.24 */
                  IN,                                               /* 1991.01.24 */
                  [facility(Name,output,PPtr,Width,_,_,_,_)|IN],    /* 1991.01.24 */
                  Y,Y,Par):-                                        /* 1991.01.24 */
        !,                                                          /* 1991.01.24 */
        trns_fac_exp(                                               /* 1991.01.24 */
            [1,                                        /* 1991.01.24 */
            Par,                                                    /* 1991.01.24 */
            Name],                                                  /* 1991.01.24 */
            PPtr,                                                   /* 1991.01.24 */
            [get_facility,Name]                                     /* 1991.01.24 */
        ).                                                          /* 1991.01.24 */
copy_submod_fac1(bidirect,Name,Width,                               /* 1991.01.24 */
                  IN,                                               /* 1991.01.24 */
                  [facility(Name,bidirect,PPtr,Width,_,_,_,_)|IN],  /* 1991.01.24 */
                  Y,Y,Par):-                                        /* 1991.01.24 */
        !,                                                          /* 1991.01.24 */
        trns_fac_exp(                                               /* 1991.01.24 */
            [1,                                        /* 1991.01.24 */
            Par,                                                    /* 1991.01.24 */
            Name],                                                  /* 1991.01.24 */
            PPtr,                                                   /* 1991.01.24 */
            [get_facility,Name]                                     /* 1991.01.24 */
        ).                                                          /* 1991.01.24 */
copy_submod_fac1(instrout,Name,_,                                   /* 1991.01.24 */
                  IN,                                               /* 1991.01.24 */
                  [facility(Name,instrout,PPtr,[],BEH,_,_,_)|IN],   /* 1991.01.24 */
                  Y,Y,Par):-                                        /* 1991.01.24 */
        !,                                                          /* 1991.01.24 */
        trns_fac_exp(                                               /* 1991.01.24 */
            [1,                                        /* 1991.01.24 */
            Par,                                                    /* 1991.01.24 */
            Name],                                                  /* 1991.01.24 */
            PPtr,                                                   /* 1991.01.24 */
            [get_facility,Name]                                     /* 1991.01.24 */
        ).                                                          /* 1991.01.24 */
copy_submod_fac1(instrin,Name,ARG,                                  /* 1991.01.24 */
                  IN,                                               /* 1991.01.24 */
                  [facility(Name,instrin,PPtr,AARG,none,_,_,_)|IN], /* 1991.01.24 */
                  Y,                                                /* 1991.01.24 */
                  [set(Name,ARG)|Y],Par):-                          /* 1991.01.24 */
        trns_fac_exp(                                               /* 1991.01.24 */
            [1,                                        /* 1991.01.24 */
            Par,                                                    /* 1991.01.24 */
            Name],                                                  /* 1991.01.24 */
            PPtr,                                                   /* 1991.01.24 */
            [get_facility,Name]                                     /* 1991.01.24 */
        ).                                                          /* 1991.01.24 */
/*------------------------*/                                        /* 1991.01.24 */
copy_submod_instr([set(Name,ARG)|I2],Facility):-                    /* 1991.01.24 */
        !,                                                          /* 1991.01.24 */
        search(Facility,facility(Name,instrin,_,AARG,_,_,_,_)),     /* 1991.01.24 */
        copy_submod_instr1(ARG,AARG,Facility),                      /* 1991.01.24 */
        copy_submod_instr(I2,Facility).                             /* 1991.01.24 */
copy_submod_instr([],_).                                            /* 1991.01.24 */
/*------------------------*/                                        /* 1991.01.24 */
copy_submod_instr1(VAR,_,_):-                                       /* 1991.01.24 */
        var(VAR),                                                   /* 1991.01.24 */
        !.                                                          /* 1991.01.24 */
copy_submod_instr1(                                                 /* 1991.01.24 */
        [facility(Name,_,_,_,_,_,_,_)|S2],                          /* 1991.01.24 */
        [Argument|D2],                                              /* 1991.01.24 */
        Facility                                                    /* 1991.01.24 */
        ):-                                                         /* 1991.01.24 */
        !,                                                          /* 1991.01.24 */
        search(Facility,facility(Name,_,_,_,_,_,_,_),Argument),     /* 1991.01.24 */
        copy_submod_instr1(S2,D2,Facility).                         /* 1991.01.24 */
copy_submod_instr1([],[],_).                                        /* 1991.01.24 */
/*-------------------------------------------*/
copy_circuit_fac([facility(Name,Type,_,P4,_,_,_,_)|S2],
                 Facility,
                 Instrins,
                 Par):-
        !,
        copy_circuit_fac1(Type,
                          Name,
                          P4,
                          Rest,
                          Facility,
                          Instrins_rest,
                          Instrins,
                          Par),
        copy_circuit_fac(S2,Rest,Instrins_rest,Par).
copy_circuit_fac([],[],[],_).
/*-------------------------------------------*/
copy_circuit_fac1(tmp_org(_),_,_,IN,IN,In1,In1,_):-!.
copy_circuit_fac1(bus_org,_,_,IN,IN,In1,In1,_):-!.
copy_circuit_fac1(sel_org,_,_,IN,IN,In1,In1,_):-!.
copy_circuit_fac1(reg,_,_,IN,IN,In1,In1,_):-!.

copy_circuit_fac1(reg_wr,_,_,IN,IN,In1,In1,_):-!. /* 1990.05.29 */

copy_circuit_fac1(reg_ws,_,_,IN,IN,In1,In1,_):-!. /* 1990.06.18 */

copy_circuit_fac1(mem,_,_,IN,IN,In1,In1,_):-!.
copy_circuit_fac1(input,Name,Width,
                  IN,
                  [facility(Name,input,PPtr,Width,_,_,_,_)|IN],
                  Y,Y,Par):-
        !,
        trns_fac_exp(
            [1,
            Par,
            Name],
            PPtr,
            [get_facility,Name]
        ).
copy_circuit_fac1(output,Name,Width,
                  IN,
                  [facility(Name,output,PPtr,Width,_,_,_,_)|IN],
                  Y,Y,Par):-
        !,
        trns_fac_exp(
            [1,
            Par,
            Name],
            PPtr,
            [get_facility,Name]
        ).
copy_circuit_fac1(bidirect,Name,Width,
                  IN,
                  [facility(Name,bidirect,PPtr,Width,_,_,_,_)|IN],
                  Y,Y,Par):-
        !,
        trns_fac_exp(
            [1,
            Par,
            Name],
            PPtr,
            [get_facility,Name]
        ).
copy_circuit_fac1(instrin,Name,ARG,
                  IN,
                  [facility(Name,instrin,PPtr,AARG,none,_,_,_)|IN],
                  Y,
                  [set(Name,ARG)|Y],Par):-
        trns_fac_exp(
            [1,
            Par,
            Name],
            PPtr,
            [get_facility,Name]
        ).
/*------------------------*/
copy_circuit_instr([set(Name,ARG)|I2],Facility):-
        !,
        search(Facility,facility(Name,instrin,_,AARG,_,_,_,_)),
        copy_circuit_instr1(ARG,AARG,Facility),
        copy_circuit_instr(I2,Facility).
copy_circuit_instr([],_).
/*------------------------*/
copy_circuit_instr1(VAR,[],_):-
        var(VAR),
        !.
copy_circuit_instr1(
        [facility(Name,_,_,_,_,_,_,_)|S2],
        [Argument|D2],
        Facility
        ):-
        !,
        search(Facility,facility(Name,_,_,_,_,_,_,_),Argument),
        copy_circuit_instr1(S2,D2,Facility).
copy_circuit_instr1([],[],_).
/******* inst arg def ***********************/
instr_arg_def([instruct_arg,Name|V0],V3,Facility):-
        !,
        if_else(
            search(Facility,facility(Name,Type,P3,P4,_,_,_,_)),
            and(
                display('??? The instrout or instrself or submodule name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        instr_arg_def1(Type,V0,V1,Facility,P3,P4),
        ';'(V1,V2),
        instr_arg_def(V2,V3,Facility).
instr_arg_def([instr_arg,Name|V0],V3,Facility):-
        !,
        if_else(
            search(Facility,facility(Name,Type,P3,P4,_,_,_,_)),
            and(
                display('??? The instrout or instrself or submodule name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        instr_arg_def1(Type,V0,V1,Facility,P3,P4),
        ';'(V1,V2),
        instr_arg_def(V2,V3,Facility).
instr_arg_def(V,V,_).
/*---------------------------------------------*/
instr_arg_def1(instrself,['('|V0],V2,Facility,Ptr,ARG):-
        !,
        instr_arg_terms(V0,V1,ARG,Facility,Number,Ptrs),
        ')'(V1,V2),
        instr_def_second(Ptr,Number,Ptrs).
instr_arg_def1(instrout,['('|V0],V2,Facility,Ptr,ARG):-
        !,
        instr_arg_outbis(V0,V1,ARG,Facility,Number,Ptrs),
        ')'(V1,V2),
        instr_def_second(Ptr,Number,Ptrs).
instr_arg_def1(submod,['.',Name,'('|V0],V2,_,_,Facility):-
        if_else(
            search(Facility,facility(Name,instrin,Ptr,ARG,_,_,_,_)),
            and(
                display('??? The submodule instrin name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        if_then_else(                                               /* 1991.01.24 */
            var(ARG),                                               /* 1991.01.24 */
            and(                                                    /* 1991.01.24 */
                instr_arg_inbis(V0,V1,ARG,Facility,Number,Ptrs),    /* 1991.01.24 */
                ')'(V1,V2),                                         /* 1991.01.24 */
                instr_def_second(Ptr,Number,Ptrs)                   /* 1991.01.24 */
            ),                                                      /* 1991.01.24 */
            and(                                                    /* 1991.01.24 */
                display('??? The submodule instrin ('),             /* 1991.01.24 */
                display(Name),                                      /* 1991.01.24 */
                display(') arguments are already defined.'),        /* 1991.01.24 */
                nl,                                                 /* 1991.01.24 */
                fail                                                /* 1991.01.24 */
            )                                                       /* 1991.01.24 */
        ).                                                          /* 1991.01.24 */
/*----------------------------*/
instr_arg_terms([Name|V0],
                V1,
                [Argument|REST],
                Facility,
                Num1,
                [Ptr|Ptrs_rest]):-
        if_else(
            or(
                search(Facility,facility(Name,output,Ptr,_,_,_,_,_),Argument),      /* 1990.12.12 */
                search(Facility,facility(Name,bidirect,Ptr,_,_,_,_,_),Argument),    /* 1990.12.12 */
                search(Facility,facility(Name,tmp_org(_),Ptr,_,_,_,_,_),Argument),
                search(Facility,facility(Name,bus_org,Ptr,_,_,_,_,_),Argument),
                search(Facility,facility(Name,sel_org,Ptr,_,_,_,_,_),Argument)
            ),
            if_then_else(
                eq(Name,')'),
                fail,
                and(
                    display('??? The argument tmp or term name: '),
                    display(Name),
                    display(' is not defined.'),
                    nl,
                    fail
                )
            )
        ),
        !,
        instr_arg_terms1(V0,V1,REST,Facility,Num,Ptrs_rest),
        add1(Num,Num1).
instr_arg_terms(V,V,[],_,0,[]).
/*----------------------------*/
instr_arg_terms1([',',Name|V0],
                 V1,
                 [Argument|REST],
                 Facility,
                 Num1,
                 [Ptr|Ptrs_rest]):-
        !,
        if_else(
            or(
                search(Facility,facility(Name,output,Ptr,_,_,_,_,_),Argument),      /* 1990.12.12 */
                search(Facility,facility(Name,bidirect,Ptr,_,_,_,_,_),Argument),    /* 1990.12.12 */
                search(Facility,facility(Name,tmp_org(_),Ptr,_,_,_,_,_),Argument),
                search(Facility,facility(Name,bus_org,Ptr,_,_,_,_,_),Argument),
                search(Facility,facility(Name,sel_org,Ptr,_,_,_,_,_),Argument)
            ),
            and(
                display('??? The argument tmp or term name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        instr_arg_terms1(V0,V1,REST,Facility,Num,Ptrs_rest),
        add1(Num,Num1).
instr_arg_terms1(V,V,[],_,0,[]).
/*----------------------------*/
instr_arg_outbis([Name|V0],
                 V1,
                 [Argument|REST],
                 Facility,
                 Num1,
                 [Ptr|Ptrs_rest]):-
        if_else(
            search(Facility,facility(Name,Type,Ptr,_,_,_,_,_),Argument),
            if_then_else(
                eq(Name,')'),
                fail,
                and(
                    display('??? The argument output or bidirect name: '),
                    display(Name),
                    display(' is not defined.'),
                    nl,
                    fail
                )
            )
        ),
        !,
        type_outbi(Type),
        instr_arg_outbis1(V0,V1,REST,Facility,Num,Ptrs_rest),
        add1(Num,Num1).
instr_arg_outbis(V,V,[],_,0,[]).
/*----------------------------*/
instr_arg_outbis1([',',Name|V0],
                  V1,
                  [Argument|REST],
                  Facility,
                  Num1,
                  [Ptr|Ptrs_rest]):-
        !,
        if_else(
            search(Facility,facility(Name,Type,Ptr,_,_,_,_,_),Argument),
            and(
                display('??? The argument output or bidirect name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        type_outbi(Type),
        instr_arg_outbis1(V0,V1,REST,Facility,Num,Ptrs_rest),
        add1(Num,Num1).
instr_arg_outbis1(V,V,[],_,0,[]).
/*----------------------------*/
instr_arg_inbis([Name|V0],
                V1,
                [Argument|REST],
                Facility,
                Num1,
                [Ptr|Ptrs_rest]):-
        if_else(
            search(Facility,facility(Name,Type,Ptr,_,_,_,_,_),Argument),
            if_then_else(
                eq(Name,')'),
                fail,
                and(
                    display('??? The argument input or bidirect name: '),
                    display(Name),
                    display(' is not defined.'),
                    nl,
                    fail
                )
            )
        ),
        !,
        type_inbi(Type),
        instr_arg_inbis1(V0,V1,REST,Facility,Num,Ptrs_rest),
        add1(Num,Num1).
instr_arg_inbis(V,V,[],_,0,[]).
/*----------------------------*/
instr_arg_inbis1([',',Name|V0],
                 V1,
                 [Argument|REST],
                 Facility,
                 Num1,
                 [Ptr|Ptrs_rest]):-
        !,
        if_else(
            search(Facility,facility(Name,Type,Ptr,_,_,_,_,_),Argument),
            and(
                display('??? The argument input or bidirect name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        type_inbi(Type),
        instr_arg_inbis1(V0,V1,REST,Facility,Num,Ptrs_rest),
        add1(Num,Num1).
instr_arg_inbis1(V,V,[],_,0,[]).
/*----------------------------*/
type_outbi(output):-!.
type_outbi(bidirect).
/*----------------------------*/
type_inbi(input):-!.
type_inbi(bidirect).
/******* stage,task def task arg def ***********************/
stage_task_def([stage_name,Name,'{'|V3],
          V6,
          [facility(Name,stage,Ptr,Task,State,Segment,First,BEH)|REST],
          Facility,
          Par):-
        !,
        alpha_name(Name),
        stage_def(Ptr,Name,Par),
        task_arg_def(V3,V4,Task,Facility,Ptr),
/**/    hash(Task),
        '}'(V4,V5),
        stage_task_def(V5,V6,REST,Facility,Par).
stage_task_def(V,V,[],_,_).
/*------ task def ----------------------*/
task_arg_def([task,Name,'('|V3],
             V7,
             [facility(Name,task,Ptr,ARG,_,_,_,_)|REST],
             Facility,
             Par):-
        !,
        alpha_name(Name),
        task_def(Ptr,Name,Par),
        task_arg_regs(V3,V4,ARG,Facility,Number,Ptrs),
        ')'(V4,V5),
        task_def_second(Ptr,Number,Ptrs),
        ';'(V5,V6),
        task_arg_def(V6,V7,REST,Facility,Par).
task_arg_def(V,V,[],_,_).
/*----------------------------*/
task_arg_regs([Name|V0],
              V1,
              [Argument|REST],
              Facility,
              Num1,
              [Ptr|Ptrs_rest]):-
        if_else(

            if_else_else(                                                      /* 1990.06.19 */
                search(Facility,facility(Name,reg,Ptr,_,_,_,_,_),Argument),    /* 1990.06.19 */
                search(Facility,facility(Name,reg_wr,Ptr,_,_,_,_,_),Argument), /* 1990.06.19 */
                search(Facility,facility(Name,reg_ws,Ptr,_,_,_,_,_),Argument)  /* 1990.06.19 */
            ),                                                                 /* 1990.06.19 */

            if_then_else(
                eq(Name,')'),
                fail,
                and(
                    display('??? The argument reg name: '),
                    display(Name),
                    display(' is not defined.'),
                    nl,
                    fail
                )
            )
        ),
        !,
        task_arg_regs1(V0,V1,REST,Facility,Num,Ptrs_rest),
        add1(Num,Num1).
task_arg_regs(V,V,[],_,0,[]).
/*----------------------------*/
task_arg_regs1([',',Name|V0],
               V1,
               [Argument|REST],
               Facility,
               Num1,
               [Ptr|Ptrs_rest]):-
        !,
        if_else(

            if_else_else(                                                      /* 1990.06.19 */
                search(Facility,facility(Name,reg,Ptr,_,_,_,_,_),Argument),    /* 1990.06.19 */
                search(Facility,facility(Name,reg_wr,Ptr,_,_,_,_,_),Argument), /* 1990.06.19 */
                search(Facility,facility(Name,reg_ws,Ptr,_,_,_,_,_),Argument)  /* 1990.06.19 */
            ),                                                                 /* 1990.06.19 */

            and(
                display('??? The argument reg name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        task_arg_regs1(V0,V1,REST,Facility,Num,Ptrs_rest),
        add1(Num,Num1).
task_arg_regs1(V,V,[],_,0,[]).
/******* inst beh ***********************/
instr_behavior([instruct,Name|V0],V2,Facility,Stage):-
        !,
        if_else(
            search(Facility,facility(Name,Type,P3,P4,P5,_,_,_)),
            and(
                display('??? The instrin or instrself or submodule name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        instr_behavior1(Type,V0,V1,Facility,Stage,P3,P4,P5),
        instr_behavior(V1,V2,Facility,Stage).
instr_behavior(V,V,_,_).
/*----------------------------*/
instr_behavior1(instrin,V0,V1,Facility,Stage,Ptr,_,BEH):-
        !,
        behavior(V0,
                 V1,
                 1,
                 _,
                 BEH,
                 Facility,
                 Stage,
                 notin_stage,
                 notin_segment,
                 [],
                 [],
                 Ptr).
instr_behavior1(instrself,V0,V1,Facility,Stage,Ptr,_,BEH):-
        !,
        behavior(V0,
                 V1,
                 1,
                 _,
                 BEH,
                 Facility,
                 Stage,
                 notin_stage,
                 notin_segment,
                 [],
                 [],
                 Ptr).
instr_behavior1(submod,['.',Name|V0],V1,Facility,Stage,_,FFacility,_):-
        if_else(
            search(FFacility,facility(Name,instrout,Ptr,_,BEH,_,_,_)),
            and(
                display('??? The submodule instrout name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        behavior(V0,
                 V1,
                 1,
                 _,
                 BEH,
                 Facility,
                 Stage,
                 notin_stage,
                 notin_segment,
                 [],
                 [],
                 Ptr).
/******* state,segment def stage beh ***********************/
stage_segment_state_def([stage,Name,'{'|V3],V13,Facility,Stage):-
        !,
        if_else(
            search(Stage,facility(Name,stage,Ptr,Task,State,Segment,First,BEH)),
            and(
                display('??? The stage name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        states_def(V3,V4,State,Ptr),
/**/    hash(State),
        segments_def(V4,V5,Segment,Ptr),
/**/    hash(Segment),
        first_state_chk(V5,V7,State,First),
        stage_def_second(Ptr,First),
        stage_beh(V7,V9,BEH,Facility,Stage,State,Segment,Ptr,Name),
        state_beh(V9,V10,Facility,Stage,State,Segment,Ptr,Name),
        segment_state_def(V10,V11,Facility,Stage,Segment,Ptr,Name),
        '}'(V11,V12),
        display('Behavior of stage: '),display(Name),display(' defined.'),nl,
        stage_segment_state_def(V12,V13,Facility,Stage).
stage_segment_state_def(V,V,_,_).
/*------ state def ----------------------*/
states_def([state_name,Name|V0],
           V1,
           [facility(Name,state,Ptr,BEH,Fst,_,_,_)|REST],
           Par):-
        !,
        alpha_name(Name),
        state_def(Ptr,Name,Par),
        states_def_rest(V0,V1,REST,Par).
states_def(V,V,[],_).
/*----------------------------*/
states_def_rest([',',Name|V0],
                V1,
                [facility(Name,state,Ptr,BEH,Fst,_,_,_)|REST],
                Par):-
        !,
        alpha_name(Name),
        state_def(Ptr,Name,Par),
        states_def_rest(V0,V1,REST,Par).
states_def_rest([';'|V0],V1,REST,Par):-
        states_def(V0,V1,REST,Par).
/*------ segment def ----------------------*/
segments_def([segment_name,Name|V0],
             V1,
             [facility(Name,segment,Ptr,State,First,BEH,_,_)|REST],
             Par):-
        !,
        alpha_name(Name),
        segment_def(Ptr,Name,Par),
        segments_def_rest(V0,V1,REST,Par).
segments_def(V,V,[],_).
/*----------------------------*/
segments_def_rest([',',Name|V0],
                  V1,
                  [facility(Name,segment,Ptr,State,First,BEH,_,_)|REST],
                  Par):-
        !,
        alpha_name(Name),
        segment_def(Ptr,Name,Par),
        segments_def_rest(V0,V1,REST,Par).
segments_def_rest([';'|V0],V1,REST,Par):-
        segments_def(V0,V1,REST,Par).
/*------ first state ----------------------*/
first_state_chk(['first_state',Name,';'|Y],Y,State,Argument):-
        !,                              /* 1990.10.29 */
        if_else(
            search(State,facility(Name,state,_,_,_,_,_,_),Argument),
            and(
                display('??? The state name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        first_state_set(State,Name).
first_state_chk(Y,Y,[],[]).             /* 1990.10.29 */
/*------ first state set ----------------------*/
first_state_set([facility(Name,state,_,_,t,_,_,_)|REST],Name):-
    !,
    first_state_set(REST,Name).
first_state_set([facility(_,state,_,_,f,_,_,_)|REST],Name):-
    !,
    first_state_set(REST,Name).
first_state_set([],_).
/*------ stage beh ----------------------*/
/* stage_beh(V0,V1,[BEH],Facility,Stage,_/*State*/,_/*Segment*/,Ptr,STG_name):- */
stage_beh(V0,V1,BEH,Facility,Stage,_/*State*/,_/*Segment*/,Ptr,STG_name):-
        behavior(V0,              /* henkou     henkou */
                 V1,
                 1,
                 _,
                 BEH,
                 Facility,
                 Stage,
                 current_stage(Ptr,STG_name),
                 notin_segment,
                 [], /* State, <--- hontouka ????? [] ni henkousita */
                 [], /* Segment, <--- hontouka ????? [] ni henkousita */
                 Ptr),
        !.
/* stage_beh(V,V,[],_,_,_,_,_,_). */
stage_beh(V,V,none,_,_,_,_,_,_).
/*------ state beh ----------------------*/
state_beh([state,NName|V2],V4,Facility,Stage,State,Segment,Ptr,STG_name):-
        !,
        if_else(
            search(State,facility(NName,state,PPtr,BBEH,_,_,_,_)),
            and(
                display('??? The state name: '),
                display(NName),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        behavior(V2,
                 V3,
                 1,
                 _,
                 BBEH,
                 Facility,
                 Stage,
                 current_stage(Ptr,STG_name),
                 notin_segment,
                 State,
                 Segment,
                 PPtr),
        state_beh(V3,V4,Facility,Stage,State,Segment,Ptr,STG_name).
state_beh(V,V,_,_,_,_,_,_).
/*------ segment state def segment beh ----------------------*/
segment_state_def([segment,NName,'{'|V3],V11,Facility,Stage,Segment,Ptr,STG_name):-
        !,
        if_else(
            search(Segment,facility(NName,segment,PPtr,SState,FFirst,BBEH,_,_)),
            and(
                display('??? The segment name: '),
                display(NName),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        states_def(V3,V4,SState,PPtr),
/**/    hash(SState),
        first_state_chk(V4,V6,SState,FFirst),
        segment_def_second(PPtr,FFirst),
        segment_beh(V6,V8,BBEH,Facility,Stage,SState,Segment,Ptr,PPtr,STG_name,NName),
        segment_state_beh(V8,V9,Facility,Stage,SState,Segment,Ptr,PPtr,STG_name,NName),
        '}'(V9,V10),
        segment_state_def(V10,V11,Facility,Stage,Segment,Ptr,STG_name).
segment_state_def(V,V,_,_,_,_,_).
/*--    --segment beh--     --*/
/* segment_beh(V0,V1,[BBEH],Facility,Stage,_/*SState*/,_/*Segment*/,Ptr,PPtr,STG_name,SEG_name):- */
segment_beh(V0,V1,BBEH,Facility,Stage,_/*SState*/,_/*Segment*/,Ptr,PPtr,STG_name,SEG_name):-
        behavior(V0,                 /* henkou      henkou */
                 V1,
                 1,
                 _,
                 BBEH,
                 Facility,
                 Stage,
                 current_stage(Ptr,STG_name),
                 current_segment(PPtr,SEG_name),
                 [], /* SState, <--- hontouka ????? [] ni henkousita */
                 [], /* Segment, <--- hontouka ????? [] ni henkousita */
                 PPtr),
        !.
/* segment_beh(V,V,[],_,_,_,_,_,_,_,_). */
segment_beh(V,V,none,_,_,_,_,_,_,_,_).
/*--    --segment state beh--     --*/
segment_state_beh([state,NNName|V2],V4,Facility,Stage,SState,Segment,Ptr,PPtr,STG_name,SEG_name):-
        !,
        if_else(
            search(SState,facility(NNName,state,PPPtr,BBBEH,_,_,_,_)),
            and(
                display('??? The state name: '),
                display(NNName),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        behavior(V2,
                 V3,
                 1,
                 _,
                 BBBEH,
                 Facility,
                 Stage,
                 current_stage(Ptr,STG_name),
                 current_segment(PPtr,SEG_name),
                 SState,
                 Segment,
                 PPPtr),
        segment_state_beh(V3,V4,Facility,Stage,SState,Segment,Ptr,PPtr,STG_name,SEG_name).
segment_state_beh(V,V,_,_,_,_,_,_,_,_).

/******************************/
/*         behavior           */
/******************************/
behavior([par,'{'|V0],
         V2,
         I,
         O,
         facility(I,par,Ptr,BEHS,_,_,_,_),
         Facility,
         Stage,
         C_stage,
         C_segment,
         State,
         Segment,
         Par):-
        !,
        block_par_def(Ptr,I,Par),
        behaviors(V0,
                  V1,
                  1,
                  BEHS,
                  Facility,
                  Stage,
                  C_stage,
                  C_segment,
                  State,
                  Segment,
                  Ptr),
        '}'(V1,V2),
        add1(I,O).
behavior([if,'('|V0],
         V1,
         I,
         O,
         facility(I,alt,Ptr,BEHS,_,_,_,_),
         Facility,
         Stage,
         C_stage,
         C_segment,
         State,
         Segment,
         Par):-
        !,
        stmnt_alt_def(Ptr,I,Par),
        if_behaviors(V0,
                    V1,
                    BEHS,
                    Facility,
                    Stage,
                    C_stage,
                    C_segment,
                    State,
                    Segment,
                    Ptr),
        add1(I,O).
behavior([alt,'{'|V0],
         V3,
         I,
         O,
         facility(I,alt,Ptr,BEHS,_,_,_,_),
         Facility,
         Stage,
         C_stage,
         C_segment,
         State,
         Segment,
         Par):-
        !,
        stmnt_alt_def(Ptr,I,Par),
        exp_behaviors(V0,
                    V1,
                    1,
                    R,
                    ELSE_BEH,
                    BEHS,
                    Facility,
                    Stage,
                    C_stage,
                    C_segment,
                    State,
                    Segment,
                    Ptr),
        else_behavior(V1,
                    V2,
                    R,
                    ELSE_BEH,
                    Facility,
                    Stage,
                    C_stage,
                    C_segment,
                    State,
                    Segment,
                    Ptr),
        '}'(V2,V3),
        add1(I,O).
behavior([any,'{'|V0],
         V3,
         I,
         O,
         facility(I,any,Ptr,BEHS,_,_,_,_),
         Facility,
         Stage,
         C_stage,
         C_segment,
         State,
         Segment,
         Par):-
        !,
        stmnt_any_def(Ptr,I,Par),
        exp_behaviors(V0,
                    V1,
                    1,
                    R,
                    ELSE_BEH,
                    BEHS,
                    Facility,
                    Stage,
                    C_stage,
                    C_segment,
                    State,
                    Segment,
                    Ptr),
        else_behavior(V1,
                    V2,
                    R,
                    ELSE_BEH,
                    Facility,
                    Stage,
                    C_stage,
                    C_segment,
                    State,
                    Segment,
                    Ptr),
        '}'(V2,V3),
        add1(I,O).
behavior(V0,
         V2,
         I,
         O,
         facility(I,simple,Ptr,EXPAND,OP,HSL_OP,_,_),
         Facility,
         Stage,
         C_stage,
         C_segment,
         State,
         Segment,
         Par):-
/***/   operation(V0,V1,OP,Facility,Stage,C_stage,C_segment,State,Segment,EXPAND,HSL_OP),
        ';'(V1,V2),
        stmnt_simple_def(Ptr,I,Par,OP),
        add1(I,O).
/*----------------------------*/
behaviors(V0,
          V2,
          I,
          [BEH|REST],
          Facility,
          Stage,
          C_stage,
          C_segment,
          State,
          Segment,
          Par):-
        behavior(V0,
                 V1,
                 I,
                 O,
                 BEH,
                 Facility,
                 Stage,
                 C_stage,
                 C_segment,
                 State,
                 Segment,
                 Par),
        !,
        behaviors(V1,
                  V2,
                  O,
                  REST,
                  Facility,
                  Stage,
                  C_stage,
                  C_segment,
                  State,
                  Segment,
                  Par).
behaviors(V,V,_,[],_,_,_,_,_,_,_).
/*----------------------------*/
if_behaviors(V0,
              V3,
              [facility(1,condition,Ptr,Value,BEH,EXPAND,Exp,_)],
              Facility,
              Stage,
              C_stage,
              C_segment,
              State,
              Segment,
              Par):-
/***/   exp(V0,V1,Exp,Facility,Stage,Value,EXPAND),
        ')'(V1,V2),
        !,
        if_else(
            eq(Value,pin(_,1,_)),
            and(
                display('??? The condition bit size is not 1.'),
                nl,
                fail
            )
        ),
        clause_if_def(Ptr,1,Par,Exp),
        behavior(V2,
                 V3,
                 1,
                 _,
                 BEH,
                 Facility,
                 Stage,
                 C_stage,
                 C_segment,
                 State,
                 Segment,
                 Ptr).
/*----------------------------*/
exp_behaviors(V0,
              V4,
              I,
              O,
              ELSE_BEH,
              [facility(I,condition,Ptr,Value,BEH,EXPAND,Exp,_)|REST],
              Facility,
              Stage,
              C_stage,
              C_segment,
              State,
              Segment,
              Par):-
/***/   exp(V0,V1,Exp,Facility,Stage,Value,EXPAND),
        ':'(V1,V2),
        !,
        if_else(
            eq(Value,pin(_,1,_)),
            and(
                display('??? The condition bit size is not 1.'),
                nl,
                fail
            )
        ),
        clause_if_def(Ptr,I,Par,Exp),
        behavior(V2,
                 V3,
                 1,
                 _,
                 BEH,
                 Facility,
                 Stage,
                 C_stage,
                 C_segment,
                 State,
                 Segment,
                 Ptr),
        add1(I,C),
        exp_behaviors(V3,
                      V4,
                      C,
                      O,
                      ELSE_BEH,
                      REST,
                      Facility,
                      Stage,
                      C_stage,
                      C_segment,
                      State,
                      Segment,
                      Par).
exp_behaviors(V,V,C,C,D,D,_,_,_,_,_,_,_).
/*----------------------------*/
else_behavior([else,':'|V0],
              V1,
              I,
              [facility(I,else,Ptr,BEH,_,_,_,_)],
              Facility,
              Stage,
              C_stage,
              C_segment,
              State,
              Segment,
              Par):-
        !,
        clause_else_def(Ptr,I,Par),
        behavior(V0,
                 V1,
                 1,
                 _,
                 BEH,
                 Facility,
                 Stage,
                 C_stage,
                 C_segment,
                 State,
                 Segment,
                 Ptr).
else_behavior(V,V,_,[],_,_,_,_,_,_,_).

/******************************/
/*          operation         */
/******************************/
/*------goto<state_name_chk>---------------------------------------*/
operation([goto,Name|Y],
          Y,
          [pack(0xd248 ,0,0),Ptr,PPtr],
          _,
          _,
          current_stage(Ptr,STG_name),
          notin_segment,
          State,
          _,
          [net(pin(stage,Sizee,STG_name),pin(state,_,[Name,STG_name]))],
          hsl_op(goto,Name)
        ):-
        !,
        if_else(
            search(State,facility(Name,state,PPtr,_,_,_,_,_)),
            and(
                display('??? The state name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ).
operation([goto,Name|Y],
          Y,
          [pack(0xd248 ,0,0),Ptr,PPtr],
          _,
          _,
          current_stage(Ptr,STG_name),
          current_segment(_,SEG_name),
          State,
          _,
          [net(pin(stage,Sizee,STG_name),pin(state,_,[Name,SEG_name,STG_name]))],
          hsl_op(goto,Name)
        ):-
        !,
        if_else(
            search(State,facility(Name,state,PPtr,_,_,_,_,_)),
            and(
                display('??? The state name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ).
/*------call<segment_name_chk>(<state_name_chk>)--------------------*/
operation([call,Name1,'(',Name2,')'|Y],
          Y,
    /*    [pack(OPR_CALL,0,0),Ptr,First,PPtr,PPPtr], */
          [pack(0xd48a ,0,0),Ptr,0,PPtr,PPPtr],
          _,
          _,
          current_stage(Ptr,STG_name),
          notin_segment,
          State,
          Segment,
          [net(pin(stage,Sizee,STG_name),pin(state,_,[First_name,Name1,STG_name])),
           net(pin(segment,Sizef,[Name1,STG_name]),pin(state,_,[Name2,STG_name]))],
          hsl_op(call,[STG_name,Name1,Name2])
        ):-
        !,
        if_else(
            search(Segment,
                   facility(Name1,
                            segment,
                            PPtr,
                            _,
                            facility(First_name,state,First,_,_,_,_,_),
                            _,
                            _,
                            _)),
            and(
                display('??? The segment name: '),
                display(Name1),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        if_else(
            search(State,facility(Name2,state,PPPtr,_,_,_,_,_)),
            and(
                display('??? The state name: '),
                display(Name2),
                display(' is not defined.'),
                nl,
                fail
            )
        ).
operation([call,Name1,'(',Name2,')'|Y],
          Y,
    /*    [pack(OPR_CALL,0,0),Ptr,First,PPtr,PPPtr], */
          [pack(0xd48a ,0,0),Ptr,0,PPtr,PPPtr],
          _,
          _,
          current_stage(Ptr,STG_name),
          current_segment(_,SEG_name),
          State,
          Segment,
          [net(pin(stage,Sizee,STG_name),pin(state,_,[First_name,Name1,STG_name])),
           net(pin(segment,Sizef,[Name1,STG_name]),pin(state,_,[Name2,SEG_name,STG_name]))],
          hsl_op(call,[STG_name,Name1,Name2])
        ):-
        !,
        if_else(
            search(Segment,
                   facility(Name1,
                            segment,
                            PPtr,
                            _,
                            facility(First_name,state,First,_,_,_,_,_),
                            _,
                            _,
                            _)),
            and(
                display('??? The segment name: '),
                display(Name1),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        if_else(
            search(State,facility(Name2,state,PPPtr,_,_,_,_,_)),
            and(
                display('??? The state name: '),
                display(Name2),
                display(' is not defined.'),
                nl,
                fail
            )
        ).
/*------call<segment_name_chk>()----------------------------------*/
operation([call,Name,'(',')'|Y],
          Y,
    /*    [pack(OPR_CALL,0,0),Ptr,First,PPPtr,PPtr], */
          [pack(0xd48a ,0,0),Ptr,0,PPPtr,PPtr],
          _,
          _,
          current_stage(Ptr,STG_name),
          current_segment(PPtr,SEG_name),
          _,
          Segment,
          [net(pin(stage,Sizee,STG_name),pin(state,_,[First_name,Name,STG_name])),
           net(pin(segment,Sizeff,[Name,STG_name]),pin(segment,Sizef,[SEG_name,STG_name]))],
          hsl_op(through,Name)
        ):-
        !,
        if_else(
            search(Segment,
                   facility(Name,
                            segment,
                            PPPtr,
                            _,
                            facility(First_name,state,First,_,_,_,_,_),
                            _,
                            _,
                            _)),
            and(
                display('??? The segment name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ).
/*------call<segment_name_chk>,<state_name_chk>--------------------*/
operation([call,Name1,',',Name2|Y],
          Y,
    /*    [pack(OPR_CALL,0,0),Ptr,First,PPtr,PPPtr], */
          [pack(0xd48a ,0,0),Ptr,0,PPtr,PPPtr],
          _,
          _,
          current_stage(Ptr,STG_name),
          notin_segment,
          State,
          Segment,
          [net(pin(stage,Sizee,STG_name),pin(state,_,[First_name,Name1,STG_name])),
           net(pin(segment,Sizef,[Name1,STG_name]),pin(state,_,[Name2,STG_name]))],
          hsl_op(call,[STG_name,Name1,Name2])
        ):-
        !,
        if_else(
            search(Segment,
                   facility(Name1,
                            segment,
                            PPtr,
                            _,
                            facility(First_name,state,First,_,_,_,_,_),
                            _,
                            _,
                            _)),
            and(
                display('??? The segment name: '),
                display(Name1),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        if_else(
            search(State,facility(Name2,state,PPPtr,_,_,_,_,_)),
            and(
                display('??? The state name: '),
                display(Name2),
                display(' is not defined.'),
                nl,
                fail
            )
        ).
operation([call,Name1,',',Name2|Y],
          Y,
    /*    [pack(OPR_CALL,0,0),Ptr,First,PPtr,PPPtr], */
          [pack(0xd48a ,0,0),Ptr,0,PPtr,PPPtr],
          _,
          _,
          current_stage(Ptr,STG_name),
          current_segment(_,SEG_name),
          State,
          Segment,
          [net(pin(stage,Sizee,STG_name),pin(state,_,[First_name,Name1,STG_name])),
           net(pin(segment,Sizef,[Name1,STG_name]),pin(state,_,[Name2,SEG_name,STG_name]))],
          hsl_op(call,[STG_name,Name1,Name2])
        ):-
        !,
        if_else(
            search(Segment,
                   facility(Name1,
                            segment,
                            PPtr,
                            _,
                            facility(First_name,state,First,_,_,_,_,_),
                            _,
                            _,
                            _)),
            and(
                display('??? The segment name: '),
                display(Name1),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        if_else(
            search(State,facility(Name2,state,PPPtr,_,_,_,_,_)),
            and(
                display('??? The state name: '),
                display(Name2),
                display(' is not defined.'),
                nl,
                fail
            )
        ).
/*------through<segment_name_chk>----------------------------------*/
operation([through,Name|Y],
          Y,
    /*    [pack(OPR_CALL,0,0),Ptr,First,PPPtr,PPtr], */
          [pack(0xd48a ,0,0),Ptr,0,PPPtr,PPtr],
          _,
          _,
          current_stage(Ptr,STG_name),
          current_segment(PPtr,SEG_name),
          _,
          Segment,
          [net(pin(stage,Sizee,STG_name),pin(state,_,[First_name,Name,STG_name])),
           net(pin(segment,Sizeff,[Name,STG_name]),pin(segment,Sizef,[SEG_name,STG_name]))],
          hsl_op(through,Name)
        ):-
        !,
        if_else(
            search(Segment,
                   facility(Name,
                            segment,
                            PPPtr,
                            _,
                            facility(First_name,state,First,_,_,_,_,_),
                            _,
                            _,
                            _)),
            and(
                display('??? The segment name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ).
/*------return-----------------------------------------------------*/
operation([return|Y],
          Y,
          [pack(0xd249 ,0,0),Ptr,PPtr],
          _,
          _,
          current_stage(Ptr,STG_name),
          current_segment(PPtr,SEG_name),
          _,
          _,
          [net(pin(stage,Sizee,STG_name),pin(segment,Sizef,[SEG_name,STG_name]))],
          hsl_op(return,_)
        ):-
        !.
/*------finish------ changed 88.4.15 ------------------------------*/
operation([finish|Y],
          Y,
          [pack(0xd241 ,0,0),0,0],
          _,
          Stage,
          current_stage(_,STG_name),
          _,
          _,
          _,
          TASK_NET,
          hsl_op(finish,TASK_NET)
        ):-
        !,
        search(Stage,facility(STG_name,stage,_,Task,_,_,_,_)),
        reset_alltask_gen(Task,STG_name,TASK_NET).
/*------generate<stage_name_chk>.<task_name_chk>([<exp>{,<exp>}])--*/
operation([generate,S_Name,'.',T_Name,'('|V5],
          V7,
          [pack(0xd042 ,Argsp,0),0,Ptr,Exps],
          Facility,
          Stage,
          _,
          _,
          _,
          _,        /* changed 88.4.15 */
          [net(pin(task,1,[T_Name,S_Name]),pin(const,1,1)),
           net(pin(task,1,S_Name),pin(const,1,1))|REST],
          hsl_op(generate,[S_Name,T_Name,REST])
        ):-
        !,
        if_else(
            search(Stage,facility(S_Name,stage,_,Task,_,_,_,_)),
            and(
                display('??? The stage name: '),
                display(S_Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        if_else(
            search(Task,facility(T_Name,task,Ptr,ARG,_,_,_,_)),
            and(
                display('??? The task name: '),
                display(T_Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        exps(V5,V6,Exps,Facility,Stage,Values,RESTS),
        ')'(V6,V7),
        list_count(Exps,Args),
        list_count(ARG,Args1),
        if_else(
            eq(Args,Args1),
            and(
                display('??? The argument number is not equal to previous definition.'),
                nl,
                fail
            )
        ),
        add1(Args,Argsp),
        net_gen(ARG,Values,GEN_NET),
        append(RESTS,GEN_NET,REST).
/*------relay<stage_name_chk>.<task_name_chk>([<exp>{,<exp>}])-----*/
operation([relay,S_Name,'.',T_Name,'('|V5],
          V7,
          [pack(0xd043 ,Argsp,0),0,Ptr,Exps],
          Facility,
          Stage,
          current_stage(_,STG_name),
          _,
          _,
          _,
          [net(pin(task,1,[T_Name,S_Name]),pin(const,1,1)),
           net(pin(task,1,S_Name),pin(const,1,1))|REST],
          hsl_op(relay,[S_Name,T_Name,REST1])
        ):-
        !,
        if_else(
            search(Stage,facility(S_Name,stage,_,Task,_,_,_,_)),
            and(
                display('??? The stage name: '),
                display(S_Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        if_else(
            search(Task,facility(T_Name,task,Ptr,ARG,_,_,_,_)),
            and(
                display('??? The task name: '),
                display(T_Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        exps(V5,V6,Exps,Facility,Stage,Values,RESTS),
        ')'(V6,V7),
        list_count(Exps,Args),
        list_count(ARG,Args1),
        if_else(
            eq(Args,Args1),
            and(
                display('??? The argument number is not equal to previous definition.'),
                nl,
                fail
            )
        ),
        add1(Args,Argsp),
        net_gen(ARG,Values,GEN_NET),
        append(RESTS,GEN_NET,REST1),    /* changed 88.4.15 */
        search(Stage,facility(STG_name,stage,_,OWNTask,_,_,_,_)),
        reset_alltask_gen(OWNTask,STG_name,TASK_NET),
        append(TASK_NET,REST1,REST).
/*------<name>...--------------------------------------*/
operation([Name|I],
          O,
          Output,
          Facility,
          Stage,
          _,
          _,
          _,
          _,
          EXPAND,
          hsl_op(other,EXPAND)
        ):-
        if_else(
            search(Facility,facility(Name,Type,P3,P4,P5,_,_,_)),
            if_then_else(
                or(
                    eq(Name,instruct),
                    eq(Name,stage),
                    eq(Name,state),
                    eq(Name,';'),
                    eq(Name,'}')
                ),
                fail,
                and(
                    display('??? The facility name: '),
                    display(Name),
                    display(' (in operation) is not defined.'),
                    nl,
                    cut(3),
                    fail
                )
            )
        ),
        !,
        operation1(Type,I,O,Output,Facility,Stage,P3,P4,P5,Name,EXPAND).
/*------<none>--------------------------------------*/
operation(Y,
          Y,
          none,
          _,
          _,
          _,
          _,
          _,
          _,
          [],
          hsl_op(none,_)
        ).
/*------<tmp_name_chk>=<exp>--------------------------------------*/
operation1(tmp_org(Sel_Bus),
        ['='|V2],
        V3,
        [pack(0xd222 ,0,0),Ptr,Exp],
        Facility,
        Stage,
        Ptr,
        Width,
        Opt_Value,
        Name,
        [net(pin(tmp_org(Sel_Bus),Width,[Name,Opt_Value]),Value)|REST]
        ):-
        !,
        exp(V2,V3,Exp,Facility,Stage,Value,REST),
        if_else(
            eq(Value,pin(_,Width,_)),
            and(
                display('??? The bit widths of source and destination are not equal.'),
                nl,
                fail
            )
        ).
/*------<term_name_chk>=<exp>--------------------------------------*/
operation1(bus_org,
        ['='|V2],
        V3,
        [pack(0xd222 ,0,0),Ptr,Exp],
        Facility,
        Stage,
        Ptr,
        Width,
        _,
        Name,
        [net(pin(bus_org,Width,Name),Value)|REST]
        ):-
        !,
        exp(V2,V3,Exp,Facility,Stage,Value,REST),
        if_else(
            eq(Value,pin(_,Width,_)),
            and(
                display('??? The bit widths of source and destination are not equal.'),
                nl,
                fail
            )
        ).
/*------<sel_name_chk>=<exp>--------------------------------------*/
operation1(sel_org,
        ['='|V2],
        V3,
        [pack(0xd222 ,0,0),Ptr,Exp],
        Facility,
        Stage,
        Ptr,
        Width,
        _,
        Name,
        [net(pin(sel_org,Width,Name),Value)|REST]
        ):-
        !,
        exp(V2,V3,Exp,Facility,Stage,Value,REST),
        if_else(
            eq(Value,pin(_,Width,_)),
            and(
                display('??? The bit widths of source and destination are not equal.'),
                nl,
                fail
            )
        ).
/*------<output_name_chk>=<exp>------------------------------------*/
operation1(output,
        ['='|V2],
        V3,
        [pack(0xd222 ,0,0),Ptr,Exp],
        Facility,
        Stage,
        Ptr,
        Width,
        _,
        Name,
        [net(pin(output,Width,Name),Value)|REST]
        ):-
        !,
        exp(V2,V3,Exp,Facility,Stage,Value,REST),
        if_else(
            eq(Value,pin(_,Width,_)),
            and(
                display('??? The bit widths of source and destination are not equal.'),
                nl,
                fail
            )
        ).
/*------<bidirect_name_chk>=<exp>----------------------------------*/
operation1(bidirect,
        ['='|V2],
        V3,
        [pack(0xd222 ,0,0),Ptr,Exp],
        Facility,
        Stage,
        Ptr,
        Width,
        _,
        Name,
        [net(pin(bidirect,Width,Name),Value)|REST]
        ):-
        !,
        exp(V2,V3,Exp,Facility,Stage,Value,REST),
        if_else(
            eq(Value,pin(_,Width,_)),
            and(
                display('??? The bit widths of source and destination are not equal.'),
                nl,
                fail
            )
        ).
/*------<reg_name_chk>:=<exp>--------------------------------------*/
operation1(reg,
        [':='|V2],
        V3,
        [pack(0xd224 ,0,0),Ptr,Exp],
        Facility,
        Stage,
        Ptr,
        Width,
        _,
        Name,
        [net(pin(reg,Width,Name),Value)|REST]
        ):-
        !,
        exp(V2,V3,Exp,Facility,Stage,Value,REST),
        if_else(
            eq(Value,pin(_,Width,_)),
            and(
                display('??? The bit widths of source and destination are not equal.'),
                nl,
                fail
            )
        ).

operation1(reg_wr,                                                                      /* 1990.05.29 */
        [':='|V2],                                                                      /* 1990.05.29 */
        V3,                                                                             /* 1990.05.29 */
        [pack(0xd224 ,0,0),Ptr,Exp],                                            /* 1990.05.29 */
        Facility,                                                                       /* 1990.05.29 */
        Stage,                                                                          /* 1990.05.29 */
        Ptr,                                                                            /* 1990.05.29 */
        Width,                                                                          /* 1990.05.29 */
        _,                                                                              /* 1990.05.29 */
        Name,                                                                           /* 1990.05.29 */
        [net(pin(reg_wr,Width,Name),Value)|REST]                                        /* 1990.05.29 */
        ):-                                                                             /* 1990.05.29 */
        !,                                                                              /* 1990.05.29 */
        exp(V2,V3,Exp,Facility,Stage,Value,REST),                                       /* 1990.05.29 */
        if_else(                                                                        /* 1990.05.29 */
            eq(Value,pin(_,Width,_)),                                                   /* 1990.05.29 */
            and(                                                                        /* 1990.05.29 */
                display('??? The bit widths of source and destination are not equal.'), /* 1990.05.29 */
                nl,                                                                     /* 1990.05.29 */
                fail                                                                    /* 1990.05.29 */
            )                                                                           /* 1990.05.29 */
        ).                                                                              /* 1990.05.29 */

operation1(reg_ws,                                                                      /* 1990.06.18 */
        [':='|V2],                                                                      /* 1990.06.18 */
        V3,                                                                             /* 1990.06.18 */
        [pack(0xd224 ,0,0),Ptr,Exp],                                            /* 1990.06.18 */
        Facility,                                                                       /* 1990.06.18 */
        Stage,                                                                          /* 1990.06.18 */
        Ptr,                                                                            /* 1990.06.18 */
        Width,                                                                          /* 1990.06.18 */
        _,                                                                              /* 1990.06.18 */
        Name,                                                                           /* 1990.06.18 */
        [net(pin(reg_ws,Width,Name),Value)|REST]                                        /* 1990.06.18 */
        ):-                                                                             /* 1990.06.18 */
        !,                                                                              /* 1990.06.18 */
        exp(V2,V3,Exp,Facility,Stage,Value,REST),                                       /* 1990.06.18 */
        if_else(                                                                        /* 1990.06.18 */
            eq(Value,pin(_,Width,_)),                                                   /* 1990.06.18 */
            and(                                                                        /* 1990.06.18 */
                display('??? The bit widths of source and destination are not equal.'), /* 1990.06.18 */
                nl,                                                                     /* 1990.06.18 */
                fail                                                                    /* 1990.06.18 */
            )                                                                           /* 1990.06.18 */
        ).                                                                              /* 1990.06.18 */

/*------<mem_name_chk>'[<exp>']:=<exp>-----------------------------*/
operation1(mem,
        ['['|V2],
        V6,
        [pack(0xd326 ,0,0),Ptr,Exp2,Exp1],
        Facility,
        Stage,
        Ptr,
        Size,
        Width,
        Name,
        [net(pin(mem_adrs,Sizew,Name),Value1),
         net(pin(mem_din,Width,Name),Value2)|REST]
        ):-
        !,
        exp(V2,V3,Exp1,Facility,Stage,Value1,REST1),
        exp2(Sizew,Size),
        if_else(
            eq(Value1,pin(_,Sizew,_)),
            and(
                display('??? The mem adrs width is not equal to expression.'),
                nl,
                fail
            )
        ),
        ']'(V3,V4),
        ':='(V4,V5),
        exp(V5,V6,Exp2,Facility,Stage,Value2,REST2),
        if_else(
            eq(Value2,pin(_,Width,_)),
            and(
                display('??? The bit widths of source and destination are not equal.'),
                nl,
                fail
            )
        ),
        append(REST1,REST2,REST).
/*------<instrout_name_chk>([<exp>{,<exp>}])-----------------------*/
operation1(instrout,
        ['('|V2],
        V4,
        [pack(0xd044 ,Argsp,0),Ptr,Ptr,Exps],
        Facility,
        Stage,
        Ptr,
        ARG,
        _,
        Name,
        [net(pin(instrout,1,Name),pin(const,1,1))|REST]
        ):-
        !,
        exps(V2,V3,Exps,Facility,Stage,Values,RESTS),
        ')'(V3,V4),
        list_count(Exps,Args),
        list_count(ARG,Args1),
        if_else(
            eq(Args,Args1),
            and(
                display('??? The argument number is not equal to previous definition.'),
                nl,
                fail
            )
        ),
        add1(Args,Argsp),
        net_gen(ARG,Values,GEN_NET),
        append(RESTS,GEN_NET,REST).
/*------<instrself_name_chk>([<exp>{,<exp>}])----------------------*/
operation1(instrself,
        ['('|V2],
        V4,
        [pack(0xd044 ,Argsp,0),Ptr,Ptr,Exps],
        Facility,
        Stage,
        Ptr,
        ARG,
        _,
        Name,
        [net(pin(instrself,1,Name),pin(const,1,1))|REST]
        ):-
        !,
        exps(V2,V3,Exps,Facility,Stage,Values,RESTS),
        ')'(V3,V4),
        list_count(Exps,Args),
        list_count(ARG,Args1),
        if_else(
            eq(Args,Args1),
            and(
                display('??? The argument number is not equal to previous definition.'),
                nl,
                fail
            )
        ),
        add1(Args,Argsp),
        net_gen(ARG,Values,GEN_NET),
        append(RESTS,GEN_NET,REST).
/*------<instrself_name_chk>----------------------*/
operation1(instrself,
        V,
        V,
        [pack(0xd044 ,1,0),Ptr,Ptr],
        _,
        _,
        Ptr,
        ARG,
        _,
        Name,
        [net(pin(instrself,1,Name),pin(const,1,1))]
        ):-
        !,
        if_else(
            list_count(ARG,0),
            and(
                display('??? The argument number is not equal to previous definition.'),
                nl,
                fail
            )
        ).
/***** 1990.06.02 *****
/*------<circuit_name_chk>.<instrin_name_chk>([<exp>{,<exp>}])-----*/
operation1(circuit,
        ['.',Name,'('|V4],
        V6,
        [pack(OPR_INVOKE_READ,Argsp,0),Ptr,Ptr,Exps],
        Facility,
        Stage,
        _,
        FFacility,
        _,
        C_Name,
        [net(pin(instrin,1,[Name,C_Name]),pin(const,1,1))|REST]
        ):-
        !,
        if_else(
            search(FFacility,facility(Name,instrin,Ptr,ARG,_,_,_,_)),
            and(
                display('??? The circuit instrin name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        exps(V4,V5,Exps,Facility,Stage,Values,RESTS),
        ')'(V5,V6),
        list_count(Exps,Args),
        list_count(ARG,Args1),
        if_else(
            eq(Args,Args1),
            and(
                display('??? The argument number is not equal to previous definition.'),
                nl,
                fail
            )
        ),
        add1(Args,Argsp),
        net_gen(ARG,Values,GEN_NET,C_Name),
        append(RESTS,GEN_NET,REST).
***** 1990.06.02 *****/

/***----<circuit_name_chk>. ....-------------------*/                           /* 1990.06.02 */
operation1(circuit,                                                             /* 1990.06.02 */
        ['.',Name|I],                                                           /* 1990.06.02 */
        O,                                                                      /* 1990.06.02 */
        Output,                                                                 /* 1990.06.02 */
        Facility,                                                               /* 1990.06.02 */
        Stage,                                                                  /* 1990.06.02 */
        _,                                                                      /* 1990.06.02 */
        FFacility,                                                              /* 1990.06.02 */
        _,                                                                      /* 1990.06.02 */
        C_Name,                                                                 /* 1990.06.02 */
        EXPAND                                                                  /* 1990.06.02 */
        ):-                                                                     /* 1990.06.02 */
        if_else(                                                                /* 1990.06.02 */
            search(FFacility,facility(Name,Type,P3,P4,_,_,_,_)),                /* 1990.06.02 */
            and(                                                                /* 1990.06.02 */
                display('??? The circuit input or bidirect or instrin name: '), /* 1990.06.02 */
                display(Name),                                                  /* 1990.06.02 */
                display(' is not defined.'),                                    /* 1990.06.02 */
                nl,                                                             /* 1990.06.02 */
                fail                                                            /* 1990.06.02 */
            )                                                                   /* 1990.06.02 */
        ),                                                                      /* 1990.06.02 */
        operation2(Type,I,O,Output,Facility,Stage,P3,P4,C_Name,Name,EXPAND).    /* 1990.06.02 */

/***----<submod_name_chk>. ....-------------------*/
operation1(submod,
        ['.',Name|I],
        O,
        Output,
        Facility,
        Stage,
        _,
        FFacility,
        _,
        S_Name,
        EXPAND
        ):-
        if_else(
            search(FFacility,facility(Name,Type,P3,P4,_,_,_,_)),
            and(
                display('??? The submodule input or bidirect or instrin name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        operation2(Type,I,O,Output,Facility,Stage,P3,P4,S_Name,Name,EXPAND).
/***----<submod_name_chk>.<input_name_chk>=<exp>-------------------*/
operation2(input,
        ['='|V2],
        V4,
        [pack(0xd222 ,0,0),Ptr,Exp],
        Facility,
        Stage,
        Ptr,
        Width,
        S_Name,
        Name,
        [net(pin(input,Width,[Name,S_Name]),Value)|REST]
        ):-
        !,
        exp(V2,V4,Exp,Facility,Stage,Value,REST),
        if_else(
            eq(Value,pin(_,Width,_)),
            and(
                display('??? The bit widths of source and destination are not equal.'),
                nl,
                fail
            )
        ).
/*------<submod_name_chk>.<bidirect_name_chk>=<exp>----------------*/
operation2(bidirect,
        ['='|V2],
        V4,
        [pack(0xd222 ,0,0),Ptr,Exp],
        Facility,
        Stage,
        Ptr,
        Width,
        S_Name,
        Name,
        [net(pin(bidirect,Width,[Name,S_Name]),Value)|REST]
        ):-
        !,
        exp(V2,V4,Exp,Facility,Stage,Value,REST),
        if_else(
            eq(Value,pin(_,Width,_)),
            and(
                display('??? The bit widths of source and destination are not equal.'),
                nl,
                fail
            )
        ).
/*------<submod_name_chk>.<instrin_name_chk>([<exp>{,<exp>}])------*/
operation2(instrin,
        ['('|V4],
        V6,
        [pack(0xd044 ,Argsp,0),Ptr,Ptr,Exps],
        Facility,
        Stage,
        Ptr,
        ARG,
        S_Name,
        Name,
        [net(pin(instrin,1,[Name,S_Name]),pin(const,1,1))|REST]
        ):-
        exps(V4,V5,Exps,Facility,Stage,Values,RESTS),
        ')'(V5,V6),
        list_count(Exps,Args),
        list_count(ARG,Args1),
        if_else(
            eq(Args,Args1),
            and(
                display('??? The argument number is not equal to previous definition.'),
                nl,
                fail
            )
        ),
        add1(Args,Argsp),
        net_gen(ARG,Values,GEN_NET,S_Name),
        append(RESTS,GEN_NET,REST).

/******* added 88.4.15 ***********************/
reset_alltask_gen([facility(TSK_name,task,_,_,_,_,_,_)|REST],
                  STG_name,
                  [net(pin(task,1,[TSK_name,STG_name]),pin(const,1,0))|RESULT]
        ):-
        !,
        reset_alltask_gen(REST,STG_name,RESULT).
reset_alltask_gen([],
                  STG_name,
                  [net(pin(task,1,STG_name),pin(const,1,0))]
                 ).

/******************************/
/*           exps             */
/******************************/
exps(V0,V2,[EXP|EREST],Facility,Stage,[Value|VREST],NET):-
        exp(V0,V1,EXP,Facility,Stage,Value,NET1),
        !,
        exps_left(V1,V2,EREST,Facility,Stage,VREST,NET2),
        append(NET1,NET2,NET).
exps(V,V,[],_,_,[],[]).
/*----------------------------*/
exps_left([','|V1],V3,[EXP|EREST],Facility,Stage,[Value|VREST],NET):-
        !,
        exp(V1,V2,EXP,Facility,Stage,Value,NET1),
        exps_left(V2,V3,EREST,Facility,Stage,VREST,NET2),
        append(NET1,NET2,NET).
exps_left(V,V,[],_,_,[],[]).

/******************************/
/*            exp             */
/******************************/
exp(V0,
    V2,
    Exp,
    Facility,
    Stage,
    Pin,
    NET):-
        s_exp(V0,V1,Exp1,Facility,Stage,Pin1,NET1),
        d_exp(V1,V2,Exp1,Exp,Facility,Stage,Pin1,Pin,NET2),
        append(NET1,NET2,NET).
/*-------------------------------------------*/
d_exp(['|'|V0],
      V1,
      Exp1,
      [pack(0xd202 ,0,0),Exp1,Exp2],
      Facility,
      Stage,
      Pin1,
      PIN, /* pin(or,Width,[Pin1,Pin2]) * 1992.07.08 */
      NET2):-
        !,
        eq(Pin1,pin(_,Width,_)),
        /***** 1992.07.08 *****
        atom_value_read(op_mode,Op_mode),
        if_else(
            or(
                eq(Op_mode,loose),
                eq(Width,1)
            ),
            and(
                dispf('??? The multi bits operator | cannot be used for module behavior.\n'),
                fail
            )
        ),
        ***** 1992.07.08 *****/
        exp(V0,V1,Exp2,Facility,Stage,Pin2,NET2),
        eq(Pin2,pin(_,Width,_)),
        if_then_else(
            eq(Width,1),
            eq(PIN,pin(or,Width,[Pin1,Pin2])),
            multi_bit_exp(or,Width,Pin1,Pin2,PIN) /* 1992.07.08 */
        ).
d_exp(['=='|V0], /* 1992.07.08 */
      V1,
      Exp1,
      [pack(0xd20c ,0,0),Exp1,Exp2],
      Facility,
      Stage,
      Pin1,
      PIN, /* pin(equal,Width,[Pin1,Pin2]) */
      NET2):-
        !,
        eq(Pin1,pin(_,Width,_)),
        exp(V0,V1,Exp2,Facility,Stage,Pin2,NET2),
        eq(Pin2,pin(Type,Width,Const)),
        atom_value_read(op_mode,Op_mode),
        if_else(
            or(
                eq(Op_mode,loose),
                eq(Type,const)
            ),
            and(
                dispf('??? The equal operator == must be used with constant for module behavior.\n'),
                fail
            )
        ),
        if_then_else(
            eq(Type,const),
            multi_bit_exp_equal(Width,Const,Pin1,PIN),
            eq(PIN,pin(const,1,1)) /* dummy */
        ).
d_exp(['@'|V0],
      V1,
      Exp1,
      [pack(0xd203 ,0,0),Exp1,Exp2],
      Facility,
      Stage,
      Pin1,
      PIN, /* pin(eor,Width,[Pin1,Pin2]) * 1992.07.08 */
      NET):-
        !,
        eq(Pin1,pin(_,Width,_)),
        /***** 1992.07.08 *****
        atom_value_read(op_mode,Op_mode),
        if_else(
            or(
                eq(Op_mode,loose),
                eq(Width,1)
            ),
            and(
                dispf('??? The multi bits operator @ cannot be used for module behavior.\n'),
                fail
            )
        ),
        ***** 1992.07.08 *****/
        exp(V0,V1,Exp2,Facility,Stage,Pin2,NET2),
        eq(Pin2,pin(_,Width,_)),
        if_then_else(
            eq(Width,1),
            and(
                atom_value_read(eor_id,X),
                add1(X,Y),
                atom_value_set(eor_id,Y),
                sdispf('eor-%d',Y,Z),
                eq(PIN,pin(eor_out,1,Z)),
                eq(NET,[net(pin(eor_in1,1,Z),Pin1),net(pin(eor_in2,1,Z),Pin2)|NET2])
            ),
            multi_bit_exp_eor(Width,Pin1,Pin2,PIN,NET2,NET) /* 1992.07.08 */
        ).
d_exp(['&'|V0],
      V1,
      Exp1,
      [pack(0xd201 ,0,0),Exp1,Exp2],
      Facility,
      Stage,
      Pin1,
      PIN, /* pin(and,Width,[Pin1,Pin2]) * 1992.07.08 */
      NET2):-
        !,
        eq(Pin1,pin(_,Width,_)),
        /***** 1992.07.08 *****
        atom_value_read(op_mode,Op_mode),
        if_else(
            or(
                eq(Op_mode,loose),
                eq(Width,1)
            ),
            and(
                dispf('??? The multi bits operator & cannot be used for module behavior.\n'),
                fail
            )
        ),
        ***** 1992.07.08 *****/
        exp(V0,V1,Exp2,Facility,Stage,Pin2,NET2),
        eq(Pin2,pin(_,Width,_)),
        if_then_else(
            eq(Width,1),
            eq(PIN,pin(and,Width,[Pin1,Pin2])),
            multi_bit_exp(and,Width,Pin1,Pin2,PIN) /* 1992.07.08 */
        ).
d_exp(['||'|V0],
      V1,
      Exp1,
      [pack(0xd20b ,0,0),Exp1,Exp2],
      Facility,
      Stage,
      Pin1,
      pin(cat,Width,[Pin1,Pin2]),
      NET2):-
        !,
        exp(V0,V1,Exp2,Facility,Stage,Pin2,NET2),
        eq(Pin1,pin(_,Width1,_)),
        eq(Pin2,pin(_,Width2,_)),
        plus(Width1,Width2,Width).
d_exp(['+'|V0],
      V1,
      Exp1,
      [pack(0xd204 ,0,0),Exp1,Exp2],
      Facility,
      Stage,
      Pin1,
      pin(add,Width,[Pin1,Pin2]),
      NET2):-
        !,
        atom_value_read(op_mode,Op_mode),
        if_else(
            eq(Op_mode,loose),
            and(
                dispf('??? The operator + cannot be used for module behavior.\n'),
                fail
            )
        ),
        exp(V0,V1,Exp2,Facility,Stage,Pin2,NET2),
        eq(Pin1,pin(_,Width1,_)),
        eq(Pin2,pin(_,Width2,_)),
        if_then_else(
                bigger(Width1,Width2),
                eq(Width,Width1),
                eq(Width,Width2)
        ).
d_exp(['>>'|V0],
      V1,
      Exp1,
      [pack(0xd207 ,0,0),Exp2,Exp1],
      Facility,
      Stage,
      Pin1,
      pin(sftrl,Width,[Pin2,Pin1]),
      NET2):-
        !,
        atom_value_read(op_mode,Op_mode),
        if_else(
            eq(Op_mode,loose),
            and(
                dispf('??? The operator >> cannot be used for module behavior.\n'),
                fail
            )
        ),
        exp(V0,V1,Exp2,Facility,Stage,Pin2,NET2),
        eq(Pin1,pin(_,Width,_)).
d_exp(['<<'|V0],
      V1,
      Exp1,
      [pack(0xd209 ,0,0),Exp2,Exp1],
      Facility,
      Stage,
      Pin1,
      pin(sftll,Width,[Pin2,Pin1]),
      NET2):-
        !,
        atom_value_read(op_mode,Op_mode),
        if_else(
            eq(Op_mode,loose),
            and(
                dispf('??? The operator << cannot be used for module behavior.\n'),
                fail
            )
        ),
        exp(V0,V1,Exp2,Facility,Stage,Pin2,NET2),
        eq(Pin1,pin(_,Width,_)).
d_exp(V,V,Exp,Exp,_,_,Pin,Pin,[]).

/******************************/ /* 1992.07.08 */
/*      multi_bit_exp         */
/******************************/
multi_bit_exp(Type,
              1,
              Pin1,
              Pin2,
              pin(Type,
                  1,
                  [pin(subst,1,[0,0,Pin1]),
                   pin(subst,1,[0,0,Pin2])
                  ]
                 )
             ):-!.
multi_bit_exp(Type,
              Width,
              Pin1,
              Pin2,
              pin(cat,
                  Width,
                  [pin(Type,
                       1,
                       [pin(subst,1,[Width1,Width1,Pin1]),
                        pin(subst,1,[Width1,Width1,Pin2])
                       ]
                      ),
                   Pin
                  ]
                 )
             ):-
        sub1(Width,Width1),
        multi_bit_exp(Type,Width1,Pin1,Pin2,Pin).
/******************************/
multi_bit_exp_eor(
        1,
        Pin1,
        Pin2,
        pin(eor_out,1,Z),
        NET,
        [net(pin(eor_in1,1,Z),pin(subst,1,[0,0,Pin1])),net(pin(eor_in2,1,Z),pin(subst,1,[0,0,Pin2]))|NET]
        ):-
        !,
        atom_value_read(eor_id,X),
        add1(X,Y),
        atom_value_set(eor_id,Y),
        sdispf('eor-%d',Y,Z).
multi_bit_exp_eor(
        Width,
        Pin1,
        Pin2,
        pin(cat,Width,[pin(eor_out,1,Z),Pin]),
        NET,
        [net(pin(eor_in1,1,Z),pin(subst,1,[Width1,Width1,Pin1])),net(pin(eor_in2,1,Z),pin(subst,1,[Width1,Width1,Pin2]))|NET1]
        ):-
        atom_value_read(eor_id,X),
        add1(X,Y),
        atom_value_set(eor_id,Y),
        sdispf('eor-%d',Y,Z),
        sub1(Width,Width1),
        multi_bit_exp_eor(Width1,Pin1,Pin2,Pin,NET,NET1).
/******************************/
multi_bit_exp_equal(Width,Const,Pin,PIN):-
        !,
        assign_tmp_reduction_const(Width,Const,List_Const,[]),
        !,
        multi_bit_exp_equal1(Width,List_Const,Pin,PIN).

multi_bit_exp_equal1(1,
                     [pin(const,1,1)],
                     Pin,
                     pin(subst,1,[0,0,Pin])
                    ):-!.
multi_bit_exp_equal1(1,
                     [pin(const,1,0)],
                     Pin,
                     pin(not,
                         1,
                         pin(subst,1,[0,0,Pin])
                        )
                    ):-!.
multi_bit_exp_equal1(Width,
                     [pin(const,1,1)|Rest],
                     Pin,
                     pin(and,
                         1,
                         [pin(subst,1,[Width1,Width1,Pin]),
                          Pinn
                         ]
                        )
                    ):-
        !,
        sub1(Width,Width1),
        multi_bit_exp_equal1(Width1,Rest,Pin,Pinn).
multi_bit_exp_equal1(Width,
                     [pin(const,1,0)|Rest],
                     Pin,
                     pin(and,
                         1,
                         [pin(not,
                              1,
                              pin(subst,1,[Width1,Width1,Pin])
                             ),
                          Pinn
                         ]
                        )
                    ):-
        !,
        sub1(Width,Width1),
        multi_bit_exp_equal1(Width1,Rest,Pin,Pinn).


/******************************/
multi_bit_exp_not(1,
                  Pin,
                  pin(not,
                      1,
                      pin(subst,1,[0,0,Pin])
                     )
                 ):-!.
multi_bit_exp_not(Width,
                  Pin,
                  pin(cat,
                      Width,
                      [pin(not,
                           1,
                           pin(subst,1,[Width1,Width1,Pin])
                          ),
                       Pinn
                      ]
                     )
                 ):-
        sub1(Width,Width1),
        multi_bit_exp_not(Width1,Pin,Pinn).

/******************************/
multi_bit_exp_red(_,
                  1,
                  Pin,
                  pin(subst,1,[0,0,Pin])
                 ):-!.
multi_bit_exp_red(Type,
                  Width,
                  Pin,
                  pin(Type,
                      1,
                      [pin(subst,1,[Width1,Width1,Pin]),
                       Pinn
                      ]
                     )
                 ):-
        sub1(Width,Width1),
        multi_bit_exp_red(Type,Width1,Pin,Pinn).
/******************************/
multi_bit_exp_red_eor(
        A,
        A,
        Pin,
        pin(subst,1,[A,A,Pin]),
        NET,
        NET
        ):-!.
multi_bit_exp_red_eor(
        Top,
        Btm,
        Pin,
        pin(eor_out,1,Z),
        NET,
        [net(pin(eor_in1,1,Z),Pint),net(pin(eor_in2,1,Z),Pinb)|NET2]
        ):-
        atom_value_read(eor_id,X),
        add1(X,Y),
        atom_value_set(eor_id,Y),
        sdispf('eor-%d',Y,Z),
        minus(Top,Btm,Dif),
        divide(Dif,2,Diff),
        plus(Btm,Diff,Midl),
        add1(Midl,Midh),
        multi_bit_exp_red_eor(Top,Midh,Pin,Pint,NET,NET1),
        multi_bit_exp_red_eor(Midl,Btm,Pin,Pinb,NET1,NET2).


/******************************/
/*           s_exp            */
/******************************/
s_exp(['^'|V0],
      V1,
      [pack(0xd102 ,0,0),Exp],
      Facility,
      Stage,
      PIN, /* pin(not,Width,Pin) * 1992.07.08 */
      NET):-
        !,
        s_exp(V0,V1,Exp,Facility,Stage,Pin,NET),
        eq(Pin,pin(_,Width,_)),
        /***** 1992.07.08 *****
        atom_value_read(op_mode,Op_mode),
        if_else(
            or(
                eq(Op_mode,loose),
                eq(Width,1)
            ),
            and(
                dispf('??? The multi bits operator ^ cannot be used for module behavior.\n'),
                fail
            )
        ).
        ***** 1992.07.08 *****/
        if_then_else(
            eq(Width,1),
            eq(PIN,pin(not,Width,Pin)),
            multi_bit_exp_not(Width,Pin,PIN) /* 1992.07.08 */
        ).
s_exp(['/|'|V0],
      V1,
      [pack(0xd105 ,0,0),Exp],
      Facility,
      Stage,
      PIN, /* pin(ror,1,Pin) * 1992.07.08 */
      NET):-
        !,
        /***** 1992.07.08 *****
        atom_value_read(op_mode,Op_mode),
        if_else(
            eq(Op_mode,loose),
            and(
                dispf('??? The operator /| cannot be used for module behavior.\n'),
                fail
            )
        ),
        ***** 1992.07.08 *****/
        s_exp(V0,V1,Exp,Facility,Stage,Pin,NET),
        eq(Pin,pin(_,Width,_)),
        multi_bit_exp_red(or,Width,Pin,PIN). /* 1992.07.08 */
s_exp(['/@'|V0],
      V1,
      [pack(0xd106 ,0,0),Exp],
      Facility,
      Stage,
      PIN, /* pin(rxor,1,Pin) * 1992.07.08 */
      NET1):-
        !,
        /***** 1992.07.08 *****
        atom_value_read(op_mode,Op_mode),
        if_else(
            eq(Op_mode,loose),
            and(
                dispf('??? The operator /@ cannot be used for module behavior.\n'),
                fail
            )
        ),
        ***** 1992.07.08 *****/
        s_exp(V0,V1,Exp,Facility,Stage,Pin,NET),
        eq(Pin,pin(_,Width,_)),
        sub1(Width,Width1),
        multi_bit_exp_red_eor(Width1,0,Pin,PIN,NET,NET1). /* 1992.07.08 */
s_exp(['/&'|V0],
      V1,
      [pack(0xd104 ,0,0),Exp],
      Facility,
      Stage,
      PIN, /* pin(rand,1,Pin) * 1992.07.08 */
      NET):-
        !,
        /***** 1992.07.08 *****
        atom_value_read(op_mode,Op_mode),
        if_else(
            eq(Op_mode,loose),
            and(
                dispf('??? The operator /& cannot be used for module behavior.\n'),
                fail
            )
        ),
        ***** 1992.07.08 *****/
        s_exp(V0,V1,Exp,Facility,Stage,Pin,NET),
        eq(Pin,pin(_,Width,_)),
        multi_bit_exp_red(and,Width,Pin,PIN). /* 1992.07.08 */
s_exp(['/'|V0],
      V1,
      [pack(0xd107 ,0,0),Exp],
      Facility,
      Stage,
      pin(dec,Dwidth,Pin),
      NET):-
        !,
        atom_value_read(op_mode,Op_mode),
        if_else(
            eq(Op_mode,loose),
            and(
                dispf('??? The operator / cannot be used for module behavior.\n'),
                fail
            )
        ),
        s_exp(V0,V1,Exp,Facility,Stage,Pin,NET),
        eq(Pin,pin(_,Width,_)),
        exp2(Width,Dwidth),
        bigger(257,Dwidth).
s_exp(['\'|V0],
      V1,
      [pack(0xd108 ,0,0),Exp],
      Facility,
      Stage,
      pin(enc,Rwidth,Pin),
      NET):-
        !,
        atom_value_read(op_mode,Op_mode),
        if_else(
            eq(Op_mode,loose),
            and(
                dispf('??? The operator \ cannot be used for module behavior.\n'),
                fail
            )
        ),
        s_exp(V0,V1,Exp,Facility,Stage,Pin,NET),
        eq(Pin,pin(_,Width,_)),
        exp2(Ewidth,Width),
        add1(Ewidth,Rwidth).
s_exp([Size,'#'|V0],
      V1,
      [pack(0xd219 ,0,0),pack(0xd001 ,0,16),Size,Exp],
      Facility,
      Stage,
      PIN, /* pin(exp,Size,Pin) * 1992.08.14 */
      NET):-
        !,
        /* 1992.08.14 *
        atom_value_read(op_mode,Op_mode),
        if_else(
            eq(Op_mode,loose),
            and(
                dispf('??? The operator # cannot be used for module behavior.\n'),
                fail
            )
        ),
        * 1992.08.14 */
        int(Size),
        bigger(257,Size),
        s_exp(V0,V1,Exp,Facility,Stage,Pin,NET),  /* 1992.08.14 */
        eq(Pin,pin(_,Width,_)),
        sub1(Width,Width1),
        size_expand(Size,Width,pin(subst,1,[Width1,Width1,Pin]),Pin,PIN).
s_exp(V0,
      V2,
      Exp,
      Facility,
      Stage,
      Pin,
      NET):-
/***/   element(V0,V1,Exp0,Facility,Stage,Pin0,NET),
        exp_subst(V1,V2,Left,Right),
        exp_subst1(Right,Left,Exp0,Exp,Pin0,Pin).
/*----------------------------*/                            /* 1992.08.14 */
size_expand(Width,Width,_,Pin,Pin):-!.
size_expand(Size,Width,Msb,Pin,pin(cat,Size,[Msb,PIN])):-
        bigger(Size,Width),
        !,
        sub1(Size,Size1),
        size_expand(Size1,Width,Msb,Pin,PIN).
size_expand(Size,_,_,Pin,pin(subst,Size,[Size1,0,Pin])):-
        sub1(Size,Size1).
/*----------------------------*/
exp_subst(['<',Left|V0],V2,Left,Right):-
        !,
        int(Left),
        bigger(257,Left),
        exp_subst_right(V0,V1,Right),
        '>'(V1,V2).
exp_subst(V,V,[],[]).
/*----------------------------*/
exp_subst_right([':',Right|Y],Y,Right):-
        !,
        int(Right),
        bigger(257,Right).
exp_subst_right(V,V,[]).
/*-------------------------------------------*/
exp_subst1([],[],EXP,EXP,Pin,Pin):-
        !.
exp_subst1([],
           Left,
           EXP,
           [pack(0xd31a ,0,0),pack(0xd001 ,0,16),Left,pack(0xd001 ,0,16),Left,EXP],
           Pin,
           pin(subst,1,[Left,Left,Pin])):-
        !.
exp_subst1(Right,
           Left,
           EXP,
           [pack(0xd31a ,0,0),pack(0xd001 ,0,16),Left,pack(0xd001 ,0,16),Right,EXP],
           Pin,
           pin(subst,Width1,[Left,Right,Pin])):-
        if_then_else(
                bigger(Left,Right),
                minus(Left,Right,Width),
                minus(Right,Left,Width)
        ),
        add1(Width,Width1).

/******************************/
/*          element           */
/******************************/
element(['('|V1],V3,Exp,Facility,Stage,Value,REST):-
        !,
        exp(V1,V2,Exp,Facility,Stage,Value,REST),
        ')'(V2,V3).
/***---------------------------------------***/
element([const,Size|I],
        O,
        [pack(0xd001 ,0,Size),Ints],
        _,
        _,
        pin(const,Size,Ints),
        []
        ):-
        !,
        int(Size),
        sfl_ints(Size,I,O,Ints).
/***---------------------------------------***/
element([S_Name,'.',T_Name|Y],
        Y,
        [pack(0xd123 ,0,0),Ptr],
        _,
        Stage,
        pin(task,1,[T_Name,S_Name]),
        []
        ):-
        search(Stage,facility(S_Name,stage,_,Task,_,_,_,_)),
        !,
        if_else(
            search(Task,facility(T_Name,task,Ptr,_,_,_,_,_)),
            and(
                display('??? The task name: '),
                display(T_Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ).
/***---------------------------------------***/
element([Name|I],
        O,
        Output,
        Facility,
        Stage,
        Value,
        NET
        ):-
        if_else(
            search(Facility,facility(Name,Type,P3,P4,P5,_,_,_)),
            if_then_else(
                or(
                    eq(Name,'}'),
                    eq(Name,')'),
                    eq(Name,else)
                ),
                fail,
                and(
                    display('??? The facility name: '),
                    display(Name),
                    display(' (in element) is not defined.'),
                    nl,
                    cut(3),
                    fail
                )
            )
        ),
        element1(Type,
                 I,
                 O,
                 Output,
                 Facility,
                 Stage,
                 P3,
                 P4,
                 P5,
                 Name,
                 Value,
                 NET).
/***---------------------------------------***/
sfl_ints(Size,[Int|I],O,[Int|Ints]):-
        bigger(Size,16),!,
        int(Int),
        minus(Size,16,Size1),
        sfl_ints(Size1,I,O,Ints).
sfl_ints(_,[Int|Y],Y,Int):-int(Int).

sfl_zeros(Size,[0|Ints]):-     /* 1990.05.29 */
        bigger(Size,16),!,     /* 1990.05.29 */
        minus(Size,16,Size1),  /* 1990.05.29 */
        sfl_zeros(Size1,Ints). /* 1990.05.29 */
sfl_zeros(_,0).                /* 1990.05.29 */

sfl_ones(Size,[65535|Ints]):- /* 1990.06.18 */
        bigger(Size,16),!,    /* 1990.06.18 */
        minus(Size,16,Size1), /* 1990.06.18 */
        sfl_ones(Size1,Ints). /* 1990.06.18 */
sfl_ones(16,65535):-!.        /* 1990.06.18 */
sfl_ones(15,32767):-!.        /* 1990.06.18 */
sfl_ones(14,16383):-!.        /* 1990.06.18 */
sfl_ones(13,8191):-!.         /* 1990.06.18 */
sfl_ones(12,4095):-!.         /* 1990.06.18 */
sfl_ones(11,2047):-!.         /* 1990.06.18 */
sfl_ones(10,1023):-!.         /* 1990.06.18 */
sfl_ones(9,511):-!.           /* 1990.06.18 */
sfl_ones(8,255):-!.           /* 1990.06.18 */
sfl_ones(7,127):-!.           /* 1990.06.18 */
sfl_ones(6,63):-!.            /* 1990.06.18 */
sfl_ones(5,31):-!.            /* 1990.06.18 */
sfl_ones(4,15):-!.            /* 1990.06.18 */
sfl_ones(3,7):-!.             /* 1990.06.18 */
sfl_ones(2,3):-!.             /* 1990.06.18 */
sfl_ones(1,1):-!.             /* 1990.06.18 */

/***---------------------------------------***/
element1(tmp_org(Sel_Bus),
        I,
        I,
        [pack(0xd121 ,0,0),Ptr],
        _,
        _,
        Ptr,
        Width,
        Opt_Value,
        Name,
        pin(tmp_org(Sel_Bus),Width,[Name,Opt_Value]),
        []
        ):-!.
element1(bus_org,
        I,
        I,
        [pack(0xd121 ,0,0),Ptr],
        _,
        _,
        Ptr,
        Width,
        _,
        Name,
        pin(bus_org,Width,Name),
        []
        ):-!.
element1(sel_org,
        I,
        I,
        [pack(0xd121 ,0,0),Ptr],
        _,
        _,
        Ptr,
        Width,
        _,
        Name,
        pin(sel_org,Width,Name),
        []
        ):-!.
element1(input,
        I,
        I,
        [pack(0xd121 ,0,0),Ptr],
        _,
        _,
        Ptr,
        Width,
        _,
        Name,
        pin(input,Width,Name),
        []
        ):-!.
element1(output,
        I,
        I,
        [pack(0xd121 ,0,0),Ptr],
        _,
        _,
        Ptr,
        Width,
        _,
        Name,
        pin(output,Width,Name),
        []
        ):-!.
element1(bidirect,
        I,
        I,
        [pack(0xd121 ,0,0),Ptr],
        _,
        _,
        Ptr,
        Width,
        _,
        Name,
        pin(bidirect,Width,Name),
        []
        ):-!.
element1(instrin,
        I,
        I,
        [pack(0xd121 ,0,0),Ptr],
        _,
        _,
        Ptr,
        _,
        _,
        Name,
        pin(instrin,1,Name),
        []
        ):-!.
element1(instrout,                                                                       /* 1990.10.29 */
        ['('|V4],                                                                        /* 1990.10.29 */
        V7,                                                                              /* 1990.10.29 */
        [pack(0xd044 ,Argsp,0),PPtr,Ptr,Exps],                                 /* 1990.10.29 */
        Facility,                                                                        /* 1990.10.29 */
        Stage,                                                                           /* 1990.10.29 */
        Ptr,                                                                             /* 1990.10.29 */
        ARG,                                                                             /* 1990.10.29 */
        _,                                                                               /* 1990.10.29 */
        I_Name,                                                                          /* 1990.10.29 */
        R_Value,                                                                         /* 1990.10.29 */
        [net(pin(instrout,1,I_Name),pin(const,1,1))|REST]                                /* 1990.10.29 */
        ):-                                                                              /* 1990.10.29 */
        !,                                                                               /* 1990.10.29 */
        exps(V4,V5,Exps,Facility,Stage,Values,RESTS),                                    /* 1990.10.29 */
        ')'(V5,V6),                                                                      /* 1990.10.29 */
        list_count(Exps,Args),                                                           /* 1990.10.29 */
        list_count(ARG,Args1),                                                           /* 1990.10.29 */
        if_else(                                                                         /* 1990.10.29 */
            eq(Args,Args1),                                                              /* 1990.10.29 */
            and(                                                                         /* 1990.10.29 */
                display('??? The argument number is not equal to previous definition.'), /* 1990.10.29 */
                nl,                                                                      /* 1990.10.29 */
                fail                                                                     /* 1990.10.29 */
            )                                                                            /* 1990.10.29 */
        ),                                                                               /* 1990.10.29 */
        add1(Args,Argsp),                                                                /* 1990.10.29 */
        net_gen(ARG,Values,GEN_NET),                                                     /* 1990.10.29 */
        append(RESTS,GEN_NET,REST),                                                      /* 1990.10.29 */
        '.name'(V6,V7,Name),                                                             /* 1990.10.29 */
        if_then_else(                                                                    /* 1990.10.29 */
            search(Facility,facility(Name,input,PPtr,Width,_,_,_,_)),                    /* 1990.10.29 */
            eq(R_Value,pin(input,Width,Name)),                                           /* 1990.10.29 */
            if_then_else(                                                                /* 1990.10.29 */
                search(Facility,facility(Name,bidirect,PPtr,Width,_,_,_,_)),             /* 1990.10.29 */
                eq(R_Value,pin(bidirect,Width,Name)),                                    /* 1990.10.29 */
                and(                                                                     /* 1990.10.29 */
                    display('??? The input or bidirect name: '),                         /* 1990.10.29 */
                    display(Name),                                                       /* 1990.10.29 */
                    display(' is not defined.'),                                         /* 1990.10.29 */
                    nl,                                                                  /* 1990.10.29 */
                    fail                                                                 /* 1990.10.29 */
                )                                                                        /* 1990.10.29 */
            )                                                                            /* 1990.10.29 */
        ).                                                                               /* 1990.10.29 */
element1(instrout,
        I,
        I,
        [pack(0xd121 ,0,0),Ptr],
        _,
        _,
        Ptr,
        _,
        _,
        Name,
        pin(instrout,1,Name),
        []
        ):-!.
element1(reg,
        I,
        I,
        [pack(0xd123 ,0,0),Ptr],
        _,
        _,
        Ptr,
        Width,
        _,
        Name,
        pin(reg,Width,Name),
        []
        ):-!.

element1(reg_wr,                        /* 1990.05.29 */
        I,                              /* 1990.05.29 */
        I,                              /* 1990.05.29 */
        [pack(0xd123 ,0,0),Ptr], /* 1990.05.29 */
        _,                              /* 1990.05.29 */
        _,                              /* 1990.05.29 */
        Ptr,                            /* 1990.05.29 */
        Width,                          /* 1990.05.29 */
        _,                              /* 1990.05.29 */
        Name,                           /* 1990.05.29 */
        pin(reg_wr,Width,Name),         /* 1990.05.29 */
        []                              /* 1990.05.29 */
        ):-!.                           /* 1990.05.29 */

element1(reg_ws,                        /* 1990.06.18 */
        I,                              /* 1990.06.18 */
        I,                              /* 1990.06.18 */
        [pack(0xd123 ,0,0),Ptr], /* 1990.06.18 */
        _,                              /* 1990.06.18 */
        _,                              /* 1990.06.18 */
        Ptr,                            /* 1990.06.18 */
        Width,                          /* 1990.06.18 */
        _,                              /* 1990.06.18 */
        Name,                           /* 1990.06.18 */
        pin(reg_ws,Width,Name),         /* 1990.06.18 */
        []                              /* 1990.06.18 */
        ):-!.                           /* 1990.06.18 */

element1(mem,
        ['['|V2],
        V4,
        [pack(0xd225 ,0,0),Ptr,Exp],
        Facility,
        Stage,
        Ptr,
        Size,
        Width,
        Name,
        pin(mem_dout,Width,Name),
        [net(pin(mem_adrs,Sizew,Name),Value)|REST]
        ):-
        !,
        exp(V2,V3,Exp,Facility,Stage,Value,REST),
        exp2(Sizew,Size),
        if_else(
            eq(Value,pin(_,Sizew,_)),
            and(
                display('??? The mem adrs width is not equal to expression.'),
                nl,
                fail
            )
        ),
        ']'(V3,V4).
element1(instrself,
        ['('|V4],
        V7,
        [pack(0xd044 ,Argsp,0),PPtr,Ptr,Exps],
        Facility,
        Stage,
        Ptr,
        ARG,
        _,
        I_Name,
        R_Value,
        [net(pin(instrself,1,I_Name),pin(const,1,1))|REST]
        ):-
        !,
        exps(V4,V5,Exps,Facility,Stage,Values,RESTS),
        ')'(V5,V6),
        list_count(Exps,Args),
        list_count(ARG,Args1),
        if_else(
            eq(Args,Args1),
            and(
                display('??? The argument number is not equal to previous definition.'),
                nl,
                fail
            )
        ),
        add1(Args,Argsp),
        net_gen(ARG,Values,GEN_NET),
        append(RESTS,GEN_NET,REST),
        '.name'(V6,V7,Name),
        if_then_else(
            search(Facility,facility(Name,tmp_org(Sel_Bus),PPtr,Width,Opt_Value,_,_,_)),
            eq(R_Value,pin(tmp_org(Sel_Bus),Width,[Name,Opt_Value])),
            if_then_else(
                search(Facility,facility(Name,bus_org,PPtr,Width,_,_,_,_)),
                eq(R_Value,pin(bus_org,Width,Name)),
            if_then_else(
                search(Facility,facility(Name,sel_org,PPtr,Width,_,_,_,_)),
                eq(R_Value,pin(sel_org,Width,Name)),
            if_then_else(                                                       /* 1990.12.12 */
                search(Facility,facility(Name,input,PPtr,Width,_,_,_,_)),       /* 1990.12.12 */
                eq(R_Value,pin(input,Width,Name)),                               /* 1990.12.12 */
            if_then_else(                                                       /* 1990.12.12 */
                search(Facility,facility(Name,bidirect,PPtr,Width,_,_,_,_)),    /* 1990.12.12 */
                eq(R_Value,pin(bidirect,Width,Name)),                               /* 1990.12.12 */
                and(
                    display('??? The tmp or term name: '),
                    display(Name),
                    display(' is not defined.'),
                    nl,
                    fail
                )
                )                                                               /* 1990.12.12 */
                )                                                               /* 1990.12.12 */
                )
            )
        ).
element1(instrself,
        ['-',Name,'('|V4],
        V6,
        [pack(0xd044 ,Argsp,0),PPtr,Ptr,Exps],
        Facility,
        Stage,
        Ptr,
        ARG,
        _,
        I_Name,
        R_Value,
        [net(pin(instrself,1,I_Name),pin(const,1,1))|REST]
        ):-
        !,
        if_then_else(
            search(Facility,facility(Name,tmp_org(Sel_Bus),PPtr,Width,Opt_Value,_,_,_)),
            eq(R_Value,pin(tmp_org(Sel_Bus),Width,[Name,Opt_Value])),
            if_then_else(
                search(Facility,facility(Name,bus_org,PPtr,Width,_,_,_,_)),
                eq(R_Value,pin(bus_org,Width,Name)),
                and(
                    display('??? The tmp or term name: '),
                    display(Name),
                    display(' is not defined.'),
                    nl,
                    fail
                )
            )
        ),
        exps(V4,V5,Exps,Facility,Stage,Values,RESTS),
        ')'(V5,V6),
        list_count(Exps,Args),
        list_count(ARG,Args1),
        if_else(
            eq(Args,Args1),
            and(
                display('??? The argument number is not equal to previous definition.'),
                nl,
                fail
            )
        ),
        add1(Args,Argsp),
        net_gen(ARG,Values,GEN_NET),
        append(RESTS,GEN_NET,REST).
element1(instrself,
        I,
        I,
        [pack(0xd121 ,0,0),Ptr],
        _,
        _,
        Ptr,
        _,
        _,
        Name,
        pin(instrself,1,Name),
        []
        ):-!.
element1(submod,
        ['.',I_Name,'(' | V6],
        V9,
        [pack(0xd044 ,Argsp,0),PPPPtr,PPPtr,Exps],
        Facility,
        Stage,
        _,
        FFacility,
        _,
        C_Name,
        pin(TTTType,Width,[O_Name,C_Name]),
        [net(pin(instrin,1,[I_Name,C_Name]),pin(const,1,1))|REST]
        ):-
        !,
        if_else(
            search(FFacility,facility(I_Name,instrin,PPPtr,AAARG,_,_,_,_)),
            and(
                display('??? The submodule instrin name: '),
                display(I_Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        exps(V6,V7,Exps,Facility,Stage,Values,RESTS),
        ')'(V7,V8),
        list_count(Exps,Args),
        list_count(AAARG,Args1),
        if_else(
            eq(Args,Args1),
            and(
                display('??? The argument number is not equal to previous definition.'),
                nl,
                fail
            )
        ),
        add1(Args,Argsp),
        net_gen(AAARG,Values,GEN_NET,C_Name),
        append(RESTS,GEN_NET,REST),
        '.name'(V8,V9,O_Name),
        if_else(
            search(FFacility,facility(O_Name,TTTType,PPPPtr,P4,_,_,_,_)),
            and(
                display('??? The submodule output or bidirect or input or instrin or instrout name: '),
                display(O_Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        element2(TTTType,P4,Width).
element1(submod,
        ['.',Name|I],
        I,
        [pack(0xd121 ,0,0),Ptr],
        _,
        _,
        _,
        Facility,
        _,
        S_Name,
        pin(Type,Width,[Name,S_Name]),
        []
        ):-
        !,
        if_else(
            search(Facility,facility(Name,Type,Ptr,P4,_,_,_,_)),
            and(
                display('??? The submodule output or bidirect or input or instrin or instrout name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        element2(Type,P4,Width).
/*XXX------------------------------XXX*/
element1(circuit,
        ['.',I_Name,'(' | V6],
        V9,
        [pack(0xd044 ,Argsp,0),PPPPtr,PPPtr,Exps],
        Facility,
        Stage,
        _,
        FFacility,
        _,
        C_Name,
        pin(TTTType,Width,[O_Name,C_Name]),
        [net(pin(instrin,1,[I_Name,C_Name]),pin(const,1,1))|REST]
        ):-
        !,
        if_else(
            search(FFacility,facility(I_Name,instrin,PPPtr,AAARG,_,_,_,_)),
            and(
                display('??? The circuit instrin name: '),
                display(I_Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        exps(V6,V7,Exps,Facility,Stage,Values,RESTS),
        ')'(V7,V8),
        list_count(Exps,Args),
        list_count(AAARG,Args1),
        if_else(
            eq(Args,Args1),
            and(
                display('??? The argument number is not equal to previous definition.'),
                nl,
                fail
            )
        ),
        add1(Args,Argsp),
        net_gen(AAARG,Values,GEN_NET,C_Name),
        append(RESTS,GEN_NET,REST),
        '.name'(V8,V9,O_Name),
        if_else(
            search(FFacility,facility(O_Name,TTTType,PPPPtr,P4,_,_,_,_)),
            and(
                display('??? The circuit output or bidirect or input or instrin name: '),
                display(O_Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        element3(TTTType,P4,Width).
/*XXX------------------------------XXX*/
element1(circuit,
        ['.',I_Name,'-',O_Name,'(' | V6],
        V8,
        [pack(0xd044 ,Argsp,0),PPPPtr,PPPtr,Exps],
        Facility,
        Stage,
        _,
        FFacility,
        _,
        C_Name,
        pin(TTTType,Width,[O_Name,C_Name]),
        [net(pin(instrin,1,[I_Name,C_Name]),pin(const,1,1))|REST]
        ):-
        !,
        if_else(
            search(FFacility,facility(I_Name,instrin,PPPtr,AAARG,_,_,_,_)),
            and(
                display('??? The circuit instrin name: '),
                display(I_Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        if_else(
            search(FFacility,facility(O_Name,TTTType,PPPPtr,P4,_,_,_,_)),
            and(
                display('??? The circuit output or bidirect or input or instrin name: '),
                display(O_Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        element3(TTTType,P4,Width),
        exps(V6,V7,Exps,Facility,Stage,Values,RESTS),
        ')'(V7,V8),
        list_count(Exps,Args),
        list_count(AAARG,Args1),
        if_else(
            eq(Args,Args1),
            and(
                display('??? The argument number is not equal to previous definition.'),
                nl,
                fail
            )
        ),
        add1(Args,Argsp),
        net_gen(AAARG,Values,GEN_NET,C_Name),
        append(RESTS,GEN_NET,REST).
element1(circuit,
        ['.',Name|I],
        I,
        [pack(0xd121 ,0,0),Ptr],
        _,
        _,
        _,
        Facility,
        _,
        C_Name,
        pin(Type,Width,[Name,C_Name]),
        []
        ):-
        if_else(
            search(Facility,facility(Name,Type,Ptr,P4,_,_,_,_)),
            and(
                display('??? The circuit input or output or bidirect or instrin name: '),
                display(Name),
                display(' is not defined.'),
                nl,
                fail
            )
        ),
        element3(Type,P4,Width).
/*----------------------------*/
element2(input,W,W):-!.
element2(output,W,W):-!.
element2(bidirect,W,W):-!.
element2(instrin,_,1):-!.
element2(instrout,_,1).
/*----------------------------*/
element3(input,W,W):-!.
element3(output,W,W):-!.
element3(bidirect,W,W):-!.
element3(instrin,_,1).
/*----------------------------*/
net_gen([facility(Name,tmp_org(Sel_Bus),_,Width,Opt_Value,_,_,_)|A_REST],                                /* 1990.10.26 */
        [Value|V_REST],                                                                     /* 1990.10.26 */
        [net(pin(tmp_org(Sel_Bus),Width,[Name,Opt_Value]),Value)|N_REST]                                 /* 1990.10.26 */
        ):-                                                                                 /* 1990.10.26 */
        !,                                                                                  /* 1990.10.26 */
        if_else(                                                                            /* 1990.10.26 */
            eq(Value,pin(_,Width,_)),                                                       /* 1990.10.26 */
            and(                                                                            /* 1990.10.26 */
                display('??? The argument bit width is not equal to previous definition.'), /* 1990.10.26 */
                nl,                                                                         /* 1990.10.26 */
                fail                                                                        /* 1990.10.26 */
            )                                                                               /* 1990.10.26 */
        ),                                                                                  /* 1990.10.26 */
        net_gen(A_REST,V_REST,N_REST).                                                      /* 1990.10.26 */
net_gen([facility(Name,reg,_,Width,_,_,_,_)|A_REST],
        [Value|V_REST],
        [net(pin(reg,Width,Name),Value)|N_REST]
        ):-
        !,
        if_else(
            eq(Value,pin(_,Width,_)),
            and(
                display('??? The argument bit width is not equal to previous definition.'),
                nl,
                fail
            )
        ),
        net_gen(A_REST,V_REST,N_REST).

net_gen([facility(Name,reg_wr,_,Width,_,_,_,_)|A_REST],                                     /* 1990.05.29 */
        [Value|V_REST],                                                                     /* 1990.05.29 */
        [net(pin(reg_wr,Width,Name),Value)|N_REST]                                          /* 1990.05.29 */
        ):-                                                                                 /* 1990.05.29 */
        !,                                                                                  /* 1990.05.29 */
        if_else(                                                                            /* 1990.05.29 */
            eq(Value,pin(_,Width,_)),                                                       /* 1990.05.29 */
            and(                                                                            /* 1990.05.29 */
                display('??? The argument bit width is not equal to previous definition.'), /* 1990.05.29 */
                nl,                                                                         /* 1990.05.29 */
                fail                                                                        /* 1990.05.29 */
            )                                                                               /* 1990.05.29 */
        ),                                                                                  /* 1990.05.29 */
        net_gen(A_REST,V_REST,N_REST).                                                      /* 1990.05.29 */

net_gen([facility(Name,reg_ws,_,Width,_,_,_,_)|A_REST],                                     /* 1990.06.18 */
        [Value|V_REST],                                                                     /* 1990.06.18 */
        [net(pin(reg_ws,Width,Name),Value)|N_REST]                                          /* 1990.06.18 */
        ):-                                                                                 /* 1990.06.18 */
        !,                                                                                  /* 1990.06.18 */
        if_else(                                                                            /* 1990.06.18 */
            eq(Value,pin(_,Width,_)),                                                       /* 1990.06.18 */
            and(                                                                            /* 1990.06.18 */
                display('??? The argument bit width is not equal to previous definition.'), /* 1990.06.18 */
                nl,                                                                         /* 1990.06.18 */
                fail                                                                        /* 1990.06.18 */
            )                                                                               /* 1990.06.18 */
        ),                                                                                  /* 1990.06.18 */
        net_gen(A_REST,V_REST,N_REST).                                                      /* 1990.06.18 */

net_gen([facility(Name,bidirect,_,Width,_,_,_,_)|A_REST],
        [Value|V_REST],
        [net(pin(bidirect,Width,Name),Value)|N_REST]
        ):-
        !,
        if_else(
            eq(Value,pin(_,Width,_)),
            and(
                display('??? The argument bit width is not equal to previous definition.'),
                nl,
                fail
            )
        ),
        net_gen(A_REST,V_REST,N_REST).
net_gen([facility(Name,Type,_,Width,_,_,_,_)|A_REST],
        [Value|V_REST],
        [net(pin(Type,Width,Name),Value)|N_REST]
        ):-
        !,
        if_else(
            eq(Value,pin(_,Width,_)),
            and(
                display('??? The argument bit width is not equal to previous definition.'),
                nl,
                fail
            )
        ),
        net_gen(A_REST,V_REST,N_REST).
net_gen([],[],[]).
/*----------------------------*/
net_gen([facility(Name,bidirect,_,Width,_,_,_,_)|A_REST],
        [Value|V_REST],
        [net(pin(bidirect,Width,[Name,U_Name]),Value)|N_REST],
        U_Name
        ):-
        !,
        if_else(
            eq(Value,pin(_,Width,_)),
            and(
                display('??? The argument bit width is not equal to previous definition.'),
                nl,
                fail
            )
        ),
        net_gen(A_REST,V_REST,N_REST,U_Name).
net_gen([facility(Name,Type,_,Width,_,_,_,_)|A_REST],
        [Value|V_REST],
        [net(pin(Type,Width,[Name,U_Name]),Value)|N_REST],
        U_Name
        ):-
        !,
        if_else(
            eq(Value,pin(_,Width,_)),
            and(
                display('??? The argument bit width is not equal to previous definition.'),
                nl,
                fail
            )
        ),
        net_gen(A_REST,V_REST,N_REST,U_Name).
net_gen([],[],[],_).

/******************************/
/*           def              */
/******************************/
module_def(Ptr,Name):-
        trns_fac_exp(
            [0,
            pack(0x9005 ,0,0),
            pack(1,0,0),
            Name,
            pack(0xffff,0,0)],
            Ptr,
            [module_def,Name]
        ).
/*-------------------------------------------*/
new_circuit_def(Ptr,Name):-
        trns_fac_exp(
            [0,
            pack(0x9305 ,0,0),
            pack(1,0,0),
            Name,
            pack(0xffff,0,0)],
            Ptr,
            [module_def,Name]
        ).
/*-------------------------------------------*/
submod_class_def(Ptr,Name,Par):-
        trns_fac_exp(
            [0,
            pack(0x9286 ,0,0),
            pack(1,0,0),
            Name,
            pack(2,0,0),
            Par,
            pack(10,0,0),  /* 1992.01.08 */
            pack(0xffff,0,0)],
            Ptr,
            [submod_class_def,Name]
        ).
/*-------------------------------------------*/
circuit_class_def(Ptr,Name,Par):-
        trns_fac_exp(
            [0,
            pack(0x9186 ,0,0),
            pack(1,0,0),
            Name,
            pack(2,0,0),
            Par,
            pack(10,0,0),  /* 1992.01.08 */
            pack(0xffff,0,0)],
            Ptr,
            [circuit_class_def,Name]
        ).
/*-------------------------------------------*/
stage_def(Ptr,Name,Par):-
        trns_fac_exp(
            [0,
            pack(0x8c55 ,0,0),
            pack(1,0,0),
            Name,
            pack(2,0,0),
            Par,
            pack(3,0,0),
            pack(0xffff,0,0)],
            Ptr,
            [stage_def,Name]
        ).
/*-------------------------------------------*/
segment_def(Ptr,Name,Par):-
        trns_fac_exp(
            [0,
            pack(0x8d55 ,0,0),
            pack(1,0,0),
            Name,
            pack(2,0,0),
            Par,
            pack(3,0,0),
            pack(0xffff,0,0)],
            Ptr,
            [segment_def,Name]
        ).
/*-------------------------------------------------*/
state_def(Ptr,Name,Par):-
        trns_fac_exp(
            [0,
            pack(0x8e96 ,0,0),
            pack(1,0,0),
            Name,
            pack(2,0,0),
            Par,
            pack(0xffff,0,0)],
            Ptr,
            [state_def,Name]
        ).
/*-------------------------------------------------*/
task_def(Ptr,Name,Par):-
        trns_fac_exp(
            [0,
            pack(0x8fb9 ,0,0),
            pack(1,0,0),
            Name,
            pack(2,0,0),
            Par,
            pack(3,0,1),
            pack(0xffff,0,0)],
            Ptr,
            [task_def,Name]
        ).
/*-------------------------------------------------*/
instrins_def([Name|V0],
             V1,
             [facility(Name,instrin,Ptr,ARG,BEH,_,_,_)|REST],
             TREST,
             Par):-
        alpha_name(Name),
        instrin_def(Ptr,Name,Par),
        instrins_def_rest(V0,V1,REST,TREST,Par).
/*----------------------------*/
instrins_def_rest([',',Name|V0],
                  V1,
                  [facility(Name,instrin,Ptr,ARG,BEH,_,_,_)|REST],
                  TREST,
                  Par):-
        !,
        alpha_name(Name),
        instrin_def(Ptr,Name,Par),
        instrins_def_rest(V0,V1,REST,TREST,Par).
instrins_def_rest([';'|V0],V0,REST,REST,_).
/*----------------------------*/
instrin_def(Ptr,Name,Par):-
        trns_fac_exp(
            [0,
            pack(0x853d ,0,0),
            pack(1,0,0),
            Name,
            pack(2,0,0),
            Par,
            pack(3,0,1),
            pack(0xffff,0,0)],
            Ptr,
            [instrin_def,Name]
        ).
/*-------------------------------------------------*/
instrselfs_def([Name|V0],
               V1,
               [facility(Name,instrself,Ptr,ARG,BEH,_,_,_)|REST],
               TREST,
               Par):-
        alpha_name(Name),
        instrself_def(Ptr,Name,Par),
        instrselfs_def_rest(V0,V1,REST,TREST,Par).
/*----------------------------*/
instrselfs_def_rest([',',Name|V0],
                    V1,
                    [facility(Name,instrself,Ptr,ARG,BEH,_,_,_)|REST],
                    TREST,
                    Par):-
        !,
        alpha_name(Name),
        instrself_def(Ptr,Name,Par),
        instrselfs_def_rest(V0,V1,REST,TREST,Par).
instrselfs_def_rest([';'|V0],V0,REST,REST,_).
/*----------------------------*/
instrself_def(Ptr,Name,Par):-
        trns_fac_exp(
            [0,
            pack(0x843d ,0,0),
            pack(1,0,0),
            Name,
            pack(2,0,0),
            Par,
            pack(3,0,1),
            pack(0xffff,0,0)],
            Ptr,
            [instrself_def,Name]
        ).
/*-------------------------------------------------*/
instrouts_def([Name|V0],
              V1,
              [facility(Name,instrout,Ptr,ARG,BEH,_,_,_)|REST],
              TREST,
              Par):-
        alpha_name(Name),
        instrout_def(Ptr,Name,Par),
        instrouts_def_rest(V0,V1,REST,TREST,Par).
/*----------------------------*/
instrouts_def_rest([',',Name|V0],
                   V1,
                   [facility(Name,instrout,Ptr,ARG,BEH,_,_,_)|REST],
                   TREST,
                   Par):-
        !,
        alpha_name(Name),
        instrout_def(Ptr,Name,Par),
        instrouts_def_rest(V0,V1,REST,TREST,Par).
instrouts_def_rest([';'|V0],V0,REST,REST,_).
/*----------------------------*/
instrout_def(Ptr,Name,Par):-
        trns_fac_exp(
            [0,
            pack(0x863d ,0,0),
            pack(1,0,0),
            Name,
            pack(2,0,0),
            Par,
            pack(3,0,1),
            pack(0xffff,0,0)],
            Ptr,
            [instrout_def,Name]
        ).
/*-------------------------------------------*/
block_par_def(Ptr,Number,Par):-
        trns_fac_exp(
            [0,
            pack(0xa0b6 ,0,0),
            pack(6,0,Number),
            pack(2,0,0),
            Par,
            pack(0xffff,0,0)],
            Ptr,
            [par_def,Number]
        ).
/*-------------------------------------------*/
stmnt_alt_def(Ptr,Number,Par):-
        trns_fac_exp(
            [0,
            pack(0xa376 ,0,0),
            pack(6,0,Number),
            pack(2,0,0),
            Par,
            pack(0xffff,0,0)],
            Ptr,
            [alt_def,Number]
        ).
/*-------------------------------------------*/
stmnt_any_def(Ptr,Number,Par):-
        trns_fac_exp(
            [0,
            pack(0xa476 ,0,0),
            pack(6,0,Number),
            pack(2,0,0),
            Par,
            pack(0xffff,0,0)],
            Ptr,
            [any_def,Number]
        ).
/*-------------------------------------------*/
clause_else_def(Ptr,Number,Par):-
        trns_fac_exp(
            [0,
            pack(0xab6d ,0,0),
            pack(6,0,Number),
            pack(2,0,0),
            Par,
            pack(0xffff,0,0)],
            Ptr,
            [else_def,Number]
        ).
/*-------------------------------------------*/
bidirects_def(V0,
              V2,
              [facility(Name,bidirect,Ptr,Width,_,_,_,_)|REST],
              TREST,
              Par,Default):-
        bidirect_def(V0,V1,Ptr,Name,Width,Par,Default),
        bidirects_def_rest(V1,V2,REST,TREST,Par,Default).
/*----------------------------*/
bidirects_def_rest([','|V0],
                   V2,
                   [facility(Name,bidirect,Ptr,Width,_,_,_,_)|REST],
                   TREST,
                   Par,Default):-
        !,
        bidirect_def(V0,V1,Ptr,Name,Width,Par,Default),
        bidirects_def_rest(V1,V2,REST,TREST,Par,Default).
bidirects_def_rest([';'|V0],V0,REST,REST,_,_).
/*----------------------------*/
bidirect_def(X,Y,Ptr,Name,Width,Par,1):-
        name_width(X,Y,Name,Width),
        sfl_ones(Width,ONES),
        trns_fac_exp(
            [0,
            pack(0x83b1 ,0,0),
            pack(1,0,0),
            Name,
            pack(3,0,Width),
            pack(12,0,Width),
            ONES,
            pack(2,0,0),
            Par,
            pack(0xffff,0,0)],
            Ptr,
            [bidirect_def,Name]
        ).
/*----------------------------*/
bidirect_def(X,Y,Ptr,Name,Width,Par,0):-
        name_width(X,Y,Name,Width),
        sfl_zeros(Width,ZEROS),
        trns_fac_exp(
            [0,
            pack(0x83b1 ,0,0),
            pack(1,0,0),
            Name,
            pack(3,0,Width),
            pack(12,0,Width),
            ZEROS,
            pack(2,0,0),
            Par,
            pack(0xffff,0,0)],
            Ptr,
            [bidirect_def,Name]
        ).
/*----------------------------*/
bidirect_def(X,Y,Ptr,Name,Width,Par,_):-
        name_width(X,Y,Name,Width),
        trns_fac_exp(
            [0,
            pack(0x83b1 ,0,0),
            pack(1,0,0),
            Name,
            pack(3,0,Width),
            pack(2,0,0),
            Par,
            pack(0xffff,0,0)],
            Ptr,
            [bidirect_def,Name]
        ).
/*-------------------------------------------------*/
inputs_def(V0,V2,[facility(Name,input,Ptr,Width,_,_,_,_)|REST],TREST,Par):-
        input_def(V0,V1,Ptr,Name,Width,Par),
        inputs_def_rest(V1,V2,REST,TREST,Par).
/*----------------------------*/
inputs_def_rest([','|V0],
                V2,
                [facility(Name,input,Ptr,Width,_,_,_,_)|REST],
                TREST,
                Par):-
        !,
        input_def(V0,V1,Ptr,Name,Width,Par),
        inputs_def_rest(V1,V2,REST,TREST,Par).
inputs_def_rest([';'|V0],V0,REST,REST,_).
/*----------------------------*/
input_def(X,Y,Ptr,Name,Width,Par):-
        name_width(X,Y,Name,Width),
        trns_fac_exp(
            [0,
            pack(0x81b1 ,0,0),
            pack(1,0,0),
            Name,
            pack(3,0,Width),
            pack(2,0,0),
            Par,
            pack(0xffff,0,0)],
            Ptr,
            [input_def,Name]
        ).
/*-------------------------------------------------*/
outputs_def(V0,V2,[facility(Name,output,Ptr,Width,_,_,_,_)|REST],TREST,Par):-
        output_def(V0,V1,Ptr,Name,Width,Par),
        outputs_def_rest(V1,V2,REST,TREST,Par).
/*----------------------------*/
outputs_def_rest([','|V0],
                 V2,
                 [facility(Name,output,Ptr,Width,_,_,_,_)|REST],
                 TREST,
                 Par):-
        !,
        output_def(V0,V1,Ptr,Name,Width,Par),
        outputs_def_rest(V1,V2,REST,TREST,Par).
outputs_def_rest([';'|V0],V0,REST,REST,_).
/*----------------------------*/
output_def(X,Y,Ptr,Name,Width,Par):-
        name_width(X,Y,Name,Width),
        trns_fac_exp(
            [0,
            pack(0x82b1 ,0,0),
            pack(1,0,0),
            Name,
            pack(3,0,Width),
            pack(2,0,0),
            Par,
            pack(0xffff,0,0)],
            Ptr,
            [output_def,Name]
        ).
/*-------------------------------------------------*/
tmps_def(V0,V2,[facility(Name,tmp_org(old),Ptr,Width,Opt_Value,_,_,_)|REST],TREST,Par):-
        tmp_def(V0,V1,Ptr,Name,Width,Par),
        tmps_def_rest(V1,V2,REST,TREST,Par).
/*----------------------------*/
tmps_def_rest([','|V0],
               V2,
               [facility(Name,tmp_org(old),Ptr,Width,Opt_Value,_,_,_)|REST],
               TREST,
               Par):-
        !,
        tmp_def(V0,V1,Ptr,Name,Width,Par),
        tmps_def_rest(V1,V2,REST,TREST,Par).
tmps_def_rest([';'|V0],V0,REST,REST,_).
/*-------------------------------------------------*/
tmps_bus_def(V0,V2,[facility(Name,tmp_org(bus_org),Ptr,Width,Opt_Value,_,_,_)|REST],TREST,Par):-
        tmp_def(V0,V1,Ptr,Name,Width,Par),
        tmps_bus_def_rest(V1,V2,REST,TREST,Par).
/*----------------------------*/
tmps_bus_def_rest([','|V0],
               V2,
               [facility(Name,tmp_org(bus_org),Ptr,Width,Opt_Value,_,_,_)|REST],
               TREST,
               Par):-
        !,
        tmp_def(V0,V1,Ptr,Name,Width,Par),
        tmps_bus_def_rest(V1,V2,REST,TREST,Par).
tmps_bus_def_rest([';'|V0],V0,REST,REST,_).
/*-------------------------------------------------*/
tmps_sel_def(V0,V2,[facility(Name,tmp_org(sel_org),Ptr,Width,Opt_Value,_,_,_)|REST],TREST,Par):-
        tmp_def(V0,V1,Ptr,Name,Width,Par),
        tmps_sel_def_rest(V1,V2,REST,TREST,Par).
/*----------------------------*/
tmps_sel_def_rest([','|V0],
               V2,
               [facility(Name,tmp_org(sel_org),Ptr,Width,Opt_Value,_,_,_)|REST],
               TREST,
               Par):-
        !,
        tmp_def(V0,V1,Ptr,Name,Width,Par),
        tmps_sel_def_rest(V1,V2,REST,TREST,Par).
tmps_sel_def_rest([';'|V0],V0,REST,REST,_).
/*----------------------------*/
tmp_def(X,Y,Ptr,Name,Width,Par):-
        name_width(X,Y,Name,Width),
        trns_fac_exp(
            [0,
            pack(0x80b1 ,0,0),
            pack(1,0,0),
            Name,
            pack(2,0,0),
            Par,
            pack(3,0,Width),
            pack(0xffff,0,0)],
            Ptr,
            [term_def,Name]
        ).
/*-------------------------------------------------*/
terms_def(V0,V2,[facility(Name,bus_org,Ptr,Width,_,_,_,_)|REST],TREST,Par):-
        term_def(V0,V1,Ptr,Name,Width,Par),
        terms_def_rest(V1,V2,REST,TREST,Par).
/*----------------------------*/
terms_def_rest([','|V0],
               V2,
               [facility(Name,bus_org,Ptr,Width,_,_,_,_)|REST],
               TREST,
               Par):-
        !,
        term_def(V0,V1,Ptr,Name,Width,Par),
        terms_def_rest(V1,V2,REST,TREST,Par).
terms_def_rest([';'|V0],V0,REST,REST,_).
/*-------------------------------------------------*/
terms_sel_def(V0,V2,[facility(Name,sel_org,Ptr,Width,_,_,_,_)|REST],TREST,Par):-
        term_def(V0,V1,Ptr,Name,Width,Par),
        terms_sel_def_rest(V1,V2,REST,TREST,Par).
/*----------------------------*/
terms_sel_def_rest([','|V0],
               V2,
               [facility(Name,sel_org,Ptr,Width,_,_,_,_)|REST],
               TREST,
               Par):-
        !,
        term_def(V0,V1,Ptr,Name,Width,Par),
        terms_sel_def_rest(V1,V2,REST,TREST,Par).
terms_sel_def_rest([';'|V0],V0,REST,REST,_).
/*----------------------------*/
term_def(X,Y,Ptr,Name,Width,Par):-
        name_width(X,Y,Name,Width),
        trns_fac_exp(
            [0,
            pack(0x80b1 ,0,0),
            pack(1,0,0),
            Name,
            pack(2,0,0),
            Par,
            pack(3,0,Width),
            pack(0xffff,0,0)],
            Ptr,
            [term_def,Name]
        ).
/*-------------------------------------------------*/
regs_def(V0,V2,[facility(Name,reg,Ptr,Width,_,_,_,_)|REST],TREST,Par):-
        reg_def(V0,V1,Ptr,Name,Width,Par),
        regs_def_rest(V1,V2,REST,TREST,Par).
/*----------------------------*/
regs_def_rest([','|V0],
              V2,
              [facility(Name,reg,Ptr,Width,_,_,_,_)|REST],
              TREST,
              Par):-
        !,
        reg_def(V0,V1,Ptr,Name,Width,Par),
        regs_def_rest(V1,V2,REST,TREST,Par).
regs_def_rest([';'|V0],V0,REST,REST,_).
/*----------------------------*/
reg_def(X,Y,Ptr,Name,Width,Par):-
        name_width(X,Y,Name,Width),
        trns_fac_exp(
            [0,
            pack(0x89b1 ,0,0),
            pack(1,0,0),
            Name,
            pack(2,0,0),
            Par,
            pack(3,0,Width),
            pack(0xffff,0,0)],
            Ptr,
            [reg_def,Name]
        ).

/*-------------------------------------------------*/                         /* 1990.05.29 */
reg_wrs_def(V0,V2,[facility(Name,reg_wr,Ptr,Width,_,_,_,_)|REST],TREST,Par):- /* 1990.05.29 */
        reg_wr_def(V0,V1,Ptr,Name,Width,Par),                                 /* 1990.05.29 */
        reg_wrs_def_rest(V1,V2,REST,TREST,Par).                               /* 1990.05.29 */
/*----------------------------*/                                              /* 1990.05.29 */
reg_wrs_def_rest([','|V0],                                                    /* 1990.05.29 */
              V2,                                                             /* 1990.05.29 */
              [facility(Name,reg_wr,Ptr,Width,_,_,_,_)|REST],                 /* 1990.05.29 */
              TREST,                                                          /* 1990.05.29 */
              Par):-                                                          /* 1990.05.29 */
        !,                                                                    /* 1990.05.29 */
        reg_wr_def(V0,V1,Ptr,Name,Width,Par),                                 /* 1990.05.29 */
        reg_wrs_def_rest(V1,V2,REST,TREST,Par).                               /* 1990.05.29 */
reg_wrs_def_rest([';'|V0],V0,REST,REST,_).                                    /* 1990.05.29 */
/*----------------------------*/                                              /* 1990.05.29 */
reg_wr_def(X,Y,Ptr,Name,Width,Par):-                                          /* 1990.05.29 */
        name_width(X,Y,Name,Width),                                           /* 1990.05.29 */
        sfl_zeros(Width,ZEROS),                                               /* 1990.05.29 */
        trns_fac_exp(                                                         /* 1990.05.29 */
            [0,                                               /* 1990.05.29 */
            pack(0x89b1 ,0,0),                                         /* 1990.05.29 */
            pack(1,0,0),                                            /* 1990.05.29 */
            Name,                                                             /* 1990.05.29 */
            pack(2,0,0),                                          /* 1990.05.29 */
            Par,                                                              /* 1990.05.29 */
            pack(3,0,Width),                                       /* 1990.05.29 */
            pack(11,0,Width),                                    /* 1990.05.29 */
            ZEROS,                                                            /* 1990.05.29 */
            pack(0xffff,0,0)],                                            /* 1990.05.29 */
            Ptr,                                                              /* 1990.05.29 */
            [reg_wr_def,Name]                                                 /* 1990.05.29 */
        ).                                                                    /* 1990.05.29 */

/*-------------------------------------------------*/                         /* 1990.06.18 */
reg_wss_def(V0,V2,[facility(Name,reg_ws,Ptr,Width,_,_,_,_)|REST],TREST,Par):- /* 1990.06.18 */
        reg_ws_def(V0,V1,Ptr,Name,Width,Par),                                 /* 1990.06.18 */
        reg_wss_def_rest(V1,V2,REST,TREST,Par).                               /* 1990.06.18 */
/*----------------------------*/                                              /* 1990.06.18 */
reg_wss_def_rest([','|V0],                                                    /* 1990.06.18 */
              V2,                                                             /* 1990.06.18 */
              [facility(Name,reg_ws,Ptr,Width,_,_,_,_)|REST],                 /* 1990.06.18 */
              TREST,                                                          /* 1990.06.18 */
              Par):-                                                          /* 1990.06.18 */
        !,                                                                    /* 1990.06.18 */
        reg_ws_def(V0,V1,Ptr,Name,Width,Par),                                 /* 1990.06.18 */
        reg_wss_def_rest(V1,V2,REST,TREST,Par).                               /* 1990.06.18 */
reg_wss_def_rest([';'|V0],V0,REST,REST,_).                                    /* 1990.06.18 */
/*----------------------------*/                                              /* 1990.06.18 */
reg_ws_def(X,Y,Ptr,Name,Width,Par):-                                          /* 1990.06.18 */
        name_width(X,Y,Name,Width),                                           /* 1990.06.18 */
        sfl_ones(Width,ONES),                                                 /* 1990.06.18 */
        trns_fac_exp(                                                         /* 1990.06.18 */
            [0,                                               /* 1990.06.18 */
            pack(0x89b1 ,0,0),                                         /* 1990.06.18 */
            pack(1,0,0),                                            /* 1990.06.18 */
            Name,                                                             /* 1990.06.18 */
            pack(2,0,0),                                          /* 1990.06.18 */
            Par,                                                              /* 1990.06.18 */
            pack(3,0,Width),                                       /* 1990.06.18 */
            pack(11,0,Width),                                    /* 1990.06.18 */
            ONES,                                                             /* 1990.06.18 */
            pack(0xffff,0,0)],                                            /* 1990.06.18 */
            Ptr,                                                              /* 1990.06.18 */
            [reg_ws_def,Name]                                                 /* 1990.06.18 */
        ).                                                                    /* 1990.06.18 */

/*-------------------------------------------------*/
mems_def(V0,V2,[facility(Name,mem,Ptr,Size,Width,_,_,_)|REST],TREST,Par):-
        mem_def(V0,V1,Ptr,Name,Size,Width,Par),
        mems_def_rest(V1,V2,REST,TREST,Par).
/*----------------------------*/
mems_def_rest([','|V0],
              V2,
              [facility(Name,mem,Ptr,Size,Width,_,_,_)|REST],
              TREST,
              Par):-
        !,
        mem_def(V0,V1,Ptr,Name,Size,Width,Par),
        mems_def_rest(V1,V2,REST,TREST,Par).
mems_def_rest([';'|V0],V0,REST,REST,_).
/*----------------------------*/
mem_def(X,Y,Ptr,Name,Size,Width,Par):-
        name_size_width(X,Y,Name,Size,Width),
        trns_fac_exp(
            [0,
            pack(0x8bb1 ,0,0),
            pack(1,0,0),
            Name,
            pack(2,0,0),
            Par,
            pack(4 ,0,0),
            Size,
            pack(3,0,Width),
            pack(0xffff,0,0)],
            Ptr,
            [mem_def,Name]
        ).
/*-------------------------------------------*/
clause_if_def(Ptr,Number,Par,Exp):-
        trns_fac_exp(
            [0,
            pack(0xb96d ,0,0),
            pack(6,0,Number),
            pack(2,0,0),
            Par,
            pack(5,0,0),
            Exp,
            pack(0xffff,0,0)],
            Ptr,
            [if_def,Number]
        ).
/*-------------------------------------------*/
stmnt_simple_def(Ptr,Number,Par,Operation):-
        if_then_else(
                eq(Operation,none),
                trns_fac_exp(
                    [0,
                    pack(0xb8e0 ,0,0),
                    pack(6,0,Number),
                    pack(2,0,0),
                    Par,
                    pack(0xffff,0,0)],
                    Ptr,
                    [simple_def,Number]
                ),
                trns_fac_exp(
                    [0,
                    pack(0xb8e0 ,0,0),
                    pack(6,0,Number),
                    pack(2,0,0),
                    Par,
                    pack(5,0,0),
                    Operation,
                    pack(0xffff,0,0)],
                    Ptr,
                    [simple_def,Number]
                )
        ).
/*-------------------------------------------*/
submod_def(Ptr,Name,PPtr,Par):-
        trns_fac_exp(
            [0,
            pack(0x9286 ,0,0),
            pack(1,0,0),
            Name,
            pack(2,0,0),
            Par,
            pack(13,0,0),
            PPtr,
            pack(0xffff,0,0)],
            Ptr,
            [submod_def,Name]
        ).
/*-------------------------------------------*/
circuit_def(Ptr,Name,PPtr,Par):-
        trns_fac_exp(
            [0,
            pack(0x9186 ,0,0),
            pack(1,0,0),
            Name,
            pack(2,0,0),
            Par,
            pack(13,0,0),
            PPtr,
            pack(0xffff,0,0)],
            Ptr,
            [circuit_def,Name]
        ).
/*-------------------------------------------*/
instr_def_second(Ptr,Args_num,Ptrs):-
        trns_fac_exp(
            [4,
            Ptr,
            pack(7,0,Args_num),
            Ptrs],
            _,
            [instr_def_second]
        ).
/*---------------------------------------------------*/
task_def_second(Ptr,Args_num,Ptrs):-
        trns_fac_exp(
            [4,
            Ptr,
            pack(7,0,Args_num),
            Ptrs],
            _,
            [task_def_second]
        ).
/*---------------------------------------------------*/
stage_def_second(Ptr,facility(_,_,PPtr,_,_,_,_,_)):-
        !,              /* 1990.10.29 */
        trns_fac_exp(
            [4,
            Ptr,
            pack(11,0,0),
            PPtr],
            _,
            [stage_def_second]
        ).
stage_def_second(_,[]). /* 1990.10.29 */
/*------add at 87.11.11------------------------------*/
segment_def_second(Ptr,facility(_,_,PPtr,_,_,_,_,_)):-
        trns_fac_exp(
            [4,
            Ptr,
            pack(11,0,0),
            PPtr],
            _,
            [segment_def_second]
        ).

/******************************/
/*           common           */
/******************************/
alpha_name_or_int(A):-
    alpha_name(A),
    !.
alpha_name_or_int(A):-
    int(A).

repeat.
repeat:-repeat.

/*----sort(qsort)----*/
sort(X,Y):-sort(X,Y,[]).
/*-------------------*/ /* kono sort ha douitu no youso wo fukumanai youni suru */
sort([X1|X2],Y1,Y2):-
    !,
    part(X1,X2,P1,P2),  /* X2 wo X1 yori ookiika doukade P1 to P2 ni wakeru */
    sort(P1,Y1,[X1|S]),
    sort(P2,S,Y2).
sort([],Y,Y):-!.
/*-------------------*/
part(X,[X|Z],P1,P2):-
    !,
    part(X,Z,P1,P2).
part(X,[Y|Z],P1,[Y|P2]):-
    cmp(X,Y),
    !,
    part(X,Z,P1,P2).
part(X,[Y|Z],[Y|P1],P2):-
    !,
    part(X,Z,P1,P2).
part(_,[],[],[]):-!.
/*-------------------*/

eq(X,X).

cmp(X,X):-!,fail.
cmp(_,_):-!,cmp.

not(X):-X,!,fail.
not(_).

chk(X):-not(not(X)).

if_then(P,T):-
    P,!,T.
if_then(_,_).

if_then_else(P,T,_):-
    P,!,T.
if_then_else(_,_,E):-
    E.

if_else(P,_):-
    P,!.
if_else(_,E):-
    E.

if_else_else(P,_,_):- /* 1990.06.19 */
    P,!.              /* 1990.06.19 */
if_else_else(_,E,_):- /* 1990.06.19 */
    E,!.              /* 1990.06.19 */
if_else_else(_,_,E):- /* 1990.06.19 */
    E.                /* 1990.06.19 */

or(A,_):-A.
or(_,B):-B.

or(A,_,_):-A.
or(_,B,_):-B.
or(_,_,C):-C.

or(A,_,_,_):-A.
or(_,B,_,_):-B.
or(_,_,C,_):-C.
or(_,_,_,D):-D.

or(A,_,_,_,_):-A.
or(_,B,_,_,_):-B.
or(_,_,C,_,_):-C.
or(_,_,_,D,_):-D.
or(_,_,_,_,E):-E.

and(X,Y):-
    X,Y.

and(X,Y,Z):-
    X,Y,Z.

and(W,X,Y,Z):-
    W,X,Y,Z.

and(V,W,X,Y,Z):-
    V,W,X,Y,Z.

and(X1,X2,X3,X4,X5,X6):-
    X1,X2,X3,X4,X5,X6.

and(X1,X2,X3,X4,X5,X6,X7):-
    X1,X2,X3,X4,X5,X6,X7.

and(X1,X2,X3,X4,X5,X6,X7,X8):-
    X1,X2,X3,X4,X5,X6,X7,X8.

and(X1,X2,X3,X4,X5,X6,X7,X8,X9):-
    X1,X2,X3,X4,X5,X6,X7,X8,X9.

append([A|X],Y,[A|Z]):-
    !,
    append(X,Y,Z).
append([],L,L).

reverse(List,Tsil):-rev1(List,[],Tsil).
rev1([],Result,Result).
rev1([X|Y],Tsil,Result):-rev1(Y,[X|Tsil],Result).

flat(A,B):-
    flat1(A,B,[]).

flat1([X|Y],D1,D3):-
    !,
    flat1(X,D1,D2),
    flat1(Y,D2,D3).
flat1([],X,X):-!.
flat1(X,[X|Y],Y).

slow_search_out_id([X|_],X,S,S):-!.
slow_search_out_id([_|Z],X,M,S):-
    slow_search_out_id(Z,X,N,S),
    add1(N,M).

slow_search_out_id([X|_],X,1):-!.
slow_search_out_id([_|Z],X,M):-
    slow_search_out_id(Z,X,N),
    add1(N,M).

slow_search([X|_],X):-!.
slow_search([_|Z],X):-slow_search(Z,X).

slow_search([X1|_],X,X1):-
    eq(X,X1),
    !.
slow_search([_|Z],X,X1):-slow_search(Z,X,X1).

index_search(List,Id,Elm):-
    index_search(List,Id,1,Elm).

index_search([Elm|_],Id,Id,Elm):-!.
index_search([_|REST],Id,In,Elm):-
    add1(In,Out),
    index_search(REST,Id,Out,Elm).
/*------------------------------------------*/
search(List,Target):-
    hash_table_search(List,Table),
    eq(facility(Key,_,_,_,_,_,_,_),Target),
    hash_search(Table,Key,Entry),
    eq(Target,Entry).
/*------------------------------------------*/
search(List,Target,Entry1):-
    hash_table_search(List,Table),
    eq(facility(Key,_,_,_,_,_,_,_),Target),
    hash_search(Table,Key,Entry),
    eq(Entry1,Entry),
    eq(Target,Entry).

/******--------------------------------******/
hash_class(List):-
    list_count(List,Size),
    bigger(Size,0),
    !,
    hash_create(Size,List,Table),
    hash_class_entry_add(List,Table).
hash_class(_).
/*------------------------------------------*/
hash_class_entry_add([Entry|REST],Table):-
    !,
    eq(facility(Key,_,_,_,_,_,_,_),Entry),
    if_else(
        hash_add(Table,Key,Entry),
        nl
    ),
    hash_class_entry_add(REST,Table).
hash_class_entry_add([],_).
/*------------------------------------------*/

/******--------------------------------******/
hash(List):-
    list_count(List,Size),
    bigger(Size,0),
    !,
    hash_create(Size,List,Table),
    hash_create_chk(List,Table).
hash(_).
/*------------------------------------------*/
hash_create_chk(List,Table):-
    hash_entry_add(List,Table).
hash_create_chk(_,Table):-
    hash_release(Table),
    fail.
/*------------------------------------------*/
hash_entry_add([Entry|REST],Table):-
    !,
    eq(facility(Key,_,_,_,_,_,_,_),Entry),
    if_else(
        hash_add(Table,Key,Entry),
        and(
            display('??? The name: '),
            display(Key),
            display(' is double assigned.'),
            nl,
            fail
        )
    ),
    hash_entry_add(REST,Table).
hash_entry_add([],_).
/*------------------------------------------*/
list_count(X,0):-
    var(X),
    !.
list_count([X|Y],N):-
    !,
    list_count(Y,M),
    add1(M,N).
list_count([],0).

while(0,_):-!.
while(I,X):-
    X,
    sub1(I,O),
    while(O,X).

for(S,S,_,_):-!.
for(S,E,I,P):-
    chk(and(eq(S,I),P)),
    add1(S,SS),
    for(SS,E,I,P).

fore(S,S,I,P):-
    !,
    chk(and(eq(S,I),P)).
fore(S,E,I,P):-
    chk(and(eq(S,I),P)),
    add1(S,SS),
    fore(SS,E,I,P).

list_display_n([A|B],ID):-
    !,
    tab,
    display(ID),
    tab,
    display(A),
    nl,
    add1(ID,NID),
    list_display_n(B,NID).
list_display_n([],_).

list_display([A|B]):-
    !,
    tab,
    display(A),
    nl,
    list_display(B).
list_display([]).

list_fdisplay([A|B]):-
    !,
    fdispf('\t'),
    fdisplay(A),
    fdispf('\n'),
    list_fdisplay(B).
list_fdisplay([]).

list_list_display([A|B]):-
    !,
    tab,display('----------'),nl,
    list_display(A),
    list_list_display(B).
list_list_display([]).
/*----------------------------------------------*/
name_size_width([Name,'[',Size,']','<',Width,'>'|Z],Z,Name,Size,Width):-
    !,
    alpha_name(Name),
    int(Size),
    int(Width),
    exp2(Sizew,Size),
    bigger(29,Sizew),
    bigger(257,Width).
name_size_width([Name,'[',Size,']'|Z],Z,Name,Size,1):-
    alpha_name(Name),
    int(Size),
    exp2(Sizew,Size),
    bigger(29,Sizew).

name_width([Name,'<',Width,'>','(',phase,Num,')'|Z],Z,Name,Width):-
    !,
    alpha_name(Name),
    int(Width),
    bigger(257,Width).
name_width([Name,'<',Width,'>'|Z],Z,Name,Width):-
    !,
    alpha_name(Name),
    int(Width),
    bigger(257,Width).
name_width([Name|Z],Z,Name,1):-
    alpha_name(Name).
/*---------------------------------------------------*/
')'([')'|X],X).   /* neccessary */
':'([':'|X],X).   /* neccessary */
':='([':='|X],X). /* neccessary */
';'([';'|X],X).   /* neccessary */
'>'(['>'|X],X).   /* neccessary */
']'([']'|X],X).   /* neccessary */
'}'(['}'|X],X).   /* neccessary */
'.name'(['.',Name|X],X,Name).   /* neccessary */

/* */
/*K.Nagami modified: Tue May 23 15:28:33 2000*/
/*?-image_save('image.trn').*//*original.*/
?-atom_value_read(image_file_name,X),image_save(X).
/* */

/**** memo ***************************/
/**** memo ***************************/
/**** memo ***************************

    /*******************/
    /*  Key_predicate  */
    /*******************/

1. behavior(
        i   D_list_start,
        o   D_list_end,
        i   Num_in,
        o   Num_out,
        o   Result,        facility(Number,par,...) etc.
        i   [Facility,...],
        i   [Stage,...], or [],
        i   current_stage(stg_ptr,stg_name), or notin_stage,
        i   current_segment(seg_ptr,seg_name), or notin_segment,
        i   [State,...], or [],
        i   [Segment,...], or [],
        i   Par
        ):-
        ...

2. operation(
        i    D_list_start,
        o    D_list_end,
        o    [pack(OPR_...,n,m),...],     Result for sim
        i    [Facility,...],
        i    [Stage,...],
        i    current_stage(stg_ptr,stg_name),
        i    current_segment(seg_ptr,seg_name),
        i    [State,...],
        i    [Segment,...],
        o    [net(dst,src),...],             net lists
        o    hsl_op(tag,NETS)
        ):-
        ...

3. exp(
    i  D_list_start,
    o  D_list_end,
    o  [pack(OPR_...,n,m),...],           Result for sim
    i  [Facility,...],
    i  [Stage,...],
    o  pin(...)                             value for expander
    o  [net(dst,src),...]                   rest of net list
        ):-
        ...

   exps(D_list_start,
        D_list_end,
        Exps,
        Facility,
        Stage,
        [Value,...],
        [REST,...]):-
        ...
   net_gen([ARG,...],[Value,...],[GEN_NET,...]),
   net_gen([ARG,...],[Value,...],[GEN_NET,...],C_Name),
   operation1(Type,I,O,Output,Facility,Stage,P3,P4,P5,Name,EXPAND).
   operation2(Type,I,O,Output,Facility,Stage,P3,P4,S_Name,Name,EXPAND).

4. element(
    i      D_list_start,
    o      D_list_end,
    o      [pack(OPR_...,0,s),...],
    i      [Facility,...],
    i      [Stage,...],
    o      pin( ,width, ),
    o      [net(dst,src),...]               rest of net list
        ):-
        ...

   element1(
        i   Type,
        i   D_list_start,
        o   D_list_end,
        o   [pack(OPR_...,0,s),...],
        i   [Facility,...],
        i   [Stage,...],
        i   P3,
        i   P4,
        i   P5,
        i   Name,
        o   pin( ,width, ),
        o   [net(dst,src),...]
        ):-
        ...

5.  exp_exec_expand(
            [flat_op(),...],
            VAR or none or facility(...) or [facility(...),...]
            Name1,
            Name2
    )

    exp_exec_expand1(
            Type,
            [flat_op(),...],
            Name,
            P4,
            P5,
            P6,
            P7,
            P8,
            Name1,
            Name2
    )

    exp_exec_expand2(   koreha BEH ga VAR ka facility(...) ka douka no hantei no tamenidake aru.
            [flat_op(),...],
            VAR or none or facility(par,...) facility(alt,...) facility(any,...) facility(simple,...)
            Name1,
            Name2,
            Name3
    )

    exp_exec_expand3(
            type,             par,       alt,        any,        simple
            [flat_op(),...],
            BEH,              [BEH,...], [DBEH,...], [DBEH,...], [NET,...]
            Name1,
            Name2,
            Name3,
            True_cnd
    )

    exp_exec_expand4(          for par
            [flat_op(),...],
            BEH,               [facility(),...]
            Name1,             par,alt,any,simple
            Name2,
            Name3,
            True_cnd
    )

    exp_exec_expand5(
            type,              alt,              any
            [flat_op(),...],
            BEH,               [facility(),...], [facility(),...]
            Name1,             condition, else   condition, else
            Name2,
            Name3,
            True_cnd,
            Else_cnd_in,
            Else_cnd_out
    )

    exp_exec_expand6(
            Type,       condition,   else
            [flat_op(),...],
            type        alt, any     alt, any
            P4,         Value        BEH
            P5,         BEH
            P6,         [NET,...]
            Name1,
            Name2,
            Name3,
            True_cnd,
            Else_cnd_in,
            Else_cnd_out
    )

    /********************/
    /*  Facility format */
    /********************/

facility(Name,module,       Ptr,[Class,...],[Facility,...],[Stage,...],BEH,EOR_ID) /* 1990.05.25 */
facility(Name,submod_class, Ptr,[Facility,...],_,_,_,_)
facility(Name,circuit_class,Ptr,[Facility,...],BEH,_,_,_) /* 1990.06.18 */
facility(Name,submod,       Ptr,[Facility,...],Submod_class_name,_,_,_)
facility(Name,circuit,      Ptr,[Facility,...],Circuit_class_name,_,_,_)
facility(Name,tmp_org(_),          Ptr,Width,Opt_Value,_,_,_)
facility(Name,bus_org,         Ptr,Width,_,_,_,_)
facility(Name,sel_org,         Ptr,Width,_,_,_,_)
facility(Name,input,        Ptr,Width,_,_,_,_)
facility(Name,output,       Ptr,Width,_,_,_,_)
facility(Name,bidirect,     Ptr,Width,_,_,_,_)
facility(Name,instrin,      Ptr,[ARG,...],BEH,_,_,_)
facility(Name,instrout,     Ptr,[ARG,...],BEH,_,_,_)
facility(Name,instrself,    Ptr,[ARG,...],BEH,_,_,_)
facility(Name,reg,          Ptr,Width,_,_,_,_)

facility(Name,reg_wr,       Ptr,Width,_,_,_,_) /* 1990.05.29 */

facility(Name,reg_ws,       Ptr,Width,_,_,_,_) /* 1990.06.18 */

facility(Name,mem,          Ptr,Size,Width,_,_,_)

facility(Name,stage,        Ptr,[Task,...],[State,...],[Segment,...],First,BEH)
facility(Name,task,         Ptr,[ARG,...],_,_,_,_)
facility(Name,segment,      Ptr,[State,...],First,BEH,_,_)
facility(Name,state,        Ptr,BEH,first_flg,_,_,_)    first_flg = t, f

facility(Number,par,        Ptr,[BEH,...],_,_,_,_)
facility(Number,alt,        Ptr,[DBEH,...],_,_,_,_)
facility(Number,any,        Ptr,[DBEH,...],_,_,_,_)
facility(Number,simple,     Ptr,[NET,...],[OP,...],HSL_OP,_,_)
facility(Number,condition,  Ptr,Value,BEH,[NET,...],[OP,...],_)
facility(Number,else,       Ptr,BEH,_,_,_,_)

    /**************/
    /*  Relation  */
    /**************/

facility(Name,module,       Ptr,[Class,...],[Facility,...],[Stage,...],BEH,_) /* 1990.05.25 */
    <Class>
    facility(Name,submod_class, Ptr,[Facility,...],_,_,_,_)
        <Facility>
        facility(Name,input,        Ptr,Width,_,_,_,_)
        facility(Name,output,       Ptr,Width,_,_,_,_)
        facility(Name,bidirect,     Ptr,Width,_,_,_,_)
        facility(Name,instrin,      Ptr,[ARG,...],BEH,_,_,_)
            <ARG>
            [] or VAR
            <BEH>
            none or VAR
        facility(Name,instrout,     Ptr,[ARG,...],BEH,_,_,_)
            <ARG>
            [] or VAR
            <BEH>
            none or VAR
    facility(Name,circuit_class,Ptr,[Facility,...],BEH,_,_,_) /* 1990.06.18 */
        <Facility>
        facility(Name,tmp_org(_),          Ptr,Width,Opt_Value,_,_,_)
        facility(Name,bus_org,         Ptr,Width,_,_,_,_)
        facility(Name,sel_org,         Ptr,Width,_,_,_,_)
        facility(Name,input,        Ptr,Width,_,_,_,_)
        facility(Name,output,       Ptr,Width,_,_,_,_)
        facility(Name,bidirect,     Ptr,Width,_,_,_,_)
        facility(Name,instrin,      Ptr,[ARG,...],BEH,_,_,_)
            <ARG>
            facility(Name,input,        Ptr,Width,_,_,_,_)
            facility(Name,bidirect,     Ptr,Width,_,_,_,_)
            or VAR
            <BEH>
            facility(Number,Type,       Ptr,?????,_,_,_,_)
            or VAR
        facility(Name,reg,          Ptr,Width,_,_,_,_)

        facility(Name,reg_wr,       Ptr,Width,_,_,_,_) /* 1990.05.29 */

        facility(Name,reg_ws,       Ptr,Width,_,_,_,_) /* 1990.06.18 */

        facility(Name,mem,          Ptr,Size,Width,_,_,_)
    <Facility>
    facility(Name,tmp_org(_),          Ptr,Width,Opt_Value,_,_,_)
    facility(Name,bus_org,         Ptr,Width,_,_,_,_)
    facility(Name,sel_org,         Ptr,Width,_,_,_,_)
    facility(Name,input,        Ptr,Width,_,_,_,_)
    facility(Name,output,       Ptr,Width,_,_,_,_)
    facility(Name,bidirect,     Ptr,Width,_,_,_,_)
    facility(Name,instrin,      Ptr,[ARG,...],BEH,_,_,_)
        <ARG>
        [] or VAR
        <BEH>
        facility(Number,Type,       Ptr,?????,_,_,_,_)
        or VAR
    facility(Name,instrself,    Ptr,[ARG,...],BEH,_,_,_)
        <ARG>
        facility(Name,tmp_org(_),          Ptr,Width,Opt_Value,_,_,_)
        facility(Name,bus_org,         Ptr,Width,_,_,_,_)
        facility(Name,sel_org,         Ptr,Width,_,_,_,_)
        or VAR
        <BEH>
        facility(Number,Type,       Ptr,?????,_,_,_,_)
        or VAR
    facility(Name,instrout,     Ptr,[ARG,...],BEH,_,_,_)
        <ARG>
        facility(Name,output,       Ptr,Width,_,_,_,_)
        facility(Name,bidirect,     Ptr,Width,_,_,_,_)
        or VAR
        <BEH>
        none
        or VAR
    facility(Name,reg,          Ptr,Width,_,_,_,_)

    facility(Name,reg_wr,       Ptr,Width,_,_,_,_) /* 1990.05.29 */

    facility(Name,reg_ws,       Ptr,Width,_,_,_,_) /* 1990.06.18 */

    facility(Name,mem,          Ptr,Size,Width,_,_,_)
    facility(Name,submod,       Ptr,[Facility,...],Submod_class_name,_,_,_)
        <Facility>
        facility(Name,input,        Ptr,Width,_,_,_,_)
        facility(Name,output,       Ptr,Width,_,_,_,_)
        facility(Name,bidirect,     Ptr,Width,_,_,_,_)
        facility(Name,instrin,      Ptr,[ARG,...],BEH,_,_,_)
            <ARG>
            facility(Name,input,        Ptr,Width,_,_,_,_)
            facility(Name,bidirect,     Ptr,Width,_,_,_,_)
            or VAR
            <BEH>
            none
        facility(Name,instrout,     Ptr,[ARG,...],BEH,_,_,_)
            <ARG>
            []
            <BEH>
            facility(Number,Type,       Ptr,?????,_,_,_,_)
            or VAR
    facility(Name,circuit,      Ptr,[Facility,...],Circuit_class_name,_,_,_)
        <Facility>
        facility(Name,input,        Ptr,Width,_,_,_,_)
        facility(Name,output,       Ptr,Width,_,_,_,_)
        facility(Name,bidirect,     Ptr,Width,_,_,_,_)
        facility(Name,instrin,      Ptr,[ARG,...],BEH,_,_,_)
            <ARG>
            facility(Name,input,        Ptr,Width,_,_,_,_)
            facility(Name,bidirect,     Ptr,Width,_,_,_,_)
            <BEH>
            none
    <Stage>
    facility(Name,stage,        Ptr,[Task,...],[State,...],[Segment,...],First,[BEH,...])
        <Task>
        facility(Name,task,         Ptr,[ARG,...],_,_,_,_)
            <ARG>
            facility(Name,reg,          Ptr,Width,_,_,_,_)

            facility(Name,reg_wr,       Ptr,Width,_,_,_,_) /* 1990.05.29 */

            facility(Name,reg_ws,       Ptr,Width,_,_,_,_) /* 1990.06.18 */

        <State>
        facility(Name,state,        Ptr,BEH,first_flg,_,_,_)
            <BEH>
            facility(Number,Type,       Ptr,?????,_,_,_,_)
        <Segment>
        facility(Name,segment,      Ptr,[State,...],First,[BEH,...],_,_)
            <State>
            facility(Name,state,        Ptr,BEH,first_flg,_,_,_)
                <BEH>
                facility(Number,Type,       Ptr,?????,_,_,_,_)
            <First>
            facility(Name,state,        Ptr,BEH,first_flg,_,_,_)
            <BEH>
            facility(Number,Type,       Ptr,?????,_,_,_,_)
            or none
        <First>
        facility(Name,state,        Ptr,BEH,first_flg,_,_,_)
        <BEH>
        facility(Number,Type,       Ptr,?????,_,_,_,_)
        or none

<BEH>
facility(Number,par,        Ptr,[BEH,...],_,_,_,_)
facility(Number,alt,        Ptr,[DBEH,...],_,_,_,_)
facility(Number,any,        Ptr,[DBEH,...],_,_,_,_)
facility(Number,simple,     Ptr,[NET,...],[OP,...],HSL_OP,_,_)
<DBEH>
facility(Number,condition,  Ptr,Value,BEH,[NET,...],[OP,...],_)
facility(Number,else,       Ptr,BEH,_,_,_,_)

    /****************/
    /*  Net format  */
    /****************/

    format: net(dst,src)

    dst and src are as follow

    x   pin(stage,       Sizee,stage_name)
    s,d pin(stage,       1,    [stage_name,bit_position])                 This means stage's current state.
    d   pin(stage_clk,   1,    [stage_name,bit_position])
    x   pin(segment,     Sizef,[segment_name,stage_name])
    s,d pin(segment,     1,    [segment_name,stage_name,bit_position])    This means register for return state.
    d   pin(segment_clk, 1,    [segment_name,stage_name,bit_position])
    x   pin(state,       _,    [state_name,stage_name])
    x   pin(state,       _,    [state_name,segment_name,stage_name])
    s,d pin(task,        1,    stage_name)                                This means whether the stage is active or not.
/*--d---pin(task_clk,----1,----stage_name)--*/
    s,d pin(task,        1,    [task_name,stage_name])                    This means whether each task is active or not.
/*--d---pin(task_clk,----1,----[task_name,stage_name])--*/

    s   pin(const,       1,    0)
    s   pin(const,       1,    1)
    s   pin(const,       width,[int,...])
    s,d pin(tmp_org(_),         width,[tmp_name,Opt_Value]) |   saisyo kokokara hajimaru
    s,d pin(bus_org|sel_org,    width,tmp_name)             ->  Opt_Value ga multi_src to natta tokiha kounaru
    s,d pin(bus_org,        width,term_name)
    s,d pin(sel_org,        width,term_name)
    s   pin(input,       width,input_name)
    s,d pin(output,      width,output_name)
    s,d pin(bidirect,    width,bidirect_name)
    d   pin(bidirect_enb,1,    bidirect_name)
    s   pin(instrin,     1,    instrin_name)
    s,d pin(instrout,    1,    instrout_name)
    s,d pin(instrself,   1,    instrself_name)
    s,d pin(reg,         width,reg_name)

    s,d pin(reg_wr,      width,reg_name) /* 1990.05.29 */

    s,d pin(reg_ws,      width,reg_name) /* 1990.06.18 */

    d   pin(reg_clk,     1,    reg_name)
    x   pin(mem_adrs,    width,mem_name)
    x   pin(mem_din,     width,mem_name)
    x   pin(mem_dout,    Width,mem_name)

    s,d pin(input,       width,[input_name,   submodule_name])
    s   pin(output,      width,[output_name,  submodule_name])
    s,d pin(bidirect,    width,[bidirect_name,submodule_name])
    d   pin(bidirect_enb,1,    [bidirect_name,submodule_name])
    s,d pin(instrin,     1,    [instrin_name, submodule_name])
    s   pin(instrout,    1,    [instrout_name,submodule_name])

    s,d pin(input,       width,[input_name,   circuit_name])
    s   pin(output,      width,[output_name,  circuit_name])
    s,d pin(bidirect,    width,[bidirect_name,circuit_name])
    d   pin(bidirect_enb,1,    [bidirect_name,circuit_name])
    s,d pin(instrin,     1,    [instrin_name, circuit_name])

    s   pin(not,         width,pin)
    x   pin(ror,         1,    pin)
    x   pin(rxor,        1,    pin)
    x   pin(rand,        1,    pin)
    x   pin(dec,         width,pin)
    x   pin(enc,         width,pin)
    x   pin(exp,         width,pin)
    s   pin(subst,       width,[left,right,pin])
    s   pin(or,          width,[pin,pin])
    s   pin(eor,         width,[pin,pin])
    s   pin(and,         width,[pin,pin])
    s   pin(cat,         width,[pin,pin])
    x   pin(add,         width,[pin,pin])
    x   pin(sftrl,       width,[sift_pin,sifted_pin])
    x   pin(sftll,       width,[sift_pin,sifted_pin])

        pin(gate,        1,    [SRC,X])

    /********************/
    /*  chk_op format   */
    /********************/           condition operation

    chk_op(stage,   -     ,  -      ,   -   ,pin(.1..),[net(),...],hsl_op)
    chk_op(stage,   -     ,state    ,first_f,pin(.1..),[net(),...],hsl_op)
    chk_op(stage,segment  ,  -      ,   -   ,pin(.1..),[net(),...],hsl_op)
    chk_op(stage,segment  ,state    ,first_f,pin(.1..),[net(),...],hsl_op)

    chk_op(  -  ,   +     ,instrself,   -   ,pin(.1..),[net(),...],hsl_op)
    chk_op(  -  ,   -     ,instrin  ,   -   ,pin(.1..),[net(),...],hsl_op)
    chk_op(  -  ,submodule,instrout ,   -   ,pin(.1..),[net(),...],hsl_op)
                                              ^
    first_f = t, f                            |
                                              nesting strucure

    /*********************/
    /*  flat_op format   */
    /*********************/           condition operation

    flat_op(stage,   -     ,  -      ,   -   ,pin(.1..),[net(),...])
    flat_op(stage,   -     ,state    ,first_f,pin(.1..),[net(),...])
    flat_op(stage,segment  ,  -      ,   -   ,pin(.1..),[net(),...])
    flat_op(stage,segment  ,state    ,first_f,pin(.1..),[net(),...])


    flat_op(  -  ,   -     ,   -     ,   -   ,SRC,[net(pin(gate,1,[SRC,X]),pin(const,1,1))]) /* 1990.05.25 */
    flat_op(  -  ,   -     ,   -     ,   -   ,pin(.1..),[net(),...]) /* 1990.05.25 */
    flat_op(  -  ,   +     ,instrself,   -   ,pin(.1..),[net(),...])
    flat_op(  -  ,   -     ,instrin  ,   -   ,pin(.1..),[net(),...])
    flat_op(  -  ,submodule,instrout ,   -   ,pin(.1..),[net(),...])
                                              ^
    first_f = t, f                            |
                                              nesting strucure

    /*********************/
    /*  flat_op1 format  */
    /*********************/

            condition operation

    flat_op1(pin(.1..),[net(),...])
            ^
            |
            nesting strucure

    /**************************/ used in exp command
    /*  flat_cnd_net1 format  */
    /**************************/

                  condition       operation

    flat_cnd_net1([pin(.1..),...], [net(DST,SRC),...])
                  ^
                  |
                  simple and list

    /***************************/
    /* code, not, and, or, sel */
    /***************************/

    get_mini2  make     not-list ::= [],[a],[a,a,...]
                        a        ::= pin()
    ------------------------------------------------------------
    get_mini22 check    not      ::= yes or no
    ------------------------------------------------------------
    get_mini3  make     and-list ::= [],[and+],[and+,and+,...]
                        Fan-in of (and) must be greater than or equal to 2.
    ------------------------------------------------------------
    get_mini33 make     and      ::= []?,[b]-,[b,b,...]+
                        b        ::= pin()
                                  |  not(i)
    ------------------------------------------------------------
    get_mini4  make     or-list  ::= [],[or+],[or+,or+,...]
                        Fan-in of (or) must be greater than or equal to 2.
    ------------------------------------------------------------
    get_mini44 make     or       ::= []?,[c]-,[c,c,...]+
                        c        ::= and(j)
                                  |  pin()
                                  |  not(i)
                                  |  pin(const,1,1) ?
    ------------------------------------------------------------
    get_mini5  make     sel-list ::= []?,[e],[e,e,...]
                        e        ::= sel(DST,NUM,src)
    ------------------------------------------------------------
    get_mini55 make     src      ::= []?,[d],[d,d,...]
                        d        ::= src(or(k),SRC)
                                  |  src(and(j),SRC)
                                  |  src(pin(),SRC)
                                  |  src(not(i),SRC)
                                  |  src(pin(const,1,1),SRC) ?
                                  |  src(none,SRC) ?

    /***********/ used for hsl_fx convertion
    /*  hsl_op */
    /***********/ designed by Namekata

    hsl_op(goto,Name)
    hsl_op(goto,Name)
    hsl_op(call,[STG_name,Name1,Name2])
    hsl_op(call,[STG_name,Name1,Name2])
    hsl_op(through,Name)    /* motoha hsl_op(through,_) datta. */
                            /* namekata program de monndai ga */
                            /* okoru kamo sirenai */
    hsl_op(return,_)
    hsl_op(finish,TASK_NET)
    hsl_op(generate,[S_Name,T_Name,REST])
    hsl_op(relay,[S_Name,T_Name,REST1])
    hsl_op(other,EXPAND)
    hsl_op(none,_)

    /***********/
    /*  STG_ST */
    /***********/

    stg(<stage_name>,[<ST>,...],<bit_size>,[<seg_name>,...])
                      ^
                      |
                      This order means code

    <ST> ::= st(     -        ,<state_name>)
          |  st(<segment_name>,<state_name>)
          |  st(     -        ,    -       )  <--- dummy code


    /*************/
    /*  selector */
    /*************/

    sel(DST,NUM,SRC)

    DST---pin()
    NUM---<num> number of SRC
    SRC---[src(),...]

    src(CND,pin())

    CND ::= and(<num>)  or  nand(<num>)
         |  or(<num>)   or  nor(<num>)
         |  not(<num>)
         |  pin()

    !! Followings are concerned with hsl_out_detect_sels() etc. !!

    NUM=don't care
        DST=task            task_dum
    NUM=1
        DST=bus_org            bus_dum
        DST=sel_org            bus_dum     /* 1993.03.16 */
        DST=instrself       instr_dum
        ELSE
            DST=clk_enb     sel_dum    cnd_dst  cnd_dst means 'condition is connected to destination'
            DST=enb         sel_dum    cnd_dst
            DST=instrin     sel_dum    cnd_dst
            DST=instrout    sel_dum    cnd_dst
            DST=bidirect    sel_dum
            ELSE            sel_dum
    NUM=2,3,...
        DST=bus_org            bus
        ELSE
            DST=bidirect    sel
            ELSE            sel

    sel(pin(task     ),_,SRC) --> task_dum   not exist
    sel(pin(bus_org     ),1,SRC) --> bus_dum    exist
    sel(pin(instrself),1,SRC) --> instr_dum  exist
    sel(pin(ELSE     ),1,SRC) --> sel_dum    not exist
    sel(pin(bus_org     ),N,SRC) --> bus        exist
    sel(pin(sel_org      ),N,SRC) --> sel        exist
    sel(pin(ELSE     ),N,SRC) --> sel        exist

    /**************/
    /*  selector1 */
    /**************/

    sel1(DST,NUM,SRC1)

    DST----pin()
    NUM----<num> number of SRC1
    SRC1---[src1(),...]

    src1(CND,pin())
    or
    src1([CND,...],pin())
         ^
         |
         means or

    CND ::= and(<num>)
         |  or(<num>)
         |  not(<num>)
         |  pin()

    /**************/
    /*  hsl_class */
    /**************/

              class(type     ,class_name,width,num)

    submod    class(submod   ,<subm_type_name> ,1,PINS)     submod PINS is not used now
    circuit   class(circuit  ,<circ_type_name> ,1,PINS)
    stage     class(reg      ,reg--1           ,1,1)
    segment   class(reg      ,reg--1           ,1,1)
    all_task  class(reg      ,reg---1          ,1,1)
    task      class(reg      ,reg---1          ,1,1)
    reg       class(reg      ,reg-<width>      ,w,1)

    reg_wr    class(reg_wr   ,regr-<width>   ,w,1) /* 1990.05.29 */

    reg_ws    class(reg_ws   ,regs-<width>   ,w,1) /* 1990.06.18 */

    bus_drive class(bus_drive,bdrv-<width>,w,1)
    instr_dum class(instr_dum,inst-dum        ,1,1)
    bus       class(bus      ,bs<width>-<num>,w,n)  num=2,3,...
    bus_dum   class(bus_dum  ,bus-<width>      ,w,1)
    sel       class(sel      ,sl<width>-<num>,w,n)  num=2,3,...
    task_dum  ---------
    sel_dum   ---------
    not       class(inv      ,inv-             ,1,1)
    and       class(and      ,and--<num>       ,1,n)  num=2,3,...
    nand      class(and      ,nand--<num>      ,1,n)  num=2,3,...
    or        class(or       ,or--<num>        ,1,n)  num=2,3,...
    nor       class(or       ,nor--<num>       ,1,n)  num=2,3,...
    eor       class(eor      ,eor--2           ,1,2) /* 1993.03.17 */

    other     class(other    ,<mod_name>-<name>,_,_)  interface to other CAD tool

    /*****************/
    /*  hsl_instance */
    /*****************/

              instance(type     ,w,class_name       ,instance_name                         ,NET_INFO)

    submod    instance(submod   ,_,<subm_type_name> ,<submod_name>                         ,_)
    circuit   instance(circuit  ,_,<circ_type_name> ,<circuit_name>                        ,_)
    stage     instance(reg      ,1,reg--1           ,<stage_name>-<bit_posi>               ,_)
    segment   instance(reg      ,1,reg--1           ,<stage_name>-<segment_name>-<bit_posi>,_)
    all_task  instance(reg      ,1,reg---1          ,<stage_name>--all                     ,_)
    task      instance(reg      ,1,reg---1          ,<stage_name>-<task_name>              ,_)
    reg       instance(reg      ,W,reg-<width>      ,<reg_name>                            ,_)

    reg_wr    instance(reg_wr   ,W,regr-<width>   ,<reg_name>                            ,_) /* 1990.05.29 */

    reg_ws    instance(reg_ws   ,W,regs-<width>   ,<reg_name>                            ,_) /* 1990.06.18 */

    bus_drive instance(bus_drive,W,bdrv-<width>,<bidirect_name>-drive                 ,_)
    bus_drive instance(bus_drive,W,bdrv-<width>,<submod_name>-<bidirect_name>-drive   ,_)
    bus_drive instance(bus_drive,W,bdrv-<width>,<circuit_name>-<bidirect_name>-drive  ,_)
    instr_dum instance(instr_dum,1,inst-dum        ,<instrself_name>                      ,[_,[src()]])
    bus       instance(bus      ,W,bs<width>-<num>,<term_name>                           ,[_,[src(),...]])
    bus_dum   instance(bus_dum  ,W,bus-<width>      ,<term_name>                           ,[_,[src()]])
    sel       instance(sel      ,W,sl<width>-<num>,sel-<seq_no>                          ,[dst,[src(),...]])
    sel       instance(sel      ,W,sl<width>-<num>,<tmp_name>                            ,[none,[src(),...]])
    task_dum  instance(task_dum ,_,_                ,_                                     ,[dst,[src(),...]])
    sel_dum   instance(sel_dum  ,W,_                ,_                                     ,[dst,[src()]])
    not       instance(inv      ,1,inv-             ,inv-<seq_no>                          ,CND)
    and       instance(and      ,1,and--<num>       ,and-<seq_no>                          ,[CND,...])
    nand      instance(and      ,1,nand--<num>      ,nand-<seq_no>                         ,[CND,...])
    or        instance(or       ,1,or--<num>        ,or-<seq_no>                           ,[CND,...])
    nor       instance(or       ,1,nor--<num>       ,nor-<seq_no>                          ,[CND,...])
    eor       instance(eor      ,1,eor--2           ,eor-<seq_no>                          ,_) /* 1993.03.17 */

    other     instance(other    ,_,<mod_name>-<name>,<mod_name>-<name>                     ,_)  interface to other CAD tool

    w means bit_width

    src(CND,pin())

    CND ::= and(<seq_no>)   or  nand(<seq_no>)
         |  or(<seq_no>)    or  nor(<seq_no>)
         |  not(<seq_no>)
         |  pin()

    /*********************/
    /*  hsl_src_pin_name */
    /*********************/

s   external  .<input_name>
s             .<input_name><N>
s             .<input_name><N:0>
s             .<output_name>
s             .<output_name><N>
s             .<output_name><N:0>
s             .<bidirect_name>
s             .<bidirect_name><N>
s             .<bidirect_name><N:0>
s             .<instrin_name>
s             .<instrout_name>
s   submod    <submod_name>.<output_name>
s             <submod_name>.<output_name><N>
s             <submod_name>.<output_name><N:0>
s             <submod_name>.<input_name>
s             <submod_name>.<input_name><N>
s             <submod_name>.<input_name><N:0>
s             <submod_name>.<bidirect_name>
s             <submod_name>.<bidirect_name><N>
s             <submod_name>.<bidirect_name><N:0>
s             <submod_name>.<instrin_name>
s             <submod_name>.<instrout_name>
s   circuit   <circuit_name>.<output_name>
s             <circuit_name>.<output_name><N>
s             <circuit_name>.<output_name><N:0>
s             <circuit_name>.<input_name>
s             <circuit_name>.<input_name><N>
s             <circuit_name>.<input_name><N:0>
s             <circuit_name>.<bidirect_name>
s             <circuit_name>.<bidirect_name><N>
s             <circuit_name>.<bidirect_name><N:0>
s             <circuit_name>.<instrin_name>
s   stage     <stage_name>-<bit_position>.out
s   stage     <stage_name>-<bit_position>.nout
s   segment   <stage_name>-<segment_name>-<bit_position>.out
s   segment   <stage_name>-<segment_name>-<bit_position>.nout
s   all_task  <stage_name>--all.out
s   all_task  <stage_name>--all.nout
s   task      <stage_name>-<task_name>.out
s   task      <stage_name>-<task_name>.nout
s   reg       <reg_name>.out
s   reg       <reg_name>.nout
s             <reg_name>.out<N>
s             <reg_name>.out<N:0>

s   reg_wr    <reg_name>.out      /* 1990.05.29 */
s   reg_wr    <reg_name>.nout     /* 1990.05.29 */
s             <reg_name>.out<N>   /* 1990.05.29 */
s             <reg_name>.out<N:0> /* 1990.05.29 */

s   reg_ws    <reg_name>.out      /* 1990.06.18 */
s   reg_ws    <reg_name>.nout     /* 1990.06.18 */
s             <reg_name>.out<N>   /* 1990.06.18 */
s             <reg_name>.out<N:0> /* 1990.06.18 */

    bus_drive <bidirect_name>-drive.out
              <bidirect_name>-drive.out<N:0>
              <submod_name>-<bidirect_name>-drive.out
              <submod_name>-<bidirect_name>-drive.out<N:0>
              <circuit_name>-<bidirect_name>-drive.out
              <circuit_name>-<bidirect_name>-drive.out<N:0>
s   instr_dum <instrself_name>.out
s   bus_dum   <term_name>.out
s             <term_name>.out<N>
s             <term_name>.out<N:0>
s   bus       <term_name>.out
s             <term_name>.out<N>
s             <term_name>.out<N:0>
    sel       sel-<seq_no>.out
              sel-<seq_no>.out<N>
              sel-<seq_no>.out<N:0>
    sel       <tmp_name>.out
              <tmp_name>.out<N>
              <tmp_name>.out<N:0>
s   not       inv-<seq_no>.nout
s   and       and-<seq_no>.out
s   nand      nand-<seq_no>.nout
s   or        or-<seq_no>.out
s   nor       nor-<seq_no>.nout
s   low       low-.nout
s   high      high-.out

    name_compo_pin_src() refers s

    /*********************/     appear in 'bus_drive' or 'bus'
    /*  stand alone cell */
    /*********************/

    ts_buf-
        input: in
        output: out
        cntrol: nenb

    /*********************/
    /*  hsl_dst_pin_name */
    /*********************/

d   external  .<output_name>
d             .<output_name><N:0>
d             .<bidirect_name>
d             .<bidirect_name><N:0>
d             .<instrout_name>
d   submod    <submod_name>.<input_name>
d             <submod_name>.<input_name><N:0>
d             <submod_name>.<bidirect_name>
d             <submod_name>.<bidirect_name><N:0>
d             <submod_name>.<instrin_name>
d   circuit   <circuit_name>.<input_name>
d             <circuit_name>.<input_name><N:0>
d             <circuit_name>.<bidirect_name>
d             <circuit_name>.<bidirect_name><N:0>
d             <circuit_name>.<instrin_name>
d   stage     <stage_name>-<bit_position>.in
d             <stage_name>-<bit_position>.clk_enb
d   segment   <stage_name>-<segment_name>-<bit_position>.in
d             <stage_name>-<segment_name>-<bit_position>.clk_enb
d   all_task  <stage_name>--all.set
d             <stage_name>--all.reset
d   task      <stage_name>-<task_name>.set
d             <stage_name>-<task_name>.reset
d   reg       <reg_name>.in
d             <reg_name>.in<N:0>
d             <reg_name>.clk_enb

d   reg_wr    <reg_name>.in      /* 1990.05.29 */
d             <reg_name>.in<N:0> /* 1990.05.29 */
d             <reg_name>.clk_enb /* 1990.05.29 */

d   reg_ws    <reg_name>.in      /* 1990.06.18 */
d             <reg_name>.in<N:0> /* 1990.06.18 */
d             <reg_name>.clk_enb /* 1990.06.18 */

    bus_drive <bidirect_name>-drive.in
              <bidirect_name>-drive.in<N:0>
d             <bidirect_name>-drive.enb
              <submod_name>-<bidirect_name>-drive.in
              <submod_name>-<bidirect_name>-drive.in<N:0>
d             <submod_name>-<bidirect_name>-drive.enb
              <circuit_name>-<bidirect_name>-drive.in
              <circuit_name>-<bidirect_name>-drive.in<N:0>
d             <circuit_name>-<bidirect_name>-drive.enb
d   instr_dum <instrself_name>.in
d   bus_dum   <term_name>.in
d             <term_name>.in<N:0>
d   bus       <term_name>.in<i_no>
d             <term_name>.in<i_no><N:0>
              <term_name>.sel<i_no>
    sel       sel-<seq_no>.in<i_no>
              sel-<seq_no>.in<i_no><N:0>
              sel-<seq_no>.sel<i_no>
    sel       <tmp_name>.in<i_no>
              <tmp_name>.in<i_no><N:0>
              <tmp_name>.sel<i_no>
    not       inv-<seq_no>.in
    and       and-<seq_no>.in<i_no>
    nand      nand-<seq_no>.in<i_no>
    or        or-<seq_no>.in<i_no>
    nor       nor-<seq_no>.in<i_no>

    <seq_no> ::= 1,2,3,...
    <i_no> ::= 1,2,3,...
    <bit_position> ::= 0,1,2,...

    /*****************/
    /*  hsl_net_name */
    /*****************/

    <net_name> ::= net-<src_pin_name>
                |  net-<dst_pin_name>  bus_drive.out --> bidirect_pin

    /**************************/
    /*  multi level logic opt */
    /**************************/

    --demo control--

    multi_level(100,1,0).   demo off
    multi_level(100,1,1).   demo on

    --allocate network--

    multi_level(1,0,Nof_pin).   initialize, alloc pin
    multi_level(1,1,ID).    alloc not
    multi_level(1,2,ID).    alloc and
    multi_level(1,3,ID).    alloc or
    multi_level(1,4,1).     alloc result
    multi_level(1,5,ID).    alloc dont_care
    multi_level(2,1,ID).    search not
    multi_level(2,2,ID).    search and
    multi_level(2,3,ID).    search or
    multi_level(2,4,1).     search result
    multi_level(2,5,ID).    search dont_care
    multi_level(3,0,ID).    search pin, alloc fin, link
    multi_level(3,1,ID).    search not, alloc fin, link
    multi_level(3,2,ID).    search and, alloc fin, link
    multi_level(3,3,ID).    search or, alloc fin, link

    --optimize--

    multi_level(4,0,0).     do multi output optimization
    multi_level(4,0,1).     do single output optimization
    multi_level(4,0,2).     do not do post optimization

    --search component--

    multi_level(5,1,_)          set NOT root
    multi_level(5,2,_)          set AND root
    multi_level(5,3,_)          set OR root
    multi_level(5,4,_)          set RESULT root

    multi_level(5,10,return_id) null check and set FIN root

        return_id: 0,1,2,3,...
        return_id: 0  means null

    multi_level(5,20,_)         next component

    --read fin and set next--

    multi_level(6,return_type,return_id)

        return_type: 0  pin
                     1  not
                     2  and
                     3  or

        return_id: 0,1,2,3,...
        return_id: 0  means null

 ***** memo end **************************/
/***** memo end **************************/
/***** memo end **************************/
