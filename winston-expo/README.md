# Winston For Expo Go

A native app shell (React Native + Expo SDK 58) that opens Winston full-screen on your phone. It loads the live
Winston site, so every update to the web app shows up automatically — no rebuild needed.

## Run it in Expo Go

1. Install **Expo Go** on your phone (App Store / Google Play).
2. On your computer (needs [Node.js](https://nodejs.org) 20+):

```bash
cd winston-expo
npm install
npx expo start
```

3. Scan the QR code:
   - **iPhone:** open the Camera app and point it at the QR code, then tap the Expo Go banner.
   - **Android:** open Expo Go and tap **Scan QR code**.

Phone and computer must be on the same Wi-Fi. If they can't see each other (school or campus Wi-Fi), use:

```bash
npx expo start --tunnel
```

## No computer setup: Expo Snack

Open https://snack.expo.dev, paste the contents of `App.js` into the editor, and add the dependencies
`react-native-webview`, `expo-audio`, `expo-status-bar` and `react-native-safe-area-context` when prompted.
Scan the Snack QR code with Expo Go.

## What works

- The whole Winston app: Home, Classes, Practice, Boost, My Dog, Light/Dark, Title Case, the shop, quests and friends.
- Microphone permission is requested at launch for live class notes.
- Links to Google Docs, Google Calendar and other sites open in your phone's browser.
- Android back button goes back inside Winston. Pull down to refresh.

## Limits (Expo Go)

- Winston can't float **over other apps** on a phone — iOS and Android don't allow that without a custom native
  build. Inside the app he stays on screen as the small dog in the corner.
- Needs an internet connection (it loads the hosted site). An offline screen with a **Try Again** button shows if it can't connect.
- Browser-only features (like Chrome's floating window) are replaced by the in-app dog.
- Live class notes use the phone's microphone through the web view. Speech recognition quality depends on the phone.

## Changing the web address

The site URL is the `SITE` constant at the top of `App.js`.
