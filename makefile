#include makefile.include

.phony: execute check clean depend

FSTAR := fstar.exe
ML_DIR := ml
CACHE_DIR := cache
EXE := Main
SRC := Main

OCAML_SRC_BASE := $(addprefix $(ML_DIR)/, $(SRC))
OCAML_CMX := $(addsuffix .cmx, $(OCAML_SRC_BASE))
FST_SRC := $(addsuffix .fst, $(SRC))
FST_CHECKED := $(addprefix $(CACHE_DIR)/, $(addsuffix .checked, $(FST_SRC)))


FSTAR += --cache_dir $(CACHE_DIR) --cache_checked_modules
FSTAR += --record_hints --use_hints --use_hint_hashes --detail_hint_replay

OCAMLOPT := ocamlfind opt -package fstarlib -linkpkg -g

execute: $(EXE)
	./$(EXE)

$(EXE): ml/FStar_Order.cmx $(OCAML_CMX)
	$(OCAMLOPT) -I ./$(ML_DIR) -o $(EXE) $^

$(ML_DIR)/%.cmx: $(ML_DIR)/%.ml
	$(OCAMLOPT) -I ./$(ML_DIR) -c $<

$(ML_DIR)/%.ml: $(FST_SRC)
	$(FSTAR) $^ --codegen OCaml --odir $(ML_DIR)

check: $(FST_SRC)
	$(FSTAR) $^

clean:
	- rm -rf $(ML_DIR) $(CACHE_DIR) $(EXE) *.hints .depend


.depend:
	$(FSTAR) --dep full $(FST_SRC) --extract '* -FStar -Prims' > .depend

depend: .depend

include .depend

verify-all: $(addsuffix .checked, $(FST_SRC))


$(CACHE_DIR)/%.checked: %
	$(FSTAR) $*
