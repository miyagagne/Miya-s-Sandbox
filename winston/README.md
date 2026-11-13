# Winston

A study buddy app. Study and engage in class to make Winston (a Pomeranian) happy and earn coins; spend coins on accessories and treats.

Open `winston/index.html` in a browser (or host the repo on GitHub Pages and open `/winston/`).

## Google sign-in
Create an OAuth Web client ID at console.cloud.google.com (APIs & Services > Credentials), add your site URL as an authorized JavaScript origin, and paste it into `GOOGLE_CLIENT_ID` at the top of the script in `index.html`. Until then the app uses a name-only sign-in. Google sign-in does not work from `file://`.

## What is and isn't real yet
- Real: profile, live-class highlighting (mic speech recognition or typed lines), pop-out widget (desktop Chrome/Edge), high-paw popup, step-by-step recaps, practice questions (multiple choice, fill-in, open answer; case-insensitive; walkthrough earns coins), levels, shop.
- Local only: data is stored in the browser. Friends use shareable codes (a snapshot), not live sync.
- AI: on the published Claude page (the `sample` artifact capability), **Ask Winston** is answered by Claude and recaps are written by Claude as step-by-step explanations, with chat memory. In the standalone file there is no Claude to ask, so Ask Winston falls back to searching your notes and recaps are built from your materials. Open-answer grading is still keyword-based.
- Materials are entered as `term :: explanation` lines; uploading slides/PDFs is not built yet.

## Course materials
Each class has a Materials tab with course-wide and weekly sections. Upload PDF, Word (.docx), PowerPoint (.pptx) or text files, or paste notes; Winston turns them into study cards (AI-written on the published Claude page, definition-spotting elsewhere). Live class and practice can be limited to one week. File readers load from cdnjs, so uploads need an internet connection. Scanned-image PDFs have no text to read.

## Feelings, calendar, timer, notes
- **How are you feeling?** (Home) bored opens a Memory Match game made from your study cards; stressed guides 5 deep breaths; unmotivated shows your goals and a pep talk; okay and sparked open a "let's get started" plan (sparked is extra excited).
- **Name your dog** during setup or in Settings (the gear on Home).
- **Calendar** per class: add events, set when the class meets, and pull exam and assignment dates out of an uploaded syllabus.
- **Study timer**: track time per class against a weekly goal; live class and practice rounds are logged automatically.
- **Class notes**: during live class the dog takes notes; afterwards they are organized (by Claude on the published page) and can be saved to Google Docs in `Winston Notes > <class>` on your Drive (needs the Google Drive connector and your OK), or downloaded.

## How the app is organized
- **Home:** your dog, one "Today" card (goal, next date, weekly study time), Focus and Start class buttons, and how-are-you-feeling.
- **Classes:** one card per class. Inside a class: **Live** (take notes in class), **Review** (recap, Ask Winston, notes saved to Google Docs), **Materials** (files, weeks, study cards), **Plan** (study time, calendar, schedule).
- **Practice:** quiz yourself on one class or all of them.
- **My dog:** shop, friends and settings.
- **Floating widget:** the 🪟 button on Home (or auto on open) pops Winston into a small always-on-top window that stays visible over Brightspace, Google and other tabs (desktop Chrome or Edge). Keep the Winston tab open.

## Growth And Habit Features
- **Title Case** everywhere (headings, buttons, tabs), e.g. "Welcome Back".
- **Daily Quests + Daily Chest:** finish today's goal, study 20 minutes, answer 10 questions, then open the chest for bonus coins.
- **Ranks:** Pup Scholar up to Dean's List Legend as you level up.
- **Share My Streak:** makes a postable picture of your dog, streak and stats (uses your device's share sheet, or downloads the PNG). **Invite A Friend** shares an invite message.
