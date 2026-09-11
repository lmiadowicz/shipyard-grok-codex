#!/usr/bin/env npx tsx
/**
 * TypeScript port of Piotr Random-Skills mega-card/render.py
 * Upstream: https://github.com/piotrkrych2/Random-Skills (mega-card)
 * English template.html (Skill web / GOLD·SILVER·BRONZE).
 */
import { spawn, execSync } from "node:child_process";
import { existsSync, mkdirSync, readFileSync, unlinkSync, writeFileSync, statSync } from "node:fs";
import { dirname, join, resolve, basename } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const TEMPLATE = join(HERE, "template.html");
const WINDOW = "1600,1240";
const INDICATOR_SLUG = /^[a-z0-9]+(?:-[a-z0-9]+)+$/;

function parseTraits(text: string): Record<string, [number, number, number]> {
  const traits: Record<string, [number, number, number]> = {};
  const re =
    /^\|\s*(T\d{2})\s*\|\s*([^|]+?)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*$/gm;
  let m: RegExpExecArray | null;
  while ((m = re.exec(text))) {
    const tid = m[1];
    const name = m[2].trim();
    if (INDICATOR_SLUG.test(name) || tid in traits) continue;
    traits[tid] = [Number(m[3]), Number(m[4]), Number(m[5])];
  }
  const missing = Array.from({ length: 24 }, (_, i) => `T${String(i + 1).padStart(2, "0")}`).filter(
    (id) => !(id in traits),
  );
  if (missing.length) throw new Error(`Report has no trait rows for: ${missing.join(", ")}`);
  return traits;
}

function plural(n: number, one: string, many: string): string {
  return n === 1 ? one : many;
}

function parseMeta(text: string): [string | null, string] {
  const num = (pattern: RegExp) => {
    const m = text.match(pattern);
    return m ? Number(m[1]) : null;
  };
  const dateM = text.match(/\*\*(?:Scan date|Data skanu):\*\*\s*(\d{4}-\d{2}-\d{2})/);
  const episodes = num(/(?:Task episodes|Epizody zadaniowe)\s*\|\s*\**(\d+)/);
  const sessions = num(/(?:Scanned|Przeskanowane)\s*\|\s*(\d+)/);
  const days = num(/\((\d+)\s*(?:days?|dni)\)/);
  const parts: string[] = [];
  if (episodes != null) parts.push(`${episodes} ${plural(episodes, "episode", "episodes")}`);
  if (sessions != null) parts.push(`${sessions} ${plural(sessions, "session", "sessions")}`);
  if (days != null) parts.push(`${days} ${days === 1 ? "day" : "days"}`);
  if (!parts.length) {
    if (/MEASURED/i.test(text)) parts.push("MEASURED local");
    if (dateM) parts.push(dateM[1]);
  }
  return [dateM ? dateM[1] : null, parts.join(" · ")];
}

function findChrome(): string | null {
  for (const c of [
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
    "/Applications/Chromium.app/Contents/MacOS/Chromium",
  ]) {
    if (existsSync(c)) return c;
  }
  for (const c of ["google-chrome", "google-chrome-stable", "chromium", "chromium-browser"]) {
    try {
      const p = execSync(`command -v ${c}`, { encoding: "utf8" }).trim();
      if (p) return p;
    } catch {
      /* miss */
    }
  }
  return null;
}

async function renderPng(htmlPath: string, pngPath: string, chrome: string): Promise<void> {
  try {
    unlinkSync(pngPath);
  } catch {
    /* ok */
  }
  const args = [
    "--headless=new",
    "--disable-gpu",
    "--hide-scrollbars",
    "--no-first-run",
    "--no-default-browser-check",
    "--no-sandbox",
    "--disable-dev-shm-usage",
    "--force-device-scale-factor=2",
    `--window-size=${WINDOW}`,
    "--virtual-time-budget=8000",
    `--screenshot=${pngPath}`,
    pathToFileURL(htmlPath).href,
  ];
  await new Promise<void>((resolveDone, reject) => {
    const proc = spawn(chrome, args, { stdio: "ignore" });
    const deadline = Date.now() + 60_000;
    let lastSize = -1;
    const tick = setInterval(() => {
      if (Date.now() > deadline) {
        clearInterval(tick);
        try {
          proc.kill("SIGTERM");
        } catch {
          /* */
        }
        if (existsSync(pngPath) && statSync(pngPath).size > 0) resolveDone();
        else reject(new Error("Chrome screenshot timed out"));
        return;
      }
      if (existsSync(pngPath)) {
        const size = statSync(pngPath).size;
        if (size > 0 && size === lastSize) {
          clearInterval(tick);
          try {
            proc.kill("SIGTERM");
          } catch {
            /* */
          }
          resolveDone();
          return;
        }
        lastSize = size;
      }
      if (proc.exitCode != null) {
        clearInterval(tick);
        if (existsSync(pngPath) && statSync(pngPath).size > 0) resolveDone();
        else reject(new Error("Chrome exited without PNG"));
      }
    }, 400);
    proc.on("error", (e) => {
      clearInterval(tick);
      reject(e);
    });
  });
}

function usage(): never {
  console.error("Usage: npx tsx render.ts <mega-assessment.md> [--name NAME] [--out-dir DIR] [--no-png]");
  process.exit(2);
}

async function main() {
  const argv = process.argv.slice(2);
  if (!argv.length) usage();
  let report = "";
  let name = "MEASURED";
  let outDir: string | null = null;
  let noPng = false;
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === "--name") name = argv[++i] ?? name;
    else if (a === "--out-dir") outDir = argv[++i] ?? null;
    else if (a === "--no-png") noPng = true;
    else if (a.startsWith("-")) usage();
    else report = a;
  }
  if (!report) usage();

  const text = readFileSync(report, "utf8");
  const traits = parseTraits(text);
  const [date, foot] = parseMeta(text);
  const dest = resolve(outDir ?? dirname(resolve(report)));
  mkdirSync(dest, { recursive: true });
  const base = basename(report).replace(/\.md$/, "");
  const stem = date ? `mega-skill-web-${date}` : `${base}-skill-web`;
  const htmlPath = join(dest, `${stem}.html`);
  const pngPath = join(dest, `${stem}.png`);

  const data = { name: name.toUpperCase(), date, foot, traits };
  const payload = JSON.stringify(data).replace(/<\//g, "<\\/");
  const html = readFileSync(TEMPLATE, "utf8").replace("/*__DATA__*/", `const DATA = ${payload};`);
  writeFileSync(htmlPath, html, "utf8");
  console.log(`HTML: ${htmlPath}`);

  if (noPng) return;
  const chrome = findChrome();
  if (!chrome) {
    console.error("Chrome/Chromium not found, PNG skipped. HTML is ready.");
    return;
  }
  await renderPng(htmlPath, pngPath, chrome);
  console.log(`PNG:  ${pngPath}`);
}

main().catch((e) => {
  console.error(e);
  process.exit(1);
});
