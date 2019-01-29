# Generated automatically from Makefile.com.in by configure.
# added by K.Nagami: (
PACKAGE         = parthenon
VERSION         = 3.0
prefix          = /usr/local
datadir         = ${prefix}/share
parthenon_prefix= /opt/parthenon
PARTHEN         = $(parthenon_prefix) # usually overridden by `auto'
# added by K.Nagami: )
##################################################################
# Makefile for parthenon Ver. 3.0
##################################################################
REVISION      = 2.3
TEST          = off
FOUNDRY       = DEMO # usually overridden by `auto'
CELL_LIB_NAME = demo # usually overridden by `auto'
CELLLIB       = $(PARTHEN)/cell_lib.dir/$(FOUNDRY)/$(CELL_LIB_NAME)
##################################################################
#  ONSET_LEVEL 1: maintain all hierarchy                         #
#              2: break hierarchy in each nld in the top-module  #
#              3: break all hierarchy (i.e. flatten)             #
#  ONSET_ITERATION, ONSET_ITERATION_CPB >= 0                     #
#  ONSET_INPUT_PIN, ONSET_INPUT_PIN_CPB <= 31                    #
##################################################################
ONSET_LEVEL         = 2
ONSET_INPUT_PIN     = 12
ONSET_ITERATION     = 2
ONSET_INPUT_PIN_CPB = 10
ONSET_ITERATION_CPB = 2
OPT_SCR_ONSET       = $(CELLLIB)/opt_scr.op1
OPT_SCR_ONSET_ITR   = $(CELLLIB)/opt_scr.lv$(ONSET_LEVEL)
OPT_SCR_OPT         = $(CELLLIB)/opt_scr.op2
OPT_SCR_OPT_ITR     = $(CELLLIB)/opt_scr.cpb
##################################################################
TPG_SCR             = $(CELLLIB)/tpg_scr
GLSH_SCR            = $(CELLLIB)/glsh_scr
CLK_DEF             = $(CELLLIB)/clk_def
##################################################################
START               = $(CELLLIB)/start.dir
START_EXT           = $(CELLLIB)/start_ex.dir
LIB                 = $(CELLLIB)/cell.dir
LIB_EXT             = $(CELLLIB)/cell_ex.dir
SFLLIB              = $(PARTHEN)/sfl_lib.dir
##################################################################
SFLEXP_FLAGS_       = $(SFLEXP_FLAGS) # to refer the environmental variable
##################################################################

$(TARGET).0off : $(TARGET).sfl
	rm -f $(TARGET).0on
	sflexp $(TARGET).sfl $(TARGET).hsl $(SFLEXP_FLAGS_) || (rm -f *.cube $(TARGET).hsl; false)
	rm -f *.cube
	touch $@

$(TARGET).0on $(TARGET).trg : $(TARGET).sfl
	rm -f $(TARGET).0off
	sfltsyn $(TARGET).sfl $(TARGET)._p1 -tsyn_pass 1 -tsyn_top $(TARGET)
	rm -f *.cube
	sfltsyn $(TARGET).sfl $(TARGET).hsl -tsyn_pass 2 -tsyn_top $(TARGET)
	rm -f *.cube
	rm -f $(TARGET).tif $(TARGET)._p1
	touch $@

$(TARGET).1$(TEST) : $(TARGET).0$(TEST)
	rm -rf $(TARGET).1st $(TARGET).1on $(TARGET).1off
	mkdir $(TARGET).1st
	hsl_nld $(TARGET).hsl $(TARGET).1st
	touch $@

$(TARGET).op1 :
	cat $(OPT_SCR_ONSET) | sed 's/TargeT/$(TARGET)/' > $(TARGET).op1

$(TARGET).ons :
	cat $(OPT_SCR_ONSET_ITR) | sed 's/TargeT/$(TARGET)/' \
	| sed 's/InputpiN/$(ONSET_INPUT_PIN)/' > $(TARGET).tmp
	echo "echo OK!" > $(TARGET).ons
	ITR_TIMES=1 ;\
	while (test $$ITR_TIMES -le $(ONSET_ITERATION)) \
	do \
	   echo "making script file for ONSET iteration $$ITR_TIMES" ;\
	   echo "echo ####### ONSET iteration $$ITR_TIMES #######" >> $(TARGET).ons ;\
	   cat $(TARGET).tmp >> $(TARGET).ons ;\
	   ITR_TIMES=`expr $$ITR_TIMES + 1` ;\
	done
	rm -f $(TARGET).tmp

$(TARGET).2$(TEST) : $(TARGET).1$(TEST) $(TARGET).op1 $(TARGET).ons
	rm -rf $(TARGET).2nd $(TARGET).2on $(TARGET).2off
	mkdir $(TARGET).2nd
	echo $(TARGET).op1 | opt_map $(TARGET) $(TARGET).1st $(SFLLIB) $(START) $(START_EXT)
	rm -f $(TARGET)._tp
	touch $@

$(TARGET).3$(TEST) : $(TARGET).2$(TEST)
	rm -rf $(TARGET).3rd $(TARGET).3on $(TARGET).3off
	mkdir $(TARGET).3rd
	rinv $(TARGET) $(TARGET).2nd $(SFLLIB) $(START) $(START_EXT) -w $(TARGET).3rd
	touch $@

$(TARGET).op2 :
	cat $(OPT_SCR_OPT) | sed 's/TargeT/$(TARGET)/' > $(TARGET).op2

$(TARGET).cpb :
	cat $(OPT_SCR_OPT_ITR) | sed 's/TargeT/$(TARGET)/' \
	| sed 's/InputpiN/$(ONSET_INPUT_PIN)/' > $(TARGET).tmp
	echo "echo OK!" > $(TARGET).cpb
	ITR_TIMES=1 ;\
	while (test $$ITR_TIMES -le $(ONSET_ITERATION_CPB)) \
	do \
	   echo "making script file for ONSET CPB iteration $$ITR_TIMES" ;\
	   echo "echo ####### ONSET CPB iteration $$ITR_TIMES #######" >> $(TARGET).cpb ;\
	   cat $(TARGET).tmp >> $(TARGET).cpb ;\
	   ITR_TIMES=`expr $$ITR_TIMES + 1` ;\
	done
	rm -f $(TARGET).tmp

$(TARGET).4$(TEST) $(TARGET).tsc : $(TARGET).3$(TEST) $(TARGET).op2 $(TARGET).cpb
	rm -rf $(TARGET).4th $(TARGET).4on $(TARGET).4off
	mkdir $(TARGET).4th
	echo $(TARGET).op2 | opt_map $(TARGET) $(TARGET).3rd $(SFLLIB) $(START) $(START_EXT) $(LIB) $(LIB_EXT) 
	rm -f $(TARGET)._tp
	touch $@

$(TARGET).ps : $(TARGET).4$(TEST)
	nld_ps -a Y -c "Foundry: $(FOUNDRY)   Cell_lib: $(CELL_LIB_NAME)" -r "$(VERSION)" \
	-p 1.2 -s A4 -o $(TARGET).ps $(TARGET) $(TARGET).4th $(SFLLIB) $(LIB) $(LIB_EXT) 

$(TARGET).tpg :
	cat $(TPG_SCR) | sed 's/TargeT/$(TARGET)/' | sed 's-PatH-$(PARTHEN)-' > $(TARGET).tpg

$(TARGET).tpd : $(TARGET).4on $(TARGET).tpg
	tpg $(TARGET).tpg

$(TARGET).clk :
	cp $(CLK_DEF) $(TARGET).clk

$(TARGET).tpm : $(TARGET).tpd $(TARGET).trg $(TARGET).tsc $(TARGET).clk
	tpmerge $(TARGET).tpd $(TARGET).trg $(TARGET).tsc $(TARGET).clk > $(TARGET).tpm

$(TARGET).glsh :
	cat $(GLSH_SCR) | sed 's/TargeT/$(TARGET)/' | sed 's-PatH-$(PARTHEN)-' > $(TARGET).glsh

##################################################################
clean :
	rm -rf $(TARGET).hsl* $(TARGET).[0-4]* $(TARGET).op? $(TARGET).ons $(TARGET).cpb \
	       $(TARGET).ps $(TARGET).t* $(TARGET).glsh* $(TARGET).clk

##################################################################
glsh : $(TARGET).tpm $(TARGET).glsh
	glsh $(TARGET).glsh

interface : $(TARGET).4$(TEST)
	@if [ -f $(CELLLIB)/Makefile -o -f $(CELLLIB)/makefile ]; \
	then (dir=`pwd` ; cd $(CELLLIB); make DESIGN=$(TARGET) LOCATION=$$dir/$(TARGET).4th ) ; \
	else echo "No makefiles for netlist conversion" ; \
	fi

lpr : $(TARGET).ps
	lpr $(TARGET).ps

v : $(TARGET).ps
	pageview -w 8.3 -h 11.7 -right -Ws 995 745 -Wp 10 10 $(TARGET).ps

gs : $(TARGET).ps
	gs $(TARGET).ps

##################################################################
