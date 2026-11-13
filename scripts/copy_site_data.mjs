// Copies data/processed/ into src/data/ so Observable Framework can serve it.
// src/data/ is git-ignored: data/processed/ stays the single source of truth.
import {cpSync, rmSync} from "node:fs";
import {dirname, join} from "node:path";
import {fileURLToPath} from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const from = join(root, "data", "processed");
const to = join(root, "src", "data");
rmSync(to, {recursive: true, force: true});
cpSync(from, to, {recursive: true, filter: (src) => !src.endsWith("README.md") && !src.endsWith(".gitkeep")});
console.log("copied data/processed/ to src/data/");
