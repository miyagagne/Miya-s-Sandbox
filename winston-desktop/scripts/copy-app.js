// Copies the Winston web app (../winston) into ./app so it is bundled with the desktop widget.
const fs = require('fs');
const path = require('path');
const src = path.join(__dirname, '..', '..', 'winston');
const dst = path.join(__dirname, '..', 'app');
fs.mkdirSync(dst, { recursive: true });
for (const f of ['index.html', 'icon-192.png', 'icon-512.png']) {
  fs.copyFileSync(path.join(src, f), path.join(dst, f));
}
console.log('Copied Winston web app into', dst);
