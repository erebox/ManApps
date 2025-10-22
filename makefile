# Makefile per ManApps - compatibile con sh/bash (MinGW, MSYS, w64devkit)

SRC_DIR = src
OBJ_DIR = obj
BIN_DIR = bin
RES_DIR = res
SAMP_DIR = samples
TEST_DIR = test

TARGET = $(BIN_DIR)/ManApps.exe
SRC = $(SRC_DIR)/manapps.cpp
RES = $(RES_DIR)/manapps.rc
RES_OBJ = $(OBJ_DIR)/manapps_res.o

CXX = g++
CXXFLG = -W -Wall -Os -s -fno-exceptions -fno-rtti -mwindows
RC = windres
RCFLG = -Isrc -O coff

# Regole principali
all: $(TARGET) copy

$(RES_OBJ): $(RES)
	@mkdir -p $(OBJ_DIR)
	$(RC) $(RCFLG) $< -o $@

$(TARGET): $(SRC) $(RES_OBJ)
	@mkdir -p $(BIN_DIR)
	$(CXX) $(CXXFLG) $^ -o $@

copy:
	@mkdir -p $(TEST_DIR)
	cp -f $(TARGET) $(TEST_DIR)/ || true
	cp -rf $(SAMP_DIR)/* $(TEST_DIR)/ 2>/dev/null || true

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR) $(TEST_DIR)

.PHONY: all clean copy 