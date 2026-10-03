# Rock Garden Organizer

Every activity is a stone in a sand pit, sized by its weight. Tap a stone for its calendar, notes and tasks.

## Install it as an app

The app is a Progressive Web App: `index.html`, `manifest.webmanifest`, `sw.js` and the icons.

1. Host the folder over HTTPS. The simplest way is GitHub Pages: repo **Settings → Pages**, deploy from the branch that holds these files, root folder.
2. Open the Pages URL.
   - **Chrome, Edge (desktop or Android):** use the install icon in the address bar, or menu → Install app.
   - **iPhone/iPad (Safari):** Share → Add to Home Screen.
3. It then opens in its own window and works offline.

You can also double-click `index.html` to use it in a browser with no hosting. It can't be installed that way.

## Notes

- Each person creates a username and password on first open. Accounts and gardens are stored on that device only, and each garden is encrypted with its owner’s password (no reset is possible). They are not synced between devices.
- Google Calendar and Notion sync only works when the page is opened inside Claude (the published artifact). The installed app shows the rest of the features without it.
