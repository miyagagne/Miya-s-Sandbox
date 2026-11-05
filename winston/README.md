# Winston

A study buddy app. Study and engage in class to make Winston (a Pomeranian) happy and earn coins; spend coins on accessories and treats.

Open `winston/index.html` in a browser (or host the repo on GitHub Pages and open `/winston/`).

## Google sign-in
Create an OAuth Web client ID at console.cloud.google.com (APIs & Services > Credentials), add your site URL as an authorized JavaScript origin, and paste it into `GOOGLE_CLIENT_ID` at the top of the script in `index.html`. Until then the app uses a name-only sign-in. Google sign-in does not work from `file://`.

## What is and isn't real yet
- Real: profile, live-class highlighting (mic speech recognition or typed lines), pop-out widget (desktop Chrome/Edge), high-paw popup, step-by-step recaps, practice questions (multiple choice, fill-in, open answer; case-insensitive; walkthrough earns coins), levels, shop, career linking.
- Local only: data is stored in the browser. Friends use shareable codes (a snapshot), not live sync.
- Not AI: "Ask Winston" finds the best matches in your class materials and what the teacher said. Open-answer grading is keyword-based. A real AI backend would be the next upgrade.
- Materials are entered as `term :: explanation` lines; uploading slides/PDFs is not built yet.
