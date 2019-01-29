!.              /* none */
sfl_see(_).
sfl_seen.
sfl_get_token(_).
sfl_point.
display(_).
put(_).
get(_).
nl.
tab(_).
add1(_,_).
sub1(_,_).
plus(_,_,_).
minus(_,_,_).
bigger(_,_).
equal(_,_).
notequal(_,_).
trace.
notrace.
tab.            /* tab1() */
show.
nonvar(_).
var(_).
atom(_).
int(_).             /* integer() */
alpha_name(_).
graph.
exp2(_,_).
dump_db.
dump_db_pat.
dump_goal_stack.
dump_glbal_stack.
dump_arg(_).
noshow.
trn_fac_exp(_,_).
atom_value_set(_,_).    /* set int atom str. but, str is not usefull */
atom_value_read(_,_).
dump_hash.
dump_atom.
image_save(_).
list.                       /* list() */
sfl_window_open.
cross.
list(_,_).                  /* list_arg() */
spy(_).
read(_).                /* prg_read */
file_compare(_,_,_).
string_cat(_,_,_).
sfl_get_position(_).
sfl_skip(_).
sfl_get_append_posit(_).
sfl_set_append_posit(_).
quit.
disp_mc.    /* display multi colomn mode */
disp_sc.    /* display single column mode */
dispf(_,_). /* display under format control */
hash_create(_,_,_).         /* search1() */
hash_add(_,_,_).            /* search2() */
hash_search(_,_,_).         /* search3() */
hash_table_search(_,_).     /* search4() */
hash_table_clear.           /* search5() */
hash_release(_).            /* search6() */
mini(_,_,_,_).    /* intmini()  ,mini(demo_flg,file_name,number_of_cubes,root_address), */
cut(_).     /* cut(0) equal ! */
retract(_).
retract(_,_).
list(_).                    /* list_name() */
list_ord.                   /* list_ord() */
listr(_).                   /* list_re() */
see(_).
seen.
fdispf(_).                  /* fdispf1() */
fdispf(_,_).                /* fdispf2() */
fdispf(_,_,_).              /* fdispf3() */
fdispf(_,_,_,_).            /* fdispf4() */
dispf(_).                   /* dispf1() */
dispf(_,_,_).               /* dispf3() */
dispf(_,_,_,_).             /* dispf4() */
get_cube(_,_,_,_,_).    /* intmini1() ,get_cube(address,part,position,value,next), */
free_cube.              /* intmini2() */
draw(_).                    /* draw() ,draw(file_name), */
exp2u(_,_).
divide(_,_,_).
multiply(_,_,_).
mod(_,_,_).
dump_for_aim.
cmp.        /* cmp(X,X):-!,fail. cmp(_,_):-cmp. */
sdispf(_,_).                /* sdispf2() */
sdispf(_,_,_).              /* sdispf3() */
sdispf(_,_,_,_).            /* sdispf4() */
sdispf(_,_,_,_,_).          /* sdispf5() */
sdispf(_,_,_,_,_,_).        /* sdispf6() */
dispf(_,_,_,_,_).           /* dispf5()  */
dispf(_,_,_,_,_,_).         /* dispf6()  */
cdispf(_,_,_,_).            /* cdispf2() */
gc.
dump_trail_stack.
catf(_).
fdispf(_,_,_,_,_).          /* fdispf5() */
fdispf(_,_,_,_,_,_).        /* fdispf6() */
garbage.
var_set(_,_).               /* not usefull */
time(_,_,_,_).
seen_all.
break.
tracet.
notracet.
fdispf(_,_,_,_,_,_,_).      /* fdispf7() */
fdispf(_,_,_,_,_,_,_,_).    /* fdispf8() */
multi_level(_,_,_).
divide(_,_,_,_).
fdisplay(_).
switch_set(_,_,_).
macro_reset.
msg_out(_).
