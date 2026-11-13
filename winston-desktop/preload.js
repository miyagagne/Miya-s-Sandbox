const { contextBridge, ipcRenderer } = require('electron');
contextBridge.exposeInMainWorld('winstonDesktop', {
  isDesktop: true,
  setMode: (m) => ipcRenderer.send('mode', m),
  hide: () => ipcRenderer.send('hide'),
  moveBy: (dx, dy) => ipcRenderer.send('moveby', dx, dy),
  quit: () => ipcRenderer.send('quit'),
  getSettings: () => ipcRenderer.invoke('get-settings'),
  setSettings: (s) => ipcRenderer.invoke('set-settings', s)
});
