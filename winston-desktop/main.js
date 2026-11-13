// Winston desktop widget: a small always-on-top window that floats over whatever you're doing.
const { app, BrowserWindow, Tray, Menu, globalShortcut, ipcMain, screen, nativeImage, shell, session, systemPreferences } = require('electron');
const path = require('path');
const fs = require('fs');

const SIZES = { widget: { w: 340, h: 560 }, full: { w: 440, h: 860 } };
let win = null;
let tray = null;
let quitting = false;
let cfg = { mode: 'widget', onTop: true, opacity: 1, openAtLogin: false, bounds: {} };

const cfgFile = () => path.join(app.getPath('userData'), 'winston-settings.json');
function loadCfg() { try { cfg = { ...cfg, ...JSON.parse(fs.readFileSync(cfgFile(), 'utf8')) }; } catch (e) { /* first run */ } }
function saveCfg() { try { fs.writeFileSync(cfgFile(), JSON.stringify(cfg)); } catch (e) { /* ignore */ } }

function appIndex() {
  const bundled = path.join(__dirname, 'app', 'index.html');
  if (fs.existsSync(bundled)) return bundled;
  return path.join(__dirname, '..', 'winston', 'index.html'); // running straight from the repo
}

function applyTop() {
  if (!win) return;
  win.setAlwaysOnTop(!!cfg.onTop, 'screen-saver');
  win.setVisibleOnAllWorkspaces(!!cfg.onTop, { visibleOnFullScreen: true });
  if (tray) buildTray();
}

function clampToScreen(b, w, h) {
  const wa = screen.getDisplayMatching({ x: b.x, y: b.y, width: w, height: h }).workArea;
  return { x: Math.min(Math.max(b.x, wa.x), wa.x + wa.width - w), y: Math.min(Math.max(b.y, wa.y), wa.y + wa.height - h) };
}

function createWindow() {
  const { w, h } = SIZES[cfg.mode];
  const wa = screen.getPrimaryDisplay().workArea;
  const saved = cfg.bounds[cfg.mode];
  const pos = clampToScreen(saved || { x: wa.x + wa.width - w - 24, y: wa.y + wa.height - h - 24 }, w, h);
  win = new BrowserWindow({
    width: w, height: h, x: pos.x, y: pos.y,
    frame: false, transparent: true, hasShadow: false, resizable: false, maximizable: false, fullscreenable: false,
    show: false, title: 'Winston', backgroundColor: '#00000000',
    icon: path.join(__dirname, 'build', 'icon.png'),
    webPreferences: { preload: path.join(__dirname, 'preload.js'), contextIsolation: true, nodeIntegration: false, backgroundThrottling: false }
  });
  win.setOpacity(cfg.opacity);
  applyTop();
  win.loadFile(appIndex(), { query: { desktop: '1', mode: cfg.mode } });
  win.once('ready-to-show', () => win.show());
  win.on('close', (e) => { if (!quitting) { e.preventDefault(); win.hide(); } });
  let t = null;
  win.on('moved', () => { clearTimeout(t); t = setTimeout(() => { const b = win.getBounds(); cfg.bounds[cfg.mode] = { x: b.x, y: b.y }; saveCfg(); }, 400); });
  win.webContents.setWindowOpenHandler(({ url }) => { if (/^https?:/.test(url)) shell.openExternal(url); return { action: 'deny' }; });
  win.webContents.on('will-navigate', (e, url) => { if (/^https?:/.test(url)) { e.preventDefault(); shell.openExternal(url); } });
}

function setMode(m) {
  if (!win || !SIZES[m] || m === cfg.mode) return;
  const old = win.getBounds();
  const { w, h } = SIZES[m];
  // keep the bottom-right corner where it is, so the widget grows up and to the left
  const pos = clampToScreen({ x: old.x + old.width - w, y: old.y + old.height - h }, w, h);
  cfg.mode = m;
  win.setResizable(true);
  win.setBounds({ x: pos.x, y: pos.y, width: w, height: h });
  win.setResizable(false);
  cfg.bounds[m] = { x: pos.x, y: pos.y };
  saveCfg();
  if (tray) buildTray();
}

function toggleShow() { if (!win) return; if (win.isVisible()) win.hide(); else { win.show(); win.focus(); } }

function buildTray() {
  const menu = Menu.buildFromTemplate([
    { label: win && win.isVisible() ? 'Hide Winston' : 'Show Winston', click: toggleShow },
    { label: cfg.mode === 'widget' ? 'Open Full App' : 'Collapse To Widget', click: () => { win.webContents.executeJavaScript(`ACTIONS.${cfg.mode === 'widget' ? 'dwexpand' : 'dwcollapse'}()`); } },
    { type: 'separator' },
    { label: 'Always On Top', type: 'checkbox', checked: !!cfg.onTop, click: (i) => { cfg.onTop = i.checked; saveCfg(); applyTop(); } },
    { label: 'Start With My Computer', type: 'checkbox', checked: !!cfg.openAtLogin, click: (i) => { cfg.openAtLogin = i.checked; saveCfg(); app.setLoginItemSettings({ openAtLogin: i.checked }); } },
    { type: 'separator' },
    { label: 'Quit Winston', click: () => { quitting = true; app.quit(); } }
  ]);
  tray.setContextMenu(menu);
}

function createTray() {
  let img = nativeImage.createFromPath(path.join(__dirname, 'build', 'tray.png'));
  img = img.resize({ width: 18, height: 18 });
  tray = new Tray(img);
  tray.setToolTip('Winston — your study buddy dog');
  tray.on('click', toggleShow);
  buildTray();
}

ipcMain.on('mode', (e, m) => setMode(m));
ipcMain.on('hide', () => { if (win) win.hide(); });
ipcMain.on('quit', () => { quitting = true; app.quit(); });
ipcMain.handle('get-settings', () => ({ onTop: cfg.onTop, opacity: cfg.opacity, openAtLogin: cfg.openAtLogin, mode: cfg.mode }));
ipcMain.handle('set-settings', (e, s) => {
  if (typeof s.onTop === 'boolean') cfg.onTop = s.onTop;
  if (typeof s.opacity === 'number') cfg.opacity = Math.min(1, Math.max(0.4, s.opacity));
  if (typeof s.openAtLogin === 'boolean') { cfg.openAtLogin = s.openAtLogin; app.setLoginItemSettings({ openAtLogin: s.openAtLogin }); }
  saveCfg();
  if (win) { win.setOpacity(cfg.opacity); applyTop(); }
  return { onTop: cfg.onTop, opacity: cfg.opacity, openAtLogin: cfg.openAtLogin, mode: cfg.mode };
});

if (!app.requestSingleInstanceLock()) { app.quit(); }
else {
  app.on('second-instance', () => { if (win) { win.show(); win.focus(); } });
  app.whenReady().then(() => {
    app.setAppUserModelId('com.winston.studybuddy');
    loadCfg();
    // let the widget use your microphone (live class notes) and show notifications
    const allowed = ['media', 'notifications', 'clipboard-sanitized-write'];
    session.defaultSession.setPermissionRequestHandler((wc, perm, cb) => cb(allowed.includes(perm)));
    session.defaultSession.setPermissionCheckHandler((wc, perm) => allowed.includes(perm));
    if (process.platform === 'darwin' && systemPreferences.askForMediaAccess) systemPreferences.askForMediaAccess('microphone').catch(() => {});
    createWindow();
    createTray();
    globalShortcut.register('CommandOrControl+Shift+W', toggleShow);
    app.on('activate', () => { if (win) win.show(); });
  });
  app.on('before-quit', () => { quitting = true; });
  app.on('will-quit', () => globalShortcut.unregisterAll());
  app.on('window-all-closed', (e) => { e.preventDefault(); }); // keep living in the tray
}
