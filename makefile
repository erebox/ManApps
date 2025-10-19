# Makefile per ManApps - compatibile con sh/bash (MinGW, MSYS, w64devkit)

SRC_DIR     = src
OBJ_DIR     = obj
BIN_DIR     = bin
RES_DIR     = res
SAMPLES_DIR = samples
TEST_DIR    = test

TARGET      = $(BIN_DIR)/ManApps.exe
SRC         = $(SRC_DIR)/ManApps.cpp
RES         = $(RES_DIR)/ManApps.rc
OBJ         = $(OBJ_DIR)/ManApps.o
RES_OBJ     = $(OBJ_DIR)/ManApps_res.o

CXX         = g++
RC          = windres
CXXFLAGS    = -Wall -O2 -mwindows
RCFLAGS     = -O coff

# Regole principali

all: dirs $(TARGET) copy

dirs:
	@echo "Creazione directory per compilare e testare"
	mkdir -p $(OBJ_DIR) $(BIN_DIR) $(TEST_DIR)

$(RES_OBJ): $(RES)
	$(RC) $(RCFLAGS) $< -o $@

$(TARGET): $(SRC) $(RES_OBJ)
	$(CXX) $(CXXFLAGS) $(SRC) $(RES_OBJ) -o $(TARGET)

copy:
	@echo "Impostazione di test"
	cp -f $(TARGET) $(TEST_DIR)/ || true
	cp -rf $(SAMPLES_DIR)/* $(TEST_DIR)/ 2>/dev/null || true

clean:
	@echo "Pulizia"
	rm -rf $(OBJ_DIR) $(BIN_DIR) $(TEST_DIR)

.PHONY: all clean distclean copy dirs