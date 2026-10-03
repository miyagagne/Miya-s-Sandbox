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

## Same garden on every device (cloud accounts)

Out of the box, accounts live on one device. To sync across devices, connect a free Supabase project:

1. Create a project at supabase.com.
2. SQL Editor → paste `supabase-setup.sql` → Run.
3. Authentication → Providers → Email: keep it enabled. To skip confirmation emails while testing, turn off "Confirm email".
4. Authentication → URL Configuration: set **Site URL** to your app address (for example `https://miyagagne.github.io/Miya-s-Sandbox/`) so password-reset emails come back to the app.
5. Project Settings → API: copy the **Project URL** and the **anon public key** into `CLOUD` near the top of the script in `index.html`.

People then sign in with an email and password. Each person can only read and change their own garden (enforced by row-level security). Cloud mode runs on the standalone site and installed app, not inside the Claude artifact, which blocks outside network calls.
