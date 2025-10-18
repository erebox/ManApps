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
JSON_HEADER = $(SRC_DIR)/json.hpp

CXX         = g++
RC          = windres

CXXFLAGS    = -Wall -O2 -mwindows
RCFLAGS     = -O coff

JSON_URL    = https://raw.githubusercontent.com/nlohmann/json/develop/single_include/nlohmann/json.hpp

# Regole principali

all: dirs json $(TARGET) copy

dirs:
	@mkdir -p $(OBJ_DIR) $(BIN_DIR) $(TEST_DIR)

# === Scarica json.hpp se mancante ===
json:
	@if [ ! -f "$(JSON_HEADER)" ]; then \
		echo "- Scaricamento json.hpp..."; \
		curl -L -o "$(JSON_HEADER)" "$(JSON_URL)" 2>/dev/null || \
		wget -O "$(JSON_HEADER)" "$(JSON_URL)" 2>/dev/null || \
		(echo "- Errore: impossibile scaricare json.hpp" && exit 1); \
	else \
		echo "- json.hpp presente."; \
	fi

$(RES_OBJ): $(RES)
	@echo "- Compilazione risorsa..."
	$(RC) $(RCFLAGS) $< -o $@

$(TARGET): $(SRC) $(RES_OBJ)
	@echo "- Compilazione e linking..."
	$(CXX) $(CXXFLAGS) $(SRC) $(RES_OBJ) -o $(TARGET)

copy:
	@echo "- Copia eseguibile e samples nella cartella test..."
	cp -f $(TARGET) $(TEST_DIR)/ || true
	cp -rf $(SAMPLES_DIR)/* $(TEST_DIR)/ 2>/dev/null || true

clean:
	@echo "- Pulizia file oggetto e binari..."
	rm -f $(OBJ_DIR)/*.o $(BIN_DIR)/*.exe
	rm -rf $(TEST_DIR)/*
	@if [ -f "$(JSON_HEADER)" ]; then \
		echo "- Rimozione di $(JSON_HEADER)..."; \
		rm -f "$(JSON_HEADER)"; \
	fi

distclean: clean
	@echo "Pulizia completa..."
	rm -rf $(OBJ_DIR) $(BIN_DIR) $(TEST_DIR)

.PHONY: all clean distclean copy dirs json
