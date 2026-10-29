// node shot.js <page?query> <out.png> <selector> [transparent=1]
const { chromium } = require('playwright');
const http = require('http'); const fs = require('fs'); const path = require('path');
const root = __dirname;
const types = { '.js': 'text/javascript', '.html': 'text/html', '.png': 'image/png', '.jpg': 'image/jpeg', '.woff2': 'font/woff2', '.woff': 'font/woff' };
const srv = http.createServer((q, r) => { const f = path.join(root, decodeURIComponent(q.url.split('?')[0])); if (!fs.existsSync(f)) { r.writeHead(404); return r.end(); } r.writeHead(200, { 'Content-Type': types[path.extname(f)] || 'application/octet-stream' }); fs.createReadStream(f).pipe(r); }).listen(8766, async () => {
  const b = await chromium.launch();
  const p = await b.newPage({ viewport: { width: 1600, height: 1400 } });
  p.on('pageerror', (e) => console.log('err:', e.message));
  await p.goto('http://localhost:8766/' + process.argv[2]);
  await p.waitForFunction('window.__done === true', null, { timeout: 60000 });
  await (await p.$(process.argv[4] || 'body')).screenshot({ path: path.join(root, process.argv[3]), omitBackground: process.argv[5] !== '0' });
  await b.close(); srv.close();
});
