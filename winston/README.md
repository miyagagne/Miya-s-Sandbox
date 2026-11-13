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

## Motivation Hub (Boost Tab)
A daily affirmation, a mood check-in with a weekly mood strip, quick tools (breathing, 5-4-3-2-1 grounding, talk it out, a memory game, a 25-minute focus session, 3 questions), **My Why** (your goals and reasons), a **Wins Wall** that earns coins, and **Milestones** badges for streaks and XP.

## Leaderboard, Reminders, Social Sharing
- **Leaderboard** (My Dog → Friends): ranks you and your friends by weekly study minutes or streak. Friends appear when they send you a friend code; a fresh code updates their numbers (codes older than a week are marked "Old Code"). Live auto-sync would need an online account system (the Supabase setup in this repo is the natural next step).
- **Reminders** (My Dog → Settings): pick a time, then add a daily repeating reminder to Google Calendar or download a calendar file (.ics) for Apple/Outlook. "Notify Me While The App Is Open" shows an alert (and a browser notification if allowed) when you haven't studied yet today. True background push notifications need a hosted app plus a push server.
- **Install As An App:** when hosted over HTTPS (for example GitHub Pages, folder `/winston/`), the page registers `manifest.webmanifest` and `sw.js`, so it can be added to your home screen and works offline.
- **Social Sharing:** Share My Streak, Instagram Story and TikTok make a 1080x1920 story image of your dog and stats. If your device has a share sheet, you pick the app; otherwise the image is saved, the caption is copied, and Instagram or TikTok opens. Web pages cannot post straight into those apps.

## Live Leaderboard Setup (One Time)
1. In your Supabase project (the same one the Rock Garden app uses): SQL Editor, New query, paste `winston/supabase-leaderboard.sql`, Run.
2. In the app: My Dog, Friends, tap **Share My Stats Live**. Send friends your fresh friend code; when they add it, their numbers update automatically.
- Nothing is sent until you opt in. Shared: name, dog name, weekly minutes, streak, level. The table has no public access; it is only reachable through three functions, and only the holder of your secret (kept in your browser) can update your row. **Delete My Live Data** removes it.
- Live sync needs network access, so it works in the hosted/installed app. Inside Claude's page it may be blocked, in which case it falls back to snapshot mode.

## Host It (GitHub Pages) So It Installs And Syncs
1. GitHub repo, Settings, Pages, Build and deployment: Deploy from a branch.
2. Pick the branch that holds `winston/` (this work is on `claude/modest-archimedes-a3823d`, or merge it into your default branch first) and the `/ (root)` folder, then Save.
3. After a minute, open `https://miyagagne.github.io/Miya-s-Sandbox/winston/` (adjust if your repo name differs). In Chrome use the install icon in the address bar; on iPhone use Share, Add to Home Screen.

## Microphone (Live Class)
Winston opens your laptop's real microphone: pick the device, watch the live level meter, and see exactly what it hears. Speech becomes text in one of two ways: **Browser Speech** (Chrome/Edge's built-in service, sends audio to Google) or **On-Device Speech** (a small Whisper model that runs on your laptop; about 40 MB downloaded once, then private and offline). It switches to on-device automatically if the browser service is unavailable, and always works in the desktop widget. If the mic is blocked, the app says why and you can type or dictate instead.

## Class Summary And Notes
- After class, the recap is a short **bullet-point summary** of what the teacher said (key points, topics from your materials, dates and to-dos, your own notes, a quick self-check), whether or not you uploaded study cards. Filler words and repeats are removed.
- The **Notes** use the same structure and are readable (headings and bullets). Tap **Edit** to change them as simple text (`#` title, `##` headings, `-` bullets); edited notes can be saved to Google Docs again.
- The floating widget shows Winston on the left with speech bubbles beside him. The **high paw** pops up as a bubble with a countdown while he waves his paw; catch it for 4 coins, miss it and he gets a little sad.
