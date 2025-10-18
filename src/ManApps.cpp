#include <windows.h>
#include <commctrl.h>
#include <fstream>
#include <iostream>
#include <string>
#include <map>
#include <vector>
#include <filesystem>
#include "json.hpp" // https://github.com/nlohmann/json

using json = nlohmann::json;
namespace fs = std::filesystem;

#define IDI_APP_ICON 101

struct AppConfig {
    std::string link;
    std::string dir;
    std::string base;
    std::vector<std::string> list;
};

std::map<std::string,std::string> state;
std::map<std::string, AppConfig> config;
std::map<HWND,std::string> comboMap;
std::map<HWND,std::string> buttonMap;
std::map<HWND,std::string> labelMap;
std::map<HWND,bool> dirtyLabels;

int runCommandHidden(const std::string& cmd) {
    STARTUPINFOA si{};
    PROCESS_INFORMATION pi{};
    si.cb = sizeof(si);
    si.dwFlags = STARTF_USESHOWWINDOW;
    si.wShowWindow = SW_HIDE;
    std::string command = "cmd.exe /C " + cmd;
    char* cmdline = command.data();
    BOOL success = CreateProcessA(NULL, cmdline, NULL, NULL, FALSE, CREATE_NO_WINDOW, NULL, NULL, &si, &pi);
    if (!success) {
        DWORD err = GetLastError();
        MessageBoxA(NULL, ("Errore CreateProcess: " + std::to_string(err)).c_str(), "Errore", MB_OK | MB_ICONERROR);
        return -1;
    }
    WaitForSingleObject(pi.hProcess, INFINITE);
    DWORD exitCode;
    GetExitCodeProcess(pi.hProcess, &exitCode);
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
    return (int)exitCode;
}

void createJunction(const std::string& link, const std::string& dir, const std::string& base, const std::string& version) {
    std::string target = dir + "/" + base + version;
    std::string linkPath = link;
    if (fs::exists(linkPath)) {
        std::string removeCmd = "rmdir \"" + linkPath + "\"";
        runCommandHidden(removeCmd);
    }
    std::string cmd = "mklink /J \"" + linkPath + "\" \"" + target + "\"";
    int res = runCommandHidden(cmd);
    if (res != 0)
        MessageBoxA(NULL, ("Errore nel creare junction:\n" + cmd).c_str(), "Errore", MB_OK | MB_ICONERROR);
}

bool loadJsonConfig() {
    std::ifstream file("ManApps.json");
    if (!file.is_open())
        return false;
    json j;
    file >> j;
    for (auto it = j.begin(); it != j.end(); ++it) {
        AppConfig a;
        a.link = (*it)["link"].get<std::string>();
        a.dir  = (*it)["dir"].get<std::string>();
        a.base = (*it)["base"].get<std::string>();
        for (auto& v : (*it)["list"])
            a.list.push_back(v.get<std::string>());
        config[it.key()] = a;
    }
    return true;
}

void loadJsonState() {
    std::ifstream f("ManApps.state.json");
    if (!f.is_open())
        return;
    json j;
    f >> j;
    for (auto it = j.begin(); it != j.end(); ++it)
        state[it.key()] = it.value().get<std::string>();
}

void saveJsonState() {
    json j;
    for (auto& s : state)
        j[s.first] = s.second;
    std::ofstream f("ManApps.state.json");
    f << j.dump(4);
}

LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam);
HBRUSH hBrushNormal = CreateSolidBrush(RGB(245,245,245));
HBRUSH hBrushDirty  = CreateSolidBrush(RGB(255,220,180));
HFONT hFont = NULL;

int WINAPI WinMain(HINSTANCE hInst, HINSTANCE, LPSTR, int ncmdshow) {
    loadJsonConfig();
    loadJsonState();

    WNDCLASSEX wc{};
    wc.cbSize = sizeof(WNDCLASSEX);
    wc.lpfnWndProc = WndProc;
    wc.hInstance = hInst;
    wc.lpszClassName = "ManAppsClass";
    wc.hCursor = LoadCursor(NULL, IDC_ARROW);
    wc.hbrBackground = (HBRUSH)(COLOR_BTNFACE+1);
    wc.hIcon = (HICON)LoadImage(hInst, MAKEINTRESOURCE(IDI_APP_ICON), IMAGE_ICON, 32, 32, LR_DEFAULTCOLOR);
    wc.hIconSm = (HICON)LoadImage(hInst, MAKEINTRESOURCE(IDI_APP_ICON), IMAGE_ICON, 16, 16, LR_DEFAULTCOLOR);
    RegisterClassEx(&wc);

    int winHeight = 30 + (int)config.size() * 43;
    HWND hwnd = CreateWindowEx(WS_EX_APPWINDOW, "ManAppsClass", "ManApps", 
        WS_OVERLAPPED | WS_CAPTION | WS_SYSMENU | WS_MINIMIZEBOX, CW_USEDEFAULT, CW_USEDEFAULT, 420, winHeight, NULL, NULL, hInst, NULL);

    // Font moderno Segoe UI
    hFont = CreateFont(-16, 0, 0, 0, FW_NORMAL, FALSE, FALSE, FALSE, DEFAULT_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, CLEARTYPE_QUALITY, DEFAULT_PITCH, TEXT("Segoe UI"));

    ShowWindow(hwnd, ncmdshow);
    UpdateWindow(hwnd);

    MSG msg{};
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    saveJsonState();
    DeleteObject(hFont);
    DeleteObject(hBrushNormal);
    DeleteObject(hBrushDirty);
    return 0;
}

LRESULT CALLBACK WndProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    static int y = 20;
    static int rowId = 0;

    switch(msg) {
    case WM_CREATE:
    {
        for (auto& c : config) {
            const int xLabel = 20;
            const int xCombo = 120;
            const int xButton = 290;

            // Label
            HWND hLabel = CreateWindow("STATIC", c.first.c_str(), WS_VISIBLE | WS_CHILD | SS_LEFT | SS_CENTERIMAGE, xLabel, y, 90, 25, hwnd, (HMENU)(UINT_PTR)(1000 + rowId), NULL, NULL);
            labelMap[hLabel] = c.first;
            dirtyLabels[hLabel] = false;
            SendMessage(hLabel, WM_SETFONT, (WPARAM)hFont, TRUE);

            // ComboBox
            HWND hCombo = CreateWindow(WC_COMBOBOX, NULL, CBS_DROPDOWNLIST | WS_CHILD | WS_VISIBLE | WS_VSCROLL, xCombo, y, 150, 120, hwnd, (HMENU)(UINT_PTR)(2000 + rowId), NULL, NULL);
            for (auto& v : c.second.list)
                SendMessage(hCombo, CB_ADDSTRING, 0, (LPARAM)v.c_str());

            std::string sel = state.count(c.first) ? state[c.first] : c.second.list[0];
            SendMessage(hCombo, CB_SELECTSTRING, -1, (LPARAM)sel.c_str());
            comboMap[hCombo] = c.first;
            SendMessage(hCombo, WM_SETFONT, (WPARAM)hFont, TRUE);

            // Pulsante
            HWND hBtn = CreateWindow("BUTTON", "Applica", WS_TABSTOP | WS_VISIBLE | WS_CHILD | BS_PUSHBUTTON, xButton, y, 90, 28, hwnd, (HMENU)(UINT_PTR)(3000 + rowId), NULL, NULL);
            buttonMap[hBtn] = c.first;
            SendMessage(hBtn, WM_SETFONT, (WPARAM)hFont, TRUE);

            y += 40;
            rowId++;
        }
        break;
    }

    case WM_COMMAND:
    {
        HWND hCtrl = (HWND)lParam;
        WORD code = HIWORD(wParam);

        // Cambio selezione combo
        if (comboMap.count(hCtrl) && code == CBN_SELCHANGE) {
            std::string tool = comboMap[hCtrl];
            HWND hLabel = nullptr;
            for (auto& kv : labelMap)
                if (kv.second == tool) { hLabel = kv.first; break; }
            int idx = SendMessage(hCtrl, CB_GETCURSEL, 0, 0);
            char buf[256];
            SendMessage(hCtrl, CB_GETLBTEXT, idx, (LPARAM)buf);
            std::string sel(buf);
            if (state.count(tool) && state[tool] == sel) {
                dirtyLabels[hLabel] = false;
                SetWindowText(hLabel, labelMap[hLabel].c_str());
            } else {
                dirtyLabels[hLabel] = true;
                std::string text = labelMap[hLabel];
                SetWindowText(hLabel, text.c_str());
            }
            InvalidateRect(hLabel, NULL, TRUE);
        }

        // Pulsante Applica
        if (buttonMap.count(hCtrl)) {
            std::string tool = buttonMap[hCtrl];
            HWND hCombo = nullptr;
            for (auto& kv : comboMap)
                if (kv.second == tool) { hCombo = kv.first; break; }
            int idx = SendMessage(hCombo, CB_GETCURSEL, 0, 0);
            char buf[256];
            SendMessage(hCombo, CB_GETLBTEXT, idx, (LPARAM)buf);
            AppConfig& c = config[tool];
            createJunction(c.link, c.dir, c.base, buf);
            state[tool] = buf;
            saveJsonState();
            // Aggiorna label
            HWND hLabel = nullptr;
            for (auto& kv : labelMap)
                if (kv.second == tool) { hLabel = kv.first; break; }
            if (hLabel) {
                dirtyLabels[hLabel] = false;
                SetWindowText(hLabel, labelMap[hLabel].c_str());
                InvalidateRect(hLabel, NULL, TRUE);
            }
        }
        break;
    }

    case WM_CTLCOLORSTATIC:
    {
        HDC hdc = (HDC)wParam;
        HWND hLabel = (HWND)lParam;
        SetTextColor(hdc, RGB(0,0,0));
        if (dirtyLabels[hLabel])
            return (LRESULT)hBrushDirty;
        return (LRESULT)hBrushNormal;
    }

    case WM_DESTROY:
        PostQuitMessage(0);
        break;

    default:
        return DefWindowProc(hwnd, msg, wParam, lParam);
    }
    return 0;
}
