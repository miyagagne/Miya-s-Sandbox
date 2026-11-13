# Winston Desktop Widget

Winston, your study therapy dog, as a small always-on-top window that floats over whatever you're doing (Brightspace, Google Docs, a video, anything). It lives in your system tray, can start with your computer, and sends real notifications.

## Get The App (Download)
1. On GitHub: **Actions** tab, **Build Winston Desktop**, **Run workflow**. (Or push a tag like `winston-v1.0.0` to also publish a Release.)
2. When it finishes (about 5-10 minutes), open the run and download **winston-windows-latest**, **winston-macos-latest** or **winston-ubuntu-latest**.
3. Install it: Windows runs the `.exe`, Mac opens the `.dmg`, Linux runs the `.AppImage`.

The builds are unsigned, so Windows SmartScreen ("More info, Run anyway") and Mac Gatekeeper (right-click the app, Open) will ask you to confirm the first time.

## Or Run It From Source
```bash
cd winston-desktop
npm install
npm start
```

## Using It
- **Widget mode** (340x560): pet Winston, breathe, get a boost, talk it out, quick flashcard, quick note, focus timer, daily goal.
- **⤢ Open Full App:** the whole app (classes, calendar, notes, practice, shop, friends, Motivation Hub) at 440x860. **▭ Widget** collapses it back.
- **📌** toggles always-on-top. **–** hides to the tray. Closing the window also hides it; quit from the tray icon.
- **Ctrl/Cmd + Shift + W** shows or hides Winston from anywhere.
- Tray menu: Always On Top, Start With My Computer, Open Full App.
- Settings (full app, My Dog, Settings) has opacity, start-with-computer, and **Export / Import My Data**.

## Good To Know
- Your data is stored in the desktop app separately from the web version. Use Export / Import to move it across.
- Live class listening (the microphone) is not available in the desktop widget; type or dictate notes instead, or use the web app for the mic.
- Claude-powered answers, AI recaps and saving notes straight to Google Docs only work in the web version inside Claude. Everything else works offline, and the live leaderboard needs internet.
