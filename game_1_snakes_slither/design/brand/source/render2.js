const { chromium } = require('playwright');
const http = require('http'); const fs = require('fs'); const path = require('path');
const root = __dirname;
const srv = http.createServer((q, r) => { const f = path.join(root, decodeURIComponent(q.url.split('?')[0])); if (!fs.existsSync(f)) { r.writeHead(404); return r.end(); } r.writeHead(200, { 'Content-Type': f.endsWith('.js') ? 'text/javascript' : 'text/html' }); fs.createReadStream(f).pipe(r); }).listen(8765, async () => {
  const b = await chromium.launch({ args: ['--use-gl=angle', '--use-angle=swiftshader', '--enable-unsafe-swiftshader'] });
  const p = await b.newPage({ viewport: { width: 2400, height: 2400 } });
  p.on('console', (m) => console.log('console:', m.text())); p.on('pageerror', (e) => console.log('err:', e.message));
  await p.goto('http://localhost:8765/' + (process.argv[2]||'scene.html'));
  await p.waitForFunction('window.__done === true', null, { timeout: 120000 });
  const data = await p.evaluate(() => document.querySelector('canvas').toDataURL('image/png'));
  fs.writeFileSync(path.join(root, (process.argv[3]||'raw.png')), Buffer.from(data.split(',')[1], 'base64'));
  await b.close(); srv.close();
});
